From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] a100u2w: fix bitmap lookup routine
Date: Mon, 17 Mar 2008 21:32:02 +0900
Message-ID: <20080317123200.GA17756@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:9186 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYCQMkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 08:40:08 -0400
Received: by wf-out-1314.google.com with SMTP id 28so5406005wff.4
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2008 05:40:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Alan Cox <alan@redhat.com>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>

This patch is only compile tested.

It seems that bitmap lookup routine for allocation_map in
a100u2w driver is simply wrong.

It cannot lookup more than first 32 bits. If all first 32 bits
are set, it just returns 33-th orc_scb even though the 33-th bit
is not set.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alan Cox <alan@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Ledford <dledford@redhat.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/a100u2w.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: 2.6-rc/drivers/scsi/a100u2w.c
===================================================================
--- 2.6-rc.orig/drivers/scsi/a100u2w.c
+++ 2.6-rc/drivers/scsi/a100u2w.c
@@ -674,12 +674,13 @@ static struct orc_scb *__orc_alloc_scb(s
 		for (index = 0; index < 32; index++) {
 			if ((host->allocation_map[channel][i] >> index) & 0x01) {
 				host->allocation_map[channel][i] &= ~(1 << index);
-				break;
+				idx = index + 32 * i;
+				/*
+				 * Translate the index to a structure instance
+				 */
+				return host->scb_virt + idx;
 			}
 		}
-		idx = index + 32 * i;
-		/* Translate the index to a structure instance */
-		return (struct orc_scb *) ((unsigned long) host->scb_virt + (idx * sizeof(struct orc_scb)));
 	}
 	return NULL;
 }
