From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V2 0/2] scsi: ufs: Add support to control UFS device background operations
Date: Fri, 28 Jun 2013 23:46:41 +0530
Message-ID: <1372443403-21830-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:47584 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3F1SQ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 14:16:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org

Add host assisted background operations for UFS device and runtime PM
helpers for ufshcd platform and pci glue drivers. The background operations
are disabled during runtime resume and enabled when the device is idle and
runtime suspended.

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

Changes from v1:
	- Minor cleanup and rebase
	- Forced enable of auto bkops during initialization to make sure device
	  and driver state are matched.

Sujit Reddy Thumma (2):
  scsi: ufs: Add support for host assisted background operations
  scsi: ufs: Add runtime PM helpers for UFS host driver

 drivers/scsi/ufs/ufs.h           |   25 +++-
 drivers/scsi/ufs/ufshcd-pci.c    |   60 ++++++-
 drivers/scsi/ufs/ufshcd-pltfrm.c |   41 +++++
 drivers/scsi/ufs/ufshcd.c        |  337 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h        |   10 +
 5 files changed, 466 insertions(+), 7 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.

