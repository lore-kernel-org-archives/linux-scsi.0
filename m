From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 4/6] libata: don't start disks on resume
Date: Mon, 16 Dec 2013 18:30:55 -0500
Message-ID: <1387236657-4852-5-git-send-email-psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:33888 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab3LPXbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 18:31:01 -0500
In-Reply-To: <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Disks with Power Up In Standby enabled that required the
SET FEATURES command to start up were being issued the
command during resume.  Suppress this until the disk
is actually accessed.
---
 drivers/ata/libata-core.c | 12 ++++++++++--
 drivers/ata/libata-eh.c   | 10 ++++++++--
 drivers/ata/libata.h      |  1 +
 include/linux/libata.h    |  1 +
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4a28caf..c9a1fa5a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1993,7 +1993,13 @@ retry:
 			goto err_out;
 	}
 
-	if (!tried_spinup && (id[2] == 0x37c8 || id[2] == 0x738c)) {
+	if (flags & ATA_READID_NOSTART && id[2] == 0x37c8)
+	{
+		dev->flags |= ATA_DFLAG_SLEEPING;
+		return -EAGAIN;
+	}
+	if (!(flags & ATA_READID_NOSTART) &&
+	    !tried_spinup && (id[2] == 0x37c8 || id[2] == 0x738c)) {
 		tried_spinup = 1;
 		/*
 		 * Drive powered-up in standby mode, and requires a specific
@@ -4024,6 +4030,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 
 	/* re-read ID */
 	rc = ata_dev_reread_id(dev, readid_flags);
+	if (rc == -EAGAIN)
+		return rc;
 	if (rc)
 		goto fail;
 
@@ -5423,7 +5431,7 @@ static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
 	int rc;
 
 	rc = ata_port_request_pm(ap, mesg, ATA_EH_RESET,
-		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET | ATA_EHI_NOSTART, async);
 	return rc;
 }
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 92d7797..0147b0d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3094,6 +3094,8 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 
 		if (ehc->i.flags & ATA_EHI_DID_RESET)
 			readid_flags |= ATA_READID_POSTRESET;
+		if (ehc->i.flags & ATA_EHI_NOSTART)
+			readid_flags |= ATA_READID_NOSTART;
 
 		if ((action & ATA_EH_REVALIDATE) && ata_dev_enabled(dev)) {
 			WARN_ON(dev->class == ATA_DEV_PMP);
@@ -3106,6 +3108,10 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			ata_eh_about_to_do(link, dev, ATA_EH_REVALIDATE);
 			rc = ata_dev_revalidate(dev, ehc->classes[dev->devno],
 						readid_flags);
+			if (rc == -EAGAIN) {
+				rc = 0; /* start required but suppressed, handle later */
+				continue;
+			}
 			if (rc)
 				goto err;
 
@@ -3432,7 +3438,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			hints &= ~ATA_LPM_HIPM;
 
 		/* disable DIPM before changing link config */
-		if (policy != ATA_LPM_MIN_POWER && dipm) {
+		if (policy != ATA_LPM_MIN_POWER && dipm && !(dev->flags & ATA_DFLAG_SLEEPING)) {
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_DISABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
@@ -3476,7 +3482,7 @@ static int ata_eh_set_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 	/* host config updated, enable DIPM if transitioning to MIN_POWER */
 	ata_for_each_dev(dev, link, ENABLED) {
 		if (policy == ATA_LPM_MIN_POWER && !no_dipm &&
-		    ata_id_has_dipm(dev->id)) {
+		    ata_id_has_dipm(dev->id) && !(dev->flags & ATA_DFLAG_SLEEPING)) {
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 45b5ab3..8939345 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -42,6 +42,7 @@ struct ata_scsi_args {
 enum {
 	/* flags for ata_dev_read_id() */
 	ATA_READID_POSTRESET	= (1 << 0), /* reading ID after reset */
+	ATA_READID_NOSTART	= (1 << 1), /* do not start drive */
 
 	/* selector for ata_down_xfermask_limit() */
 	ATA_DNXFER_PIO		= 0,	/* speed down PIO */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 0e23c26..3929bb8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -362,6 +362,7 @@ enum {
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
+	ATA_EHI_NOSTART		= (1 << 1),  /* don't start the disk */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
 	ATA_EHI_NO_RECOVERY	= (1 << 4),  /* no recovery */
-- 
1.8.3.2

