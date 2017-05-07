From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 14/19] aacraid: Use correct function to get ctrl health
Date: Sun, 7 May 2017 04:26:59 -0700
Message-ID: <20170507112704.21940-15-RaghavaAditya.Renukunta@microsemi.com>
References: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0085.outbound.protection.outlook.com ([104.47.42.85]:35392
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754438AbdEGVj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:39:56 -0400
In-Reply-To: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

The command thread checks the ctrl health periodically before sending
updates to the controller. The function that it uses is aac_check_health
which does more than get the health status.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 3299012..f26543a 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2476,7 +2476,7 @@ int aac_command_thread(void *data)
 		if ((time_before(next_check_jiffies,next_jiffies))
 		 && ((difference = next_check_jiffies - jiffies) <= 0)) {
 			next_check_jiffies = next_jiffies;
-			if (aac_check_health(dev) == 0) {
+			if (aac_adapter_check_health(dev) == 0) {
 				difference = ((long)(unsigned)check_interval)
 					   * HZ;
 				next_check_jiffies = jiffies + difference;
@@ -2489,7 +2489,7 @@ int aac_command_thread(void *data)
 			int ret;
 
 			/* Don't even try to talk to adapter if its sick */
-			ret = aac_check_health(dev);
+			ret = aac_adapter_check_health(dev);
 			if (ret || !dev->queues)
 				break;
 			next_check_jiffies = jiffies
-- 
2.7.4
