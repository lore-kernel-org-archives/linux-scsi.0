From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 00/11] qla2xxx: Feature updates for target.
Date: Fri, 23 Dec 2016 20:23:28 -0800
Message-ID: <1482553419-4117-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

Hi Bart, Christoph, 

We have added new features to the qla2xxx target driver. This patch series
enables simultaneous initiator and target mode in the driver. As part of
supporting simultaneous initator and target mode we also improved Fabric
discovery which relies heavily on newly added dual mode code. We also have
improved RSCN handling in fabric mode. 

To support simplified fabric discovery we restructured I-T nexus into single
fc_port struct, so that we can manage fc_port more efficiently in the driver,
while operating in an initator, target or dual mode.

Asynchronous fabric discovery patch also prepared code for simultaneous intiator
and target mode enablement in the driver. Also with addition of dual mode support,
I have added a seperate patch which cleans up unused reverse_ini_mode(). 

SRR related code cleanup was submitted earlier as part of another patch. I have 
now split SRR cleanup into patch by itself and have included here for cosiderations. 

Trace readabilty improvement is a small subset which was missed in earlier bug-fixes
patch series. I've included that as part of this series. 

This patch series is based on the earlier bug-fixes series that I posted today. 

Here's link for that series 

http://marc.info/?l=linux-scsi&m=148254518825278&w=2

Please consider this series for target-pending. 

Thanks, 
Himanshu

Himanshu Madhani (2):
  qla2xxx: Cleanup SRR code.
  qla2xxx: Remove unused reverse_ini_mode.

Quinn Tran (9):
  qla2xxx: Remove direct access of scsi_status field in se_cmd
  qla2xxx: Cleanup TMF code translation from qla_target.
  qla2xxx: Make trace flags more readable.
  qla2xxx: Fix wrong argument in sp done callback.
  qla2xxx: Use d_id instead of s_id for more clarity.
  qla2xxx: Track I-T nexus as single fc_port struct.
  qla2xxx: Add framework for Async fabric discovery.
  qla2xxx: Add Dual mode support in the driver
  qla2xxx: Improve RSCN handling in driver

 drivers/scsi/qla2xxx/qla_attr.c    |    3 +
 drivers/scsi/qla2xxx/qla_def.h     |  221 +++-
 drivers/scsi/qla2xxx/qla_dfs.c     |   10 +-
 drivers/scsi/qla2xxx/qla_fw.h      |   90 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   58 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  726 +++++++++--
 drivers/scsi/qla2xxx/qla_init.c    | 1547 +++++++++++++++++------
 drivers/scsi/qla2xxx/qla_inline.h  |    7 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   73 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  290 +++--
 drivers/scsi/qla2xxx/qla_mbx.c     |  214 ++--
 drivers/scsi/qla2xxx/qla_mr.c      |    6 +-
 drivers/scsi/qla2xxx/qla_os.c      |  296 +++--
 drivers/scsi/qla2xxx/qla_target.c  | 2359 +++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_target.h  |  176 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  238 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    4 +-
 17 files changed, 4042 insertions(+), 2276 deletions(-)

-- 
1.8.3.1
