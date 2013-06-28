From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V2 0/4] scsi: ufs: Improve UFS error handling
Date: Sat, 29 Jun 2013 00:05:27 +0530
Message-ID: <1372444531-24340-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The first patch fixes many issues with current task management handling
in UFSHCD driver. Others improve error handling in various scenarios.

These patches depends on:
[PATCH 01/10] scsi: ufs: wrap the i/o access operations
[PATCH 02/10] scsi: ufs: amend interrupt configuration
[PATCH 03/10] scsi: ufs: remove version check before IS reg clear
[PATCH 04/10] scsi: ufs: rework link start-up process
[PATCH 05/10] scsi: ufs: Fix the response UPIU length setting
[PATCH 06/10] scsi: ufs: use devres functions for ufshcd
[PATCH 07/10] ufshcd-pltfrm: add missing empty slot in ufs_of_match[]
[PATCH 08/10] ufs: fix register address in UIC error interrupt handling
[PATCH 09/10] ufshcd-pltfrm: remove unnecessary dma_set_coherent_mask() call
[PATCH 10/10] ufs: fix DMA mask setting
[PATCH V2 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
[PATCH V2 2/2] scsi: ufs: Set fDeviceInit flag to initiate device initialization
[PATCH V2 1/2] scsi: ufs: Add support for host assisted background operations
[PATCH V2 2/2] scsi: ufs: Add runtime PM helpers for UFS host driver

Changes from v1:
	- [PATCH V2 1/4]: Fix a race condition because of overloading
	  outstanding_tasks variable to lock the slots. A new variable
	  tm_slots_in_use will track which slots are in use by the driver.
	- [PATCH V2 2/4]: Commit text update to clarify the hardware race
	  with more details.
	- [PATCH V2 3/4]: Minor cleanup and rebase
	- [PATCH V2 4/4]: Fix a bug - sleeping in atomic context

Sujit Reddy Thumma (4):
  scsi: ufs: Fix broken task management command implementation
  scsi: ufs: Fix hardware race conditions while aborting a command
  scsi: ufs: Fix device and host reset methods
  scsi: ufs: Improve UFS fatal error handling

 drivers/scsi/ufs/ufshcd.c | 1020 ++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/ufs/ufshcd.h |   12 +-
 drivers/scsi/ufs/ufshci.h |   19 +-
 3 files changed, 859 insertions(+), 192 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
