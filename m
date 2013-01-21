From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/15] drivers/scsi/bnx2fc/bnx2fc_io.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:49 +0100
Message-ID: <1358773378-4700-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  The code tested the result
of a previous allocation, that itself was already tested.  It is changed to
test the result of the most recent allocation.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@s exists@
local idexpression y;
expression x,e;
@@

*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
    when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8d4626c..8bea53d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -654,7 +654,7 @@ int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
 	mp_req->mp_resp_bd = dma_alloc_coherent(&hba->pcidev->dev, sz,
 						 &mp_req->mp_resp_bd_dma,
 						 GFP_ATOMIC);
-	if (!mp_req->mp_req_bd) {
+	if (!mp_req->mp_resp_bd) {
 		printk(KERN_ERR PFX "unable to alloc MP resp bd\n");
 		bnx2fc_free_mp_resc(io_req);
 		return FAILED;
