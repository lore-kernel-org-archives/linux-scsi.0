From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v6 00/15] Big fixes, retries, handle a race condition
Date: Wed, 28 Oct 2015 15:13:50 +0200
Message-ID: <1446038045-17102-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

Important:
This serie of 15 small patches should be pushed after the series of 8 patches
"Fix error message and present UFS variant probe"

V6:
update Reviewed-by from various reviewers

V5:
removed un-necessary wmb()

V4:
fixing a few comments from reviewers

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

 drivers/scsi/ufs/ufshcd.c | 408 ++++++++++++++++++++++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h |   4 +
 2 files changed, 327 insertions(+), 85 deletions(-)

-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
