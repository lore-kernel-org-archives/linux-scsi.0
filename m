From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 10/15] drivers/scsi/csiostor/csio_lnode.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:54 +0100
Message-ID: <1358773378-4700-11-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  The current value of ln has
been tested already, and is clearly not NULL, given the enclosing if
condition.  Furthermore, the result of csio_lnode_alloc is currently
ignored.

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
Not tested.  I don't know if this is the right fix.

 drivers/scsi/csiostor/csio_lnode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index ffe9be0..d956f97 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -873,7 +873,7 @@ csio_handle_link_up(struct csio_hw *hw, uint8_t portid, uint32_t fcfi,
 		if (ln->vnp_flowid != CSIO_INVALID_IDX) {
 			/* New VN-Port */
 			spin_unlock_irq(&hw->lock);
-			csio_lnode_alloc(hw);
+			ln = csio_lnode_alloc(hw);
 			spin_lock_irq(&hw->lock);
 			if (!ln) {
 				csio_err(hw,
