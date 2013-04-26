From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH RESEND 8/9] zfcp: remove access control tables interface
Date: Fri, 26 Apr 2013 16:13:54 +0200
Message-ID: <1366985635-38270-9-git-send-email-maier@linux.vnet.ibm.com>
References: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:57478 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3DZOQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Apr 2013 10:16:03 -0400
Received: from /spool/local
	by e06smtp18.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Fri, 26 Apr 2013 15:12:12 +0100
In-Reply-To: <1366985635-38270-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Peschke <mpeschke@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

This patch removes an interface that was used to manage access control
tables within the HBA. The patch consequently removes the handling
for conditions related to those access control tables, too.

That initiator-based access control feature was only needed until the
introduction of NPIV and was withdrawn with z10 years ago.
It's time to cleanup the corresponding device driver code.

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/Makefile     |    2 
 drivers/s390/scsi/zfcp_aux.c   |   10 
 drivers/s390/scsi/zfcp_ccw.c   |    9 
 drivers/s390/scsi/zfcp_cfdc.c  |  448 -----------------------------------------
 drivers/s390/scsi/zfcp_def.h   |    4 
 drivers/s390/scsi/zfcp_erp.c   |    3 
 drivers/s390/scsi/zfcp_ext.h   |   14 -
 drivers/s390/scsi/zfcp_fsf.c   |  127 +----------
 drivers/s390/scsi/zfcp_fsf.h   |   26 --
 drivers/s390/scsi/zfcp_sysfs.c |    8 
 10 files changed, 15 insertions(+), 636 deletions(-)

--- a/drivers/s390/scsi/Makefile
+++ b/drivers/s390/scsi/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the S/390 specific device drivers
 #
 
-zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_cfdc.o zfcp_dbf.o zfcp_erp.o \
+zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_dbf.o zfcp_erp.o \
 	     zfcp_fc.o zfcp_fsf.o zfcp_qdio.o zfcp_scsi.o zfcp_sysfs.o \
 	     zfcp_unit.o
 
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -140,13 +140,6 @@ static int __init zfcp_module_init(void)
 	scsi_transport_reserve_device(zfcp_scsi_transport_template,
 				      sizeof(struct zfcp_scsi_dev));
 
-
-	retval = misc_register(&zfcp_cfdc_misc);
-	if (retval) {
-		pr_err("Registering the misc device zfcp_cfdc failed\n");
-		goto out_misc;
-	}
-
 	retval = ccw_driver_register(&zfcp_ccw_driver);
 	if (retval) {
 		pr_err("The zfcp device driver could not register with "
@@ -159,8 +152,6 @@ static int __init zfcp_module_init(void)
 	return 0;
 
 out_ccw_register:
-	misc_deregister(&zfcp_cfdc_misc);
-out_misc:
 	fc_release_transport(zfcp_scsi_transport_template);
 out_transport:
 	kmem_cache_destroy(zfcp_fc_req_cache);
@@ -175,7 +166,6 @@ module_init(zfcp_module_init);
 static void __exit zfcp_module_exit(void)
 {
 	ccw_driver_unregister(&zfcp_ccw_driver);
-	misc_deregister(&zfcp_cfdc_misc);
 	fc_release_transport(zfcp_scsi_transport_template);
 	kmem_cache_destroy(zfcp_fc_req_cache);
 	kmem_cache_destroy(zfcp_fsf_qtcb_cache);
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -72,15 +72,6 @@ static struct ccw_device_id zfcp_ccw_dev
 MODULE_DEVICE_TABLE(ccw, zfcp_ccw_device_id);
 
 /**
- * zfcp_ccw_priv_sch - check if subchannel is privileged
- * @adapter: Adapter/Subchannel to check
- */
-int zfcp_ccw_priv_sch(struct zfcp_adapter *adapter)
-{
-	return adapter->ccw_device->id.dev_model == ZFCP_MODEL_PRIV;
-}
-
-/**
  * zfcp_ccw_probe - probe function of zfcp driver
  * @cdev: pointer to belonging ccw device
  *
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ /dev/null
@@ -1,448 +0,0 @@
-/*
- * zfcp device driver
- *
- * Userspace interface for accessing the
- * Access Control Lists / Control File Data Channel;
- * handling of response code and states for ports and LUNs.
- *
- * Copyright IBM Corp. 2008, 2010
- */
-
-#define KMSG_COMPONENT "zfcp"
-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
-
-#include <linux/compat.h>
-#include <linux/slab.h>
-#include <linux/types.h>
-#include <linux/module.h>
-#include <linux/miscdevice.h>
-#include <asm/compat.h>
-#include <asm/ccwdev.h>
-#include "zfcp_def.h"
-#include "zfcp_ext.h"
-#include "zfcp_fsf.h"
-
-#define ZFCP_CFDC_CMND_DOWNLOAD_NORMAL		0x00010001
-#define ZFCP_CFDC_CMND_DOWNLOAD_FORCE		0x00010101
-#define ZFCP_CFDC_CMND_FULL_ACCESS		0x00000201
-#define ZFCP_CFDC_CMND_RESTRICTED_ACCESS	0x00000401
-#define ZFCP_CFDC_CMND_UPLOAD			0x00010002
-
-#define ZFCP_CFDC_DOWNLOAD			0x00000001
-#define ZFCP_CFDC_UPLOAD			0x00000002
-#define ZFCP_CFDC_WITH_CONTROL_FILE		0x00010000
-
-#define ZFCP_CFDC_IOC_MAGIC                     0xDD
-#define ZFCP_CFDC_IOC \
-	_IOWR(ZFCP_CFDC_IOC_MAGIC, 0, struct zfcp_cfdc_data)
-
-/**
- * struct zfcp_cfdc_data - data for ioctl cfdc interface
- * @signature: request signature
- * @devno: FCP adapter device number
- * @command: command code
- * @fsf_status: returns status of FSF command to userspace
- * @fsf_status_qual: returned to userspace
- * @payloads: access conflicts list
- * @control_file: access control table
- */
-struct zfcp_cfdc_data {
-	u32 signature;
-	u32 devno;
-	u32 command;
-	u32 fsf_status;
-	u8  fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
-	u8  payloads[256];
-	u8  control_file[0];
-};
-
-static int zfcp_cfdc_copy_from_user(struct scatterlist *sg,
-				    void __user *user_buffer)
-{
-	unsigned int length;
-	unsigned int size = ZFCP_CFDC_MAX_SIZE;
-
-	while (size) {
-		length = min((unsigned int)size, sg->length);
-		if (copy_from_user(sg_virt(sg++), user_buffer, length))
-			return -EFAULT;
-		user_buffer += length;
-		size -= length;
-	}
-	return 0;
-}
-
-static int zfcp_cfdc_copy_to_user(void __user  *user_buffer,
-				  struct scatterlist *sg)
-{
-	unsigned int length;
-	unsigned int size = ZFCP_CFDC_MAX_SIZE;
-
-	while (size) {
-		length = min((unsigned int) size, sg->length);
-		if (copy_to_user(user_buffer, sg_virt(sg++), length))
-			return -EFAULT;
-		user_buffer += length;
-		size -= length;
-	}
-	return 0;
-}
-
-static struct zfcp_adapter *zfcp_cfdc_get_adapter(u32 devno)
-{
-	char busid[9];
-	struct ccw_device *cdev;
-	struct zfcp_adapter *adapter;
-
-	snprintf(busid, sizeof(busid), "0.0.%04x", devno);
-	cdev = get_ccwdev_by_busid(&zfcp_ccw_driver, busid);
-	if (!cdev)
-		return NULL;
-
-	adapter = zfcp_ccw_adapter_by_cdev(cdev);
-
-	put_device(&cdev->dev);
-	return adapter;
-}
-
-static int zfcp_cfdc_set_fsf(struct zfcp_fsf_cfdc *fsf_cfdc, int command)
-{
-	switch (command) {
-	case ZFCP_CFDC_CMND_DOWNLOAD_NORMAL:
-		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		fsf_cfdc->option = FSF_CFDC_OPTION_NORMAL_MODE;
-		break;
-	case ZFCP_CFDC_CMND_DOWNLOAD_FORCE:
-		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		fsf_cfdc->option = FSF_CFDC_OPTION_FORCE;
-		break;
-	case ZFCP_CFDC_CMND_FULL_ACCESS:
-		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		fsf_cfdc->option = FSF_CFDC_OPTION_FULL_ACCESS;
-		break;
-	case ZFCP_CFDC_CMND_RESTRICTED_ACCESS:
-		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		fsf_cfdc->option = FSF_CFDC_OPTION_RESTRICTED_ACCESS;
-		break;
-	case ZFCP_CFDC_CMND_UPLOAD:
-		fsf_cfdc->command = FSF_QTCB_UPLOAD_CONTROL_FILE;
-		fsf_cfdc->option = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int zfcp_cfdc_sg_setup(int command, struct scatterlist *sg,
-			      u8 __user *control_file)
-{
-	int retval;
-	retval = zfcp_sg_setup_table(sg, ZFCP_CFDC_PAGES);
-	if (retval)
-		return retval;
-
-	sg[ZFCP_CFDC_PAGES - 1].length = ZFCP_CFDC_MAX_SIZE % PAGE_SIZE;
-
-	if (command & ZFCP_CFDC_WITH_CONTROL_FILE &&
-	    command & ZFCP_CFDC_DOWNLOAD) {
-		retval = zfcp_cfdc_copy_from_user(sg, control_file);
-		if (retval) {
-			zfcp_sg_free_table(sg, ZFCP_CFDC_PAGES);
-			return -EFAULT;
-		}
-	}
-
-	return 0;
-}
-
-static void zfcp_cfdc_req_to_sense(struct zfcp_cfdc_data *data,
-				   struct zfcp_fsf_req *req)
-{
-	data->fsf_status = req->qtcb->header.fsf_status;
-	memcpy(&data->fsf_status_qual, &req->qtcb->header.fsf_status_qual,
-	       sizeof(union fsf_status_qual));
-	memcpy(&data->payloads, &req->qtcb->bottom.support.els,
-	       sizeof(req->qtcb->bottom.support.els));
-}
-
-static long zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
-				unsigned long arg)
-{
-	struct zfcp_cfdc_data *data;
-	struct zfcp_cfdc_data __user *data_user;
-	struct zfcp_adapter *adapter;
-	struct zfcp_fsf_req *req;
-	struct zfcp_fsf_cfdc *fsf_cfdc;
-	int retval;
-
-	if (command != ZFCP_CFDC_IOC)
-		return -ENOTTY;
-
-	if (is_compat_task())
-		data_user = compat_ptr(arg);
-	else
-		data_user = (void __user *)arg;
-
-	if (!data_user)
-		return -EINVAL;
-
-	fsf_cfdc = kmalloc(sizeof(struct zfcp_fsf_cfdc), GFP_KERNEL);
-	if (!fsf_cfdc)
-		return -ENOMEM;
-
-	data = memdup_user(data_user, sizeof(*data_user));
-	if (IS_ERR(data)) {
-		retval = PTR_ERR(data);
-		goto no_mem_sense;
-	}
-
-	if (data->signature != 0xCFDCACDF) {
-		retval = -EINVAL;
-		goto free_buffer;
-	}
-
-	retval = zfcp_cfdc_set_fsf(fsf_cfdc, data->command);
-
-	adapter = zfcp_cfdc_get_adapter(data->devno);
-	if (!adapter) {
-		retval = -ENXIO;
-		goto free_buffer;
-	}
-
-	retval = zfcp_cfdc_sg_setup(data->command, fsf_cfdc->sg,
-				    data_user->control_file);
-	if (retval)
-		goto adapter_put;
-	req = zfcp_fsf_control_file(adapter, fsf_cfdc);
-	if (IS_ERR(req)) {
-		retval = PTR_ERR(req);
-		goto free_sg;
-	}
-
-	if (req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		retval = -ENXIO;
-		goto free_fsf;
-	}
-
-	zfcp_cfdc_req_to_sense(data, req);
-	retval = copy_to_user(data_user, data, sizeof(*data_user));
-	if (retval) {
-		retval = -EFAULT;
-		goto free_fsf;
-	}
-
-	if (data->command & ZFCP_CFDC_UPLOAD)
-		retval = zfcp_cfdc_copy_to_user(&data_user->control_file,
-						fsf_cfdc->sg);
-
- free_fsf:
-	zfcp_fsf_req_free(req);
- free_sg:
-	zfcp_sg_free_table(fsf_cfdc->sg, ZFCP_CFDC_PAGES);
- adapter_put:
-	zfcp_ccw_adapter_put(adapter);
- free_buffer:
-	kfree(data);
- no_mem_sense:
-	kfree(fsf_cfdc);
-	return retval;
-}
-
-static const struct file_operations zfcp_cfdc_fops = {
-	.owner = THIS_MODULE,
-	.open = nonseekable_open,
-	.unlocked_ioctl = zfcp_cfdc_dev_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = zfcp_cfdc_dev_ioctl,
-#endif
-	.llseek = no_llseek,
-};
-
-struct miscdevice zfcp_cfdc_misc = {
-	.minor = MISC_DYNAMIC_MINOR,
-	.name = "zfcp_cfdc",
-	.fops = &zfcp_cfdc_fops,
-};
-
-/**
- * zfcp_cfdc_adapter_access_changed - Process change in adapter ACT
- * @adapter: Adapter where the Access Control Table (ACT) changed
- *
- * After a change in the adapter ACT, check if access to any
- * previously denied resources is now possible.
- */
-void zfcp_cfdc_adapter_access_changed(struct zfcp_adapter *adapter)
-{
-	unsigned long flags;
-	struct zfcp_port *port;
-	struct scsi_device *sdev;
-	struct zfcp_scsi_dev *zfcp_sdev;
-	int status;
-
-	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
-		return;
-
-	read_lock_irqsave(&adapter->port_list_lock, flags);
-	list_for_each_entry(port, &adapter->port_list, list) {
-		status = atomic_read(&port->status);
-		if ((status & ZFCP_STATUS_COMMON_ACCESS_DENIED) ||
-		    (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
-			zfcp_erp_port_reopen(port,
-					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "cfaac_1");
-	}
-	read_unlock_irqrestore(&adapter->port_list_lock, flags);
-
-	shost_for_each_device(sdev, adapter->scsi_host) {
-		zfcp_sdev = sdev_to_zfcp(sdev);
-		status = atomic_read(&zfcp_sdev->status);
-		if ((status & ZFCP_STATUS_COMMON_ACCESS_DENIED) ||
-		    (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
-			zfcp_erp_lun_reopen(sdev,
-					    ZFCP_STATUS_COMMON_ERP_FAILED,
-					    "cfaac_2");
-	}
-}
-
-static void zfcp_act_eval_err(struct zfcp_adapter *adapter, u32 table)
-{
-	u16 subtable = table >> 16;
-	u16 rule = table & 0xffff;
-	const char *act_type[] = { "unknown", "OS", "WWPN", "DID", "LUN" };
-
-	if (subtable && subtable < ARRAY_SIZE(act_type))
-		dev_warn(&adapter->ccw_device->dev,
-			 "Access denied according to ACT rule type %s, "
-			 "rule %d\n", act_type[subtable], rule);
-}
-
-/**
- * zfcp_cfdc_port_denied - Process "access denied" for port
- * @port: The port where the access has been denied
- * @qual: The FSF status qualifier for the access denied FSF status
- */
-void zfcp_cfdc_port_denied(struct zfcp_port *port,
-			   union fsf_status_qual *qual)
-{
-	dev_warn(&port->adapter->ccw_device->dev,
-		 "Access denied to port 0x%016Lx\n",
-		 (unsigned long long)port->wwpn);
-
-	zfcp_act_eval_err(port->adapter, qual->halfword[0]);
-	zfcp_act_eval_err(port->adapter, qual->halfword[1]);
-	zfcp_erp_set_port_status(port,
-				 ZFCP_STATUS_COMMON_ERP_FAILED |
-				 ZFCP_STATUS_COMMON_ACCESS_DENIED);
-}
-
-/**
- * zfcp_cfdc_lun_denied - Process "access denied" for LUN
- * @sdev: The SCSI device / LUN where the access has been denied
- * @qual: The FSF status qualifier for the access denied FSF status
- */
-void zfcp_cfdc_lun_denied(struct scsi_device *sdev,
-			  union fsf_status_qual *qual)
-{
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-
-	dev_warn(&zfcp_sdev->port->adapter->ccw_device->dev,
-		 "Access denied to LUN 0x%016Lx on port 0x%016Lx\n",
-		 zfcp_scsi_dev_lun(sdev),
-		 (unsigned long long)zfcp_sdev->port->wwpn);
-	zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->halfword[0]);
-	zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->halfword[1]);
-	zfcp_erp_set_lun_status(sdev,
-				ZFCP_STATUS_COMMON_ERP_FAILED |
-				ZFCP_STATUS_COMMON_ACCESS_DENIED);
-
-	atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
-	atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
-}
-
-/**
- * zfcp_cfdc_lun_shrng_vltn - Evaluate LUN sharing violation status
- * @sdev: The LUN / SCSI device where sharing violation occurred
- * @qual: The FSF status qualifier from the LUN sharing violation
- */
-void zfcp_cfdc_lun_shrng_vltn(struct scsi_device *sdev,
-			      union fsf_status_qual *qual)
-{
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-
-	if (qual->word[0])
-		dev_warn(&zfcp_sdev->port->adapter->ccw_device->dev,
-			 "LUN 0x%Lx on port 0x%Lx is already in "
-			 "use by CSS%d, MIF Image ID %x\n",
-			 zfcp_scsi_dev_lun(sdev),
-			 (unsigned long long)zfcp_sdev->port->wwpn,
-			 qual->fsf_queue_designator.cssid,
-			 qual->fsf_queue_designator.hla);
-	else
-		zfcp_act_eval_err(zfcp_sdev->port->adapter, qual->word[2]);
-
-	zfcp_erp_set_lun_status(sdev,
-				ZFCP_STATUS_COMMON_ERP_FAILED |
-				ZFCP_STATUS_COMMON_ACCESS_DENIED);
-	atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
-	atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
-}
-
-/**
- * zfcp_cfdc_open_lun_eval - Eval access ctrl. status for successful "open lun"
- * @sdev: The SCSI device / LUN where to evaluate the status
- * @bottom: The qtcb bottom with the status from the "open lun"
- *
- * Returns: 0 if LUN is usable, -EACCES if the access control table
- *          reports an unsupported configuration.
- */
-int zfcp_cfdc_open_lun_eval(struct scsi_device *sdev,
-			    struct fsf_qtcb_bottom_support *bottom)
-{
-	int shared, rw;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
-
-	if ((adapter->connection_features & FSF_FEATURE_NPIV_MODE) ||
-	    !(adapter->adapter_features & FSF_FEATURE_LUN_SHARING) ||
-	    zfcp_ccw_priv_sch(adapter))
-		return 0;
-
-	shared = !(bottom->lun_access_info & FSF_UNIT_ACCESS_EXCLUSIVE);
-	rw = (bottom->lun_access_info & FSF_UNIT_ACCESS_OUTBOUND_TRANSFER);
-
-	if (shared)
-		atomic_set_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
-
-	if (!rw) {
-		atomic_set_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
-		dev_info(&adapter->ccw_device->dev, "SCSI device at LUN "
-			 "0x%016Lx on port 0x%016Lx opened read-only\n",
-			 zfcp_scsi_dev_lun(sdev),
-			 (unsigned long long)zfcp_sdev->port->wwpn);
-	}
-
-	if (!shared && !rw) {
-		dev_err(&adapter->ccw_device->dev, "Exclusive read-only access "
-			"not supported (LUN 0x%016Lx, port 0x%016Lx)\n",
-			zfcp_scsi_dev_lun(sdev),
-			(unsigned long long)zfcp_sdev->port->wwpn);
-		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
-		zfcp_erp_lun_shutdown(sdev, 0, "fsouh_6");
-		return -EACCES;
-	}
-
-	if (shared && rw) {
-		dev_err(&adapter->ccw_device->dev,
-			"Shared read-write access not supported "
-			"(LUN 0x%016Lx, port 0x%016Lx)\n",
-			zfcp_scsi_dev_lun(sdev),
-			(unsigned long long)zfcp_sdev->port->wwpn);
-		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
-		zfcp_erp_lun_shutdown(sdev, 0, "fsosh_8");
-		return -EACCES;
-	}
-
-	return 0;
-}
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -86,10 +86,6 @@ struct zfcp_reqlist;
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
 #define ZFCP_STATUS_PORT_LINK_TEST		0x00000002
 
-/* logical unit status */
-#define ZFCP_STATUS_LUN_SHARED			0x00000004
-#define ZFCP_STATUS_LUN_READONLY		0x00000008
-
 /* FSF request status (this does not have a common part) */
 #define ZFCP_STATUS_FSFREQ_ERROR		0x00000008
 #define ZFCP_STATUS_FSFREQ_CLEANUP		0x00000010
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -950,8 +950,7 @@ static void zfcp_erp_lun_strategy_clears
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
-	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_LUN_SHARED | ZFCP_STATUS_LUN_READONLY,
+	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
 			  &zfcp_sdev->status);
 }
 
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -25,22 +25,10 @@ extern void zfcp_adapter_release(struct
 extern void zfcp_adapter_unregister(struct zfcp_adapter *);
 
 /* zfcp_ccw.c */
-extern int zfcp_ccw_priv_sch(struct zfcp_adapter *);
 extern struct ccw_driver zfcp_ccw_driver;
 extern struct zfcp_adapter *zfcp_ccw_adapter_by_cdev(struct ccw_device *);
 extern void zfcp_ccw_adapter_put(struct zfcp_adapter *);
 
-/* zfcp_cfdc.c */
-extern struct miscdevice zfcp_cfdc_misc;
-extern void zfcp_cfdc_port_denied(struct zfcp_port *, union fsf_status_qual *);
-extern void zfcp_cfdc_lun_denied(struct scsi_device *, union fsf_status_qual *);
-extern void zfcp_cfdc_lun_shrng_vltn(struct scsi_device *,
-				     union fsf_status_qual *);
-extern int zfcp_cfdc_open_lun_eval(struct scsi_device *,
-				   struct fsf_qtcb_bottom_support *);
-extern void zfcp_cfdc_adapter_access_changed(struct zfcp_adapter *);
-
-
 /* zfcp_dbf.c */
 extern int zfcp_dbf_adapter_register(struct zfcp_adapter *);
 extern void zfcp_dbf_adapter_unregister(struct zfcp_adapter *);
@@ -115,8 +103,6 @@ extern int zfcp_fsf_exchange_config_data
 extern int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *);
 extern int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *,
 					    struct fsf_qtcb_bottom_port *);
-extern struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *,
-						  struct zfcp_fsf_cfdc *);
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int zfcp_fsf_status_read(struct zfcp_qdio *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -254,14 +254,9 @@ static void zfcp_fsf_status_read_handler
 
 		break;
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
-		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_ACT_UPDATED)
-			zfcp_cfdc_adapter_access_changed(adapter);
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_INCOMING_ELS)
 			zfcp_fc_conditional_port_scan(adapter);
 		break;
-	case FSF_STATUS_READ_CFDC_UPDATED:
-		zfcp_cfdc_adapter_access_changed(adapter);
-		break;
 	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
 		adapter->adapter_features = sr_buf->payload.word[0];
 		break;
@@ -935,8 +930,6 @@ static void zfcp_fsf_send_ct_handler(str
 			break;
                 }
                 break;
-	case FSF_ACCESS_DENIED:
-		break;
         case FSF_PORT_BOXED:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1090,7 +1083,6 @@ out:
 static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_fsf_ct_els *send_els = req->data;
-	struct zfcp_port *port = send_els->port;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
 	send_els->status = -EINVAL;
@@ -1120,12 +1112,6 @@ static void zfcp_fsf_send_els_handler(st
 	case FSF_REQUEST_SIZE_TOO_LARGE:
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
 		break;
-	case FSF_ACCESS_DENIED:
-		if (port) {
-			zfcp_cfdc_port_denied(port, &header->fsf_status_qual);
-			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		}
-		break;
 	case FSF_SBAL_MISMATCH:
 		/* should never occur, avoided in zfcp_fsf_send_els */
 		/* fall through */
@@ -1213,8 +1199,6 @@ int zfcp_fsf_exchange_config_data(struct
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->qtcb->bottom.config.feature_selection =
-			FSF_FEATURE_CFDC |
-			FSF_FEATURE_LUN_SHARING |
 			FSF_FEATURE_NOTIFICATION_LOST |
 			FSF_FEATURE_UPDATE_ALERT;
 	req->erp_action = erp_action;
@@ -1254,8 +1238,6 @@ int zfcp_fsf_exchange_config_data_sync(s
 	req->handler = zfcp_fsf_exchange_config_data_handler;
 
 	req->qtcb->bottom.config.feature_selection =
-			FSF_FEATURE_CFDC |
-			FSF_FEATURE_LUN_SHARING |
 			FSF_FEATURE_NOTIFICATION_LOST |
 			FSF_FEATURE_UPDATE_ALERT;
 
@@ -1382,10 +1364,6 @@ static void zfcp_fsf_open_port_handler(s
 	switch (header->fsf_status) {
 	case FSF_PORT_ALREADY_OPEN:
 		break;
-	case FSF_ACCESS_DENIED:
-		zfcp_cfdc_port_denied(port, &header->fsf_status_qual);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
 		dev_warn(&req->adapter->ccw_device->dev,
 			 "Not enough FCP adapter resources to open "
@@ -1568,8 +1546,6 @@ static void zfcp_fsf_open_wka_port_handl
 		/* fall through */
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		/* fall through */
-	case FSF_ACCESS_DENIED:
 		wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 		break;
 	case FSF_GOOD:
@@ -1689,9 +1665,6 @@ static void zfcp_fsf_close_physical_port
 		zfcp_erp_adapter_reopen(port->adapter, 0, "fscpph1");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-	case FSF_ACCESS_DENIED:
-		zfcp_cfdc_port_denied(port, &header->fsf_status_qual);
-		break;
 	case FSF_PORT_BOXED:
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
@@ -1777,7 +1750,7 @@ static void zfcp_fsf_open_lun_handler(st
 	struct scsi_device *sdev = req->data;
 	struct zfcp_scsi_dev *zfcp_sdev;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
-	struct fsf_qtcb_bottom_support *bottom = &req->qtcb->bottom.support;
+	union fsf_status_qual *qual = &header->fsf_status_qual;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
@@ -1785,9 +1758,7 @@ static void zfcp_fsf_open_lun_handler(st
 	zfcp_sdev = sdev_to_zfcp(sdev);
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_COMMON_ACCESS_BOXED |
-			  ZFCP_STATUS_LUN_SHARED |
-			  ZFCP_STATUS_LUN_READONLY,
+			  ZFCP_STATUS_COMMON_ACCESS_BOXED,
 			  &zfcp_sdev->status);
 
 	switch (header->fsf_status) {
@@ -1797,10 +1768,6 @@ static void zfcp_fsf_open_lun_handler(st
 		/* fall through */
 	case FSF_LUN_ALREADY_OPEN:
 		break;
-	case FSF_ACCESS_DENIED:
-		zfcp_cfdc_lun_denied(sdev, &header->fsf_status_qual);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_set_port_status(zfcp_sdev->port,
 					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
@@ -1809,7 +1776,17 @@ static void zfcp_fsf_open_lun_handler(st
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_SHARING_VIOLATION:
-		zfcp_cfdc_lun_shrng_vltn(sdev, &header->fsf_status_qual);
+		if (qual->word[0])
+			dev_warn(&zfcp_sdev->port->adapter->ccw_device->dev,
+				 "LUN 0x%Lx on port 0x%Lx is already in "
+				 "use by CSS%d, MIF Image ID %x\n",
+				 zfcp_scsi_dev_lun(sdev),
+				 (unsigned long long)zfcp_sdev->port->wwpn,
+				 qual->fsf_queue_designator.cssid,
+				 qual->fsf_queue_designator.hla);
+		zfcp_erp_set_lun_status(sdev,
+					ZFCP_STATUS_COMMON_ERP_FAILED |
+					ZFCP_STATUS_COMMON_ACCESS_DENIED);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED:
@@ -1837,7 +1814,6 @@ static void zfcp_fsf_open_lun_handler(st
 	case FSF_GOOD:
 		zfcp_sdev->lun_handle = header->lun_handle;
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
-		zfcp_cfdc_open_lun_eval(sdev, bottom);
 		break;
 	}
 }
@@ -2065,10 +2041,6 @@ static void zfcp_fsf_fcp_handler_common(
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
 		zfcp_fsf_class_not_supp(req);
 		break;
-	case FSF_ACCESS_DENIED:
-		zfcp_cfdc_lun_denied(sdev, &header->fsf_status_qual);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
 	case FSF_DIRECTION_INDICATOR_NOT_VALID:
 		dev_err(&req->adapter->ccw_device->dev,
 			"Incorrect direction %d, LUN 0x%016Lx on port "
@@ -2369,79 +2341,6 @@ out:
 	return req;
 }
 
-static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *req)
-{
-}
-
-/**
- * zfcp_fsf_control_file - control file upload/download
- * @adapter: pointer to struct zfcp_adapter
- * @fsf_cfdc: pointer to struct zfcp_fsf_cfdc
- * Returns: on success pointer to struct zfcp_fsf_req, NULL otherwise
- */
-struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
-					   struct zfcp_fsf_cfdc *fsf_cfdc)
-{
-	struct zfcp_qdio *qdio = adapter->qdio;
-	struct zfcp_fsf_req *req = NULL;
-	struct fsf_qtcb_bottom_support *bottom;
-	int retval = -EIO;
-	u8 direction;
-
-	if (!(adapter->adapter_features & FSF_FEATURE_CFDC))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	switch (fsf_cfdc->command) {
-	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
-		direction = SBAL_SFLAGS0_TYPE_WRITE;
-		break;
-	case FSF_QTCB_UPLOAD_CONTROL_FILE:
-		direction = SBAL_SFLAGS0_TYPE_READ;
-		break;
-	default:
-		return ERR_PTR(-EINVAL);
-	}
-
-	spin_lock_irq(&qdio->req_q_lock);
-	if (zfcp_qdio_sbal_get(qdio))
-		goto out;
-
-	req = zfcp_fsf_req_create(qdio, fsf_cfdc->command, direction, NULL);
-	if (IS_ERR(req)) {
-		retval = -EPERM;
-		goto out;
-	}
-
-	req->handler = zfcp_fsf_control_file_handler;
-
-	bottom = &req->qtcb->bottom.support;
-	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
-	bottom->option = fsf_cfdc->option;
-
-	retval = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, fsf_cfdc->sg);
-
-	if (retval ||
-		(zfcp_qdio_real_bytes(fsf_cfdc->sg) != ZFCP_CFDC_MAX_SIZE)) {
-		zfcp_fsf_req_free(req);
-		retval = -EIO;
-		goto out;
-	}
-	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
-	if (zfcp_adapter_multi_buffer_active(adapter))
-		zfcp_qdio_set_scount(qdio, &req->qdio_req);
-
-	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
-	retval = zfcp_fsf_req_send(req);
-out:
-	spin_unlock_irq(&qdio->req_q_lock);
-
-	if (!retval) {
-		wait_for_completion(&req->completion);
-		return req;
-	}
-	return ERR_PTR(retval);
-}
-
 /**
  * zfcp_fsf_reqid_check - validate req_id contained in SBAL returned by QDIO
  * @adapter: pointer to struct zfcp_adapter
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -36,13 +36,6 @@
 #define FSF_CONFIG_COMMAND			0x00000003
 #define FSF_PORT_COMMAND			0x00000004
 
-/* FSF control file upload/download operations' subtype and options */
-#define FSF_CFDC_OPERATION_SUBTYPE		0x00020001
-#define FSF_CFDC_OPTION_NORMAL_MODE		0x00000000
-#define FSF_CFDC_OPTION_FORCE			0x00000001
-#define FSF_CFDC_OPTION_FULL_ACCESS		0x00000002
-#define FSF_CFDC_OPTION_RESTRICTED_ACCESS	0x00000004
-
 /* FSF protocol states */
 #define FSF_PROT_GOOD				0x00000001
 #define FSF_PROT_QTCB_VERSION_ERROR		0x00000010
@@ -64,7 +57,6 @@
 #define FSF_HANDLE_MISMATCH			0x00000005
 #define FSF_SERVICE_CLASS_NOT_SUPPORTED		0x00000006
 #define FSF_FCPLUN_NOT_VALID			0x00000009
-#define FSF_ACCESS_DENIED			0x00000010
 #define FSF_LUN_SHARING_VIOLATION               0x00000012
 #define FSF_FCP_COMMAND_DOES_NOT_EXIST		0x00000022
 #define FSF_DIRECTION_INDICATOR_NOT_VALID	0x00000030
@@ -130,7 +122,6 @@
 #define FSF_STATUS_READ_LINK_DOWN		0x00000005
 #define FSF_STATUS_READ_LINK_UP          	0x00000006
 #define FSF_STATUS_READ_NOTIFICATION_LOST	0x00000009
-#define FSF_STATUS_READ_CFDC_UPDATED		0x0000000A
 #define FSF_STATUS_READ_FEATURE_UPDATE_ALERT	0x0000000C
 
 /* status subtypes for link down */
@@ -140,7 +131,6 @@
 
 /* status subtypes for unsolicited status notification lost */
 #define FSF_STATUS_READ_SUB_INCOMING_ELS	0x00000001
-#define FSF_STATUS_READ_SUB_ACT_UPDATED		0x00000020
 
 /* topologie that is detected by the adapter */
 #define FSF_TOPO_P2P				0x00000001
@@ -166,8 +156,6 @@
 #define FSF_QTCB_LOG_SIZE			1024
 
 /* channel features */
-#define FSF_FEATURE_CFDC			0x00000002
-#define FSF_FEATURE_LUN_SHARING			0x00000004
 #define FSF_FEATURE_NOTIFICATION_LOST		0x00000008
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
 #define FSF_FEATURE_ELS_CT_CHAINED_SBALS	0x00000020
@@ -182,20 +170,6 @@
 /* option */
 #define FSF_OPEN_LUN_SUPPRESS_BOXING		0x00000001
 
-/* open LUN access flags*/
-#define FSF_UNIT_ACCESS_EXCLUSIVE		0x02000000
-#define FSF_UNIT_ACCESS_OUTBOUND_TRANSFER	0x10000000
-
-/* FSF interface for CFDC */
-#define ZFCP_CFDC_MAX_SIZE		127 * 1024
-#define ZFCP_CFDC_PAGES 		PFN_UP(ZFCP_CFDC_MAX_SIZE)
-
-struct zfcp_fsf_cfdc {
-	struct scatterlist sg[ZFCP_CFDC_PAGES];
-	u32 command;
-	u32 option;
-};
-
 struct fsf_queue_designator {
 	u8  cssid;
 	u8  chpid;
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -75,12 +75,6 @@ ZFCP_DEFINE_ATTR(zfcp_unit, unit, in_rec
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_denied, "%d\n",
 		 (zfcp_unit_sdev_status(unit) &
 		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
-ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_shared, "%d\n",
-		 (zfcp_unit_sdev_status(unit) &
-		  ZFCP_STATUS_LUN_SHARED) != 0);
-ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_readonly, "%d\n",
-		 (zfcp_unit_sdev_status(unit) &
-		  ZFCP_STATUS_LUN_READONLY) != 0);
 
 static ssize_t zfcp_sysfs_port_failed_show(struct device *dev,
 					   struct device_attribute *attr,
@@ -353,8 +347,6 @@ static struct attribute *zfcp_unit_attrs
 	&dev_attr_unit_in_recovery.attr,
 	&dev_attr_unit_status.attr,
 	&dev_attr_unit_access_denied.attr,
-	&dev_attr_unit_access_shared.attr,
-	&dev_attr_unit_access_readonly.attr,
 	NULL
 };
 static struct attribute_group zfcp_unit_attr_group = {

