From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 00/17] A series of small SCSI patches for kernel v4.14
Date: Fri, 25 Aug 2017 13:46:26 -0700
Message-ID: <20170825204643.25043-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40785 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932911AbdHYUr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 16:47:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The patches in this series fall into three categories:
- One patch renames a few functions to make it clear whether these
  are used by the legacy SCSI code path or by the new scsi-mq code.
- Two patches are related to using blk_mq_rq_to_pdu() instead of
  struct request.special.
- Fourteen patches suppress warnings reported by static analysis
  tools. These tools are very useful but unfortunately the current
  code base makes these tools report a significant number of false
  positives.

Please consider these patches for kernel v4.14.

Thanks,

Bart.

Changes in v2 compared to v1:
- Left out the SCSI device VPD patch from this series and posted it
  separately as a two-patch series.
- Reworked patch "scsi_transport_srp: Suppress a W=1 compiler warning".
- Dropped the patch "scsi_setup_fs_cmnd(): Call scsi_req_init() instead of
  open-coding it".

Bart Van Assche (17):
  Remove an obsolete function declaration
  Avoid sign extension of scsi_device.type
  Suppress gcc 7 fall-through warnings reported with W=1
  Convert a strncmp() call into a strcmp() call
  Document which queue type a function is intended for
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
 drivers/scsi/scsi_debug.c           |  3 +--
 drivers/scsi/scsi_error.c           | 10 +++++++--
 drivers/scsi/scsi_ioctl.c           |  4 +++-
 drivers/scsi/scsi_lib.c             | 41 +++++++++++++++++++------------------
 drivers/scsi/scsi_priv.h            |  2 +-
 drivers/scsi/scsi_scan.c            |  2 +-
 drivers/scsi/scsi_sysfs.c           |  2 +-
 drivers/scsi/scsi_transport_sas.c   |  3 +++
 drivers/scsi/scsi_transport_srp.c   |  2 +-
 drivers/scsi/sd.c                   |  6 +++---
 drivers/scsi/sg.c                   |  3 +--
 drivers/scsi/sr.c                   |  2 +-
 include/scsi/scsi_cmnd.h            |  1 -
 include/scsi/scsi_device.h          |  2 +-
 include/scsi/scsi_tcq.h             |  2 +-
 include/scsi/scsi_transport_srp.h   |  2 +-
 20 files changed, 50 insertions(+), 45 deletions(-)

-- 
2.14.1
