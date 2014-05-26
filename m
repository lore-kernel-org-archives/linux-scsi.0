From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [RESEND PATCH V7 0/6] scsi: ufs: TM, fatal-error handling and other fixes
Date: Mon, 26 May 2014 10:59:09 +0530
Message-ID: <1401082155-23184-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: vinholikatti@gmail.com, santoshsy@gmail.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch version fixes various static checker warnings along with fixing
usage of deprecated flush_work_sync() API that led James drop the patchset
from scsi-misc tree.

The first patch fixes many issues with current task management handling
in UFSHCD driver. Others improve error handling in various scenarios.

These patches are rebased on scsi-misc and are ack'ed by UFS maintainer.

Changes from v6:
	- Two new patches to fix static checker warnings
	- remove usage of deprecated flush_work_sync() API.
Changes from v5:
	- correct typo in [PATCH V5 1/4] scsi: ufs: Fix broken task ...
	- correct poll wait in [PATCH V5 2/4] scsi: ufs: Fix hardware ...
	- Included Tested-by and Reviewed-by ack's.
Changes from v4:
	- Addressed comments from Seungwon Jeon on V3
	- Updated with proper locking while ufshcd state changes
	- Retained LUN reset instead of device reset with DME_END_POINT_RESET
	- Removed error handling decisions dependent on OCS value
	- Simplified fatal error handling to abort the requests first
	  and then carry out reset.
Changes from v3:
	- Rebased.
Changes from v2:
	- [PATCH V3 1/4]: Make the task management command task tag unique
	  across SCSI/NOP/QUERY request tags.
	- [PATCH V3 3/4]: While handling device/host reset, wait for
	  pending fatal handler to return if running.
Changes from v1:
	- [PATCH V2 1/4]: Fix a race condition because of overloading
	  outstanding_tasks variable to lock the slots. A new variable
	  tm_slots_in_use will track which slots are in use by the driver.
	- [PATCH V2 2/4]: Commit text update to clarify the hardware race
	  with more details.
	- [PATCH V2 3/4]: Minor cleanup and rebase
	- [PATCH V2 4/4]: Fix a bug - sleeping in atomic context

Sujit Reddy Thumma (6):
  scsi: ufs: fix endianness sparse warnings
  scsi: ufs: make undeclared functions static
  scsi: ufs: Fix broken task management command implementation
  scsi: ufs: Fix hardware race conditions while aborting a command
  scsi: ufs: Fix device and host reset methods
  scsi: ufs: Improve UFS fatal error handling

 drivers/scsi/ufs/ufs.h    |  36 +--
 drivers/scsi/ufs/ufshcd.c | 722 +++++++++++++++++++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h |  22 +-
 drivers/scsi/ufs/ufshci.h |  32 +-
 4 files changed, 545 insertions(+), 267 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
