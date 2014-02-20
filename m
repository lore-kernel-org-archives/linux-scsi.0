From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 0/5] qla2xxx: NPIV target mode fixes for v3.14-rc
Date: Thu, 20 Feb 2014 21:03:24 +0000
Message-ID: <1392930209-25065-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sawan Chandak <sawan.chandak@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Sawan, Quinn, & Co.

The following series addresses a number of NPIV related bugs specific
to v3.14-rc code, mostly involving the underlying configfs dependency
of base_vha / base_tpg to not be removed while there are active NPIV
ports.

Patch #1 fixes a race between the qlt_lport_register() callback and
subsequent shutdown operations.

Patch #2 ensures that shutdown of a base_vha port fails when there
are active npiv_ports_inuse.

Patch #3 adds seperate enable/disable attribute logic that is specific
to NPIV operation, and patch #4 adds the configfs_[un]depend_item()
calls in ensure that base_vha / base_tpg cannot be removed from the
configfs hierarchy until all associated NPIV ports have been shutdown.

And patch #5 fixes a seperate issue with NAA formatting of EVPD=0x83
device identifier for NPIV WWPNs.

Please review.

Thanks!

--nab

Nicholas Bellinger (5):
  qla2xxx: Fix qlt_lport_register base_vha callback race
  qla2xxx: Check + fail when npiv_vports_inuse exists in shutdown
  tcm_qla2xxx: Add NPIV specific enable/disable attribute logic
  tcm_qla2xxx: Perform configfs depend/undepend for base_tpg
  tcm_qla2xxx: Fix NAA formatted name for NPIV WWPNs

 drivers/scsi/qla2xxx/qla_target.c  |   39 +++++++--
 drivers/scsi/qla2xxx/qla_target.h  |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  158 ++++++++++++++++++++++++++----------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    7 +-
 4 files changed, 153 insertions(+), 53 deletions(-)

-- 
1.7.10.4
