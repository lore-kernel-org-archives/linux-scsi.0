From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/4] drivers/scsi: adjust NULL test
Date: Mon, 13 Jul 2009 22:44:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0907132244090.12374@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757224AbZGMUuP@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Due to the preceding dereference, cmnd cannot be NULL at the point of the
WARN_ON.  Furthermore, it was earlier tested whether cmnd was NULL and the
function was exited if that was the case.

A simplified version of the semantic match that finds this problem is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E,E1;
identifier f,l;
position p1,p2;
@@

*x@p1->f = E1;
... when != x = E
    when != goto l;
(
*x@p2 == NULL
|
*x@p2 != NULL
)
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
