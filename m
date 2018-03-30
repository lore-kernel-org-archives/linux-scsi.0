From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 03/15] mpt3sas: Add sanity checks for scsi tracker before  accessing it.
Date: Fri, 30 Mar 2018 15:07:12 +0530
Message-ID: <1522402644-3016-4-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Check scsi tracker for NULL before accessing it.
And in some places there are possibilities for getting valid st
but still other fields are not set.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 5 ++++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 ++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index c1b17d6..2f27d5c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -590,7 +590,8 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
 		struct scsiio_tracker *st;
 
 		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
-		if (!scmd)
+		if (scmd == NULL || scmd->device == NULL ||
+				scmd->device->hostdata == NULL)
 			continue;
 		if (lun != scmd->device->lun)
 			continue;
@@ -600,6 +601,8 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
 		if (priv_data->sas_target->handle != handle)
 			continue;
 		st = scsi_cmd_priv(scmd);
+		if ((!st) || (st->smid == 0))
+			continue;
 		tm_request->TaskMID = cpu_to_le16(st->smid);
 		found = 1;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c9cce65..6b1aaa0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1465,7 +1465,7 @@ mpt3sas_scsih_scsi_lookup_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 		scmd = scsi_host_find_tag(ioc->shost, unique_tag);
 		if (scmd) {
 			st = scsi_cmd_priv(scmd);
-			if (st->cb_idx == 0xFF)
+			if ((!st) || (st->cb_idx == 0xFF) || (st->smid == 0))
 				scmd = NULL;
 		}
 	}
@@ -4451,6 +4451,13 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
 		count++;
 		_scsih_set_satl_pending(scmd, false);
 		st = scsi_cmd_priv(scmd);
+		/*
+		 * It may be possible that SCSI scmd got prepared by SML
+		 * but it has not issued to the driver, for these type of
+		 * scmd's don't do anything"
+		 */
+		if (st && st->smid == 0)
+			continue;
 		mpt3sas_base_clear_st(ioc, st);
 		scsi_dma_unmap(scmd);
 		if (ioc->pci_error_recovery)
-- 
1.8.3.1
