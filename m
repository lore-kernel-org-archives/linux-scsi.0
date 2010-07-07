From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of
 REQ_TYPE_BLOCK_PC
Date: Tue, 06 Jul 2010 23:07:26 -0500
Message-ID: <1278475646.15869.3.camel@mulgrave.site>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
	 <20100706213136.GA21246@redhat.com> <4C33BEDF.7050602@interlog.com>
	 <20100707004748.GA3068@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab0GGEHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 00:07:33 -0400
In-Reply-To: <20100707004748.GA3068@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, hch@lst.de, axboe@kernel.dk

On Tue, 2010-07-06 at 20:47 -0400, Mike Snitzer wrote:
> On Tue, Jul 06 2010 at  7:40pm -0400,
> Douglas Gilbert <dgilbert@interlog.com> wrote:
> 
> > On 10-07-06 05:31 PM, Mike Snitzer wrote:
> > >On Tue, Jul 06 2010 at  3:01am -0400,
> > >FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>  wrote:
> > >
> > >>I confirmed that mkfs.xfs worked with Intel X25-M (trim) and
> > >>scsi_debug (write same and unmap).
> > >>
> > >>REQ_TYPE_FS should give the same scsi_cmnd struct as REQ_TYPE_BLOCK_PC.
> > >>
> > >>This can be applied to block's for-2.6.36.
> > >>
> > >>The git tree is also available:
> > >>
> > >>git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-discard
> > >>
> > >>=
> > >>From: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> > >>Subject: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
> > >>
> > >>The block layer (file systems) sends discard requests as REQ_TYPE_FS
> > >>(the role of REQ_TYPE_FS is that setting up commands and interpreting
> > >>the results). But SCSI-ml treats discard requests as
> > >>REQ_TYPE_BLOCK_PC.
> > >>
> > >>scsi-ml can handle discard requests as REQ_TYPE_FS
> > >>easily. scsi_setup_discard_cmnd() sets up struct request and the bio
> > >>nicely. Only remaining issue is that discard requests can't be
> > >>completed partially so we need to modify sd_done.
> > >>
> > >>This conversion also fixes the problem that discard requests aren't
> > >>retried when possible (e.g. UNIT ATTENTION).
> > >>
> > >>Signed-off-by: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> > >
> > >Unfortunately this patch causes 'mkfs.ext4 -F /dev/sda' to fail against
> > >a device whose discard support is implemented using WRITE SAME 16 w/
> > >discard bit set.  This is with recent e2fsprogs that issues BLKDISCARD
> > >ioctl at start of mkfs:
> > >
> > >sd 2:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> > >sd 2:0:0:0: [sda] Sense Key : Illegal Request [current]
> > >Info fld=0x0
> > >sd 2:0:0:0: [sda] Add. Sense: Parameter value invalid
> > >sd 2:0:0:0: [sda] CDB: Write same(16): 93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00
> > >end_request: I/O error, dev sda, sector 0
> > 
> > That is 0x7fffff (over 8 million) blocks (4 GB) being unmapped
> > in one operation! That may exceed the "maximum unmap lba
> > count" field in the Block Limits VPD page.
> > The latest SBC draft (sbc3r22.pdf) says that field applies to
> > the SCSI UNMAP command and does not mention the WRITE SAME (16)
> > command but that is probably an oversight.
> 
> # sg_inq -p 0xb0 /dev/sda
> VPD INQUIRY: Block limits page (SBC)
>   Optimal transfer length granularity: 8 blocks
>   Maximum transfer length: 8388607 blocks

I'll lay reasonable odds this is the problem.  The standard doesn't
mention WRITE SAME for this transfer length limit, but nor does it
mention WRITE LONG ... I bet they both fail when over this.

James


