From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 2/2] cxlflash: Move to exponential back-off when cmd_room is not available
Date: Fri, 25 Mar 2016 14:26:49 -0500
Message-ID: <1458934009-28861-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1458933920-28788-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:36512 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbcCYT3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Mar 2016 15:29:06 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 25 Mar 2016 13:29:05 -0600
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 11DAB3E4003B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 13:29:02 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2PJT2hj30802098
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 12:29:02 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2PJT1Qe002106
	for <linux-scsi@vger.kernel.org>; Fri, 25 Mar 2016 13:29:01 -0600
In-Reply-To: <1458933920-28788-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

While profiling the cxlflash_queuecommand() path under a heavy load it
was found that number of retries to find cmd_room was fairly high.

There are two problems with the current back-off:
a) It starts with a udelay of 0
b) It backs-off linearly

Tried several approaches (a higher multiple 10*n, 100*n, as well as n^2,
2^n) and found that the exponential back-off(2^n) approach had the least
overall cost. Cost as being defined as overall time spent waiting.

The fix is to change the linear back-off to an exponential back-off.
This solution also takes care of the problem with the initial
delay (starts with 1 usec).

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index e6d56ac..8fb9643 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -289,7 +289,7 @@ static void context_reset(struct afu_cmd *cmd)
 		atomic64_set(&afu->room, room);
 		if (room)
 			goto write_rrin;
-		udelay(nretry);
+		udelay(1 << nretry);
 	} while (nretry++ < MC_ROOM_RETRY_CNT);
 
 	pr_err("%s: no cmd_room to send reset\n", __func__);
@@ -303,7 +303,7 @@ write_rrin:
 		if (rrin != 0x1)
 			break;
 		/* Double delay each time */
-		udelay(2 << nretry);
+		udelay(1 << nretry);
 	} while (nretry++ < MC_ROOM_RETRY_CNT);
 }
 
@@ -338,7 +338,7 @@ retry:
 			atomic64_set(&afu->room, room);
 			if (room)
 				goto write_ioarrin;
-			udelay(nretry);
+			udelay(1 << nretry);
 		} while (nretry++ < MC_ROOM_RETRY_CNT);
 
 		dev_err(dev, "%s: no cmd_room to send 0x%X\n",
@@ -352,7 +352,7 @@ retry:
 		 * afu->room.
 		 */
 		if (nretry++ < MC_ROOM_RETRY_CNT) {
-			udelay(nretry);
+			udelay(1 << nretry);
 			goto retry;
 		}
 
-- 
2.1.0

