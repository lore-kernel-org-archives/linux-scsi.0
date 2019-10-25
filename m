Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9E7CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EAC321D7B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 22:28:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="o3jH7uGf";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Fyn0XPSG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfJYW23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 18:28:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33790 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726388AbfJYW23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 18:28:29 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0926B8EE1D1;
        Fri, 25 Oct 2019 15:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1572042509;
        bh=T9lVlPPusTDiK2b8Yf+PwPt5cs36dDin/6Lel6zHVdo=;
        h=Subject:From:To:Cc:Date:From;
        b=o3jH7uGfrLM3UHKKrjPO7UenrLQ1jwmwz+rWZwnS9YmkoAxY8rHL3l+/gHtaIRtM1
         mZ4Im1MhhSpQoh1rAQRWioAr8KmKXxlkFwM7+hk++eH0If0ppPrnnJero6wiySOKPt
         mEu8Gjj+LCmc5KZPnAsL4SoFAZUsgua8ESiWq7LE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sjdzgV2Jp0ua; Fri, 25 Oct 2019 15:28:28 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 844FE8EE0D2;
        Fri, 25 Oct 2019 15:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1572042508;
        bh=T9lVlPPusTDiK2b8Yf+PwPt5cs36dDin/6Lel6zHVdo=;
        h=Subject:From:To:Cc:Date:From;
        b=Fyn0XPSGsq/A5xIX8zbyCm31VQHLTybd+uf6i9+Pig6V9uO3a/qHsfTMpiFsGblK1
         Fddws/NXPk91nLb/Yovn4t4lTiNKQ8K/tX9GYhz/gyMJVjAQtXq8IOVNuEvdh6dax+
         +4ahI7s4qgGwKyTXpbQeUyyfPABlMk0Cnlq411S4=
Message-ID: <1572042507.11722.5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.4-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 25 Oct 2019 15:28:27 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Nine changes, eight to drivers (qla2xxx, hpsa, lpfc, alua, ch,
53c710[x2], target) and one core change that tries to close a race
between sysfs delete and module removal.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Allen Pais (1):
      scsi: qla2xxx: fix a potential NULL pointer dereference

Bart Van Assche (1):
      scsi: ch: Make it possible to open a ch device multiple times again

Bodo Stroesser (1):
      scsi: target: core: Do not overwrite CDB byte 1

Don Brace (1):
      scsi: hpsa: add missing hunks in reset-patch

Hannes Reinecke (2):
      scsi: lpfc: remove left-over BUILD_NVME defines
      scsi: scsi_dh_alua: handle RTPG sense code correctly during state transitions

Thomas Bogendoerfer (2):
      scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE
      scsi: sni_53c710: fix compilation error

Yufen Yu (1):
      scsi: core: try to get module before removing device

And the diffstat:

 drivers/scsi/Kconfig                       |  2 +-
 drivers/scsi/ch.c                          |  1 -
 drivers/scsi/device_handler/scsi_dh_alua.c | 21 ++++++++++++++++-----
 drivers/scsi/hpsa.c                        |  4 ++++
 drivers/scsi/lpfc/lpfc_init.c              |  2 --
 drivers/scsi/lpfc/lpfc_scsi.c              |  2 --
 drivers/scsi/qla2xxx/qla_os.c              |  4 ++++
 drivers/scsi/scsi_sysfs.c                  | 11 ++++++++++-
 drivers/scsi/sni_53c710.c                  |  4 +---
 drivers/target/target_core_device.c        | 21 ---------------------
 10 files changed, 36 insertions(+), 36 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 75f66f8ad3ea..d00e1ee09af3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -898,7 +898,7 @@ config SCSI_SNI_53C710
 
 config 53C700_LE_ON_BE
 	bool
-	depends on SCSI_LASI700
+	depends on SCSI_LASI700 || SCSI_SNI_53C710
 	default y
 
 config SCSI_STEX
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 5f8153c37f77..76751d6c7f0d 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -579,7 +579,6 @@ ch_release(struct inode *inode, struct file *file)
 	scsi_changer *ch = file->private_data;
 
 	scsi_device_put(ch->device);
-	ch->device = NULL;
 	file->private_data = NULL;
 	kref_put(&ch->ref, ch_destroy);
 	return 0;
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f0066f8a1786..c6437a442ffc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -511,6 +511,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
+	bool transitioning_sense = false;
 
 	if (!pg->expiry) {
 		unsigned long transition_tmo = ALUA_FAILOVER_TIMEOUT * HZ;
@@ -571,13 +572,19 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			goto retry;
 		}
 		/*
-		 * Retry on ALUA state transition or if any
-		 * UNIT ATTENTION occurred.
+		 * If the array returns with 'ALUA state transition'
+		 * sense code here it cannot return RTPG data during
+		 * transition. So set the state to 'transitioning' directly.
 		 */
 		if (sense_hdr.sense_key == NOT_READY &&
-		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
-			err = SCSI_DH_RETRY;
-		else if (sense_hdr.sense_key == UNIT_ATTENTION)
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
+			transitioning_sense = true;
+			goto skip_rtpg;
+		}
+		/*
+		 * Retry on any other UNIT ATTENTION occurred.
+		 */
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
 			err = SCSI_DH_RETRY;
 		if (err == SCSI_DH_RETRY &&
 		    pg->expiry != 0 && time_before(jiffies, pg->expiry)) {
@@ -665,7 +672,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		off = 8 + (desc[7] * 4);
 	}
 
+ skip_rtpg:
 	spin_lock_irqsave(&pg->lock, flags);
+	if (transitioning_sense)
+		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
+
 	sdev_printk(KERN_INFO, sdev,
 		    "%s: port group %02x state %c %s supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, pg->group_id, print_alua_state(pg->state),
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 43a6b5350775..d93a5b20b9d1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5474,6 +5474,8 @@ static int hpsa_ciss_submit(struct ctlr_info *h,
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	c->device = dev;
+
 	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
 	return 0;
@@ -5545,6 +5547,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		hpsa_cmd_init(h, c->cmdindex, c);
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
+		c->device = dev;
 		rc = hpsa_scsi_ioaccel_raid_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
@@ -5552,6 +5555,7 @@ static int hpsa_ioaccel_submit(struct ctlr_info *h,
 		hpsa_cmd_init(h, c->cmdindex, c);
 		c->cmd_type = CMD_SCSI;
 		c->scsi_cmd = cmd;
+		c->device = dev;
 		rc = hpsa_scsi_ioaccel_direct_map(h, c);
 		if (rc < 0)     /* scsi_dma_map failed. */
 			rc = SCSI_MLQUEUE_HOST_BUSY;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index de64880c6c60..2c1e085bd3ce 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9053,7 +9053,6 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 		}
 	}
 
-#if defined(BUILD_NVME)
 	/* Clear NVME stats */
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
 		for (idx = 0; idx < phba->cfg_hdw_queue; idx++) {
@@ -9061,7 +9060,6 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 			       sizeof(phba->sli4_hba.hdwq[idx].nvme_cstat));
 		}
 	}
-#endif
 
 	/* Clear SCSI stats */
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP) {
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index fe1097666de4..6822cd9ff8f1 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -528,7 +528,6 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 			list_del_init(&psb->list);
 			psb->exch_busy = 0;
 			psb->status = IOSTAT_SUCCESS;
-#ifdef BUILD_NVME
 			if (psb->cur_iocbq.iocb_flag == LPFC_IO_NVME) {
 				qp->abts_nvme_io_bufs--;
 				spin_unlock(&qp->abts_io_buf_list_lock);
@@ -536,7 +535,6 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 				lpfc_sli4_nvme_xri_aborted(phba, axri, psb);
 				return;
 			}
-#endif
 			qp->abts_scsi_io_bufs--;
 			spin_unlock(&qp->abts_io_buf_list_lock);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ee47de9fbc05..e4d765fc03ea 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3224,6 +3224,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    req->req_q_in, req->req_q_out, rsp->rsp_q_in, rsp->rsp_q_out);
 
 	ha->wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+	if (unlikely(!ha->wq)) {
+		ret = -ENOMEM;
+		goto probe_failed;
+	}
 
 	if (ha->isp_ops->initialize_adapter(base_vha)) {
 		ql_log(ql_log_fatal, base_vha, 0x00d6,
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 64c96c7828ee..6d7362e7367e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -730,6 +730,14 @@ sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
 	struct kernfs_node *kn;
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	/*
+	 * We need to try to get module, avoiding the module been removed
+	 * during delete.
+	 */
+	if (scsi_device_get(sdev))
+		return -ENODEV;
 
 	kn = sysfs_break_active_protection(&dev->kobj, &attr->attr);
 	WARN_ON_ONCE(!kn);
@@ -744,9 +752,10 @@ sdev_store_delete(struct device *dev, struct device_attribute *attr,
 	 * state into SDEV_DEL.
 	 */
 	device_remove_file(dev, attr);
-	scsi_remove_device(to_scsi_device(dev));
+	scsi_remove_device(sdev);
 	if (kn)
 		sysfs_unbreak_active_protection(kn);
+	scsi_device_put(sdev);
 	return count;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index aef4881d8e21..a85d52b5dc32 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -66,10 +66,8 @@ static int snirm710_probe(struct platform_device *dev)
 
 	base = res->start;
 	hostdata = kzalloc(sizeof(*hostdata), GFP_KERNEL);
-	if (!hostdata) {
-		dev_printk(KERN_ERR, dev, "Failed to allocate host data\n");
+	if (!hostdata)
 		return -ENOMEM;
-	}
 
 	hostdata->dev = &dev->dev;
 	dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 04bf2acd3800..2d19f0e332b0 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1074,27 +1074,6 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	struct se_device *dev = cmd->se_dev;
 	unsigned int size;
 
-	/*
-	 * Clear a lun set in the cdb if the initiator talking to use spoke
-	 * and old standards version, as we can't assume the underlying device
-	 * won't choke up on it.
-	 */
-	switch (cdb[0]) {
-	case READ_10: /* SBC - RDProtect */
-	case READ_12: /* SBC - RDProtect */
-	case READ_16: /* SBC - RDProtect */
-	case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code */
-	case VERIFY: /* SBC - VRProtect */
-	case VERIFY_16: /* SBC - VRProtect */
-	case WRITE_VERIFY: /* SBC - VRProtect */
-	case WRITE_VERIFY_12: /* SBC - VRProtect */
-	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
-		break;
-	default:
-		cdb[1] &= 0x1f; /* clear logical unit number */
-		break;
-	}
-
 	/*
 	 * For REPORT LUNS we always need to emulate the response, for everything
 	 * else, pass it up.
