From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Tue, 6 Jul 2010 20:47:48 -0400
Message-ID: <20100707004748.GA3068@redhat.com>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
 <20100706213136.GA21246@redhat.com>
 <4C33BEDF.7050602@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab0GGAsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 20:48:06 -0400
Content-Disposition: inline
In-Reply-To: <4C33BEDF.7050602@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, axboe@kernel.dk

On Tue, Jul 06 2010 at  7:40pm -0400,
Douglas Gilbert <dgilbert@interlog.com> wrote:

> On 10-07-06 05:31 PM, Mike Snitzer wrote:
> >On Tue, Jul 06 2010 at  3:01am -0400,
> >FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>  wrote:
> >
> >>I confirmed that mkfs.xfs worked with Intel X25-M (trim) and
> >>scsi_debug (write same and unmap).
> >>
> >>REQ_TYPE_FS should give the same scsi_cmnd struct as REQ_TYPE_BLOCK_PC.
> >>
> >>This can be applied to block's for-2.6.36.
> >>
> >>The git tree is also available:
> >>
> >>git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-discard
> >>
> >>=
> >>From: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> >>Subject: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
> >>
> >>The block layer (file systems) sends discard requests as REQ_TYPE_FS
> >>(the role of REQ_TYPE_FS is that setting up commands and interpreting
> >>the results). But SCSI-ml treats discard requests as
> >>REQ_TYPE_BLOCK_PC.
> >>
> >>scsi-ml can handle discard requests as REQ_TYPE_FS
> >>easily. scsi_setup_discard_cmnd() sets up struct request and the bio
> >>nicely. Only remaining issue is that discard requests can't be
> >>completed partially so we need to modify sd_done.
> >>
> >>This conversion also fixes the problem that discard requests aren't
> >>retried when possible (e.g. UNIT ATTENTION).
> >>
> >>Signed-off-by: FUJITA Tomonori<fujita.tomonori@lab.ntt.co.jp>
> >
> >Unfortunately this patch causes 'mkfs.ext4 -F /dev/sda' to fail against
> >a device whose discard support is implemented using WRITE SAME 16 w/
> >discard bit set.  This is with recent e2fsprogs that issues BLKDISCARD
> >ioctl at start of mkfs:
> >
> >sd 2:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> >sd 2:0:0:0: [sda] Sense Key : Illegal Request [current]
> >Info fld=0x0
> >sd 2:0:0:0: [sda] Add. Sense: Parameter value invalid
> >sd 2:0:0:0: [sda] CDB: Write same(16): 93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00
> >end_request: I/O error, dev sda, sector 0
> 
> That is 0x7fffff (over 8 million) blocks (4 GB) being unmapped
> in one operation! That may exceed the "maximum unmap lba
> count" field in the Block Limits VPD page.
> The latest SBC draft (sbc3r22.pdf) says that field applies to
> the SCSI UNMAP command and does not mention the WRITE SAME (16)
> command but that is probably an oversight.

# sg_inq -p 0xb0 /dev/sda
VPD INQUIRY: Block limits page (SBC)
  Optimal transfer length granularity: 8 blocks
  Maximum transfer length: 8388607 blocks
  Optimal transfer length: 128 blocks
  Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
# cat /sys/block/sda/queue/discard_granularity 
512
# cat /sys/block/sda/queue/discard_max_bytes 
4294966784

I'll look to understand why 'discard_max_bytes' is so large for this LUN
despite the standard Block limits VPD page not reflecting this.

Here is a SCSI trace with Tomo's patch REQ_TYPE_FS applied:

           blkid-1425  [001] 1272477.814205: scsi_dispatch_cmd_start: host_no=2 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(WRITE_SAME_16 lba=0 txlen=8388607 protect=0 unmap=1 raw=93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00)
          <idle>-0     [000] 1272477.815199: scsi_dispatch_cmd_done: host_no=2 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(WRITE_SAME_16 lba=0 txlen=8388607 protect=0 unmap=1 raw=93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_CHECK_CONDITION)

and without:

          <idle>-0     [001] 1272933.144045: scsi_dispatch_cmd_start: host_no=2 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(WRITE_SAME_16 lba=0 txlen=8388607 protect=0 unmap=1 raw=93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00)
          <idle>-0     [000] 1272933.144726: scsi_dispatch_cmd_done: host_no=2 channel=0 id=0 lun=0 data_sgl=1 prot_sgl=0 cmnd=(WRITE_SAME_16 lba=0 txlen=8388607 protect=0 unmap=1 raw=93 08 00 00 00 00 00 00 00 00 00 7f ff ff 00 00) result=(driver=DRIVER_OK host=DID_OK message=COMMAND_COMPLETE status=SAM_STAT_CHECK_CONDITION)

So it seems the transition away from BLOCK_PC to REQ_TYPE_FS has enabled
us to actually know about malformed SCSI requests without special SCSI
tracing.

This appears to be a welcomed side-effect of using REQ_TYPE_FS.

Mike
