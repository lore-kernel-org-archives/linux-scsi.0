From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] 3ware scsi_dma_unmap fix
Date: Wed, 6 May 2009 13:11:37 +0900
Message-ID: <20090506131234Q.fujita.tomonori@lab.ntt.co.jp>
References: <20090506091238I.fujita.tomonori@lab.ntt.co.jp>
	<b1bc6a000905051725y167f6b67pa243807954eda78a@mail.gmail.com>
	<20090506093400K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [192.16.179.4] ([192.16.179.4]:48713 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbZEFENt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 00:13:49 -0400
In-Reply-To: <20090506093400K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aradford@gmail.com
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Wed, 6 May 2009 09:33:45 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 5 May 2009 17:25:40 -0700
> adam radford <aradford@gmail.com> wrote:
> 
> > I wouldn't do that.  The generic_buffer_virt stuff is there because
> > the hardware can't DMA < 512 bytes, so we sg_copy_to/from_buffer()
> > there, then dma from generic_buffer_virt.
> 
> Thanks, I see. Yeah, if the hardware can't DMA < 512 bytes, the driver
> needs such workaround.

I have one more question about this issue.

Looks like the driver can't work properly in the case of the length <
512 bytes and scsi_sg_count > 1. That is, the driver says that the
request is successful but the data isn't copied fully. Note that
applications can send such requests with SG_IO and iovec. Can't we
remove the scsi_sg_count(srb) == 1 tests?

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 8b7983a..0d8b1c0 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1847,8 +1847,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 		/* Map sglist from scsi layer to cmd packet */
 
 		if (scsi_sg_count(srb)) {
-			if ((scsi_sg_count(srb) == 1) &&
-			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
+			if (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH) {
 				if (srb->sc_data_direction == DMA_TO_DEVICE ||
 				    srb->sc_data_direction == DMA_BIDIRECTIONAL)
 					scsi_sg_copy_to_buffer(srb,
@@ -1924,11 +1923,9 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 	if (scsi_bufflen(cmd) < TW_MIN_SGL_LENGTH &&
 	    (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	     cmd->sc_data_direction == DMA_BIDIRECTIONAL)) {
-		if (scsi_sg_count(cmd) == 1) {
-			void *buf = tw_dev->generic_buffer_virt[request_id];
+		void *buf = tw_dev->generic_buffer_virt[request_id];
 
-			scsi_sg_copy_from_buffer(cmd, buf, TW_SECTOR_SIZE);
-		}
+		scsi_sg_copy_from_buffer(cmd, buf, TW_SECTOR_SIZE);
 	}
 } /* End twa_scsiop_execute_scsi_complete() */
 
