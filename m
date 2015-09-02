From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v3 00/15] Big fixes, retries, handle a race condition
Date: Wed,  2 Sep 2015 13:13:00 +0300
Message-ID: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60832 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbIBKNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2015 06:13:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org

Important:
This serie of 15 small patches should be pushed after the series of 8 patches
"Fix error message and present UFS variant probe"

V3:
removed specific calls to wmb() since they are redundant.

V2:
a few minor changes

V1:
This serie of 15 small patches should be pushed after the series of 8 patches
I have uploaded to the upstream a week ago:
"Fix error message and present UFS variant probe"

Yaniv Gardi (15):
  scsi: ufs: clear UTRD, UPIU req and rsp before new transfers
  scsi: ufs: clear fields UTRD, UPIU req and rsp before new transfers
  scsi: ufs: verify command tag validity
  scsi: ufs: clear outstanding_request bit in case query timeout
  scsi: ufs: increase fDeviceInit query response timeout
  scsi: ufs: avoid exception event handler racing with PM callbacks
  scsi: ufs: set REQUEST_SENSE command size to 18 bytes
  scsi: ufs: add retries to dme_peer get and set attribute
  scsi: ufs: add retries for hibern8 enter
  scsi: ufs: fix error recovery after the hibern8 exit failure
  scsi: ufs: retry failed query flag requests
  scsi: ufs: reduce the interrupts for power mode change requests
  scsi: ufs: add missing memory barriers
  scsi: ufs: commit descriptors before setting the doorbell
  scsi: ufs: add wrapper for retrying sending query attribute

 drivers/scsi/ufs/ufshcd.c | 409 ++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h |   4 +
 2 files changed, 328 insertions(+), 85 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
