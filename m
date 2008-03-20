From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] a100u2w: fix bitmap lookup routine
Date: Thu, 20 Mar 2008 18:36:28 +0900
Message-ID: <20080320093626.GB30888@APFDCB5C>
References: <20080317123200.GA17756@APFDCB5C> <1205765204.6767.129.camel@localhost.localdomain> <20080319142419.GA27779@devserv.devel.redhat.com> <20080320135518W.tomof@acm.org> <20080320093448.GA30888@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:41265 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526AbYCTJoh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2008 05:44:37 -0400
Received: by wa-out-1112.google.com with SMTP id v27so945781wah.23
        for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2008 02:44:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20080320093448.GA30888@APFDCB5C>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: alan@redhat.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@lst.de, dledford@redhat.com, fujita.tomonori@lab.ntt.co.jp

On Thu, Mar 20, 2008 at 06:34:48PM +0900, Akinobu Mita wrote:
> This is incremental patch to the original bugfix patch.

This is the original bugfix for the reference

Subject: [patch 1/2] a100u2w: fix bitmap lookup routine

This patch is only compile tested.

It seems that bitmap lookup routine for allocation_map in
a100u2w driver is simply wrong.

It cannot lookup more than first 32 bits. If all first 32 bits
are not set, it always returns 33-th orc_scb even though the 33-th bit
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
