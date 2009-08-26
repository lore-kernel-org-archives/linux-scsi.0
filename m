From: Vasu Dev <vasu.dev@intel.com>
Subject: [RFC PATCH 0/9] RFC: handle queue_depth adjustments because of
	QUEUE_FULLs in scsi_error.c
Date: Wed, 26 Aug 2009 11:03:13 -0700
Message-ID: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17258 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbZHZSDN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 14:03:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

First four patches are from Mike Christie's original RFC at:-

http://www.spinics.net/lists/linux-scsi/msg35959.html
http://www.spinics.net/lists/linux-scsi/msg35962.html
http://www.spinics.net/lists/linux-scsi/msg35961.html
http://www.spinics.net/lists/linux-scsi/msg35963.html
http://www.spinics.net/lists/linux-scsi/msg35964.html

Above four patches adds ramp down code and I appended ramp
up code in following patches and tested this entire
series with libfc/fcoe. This series works fine without any
regression and also queue_depth adjustment works for both
ramp down and ramp up.

Above patches are updated to scsi-misc -rc7 plus recently
submitted 64 fcoe patches series by Rob
"[PATCH 00/64] libfc, libfcoe and fcoe updates for scsi-misc"
This series also applies cleanly to scsi-misc -rc7.

I'd appreciate review comments for added more patches for
ramp up.

I'll post my final patches to this list skipping fcoe list,
this as per Rob Love suggestion since mostly scsi changes
by this series beyond fcoe/libfc. However Rob agreed to
review/Ack fcoe/libfc changes at this list.

Mike, I'll be able to post my ramp up patches only once
you send final patches for ramp down on which my patches
depends. As I said your patches are tested for libfc,
so most common code is already tested and they are
good go as far as libfc goes.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>

---

Mike Christie (4):
      drivers: convert fc drivers calling scsi_track_queue_full
      drivers: convert drivers setting the change_queue_depth callback
      scsi error: have scsi-ml call change_queue_depth to handle QUEUE_FULL
      scsi-ml: modify change_queue_depth to take in reason why it is being called

Vasu Dev (5):
      libfc: adds queue_depth ramp up to libfc
      fcoe, libfc: fix an libfc issue with queue ramp down in libfc
      scsi: add common queue_depth ramp up code
      scsi: adds sdev->queue_ramp_up_period to sysfs
      scsi: updates sdev to add queue_depth ramp up code


 drivers/ata/libata-scsi.c             |    6 ++-
 drivers/ata/sata_nv.c                 |    2 -
 drivers/message/fusion/mptscsih.c     |    8 +++-
 drivers/message/fusion/mptscsih.h     |    3 +
 drivers/scsi/3w-9xxx.c                |    5 ++
 drivers/scsi/3w-xxxx.c                |    5 ++
 drivers/scsi/53c700.c                 |    5 ++
 drivers/scsi/aacraid/linit.c          |    6 ++-
 drivers/scsi/arcmsr/arcmsr_hba.c      |    5 ++
 drivers/scsi/fcoe/fcoe.c              |    2 -
 drivers/scsi/hptiop.c                 |    5 ++
 drivers/scsi/ibmvscsi/ibmvfc.c        |    7 +++
 drivers/scsi/ibmvscsi/ibmvscsi.c      |    7 +++
 drivers/scsi/ipr.c                    |    7 +++
 drivers/scsi/libfc/fc_fcp.c           |   47 ++++++++++-----------
 drivers/scsi/libsas/sas_scsi_host.c   |    6 ++-
 drivers/scsi/lpfc/lpfc_scsi.c         |   75 ++++++++++++++++++---------------
 drivers/scsi/megaraid/megaraid_mbox.c |    7 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |   10 +++-
 drivers/scsi/qla2xxx/qla_isr.c        |   32 --------------
 drivers/scsi/qla2xxx/qla_os.c         |   32 +++++++++++++-
 drivers/scsi/scsi.c                   |   10 ++++
 drivers/scsi/scsi_error.c             |   64 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c              |    1 
 drivers/scsi/scsi_sysfs.c             |   41 +++++++++++++++++-
 include/linux/libata.h                |    2 -
 include/scsi/libfc.h                  |    2 -
 include/scsi/libsas.h                 |    3 +
 include/scsi/scsi_device.h            |    8 ++--
 include/scsi/scsi_host.h              |    9 ++++
 30 files changed, 295 insertions(+), 127 deletions(-)

-- 
Signature
