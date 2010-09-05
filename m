From: Joe Perches <joe@perches.com>
Subject: [PATCH 05/13] drivers/scsi: Remove unnecessary casts of private_data
Date: Sat,  4 Sep 2010 18:52:46 -0700
Message-ID: <ce0592fde56f01f9027bf5d1cfa83536b2aca8e4.1283650107.git.joe@perches.com>
References: <cover.1283650107.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1283650107.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aacraid/linit.c |    2 +-
 drivers/scsi/sg.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index cad6f9a..aa40036 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -770,7 +770,7 @@ static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long
 {
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
+	return aac_compat_do_ioctl(file->private_data, cmd, arg);
 }
 #endif
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 78d6163..6efa8dd 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -210,7 +210,7 @@ static void sg_put_dev(Sg_device *sdp);
 
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
-	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
+	struct sg_fd *sfp = filp->private_data;
 
 	if (sfp->parentdp->device->type == TYPE_SCANNER)
 		return 0;
-- 
1.7.2.19.g9a302
