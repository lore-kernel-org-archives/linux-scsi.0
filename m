From: Tejun Heo <tj@kernel.org>
Subject: [GIT PATCH] block,scsi,ide: unify sector and data_len
Date: Wed, 29 Apr 2009 18:13:38 +0900
Message-ID: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:48082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbZD2JU1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Apr 2009 05:20:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-unify-sector-and-data_len

This is the first take of block-unify-sector-and-data_len patchset.
The primary goal of this patchset is to consolidate all the similar
bug slightly different current position and data length fields in
struct request.

Currently, there are two current position fields - rq->sector and
rq->hard_sector.  Three possible total lengths - rq->nr_sectors,
rq->hard_nr_sectors and rq->data_len and two possible current lengths
- rq->current_nr_sectors and rq->hard_cur_sectors.

The hard_ prefixed fields are there to allow low level drivers to
modify respective fields without the hard_ prefix for partial
processing.  However, this capability can easily be replaced with
partial completion and/or blk_update_request() and in fact with recent
updates there is no remaining user.

data_len equals nr_sectors << 9 for FS requests.  For !FS requests,
nr_sectors could be zero while data_len contains the request length.
This is further complicated by the fact that data_len duals as
residual count on request completion.

All these duplications with slight variances lead to a lot of
confusion.  For example, it's not very clear what blk_rq_bytes() would
return during request processing.  It depends on the type of the
request, whether the driver supports residual byte counting and if so
how it supports that.  These subtleties show up both in block layer
and llds requiring request length caching during completion and
different completion paths depending on request type.

This patch simplifies the situation by doing the followings.

* Introduce rq->resid_len and use it for residual count.  rq->data_len
  means the left data length in the request at all times.

* Make sure nobody tinkers with rq fields directly.

* Kill rq->hard_sector and use rq->sector exclusively.

* Kill rq->nr_sectors and rq->hard_nr_sectors and use rq->data_len
  exclusively.

* Kill rq->current_nr_sectors and rq->hard_cur_sectors and use
  bio_cur_bytes(rq->bio) instead.

* Encapsulate all accesses via accessors.

* Add __ prefix to rq->sector and rq->data_len to make it clear that
  these fields are internal and llds MUST NOT access these directly.
  This field renaming is also to trigger build breakage on out-of-tree
  drivers which access and modify request fields directly which won't
  work correctly anymore.

This patchset contains the following ten patches.

  0001-nbd-don-t-clear-rq-sector-and-nr_sectors-unnecessa.patch
  0002-ide-tape-don-t-initialize-rq-sector-for-rw-request.patch
  0003-block-add-rq-resid_len.patch
  0004-block-implement-blk_rq_pos-cur_-sectors-and-conv.patch
  0005-block-convert-to-pos-and-nr_sectors-accessors.patch
  0006-ide-convert-to-rq-pos-and-nr_sectors-accessors.patch
  0007-block-drop-request-hard_-and-nr_sectors.patch
  0008-block-cleanup-rq-data_len-usages.patch
  0009-ide-cleanup-rq-data_len-usages.patch
  0010-block-hide-request-sector-and-data_len.patch

0001-0002 remove unnecessary explicit rq field clearing.

0003 adds rq->resid_len.

0004-0006 introduce and use blk_rq_pos() and blk_rq_[cur_]sectors()
accessors.

0007 drops fields with hard_ prefix.

0008-0009 replaces direct data_len usage with blk_rq_bytes().

0010 hides rq->sector and data_len.

As the patchset contains several block-ide sync points, I think it's
best to apply this series in unified series.  SCSI also received good
amount of changes.  If there's a tree I can pull from which won't be
rebased, please let me know.  If SCSI tree is gonna pull block tree
after merge, that will be fine too.

All changed llds have been compile tested, mid-high layer resid_len
handling has been verified and nothing broke during my test runs with
ide and libata.

This patchset is on top of

  linux-2.6-block#for-2.6.31	(f68adec3c7155a8bbf32a90cb4c4d0737df045d9)
+ linux-2.6-ide#for-next	(b656eba122929881c52d38ae16637167aaa5b88b)

and contains the following changes.

 arch/um/drivers/ubd_kern.c               |    2 
 block/as-iosched.c                       |   18 +++--
 block/blk-barrier.c                      |    4 -
 block/blk-core.c                         |  100 ++++++++++++-------------------
 block/blk-map.c                          |    2 
 block/blk-merge.c                        |   46 ++------------
 block/blk.h                              |    1 
 block/bsg.c                              |    8 +-
 block/cfq-iosched.c                      |   30 ++++-----
 block/deadline-iosched.c                 |    2 
 block/elevator.c                         |   22 +++---
 block/scsi_ioctl.c                       |    2 
 drivers/ata/libata-scsi.c                |    2 
 drivers/block/DAC960.c                   |    6 -
 drivers/block/amiflop.c                  |    6 -
 drivers/block/ataflop.c                  |   10 +--
 drivers/block/cciss.c                    |   35 ++++------
 drivers/block/cpqarray.c                 |    9 +-
 drivers/block/floppy.c                   |   53 ++++++++--------
 drivers/block/hd.c                       |   14 ++--
 drivers/block/nbd.c                      |   19 +----
 drivers/block/paride/pcd.c               |    4 -
 drivers/block/paride/pd.c                |    8 +-
 drivers/block/paride/pf.c                |    8 +-
 drivers/block/ps3disk.c                  |    9 +-
 drivers/block/sunvdc.c                   |    2 
 drivers/block/swim3.c                    |   34 +++++-----
 drivers/block/sx8.c                      |    6 -
 drivers/block/ub.c                       |   16 ++--
 drivers/block/viodasd.c                  |    8 +-
 drivers/block/virtio_blk.c               |    2 
 drivers/block/xd.c                       |    4 -
 drivers/block/xen-blkfront.c             |   11 +--
 drivers/block/xsysace.c                  |   25 ++++---
 drivers/block/z2ram.c                    |    6 -
 drivers/cdrom/gdrom.c                    |    6 -
 drivers/cdrom/viocd.c                    |    2 
 drivers/ide/ide-atapi.c                  |   13 ----
 drivers/ide/ide-cd.c                     |   44 ++++---------
 drivers/ide/ide-disk.c                   |    8 +-
 drivers/ide/ide-dma.c                    |    2 
 drivers/ide/ide-floppy.c                 |   10 +--
 drivers/ide/ide-io.c                     |   10 +--
 drivers/ide/ide-lib.c                    |    2 
 drivers/ide/ide-tape.c                   |   11 +--
 drivers/ide/ide-taskfile.c               |    2 
 drivers/ide/pdc202xx_old.c               |    2 
 drivers/ide/tc86c001.c                   |    2 
 drivers/ide/tx4939ide.c                  |    2 
 drivers/memstick/core/mspro_block.c      |    6 -
 drivers/message/fusion/mptsas.c          |   21 +++---
 drivers/message/i2o/i2o_block.c          |   24 ++++---
 drivers/mmc/card/block.c                 |   10 +--
 drivers/mtd/mtd_blkdevs.c                |    7 +-
 drivers/s390/block/dasd.c                |    2 
 drivers/s390/block/dasd_diag.c           |    5 -
 drivers/s390/block/dasd_eckd.c           |    6 -
 drivers/s390/block/dasd_fba.c            |    7 +-
 drivers/s390/char/tape_34xx.c            |    2 
 drivers/s390/char/tape_3590.c            |    2 
 drivers/s390/char/tape_block.c           |    2 
 drivers/sbus/char/jsflash.c              |    4 -
 drivers/scsi/eata.c                      |   24 +++----
 drivers/scsi/libsas/sas_expander.c       |   14 +---
 drivers/scsi/libsas/sas_host_smp.c       |   52 ++++++++--------
 drivers/scsi/lpfc/lpfc_scsi.c            |   22 +++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |   23 +++----
 drivers/scsi/osd/osd_initiator.c         |    4 -
 drivers/scsi/scsi_lib.c                  |   45 ++++++-------
 drivers/scsi/scsi_tgt_lib.c              |    2 
 drivers/scsi/sd.c                        |   24 +++----
 drivers/scsi/sd_dif.c                    |    2 
 drivers/scsi/sg.c                        |    2 
 drivers/scsi/sr.c                        |   15 ++--
 drivers/scsi/st.c                        |    2 
 drivers/scsi/u14-34f.c                   |   22 +++---
 fs/exofs/osd.c                           |    4 -
 include/linux/bio.h                      |    6 -
 include/linux/blkdev.h                   |   56 ++++++++++-------
 include/linux/elevator.h                 |    2 
 include/scsi/scsi_cmnd.h                 |    2 
 kernel/trace/blktrace.c                  |   16 ++--
 82 files changed, 511 insertions(+), 576 deletions(-)

Thanks.

--
tejun
