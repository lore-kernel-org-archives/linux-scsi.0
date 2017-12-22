From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 07/11] mpt3sas: always use first reserved smid for ioctl  passthrough
Date: Thu, 21 Dec 2017 23:31:43 -0800
Message-ID: <1513927907-19735-8-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39910 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754109AbdLVHcm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 02:32:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id i11so19803080wmf.4
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 23:32:42 -0800 (PST)
In-Reply-To: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

ioctl passthrough commands require a SCSIIO smid, but cannot
easily integrate with the block layer. But the driver already
has reserved some SCSIIO smids and we're only ever allowing
one ioctl command at a time we can use the first reserved smid
for ioctl commands.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 19 +++++++++++++------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c  | 10 ++--------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index afe42a8..a49040e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -908,14 +908,18 @@ static u8
 _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	int i;
+	u16 ctl_smid = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT + 1;
 	u8 cb_idx = 0xFF;
 
 	if (smid < ioc->hi_priority_smid) {
 		struct scsiio_tracker *st;
 
-		st = mpt3sas_get_st_from_smid(ioc, smid);
-		if (st)
-			cb_idx = st->cb_idx;
+		if (smid < ctl_smid) {
+			st = mpt3sas_get_st_from_smid(ioc, smid);
+			if (st)
+				cb_idx = st->cb_idx;
+		} else if (smid == ctl_smid)
+			cb_idx = ioc->ctl_cb_idx;
 	} else if (smid < ioc->internal_smid) {
 		i = smid - ioc->hi_priority_smid;
 		cb_idx = ioc->hpr_lookup[i].cb_idx;
@@ -2922,7 +2926,9 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 		ioc->scsi_lookup[i].cb_idx = 0xFF;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-		list_add(&ioc->scsi_lookup[i].tracker_list, &ioc->free_list);
+		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
+			list_add(&ioc->scsi_lookup[i].tracker_list,
+				 &ioc->free_list);
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 
 		_base_recovery_check(ioc);
@@ -5787,8 +5793,9 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
 		ioc->scsi_lookup[i].smid = smid;
 		ioc->scsi_lookup[i].scmd = NULL;
 		ioc->scsi_lookup[i].direct_io = 0;
-		list_add_tail(&ioc->scsi_lookup[i].tracker_list,
-		    &ioc->free_list);
+		if (i < ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT)
+			list_add_tail(&ioc->scsi_lookup[i].tracker_list,
+				      &ioc->free_list);
 	}
 
 	/* hi-priority queue */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index b4c374b..4f23498 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -724,14 +724,8 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			goto out;
 		}
 	} else {
-
-		smid = mpt3sas_base_get_smid_scsiio(ioc, ioc->ctl_cb_idx, NULL);
-		if (!smid) {
-			pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
-			    ioc->name, __func__);
-			ret = -EAGAIN;
-			goto out;
-		}
+		/* Use first reserved smid for passthrough ioctls */
+		smid = ioc->scsiio_depth - INTERNAL_SCSIIO_CMDS_COUNT + 1;
 	}
 
 	ret = 0;
-- 
2.5.5
