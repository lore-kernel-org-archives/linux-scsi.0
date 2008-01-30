From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] intermediate SCSI update for 2.6.24
Date: Wed, 30 Jan 2008 15:44:31 -0600
Message-ID: <1201729471.3292.97.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50155 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbYA3Voh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2008 16:44:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This isn't the final update I promised, most of this is fixing bugs in
the previous update which became more evident with wider testing (a
nasty set of cases where we have &cmnd->sense_buffer instead of
&cmnd->sense_buffer[0] which cause problems now that sense_buffer is a
pointer instead and a bug in the setup of immediate request sense
commands that lead to some USB devices becoming unusable).  However, the
two feature updates it has are to convert SCSI to allow it to use
bidirectional commands and to make sg chaining the default (drivers now
turn it off simply by setting their sg_tablesize to something which
won't excite chaining).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Boaz Harrosh (3):
      bidirectional command support
      implement scsi_data_buffer
      tgt: use scsi_init_io instead of scsi_alloc_sgtable

David Milburn (1):
      aic7xxx: fix ahc_done check SCB_ACTIVE for tagged transactions

FUJITA Tomonori (11):
      handle scsi_init_queue failure properly
      destroy scsi_bidi_sdb_cache in scsi_exit_queue
      scsi_debug: add XDWRITEREAD_10 support
      scsi_debug: add bidi data transfer support
      scsi_debug: add get_data_transfer_info helper function
      aic7xxx: fix warnings with CONFIG_PM disabled
      aic79xx: fix warnings with CONFIG_PM disabled
      zfcp: fix sense_buffer access bug
      ncr53c8xx: fix sense_buffer access bug
      aic79xx: fix sense_buffer access bug
      hptiop: fix sense_buffer access bug

James Bottomley (3):
      Revert "[SCSI] aacraid: fib context lock for management ioctls"
      bsg: copy the cmd_type field to the subordinate request for bidi
      remove use_sg_chaining

Kiyoshi Ueda (1):
      bidirectional: fix up for the new blk_end_request code

Nathan Lynch (1):
      sym53c8xx: fix bad memset argument in sym_set_cam_result_error

Thomas Bogendoerfer (1):
      sgiwd93: use cached memory access to make driver work on IP28


And the diffstat:

 arch/ia64/hp/sim/simscsi.c             |    1 
 block/bsg.c                            |    1 
 drivers/infiniband/ulp/srp/ib_srp.c    |    1 
 drivers/s390/scsi/zfcp_fsf.c           |    4 
 drivers/scsi/3w-9xxx.c                 |    1 
 drivers/scsi/3w-xxxx.c                 |    1 
 drivers/scsi/BusLogic.c                |    1 
 drivers/scsi/Kconfig                   |    2 
 drivers/scsi/NCR53c406a.c              |    1 
 drivers/scsi/a100u2w.c                 |    1 
 drivers/scsi/aacraid/commctrl.c        |   29 +--
 drivers/scsi/aacraid/linit.c           |    1 
 drivers/scsi/aha1740.c                 |    1 
 drivers/scsi/aic7xxx/aic79xx.h         |    5 
 drivers/scsi/aic7xxx/aic79xx_core.c    |    2 
 drivers/scsi/aic7xxx/aic79xx_osm.c     |    3 
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |   33 +--
 drivers/scsi/aic7xxx/aic79xx_pci.c     |    2 
 drivers/scsi/aic7xxx/aic7xxx.h         |    4 
 drivers/scsi/aic7xxx/aic7xxx_core.c    |    3 
 drivers/scsi/aic7xxx/aic7xxx_osm.c     |   10 -
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |   33 +--
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |    2 
 drivers/scsi/aic7xxx_old.c             |    1 
 drivers/scsi/arcmsr/arcmsr_hba.c       |    1 
 drivers/scsi/dc395x.c                  |    1 
 drivers/scsi/dpt_i2o.c                 |    1 
 drivers/scsi/eata.c                    |    1 
 drivers/scsi/hosts.c                   |    1 
 drivers/scsi/hptiop.c                  |    3 
 drivers/scsi/ibmmca.c                  |    1 
 drivers/scsi/ibmvscsi/ibmvscsi.c       |    1 
 drivers/scsi/initio.c                  |    1 
 drivers/scsi/iscsi_tcp.c               |    1 
 drivers/scsi/libsrp.c                  |    4 
 drivers/scsi/lpfc/lpfc_scsi.c          |    2 
 drivers/scsi/mac53c94.c                |    1 
 drivers/scsi/megaraid.c                |    1 
 drivers/scsi/megaraid/megaraid_mbox.c  |    1 
 drivers/scsi/megaraid/megaraid_sas.c   |    1 
 drivers/scsi/mesh.c                    |    1 
 drivers/scsi/ncr53c8xx.c               |    2 
 drivers/scsi/nsp32.c                   |    1 
 drivers/scsi/pcmcia/sym53c500_cs.c     |    1 
 drivers/scsi/qla1280.c                 |    1 
 drivers/scsi/qla2xxx/qla_os.c          |    2 
 drivers/scsi/qla4xxx/ql4_os.c          |    1 
 drivers/scsi/qlogicfas.c               |    1 
 drivers/scsi/scsi.c                    |    2 
 drivers/scsi/scsi_debug.c              |  174 ++++++++++++++------
 drivers/scsi/scsi_error.c              |   33 +--
 drivers/scsi/scsi_lib.c                |  274 +++++++++++++++++++--------------
 drivers/scsi/scsi_tgt_lib.c            |   28 ---
 drivers/scsi/sd.c                      |    4 
 drivers/scsi/sgiwd93.c                 |   64 ++++---
 drivers/scsi/sr.c                      |   25 +--
 drivers/scsi/stex.c                    |    1 
 drivers/scsi/sym53c416.c               |    1 
 drivers/scsi/sym53c8xx_2/sym_glue.c    |    3 
 drivers/scsi/u14-34f.c                 |    1 
 drivers/scsi/ultrastor.c               |    1 
 drivers/scsi/wd7000.c                  |    1 
 drivers/usb/storage/isd200.c           |    8 
 include/scsi/scsi.h                    |   20 ++
 include/scsi/scsi_cmnd.h               |   59 +++++--
 include/scsi/scsi_eh.h                 |    9 -
 include/scsi/scsi_host.h               |   17 --
 67 files changed, 493 insertions(+), 407 deletions(-)

James


