From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 00/10] handles queue_depth adjustments in scsi_error.c
Date: Thu, 03 Sep 2009 15:22:25 -0700
Message-ID: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZICWWX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:22:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

This patch series moves the QUEUE_FULL and then the ramp
up code from drivers like qla2xxx and lpfc to scsi-ml.
The change_queue_depth callback is used to allow the
drivers to adjust the queue depth, so LLDs do not have
to worry about parsing the sense, see some additional
info on these changes in first RFC cover at:-

http://www.spinics.net/lists/linux-scsi/msg35959.html

I've tested this series with libfc/fcoe for queue_depth
ramp down and up.

This series is based on scsi-misc -rc7 and also cleanly
applies & works on top recently submitted 64 fcoe patches
series by Rob "[PATCH 00/64] libfc, libfcoe and fcoe
updates for scsi-misc"

I'm posting this series with Mike and Christof patches
per this mail thread discussion
http://marc.info/?l=linux-scsi&m=125196587107768&w=2

Signed-off-by: Vasu Dev <vasu.dev@intel.com>

---

Christof Schmitt (1):
      zfcp: Adapt change_queue_depth for queue full tracking

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


 drivers/ata/libata-scsi.c             |    7 +++
 drivers/ata/sata_nv.c                 |    2 -
 drivers/message/fusion/mptscsih.c     |    9 +++-
 drivers/message/fusion/mptscsih.h     |    3 +
 drivers/s390/scsi/zfcp_scsi.c         |   21 ++++++++-
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
 drivers/scsi/libiscsi.c               |    4 +-
 drivers/scsi/libsas/sas_scsi_host.c   |    6 ++-
 drivers/scsi/lpfc/lpfc_scsi.c         |   75 ++++++++++++++++++---------------
 drivers/scsi/megaraid/megaraid_mbox.c |    7 +++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |   10 +++-
 drivers/scsi/qla2xxx/qla_isr.c        |   32 --------------
 drivers/scsi/qla2xxx/qla_os.c         |   32 +++++++++++++-
 drivers/scsi/scsi.c                   |   10 ++++
 drivers/scsi/scsi_error.c             |   62 +++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c              |    1 
 drivers/scsi/scsi_sysfs.c             |   41 +++++++++++++++++-
 include/linux/libata.h                |    2 -
 include/scsi/libfc.h                  |    2 -
 include/scsi/libiscsi.h               |    3 +
 include/scsi/libsas.h                 |    3 +
 include/scsi/scsi_device.h            |    8 ++--
 include/scsi/scsi_host.h              |    8 +++-
 33 files changed, 317 insertions(+), 132 deletions(-)

-- 
