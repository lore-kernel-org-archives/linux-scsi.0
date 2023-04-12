Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97627C77B6E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 17:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjDLRlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 13:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDLRk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 13:40:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DAA65BA
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 10:40:53 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33CHIe54012918;
        Wed, 12 Apr 2023 17:40:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=bnIrI/sFM80zvyjPknSV1Kmf+YnZiGDBWbXnI8UQk/U=;
 b=rAhVyR1714dUQJsDl70/StITHI9uZeVb5wUvs+7XwJs3i4l4FgXSuvoxfUi5j60Udi6C
 p0kXBlnTHndcfpdjxF15UAIfjzUTd0YMzWJrQ7usnHr5zo/sQgydTSDm6DJc7StdYe8w
 GfyISTLeEowIUxP+2eDMtXDKzeNMHqDw2NZcNoSZly7zP6mWqJ7J5ykcjWGrHiHvMjXY
 1Mm2IHR0WHpLJs+uzo4EZasJdRk8Oy6A0wJJoeYIBD8/bQnWvFbk43UEZmiCPyNNiiB1
 UeUwpsmmK5lqKEUtl7Rm0sapm4VDONZhXe2KYaUUnf2jX5g43JgY6NACmNhvJJcmtWo6 qw== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3px0xbgpwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Apr 2023 17:40:24 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33CGsJRm003033;
        Wed, 12 Apr 2023 17:40:24 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3pu0jb7d7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Apr 2023 17:40:24 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33CHeMdW17761012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 17:40:22 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ADDE5805D;
        Wed, 12 Apr 2023 17:40:22 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 870EE58059;
        Wed, 12 Apr 2023 17:40:21 +0000 (GMT)
Received: from li-6bf4d4cc-31f5-11b2-a85c-838e9310af65.rchland.ibm.com (unknown [9.10.86.227])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Apr 2023 17:40:21 +0000 (GMT)
From:   Brian King <brking@linux.vnet.ibm.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com,
        wenxiong@linux.ibm.com, Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] ipr: Remove SATA support
Date:   Wed, 12 Apr 2023 12:40:15 -0500
Message-Id: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5JPSoPOxiVX4RzLoMfnMctBztx1xHmUM
X-Proofpoint-GUID: 5JPSoPOxiVX4RzLoMfnMctBztx1xHmUM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_08,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 suspectscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304120151
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Linux SATA support in ipr has always been limited to SATA DVDs. The last
systems that had the option of including a SATA DVD was Power 8,
which have been withdrawn for sometime now, so this support can
be removed.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/Kconfig |   3 +-
 drivers/scsi/ipr.c   | 774 +------------------------------------------
 drivers/scsi/ipr.h   |  64 ----
 3 files changed, 11 insertions(+), 830 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 03e71e3d5e5b..0704809d9d99 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -971,8 +971,7 @@ config SCSI_SYM53C8XX_MMIO
 
 config SCSI_IPR
 	tristate "IBM Power Linux RAID adapter support"
-	depends on PCI && SCSI && ATA
-	select SATA_HOST
+	depends on PCI && SCSI
 	select FW_LOADER
 	select IRQ_POLL
 	select SGL_ALLOC
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 4d3c280a7360..d81189ba8773 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -58,7 +58,6 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <linux/reboot.h>
 #include <linux/stringify.h>
@@ -595,10 +594,6 @@ static void ipr_trc_hook(struct ipr_cmnd *ipr_cmd,
 	trace_entry->time = jiffies;
 	trace_entry->op_code = ipr_cmd->ioarcb.cmd_pkt.cdb[0];
 	trace_entry->type = type;
-	if (ipr_cmd->ioa_cfg->sis64)
-		trace_entry->ata_op_code = ipr_cmd->i.ata_ioadl.regs.command;
-	else
-		trace_entry->ata_op_code = ipr_cmd->ioarcb.u.add_data.u.regs.command;
 	trace_entry->cmd_index = ipr_cmd->cmd_index & 0xff;
 	trace_entry->res_handle = ipr_cmd->ioarcb.res_handle;
 	trace_entry->u.add_data = add_data;
@@ -636,7 +631,6 @@ static void ipr_reinit_ipr_cmnd(struct ipr_cmnd *ipr_cmd)
 {
 	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
 	struct ipr_ioasa *ioasa = &ipr_cmd->s.ioasa;
-	struct ipr_ioasa64 *ioasa64 = &ipr_cmd->s.ioasa64;
 	dma_addr_t dma_addr = ipr_cmd->dma_addr;
 	int hrrq_id;
 
@@ -651,18 +645,15 @@ static void ipr_reinit_ipr_cmnd(struct ipr_cmnd *ipr_cmd)
 	if (ipr_cmd->ioa_cfg->sis64) {
 		ioarcb->u.sis64_addr_data.data_ioadl_addr =
 			cpu_to_be64(dma_addr + offsetof(struct ipr_cmnd, i.ioadl64));
-		ioasa64->u.gata.status = 0;
 	} else {
 		ioarcb->write_ioadl_addr =
 			cpu_to_be32(dma_addr + offsetof(struct ipr_cmnd, i.ioadl));
 		ioarcb->read_ioadl_addr = ioarcb->write_ioadl_addr;
-		ioasa->u.gata.status = 0;
 	}
 
 	ioasa->hdr.ioasc = 0;
 	ioasa->hdr.residual_data_len = 0;
 	ipr_cmd->scsi_cmd = NULL;
-	ipr_cmd->qc = NULL;
 	ipr_cmd->sense_buffer[0] = 0;
 	ipr_cmd->dma_use_sg = 0;
 }
@@ -806,48 +797,6 @@ static int ipr_set_pcix_cmd_reg(struct ipr_ioa_cfg *ioa_cfg)
 	return 0;
 }
 
-/**
- * __ipr_sata_eh_done - done function for aborted SATA commands
- * @ipr_cmd:	ipr command struct
- *
- * This function is invoked for ops generated to SATA
- * devices which are being aborted.
- *
- * Return value:
- * 	none
- **/
-static void __ipr_sata_eh_done(struct ipr_cmnd *ipr_cmd)
-{
-	struct ata_queued_cmd *qc = ipr_cmd->qc;
-	struct ipr_sata_port *sata_port = qc->ap->private_data;
-
-	qc->err_mask |= AC_ERR_OTHER;
-	sata_port->ioasa.status |= ATA_BUSY;
-	ata_qc_complete(qc);
-	if (ipr_cmd->eh_comp)
-		complete(ipr_cmd->eh_comp);
-	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
-}
-
-/**
- * ipr_sata_eh_done - done function for aborted SATA commands
- * @ipr_cmd:	ipr command struct
- *
- * This function is invoked for ops generated to SATA
- * devices which are being aborted.
- *
- * Return value:
- * 	none
- **/
-static void ipr_sata_eh_done(struct ipr_cmnd *ipr_cmd)
-{
-	struct ipr_hrr_queue *hrrq = ipr_cmd->hrrq;
-	unsigned long hrrq_flags;
-
-	spin_lock_irqsave(&hrrq->_lock, hrrq_flags);
-	__ipr_sata_eh_done(ipr_cmd);
-	spin_unlock_irqrestore(&hrrq->_lock, hrrq_flags);
-}
 
 /**
  * __ipr_scsi_eh_done - mid-layer done function for aborted ops
@@ -920,8 +869,6 @@ static void ipr_fail_all_ops(struct ipr_ioa_cfg *ioa_cfg)
 
 			if (ipr_cmd->scsi_cmd)
 				ipr_cmd->done = __ipr_scsi_eh_done;
-			else if (ipr_cmd->qc)
-				ipr_cmd->done = __ipr_sata_eh_done;
 
 			ipr_trc_hook(ipr_cmd, IPR_TRACE_FINISH,
 				     IPR_IOASC_IOA_WAS_RESET);
@@ -1142,31 +1089,6 @@ static void ipr_send_hcam(struct ipr_ioa_cfg *ioa_cfg, u8 type,
 	}
 }
 
-/**
- * ipr_update_ata_class - Update the ata class in the resource entry
- * @res:	resource entry struct
- * @proto:	cfgte device bus protocol value
- *
- * Return value:
- * 	none
- **/
-static void ipr_update_ata_class(struct ipr_resource_entry *res, unsigned int proto)
-{
-	switch (proto) {
-	case IPR_PROTO_SATA:
-	case IPR_PROTO_SAS_STP:
-		res->ata_class = ATA_DEV_ATA;
-		break;
-	case IPR_PROTO_SATA_ATAPI:
-	case IPR_PROTO_SAS_STP_ATAPI:
-		res->ata_class = ATA_DEV_ATAPI;
-		break;
-	default:
-		res->ata_class = ATA_DEV_UNKNOWN;
-		break;
-	}
-}
-
 /**
  * ipr_init_res_entry - Initialize a resource entry struct.
  * @res:	resource entry struct
@@ -1190,7 +1112,6 @@ static void ipr_init_res_entry(struct ipr_resource_entry *res,
 	res->resetting_device = 0;
 	res->reset_occurred = 0;
 	res->sdev = NULL;
-	res->sata_port = NULL;
 
 	if (ioa_cfg->sis64) {
 		proto = cfgtew->u.cfgte64->proto;
@@ -1252,8 +1173,6 @@ static void ipr_init_res_entry(struct ipr_resource_entry *res,
 		res->lun = cfgtew->u.cfgte->res_addr.lun;
 		res->lun_wwn = get_unaligned_be64(cfgtew->u.cfgte->lun_wwn);
 	}
-
-	ipr_update_ata_class(res, proto);
 }
 
 /**
@@ -1383,8 +1302,6 @@ static void ipr_update_res_entry(struct ipr_resource_entry *res,
 		proto = cfgtew->u.cfgte->proto;
 		res->res_handle = cfgtew->u.cfgte->res_handle;
 	}
-
-	ipr_update_ata_class(res, proto);
 }
 
 /**
@@ -4502,9 +4419,6 @@ static int ipr_change_queue_depth(struct scsi_device *sdev, int qdepth)
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
-
-	if (res && ipr_is_gata(res) && qdepth > IPR_MAX_CMD_PER_ATA_LUN)
-		qdepth = IPR_MAX_CMD_PER_ATA_LUN;
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	scsi_change_queue_depth(sdev, qdepth);
@@ -4799,68 +4713,13 @@ static struct ipr_resource_entry *ipr_find_starget(struct scsi_target *starget)
 	return NULL;
 }
 
-static struct ata_port_info sata_port_info;
-
-/**
- * ipr_target_alloc - Prepare for commands to a SCSI target
- * @starget:	scsi target struct
- *
- * If the device is a SATA device, this function allocates an
- * ATA port with libata, else it does nothing.
- *
- * Return value:
- * 	0 on success / non-0 on failure
- **/
-static int ipr_target_alloc(struct scsi_target *starget)
-{
-	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
-	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
-	struct ipr_sata_port *sata_port;
-	struct ata_port *ap;
-	struct ipr_resource_entry *res;
-	unsigned long lock_flags;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	res = ipr_find_starget(starget);
-	starget->hostdata = NULL;
-
-	if (res && ipr_is_gata(res)) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-		sata_port = kzalloc(sizeof(*sata_port), GFP_KERNEL);
-		if (!sata_port)
-			return -ENOMEM;
-
-		ap = ata_sas_port_alloc(&ioa_cfg->ata_host, &sata_port_info, shost);
-		if (ap) {
-			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-			sata_port->ioa_cfg = ioa_cfg;
-			sata_port->ap = ap;
-			sata_port->res = res;
-
-			res->sata_port = sata_port;
-			ap->private_data = sata_port;
-			starget->hostdata = sata_port;
-		} else {
-			kfree(sata_port);
-			return -ENOMEM;
-		}
-	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-
-	return 0;
-}
-
 /**
  * ipr_target_destroy - Destroy a SCSI target
  * @starget:	scsi target struct
  *
- * If the device was a SATA device, this function frees the libata
- * ATA port, else it does nothing.
- *
  **/
 static void ipr_target_destroy(struct scsi_target *starget)
 {
-	struct ipr_sata_port *sata_port = starget->hostdata;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
 
@@ -4874,12 +4733,6 @@ static void ipr_target_destroy(struct scsi_target *starget)
 				clear_bit(starget->id, ioa_cfg->target_ids);
 		}
 	}
-
-	if (sata_port) {
-		starget->hostdata = NULL;
-		ata_sas_port_destroy(sata_port->ap);
-		kfree(sata_port);
-	}
 }
 
 /**
@@ -4922,11 +4775,8 @@ static void ipr_slave_destroy(struct scsi_device *sdev)
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *) sdev->hostdata;
 	if (res) {
-		if (res->sata_port)
-			res->sata_port->ap->link.device[0].class = ATA_DEV_NONE;
 		sdev->hostdata = NULL;
 		res->sdev = NULL;
-		res->sata_port = NULL;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 }
@@ -4944,7 +4794,6 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 	struct ipr_resource_entry *res;
-	struct ata_port *ap = NULL;
 	unsigned long lock_flags = 0;
 	char buffer[IPR_MAX_RES_PATH_LENGTH];
 
@@ -4964,15 +4813,8 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 					     IPR_VSET_RW_TIMEOUT);
 			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
 		}
-		if (ipr_is_gata(res) && res->sata_port)
-			ap = res->sata_port->ap;
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-		if (ap) {
-			scsi_change_queue_depth(sdev, IPR_MAX_CMD_PER_ATA_LUN);
-			ata_sas_slave_configure(sdev, ap);
-		}
-
 		if (ioa_cfg->sis64)
 			sdev_printk(KERN_INFO, sdev, "Resource path: %s\n",
 				    ipr_format_res_path(ioa_cfg,
@@ -4983,37 +4825,6 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-/**
- * ipr_ata_slave_alloc - Prepare for commands to a SATA device
- * @sdev:	scsi device struct
- *
- * This function initializes an ATA port so that future commands
- * sent through queuecommand will work.
- *
- * Return value:
- * 	0 on success
- **/
-static int ipr_ata_slave_alloc(struct scsi_device *sdev)
-{
-	struct ipr_sata_port *sata_port = NULL;
-	int rc = -ENXIO;
-
-	ENTER;
-	if (sdev->sdev_target)
-		sata_port = sdev->sdev_target->hostdata;
-	if (sata_port) {
-		rc = ata_sas_port_init(sata_port->ap);
-		if (rc == 0)
-			rc = ata_sas_sync_probe(sata_port->ap);
-	}
-
-	if (rc)
-		ipr_slave_destroy(sdev);
-
-	LEAVE;
-	return rc;
-}
-
 /**
  * ipr_slave_alloc - Prepare for commands to a device.
  * @sdev:	scsi device struct
@@ -5047,8 +4858,10 @@ static int ipr_slave_alloc(struct scsi_device *sdev)
 			res->needs_sync_complete = 1;
 		rc = 0;
 		if (ipr_is_gata(res)) {
+			sdev_printk(KERN_ERR, sdev, "SATA devices are no longer "
+				"supported by this driver. Skipping device.\n");
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			return ipr_ata_slave_alloc(sdev);
+			return -ENXIO;
 		}
 	}
 
@@ -5091,23 +4904,6 @@ static bool ipr_cmnd_is_free(struct ipr_cmnd *ipr_cmd)
 	return false;
 }
 
-/**
- * ipr_match_res - Match function for specified resource entry
- * @ipr_cmd:	ipr command struct
- * @resource:	resource entry to match
- *
- * Returns:
- *	1 if command matches sdev / 0 if command does not match sdev
- **/
-static int ipr_match_res(struct ipr_cmnd *ipr_cmd, void *resource)
-{
-	struct ipr_resource_entry *res = resource;
-
-	if (res && ipr_cmd->ioarcb.res_handle == res->res_handle)
-		return 1;
-	return 0;
-}
-
 /**
  * ipr_wait_for_ops - Wait for matching commands to complete
  * @ioa_cfg:	ioa config struct
@@ -5220,8 +5016,7 @@ static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
  * This function issues a device reset to the affected device.
  * If the device is a SCSI device, a LUN reset will be sent
  * to the device first. If that does not work, a target reset
- * will be sent. If the device is a SATA device, a PHY reset will
- * be sent.
+ * will be sent.
  *
  * Return value:
  *	0 on success / non-zero on failure
@@ -5232,7 +5027,6 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioarcb *ioarcb;
 	struct ipr_cmd_pkt *cmd_pkt;
-	struct ipr_ioarcb_ata_regs *regs;
 	u32 ioasc;
 
 	ENTER;
@@ -5240,86 +5034,21 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
 	ioarcb = &ipr_cmd->ioarcb;
 	cmd_pkt = &ioarcb->cmd_pkt;
 
-	if (ipr_cmd->ioa_cfg->sis64) {
-		regs = &ipr_cmd->i.ata_ioadl.regs;
+	if (ipr_cmd->ioa_cfg->sis64)
 		ioarcb->add_cmd_parms_offset = cpu_to_be16(sizeof(*ioarcb));
-	} else
-		regs = &ioarcb->u.add_data.u.regs;
 
 	ioarcb->res_handle = res->res_handle;
 	cmd_pkt->request_type = IPR_RQTYPE_IOACMD;
 	cmd_pkt->cdb[0] = IPR_RESET_DEVICE;
-	if (ipr_is_gata(res)) {
-		cmd_pkt->cdb[2] = IPR_ATA_PHY_RESET;
-		ioarcb->add_cmd_parms_len = cpu_to_be16(sizeof(regs->flags));
-		regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
-	}
 
 	ipr_send_blocking_cmd(ipr_cmd, ipr_timeout, IPR_DEVICE_RESET_TIMEOUT);
 	ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
-	if (ipr_is_gata(res) && res->sata_port && ioasc != IPR_IOASC_IOA_WAS_RESET) {
-		if (ipr_cmd->ioa_cfg->sis64)
-			memcpy(&res->sata_port->ioasa, &ipr_cmd->s.ioasa64.u.gata,
-			       sizeof(struct ipr_ioasa_gata));
-		else
-			memcpy(&res->sata_port->ioasa, &ipr_cmd->s.ioasa.u.gata,
-			       sizeof(struct ipr_ioasa_gata));
-	}
 
 	LEAVE;
 	return IPR_IOASC_SENSE_KEY(ioasc) ? -EIO : 0;
 }
 
-/**
- * ipr_sata_reset - Reset the SATA port
- * @link:	SATA link to reset
- * @classes:	class of the attached device
- * @deadline:	unused
- *
- * This function issues a SATA phy reset to the affected ATA link.
- *
- * Return value:
- *	0 on success / non-zero on failure
- **/
-static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
-				unsigned long deadline)
-{
-	struct ipr_sata_port *sata_port = link->ap->private_data;
-	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
-	struct ipr_resource_entry *res;
-	unsigned long lock_flags = 0;
-	int rc = -ENXIO, ret;
-
-	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	}
-
-	res = sata_port->res;
-	if (res) {
-		rc = ipr_device_reset(ioa_cfg, res);
-		*classes = res->ata_class;
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-
-		ret = ipr_wait_for_ops(ioa_cfg, res, ipr_match_res);
-		if (ret != SUCCESS) {
-			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-			ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_ABBREV);
-			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-
-			wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		}
-	} else
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-
-	LEAVE;
-	return rc;
-}
-
 /**
  * __ipr_eh_dev_reset - Reset the device
  * @scsi_cmd:	scsi command struct
@@ -5333,12 +5062,9 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
  **/
 static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 {
-	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
-	struct ata_port *ap;
-	int rc = 0, i;
-	struct ipr_hrr_queue *hrrq;
+	int rc = 0;
 
 	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
@@ -5354,36 +5080,10 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 	if (ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead)
 		return FAILED;
 
-	for_each_hrrq(hrrq, ioa_cfg) {
-		spin_lock(&hrrq->_lock);
-		for (i = hrrq->min_cmd_id; i <= hrrq->max_cmd_id; i++) {
-			ipr_cmd = ioa_cfg->ipr_cmnd_list[i];
-
-			if (ipr_cmd->ioarcb.res_handle == res->res_handle) {
-				if (!ipr_cmd->qc)
-					continue;
-				if (ipr_cmnd_is_free(ipr_cmd))
-					continue;
-
-				ipr_cmd->done = ipr_sata_eh_done;
-				if (!(ipr_cmd->qc->flags & ATA_QCFLAG_EH)) {
-					ipr_cmd->qc->err_mask |= AC_ERR_TIMEOUT;
-					ipr_cmd->qc->flags |= ATA_QCFLAG_EH;
-				}
-			}
-		}
-		spin_unlock(&hrrq->_lock);
-	}
 	res->resetting_device = 1;
 	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
 
-	if (ipr_is_gata(res) && res->sata_port) {
-		ap = res->sata_port->ap;
-		spin_unlock_irq(scsi_cmd->device->host->host_lock);
-		ata_std_error_handler(ap);
-		spin_lock_irq(scsi_cmd->device->host->host_lock);
-	} else
-		rc = ipr_device_reset(ioa_cfg, res);
+	rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
 	res->reset_occurred = 1;
 
@@ -5407,12 +5107,8 @@ static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
 	rc = __ipr_eh_dev_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
 
-	if (rc == SUCCESS) {
-		if (ipr_is_gata(res) && res->sata_port)
-			rc = ipr_wait_for_ops(ioa_cfg, res, ipr_match_res);
-		else
-			rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
-	}
+	if (rc == SUCCESS)
+		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
 
 	return rc;
 }
@@ -6564,7 +6260,7 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	struct ipr_resource_entry *res;
 	struct ipr_ioarcb *ioarcb;
 	struct ipr_cmnd *ipr_cmd;
-	unsigned long hrrq_flags, lock_flags;
+	unsigned long hrrq_flags;
 	int rc;
 	struct ipr_hrr_queue *hrrq;
 	int hrrq_id;
@@ -6574,13 +6270,6 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	scsi_cmd->result = (DID_OK << 16);
 	res = scsi_cmd->device->hostdata;
 
-	if (ipr_is_gata(res) && res->sata_port) {
-		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-		rc = ata_sas_queuecmd(scsi_cmd, res->sata_port->ap);
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-		return rc;
-	}
-
 	hrrq_id = ipr_get_hrrq_index(ioa_cfg);
 	hrrq = &ioa_cfg->hrrq[hrrq_id];
 
@@ -6690,30 +6379,6 @@ static int ipr_queuecommand(struct Scsi_Host *shost,
 	return 0;
 }
 
-/**
- * ipr_ioctl - IOCTL handler
- * @sdev:	scsi device struct
- * @cmd:	IOCTL cmd
- * @arg:	IOCTL arg
- *
- * Return value:
- * 	0 on success / other on failure
- **/
-static int ipr_ioctl(struct scsi_device *sdev, unsigned int cmd,
-		     void __user *arg)
-{
-	struct ipr_resource_entry *res;
-
-	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res && ipr_is_gata(res)) {
-		if (cmd == HDIO_GET_IDENTITY)
-			return -ENOTTY;
-		return ata_sas_scsi_ioctl(res->sata_port->ap, sdev, cmd, arg);
-	}
-
-	return -EINVAL;
-}
-
 /**
  * ipr_ioa_info - Get information about the card/driver
  * @host:	scsi host struct
@@ -6740,12 +6405,7 @@ static const struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IPR",
 	.info = ipr_ioa_info,
-	.ioctl = ipr_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl = ipr_ioctl,
-#endif
 	.queuecommand = ipr_queuecommand,
-	.dma_need_drain = ata_scsi_dma_need_drain,
 	.eh_abort_handler = ipr_eh_abort,
 	.eh_device_reset_handler = ipr_eh_dev_reset,
 	.eh_host_reset_handler = ipr_eh_host_reset,
@@ -6753,7 +6413,6 @@ static const struct scsi_host_template driver_template = {
 	.slave_configure = ipr_slave_configure,
 	.slave_destroy = ipr_slave_destroy,
 	.scan_finished = ipr_scan_finished,
-	.target_alloc = ipr_target_alloc,
 	.target_destroy = ipr_target_destroy,
 	.change_queue_depth = ipr_change_queue_depth,
 	.bios_param = ipr_biosparam,
@@ -6767,418 +6426,6 @@ static const struct scsi_host_template driver_template = {
 	.proc_name = IPR_NAME,
 };
 
-/**
- * ipr_ata_phy_reset - libata phy_reset handler
- * @ap:		ata port to reset
- *
- **/
-static void ipr_ata_phy_reset(struct ata_port *ap)
-{
-	unsigned long flags;
-	struct ipr_sata_port *sata_port = ap->private_data;
-	struct ipr_resource_entry *res = sata_port->res;
-	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
-	int rc;
-
-	ENTER;
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
-		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	}
-
-	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds)
-		goto out_unlock;
-
-	rc = ipr_device_reset(ioa_cfg, res);
-
-	if (rc) {
-		ap->link.device[0].class = ATA_DEV_NONE;
-		goto out_unlock;
-	}
-
-	ap->link.device[0].class = res->ata_class;
-	if (ap->link.device[0].class == ATA_DEV_UNKNOWN)
-		ap->link.device[0].class = ATA_DEV_NONE;
-
-out_unlock:
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
-	LEAVE;
-}
-
-/**
- * ipr_ata_post_internal - Cleanup after an internal command
- * @qc:	ATA queued command
- *
- * Return value:
- * 	none
- **/
-static void ipr_ata_post_internal(struct ata_queued_cmd *qc)
-{
-	struct ipr_sata_port *sata_port = qc->ap->private_data;
-	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
-	struct ipr_cmnd *ipr_cmd;
-	struct ipr_hrr_queue *hrrq;
-	unsigned long flags;
-
-	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	while (ioa_cfg->in_reset_reload) {
-		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
-		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
-		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	}
-
-	for_each_hrrq(hrrq, ioa_cfg) {
-		spin_lock(&hrrq->_lock);
-		list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
-			if (ipr_cmd->qc == qc) {
-				ipr_device_reset(ioa_cfg, sata_port->res);
-				break;
-			}
-		}
-		spin_unlock(&hrrq->_lock);
-	}
-	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
-}
-
-/**
- * ipr_copy_sata_tf - Copy a SATA taskfile to an IOA data structure
- * @regs:	destination
- * @tf:	source ATA taskfile
- *
- * Return value:
- * 	none
- **/
-static void ipr_copy_sata_tf(struct ipr_ioarcb_ata_regs *regs,
-			     struct ata_taskfile *tf)
-{
-	regs->feature = tf->feature;
-	regs->nsect = tf->nsect;
-	regs->lbal = tf->lbal;
-	regs->lbam = tf->lbam;
-	regs->lbah = tf->lbah;
-	regs->device = tf->device;
-	regs->command = tf->command;
-	regs->hob_feature = tf->hob_feature;
-	regs->hob_nsect = tf->hob_nsect;
-	regs->hob_lbal = tf->hob_lbal;
-	regs->hob_lbam = tf->hob_lbam;
-	regs->hob_lbah = tf->hob_lbah;
-	regs->ctl = tf->ctl;
-}
-
-/**
- * ipr_sata_done - done function for SATA commands
- * @ipr_cmd:	ipr command struct
- *
- * This function is invoked by the interrupt handler for
- * ops generated by the SCSI mid-layer to SATA devices
- *
- * Return value:
- * 	none
- **/
-static void ipr_sata_done(struct ipr_cmnd *ipr_cmd)
-{
-	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
-	struct ata_queued_cmd *qc = ipr_cmd->qc;
-	struct ipr_sata_port *sata_port = qc->ap->private_data;
-	struct ipr_resource_entry *res = sata_port->res;
-	u32 ioasc = be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc);
-
-	spin_lock(&ipr_cmd->hrrq->_lock);
-	if (ipr_cmd->ioa_cfg->sis64)
-		memcpy(&sata_port->ioasa, &ipr_cmd->s.ioasa64.u.gata,
-		       sizeof(struct ipr_ioasa_gata));
-	else
-		memcpy(&sata_port->ioasa, &ipr_cmd->s.ioasa.u.gata,
-		       sizeof(struct ipr_ioasa_gata));
-	ipr_dump_ioasa(ioa_cfg, ipr_cmd, res);
-
-	if (be32_to_cpu(ipr_cmd->s.ioasa.hdr.ioasc_specific) & IPR_ATA_DEVICE_WAS_RESET)
-		scsi_report_device_reset(ioa_cfg->host, res->bus, res->target);
-
-	if (IPR_IOASC_SENSE_KEY(ioasc) > RECOVERED_ERROR)
-		qc->err_mask |= __ac_err_mask(sata_port->ioasa.status);
-	else
-		qc->err_mask |= ac_err_mask(sata_port->ioasa.status);
-	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
-	spin_unlock(&ipr_cmd->hrrq->_lock);
-	ata_qc_complete(qc);
-}
-
-/**
- * ipr_build_ata_ioadl64 - Build an ATA scatter/gather list
- * @ipr_cmd:	ipr command struct
- * @qc:		ATA queued command
- *
- **/
-static void ipr_build_ata_ioadl64(struct ipr_cmnd *ipr_cmd,
-				  struct ata_queued_cmd *qc)
-{
-	u32 ioadl_flags = 0;
-	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
-	struct ipr_ioadl64_desc *ioadl64 = ipr_cmd->i.ata_ioadl.ioadl64;
-	struct ipr_ioadl64_desc *last_ioadl64 = NULL;
-	int len = qc->nbytes;
-	struct scatterlist *sg;
-	unsigned int si;
-	dma_addr_t dma_addr = ipr_cmd->dma_addr;
-
-	if (len == 0)
-		return;
-
-	if (qc->dma_dir == DMA_TO_DEVICE) {
-		ioadl_flags = IPR_IOADL_FLAGS_WRITE;
-		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
-	} else if (qc->dma_dir == DMA_FROM_DEVICE)
-		ioadl_flags = IPR_IOADL_FLAGS_READ;
-
-	ioarcb->data_transfer_length = cpu_to_be32(len);
-	ioarcb->ioadl_len =
-		cpu_to_be32(sizeof(struct ipr_ioadl64_desc) * ipr_cmd->dma_use_sg);
-	ioarcb->u.sis64_addr_data.data_ioadl_addr =
-		cpu_to_be64(dma_addr + offsetof(struct ipr_cmnd, i.ata_ioadl.ioadl64));
-
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		ioadl64->flags = cpu_to_be32(ioadl_flags);
-		ioadl64->data_len = cpu_to_be32(sg_dma_len(sg));
-		ioadl64->address = cpu_to_be64(sg_dma_address(sg));
-
-		last_ioadl64 = ioadl64;
-		ioadl64++;
-	}
-
-	if (likely(last_ioadl64))
-		last_ioadl64->flags |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
-}
-
-/**
- * ipr_build_ata_ioadl - Build an ATA scatter/gather list
- * @ipr_cmd:	ipr command struct
- * @qc:		ATA queued command
- *
- **/
-static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
-				struct ata_queued_cmd *qc)
-{
-	u32 ioadl_flags = 0;
-	struct ipr_ioarcb *ioarcb = &ipr_cmd->ioarcb;
-	struct ipr_ioadl_desc *ioadl = ipr_cmd->i.ioadl;
-	struct ipr_ioadl_desc *last_ioadl = NULL;
-	int len = qc->nbytes;
-	struct scatterlist *sg;
-	unsigned int si;
-
-	if (len == 0)
-		return;
-
-	if (qc->dma_dir == DMA_TO_DEVICE) {
-		ioadl_flags = IPR_IOADL_FLAGS_WRITE;
-		ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_WRITE_NOT_READ;
-		ioarcb->data_transfer_length = cpu_to_be32(len);
-		ioarcb->ioadl_len =
-			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
-	} else if (qc->dma_dir == DMA_FROM_DEVICE) {
-		ioadl_flags = IPR_IOADL_FLAGS_READ;
-		ioarcb->read_data_transfer_length = cpu_to_be32(len);
-		ioarcb->read_ioadl_len =
-			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
-	}
-
-	for_each_sg(qc->sg, sg, qc->n_elem, si) {
-		ioadl->flags_and_data_len = cpu_to_be32(ioadl_flags | sg_dma_len(sg));
-		ioadl->address = cpu_to_be32(sg_dma_address(sg));
-
-		last_ioadl = ioadl;
-		ioadl++;
-	}
-
-	if (likely(last_ioadl))
-		last_ioadl->flags_and_data_len |= cpu_to_be32(IPR_IOADL_FLAGS_LAST);
-}
-
-/**
- * ipr_qc_defer - Get a free ipr_cmd
- * @qc:	queued command
- *
- * Return value:
- *	0 if success
- **/
-static int ipr_qc_defer(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ipr_sata_port *sata_port = ap->private_data;
-	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
-	struct ipr_cmnd *ipr_cmd;
-	struct ipr_hrr_queue *hrrq;
-	int hrrq_id;
-
-	hrrq_id = ipr_get_hrrq_index(ioa_cfg);
-	hrrq = &ioa_cfg->hrrq[hrrq_id];
-
-	qc->lldd_task = NULL;
-	spin_lock(&hrrq->_lock);
-	if (unlikely(hrrq->ioa_is_dead)) {
-		spin_unlock(&hrrq->_lock);
-		return 0;
-	}
-
-	if (unlikely(!hrrq->allow_cmds)) {
-		spin_unlock(&hrrq->_lock);
-		return ATA_DEFER_LINK;
-	}
-
-	ipr_cmd = __ipr_get_free_ipr_cmnd(hrrq);
-	if (ipr_cmd == NULL) {
-		spin_unlock(&hrrq->_lock);
-		return ATA_DEFER_LINK;
-	}
-
-	qc->lldd_task = ipr_cmd;
-	spin_unlock(&hrrq->_lock);
-	return 0;
-}
-
-/**
- * ipr_qc_issue - Issue a SATA qc to a device
- * @qc:	queued command
- *
- * Return value:
- * 	0 if success
- **/
-static unsigned int ipr_qc_issue(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-	struct ipr_sata_port *sata_port = ap->private_data;
-	struct ipr_resource_entry *res = sata_port->res;
-	struct ipr_ioa_cfg *ioa_cfg = sata_port->ioa_cfg;
-	struct ipr_cmnd *ipr_cmd;
-	struct ipr_ioarcb *ioarcb;
-	struct ipr_ioarcb_ata_regs *regs;
-
-	if (qc->lldd_task == NULL)
-		ipr_qc_defer(qc);
-
-	ipr_cmd = qc->lldd_task;
-	if (ipr_cmd == NULL)
-		return AC_ERR_SYSTEM;
-
-	qc->lldd_task = NULL;
-	spin_lock(&ipr_cmd->hrrq->_lock);
-	if (unlikely(!ipr_cmd->hrrq->allow_cmds ||
-			ipr_cmd->hrrq->ioa_is_dead)) {
-		list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
-		spin_unlock(&ipr_cmd->hrrq->_lock);
-		return AC_ERR_SYSTEM;
-	}
-
-	ipr_init_ipr_cmnd(ipr_cmd, ipr_lock_and_done);
-	ioarcb = &ipr_cmd->ioarcb;
-
-	if (ioa_cfg->sis64) {
-		regs = &ipr_cmd->i.ata_ioadl.regs;
-		ioarcb->add_cmd_parms_offset = cpu_to_be16(sizeof(*ioarcb));
-	} else
-		regs = &ioarcb->u.add_data.u.regs;
-
-	memset(regs, 0, sizeof(*regs));
-	ioarcb->add_cmd_parms_len = cpu_to_be16(sizeof(*regs));
-
-	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_pending_q);
-	ipr_cmd->qc = qc;
-	ipr_cmd->done = ipr_sata_done;
-	ipr_cmd->ioarcb.res_handle = res->res_handle;
-	ioarcb->cmd_pkt.request_type = IPR_RQTYPE_ATA_PASSTHRU;
-	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_LINK_DESC;
-	ioarcb->cmd_pkt.flags_hi |= IPR_FLAGS_HI_NO_ULEN_CHK;
-	ipr_cmd->dma_use_sg = qc->n_elem;
-
-	if (ioa_cfg->sis64)
-		ipr_build_ata_ioadl64(ipr_cmd, qc);
-	else
-		ipr_build_ata_ioadl(ipr_cmd, qc);
-
-	regs->flags |= IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION;
-	ipr_copy_sata_tf(regs, &qc->tf);
-	memcpy(ioarcb->cmd_pkt.cdb, qc->cdb, IPR_MAX_CDB_LEN);
-	ipr_trc_hook(ipr_cmd, IPR_TRACE_START, IPR_GET_RES_PHYS_LOC(res));
-
-	switch (qc->tf.protocol) {
-	case ATA_PROT_NODATA:
-	case ATA_PROT_PIO:
-		break;
-
-	case ATA_PROT_DMA:
-		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
-		break;
-
-	case ATAPI_PROT_PIO:
-	case ATAPI_PROT_NODATA:
-		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
-		break;
-
-	case ATAPI_PROT_DMA:
-		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
-		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
-		break;
-
-	default:
-		WARN_ON(1);
-		spin_unlock(&ipr_cmd->hrrq->_lock);
-		return AC_ERR_INVALID;
-	}
-
-	ipr_send_command(ipr_cmd);
-	spin_unlock(&ipr_cmd->hrrq->_lock);
-
-	return 0;
-}
-
-/**
- * ipr_qc_fill_rtf - Read result TF
- * @qc: ATA queued command
- **/
-static void ipr_qc_fill_rtf(struct ata_queued_cmd *qc)
-{
-	struct ipr_sata_port *sata_port = qc->ap->private_data;
-	struct ipr_ioasa_gata *g = &sata_port->ioasa;
-	struct ata_taskfile *tf = &qc->result_tf;
-
-	tf->feature = g->error;
-	tf->nsect = g->nsect;
-	tf->lbal = g->lbal;
-	tf->lbam = g->lbam;
-	tf->lbah = g->lbah;
-	tf->device = g->device;
-	tf->command = g->status;
-	tf->hob_nsect = g->hob_nsect;
-	tf->hob_lbal = g->hob_lbal;
-	tf->hob_lbam = g->hob_lbam;
-	tf->hob_lbah = g->hob_lbah;
-}
-
-static struct ata_port_operations ipr_sata_ops = {
-	.phy_reset = ipr_ata_phy_reset,
-	.hardreset = ipr_sata_reset,
-	.post_internal_cmd = ipr_ata_post_internal,
-	.qc_prep = ata_noop_qc_prep,
-	.qc_defer = ipr_qc_defer,
-	.qc_issue = ipr_qc_issue,
-	.qc_fill_rtf = ipr_qc_fill_rtf,
-	.port_start = ata_sas_port_start,
-	.port_stop = ata_sas_port_stop
-};
-
-static struct ata_port_info sata_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
-			  ATA_FLAG_SAS_HOST,
-	.pio_mask	= ATA_PIO4_ONLY,
-	.mwdma_mask	= ATA_MWDMA2,
-	.udma_mask	= ATA_UDMA6,
-	.port_ops	= &ipr_sata_ops
-};
-
 #ifdef CONFIG_PPC_PSERIES
 static const u16 ipr_blocked_processors[] = {
 	PVR_NORTHSTAR,
@@ -10181,7 +9428,6 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 
 	ioa_cfg = (struct ipr_ioa_cfg *)host->hostdata;
 	memset(ioa_cfg, 0, sizeof(struct ipr_ioa_cfg));
-	ata_host_init(&ioa_cfg->ata_host, &pdev->dev, &ipr_sata_ops);
 
 	ioa_cfg->ipr_chip = ipr_get_chip_info(dev_id);
 
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 69444d21fca1..c77d6ca1a210 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -16,7 +16,6 @@
 #include <asm/unaligned.h>
 #include <linux/types.h>
 #include <linux/completion.h>
-#include <linux/libata.h>
 #include <linux/list.h>
 #include <linux/kref.h>
 #include <linux/irq_poll.h>
@@ -35,7 +34,6 @@
  *	This can be adjusted at runtime through sysfs device attributes.
  */
 #define IPR_MAX_CMD_PER_LUN				6
-#define IPR_MAX_CMD_PER_ATA_LUN			1
 
 /*
  * IPR_NUM_BASE_CMD_BLKS: This defines the maximum number of
@@ -197,7 +195,6 @@
 #define	IPR_LUN_RESET					0x40
 #define	IPR_TARGET_RESET					0x20
 #define	IPR_BUS_RESET					0x10
-#define	IPR_ATA_PHY_RESET					0x80
 #define IPR_ID_HOST_RR_Q				0xC4
 #define IPR_QUERY_IOA_CONFIG				0xC5
 #define IPR_CANCEL_ALL_REQUESTS			0xCE
@@ -521,7 +518,6 @@ struct ipr_cmd_pkt {
 #define IPR_RQTYPE_SCSICDB		0x00
 #define IPR_RQTYPE_IOACMD		0x01
 #define IPR_RQTYPE_HCAM			0x02
-#define IPR_RQTYPE_ATA_PASSTHRU	0x04
 #define IPR_RQTYPE_PIPE			0x05
 
 	u8 reserved2;
@@ -546,30 +542,6 @@ struct ipr_cmd_pkt {
 	__be16 timeout;
 }__attribute__ ((packed, aligned(4)));
 
-struct ipr_ioarcb_ata_regs {	/* 22 bytes */
-	u8 flags;
-#define IPR_ATA_FLAG_PACKET_CMD			0x80
-#define IPR_ATA_FLAG_XFER_TYPE_DMA			0x40
-#define IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION	0x20
-	u8 reserved[3];
-
-	__be16 data;
-	u8 feature;
-	u8 nsect;
-	u8 lbal;
-	u8 lbam;
-	u8 lbah;
-	u8 device;
-	u8 command;
-	u8 reserved2[3];
-	u8 hob_feature;
-	u8 hob_nsect;
-	u8 hob_lbal;
-	u8 hob_lbam;
-	u8 hob_lbah;
-	u8 ctl;
-}__attribute__ ((packed, aligned(2)));
-
 struct ipr_ioadl_desc {
 	__be32 flags_and_data_len;
 #define IPR_IOADL_FLAGS_MASK		0xff000000
@@ -591,15 +563,8 @@ struct ipr_ioadl64_desc {
 	__be64 address;
 }__attribute__((packed, aligned (16)));
 
-struct ipr_ata64_ioadl {
-	struct ipr_ioarcb_ata_regs regs;
-	u16 reserved[5];
-	struct ipr_ioadl64_desc ioadl64[IPR_NUM_IOADL_ENTRIES];
-}__attribute__((packed, aligned (16)));
-
 struct ipr_ioarcb_add_data {
 	union {
-		struct ipr_ioarcb_ata_regs regs;
 		struct ipr_ioadl_desc ioadl[5];
 		__be32 add_cmd_parms[10];
 	} u;
@@ -665,21 +630,6 @@ struct ipr_ioasa_gpdd {
 	__be32 ioa_data[2];
 }__attribute__((packed, aligned (4)));
 
-struct ipr_ioasa_gata {
-	u8 error;
-	u8 nsect;		/* Interrupt reason */
-	u8 lbal;
-	u8 lbam;
-	u8 lbah;
-	u8 device;
-	u8 status;
-	u8 alt_status;	/* ATA CTL */
-	u8 hob_nsect;
-	u8 hob_lbal;
-	u8 hob_lbam;
-	u8 hob_lbah;
-}__attribute__((packed, aligned (4)));
-
 struct ipr_auto_sense {
 	__be16 auto_sense_len;
 	__be16 ioa_data_len;
@@ -713,7 +663,6 @@ struct ipr_ioasa_hdr {
 	__be32 ioasc_specific;	/* status code specific field */
 #define IPR_ADDITIONAL_STATUS_FMT		0x80000000
 #define IPR_AUTOSENSE_VALID			0x40000000
-#define IPR_ATA_DEVICE_WAS_RESET		0x20000000
 #define IPR_IOASC_SPECIFIC_MASK		0x00ffffff
 #define IPR_FIELD_POINTER_VALID		(0x80000000 >> 8)
 #define IPR_FIELD_POINTER_MASK		0x0000ffff
@@ -727,7 +676,6 @@ struct ipr_ioasa {
 		struct ipr_ioasa_vset vset;
 		struct ipr_ioasa_af_dasd dasd;
 		struct ipr_ioasa_gpdd gpdd;
-		struct ipr_ioasa_gata gata;
 	} u;
 
 	struct ipr_auto_sense auto_sense;
@@ -741,7 +689,6 @@ struct ipr_ioasa64 {
 		struct ipr_ioasa_vset vset;
 		struct ipr_ioasa_af_dasd dasd;
 		struct ipr_ioasa_gpdd gpdd;
-		struct ipr_ioasa_gata gata;
 	} u;
 
 	struct ipr_auto_sense auto_sense;
@@ -1279,13 +1226,6 @@ struct ipr_bus_attributes {
 	u32 max_xfer_rate;
 };
 
-struct ipr_sata_port {
-	struct ipr_ioa_cfg *ioa_cfg;
-	struct ata_port *ap;
-	struct ipr_resource_entry *res;
-	struct ipr_ioasa_gata ioasa;
-};
-
 struct ipr_resource_entry {
 	u8 needs_sync_complete:1;
 	u8 in_erp:1;
@@ -1323,7 +1263,6 @@ struct ipr_resource_entry {
 
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct scsi_device *sdev;
-	struct ipr_sata_port *sata_port;
 	struct list_head queue;
 }; /* struct ipr_resource_entry */
 
@@ -1582,7 +1521,6 @@ struct ipr_ioa_cfg {
 	struct ipr_cmnd *reset_cmd;
 	int (*reset) (struct ipr_cmnd *);
 
-	struct ata_host ata_host;
 	char ipr_cmd_label[8];
 #define IPR_CMD_LABEL		"ipr_cmd"
 	u32 max_cmds;
@@ -1604,7 +1542,6 @@ struct ipr_cmnd {
 	union {
 		struct ipr_ioadl_desc ioadl[IPR_NUM_IOADL_ENTRIES];
 		struct ipr_ioadl64_desc ioadl64[IPR_NUM_IOADL_ENTRIES];
-		struct ipr_ata64_ioadl ata_ioadl;
 	} i;
 	union {
 		struct ipr_ioasa ioasa;
@@ -1612,7 +1549,6 @@ struct ipr_cmnd {
 	} s;
 	struct list_head queue;
 	struct scsi_cmnd *scsi_cmd;
-	struct ata_queued_cmd *qc;
 	struct completion completion;
 	struct timer_list timer;
 	struct work_struct work;
-- 
2.31.1

