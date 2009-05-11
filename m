From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len, take#2
Date: Mon, 11 May 2009 15:06:01 +0300
Message-ID: <4A0814A9.5040603@panasas.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com
List-Id: linux-scsi@vger.kernel.org

On 05/04/2009 10:58 AM, Tejun Heo wrote:
> Hello,
> 
> Upon ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len
> 
> This is the second take of block-unify-sector-and-data_len patchset.
> The primary goal of this patchset is to consolidate all the similar
> bug slightly different current position and data length fields in
> struct request.  For detailed description, please read the description
> in the last take[L].  Changes from the last take[L] are
> 
> * Acked-by:'s added
> 
> * osd resid_len conversion was missing as pointed out by Boaz Harrosh,
>   fixed.
> 
> * patch to cleanup request length accessor usages after the conversion
>   added.
> 
> This patchset contains the following eleven patches.
> 
>   0001-nbd-don-t-clear-rq-sector-and-nr_sectors-unnecessa.patch
>   0002-ide-tape-don-t-initialize-rq-sector-for-rw-request.patch
>   0003-block-add-rq-resid_len.patch
>   0004-block-implement-blk_rq_pos-cur_-sectors-and-conv.patch
>   0005-block-convert-to-pos-and-nr_sectors-accessors.patch
>   0006-ide-convert-to-rq-pos-and-nr_sectors-accessors.patch
>   0007-block-drop-request-hard_-and-nr_sectors.patch
>   0008-block-cleanup-rq-data_len-usages.patch
>   0009-ide-cleanup-rq-data_len-usages.patch
>   0010-block-hide-request-sector-and-data_len.patch
>   0011-block-blk_rq_-cur_-_-sectors-bytes-usage-cleanup.patch
> 
> This patchset is on top of
> 
>   linux-2.6-block#for-2.6.31	(f68adec3c7155a8bbf32a90cb4c4d0737df045d9)
> + linux-2.6-ide#for-next	(03682411b1ccd38cbde2e9a6ab43884ff34fbefc)
> 
> and contains the following changes.
> 
>  arch/um/drivers/ubd_kern.c               |    2 
>  block/as-iosched.c                       |   18 +++--
>  block/blk-barrier.c                      |    4 -
>  block/blk-core.c                         |  100 ++++++++++++-------------------
>  block/blk-map.c                          |    2 
>  block/blk-merge.c                        |   46 ++------------
>  block/blk.h                              |    1 
>  block/bsg.c                              |    8 +-
>  block/cfq-iosched.c                      |   30 ++++-----
>  block/deadline-iosched.c                 |    2 
>  block/elevator.c                         |   22 +++---
>  block/scsi_ioctl.c                       |    2 
>  drivers/ata/libata-scsi.c                |    2 
>  drivers/block/DAC960.c                   |    6 -
>  drivers/block/amiflop.c                  |    6 -
>  drivers/block/ataflop.c                  |   10 +--
>  drivers/block/cciss.c                    |   35 ++++------
>  drivers/block/cpqarray.c                 |    9 +-
>  drivers/block/floppy.c                   |   54 ++++++++--------
>  drivers/block/hd.c                       |   14 ++--
>  drivers/block/nbd.c                      |   19 +----
>  drivers/block/paride/pcd.c               |    4 -
>  drivers/block/paride/pd.c                |    8 +-
>  drivers/block/paride/pf.c                |    8 +-
>  drivers/block/ps3disk.c                  |    9 +-
>  drivers/block/sunvdc.c                   |    2 
>  drivers/block/swim3.c                    |   34 +++++-----
>  drivers/block/sx8.c                      |    6 -
>  drivers/block/ub.c                       |   16 ++--
>  drivers/block/viodasd.c                  |    8 +-
>  drivers/block/virtio_blk.c               |    2 
>  drivers/block/xd.c                       |    4 -
>  drivers/block/xen-blkfront.c             |   11 +--
>  drivers/block/xsysace.c                  |   25 ++++---
>  drivers/block/z2ram.c                    |    6 -
>  drivers/cdrom/gdrom.c                    |    6 -
>  drivers/cdrom/viocd.c                    |    2 
>  drivers/ide/ide-atapi.c                  |   13 ----
>  drivers/ide/ide-cd.c                     |   44 ++++---------
>  drivers/ide/ide-disk.c                   |    8 +-
>  drivers/ide/ide-dma.c                    |    2 
>  drivers/ide/ide-floppy.c                 |   10 +--
>  drivers/ide/ide-io.c                     |   10 +--
>  drivers/ide/ide-lib.c                    |    2 
>  drivers/ide/ide-tape.c                   |   11 +--
>  drivers/ide/ide-taskfile.c               |    2 
>  drivers/ide/pdc202xx_old.c               |    2 
>  drivers/ide/tc86c001.c                   |    2 
>  drivers/ide/tx4939ide.c                  |    2 
>  drivers/memstick/core/mspro_block.c      |    6 -
>  drivers/message/fusion/mptsas.c          |   21 +++---
>  drivers/message/i2o/i2o_block.c          |   28 +++-----
>  drivers/mmc/card/block.c                 |   10 +--
>  drivers/mtd/mtd_blkdevs.c                |    7 +-
>  drivers/s390/block/dasd.c                |    2 
>  drivers/s390/block/dasd_diag.c           |    5 -
>  drivers/s390/block/dasd_eckd.c           |    6 -
>  drivers/s390/block/dasd_fba.c            |    7 +-
>  drivers/s390/char/tape_34xx.c            |    2 
>  drivers/s390/char/tape_3590.c            |    2 
>  drivers/s390/char/tape_block.c           |    2 
>  drivers/sbus/char/jsflash.c              |    4 -
>  drivers/scsi/eata.c                      |   24 +++----
>  drivers/scsi/libsas/sas_expander.c       |   14 +---
>  drivers/scsi/libsas/sas_host_smp.c       |   52 ++++++++--------
>  drivers/scsi/lpfc/lpfc_scsi.c            |   22 +++---
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |   23 +++----
>  drivers/scsi/osd/osd_initiator.c         |    4 -
>  drivers/scsi/scsi_lib.c                  |   46 ++++++--------
>  drivers/scsi/scsi_tgt_lib.c              |    2 
>  drivers/scsi/sd.c                        |   24 +++----
>  drivers/scsi/sd_dif.c                    |    2 
>  drivers/scsi/sg.c                        |    2 
>  drivers/scsi/sr.c                        |   15 ++--
>  drivers/scsi/st.c                        |    2 
>  drivers/scsi/u14-34f.c                   |   22 +++---
>  fs/exofs/osd.c                           |    4 -
>  include/linux/bio.h                      |    6 -
>  include/linux/blkdev.h                   |   56 ++++++++++-------
>  include/linux/elevator.h                 |    2 
>  include/scsi/scsi_cmnd.h                 |    2 
>  kernel/trace/blktrace.c                  |   16 ++--
>  82 files changed, 508 insertions(+), 585 deletions(-)
> 
> Thanks.
> 
> --
> tejun
> 
> [L] http://lkml.org/lkml/2009/4/29/173


Hi Tejun

I've inspected all scsi touching patches and refrained from comments
on the simple rename bunch. They all look very good accept that one
place. (which will effect 2 patches)

There are few more places that can use blk_end_request_all() after
these changes.

(The same internet outage on this reply)

Thanks
Boaz
