From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.23-rc1
Date: Sun, 29 Jul 2007 09:49:52 -0500
Message-ID: <1185720592.3434.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58695 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762878AbXG2Oty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 10:49:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is basically a set of bug fixes with a few minor cleanups thrown
in.  There are also a few bsg fixes we're taking through this tree
because SCSI is the current sole consumer. The reason for the huge size
is the lindent of the advansys driver along with a few cleanups.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Alan Cox (1):
      aacraid: Fix security hole

Boaz Harrosh (1):
      qla2xxx: Data accessors Cleanup of last merge

Chip Coldwell (1):
      sym53c8xx: don't claim cpqarray device

Darrick J. Wong (1):
      libsas: SMP request handler shouldn't crash when rphy is NULL

FUJITA Tomonori (3):
      simscsi: convert to use the data buffer accessors
      bsg: remove unnecessary code and comments
      bsg: use lib/idr.c to find a unique minor number

James Bottomley (2):
      aic79xx, aic7xxx: Fix incorrect width setting
      bsg: fix unused variable warnings for BLK_DEV_BSG=n

Jeff Garzik (1):
      libsas: Remove PCI dependencies

Jesper Juhl (1):
      libsas: Fix potential NULL dereference in sas_smp_get_phy_events()

Matthew Wilcox (1):
      advansys: lindent and other large, uninteresting changes

Mike Christie (4):
      iscsi_tcp: Turn off bounce buffers
      libiscsi: fix cmd seqeunce number checking
      iscsi_tcp, ib_iser Enable module refcounting for iscsi host template
      libiscsi: make sure session is not blocked when removing host

Paul Mundt (1):
      bsg: Fix build for CONFIG_BLOCK=n

Prakash, Sathya (5):
      mpt fusion: Changes in mptctl.c for logging support
      mpt fusion: Changes in mptfc.c mptlan.c mptsas.c and mptspi.c for logging support
      mpt fusion: Changes in mptscsih.c for logging support
      mpt fusion: Changes in mptbase.c for logging support
      mpt fusion: logging support in Kconfig, Makefile, mptbase.h and addition of mptdebug.h

Salyzyn, Mark (4):
      aacraid: fix Sunrise Lake reset handling
      aacraid: add SCSI SYNCHONIZE_CACHE range checking
      aacraid: draw line in sand, sundry cleanup and version update
      aacraid: sysfs adapter reset/status format change.

Seokmann Ju (1):
      qla2xxx: fix to honor ignored parameters in sysfs attributes

akpm@linux-foundation.org (1):
      add easyRAID to the no report luns blacklist


And the diffstat:

 arch/ia64/hp/sim/simscsi.c               |   66 
 block/Kconfig                            |    4 
 block/bsg.c                              |   78 
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 
 drivers/message/fusion/Kconfig           |   14 
 drivers/message/fusion/Makefile          |   37 
 drivers/message/fusion/mptbase.c         |  467 
 drivers/message/fusion/mptbase.h         |  198 
 drivers/message/fusion/mptctl.c          |  266 
 drivers/message/fusion/mptdebug.h        |  288 
 drivers/message/fusion/mptfc.c           |  108 
 drivers/message/fusion/mptlan.c          |    3 
 drivers/message/fusion/mptsas.c          |  276 
 drivers/message/fusion/mptscsih.c        |  446 
 drivers/message/fusion/mptspi.c          |   53 
 drivers/scsi/aacraid/aachba.c            |   66 
 drivers/scsi/aacraid/aacraid.h           |    6 
 drivers/scsi/aacraid/linit.c             |    9 
 drivers/scsi/aacraid/nark.c              |    3 
 drivers/scsi/aacraid/rkt.c               |    2 
 drivers/scsi/aacraid/rx.c                |    2 
 drivers/scsi/advansys.c                  |28261 +++++++++++++++----------------
 drivers/scsi/aic7xxx/aic79xx_osm.c       |   23 
 drivers/scsi/aic7xxx/aic7xxx_osm.c       |   11 
 drivers/scsi/aic94xx/aic94xx_init.c      |    4 
 drivers/scsi/iscsi_tcp.c                 |    2 
 drivers/scsi/libiscsi.c                  |   47 
 drivers/scsi/libsas/sas_ata.c            |   30 
 drivers/scsi/libsas/sas_discover.c       |    3 
 drivers/scsi/libsas/sas_dump.c           |    2 
 drivers/scsi/libsas/sas_expander.c       |   18 
 drivers/scsi/qla2xxx/qla_attr.c          |   39 
 drivers/scsi/qla2xxx/qla_def.h           |    4 
 drivers/scsi/qla2xxx/qla_init.c          |   19 
 drivers/scsi/qla2xxx/qla_isr.c           |    4 
 drivers/scsi/scsi_devinfo.c              |    3 
 drivers/scsi/sym53c8xx_2/sym_glue.c      |    2 
 include/linux/bsg.h                      |   10 
 include/scsi/libiscsi.h                  |    3 
 include/scsi/libsas.h                    |    2 
 40 files changed, 15957 insertions(+), 14923 deletions(-)

James


