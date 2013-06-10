From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 0/2] Add suport for internal request (NOP and Query Request)
Date: Mon, 10 Jun 2013 17:12:08 +0300
Message-ID: <1370873530-19461-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Those patches replace the previous Query Request and NOP patches:
[PATCH 1/8] scsi: ufs: add support for query
[PATCH 7/8] scsi: ufs: Set fDeviceInit flag to initiate device initialization
[PATCH 8/8] scsi: ufs: Fix the response UPIU length setting

And depends on:
[PATCH 2/8] scsi: ufs: wrap the i/o access operations
[PATCH 3/8] scsi: ufs: amend interrupt configuration
[PATCH 4/8] scsi: ufs: remove version check before IS reg clear
[PATCH 5/8] scsi: ufs: rework link start-up process

Sending the query request via the SCSI vendor specific command can cause a deadlock
in case the SCSI command queue is blocked and we would like to send a query request 
(for example fDeviceInit in case of re-initialization).
In addition, usage of a vendor specific SCSI command for UFS can cause future conflicts
if this vendor specific command will be allocated for a different usage.

The below patches allocate an internal tag for NOP and query requests and do not
involve the SCSI layer in UFS specific requests transfers. 
This design also resolves the possible deadlock mentioned above.


Dolev Raviv (1):
  scsi: ufs: Set fDeviceInit flag to initiate device initialization

Sujit Reddy Thumma (1):
  scsi: ufs: Add support for sending NOP OUT UPIU

 drivers/scsi/ufs/ufs.h    |  127 +++++++-
 drivers/scsi/ufs/ufshcd.c |  802 ++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h |   40 +++-
 drivers/scsi/ufs/ufshci.h |    2 +-
 4 files changed, 849 insertions(+), 122 deletions(-)

-- 
1.7.6
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
