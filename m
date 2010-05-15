From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 2/4] drivers/scsi/aacraid: Eliminate use after free
Date: Sat, 15 May 2010 11:46:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005151145540.15566@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:44201 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab0EOJqR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 May 2010 05:46:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The debugging code using the freed structure is moved before the kfree.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@free@
expression E;
position p;
@@
kfree@p(E)

@@
expression free.E, subE<=free.E, E1;
position free.p;
@@

  kfree@p(E)
  ...
(
  subE = E1
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/aacraid/commctrl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 9c0c911..1b761d5 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -655,9 +655,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				/* Does this really need to be GFP_DMA? */
 				p = kmalloc(usg->sg[i].count,GFP_KERNEL|__GFP_DMA);
 				if(!p) {
-					kfree (usg);
-					dprintk((KERN_DEBUG"aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
+					dprintk((KERN_DEBUG "aacraid: Could not allocate SG buffer - size = %d buffer number %d of %d\n",
 					  usg->sg[i].count,i,usg->count));
+					kfree(usg);
 					rcode = -ENOMEM;
 					goto cleanup;
 				}
