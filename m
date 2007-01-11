From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 21/21] libsas: Start I_T recovery if ABORT TASK fails
Date: Thu, 11 Jan 2007 14:15:46 -0800
Message-ID: <20070111221546.3543.37791.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40918 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661AbXAKWP1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:27 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFQsg016034
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:26 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMFQCQ302932
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:26 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMFQEn019353
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:26 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


The EH should fall into I_T recovery (and potentially stronger
remedies) if ABORT TASK fails.

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 8a1b98e..9ffe760 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -281,6 +281,7 @@ enum task_disposition {
 	TASK_IS_ABORTED,
 	TASK_IS_AT_LU,
 	TASK_IS_NOT_AT_LU,
+	TASK_ABORT_FAILED,
 };
 
 static enum task_disposition sas_scsi_find_task(struct sas_task *task)
@@ -331,15 +332,21 @@ static enum task_disposition sas_scsi_fi
 			SAS_DPRINTK("%s: querying task 0x%p\n",
 				    __FUNCTION__, task);
 			res = si->dft->lldd_query_task(task);
-			if (res == TMF_RESP_FUNC_SUCC) {
+			switch (res) {
+			case TMF_RESP_FUNC_SUCC:
 				SAS_DPRINTK("%s: task 0x%p at LU\n",
 					    __FUNCTION__, task);
 				return TASK_IS_AT_LU;
-			} else if (res == TMF_RESP_FUNC_COMPLETE) {
+			case TMF_RESP_FUNC_COMPLETE:
 				SAS_DPRINTK("%s: task 0x%p not at LU\n",
 					    __FUNCTION__, task);
 				return TASK_IS_NOT_AT_LU;
-			}
+			case TMF_RESP_FUNC_FAILED:
+                                SAS_DPRINTK("%s: task 0x%p failed to abort\n",
+                                                __FUNCTION__, task);
+                                return TASK_ABORT_FAILED;
+                        }
+
 		}
 	}
 	return res;
@@ -475,6 +482,7 @@ Again:
 			}
 			/* fallthrough */
 		case TASK_IS_NOT_AT_LU:
+		case TASK_ABORT_FAILED:
 			SAS_DPRINTK("task 0x%p is not at LU: I_T recover\n",
 				    task);
 			tmf_resp = sas_recover_I_T(task->dev);
