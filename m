From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] SCSI/SD: clearer output of disk cache state
Date: Sat, 4 Nov 2006 11:54:08 -0800 (PST)
Message-ID: <335122.2750.qm@web31808.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:19032 "HELO
	web31808.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965551AbWKDTyJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 14:54:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/sd.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

This patch is 8 months old.

     Luben

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9d98723..f157747 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1354,11 +1354,6 @@ sd_read_cache_type(struct scsi_disk *sdk
 	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
-		const char *types[] = {
-			"write through", "none", "write back",
-			"write back, no read (daft)"
-		};
-		int ct = 0;
 		int offset = data.header_length + data.block_descriptor_length;
 
 		if (offset >= SD_BUF_SIZE - 2) {
@@ -1387,11 +1382,13 @@ sd_read_cache_type(struct scsi_disk *sdk
 			sdkp->DPOFUA = 0;
 		}
 
-		ct =  sdkp->RCD + 2*sdkp->WCE;
-
-		printk(KERN_NOTICE "SCSI device %s: drive cache: %s%s\n",
-		       diskname, types[ct],
-		       sdkp->DPOFUA ? " w/ FUA" : "");
+		printk(KERN_NOTICE "SCSI device %s: "
+		       "write cache: %s, read cache: %s, %s\n",
+		       diskname,
+		       sdkp->WCE ? "enabled" : "disabled",
+		       sdkp->RCD ? "disabled" : "enabled",
+		       sdkp->DPOFUA ? "supports DPO and FUA"
+		       : "doesn't support DPO or FUA");
 
 		return;
 	}
-- 
1.4.3.3.g8478


