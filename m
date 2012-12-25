From: Andreas Bombe <aeb@debian.org>
Subject: [RFC PATCH] [SCSI] sd: When no media present ignore WCE in
 suspend/shutdown
Date: Wed, 26 Dec 2012 00:24:01 +0100
Message-ID: <20121225232401.GA19299@amos.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from infernal.debian.net ([176.28.9.132]:50499 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2LYXsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Dec 2012 18:48:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

When the WCE flag is set for a drive, sd_shutdown() and sd_suspend() try
to send a SYNCHRONIZE_CACHE command to that drive. This is not
meaningful when no media are present and causes errors with devices
where the media are the actual command processing devices, such as SATA
attached RDX docks where the removable cartridges contain hard disks.

In the RDX case, the WCE bit is set when a cartridge is inserted and not
reset when it is removed. Suspending the computer afterwards will not be
possible unless a cartridge is inserted since otherwise the
SYNCHRONIZE_CACHE command will fail causing sd_suspend() to return an
error.

Signed-off-by: Andreas Bombe <aeb@debian.org>
---

Ok, this patch makes the problem go away, but I'm not sure whether this
is right solution. I also don't know whether SATA RDX docks are sort of
a special case in this regard.

I can think of two other solutions:
1. Also skip the sd_start_stop_device() call. The device for the RDX
   dock isn't managed so I can't test.
2. Clear the WCE flag when media are removed and leave sd_shutdown() /
   sd_suspend() alone.

The final patch would then also be Cc: stable, I don't know how far back
this goes but at least 3.7 is affected.


 drivers/scsi/sd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..723512e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3048,7 +3048,7 @@ static void sd_shutdown(struct device *dev)
 	if (pm_runtime_suspended(dev))
 		goto exit;
 
-	if (sdkp->WCE) {
+	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		sd_sync_cache(sdkp);
 	}
@@ -3070,7 +3070,7 @@ static int sd_suspend(struct device *dev)
 	if (!sdkp)
 		return 0;	/* this can happen */
 
-	if (sdkp->WCE) {
+	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp);
 		if (ret)
-- 
1.7.10.4
