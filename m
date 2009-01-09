From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] more SCSI updates for 2.6.28
Date: Thu, 08 Jan 2009 18:10:59 -0600
Message-ID: <1231459859.3237.116.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34340 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187AbZAIALE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2009 19:11:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the second round of SCSI updates for the current merge window.
It also includes a round of bug fixes for the previous updates ...

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Al Viro (1):
      cxgb3i: add missing include

Alan Stern (1):
      Fix uninitialized variable error in scsi_io_completion

Andrew Vasquez (8):
      qla2xxx: Update version number to 8.03.00-k1.
      qla2xxx: Add ISP81XX support.
      qla2xxx: Use proper request/response queues with MQ instantiations.
      qla2xxx: Correct MQ-chain information retrieval during a firmware dump.
      qla2xxx: Collapse EFT/FCE copy procedures during a firmware dump.
      qla2xxx: Don't pollute kernel logs with ZIO/RIO status messages.
      qla2xxx: Don't fallback to interrupt-polling during re-initialization with
      qla2xxx: Remove support for reading/writing HW-event-log.

Brian King (2):
      ibmvscsi: Make max_requests module parameter more accurate
      ibmvfc: Fixup command response translation

Christoph Hellwig (2):
      clean up scsi_times_out
      remove severly outdated comment in scsi_dispatch_cmd

Dmitri Vorobiev (1):
      sgiwd93: Fix compilation warning

FUJITA Tomonori (14):
      st: remove unused frp_sg_current
      st: remove unused orig_frp_segs
      st: simplify new_tape_buffer
      st: remove struct scatterlist
      st: kill struct st_buff_fragment
      st: remove buf_to_sg
      st: convert dio path to use st_scsi_execute
      st: convert non-dio path to use st_scsi_execute
      st: add st_scsi_execute helper function
      st: add struct rq_map_data support
      st: make all the fragment buffers the same size
      block: make blk_rq_map_user take a NULL user-space buffer for WRITE
      block: fix the partial mappings with struct rq_map_data
      block: fix bio_add_page misuse with rq_map_data

Geert Uytterhoeven (1):
      a2091, gvp11: kill warn_unused_result warnings

James Bottomley (2):
      scsi_lib: fix DID_RESET status problems
      scsi_lib: don't decrement busy counters when inserting commands

James Smart (1):
      fc transport: restore missing dev_loss_tmo callback to LLDD

Julia Lawall (2):
      fusion: Move a dereference below a NULL test
      lpfc: Move a dereference below a NULL test

Kai Makisara (2):
      st: retry enlarge_buffer allocation
      st: integrate st_scsi_kern_execute and st_do_scsi

Kay Sievers (1):
      struct device - replace bus_id with dev_name(), dev_set_name()

Larry Finger (1):
      aha152x_cs: Fix regression that keeps driver from using shared interrupts

Martin K. Petersen (4):
      sd: Correctly handle 6-byte commands with DIX
      sd: DIF: Fix tagging on platforms with signed char
      sd: DIF: Show app tag on error
      Fix error handling for DIF/DIX

Reinhard Nissl (1):
      mvsas: increase port type detection delay to suit Seagate's 10k6 drive ST3

Roel Kluin (1):
      libsas: fix test for negative unsigned and typos


And the diffstat:

 block/blk-map.c                     |   19 -
 drivers/message/fusion/mptctl.c     |    5 
 drivers/misc/enclosure.c            |    8 
 drivers/scsi/NCR_D700.c             |    2 
 drivers/scsi/a2091.c                |   18 -
 drivers/scsi/advansys.c             |    2 
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    2 
 drivers/scsi/cxgb3i/cxgb3i_ddp.c    |    1 
 drivers/scsi/gvp11.c                |    8 
 drivers/scsi/hosts.c                |    6 
 drivers/scsi/ibmvscsi/ibmvfc.c      |   14 -
 drivers/scsi/ibmvscsi/ibmvscsi.c    |   16 -
 drivers/scsi/ipr.c                  |    2 
 drivers/scsi/ipr.h                  |    2 
 drivers/scsi/lasi700.c              |    3 
 drivers/scsi/libsas/sas_discover.c  |    2 
 drivers/scsi/libsas/sas_dump.c      |    2 
 drivers/scsi/libsas/sas_host_smp.c  |   12 
 drivers/scsi/libsas/sas_port.c      |    2 
 drivers/scsi/lpfc/lpfc_init.c       |    3 
 drivers/scsi/mvsas.c                |    2 
 drivers/scsi/pcmcia/aha152x_stub.c  |    2 
 drivers/scsi/qla2xxx/qla_attr.c     |   26 +
 drivers/scsi/qla2xxx/qla_dbg.c      |  462 +++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_dbg.h      |   40 ++
 drivers/scsi/qla2xxx/qla_def.h      |   33 +-
 drivers/scsi/qla2xxx/qla_dfs.c      |    3 
 drivers/scsi/qla2xxx/qla_fw.h       |  294 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h      |   10 
 drivers/scsi/qla2xxx/qla_gs.c       |    9 
 drivers/scsi/qla2xxx/qla_init.c     |  295 ++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c     |   12 
 drivers/scsi/qla2xxx/qla_isr.c      |   82 ++++--
 drivers/scsi/qla2xxx/qla_mbx.c      |   41 +--
 drivers/scsi/qla2xxx/qla_mid.c      |    4 
 drivers/scsi/qla2xxx/qla_os.c       |  139 ++++++----
 drivers/scsi/qla2xxx/qla_sup.c      |  263 ++++++-------------
 drivers/scsi/qla2xxx/qla_version.h  |    6 
 drivers/scsi/raid_class.c           |    3 
 drivers/scsi/scsi.c                 |    4 
 drivers/scsi/scsi_debug.c           |    4 
 drivers/scsi/scsi_error.c           |   24 -
 drivers/scsi/scsi_ioctl.c           |    9 
 drivers/scsi/scsi_lib.c             |  119 +++++---
 drivers/scsi/scsi_scan.c            |    7 
 drivers/scsi/scsi_sysfs.c           |   12 
 drivers/scsi/scsi_transport_fc.c    |   39 ++
 drivers/scsi/scsi_transport_iscsi.c |   11 
 drivers/scsi/scsi_transport_sas.c   |   42 +--
 drivers/scsi/scsi_transport_srp.c   |    2 
 drivers/scsi/sd.c                   |    2 
 drivers/scsi/sd_dif.c               |   17 -
 drivers/scsi/ses.c                  |    2 
 drivers/scsi/sg.c                   |    2 
 drivers/scsi/sgiwd93.c              |    3 
 drivers/scsi/sim710.c               |    4 
 drivers/scsi/sni_53c710.c           |    3 
 drivers/scsi/st.c                   |  492 ++++++++++++++++--------------------
 drivers/scsi/st.h                   |   14 -
 drivers/scsi/zalon.c                |    4 
 fs/bio.c                            |   36 +-
 include/linux/blkdev.h              |    2 
 include/scsi/scsi_transport_fc.h    |    1 
 63 files changed, 1851 insertions(+), 859 deletions(-)

James


