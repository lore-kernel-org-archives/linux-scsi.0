From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 7/7] aacraid: Apply another recommendation from
 "checkpatch.pl"
Date: Sun, 21 Aug 2016 09:29:24 +0200
Message-ID: <03ee5f77-5866-1186-b160-bb5141848865@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@microsemi.com, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 21 Aug 2016 08:23:25 +0200

The script "checkpatch.pl" can point out that assignments should usually
not be performed within condition checks.
Thus move the assignment for the variable "srbfib" to a separate statement.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/aacraid/commctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index d2029db..7e6c76d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -499,9 +499,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	/*
 	 *	Allocate and initialize a Fib then setup a SRB command
 	 */
-	if (!(srbfib = aac_fib_alloc(dev))) {
+	srbfib = aac_fib_alloc(dev);
+	if (!srbfib)
 		return -ENOMEM;
-	}
 	aac_fib_init(srbfib);
 	/* raw_srb FIB is not FastResponseCapable */
 	srbfib->hw_fib_va->header.XferState &= ~cpu_to_le32(FastResponseCapable);
-- 
2.9.3
