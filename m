From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Tue, 6 Jul 2010 17:31:37 -0400
Message-ID: <20100706213136.GA21246@redhat.com>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab0GFVbs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 17:31:48 -0400
Content-Disposition: inline
In-Reply-To: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On Tue, Jul 06 2010 at  3:01am -0400,
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> I confirmed that mkfs.xfs worked with Intel X25-M (trim) and
> scsi_debug (write same and unmap).
> 
> REQ_TYPE_FS should give the same scsi_cmnd struct as REQ_TYPE_BLOCK_PC.
> 
> This can be applied to block's for-2.6.36.
> 
> The git tree is also available:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-discard
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
> 
> The block layer (file systems) sends discard requests as REQ_TYPE_FS
> (the role of REQ_TYPE_FS is that setting up commands and interpreting
> the results). But SCSI-ml treats discard requests as
> REQ_TYPE_BLOCK_PC.
> 
> scsi-ml can handle discard requests as REQ_TYPE_FS
> easily. scsi_setup_discard_cmnd() sets up struct request and the bio
> nicely. Only remaining issue is that discard requests can't be
> completed partially so we need to modify sd_done.
> 
> This conversion also fixes the problem that discard requests aren't
> retried when possible (e.g. UNIT ATTENTION).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Unfortunately this patch causes 'mkfs.ext4 -F /dev/sda' to fail against
a device whose discard support is implemented using WRITE SAME 16 w/
discard bit set.  This is with recent e2fsprogs that issues BLKDISCARD
ioctl at start of mkfs:

sd 2:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 2:0:0:0: [sda] Sense Key : Illegal Request [current] 
Info fld=0x0
sd 2:0:0:0: [sda] Add. Sense: Parameter value invalid
sd 2:0:0:0: [sda] CDB: Write same(16): 93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00
end_request: I/O error, dev sda, sector 0

If I revert your patch I don't see this.

Mike
