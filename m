From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.25-rc4
Date: Wed, 05 Mar 2008 16:26:17 -0600
Message-ID: <1204755977.3047.103.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52696 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbYCEW0X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 17:26:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Apart from the usual crop of bug fixes, it is hoped that both gdth
(under all circumstances) and aic94xx (under protocol errors) now work
after this.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Andrew Vasquez (4):
      qla2xxx: Update version number to 8.02.00-k9.
      qla2xxx: Correct usage of inconsistent timeout values while issuing ELS co
      qla2xxx: Correct discrepancies during OVERRUN handling on FWI2-capable car
      qla2xxx: Correct needless clean-up resets during shutdown.

Boaz Harrosh (2):
      gdth: fix to internal commands execution
      gdth: bugfix for the at-exit problems

FUJITA Tomonori (6):
      tgt: fix build errors when dprintk is defined
      tgt: set the data length properly
      tgt: stop zero'ing scsi_cmnd
      ibmvstgt: set up scsi_host properly before __scsi_alloc_queue
      ps3rom: disable clustering
      ps3rom: fix wrong resid calculation bug

James Bottomley (6):
      aic94xx: fix TMF ascb handling to prevent sequencer panic
      libsas: misc fixes to the eh path
      libsas: use the supplied address for SATA devices rather than changing it
Andrew Vasquez (4):
      qla2xxx: Update version number to 8.02.00-k9.
      qla2xxx: Correct usage of inconsistent timeout values while issuing ELS co
      qla2xxx: Correct discrepancies during OVERRUN handling on FWI2-capable car
      qla2xxx: Correct needless clean-up resets during shutdown.

Boaz Harrosh (2):
      gdth: fix to internal commands execution
      gdth: bugfix for the at-exit problems

FUJITA Tomonori (6):
      tgt: fix build errors when dprintk is defined
      tgt: set the data length properly
      tgt: stop zero'ing scsi_cmnd
      ibmvstgt: set up scsi_host properly before __scsi_alloc_queue
      ps3rom: disable clustering
      ps3rom: fix wrong resid calculation bug

James Bottomley (6):
      aic94xx: fix TMF ascb handling to prevent sequencer panic
      libsas: misc fixes to the eh path
      libsas: use the supplied address for SATA devices rather than changing it
      aic94xx: plumb in I_T_nexus_reset task management function
      libsas: export sas_find_local_phy function
      mvsas: remove execute permission from file

Ke Wei (1):
      mvsas: fix phy sas address

Krzysztof Oledzki (1):
      mpt fusion: don't oops if NumPhys==0

Mike Christie (4):
      iscsi class: regression - fix races with state manipulation and blocking/u
      qla4xxx: regression - add start scan callout
      qla4xxx: fix host reset dpc race
      iscsi regression: check for zero max session cmds

Nick Cheng (1):
      arcmsr: update version and changelog

Randy Dunlap (2):
      docbook: fix fusion source files
      docbook: fix scsi source file


And the diffstat:

 Documentation/scsi/ChangeLog.arcmsr |    6 
 drivers/message/fusion/mptbase.c    |   25 +-
 drivers/message/fusion/mptsas.c     |    5 
 drivers/message/fusion/mptscsih.c   |   14 -
 drivers/scsi/aic94xx/aic94xx.h      |    1 
 drivers/scsi/aic94xx/aic94xx_hwi.h  |    3 
 drivers/scsi/aic94xx/aic94xx_init.c |    2 
 drivers/scsi/aic94xx/aic94xx_task.c |    4 
 drivers/scsi/aic94xx/aic94xx_tmf.c  |  304 ++++++++++++++++++++++--------------
 drivers/scsi/arcmsr/arcmsr.h        |    2 
 drivers/scsi/gdth.c                 |  112 ++++---------
 drivers/scsi/gdth.h                 |    1 
 drivers/scsi/ibmvscsi/ibmvstgt.c    |    9 -
 drivers/scsi/libiscsi.c             |    4 
 drivers/scsi/libsas/sas_ata.c       |   39 ----
 drivers/scsi/libsas/sas_port.c      |   11 -
 drivers/scsi/libsas/sas_scsi_host.c |   34 +---
 drivers/scsi/mvsas.c                |   11 -
 drivers/scsi/ps3rom.c               |    4 
 drivers/scsi/qla2xxx/qla_gs.c       |   10 -
 drivers/scsi/qla2xxx/qla_init.c     |   11 -
 drivers/scsi/qla2xxx/qla_isr.c      |    5 
 drivers/scsi/qla2xxx/qla_mbx.c      |    2 
 drivers/scsi/qla2xxx/qla_version.h  |    2 
 drivers/scsi/qla4xxx/ql4_init.c     |    2 
 drivers/scsi/qla4xxx/ql4_os.c       |   39 ++--
 drivers/scsi/scsi_scan.c            |    3 
 drivers/scsi/scsi_tgt_lib.c         |    6 
 drivers/scsi/scsi_transport_iscsi.c |   78 +++++----
 include/scsi/libsas.h               |    1 
 include/scsi/scsi_transport_iscsi.h |    2 
 31 files changed, 403 insertions(+), 349 deletions(-)

James


