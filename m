From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 11/14] drivers/scsi: Remove unnecessary NULL test
Date: Sat, 17 Oct 2009 08:42:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0910170841480.9213@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752069AbZJQGmK@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

At the point where cmnd is initialized, it is tested for NULL, so it
doesn't have to be tested again here.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/initio.c               |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..359de22 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2817,7 +2817,6 @@ static void i91uSCBPost(u8 * host_mem, u8 * cblk_mem)
 	}
 
 	cmnd->result = cblk->tastat | (cblk->hastat << 16);
-	WARN_ON(cmnd == NULL);
 	i91u_unmap_scb(host->pci_dev, cmnd);
 	cmnd->scsi_done(cmnd);	/* Notify system DONE           */
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
