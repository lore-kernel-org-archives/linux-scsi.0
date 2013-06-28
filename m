From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V2 0/2]  Add suport for internal request (NOP and Query Request)
Date: Fri, 28 Jun 2013 23:26:17 +0530
Message-ID: <1372442179-20099-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:46902 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3F1R4b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 13:56:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org

This patch series replace the previous Query Request and NOP patches:
[PATCH 1/8] scsi: ufs: add support for query
[PATCH 6/8] scsi: ufs: Add support for sending NOP OUT UPIU
[PATCH 7/8] scsi: ufs: Set fDeviceInit flag to initiate device initialization
Major difference -

	Sending the query request via the SCSI vendor specific command can
	cause a deadlock in case the SCSI command queue is blocked and we
	would like to send a query request (for example fDeviceInit in case
	of re-initialization). In addition, usage of a vendor specific SCSI
	command for UFS can cause future conflicts if this vendor specific
	command will be allocated for a different usage.

	The new patch series gets an internal tag for NOP and query requests
	and do not involve the SCSI layer in UFS specific requests transfers.
	This design also resolves the possible deadlock mentioned above.


Depends on:
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

Changes from v1
	- Allocate a tag for device management commands dynamically instead
	  of reserving tag[MAX_QUEUE - 1].
	- Changed the "internal_cmd" naming to "dev_cmd" to avoid confusion
	  with other type of internal commands other than NOP and QUERY.

Dolev Raviv (1):
  scsi: ufs: Set fDeviceInit flag to initiate device initialization

Sujit Reddy Thumma (1):
  scsi: ufs: Add support for sending NOP OUT UPIU

 drivers/scsi/ufs/ufs.h    |  127 ++++++-
 drivers/scsi/ufs/ufshcd.c |  886 +++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h |   43 ++-
 drivers/scsi/ufs/ufshci.h |    2 +-
 4 files changed, 939 insertions(+), 119 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.

