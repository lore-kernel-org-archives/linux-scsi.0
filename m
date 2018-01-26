From: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH resend 4/6] cdrom: introduce CDS_DRIVE_ERROR
Date: Fri, 26 Jan 2018 17:58:38 +0100
Message-ID: <d92282ad58ca6256a438ef68354f3ae3d1d30162.1516985620.git.msuchanek@suse.de>
References: <cover.1513263482.git.msuchanek@suse.de>
 <cover.1516985620.git.msuchanek@suse.de>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
In-Reply-To: <cover.1516985620.git.msuchanek@suse.de>
References: <cover.1516985620.git.msuchanek@suse.de>
Sender: linux-doc-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Borislav Petkov <bp@alien8.de>, Tim Waugh <tim@cyberelk.net>, "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michal Suchanek <msuchanek@suse.de>, Kees Cook <keescook@chromium.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

CDS_DRIVE_NOT_READY is used for the state in which CDROM is 'becoming
ready' (typically analyzing the disc) but also as the fallback when
nothing else applies. Introduce CDS_DRIVE_ERROR for the fallback case.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/block/paride/pcd.c |  2 +-
 drivers/cdrom/gdrom.c      |  2 +-
 drivers/ide/ide-cd_ioctl.c | 12 ++++++++----
 drivers/scsi/sr_ioctl.c    |  2 +-
 include/uapi/linux/cdrom.h |  1 +
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 7b8c6368beb7..6e00093ff34e 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -605,7 +605,7 @@ static int pcd_drive_status(struct cdrom_device_info *cdi, int slot_nr)
 	struct pcd_unit *cd = cdi->handle;
 
 	if (pcd_ready_wait(cd, PCD_READY_TMO))
-		return CDS_DRIVE_NOT_READY;
+		return CDS_DRIVE_ERROR;
 	if (pcd_atapi(cd, rc_cmd, 8, pcd_scratch, DBMSG("check media")))
 		return CDS_NO_DISC;
 	return CDS_DISC_OK;
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 6495b03f576c..702f255bbe42 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -390,7 +390,7 @@ static int gdrom_drivestatus(struct cdrom_device_info *cd_info, int ignore)
 	if (sense == 0)
 		return CDS_DISC_OK;
 	if (sense == 0x20)
-		return CDS_DRIVE_NOT_READY;
+		return CDS_DRIVE_ERROR;
 	/* default */
 	return CDS_NO_INFO;
 }
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 2acca12b9c94..9a26f50a2092 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -62,9 +62,13 @@ int ide_cdrom_drive_status(struct cdrom_device_info *cdi, int slot_nr)
 			return CDS_NO_DISC;
 	}
 
-	if (sense.sense_key == NOT_READY && sense.asc == 0x04
-			&& sense.ascq == 0x04)
-		return CDS_DISC_OK;
+	if (sense.sense_key == NOT_READY && sense.asc == 0x04)
+		switch (sense.ascq) {
+		case 0x01:
+			return CDS_DRIVE_NOT_READY;
+		case 0x04:
+			return CDS_DISC_OK;
+		}
 
 	/*
 	 * If not using Mt Fuji extended media tray reports,
@@ -77,7 +81,7 @@ int ide_cdrom_drive_status(struct cdrom_device_info *cdi, int slot_nr)
 		else
 			return CDS_TRAY_OPEN;
 	}
-	return CDS_DRIVE_NOT_READY;
+	return CDS_DRIVE_ERROR;
 }
 
 /*
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 2a21f2d48592..7c93f12a9cb8 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -333,7 +333,7 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 	else
 		return CDS_TRAY_OPEN;
 
-	return CDS_DRIVE_NOT_READY;
+	return CDS_DRIVE_ERROR;
 }
 
 int sr_disk_status(struct cdrom_device_info *cdi)
diff --git a/include/uapi/linux/cdrom.h b/include/uapi/linux/cdrom.h
index 2817230148fd..339b1435f44e 100644
--- a/include/uapi/linux/cdrom.h
+++ b/include/uapi/linux/cdrom.h
@@ -398,6 +398,7 @@ struct cdrom_generic_command
 #define CDS_TRAY_OPEN		2
 #define CDS_DRIVE_NOT_READY	3
 #define CDS_DISC_OK		4
+#define CDS_DRIVE_ERROR		5
 
 /* return values for the CDROM_DISC_STATUS ioctl */
 /* can also return CDS_NO_[INFO|DISC], from above */
-- 
2.13.6

