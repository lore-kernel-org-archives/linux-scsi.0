From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/8] drivers/message/fusion: use ARRAY_SIZE
Date: Sun, 9 Nov 2008 17:55:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811091755050.32509@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:56827 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbYKIQzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Nov 2008 11:55:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptbase.c    |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d6a0074..7a313f3 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4563,7 +4563,7 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, int howlong, int sleepFlag)
 			failcnt++;
 		hword = le16_to_cpu(CHIPREG_READ32(&ioc->chip->Doorbell) & 0x0000FFFF);
 		/* don't overflow our IOC hs_reply[] buffer! */
-		if (u16cnt < sizeof(ioc->hs_reply) / sizeof(ioc->hs_reply[0]))
+		if (u16cnt < ARRAY_SIZE(ioc->hs_reply))
 			hs_reply[u16cnt] = hword;
 		CHIPREG_WRITE32(&ioc->chip->IntStatus, 0);
 	}
@@ -7176,7 +7176,7 @@ union loginfo_type {
 
 	sas_loginfo.loginfo = log_info;
 	if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) &&
-	    (sas_loginfo.dw.originator < sizeof(originator_str)/sizeof(char*)))
+	    (sas_loginfo.dw.originator < ARRAY_SIZE(originator_str)))
 		return;
 
 	originator_desc = originator_str[sas_loginfo.dw.originator];
@@ -7185,21 +7185,21 @@ union loginfo_type {
 
 		case 0:  /* IOP */
 			if (sas_loginfo.dw.code <
-			    sizeof(iop_code_str)/sizeof(char*))
+			    ARRAY_SIZE(iop_code_str))
 				code_desc = iop_code_str[sas_loginfo.dw.code];
 			break;
 		case 1:  /* PL */
 			if (sas_loginfo.dw.code <
-			    sizeof(pl_code_str)/sizeof(char*))
+			    ARRAY_SIZE(pl_code_str))
 				code_desc = pl_code_str[sas_loginfo.dw.code];
 			break;
 		case 2:  /* IR */
 			if (sas_loginfo.dw.code >=
-			    sizeof(ir_code_str)/sizeof(char*))
+			    ARRAY_SIZE(ir_code_str))
 				break;
 			code_desc = ir_code_str[sas_loginfo.dw.code];
 			if (sas_loginfo.dw.subcode >=
-			    sizeof(raid_sub_code_str)/sizeof(char*))
+			    ARRAY_SIZE(raid_sub_code_str))
 			break;
 			if (sas_loginfo.dw.code == 0)
 				sub_code_desc =
