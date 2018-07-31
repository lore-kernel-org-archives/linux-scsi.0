From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 0/9] block: Consolidate scsi sense buffer usage
Date: Tue, 31 Jul 2018 12:51:45 -0700
Message-ID: <20180731195155.46664-1-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Thomas Gleixner <tglx@linutronix.de>, Philippe Ombredanne <pombredanne@nexb.com>, Stephen Boyd <sboyd@codeaurora.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>, Juergen Gross <jgross@suse.com>, Viresh Kumar <viresh.kumar@linaro.org>, =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pen>
List-Id: linux-scsi@vger.kernel.org

This is a follow-up to commit f7068114d45e ("sr: pass down correctly
sized SCSI sense buffer") which further cleans up and removes needless
sense character array buffers and "struct request_sense" usage in favor
of the common "struct scsi_sense_hdr".

First, drop a bunch of unused sense buffers:
 [PATCH 1/9] ide-cd: Drop unused sense buffers
 [PATCH 2/9] scsi: cxlflash: Drop unused sense buffers

Next, allow the sense buffer to be usable outside SCSI tree:
 [PATCH 3/9] scsi: build scsi_common.o for all scsi passthrough request users
 [PATCH 4/9] target: don't depend on SCSI

Then move all request_sense usage to scsi_sense_hdr:
 [PATCH 5/9] block: Switch struct packet_command to use struct scsi_sense_hdr

And do some further cleanups for scsi_sense_hdr now that we can:
 [PATCH 6/9] ide-cd: Remove redundant sense buffer
 [PATCH 7/9] cdrom: Use struct scsi_sense_hdr internally

Finally add a build-time check to make sure we don't pass bad buffer sizes:
 [PATCH 8/9] libata-scsi: Move sense buffers onto stack
 [PATCH 9/9] scsi: Check sense buffer size at build time


-Kees

Christoph Hellwig (2):
  scsi: build scsi_common.o for all scsi passthrough request users
  target: don't depend on SCSI

Kees Cook (7):
  ide-cd: Drop unused sense buffers
  scsi: cxlflash: Drop unused sense buffers
  block: Switch struct packet_command to use struct scsi_sense_hdr
  ide-cd: Remove redundant sense buffer
  cdrom: Use struct scsi_sense_hdr internally
  libata-scsi: Move sense buffers onto stack
  scsi: Check sense buffer size at build time

 drivers/Makefile                  |  2 +-
 drivers/ata/libata-scsi.c         | 18 +++------
 drivers/block/Kconfig             |  2 +-
 drivers/block/pktcdvd.c           | 36 +++++++++---------
 drivers/cdrom/cdrom.c             | 30 ++++++++-------
 drivers/ide/ide-cd.c              | 58 ++++++++++++++---------------
 drivers/ide/ide-cd.h              |  6 +--
 drivers/ide/ide-cd_ioctl.c        | 62 +++++++++++++------------------
 drivers/scsi/Makefile             |  2 +-
 drivers/scsi/cxlflash/superpipe.c |  8 +---
 drivers/scsi/cxlflash/vlun.c      |  7 +---
 drivers/scsi/scsi_lib.c           |  6 +--
 drivers/scsi/sr_ioctl.c           | 22 +++++------
 drivers/target/Kconfig            |  5 ++-
 include/linux/cdrom.h             |  3 +-
 include/scsi/scsi_cmnd.h          |  6 +--
 include/scsi/scsi_device.h        | 14 ++++++-
 17 files changed, 136 insertions(+), 151 deletions(-)

-- 
2.17.1
