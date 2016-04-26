From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 08/10] aacraid: Remove code to needlessly complete fib
Date: Mon, 25 Apr 2016 23:32:26 -0700
Message-ID: <20160426063226.28402.37546.stgit@pmcuser-System-Product-Name>
References: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0055.outbound.protection.outlook.com ([65.55.169.55]:55384
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752255AbcDZGhF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:37:05 -0400
In-Reply-To: <20160426062414.28402.69178.stgit@pmcuser-System-Product-Name>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc: aacraid@pmc-sierra.com, gana.sridaran@microsemi.com, scott.benesh@microsemi.com, vishal.josemannanal@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Currently driver completes double completed or spurious interrupted fibs.
This  is not necessary and causes the SCSI mid layer to issue aborts and
resets, since completing a fib  prematurely might trigger a race condition
resulting in the driver not calling the scsi_done callback.

Fixed by removing the call to fib complete.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/dpcsup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index d677b52..7e83620 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -392,9 +392,10 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index,
 			if (likely(fib->callback && fib->callback_data)) {
 				fib->flags &= FIB_CONTEXT_FLAG_FASTRESP;
 				fib->callback(fib->callback_data, fib);
-			} else {
-				aac_fib_complete(fib);
-			}
+			} else
+				dev_info(&dev->pdev->dev,
+				"Invalid callback_fib[%d] (*%p)(%p)\n",
+				index, fib->callback, fib->callback_data);
 		} else {
 			unsigned long flagv;
 	  		dprintk((KERN_INFO "event_wait up\n"));

