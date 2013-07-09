From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V3 0/2] scsi: ufs: Add support to control UFS device background operations
Date: Tue,  9 Jul 2013 14:45:34 +0530
Message-ID: <1373361336-30713-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:50382 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3GIJPs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jul 2013 05:15:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org

Add host assisted background operations for UFS device and runtime PM
helpers for ufshcd platform and pci glue drivers. The background operations
are disabled during runtime resume and enabled when the device is idle and
runtime suspended.

These patches depends on:
[PATCH V3 1/2] scsi: ufs: Add support for sending NOP OUT UPIU
[PATCH V3 2/2] scsi: ufs: Set fDeviceInit flag to initiate device initialization

Changes from v2:
	- Enable auto bkops by default explicitly during bootup so that we
	  may not assume it as enabled after reset.
	- Enable runtime PM support for contexts that are not part of SCSI,
	  so that the host is not suspended while running other contexts
	  like bkops exception handling.
Changes from v1:
	- Minor cleanup and rebase
	- Forced enable of auto bkops during initialization to make sure device
	  and driver state are matched.

Sujit Reddy Thumma (2):
  scsi: ufs: Add support for host assisted background operations
  scsi: ufs: Add runtime PM support for UFS host controller driver

 drivers/scsi/ufs/ufs.h           |   25 +++-
 drivers/scsi/ufs/ufshcd-pci.c    |   65 +++++++-
 drivers/scsi/ufs/ufshcd-pltfrm.c |   51 ++++++-
 drivers/scsi/ufs/ufshcd.c        |  346 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h        |   10 +
 5 files changed, 489 insertions(+), 8 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.

