From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 00/18] Unify and simplify SCSI request initialization
Date: Fri, 19 May 2017 11:29:58 -0700
Message-ID: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:13694 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755933AbdESSa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>

Hello Martin and James,

The patches in this series unify scsi-mq and scsi-sq request initialization,
significantly simplify request initialization and fix a recently introduced
bug in the request initialization code. Please consider these patches for
kernel v4.13.

Thanks,

Bart.

Bart Van Assche (18):
  block: Introduce blk_queue_cmd_size()
  bsg: Check private request size before attaching to a queue
  pktcdvd: Check private request size before attaching to a queue
  cdrom: Check private request size before attaching to a queue
  nfsd: Check private request size before submitting a SCSI request
  scsi: Make scsi_ioctl_reset() pass the request queue pointer to
    blk_rq_init()
  block: Introduce request_queue.initialize_rq_fn()
  block: Make scsi_req_init() calls implicit
  scsi: Change argument type of scsi_req_init()
  scsi: Only add commands to the device command list if required by the
    LLD
  scsi: Move most of scsi_init_command() into scsi_initialize_rq()
  scsi: Inline scsi_init_command()
  scsi: Move sense buffer pointer initialization into
    scsi_initialize_rq()
  scsi: Make scsi_initialize_rq() zero the entire struct scsi_cmnd
  scsi: storvsc: Initialize driver-private command before using it
  scsi-mq: Make behavior scsi_mq_prep_fn() closer to that of
    scsi_prep_fn()
  scsi: Consolidate more initialization code
  scsi_setup_fs_cmnd(): Call scsi_req_init() instead of open-coding it

 block/blk-core.c                   | 13 ++++++
 block/blk-mq.c                     |  3 ++
 block/bsg.c                        |  7 ++-
 block/scsi_ioctl.c                 | 13 +++---
 drivers/block/pktcdvd.c            |  7 ++-
 drivers/cdrom/cdrom.c              |  6 ++-
 drivers/ide/ide-atapi.c            |  2 -
 drivers/ide/ide-cd.c               |  1 -
 drivers/ide/ide-cd_ioctl.c         |  1 -
 drivers/ide/ide-devsets.c          |  1 -
 drivers/ide/ide-disk.c             |  1 -
 drivers/ide/ide-ioctls.c           |  2 -
 drivers/ide/ide-park.c             |  2 -
 drivers/ide/ide-pm.c               |  2 -
 drivers/ide/ide-probe.c            |  6 +--
 drivers/ide/ide-tape.c             |  1 -
 drivers/ide/ide-taskfile.c         |  1 -
 drivers/scsi/osd/osd_initiator.c   |  2 -
 drivers/scsi/osst.c                |  1 -
 drivers/scsi/scsi.c                |  9 +---
 drivers/scsi/scsi_error.c          | 10 +++--
 drivers/scsi/scsi_lib.c            | 91 ++++++++++++++++++--------------------
 drivers/scsi/scsi_priv.h           |  3 +-
 drivers/scsi/scsi_transport_sas.c  |  6 +++
 drivers/scsi/sg.c                  |  2 -
 drivers/scsi/st.c                  |  1 -
 drivers/scsi/storvsc_drv.c         |  1 +
 drivers/target/target_core_pscsi.c |  2 -
 fs/nfsd/blocklayout.c              |  4 +-
 include/linux/blkdev.h             |  5 +++
 include/scsi/scsi_request.h        |  2 +-
 31 files changed, 112 insertions(+), 96 deletions(-)

-- 
2.12.2
