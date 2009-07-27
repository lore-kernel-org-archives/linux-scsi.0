From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 8/12] drivers/scsi/fcoe: Correct redundant test
Date: Mon, 27 Jul 2009 18:14:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907271814300.2682@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:49339 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZG0QUF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jul 2009 12:20:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The second test is more general than the first one.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
*x == NULL
|
*x != NULL
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/fcoe/libfcoe.c         |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index f544340..ab0eb1b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -911,8 +911,6 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	u32	desc_mask;
 
 	LIBFCOE_FIP_DBG("Clear Virtual Link received\n");
-	if (!fcf)
-		return;
 	if (!fcf || !fc_host_port_id(lp->host))
 		return;
 
