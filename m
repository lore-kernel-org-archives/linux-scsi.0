From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] final (hopefully) SCSI updates for 2.6.25
Date: Fri, 02 May 2008 13:34:38 -0500
Message-ID: <1209753278.3121.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38488 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935882AbYEBSel (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 14:34:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Actually, all but four of these are really bug fixes and driver updates.
The final feature is large command support in SCSI which we were waiting
on the block changes that Jens just merged.

The patches are available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Alan Cox (1):
      u14-34f: Fix 32bit only problem

Alan D. Brunelle (1):
      bug fix for free list handling

Boaz Harrosh (2):
      add support for variable length extended commands
      Let scsi_cmnd->cmnd use request->cmd buffer

Brian King (2):
      ibmvscsi: Handle non SCSI error status
      ipr: Rename ipr's state scsi host attribute to prevent collisions

FUJITA Tomonori (1):
      bsg: add large command support

Hannes Reinecke (1):
      megaraid_mbox: fix Dell CERC firmware problem

Jiri Slaby (1):
      megaraid_sas: fix suspend/resume sections

Mark Salyzyn (4):
      aacraid: Add Power Management support
      aacraid: Fix jbod operations scan issues
      aacraid: Fix warning about macro side-effects
      aacraid: Fix down_interruptible() to check the return value correctly

Miquel van Smoorenburg (4):
      dpt_i2o: sysfs code
      dpt_i2o: 64 bit support
      dpt_i2o: move from virt_to_bus/bus_to_virt to dma_alloc_coherent
      dpt_i2o: use standard __init / __exit code

Sam Ravnborg (1):
      aic94xx: fix section mismatch

bo yang (1):
      megaraid_sas; Update the Version and Changelog


And the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas |   22 +
 block/bsg.c                               |   12 
 block/scsi_ioctl.c                        |    5 
 drivers/firewire/fw-sbp2.c                |    2 
 drivers/s390/scsi/zfcp_dbf.c              |    2 
 drivers/s390/scsi/zfcp_fsf.c              |    2 
 drivers/scsi/53c700.c                     |    6 
 drivers/scsi/Kconfig                      |    3 
 drivers/scsi/a100u2w.c                    |    2 
 drivers/scsi/aacraid/aachba.c             |  133 +++++-
 drivers/scsi/aacraid/aacraid.h            |   28 +
 drivers/scsi/aacraid/comminit.c           |    2 
 drivers/scsi/aacraid/commsup.c            |   34 +
 drivers/scsi/aacraid/linit.c              |   22 -
 drivers/scsi/aic94xx/aic94xx_init.c       |    6 
 drivers/scsi/constants.c                  |   10 
 drivers/scsi/dpt/dpti_ioctl.h             |   16 
 drivers/scsi/dpt/dptsig.h                 |    8 
 drivers/scsi/dpt/sys_info.h               |    4 
 drivers/scsi/dpt_i2o.c                    |  640 ++++++++++++++++++++++--------
 drivers/scsi/dpti.h                       |   15 
 drivers/scsi/gdth.c                       |    2 
 drivers/scsi/hptiop.c                     |    6 
 drivers/scsi/ibmvscsi/ibmvscsi.c          |    7 
 drivers/scsi/ibmvscsi/viosrp.h            |    9 
 drivers/scsi/initio.c                     |    2 
 drivers/scsi/ipr.c                        |    2 
 drivers/scsi/megaraid/megaraid_mbox.c     |   17 
 drivers/scsi/megaraid/megaraid_mbox.h     |    1 
 drivers/scsi/megaraid/megaraid_sas.c      |   13 
 drivers/scsi/megaraid/megaraid_sas.h      |    6 
 drivers/scsi/qla1280.c                    |    4 
 drivers/scsi/scsi.c                       |   23 -
 drivers/scsi/scsi_error.c                 |   15 
 drivers/scsi/scsi_lib.c                   |    7 
 drivers/scsi/scsi_tgt_lib.c               |    2 
 drivers/scsi/u14-34f.c                    |    6 
 drivers/usb/storage/cypress_atacb.c       |    2 
 drivers/usb/storage/isd200.c              |    2 
 include/scsi/scsi.h                       |   40 +
 include/scsi/scsi_cmnd.h                  |   23 -
 include/scsi/scsi_eh.h                    |    4 
 include/scsi/scsi_host.h                  |    8 
 43 files changed, 884 insertions(+), 291 deletions(-)

James


