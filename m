From: akpm@linux-foundation.org
Subject: [patch 09/26] drivers/scsi: Remove unnecessary NULL test
Date: Thu, 11 Mar 2010 14:09:41 -0800
Message-ID: <201003112209.o2BM9gbD013628@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758377Ab0CKWJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:09:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk

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
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/initio.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/initio.c~drivers-scsi-remove-unnecessary-null-test drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~drivers-scsi-remove-unnecessary-null-test
+++ a/drivers/scsi/initio.c
@@ -2817,7 +2817,6 @@ static void i91uSCBPost(u8 * host_mem, u
 	}
 
 	cmnd->result = cblk->tastat | (cblk->hastat << 16);
-	WARN_ON(cmnd == NULL);
 	i91u_unmap_scb(host->pci_dev, cmnd);
 	cmnd->scsi_done(cmnd);	/* Notify system DONE           */
 	initio_release_scb(host, cblk);	/* Release SCB for current channel */
_
