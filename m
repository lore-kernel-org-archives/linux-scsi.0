From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH V4 0/2] Add suport for internal request (NOP and Query Request)
Date: Tue, 23 Jul 2013 12:37:40 +0530
Message-ID: <1374563262-22730-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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

Changes from v3:
	- Addressed some of the comments by Seungwon Jeon.
	  o Changed return value for ufshcd_wait_for_register().
	  o Function name changes to ufshcd_verify_dev_init().
	  o Bootup allocation for query structures.
	  o Remove overloading of flag_res while polling in fDeviceInit.
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

 drivers/scsi/ufs/ufs.h    |  132 +++++++-
 drivers/scsi/ufs/ufshcd.c |  817 +++++++++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshcd.h |   49 +++-
 drivers/scsi/ufs/ufshci.h |    2 +-
 4 files changed, 879 insertions(+), 121 deletions(-)

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
