From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 3/3] libata: don't start disks on resume
Date: Wed,  6 Nov 2013 20:57:51 -0500
Message-ID: <1e3533e3ea742b1b0b9d86f1dd7e54a9a8a16138.1383789225.git.psusi@ubuntu.com>
References: <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <927e15641f27b46f206f8ae8110201c8fd77b7e1.1383789225.git.psusi@ubuntu.com>
In-Reply-To: <527AF287.7020700@ubuntu.com>
References: <527AF287.7020700@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: tj@kernel.org, JBottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

Disks with Power Up In Standby enabled that required the
SET FEATURES command to start up were being issued the
command during resume.  Suppress this until the disk
is actually accessed.
---
 drivers/ata/libata-core.c | 10 +++++++---
 drivers/ata/libata-eh.c   | 11 +++++++++++
 drivers/ata/libata.h      |  1 +
 include/linux/libata.h    |  1 +
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 16f45dc..06b81fc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1993,7 +1993,10 @@ retry:
 			goto err_out;
 	}
 
-	if (!tried_spinup && (id[2] == 0x37c8 || id[2] == 0x738c)) {
+	if (flags & ATA_READID_NOSTART && id[2] == 0x37c8)
+		return -EAGAIN;
+	if (!(flags & ATA_READID_NOSTART) &&
+	    !tried_spinup && (id[2] == 0x37c8 || id[2] == 0x738c)) {
 		tried_spinup = 1;
 		/*
 		 * Drive powered-up in standby mode, and requires a specific
@@ -3982,7 +3985,6 @@ int ata_dev_reread_id(struct ata_device *dev, unsigned int readid_flags)
 	if (!ata_dev_same_device(dev, class, id))
 		return -ENODEV;
 
-	memcpy(dev->id, id, sizeof(id[0]) * ATA_ID_WORDS);
 	return 0;
 }
 
@@ -4024,6 +4026,8 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 
 	/* re-read ID */
 	rc = ata_dev_reread_id(dev, readid_flags);
+	if (rc == -EAGAIN)
+		return rc;
 	if (rc)
 		goto fail;
 
@@ -5413,7 +5417,7 @@ static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
 	int rc;
 
 	rc = ata_port_request_pm(ap, mesg, ATA_EH_RESET,
-		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET | ATA_EHI_NOSTART, async);
 	return rc;
 }
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c69fcce..b4fcf62 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3086,6 +3086,8 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 
 		if (ehc->i.flags & ATA_EHI_DID_RESET)
 			readid_flags |= ATA_READID_POSTRESET;
+		if (ehc->i.flags & ATA_EHI_NOSTART)
+			readid_flags |= ATA_READID_NOSTART;
 
 		if ((action & ATA_EH_REVALIDATE) && ata_dev_enabled(dev)) {
 			WARN_ON(dev->class == ATA_DEV_PMP);
@@ -3098,6 +3100,10 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 			ata_eh_about_to_do(link, dev, ATA_EH_REVALIDATE);
 			rc = ata_dev_revalidate(dev, ehc->classes[dev->devno],
 						readid_flags);
+			if (rc == -EAGAIN) {
+				rc = 0; /* start required but suppressed, handle later */
+				continue;
+			}
 			if (rc)
 				goto err;
 
@@ -3830,6 +3836,11 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 
 		/* revalidate existing devices and attach new ones */
 		rc = ata_eh_revalidate_and_attach(link, &dev);
+		if (rc == -EAGAIN) {
+			/* spinup required, but suppressed, ignore for now */
+			rc = 0;
+			continue;
+		}
 		if (rc)
 			goto rest_fail;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index eeeb778..146d62d 100644
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

