From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 00/19] SCSI patches for kernel v4.14
Date: Wed, 23 Aug 2017 14:39:50 -0700
Message-ID: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45883 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdHWVk4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:40:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The patches in this series fall into two categories:
- Two patches are related to using blk_mq_rq_to_pdu() instead of
  struct request.special.
- Seventeen patches suppress warnings reported by static analysis
  tools. These tools are very useful but unfortunately the current
  code base makes these tools report a significant number of false
  positives.

Please consider these patches for kernel v4.14.

Thanks,

Bart.

Bart Van Assche (19):
  Remove an obsolete function declaration
  Avoid sign extension of scsi_device.type
  Suppress gcc 7 fall-through warnings reported with W=1
  Convert a strncmp() call into a strcmp() call
  scsi_setup_fs_cmnd(): Call scsi_req_init() instead of open-coding it
  Document which queue type a function is intended for
  Fix RCU handling of scsi_device.vpd_pg8[03]
  Use blk_mq_rq_to_pdu() to convert a request to a SCSI command pointer
  sd, sr: Convert two assignments into warning statements
  sd: Fix indentation
  sd: Remove a useless comparison
  sg: Fix type of last blk_trace_setup() argument
  libiscsi: Fix indentation
  libsas: Remove a set-but-not-used variable
  libsas: Annotate fall-through in a switch statement
  scsi_transport_sas, sas_tlr_supported(): Check kzalloc() return value
  scsi_transport_srp: Suppress a W=1 compiler warning
  scsi_debug: Remove a set-but-not-used variable
  iscsi_tcp: Remove a set-but-not-used variable

 drivers/scsi/iscsi_tcp.c            |  2 --
 drivers/scsi/libiscsi.c             |  2 +-
 drivers/scsi/libsas/sas_ata.c       |  1 +
 drivers/scsi/libsas/sas_scsi_host.c |  3 ---
 drivers/scsi/scsi.c                 |  6 +++---
 drivers/scsi/scsi_debug.c           |  3 +--
 drivers/scsi/scsi_error.c           | 10 ++++++++--
 drivers/scsi/scsi_ioctl.c           |  4 +++-
 drivers/scsi/scsi_lib.c             | 36 +++++++++++++++++++++---------------
 drivers/scsi/scsi_sysfs.c           |  9 ++++++---
 drivers/scsi/scsi_transport_sas.c   |  3 +++
 drivers/scsi/scsi_transport_srp.c   |  2 +-
 drivers/scsi/sd.c                   |  6 +++---
 drivers/scsi/sg.c                   |  3 +--
 drivers/scsi/sr.c                   |  2 +-
 include/scsi/scsi_cmnd.h            |  1 -
 include/scsi/scsi_device.h          |  2 +-
 include/scsi/scsi_tcq.h             |  2 +-
 18 files changed, 55 insertions(+), 42 deletions(-)

-- 
2.14.0
