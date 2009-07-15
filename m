From: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] fcoe: convert to %pM
Date: Wed, 15 Jul 2009 17:21:14 +0200
Message-ID: <1247671274.10754.5.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZGOPek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 11:34:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Love <robert.w.love@intel.com>, Chris Leech <christopher.leech@intel.com>

print_mac is being deprecated, and %pM makes for smaller
code anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/scsi/fcoe/libfcoe.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- wireless-testing.orig/drivers/scsi/fcoe/libfcoe.c	2009-07-15 17:12:02.000000000 +0200
+++ wireless-testing/drivers/scsi/fcoe/libfcoe.c	2009-07-15 17:12:17.000000000 +0200
@@ -1104,7 +1104,6 @@ static void fcoe_ctlr_timeout(unsigned l
 	struct fcoe_fcf *sel;
 	struct fcoe_fcf *fcf;
 	unsigned long next_timer = jiffies + msecs_to_jiffies(FIP_VN_KA_PERIOD);
-	DECLARE_MAC_BUF(buf);
 	u8 send_ctlr_ka;
 	u8 send_port_ka;
 
@@ -1128,9 +1127,8 @@ static void fcoe_ctlr_timeout(unsigned l
 		fcf = sel;		/* the old FCF may have been freed */
 		if (sel) {
 			printk(KERN_INFO "libfcoe: host%d: FIP selected "
-			       "Fibre-Channel Forwarder MAC %s\n",
-			       fip->lp->host->host_no,
-			       print_mac(buf, sel->fcf_mac));
+			       "Fibre-Channel Forwarder MAC %pM\n",
+			       fip->lp->host->host_no, sel->fcf_mac);
 			memcpy(fip->dest_addr, sel->fcf_mac, ETH_ALEN);
 			fip->port_ka_time = jiffies +
 					    msecs_to_jiffies(FIP_VN_KA_PERIOD);


