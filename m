From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V4 0/4] scsi: ufs: Improve UFS error handling
Date: Tue, 23 Jul 2013 12:38:38 +0530
Message-ID: <1374563322-22846-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42350 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab3GWHIx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jul 2013 03:08:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org

The first patch fixes many issues with current task management handling
in UFSHCD driver. Others improve error handling in various scenarios.

These patches depends on:
[PATCH V4 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
[PATCH V4 2/2] scsi: ufs: Set fDeviceInit flag to initiate device initialization
[PATCH V4 1/2] scsi: ufs: Add support for host assisted background operations
[PATCH V4 2/2] scsi: ufs: Add runtime PM support for UFS host controller driver

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


Sujit Reddy Thumma (4):
  scsi: ufs: Fix broken task management command implementation
  scsi: ufs: Fix hardware race conditions while aborting a command
  scsi: ufs: Fix device and host reset methods
  scsi: ufs: Improve UFS fatal error handling

 drivers/scsi/ufs/ufshcd.c | 1003 ++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/ufs/ufshcd.h |   12 +-
 drivers/scsi/ufs/ufshci.h |   19 +-
 3 files changed, 841 insertions(+), 193 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.

