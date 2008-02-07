From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: Latest git oopses during boot
Date: Thu, 7 Feb 2008 23:32:42 +0900
Message-ID: <20080207233239Z.tomof@acm.org>
References: <8120cfd40802070144l79830c2cs6329c302697ecc8b@mail.gmail.com>
	<20080207020214.0f0cf1c7.akpm@linux-foundation.org>
	<8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44339 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbYBGOcz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Feb 2008 09:32:55 -0500
In-Reply-To: <8120cfd40802070314x2799bcbatf42e3fe824a18c22@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: skogtun.linux@gmail.com
Cc: akpm@linux-foundation.org, tomof@acm.org, torvalds@linux-foundation.org, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 7 Feb 2008 12:14:56 +0100
"Harald Arnesen" <skogtun.linux@gmail.com> wrote:

> On 2/7/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > (cc's restored, and expanded a bit)
> 
> Ah, sorry, not used to gmail's web interface. Clicked the wrong button.
> 
> > > Seems to be the advansys driver, so I tried to remove it - and indeed,
> > > the kernel now boots. So I guess it's either that driver or my ancient
> > > Nikon Coolscan II that is the only thing attached to the board.
> >
> > Thanks.  I uploaded the oops picture to
> > http://userweb.kernel.org/~akpm/oops.jpg
> >
> > > Cc to the Matthew Wilcox added.
> >
> > mm...  looks like all Matthew's changes were in 2.6.23.  And 2.6.23 worked
> > OK, yes?
> 
> Both 2.6.23 and 2.6.24 are ok.
> 
> > The only recent changes to drivers/scsi/advansys.c are
> >
> > commit b80ca4f7ee36c26d300c5a8f429e73372d153379
> > Author: FUJITA Tomonori <tomof@acm.org>
> > Date:   Sun Jan 13 15:46:13 2008 +0900
> >
> >     [SCSI] replace sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE
> >
> >     This replaces sizeof sense_buffer with SCSI_SENSE_BUFFERSIZE in
> >     several LLDs. It's a preparation for the future changes to remove
> >     sense_buffer array in scsi_cmnd structure.
> >
> >     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> >
> > :100644 100644 9dd3952... 492702b... M  drivers/scsi/advansys.c
> >
> > commit 747d016e7e25e216b31022fe2b012508d99fb682
> > Author: Randy Dunlap <randy.dunlap@oracle.com>
> > Date:   Mon Jan 14 00:55:18 2008 -0800
> >
> >     advansys: fix section mismatch warning
> >
> >     Fix section mismatch warning:
> >
> >     WARNING: vmlinux.o(.exit.text+0x152a): Section mismatch: reference to .init.
> >
> >     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >     Cc: Matthew Wilcox <willy@debian.org>
> >     Cc: James Bottomley <James.Bottomley@steeleye.com>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >
> > which seem fairly benign.
> >
> >
> > gcc inlining is going to make it rather a lot of work to find out which
> > statement has actually oopsed there.
> -- 

Can you try this?

Thanks,

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 374ed02..f5dde12 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -566,7 +566,7 @@ typedef struct asc_dvc_var {
 	ASC_SCSI_BIT_ID_TYPE unit_not_ready;
 	ASC_SCSI_BIT_ID_TYPE queue_full_or_busy;
 	ASC_SCSI_BIT_ID_TYPE start_motor;
-	uchar overrun_buf[ASC_OVERRUN_BSIZE] __aligned(8);
+	uchar *overrun_buf;
 	dma_addr_t overrun_dma;
 	uchar scsi_reset_wait;
 	uchar chip_no;
@@ -13833,6 +13833,12 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	 */
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DBG(2, "AscInitAsc1000Driver()\n");
+
+		asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
+		if (!asc_dvc_varp->overrun_buf) {
+			ret = -ENOMEM;
+			goto err_free_wide_mem;
+		}
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
 		if (warn_code || asc_dvc_varp->err_code) {
@@ -13840,8 +13846,10 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 					"warn 0x%x, error 0x%x\n",
 					asc_dvc_varp->init_state, warn_code,
 					asc_dvc_varp->err_code);
-			if (asc_dvc_varp->err_code)
+			if (asc_dvc_varp->err_code) {
 				ret = -ENODEV;
+				kfree(asc_dvc_varp->overrun_buf);
+			}
 		}
 	} else {
 		if (advansys_wide_init_chip(shost))
@@ -13891,9 +13899,11 @@ static int advansys_release(struct Scsi_Host *shost)
 		free_dma(shost->dma_channel);
 	}
 	if (ASC_NARROW_BOARD(board)) {
+		ASC_DVC_VAR *asc_dvc_varp = &board->dvc_var.asc_dvc_var;
 		dma_unmap_single(board->dev,
 					board->dvc_var.asc_dvc_var.overrun_dma,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(asc_dvc_varp->overrun_buf);
 	} else {
 		iounmap(board->ioremap_addr);
 		advansys_wide_free_mem(board);
