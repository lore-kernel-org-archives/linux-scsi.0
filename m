From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 29/30] hpsa: Reorder compat ioctl functions to eliminate some
	forward declarations.
Date: Thu, 04 Feb 2010 08:43:51 -0600
Message-ID: <20100204144351.10406.72244.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:1391 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139Ab0BDOlG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 09:41:06 -0500
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: Reorder compat ioctl functions to eliminate some forward declarations.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   64 ++++++++++++++++++++++++---------------------------
 1 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 225a787..af20dbd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2287,40 +2287,6 @@ static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
 
 #ifdef CONFIG_COMPAT
 
-static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg);
-static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
-	int cmd, void *arg);
-
-static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg)
-{
-	switch (cmd) {
-	case CCISS_GETPCIINFO:
-	case CCISS_GETINTINFO:
-	case CCISS_SETINTINFO:
-	case CCISS_GETNODENAME:
-	case CCISS_SETNODENAME:
-	case CCISS_GETHEARTBEAT:
-	case CCISS_GETBUSTYPES:
-	case CCISS_GETFIRMVER:
-	case CCISS_GETDRIVVER:
-	case CCISS_REVALIDVOLS:
-	case CCISS_DEREGDISK:
-	case CCISS_REGNEWDISK:
-	case CCISS_REGNEWD:
-	case CCISS_RESCANDISK:
-	case CCISS_GETLUNINFO:
-		return hpsa_ioctl(dev, cmd, arg);
-
-	case CCISS_PASSTHRU32:
-		return hpsa_ioctl32_passthru(dev, cmd, arg);
-	case CCISS_BIG_PASSTHRU32:
-		return hpsa_ioctl32_big_passthru(dev, cmd, arg);
-
-	default:
-		return -ENOIOCTLCMD;
-	}
-}
-
 static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
 {
 	IOCTL32_Command_struct __user *arg32 =
@@ -2391,6 +2357,36 @@ static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
 		return -EFAULT;
 	return err;
 }
+
+static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg)
+{
+	switch (cmd) {
+	case CCISS_GETPCIINFO:
+	case CCISS_GETINTINFO:
+	case CCISS_SETINTINFO:
+	case CCISS_GETNODENAME:
+	case CCISS_SETNODENAME:
+	case CCISS_GETHEARTBEAT:
+	case CCISS_GETBUSTYPES:
+	case CCISS_GETFIRMVER:
+	case CCISS_GETDRIVVER:
+	case CCISS_REVALIDVOLS:
+	case CCISS_DEREGDISK:
+	case CCISS_REGNEWDISK:
+	case CCISS_REGNEWD:
+	case CCISS_RESCANDISK:
+	case CCISS_GETLUNINFO:
+		return hpsa_ioctl(dev, cmd, arg);
+
+	case CCISS_PASSTHRU32:
+		return hpsa_ioctl32_passthru(dev, cmd, arg);
+	case CCISS_BIG_PASSTHRU32:
+		return hpsa_ioctl32_big_passthru(dev, cmd, arg);
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
 #endif
 
 static int hpsa_getpciinfo_ioctl(struct ctlr_info *h, void __user *argp)

