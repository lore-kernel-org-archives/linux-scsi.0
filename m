From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 2/6] bidi support: request_io_part
Date: Tue, 23 Jan 2007 10:40:34 +0200
Message-ID: <45B5CA02.3020300@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:35620 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932412AbXAWIkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 03:40:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

The patch was probably too big and did not go through the mailing list.
I have compressed and attached it, is that OK or must I put it online somewhere?


- Extract all I/O members of struct request into a request_io_part member.
- Define API to access the I/O part
- Adjust block layer accordingly.
- Change all users to new API.

At this stage it is all still uni-directional but the intention is clear.

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

---
 arch/um/drivers/ubd_kern.c      |   12 +-
 block/as-iosched.c              |   16 ++--
 block/cfq-iosched.c             |   14 ++--
 block/deadline-iosched.c        |    6 +-
 block/elevator.c                |   26 +++---
 block/ll_rw_blk.c               |  207 ++++++++++++++++++++-------------------
 block/scsi_ioctl.c              |    4 +-
 drivers/acorn/block/fd1772.c    |   18 ++--
 drivers/acorn/block/mfmhd.c     |   23 +++--
 drivers/block/DAC960.c          |    6 +-
 drivers/block/amiflop.c         |   10 +-
 drivers/block/ataflop.c         |   18 ++--
 drivers/block/cciss.c           |   26 +++---
 drivers/block/cpqarray.c        |   12 +-
 drivers/block/floppy.c          |   50 +++++-----
 drivers/block/nbd.c             |   14 ++--
 drivers/block/paride/pcd.c      |    4 +-
 drivers/block/paride/pd.c       |    8 +-
 drivers/block/paride/pf.c       |    6 +-
 drivers/block/ps2esdi.c         |   10 +-
 drivers/block/swim3.c           |   32 +++---
 drivers/block/sx8.c             |    8 +-
 drivers/block/ub.c              |   18 ++--
 drivers/block/viodasd.c         |    8 +-
 drivers/block/xd.c              |    4 +-
 drivers/block/z2ram.c           |    6 +-
 drivers/cdrom/aztcd.c           |   34 +++---
 drivers/cdrom/cdrom.c           |    2 +-
 drivers/cdrom/cdu31a.c          |    4 +-
 drivers/cdrom/cm206.c           |    6 +-
 drivers/cdrom/gscd.c            |   20 ++--
 drivers/cdrom/mcdx.c            |   12 +-
 drivers/cdrom/optcd.c           |   32 +++---
 drivers/cdrom/sbpcd.c           |   26 +++---
 drivers/cdrom/sjcd.c            |   32 +++---
 drivers/cdrom/sonycd535.c       |    4 +-
 drivers/cdrom/viocd.c           |    4 +-
 drivers/ide/ide-cd.c            |  189 ++++++++++++++++++-----------------
 drivers/ide/ide-disk.c          |    6 +-
 drivers/ide/ide-dma.c           |    6 +-
 drivers/ide/ide-floppy.c        |   16 ++--
 drivers/ide/ide-io.c            |   22 ++--
 drivers/ide/ide-lib.c           |    2 +-
 drivers/ide/ide-tape.c          |   32 +++---
 drivers/ide/ide-taskfile.c      |   21 +++--
 drivers/ide/legacy/hd.c         |   26 +++---
 drivers/ide/pci/pdc202xx_old.c  |    2 +-
 drivers/md/dm-emc.c             |    3 +-
 drivers/message/i2o/i2o_block.c |   22 ++--
 drivers/mmc/mmc_block.c         |    6 +-
 drivers/mtd/mtd_blkdevs.c       |    4 +-
 drivers/s390/block/dasd.c       |    2 +-
 drivers/s390/block/dasd_diag.c  |    4 +-
 drivers/s390/block/dasd_eckd.c  |    6 +-
 drivers/s390/block/dasd_fba.c   |    6 +-
 drivers/s390/char/tape_34xx.c   |    2 +-
 drivers/s390/char/tape_3590.c   |    2 +-
 drivers/s390/char/tape_block.c  |    4 +-
 drivers/sbus/char/jsflash.c     |    4 +-
 drivers/scsi/eata.c             |   22 ++--
 drivers/scsi/ide-scsi.c         |    2 +-
 drivers/scsi/scsi_lib.c         |   43 ++++----
 drivers/scsi/scsi_tgt_lib.c     |   16 ++--
 drivers/scsi/sd.c               |   16 ++--
 drivers/scsi/sr.c               |   14 ++--
 drivers/scsi/u14-34f.c          |   16 ++--
 include/linux/blkdev.h          |   99 ++++++++++++-------
 include/linux/blktrace_api.h    |    7 +-
 include/linux/elevator.h        |    2 +-
 69 files changed, 707 insertions(+), 659 deletions(-)
 Total size     :148.5 KB
 Compressed Size: 36.6 KB
