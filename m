From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/5] isci: fix decode of DONE_CRC_ERR TC completion status
Date: Wed, 28 Sep 2011 18:47:51 -0700
Message-ID: <20110929014751.23617.99481.stgit@localhost6.localdomain6>
References: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab1I2Brw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 21:47:52 -0400
In-Reply-To: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dmilburn@redhat.com, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

DONE_CRC_ERR is not a RNC suspension condition, so do not change the
state to expect the incoming suspension notification.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
[djbw: dropped DONE_CMD_LL_R_ERR change]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/request.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 2bf072f..d431564 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2072,10 +2072,9 @@ static enum sci_status stp_request_udma_await_tc_event(struct isci_request *ireq
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_MAX_PLD_ERR):
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_LL_R_ERR):
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_CMD_LL_R_ERR):
-	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_CRC_ERR):
 		sci_remote_device_suspend(ireq->target_device,
 			SCU_EVENT_SPECIFIC(SCU_NORMALIZE_COMPLETION_STATUS(completion_code)));
-	/* Fall through to the default case */
+		/* Fall through to the default case */
 	default:
 		/* All other completion status cause the IO to be complete. */
 		ireq->scu_status = SCU_NORMALIZE_COMPLETION_STATUS(completion_code);

