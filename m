From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/8] zfcp: Move CFDC code to new file.
Date: Tue, 10 Jun 2008 18:20:55 +0200
Message-ID: <20080610162513.846166000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30377 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYFJQZT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:19 -0400
Content-Disposition: inline; filename=zfcp-move-cfdc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

zfcp implements a device file to allow Linux guests changing the
Access Control Tables stored in the adapter. The code for the device
file has nothing to do with the other parts of the driver, so move it
to a new file and cleanup the code while doing so.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/Makefile    |    2 
 drivers/s390/scsi/zfcp_aux.c  |  425 ++----------------------------------------
 drivers/s390/scsi/zfcp_cfdc.c |  259 +++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h  |   43 ----
 drivers/s390/scsi/zfcp_ext.h  |    8 
 drivers/s390/scsi/zfcp_fsf.c  |  244 ++----------------------
 drivers/s390/scsi/zfcp_fsf.h  |   12 +
 7 files changed, 330 insertions(+), 663 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-09 17:56:34.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-10 15:12:24.000000000 +0200
@@ -33,6 +33,7 @@
  *            Ralph Wuerthner
  */
 
+#include <linux/miscdevice.h>
 #include "zfcp_ext.h"
 
 /* accumulated log level (module parameter) */
@@ -43,33 +44,6 @@ static char *device;
 /* written against the module interface */
 static int __init  zfcp_module_init(void);
 
-/* miscellaneous */
-static int zfcp_sg_list_alloc(struct zfcp_sg_list *, size_t);
-static void zfcp_sg_list_free(struct zfcp_sg_list *);
-static int zfcp_sg_list_copy_from_user(struct zfcp_sg_list *,
-				       void __user *, size_t);
-static int zfcp_sg_list_copy_to_user(void __user *,
-				     struct zfcp_sg_list *, size_t);
-static long zfcp_cfdc_dev_ioctl(struct file *, unsigned int, unsigned long);
-
-#define ZFCP_CFDC_IOC_MAGIC                     0xDD
-#define ZFCP_CFDC_IOC \
-	_IOWR(ZFCP_CFDC_IOC_MAGIC, 0, struct zfcp_cfdc_sense_data)
-
-
-static const struct file_operations zfcp_cfdc_fops = {
-	.unlocked_ioctl = zfcp_cfdc_dev_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = zfcp_cfdc_dev_ioctl
-#endif
-};
-
-static struct miscdevice zfcp_cfdc_misc = {
-	.minor = ZFCP_CFDC_DEV_MINOR,
-	.name = ZFCP_CFDC_DEV_NAME,
-	.fops = &zfcp_cfdc_fops
-};
-
 /*********************** KERNEL/MODULE PARAMETERS  ***************************/
 
 /* declare driver module init/cleanup functions */
@@ -294,9 +268,6 @@ zfcp_module_init(void)
 		goto out_misc;
 	}
 
-	ZFCP_LOG_TRACE("major/minor for zfcp_cfdc: %d/%d\n",
-		       ZFCP_CFDC_DEV_MAJOR, zfcp_cfdc_misc.minor);
-
 	/* Initialise proc semaphores */
 	sema_init(&zfcp_data.config_sema, 1);
 
@@ -329,372 +300,6 @@ zfcp_module_init(void)
 	return retval;
 }
 
-/*
- * function:    zfcp_cfdc_dev_ioctl
- *
- * purpose:     Handle control file upload/download transaction via IOCTL
- *		interface
- *
- * returns:     0           - Operation completed successfuly
- *              -ENOTTY     - Unknown IOCTL command
- *              -EINVAL     - Invalid sense data record
- *              -ENXIO      - The FCP adapter is not available
- *              -EOPNOTSUPP - The FCP adapter does not have CFDC support
- *              -ENOMEM     - Insufficient memory
- *              -EFAULT     - User space memory I/O operation fault
- *              -EPERM      - Cannot create or queue FSF request or create SBALs
- *              -ERESTARTSYS- Received signal (is mapped to EAGAIN by VFS)
- */
-static long
-zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
-		    unsigned long buffer)
-{
-	struct zfcp_cfdc_sense_data *sense_data, __user *sense_data_user;
-	struct zfcp_adapter *adapter = NULL;
-	struct zfcp_fsf_req *fsf_req = NULL;
-	struct zfcp_sg_list *sg_list = NULL;
-	u32 fsf_command, option;
-	char *bus_id = NULL;
-	int retval = 0;
-
-	sense_data = kmalloc(sizeof(struct zfcp_cfdc_sense_data), GFP_KERNEL);
-	if (sense_data == NULL) {
-		retval = -ENOMEM;
-		goto out;
-	}
-
-	sg_list = kzalloc(sizeof(struct zfcp_sg_list), GFP_KERNEL);
-	if (sg_list == NULL) {
-		retval = -ENOMEM;
-		goto out;
-	}
-
-	if (command != ZFCP_CFDC_IOC) {
-		ZFCP_LOG_INFO("IOC request code 0x%x invalid\n", command);
-		retval = -ENOTTY;
-		goto out;
-	}
-
-	if ((sense_data_user = (void __user *) buffer) == NULL) {
-		ZFCP_LOG_INFO("sense data record is required\n");
-		retval = -EINVAL;
-		goto out;
-	}
-
-	retval = copy_from_user(sense_data, sense_data_user,
-				sizeof(struct zfcp_cfdc_sense_data));
-	if (retval) {
-		retval = -EFAULT;
-		goto out;
-	}
-
-	if (sense_data->signature != ZFCP_CFDC_SIGNATURE) {
-		ZFCP_LOG_INFO("invalid sense data request signature 0x%08x\n",
-			      ZFCP_CFDC_SIGNATURE);
-		retval = -EINVAL;
-		goto out;
-	}
-
-	switch (sense_data->command) {
-
-	case ZFCP_CFDC_CMND_DOWNLOAD_NORMAL:
-		fsf_command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		option = FSF_CFDC_OPTION_NORMAL_MODE;
-		break;
-
-	case ZFCP_CFDC_CMND_DOWNLOAD_FORCE:
-		fsf_command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		option = FSF_CFDC_OPTION_FORCE;
-		break;
-
-	case ZFCP_CFDC_CMND_FULL_ACCESS:
-		fsf_command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		option = FSF_CFDC_OPTION_FULL_ACCESS;
-		break;
-
-	case ZFCP_CFDC_CMND_RESTRICTED_ACCESS:
-		fsf_command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
-		option = FSF_CFDC_OPTION_RESTRICTED_ACCESS;
-		break;
-
-	case ZFCP_CFDC_CMND_UPLOAD:
-		fsf_command = FSF_QTCB_UPLOAD_CONTROL_FILE;
-		option = 0;
-		break;
-
-	default:
-		ZFCP_LOG_INFO("invalid command code 0x%08x\n",
-			      sense_data->command);
-		retval = -EINVAL;
-		goto out;
-	}
-
-	bus_id = kmalloc(BUS_ID_SIZE, GFP_KERNEL);
-	if (bus_id == NULL) {
-		retval = -ENOMEM;
-		goto out;
-	}
-	snprintf(bus_id, BUS_ID_SIZE, "%d.%d.%04x",
-		(sense_data->devno >> 24),
-		(sense_data->devno >> 16) & 0xFF,
-		(sense_data->devno & 0xFFFF));
-
-	read_lock_irq(&zfcp_data.config_lock);
-	adapter = zfcp_get_adapter_by_busid(bus_id);
-	if (adapter)
-		zfcp_adapter_get(adapter);
-	read_unlock_irq(&zfcp_data.config_lock);
-
-	kfree(bus_id);
-
-	if (adapter == NULL) {
-		ZFCP_LOG_INFO("invalid adapter\n");
-		retval = -ENXIO;
-		goto out;
-	}
-
-	if (sense_data->command & ZFCP_CFDC_WITH_CONTROL_FILE) {
-		retval = zfcp_sg_list_alloc(sg_list,
-					    ZFCP_CFDC_MAX_CONTROL_FILE_SIZE);
-		if (retval) {
-			retval = -ENOMEM;
-			goto out;
-		}
-	}
-
-	if ((sense_data->command & ZFCP_CFDC_DOWNLOAD) &&
-	    (sense_data->command & ZFCP_CFDC_WITH_CONTROL_FILE)) {
-		retval = zfcp_sg_list_copy_from_user(
-			sg_list, &sense_data_user->control_file,
-			ZFCP_CFDC_MAX_CONTROL_FILE_SIZE);
-		if (retval) {
-			retval = -EFAULT;
-			goto out;
-		}
-	}
-
-	retval = zfcp_fsf_control_file(adapter, &fsf_req, fsf_command,
-				       option, sg_list);
-	if (retval)
-		goto out;
-
-	if ((fsf_req->qtcb->prefix.prot_status != FSF_PROT_GOOD) &&
-	    (fsf_req->qtcb->prefix.prot_status != FSF_PROT_FSF_STATUS_PRESENTED)) {
-		retval = -ENXIO;
-		goto out;
-	}
-
-	sense_data->fsf_status = fsf_req->qtcb->header.fsf_status;
-	memcpy(&sense_data->fsf_status_qual,
-	       &fsf_req->qtcb->header.fsf_status_qual,
-	       sizeof(union fsf_status_qual));
-	memcpy(&sense_data->payloads, &fsf_req->qtcb->bottom.support.els, 256);
-
-	retval = copy_to_user(sense_data_user, sense_data,
-		sizeof(struct zfcp_cfdc_sense_data));
-	if (retval) {
-		retval = -EFAULT;
-		goto out;
-	}
-
-	if (sense_data->command & ZFCP_CFDC_UPLOAD) {
-		retval = zfcp_sg_list_copy_to_user(
-			&sense_data_user->control_file, sg_list,
-			ZFCP_CFDC_MAX_CONTROL_FILE_SIZE);
-		if (retval) {
-			retval = -EFAULT;
-			goto out;
-		}
-	}
-
- out:
-	if (fsf_req != NULL)
-		zfcp_fsf_req_free(fsf_req);
-
-	if ((adapter != NULL) && (retval != -ENXIO))
-		zfcp_adapter_put(adapter);
-
-	if (sg_list != NULL) {
-		zfcp_sg_list_free(sg_list);
-		kfree(sg_list);
-	}
-
-	kfree(sense_data);
-
-	return retval;
-}
-
-
-/**
- * zfcp_sg_list_alloc - create a scatter-gather list of the specified size
- * @sg_list: structure describing a scatter gather list
- * @size: size of scatter-gather list
- * Return: 0 on success, else -ENOMEM
- *
- * In sg_list->sg a pointer to the created scatter-gather list is returned,
- * or NULL if we run out of memory. sg_list->count specifies the number of
- * elements of the scatter-gather list. The maximum size of a single element
- * in the scatter-gather list is PAGE_SIZE.
- */
-static int
-zfcp_sg_list_alloc(struct zfcp_sg_list *sg_list, size_t size)
-{
-	struct scatterlist *sg;
-	unsigned int i;
-	int retval = 0;
-	void *address;
-
-	BUG_ON(sg_list == NULL);
-
-	sg_list->count = size >> PAGE_SHIFT;
-	if (size & ~PAGE_MASK)
-		sg_list->count++;
-	sg_list->sg = kcalloc(sg_list->count, sizeof(struct scatterlist),
-			      GFP_KERNEL);
-	if (sg_list->sg == NULL) {
-		sg_list->count = 0;
-		retval = -ENOMEM;
-		goto out;
-	}
-	sg_init_table(sg_list->sg, sg_list->count);
-
-	for (i = 0, sg = sg_list->sg; i < sg_list->count; i++, sg++) {
-		address = (void *) get_zeroed_page(GFP_KERNEL);
-		if (address == NULL) {
-			sg_list->count = i;
-			zfcp_sg_list_free(sg_list);
-			retval = -ENOMEM;
-			goto out;
-		}
-		zfcp_address_to_sg(address, sg, min(size, PAGE_SIZE));
-		size -= sg->length;
-	}
-
- out:
-	return retval;
-}
-
-
-/**
- * zfcp_sg_list_free - free memory of a scatter-gather list
- * @sg_list: structure describing a scatter-gather list
- *
- * Memory for each element in the scatter-gather list is freed.
- * Finally sg_list->sg is freed itself and sg_list->count is reset.
- */
-static void
-zfcp_sg_list_free(struct zfcp_sg_list *sg_list)
-{
-	struct scatterlist *sg;
-	unsigned int i;
-
-	BUG_ON(sg_list == NULL);
-
-	for (i = 0, sg = sg_list->sg; i < sg_list->count; i++, sg++)
-		free_page((unsigned long) zfcp_sg_to_address(sg));
-
-	sg_list->count = 0;
-	kfree(sg_list->sg);
-}
-
-/**
- * zfcp_sg_size - determine size of a scatter-gather list
- * @sg: array of (struct scatterlist)
- * @sg_count: elements in array
- * Return: size of entire scatter-gather list
- */
-static size_t zfcp_sg_size(struct scatterlist *sg, unsigned int sg_count)
-{
-	unsigned int i;
-	struct scatterlist *p;
-	size_t size;
-
-	size = 0;
-	for (i = 0, p = sg; i < sg_count; i++, p++) {
-		BUG_ON(p == NULL);
-		size += p->length;
-	}
-
-	return size;
-}
-
-
-/**
- * zfcp_sg_list_copy_from_user -copy data from user space to scatter-gather list
- * @sg_list: structure describing a scatter-gather list
- * @user_buffer: pointer to buffer in user space
- * @size: number of bytes to be copied
- * Return: 0 on success, -EFAULT if copy_from_user fails.
- */
-static int
-zfcp_sg_list_copy_from_user(struct zfcp_sg_list *sg_list,
-			    void __user *user_buffer,
-                            size_t size)
-{
-	struct scatterlist *sg;
-	unsigned int length;
-	void *zfcp_buffer;
-	int retval = 0;
-
-	BUG_ON(sg_list == NULL);
-
-	if (zfcp_sg_size(sg_list->sg, sg_list->count) < size)
-		return -EFAULT;
-
-	for (sg = sg_list->sg; size > 0; sg++) {
-		length = min((unsigned int)size, sg->length);
-		zfcp_buffer = zfcp_sg_to_address(sg);
-		if (copy_from_user(zfcp_buffer, user_buffer, length)) {
-			retval = -EFAULT;
-			goto out;
-		}
-		user_buffer += length;
-		size -= length;
-	}
-
- out:
-	return retval;
-}
-
-
-/**
- * zfcp_sg_list_copy_to_user - copy data from scatter-gather list to user space
- * @user_buffer: pointer to buffer in user space
- * @sg_list: structure describing a scatter-gather list
- * @size: number of bytes to be copied
- * Return: 0 on success, -EFAULT if copy_to_user fails
- */
-static int
-zfcp_sg_list_copy_to_user(void __user  *user_buffer,
-			  struct zfcp_sg_list *sg_list,
-                          size_t size)
-{
-	struct scatterlist *sg;
-	unsigned int length;
-	void *zfcp_buffer;
-	int retval = 0;
-
-	BUG_ON(sg_list == NULL);
-
-	if (zfcp_sg_size(sg_list->sg, sg_list->count) < size)
-		return -EFAULT;
-
-	for (sg = sg_list->sg; size > 0; sg++) {
-		length = min((unsigned int) size, sg->length);
-		zfcp_buffer = zfcp_sg_to_address(sg);
-		if (copy_to_user(user_buffer, zfcp_buffer, length)) {
-			retval = -EFAULT;
-			goto out;
-		}
-		user_buffer += length;
-		size -= length;
-	}
-
- out:
-	return retval;
-}
-
-
 #undef ZFCP_LOG_AREA
 
 /****************************************************************/
@@ -1345,4 +950,32 @@ zfcp_nameserver_enqueue(struct zfcp_adap
 	return 0;
 }
 
+void zfcp_sg_free_table(struct scatterlist *sg, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++, sg++)
+		if (sg)
+			free_page((unsigned long) sg_virt(sg));
+		else
+			break;
+}
+
+int zfcp_sg_setup_table(struct scatterlist *sg, int count)
+{
+	void *addr;
+	int i;
+
+	sg_init_table(sg, count);
+	for (i = 0; i < count; i++, sg++) {
+		addr = (void *) get_zeroed_page(GFP_KERNEL);
+		if (!addr) {
+			zfcp_sg_free_table(sg, i);
+			return -ENOMEM;
+		}
+		sg_set_buf(sg, addr, PAGE_SIZE);
+	}
+	return 0;
+}
+
 #undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-09 17:56:34.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-10 15:12:24.000000000 +0200
@@ -86,8 +86,8 @@ extern int  zfcp_fsf_exchange_config_dat
 extern int  zfcp_fsf_exchange_port_data(struct zfcp_erp_action *);
 extern int  zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *,
                                              struct fsf_qtcb_bottom_port *);
-extern int  zfcp_fsf_control_file(struct zfcp_adapter *, struct zfcp_fsf_req **,
-				  u32, u32, struct zfcp_sg_list *);
+extern struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
+					   struct zfcp_fsf_cfdc *fsf_cfdc);
 extern void zfcp_fsf_start_timer(struct zfcp_fsf_req *, unsigned long);
 extern void zfcp_erp_start_timer(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
@@ -167,6 +167,8 @@ extern void zfcp_erp_port_access_changed
 extern void zfcp_erp_unit_access_changed(struct zfcp_unit *, u8, void *);
 
 /******************************** AUX ****************************************/
+extern void zfcp_sg_free_table(struct scatterlist *sg, int count);
+extern int  zfcp_sg_setup_table(struct scatterlist *sg, int count);
 extern void zfcp_rec_dbf_event_thread(u8 id, struct zfcp_adapter *adapter);
 extern void zfcp_rec_dbf_event_thread_lock(u8 id, struct zfcp_adapter *adapter);
 extern void zfcp_rec_dbf_event_adapter(u8 id, void *ref, struct zfcp_adapter *);
@@ -200,4 +202,6 @@ extern void zfcp_scsi_dbf_event_devreset
 					 struct scsi_cmnd *);
 extern int zfcp_reqlist_isempty(struct zfcp_adapter *);
 
+extern struct miscdevice zfcp_cfdc_misc;
+
 #endif	/* ZFCP_EXT_H */
--- a/drivers/s390/scsi/Makefile	2008-06-09 17:56:34.000000000 +0200
+++ b/drivers/s390/scsi/Makefile	2008-06-10 15:12:24.000000000 +0200
@@ -4,6 +4,6 @@
 
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.o \
 	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
-	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o zfcp_fc.o
+	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o zfcp_fc.o zfcp_cfdc.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-09 17:56:34.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-10 15:12:24.000000000 +0200
@@ -26,7 +26,6 @@
 
 #include <linux/init.h>
 #include <linux/moduleparam.h>
-#include <linux/miscdevice.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
@@ -534,38 +533,6 @@ do { \
 #define ZFCP_ERP_DISMISSED	0x4
 #define ZFCP_ERP_NOMEM		0x5
 
-
-/******************** CFDC SPECIFIC STUFF *****************************/
-
-/* Firewall data channel sense data record */
-struct zfcp_cfdc_sense_data {
-	u32 signature;           /* Request signature */
-	u32 devno;               /* FCP adapter device number */
-	u32 command;             /* Command code */
-	u32 fsf_status;          /* FSF request status and status qualifier */
-	u8  fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
-	u8  payloads[256];       /* Access conflicts list */
-	u8  control_file[0];     /* Access control table */
-};
-
-#define ZFCP_CFDC_SIGNATURE			0xCFDCACDF
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
-#define ZFCP_CFDC_DEV_NAME			"zfcp_cfdc"
-#define ZFCP_CFDC_DEV_MAJOR			MISC_MAJOR
-#define ZFCP_CFDC_DEV_MINOR			MISC_DYNAMIC_MINOR
-
-#define ZFCP_CFDC_MAX_CONTROL_FILE_SIZE		127 * 1024
-
 /************************* STRUCTURE DEFINITIONS *****************************/
 
 struct zfcp_fsf_req;
@@ -897,16 +864,6 @@ struct zfcp_data {
 	struct kmem_cache		*gid_pn_cache;
 };
 
-/**
- * struct zfcp_sg_list - struct describing a scatter-gather list
- * @sg: pointer to array of (struct scatterlist)
- * @count: number of elements in scatter-gather list
- */
-struct zfcp_sg_list {
-	struct scatterlist *sg;
-	unsigned int count;
-};
-
 /* number of elements for various memory pools */
 #define ZFCP_POOL_FSF_REQ_ERP_NR	1
 #define ZFCP_POOL_FSF_REQ_SCSI_NR	1
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/s390/scsi/zfcp_cfdc.c	2008-06-10 15:12:26.000000000 +0200
@@ -0,0 +1,259 @@
+/*
+ * zfcp device driver
+ *
+ * Userspace interface for accessing the
+ * Access Control Lists / Control File Data Channel
+ *
+ * Copyright IBM Corporation 2008
+ */
+
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <asm/ccwdev.h>
+#include "zfcp_def.h"
+#include "zfcp_ext.h"
+#include "zfcp_fsf.h"
+
+#define ZFCP_CFDC_CMND_DOWNLOAD_NORMAL		0x00010001
+#define ZFCP_CFDC_CMND_DOWNLOAD_FORCE		0x00010101
+#define ZFCP_CFDC_CMND_FULL_ACCESS		0x00000201
+#define ZFCP_CFDC_CMND_RESTRICTED_ACCESS	0x00000401
+#define ZFCP_CFDC_CMND_UPLOAD			0x00010002
+
+#define ZFCP_CFDC_DOWNLOAD			0x00000001
+#define ZFCP_CFDC_UPLOAD			0x00000002
+#define ZFCP_CFDC_WITH_CONTROL_FILE		0x00010000
+
+#define ZFCP_CFDC_IOC_MAGIC                     0xDD
+#define ZFCP_CFDC_IOC \
+	_IOWR(ZFCP_CFDC_IOC_MAGIC, 0, struct zfcp_cfdc_data)
+
+/**
+ * struct zfcp_cfdc_data - data for ioctl cfdc interface
+ * @signature: request signature
+ * @devno: FCP adapter device number
+ * @command: command code
+ * @fsf_status: returns status of FSF command to userspace
+ * @fsf_status_qual: returned to userspace
+ * @payloads: access conflicts list
+ * @control_file: access control table
+ */
+struct zfcp_cfdc_data {
+	u32 signature;
+	u32 devno;
+	u32 command;
+	u32 fsf_status;
+	u8  fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
+	u8  payloads[256];
+	u8  control_file[0];
+};
+
+static int zfcp_cfdc_copy_from_user(struct scatterlist *sg,
+				    void __user *user_buffer)
+{
+	unsigned int length;
+	unsigned int size = ZFCP_CFDC_MAX_SIZE;
+
+	while (size) {
+		length = min((unsigned int)size, sg->length);
+		if (copy_from_user(sg_virt(sg++), user_buffer, length))
+			return -EFAULT;
+		user_buffer += length;
+		size -= length;
+	}
+	return 0;
+}
+
+static int zfcp_cfdc_copy_to_user(void __user  *user_buffer,
+				  struct scatterlist *sg)
+{
+	unsigned int length;
+	unsigned int size = ZFCP_CFDC_MAX_SIZE;
+
+	while (size) {
+		length = min((unsigned int) size, sg->length);
+		if (copy_to_user(user_buffer, sg_virt(sg++), length))
+			return -EFAULT;
+		user_buffer += length;
+		size -= length;
+	}
+	return 0;
+}
+
+static struct zfcp_adapter *zfcp_cfdc_get_adapter(u32 devno)
+{
+	struct zfcp_adapter *adapter = NULL, *cur_adapter;
+	struct ccw_dev_id dev_id;
+
+	read_lock_irq(&zfcp_data.config_lock);
+	list_for_each_entry(cur_adapter, &zfcp_data.adapter_list_head, list) {
+		ccw_device_get_id(cur_adapter->ccw_device, &dev_id);
+		if (dev_id.devno == devno) {
+			adapter = cur_adapter;
+			zfcp_adapter_get(adapter);
+			break;
+		}
+	}
+	read_unlock_irq(&zfcp_data.config_lock);
+	return adapter;
+}
+
+static int zfcp_cfdc_set_fsf(struct zfcp_fsf_cfdc *fsf_cfdc, int command)
+{
+	switch (command) {
+	case ZFCP_CFDC_CMND_DOWNLOAD_NORMAL:
+		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
+		fsf_cfdc->option = FSF_CFDC_OPTION_NORMAL_MODE;
+		break;
+	case ZFCP_CFDC_CMND_DOWNLOAD_FORCE:
+		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
+		fsf_cfdc->option = FSF_CFDC_OPTION_FORCE;
+		break;
+	case ZFCP_CFDC_CMND_FULL_ACCESS:
+		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
+		fsf_cfdc->option = FSF_CFDC_OPTION_FULL_ACCESS;
+		break;
+	case ZFCP_CFDC_CMND_RESTRICTED_ACCESS:
+		fsf_cfdc->command = FSF_QTCB_DOWNLOAD_CONTROL_FILE;
+		fsf_cfdc->option = FSF_CFDC_OPTION_RESTRICTED_ACCESS;
+		break;
+	case ZFCP_CFDC_CMND_UPLOAD:
+		fsf_cfdc->command = FSF_QTCB_UPLOAD_CONTROL_FILE;
+		fsf_cfdc->option = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int zfcp_cfdc_sg_setup(int command, struct scatterlist *sg,
+			      u8 __user *control_file)
+{
+	int retval;
+	retval = zfcp_sg_setup_table(sg, ZFCP_CFDC_PAGES);
+	if (retval)
+		return retval;
+
+	sg[ZFCP_CFDC_PAGES - 1].length = ZFCP_CFDC_MAX_SIZE % PAGE_SIZE;
+
+	if (command & ZFCP_CFDC_WITH_CONTROL_FILE &&
+	    command & ZFCP_CFDC_DOWNLOAD) {
+		retval = zfcp_cfdc_copy_from_user(sg, control_file);
+		if (retval) {
+			zfcp_sg_free_table(sg, ZFCP_CFDC_PAGES);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
+static void zfcp_cfdc_req_to_sense(struct zfcp_cfdc_data *data,
+				   struct zfcp_fsf_req *req)
+{
+	data->fsf_status = req->qtcb->header.fsf_status;
+	memcpy(&data->fsf_status_qual, &req->qtcb->header.fsf_status_qual,
+	       sizeof(union fsf_status_qual));
+	memcpy(&data->payloads, &req->qtcb->bottom.support.els,
+	       sizeof(req->qtcb->bottom.support.els));
+}
+
+static long zfcp_cfdc_dev_ioctl(struct file *file, unsigned int command,
+				unsigned long buffer)
+{
+	struct zfcp_cfdc_data *data;
+	struct zfcp_cfdc_data __user *data_user;
+	struct zfcp_adapter *adapter;
+	struct zfcp_fsf_req *req;
+	struct zfcp_fsf_cfdc *fsf_cfdc;
+	int retval;
+
+	if (command != ZFCP_CFDC_IOC)
+		return -ENOTTY;
+
+	data_user = (void __user *) buffer;
+	if (!data_user)
+		return -EINVAL;
+
+	fsf_cfdc = kmalloc(sizeof(struct zfcp_fsf_cfdc), GFP_KERNEL);
+	if (!fsf_cfdc)
+		return -ENOMEM;
+
+	data = kmalloc(sizeof(struct zfcp_cfdc_data), GFP_KERNEL);
+	if (!data) {
+		retval = -ENOMEM;
+		goto no_mem_sense;
+	}
+
+	retval = copy_from_user(data, data_user, sizeof(*data));
+	if (retval) {
+		retval = -EFAULT;
+		goto free_buffer;
+	}
+
+	if (data->signature != 0xCFDCACDF) {
+		retval = -EINVAL;
+		goto free_buffer;
+	}
+
+	retval = zfcp_cfdc_set_fsf(fsf_cfdc, data->command);
+
+	adapter = zfcp_cfdc_get_adapter(data->devno);
+	if (!adapter) {
+		retval = -ENXIO;
+		goto free_buffer;
+	}
+
+	retval = zfcp_cfdc_sg_setup(data->command, fsf_cfdc->sg,
+				    data_user->control_file);
+	if (retval)
+		goto adapter_put;
+	req = zfcp_fsf_control_file(adapter, fsf_cfdc);
+	if (IS_ERR(req)) {
+		retval = PTR_ERR(req);
+		goto free_sg;
+	}
+
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR) {
+		retval = -ENXIO;
+		goto free_fsf;
+	}
+
+	zfcp_cfdc_req_to_sense(data, req);
+	retval = copy_to_user(data_user, data, sizeof(*data_user));
+	if (retval) {
+		retval = -EFAULT;
+		goto free_fsf;
+	}
+
+	if (data->command & ZFCP_CFDC_UPLOAD)
+		retval = zfcp_cfdc_copy_to_user(&data_user->control_file,
+						fsf_cfdc->sg);
+
+ free_fsf:
+	zfcp_fsf_req_free(req);
+ free_sg:
+	zfcp_sg_free_table(fsf_cfdc->sg, ZFCP_CFDC_PAGES);
+ adapter_put:
+	zfcp_adapter_put(adapter);
+ free_buffer:
+	kfree(data);
+ no_mem_sense:
+	kfree(fsf_cfdc);
+	return retval;
+}
+
+static const struct file_operations zfcp_cfdc_fops = {
+	.unlocked_ioctl = zfcp_cfdc_dev_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = zfcp_cfdc_dev_ioctl
+#endif
+};
+
+struct miscdevice zfcp_cfdc_misc = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "zfcp_cfdc",
+	.fops = &zfcp_cfdc_fops,
+};
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-09 17:56:34.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-10 15:12:24.000000000 +0200
@@ -36,7 +36,7 @@ static int zfcp_fsf_abort_fcp_command_ha
 static int zfcp_fsf_status_read_handler(struct zfcp_fsf_req *);
 static int zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *);
 static int zfcp_fsf_send_els_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_control_file_handler(struct zfcp_fsf_req *);
+static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *);
 static inline int zfcp_fsf_req_sbal_check(
 	unsigned long *, struct zfcp_qdio_queue *, int);
 static inline int zfcp_use_one_sbal(
@@ -4183,53 +4183,35 @@ zfcp_fsf_send_fcp_command_task_managemen
  *              -ENOMEM     - Insufficient memory
  *              -EPERM      - Cannot create FSF request or place it in QDIO queue
  */
-int
-zfcp_fsf_control_file(struct zfcp_adapter *adapter,
-                      struct zfcp_fsf_req **fsf_req_ptr,
-                      u32 fsf_command,
-                      u32 option,
-                      struct zfcp_sg_list *sg_list)
+struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
+					   struct zfcp_fsf_cfdc *fsf_cfdc)
 {
 	struct zfcp_fsf_req *fsf_req;
 	struct fsf_qtcb_bottom_support *bottom;
 	volatile struct qdio_buffer_element *sbale;
 	unsigned long lock_flags;
-	int req_flags = 0;
 	int direction;
-	int retval = 0;
-
-	if (!(adapter->adapter_features & FSF_FEATURE_CFDC)) {
-		ZFCP_LOG_INFO("cfdc not supported (adapter %s)\n",
-			      zfcp_get_busid_by_adapter(adapter));
-		retval = -EOPNOTSUPP;
-		goto out;
-	}
+	int retval;
+	int bytes;
 
-	switch (fsf_command) {
+	if (!(adapter->adapter_features & FSF_FEATURE_CFDC))
+		return ERR_PTR(-EOPNOTSUPP);
 
+	switch (fsf_cfdc->command) {
 	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
 		direction = SBAL_FLAGS0_TYPE_WRITE;
-		if ((option != FSF_CFDC_OPTION_FULL_ACCESS) &&
-		    (option != FSF_CFDC_OPTION_RESTRICTED_ACCESS))
-			req_flags = ZFCP_WAIT_FOR_SBAL;
 		break;
-
 	case FSF_QTCB_UPLOAD_CONTROL_FILE:
 		direction = SBAL_FLAGS0_TYPE_READ;
 		break;
-
 	default:
-		ZFCP_LOG_INFO("Invalid FSF command code 0x%08x\n", fsf_command);
-		retval = -EINVAL;
-		goto out;
+		return ERR_PTR(-EINVAL);
 	}
 
-	retval = zfcp_fsf_req_create(adapter, fsf_command, req_flags,
+	retval = zfcp_fsf_req_create(adapter, fsf_cfdc->command,
+				     ZFCP_WAIT_FOR_SBAL,
 				     NULL, &lock_flags, &fsf_req);
 	if (retval < 0) {
-		ZFCP_LOG_INFO("error: Could not create FSF request for the "
-			      "adapter %s\n",
-			zfcp_get_busid_by_adapter(adapter));
 		retval = -EPERM;
 		goto unlock_queue_lock;
 	}
@@ -4239,220 +4221,40 @@ zfcp_fsf_control_file(struct zfcp_adapte
 
 	bottom = &fsf_req->qtcb->bottom.support;
 	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
-	bottom->option = option;
+	bottom->option = fsf_cfdc->option;
 
-	if (sg_list->count > 0) {
-		int bytes;
-
-		bytes = zfcp_qdio_sbals_from_sg(fsf_req, direction,
-						sg_list->sg, sg_list->count,
-						ZFCP_MAX_SBALS_PER_REQ);
-                if (bytes != ZFCP_CFDC_MAX_CONTROL_FILE_SIZE) {
-			ZFCP_LOG_INFO(
-				"error: Could not create sufficient number of "
-				"SBALS for an FSF request to the adapter %s\n",
-				zfcp_get_busid_by_adapter(adapter));
-			retval = -ENOMEM;
-			goto free_fsf_req;
-		}
-	} else
-		sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	bytes = zfcp_qdio_sbals_from_sg(fsf_req, direction,
+					fsf_cfdc->sg, ZFCP_CFDC_PAGES,
+					ZFCP_MAX_SBALS_PER_REQ);
+	if (bytes != ZFCP_CFDC_MAX_SIZE) {
+		retval = -ENOMEM;
+		goto free_fsf_req;
+	}
 
 	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(fsf_req);
 	if (retval < 0) {
-		ZFCP_LOG_INFO("initiation of cfdc up/download failed"
-			      "(adapter %s)\n",
-			      zfcp_get_busid_by_adapter(adapter));
 		retval = -EPERM;
 		goto free_fsf_req;
 	}
 	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
 
-	ZFCP_LOG_NORMAL("Control file %s FSF request has been sent to the "
-			"adapter %s\n",
-			fsf_command == FSF_QTCB_DOWNLOAD_CONTROL_FILE ?
-			"download" : "upload",
-			zfcp_get_busid_by_adapter(adapter));
-
 	wait_event(fsf_req->completion_wq,
 	           fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
-	*fsf_req_ptr = fsf_req;
-	goto out;
+	return fsf_req;
 
  free_fsf_req:
 	zfcp_fsf_req_free(fsf_req);
  unlock_queue_lock:
 	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
- out:
-	return retval;
+	return ERR_PTR(retval);
 }
 
-
-/*
- * function:    zfcp_fsf_control_file_handler
- *
- * purpose:     Handler of the control file upload/download FSF requests
- *
- * returns:     0       - FSF request successfuly processed
- *              -EAGAIN - Operation has to be repeated because of a temporary problem
- *              -EACCES - There is no permission to execute an operation
- *              -EPERM  - The control file is not in a right format
- *              -EIO    - There is a problem with the FCP adapter
- *              -EINVAL - Invalid operation
- *              -EFAULT - User space memory I/O operation fault
- */
-static int
-zfcp_fsf_control_file_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *fsf_req)
 {
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fsf_qtcb_header *header = &fsf_req->qtcb->header;
-	struct fsf_qtcb_bottom_support *bottom = &fsf_req->qtcb->bottom.support;
-	int retval = 0;
-
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		retval = -EINVAL;
-		goto skip_fsfstatus;
-	}
-
-	switch (header->fsf_status) {
-
-	case FSF_GOOD:
-		ZFCP_LOG_NORMAL(
-			"The FSF request has been successfully completed "
-			"on the adapter %s\n",
-			zfcp_get_busid_by_adapter(adapter));
-		break;
-
-	case FSF_OPERATION_PARTIALLY_SUCCESSFUL:
-		if (bottom->operation_subtype == FSF_CFDC_OPERATION_SUBTYPE) {
-			switch (header->fsf_status_qual.word[0]) {
-
-			case FSF_SQ_CFDC_HARDENED_ON_SE:
-				ZFCP_LOG_NORMAL(
-					"CFDC on the adapter %s has being "
-					"hardened on primary and secondary SE\n",
-					zfcp_get_busid_by_adapter(adapter));
-				break;
-
-			case FSF_SQ_CFDC_COULD_NOT_HARDEN_ON_SE:
-				ZFCP_LOG_NORMAL(
-					"CFDC of the adapter %s could not "
-					"be saved on the SE\n",
-					zfcp_get_busid_by_adapter(adapter));
-				break;
-
-			case FSF_SQ_CFDC_COULD_NOT_HARDEN_ON_SE2:
-				ZFCP_LOG_NORMAL(
-					"CFDC of the adapter %s could not "
-					"be copied to the secondary SE\n",
-					zfcp_get_busid_by_adapter(adapter));
-				break;
-
-			default:
-				ZFCP_LOG_NORMAL(
-					"CFDC could not be hardened "
-					"on the adapter %s\n",
-					zfcp_get_busid_by_adapter(adapter));
-			}
-		}
+	if (fsf_req->qtcb->header.fsf_status != FSF_GOOD)
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EAGAIN;
-		break;
-
-	case FSF_AUTHORIZATION_FAILURE:
-		ZFCP_LOG_NORMAL(
-			"Adapter %s does not accept privileged commands\n",
-			zfcp_get_busid_by_adapter(adapter));
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EACCES;
-		break;
-
-	case FSF_CFDC_ERROR_DETECTED:
-		ZFCP_LOG_NORMAL(
-			"Error at position %d in the CFDC, "
-			"CFDC is discarded by the adapter %s\n",
-			header->fsf_status_qual.word[0],
-			zfcp_get_busid_by_adapter(adapter));
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EPERM;
-		break;
-
-	case FSF_CONTROL_FILE_UPDATE_ERROR:
-		ZFCP_LOG_NORMAL(
-			"Adapter %s cannot harden the control file, "
-			"file is discarded\n",
-			zfcp_get_busid_by_adapter(adapter));
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EIO;
-		break;
-
-	case FSF_CONTROL_FILE_TOO_LARGE:
-		ZFCP_LOG_NORMAL(
-			"Control file is too large, file is discarded "
-			"by the adapter %s\n",
-			zfcp_get_busid_by_adapter(adapter));
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EIO;
-		break;
-
-	case FSF_ACCESS_CONFLICT_DETECTED:
-		if (bottom->operation_subtype == FSF_CFDC_OPERATION_SUBTYPE)
-			ZFCP_LOG_NORMAL(
-				"CFDC has been discarded by the adapter %s, "
-				"because activation would impact "
-				"%d active connection(s)\n",
-				zfcp_get_busid_by_adapter(adapter),
-				header->fsf_status_qual.word[0]);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EIO;
-		break;
-
-	case FSF_CONFLICTS_OVERRULED:
-		if (bottom->operation_subtype == FSF_CFDC_OPERATION_SUBTYPE)
-			ZFCP_LOG_NORMAL(
-				"CFDC has been activated on the adapter %s, "
-				"but activation has impacted "
-				"%d active connection(s)\n",
-				zfcp_get_busid_by_adapter(adapter),
-				header->fsf_status_qual.word[0]);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EIO;
-		break;
-
-	case FSF_UNKNOWN_OP_SUBTYPE:
-		ZFCP_LOG_NORMAL("unknown operation subtype (adapter: %s, "
-				"op_subtype=0x%x)\n",
-				zfcp_get_busid_by_adapter(adapter),
-				bottom->operation_subtype);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EINVAL;
-		break;
-
-	case FSF_INVALID_COMMAND_OPTION:
-		ZFCP_LOG_NORMAL(
-			"Invalid option 0x%x has been specified "
-			"in QTCB bottom sent to the adapter %s\n",
-			bottom->option,
-			zfcp_get_busid_by_adapter(adapter));
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EINVAL;
-		break;
-
-	default:
-		ZFCP_LOG_NORMAL(
-			"bug: An unknown/unexpected FSF status 0x%08x "
-			"was presented on the adapter %s\n",
-			header->fsf_status,
-			zfcp_get_busid_by_adapter(adapter));
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EINVAL;
-		break;
-	}
-
-skip_fsfstatus:
-	return retval;
 }
 
 static inline int
--- a/drivers/s390/scsi/zfcp_fsf.h	2008-06-09 17:56:34.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2008-06-10 15:12:24.000000000 +0200
@@ -22,6 +22,8 @@
 #ifndef FSF_H
 #define FSF_H
 
+#include <linux/pfn.h>
+
 #define FSF_QTCB_CURRENT_VERSION		0x00000001
 
 /* FSF commands */
@@ -258,6 +260,16 @@
 #define FSF_UNIT_ACCESS_EXCLUSIVE		0x02000000
 #define FSF_UNIT_ACCESS_OUTBOUND_TRANSFER	0x10000000
 
+/* FSF interface for CFDC */
+#define ZFCP_CFDC_MAX_SIZE		127 * 1024
+#define ZFCP_CFDC_PAGES 		PFN_UP(ZFCP_CFDC_MAX_SIZE)
+
+struct zfcp_fsf_cfdc {
+	struct scatterlist sg[ZFCP_CFDC_PAGES];
+	u32 command;
+	u32 option;
+};
+
 struct fsf_queue_designator {
 	u8  cssid;
 	u8  chpid;

-- 
