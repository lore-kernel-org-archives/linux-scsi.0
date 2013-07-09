From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V3 0/2] Add suport for internal request (NOP and Query Request)
Date: Tue,  9 Jul 2013 14:45:08 +0530
Message-ID: <1373361310-30674-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:50343 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3GIJPV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jul 2013 05:15:21 -0400
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


Changes from v2:
 	- Rebased on scsi-misc branche (commit 8c0eb596baa5)
	- Minor addition to structure documentation in ufshcd.h
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

