From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.9-rc7
Date: Tue, 29 Nov 2016 10:55:04 -0800
Message-ID: <1480445704.2424.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51584 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751227AbcK2SzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 13:55:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Four small fixes.  The be2iscsi is a potential device overrun in
consistent memory, which could have nasty consequences if the
consistent allocations are packed.  The hpsa one fixes a regression
where older controllers can now get a numbering clash between the first
internal disk and the controller. The libfc one is a regression in
timespec conversions which causes a user visible issue in a command
line tool and the mpt3sas one fixes a regression where the controller
could remain permanently blocked after an ATA pass through command
followed by a reset.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      scsi: be2iscsi: allocate enough memory in beiscsi_boot_get_sinfo()

Hannes Reinecke (1):
      scsi: hpsa: use bus '3' for legacy HBA devices

Johannes Thumshirn (1):
      scsi: libfc: fix seconds_since_last_reset miscalculation

Suganath Prabu S (1):
      scsi: mpt3sas: Unblock device after controller reset

And the diffstat:

 drivers/scsi/be2iscsi/be_mgmt.c      |  2 +-
 drivers/scsi/hpsa.c                  | 16 +++++++++++-----
 drivers/scsi/hpsa.h                  |  2 ++
 drivers/scsi/libfc/fc_lport.c        |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 13 ++++++++-----
 5 files changed, 23 insertions(+), 12 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index aebc4dd..ac05317 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1083,7 +1083,7 @@ unsigned int beiscsi_boot_get_sinfo(struct beiscsi_hba *phba)
 	nonemb_cmd = &phba->boot_struct.nonemb_cmd;
 	nonemb_cmd->size = sizeof(*resp);
 	nonemb_cmd->va = pci_alloc_consistent(phba->ctrl.pdev,
-					      sizeof(nonemb_cmd->size),
+					      nonemb_cmd->size,
 					      &nonemb_cmd->dma);
 	if (!nonemb_cmd->va) {
 		mutex_unlock(&ctrl->mbox_lock);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index d007ec1..a1d6ab7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2009,7 +2009,7 @@ static struct hpsa_scsi_dev_t *lookup_hpsa_scsi_dev(struct ctlr_info *h,
 
 static int hpsa_slave_alloc(struct scsi_device *sdev)
 {
-	struct hpsa_scsi_dev_t *sd;
+	struct hpsa_scsi_dev_t *sd = NULL;
 	unsigned long flags;
 	struct ctlr_info *h;
 
@@ -2026,7 +2026,8 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
 			sd->target = sdev_id(sdev);
 			sd->lun = sdev->lun;
 		}
-	} else
+	}
+	if (!sd)
 		sd = lookup_hpsa_scsi_dev(h, sdev_channel(sdev),
 					sdev_id(sdev), sdev->lun);
 
@@ -3840,6 +3841,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->vendor));
 	memcpy(this_device->model, &inq_buff[16],
 		sizeof(this_device->model));
+	this_device->rev = inq_buff[2];
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
 	if (hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
@@ -3929,10 +3931,14 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 
 	if (!is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* physical device, target and lun filled in later */
-		if (is_hba_lunid(lunaddrbytes))
+		if (is_hba_lunid(lunaddrbytes)) {
+			int bus = HPSA_HBA_BUS;
+
+			if (!device->rev)
+				bus = HPSA_LEGACY_HBA_BUS;
 			hpsa_set_bus_target_lun(device,
-					HPSA_HBA_BUS, 0, lunid & 0x3fff);
-		else
+					bus, 0, lunid & 0x3fff);
+		} else
 			/* defer target, lun assignment for physical devices */
 			hpsa_set_bus_target_lun(device,
 					HPSA_PHYSICAL_DEVICE_BUS, -1, -1);
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 82cdfad..9ea162d 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -69,6 +69,7 @@ struct hpsa_scsi_dev_t {
 	u64 sas_address;
 	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
 	unsigned char model[16];        /* bytes 16-31 of inquiry data */
+	unsigned char rev;		/* byte 2 of inquiry data */
 	unsigned char raid_level;	/* from inquiry page 0xC1 */
 	unsigned char volume_offline;	/* discovered via TUR or VPD */
 	u16 queue_depth;		/* max queue_depth for this device */
@@ -402,6 +403,7 @@ struct offline_device_entry {
 #define HPSA_RAID_VOLUME_BUS		1
 #define HPSA_EXTERNAL_RAID_VOLUME_BUS	2
 #define HPSA_HBA_BUS			0
+#define HPSA_LEGACY_HBA_BUS		3
 
 /*
 	Send the command to the hardware
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 04ce7cf..50c7167 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -308,7 +308,7 @@ struct fc_host_statistics *fc_get_host_stats(struct Scsi_Host *shost)
 	fc_stats = &lport->host_stats;
 	memset(fc_stats, 0, sizeof(struct fc_host_statistics));
 
-	fc_stats->seconds_since_last_reset = (lport->boot_time - jiffies) / HZ;
+	fc_stats->seconds_since_last_reset = (jiffies - lport->boot_time) / HZ;
 
 	for_each_possible_cpu(cpu) {
 		struct fc_stats *stats;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 91b70bc..1c4744e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3885,6 +3885,11 @@ _scsih_temp_threshold_events(struct MPT3SAS_ADAPTER *ioc,
 	}
 }
 
+static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
+{
+	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
+}
+
 /**
  * _scsih_flush_running_cmds - completing outstanding commands.
  * @ioc: per adapter object
@@ -3906,6 +3911,9 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		if (!scmd)
 			continue;
 		count++;
+		if (ata_12_16_cmd(scmd))
+			scsi_internal_device_unblock(scmd->device,
+							SDEV_RUNNING);
 		mpt3sas_base_free_smid(ioc, smid);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
@@ -4010,11 +4018,6 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 	    SAM_STAT_CHECK_CONDITION;
 }
 
-static inline bool ata_12_16_cmd(struct scsi_cmnd *scmd)
-{
-	return (scmd->cmnd[0] == ATA_12 || scmd->cmnd[0] == ATA_16);
-}
-
 /**
  * scsih_qcmd - main scsi request entry point
  * @scmd: pointer to scsi command object
