From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 02/11] isci: Immediately fail I/O to removed devices.
Date: Thu, 27 Oct 2011 15:04:56 -0700
Message-ID: <20111027220455.4941.62455.stgit@localhost6.localdomain6>
References: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40843 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754569Ab1J0WE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2011 18:04:57 -0400
In-Reply-To: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

In the case where an I/O fails to start in isci_request_execute,
only allow retries if the device is not already gone.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index e2d9418..e8cf17b 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -212,16 +212,27 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 					task->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
 					spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-					/* Indicate QUEUE_FULL so that the scsi
-					* midlayer retries. if the request
-					* failed for remote device reasons,
-					* it gets returned as
-					* SAS_TASK_UNDELIVERED next time
-					* through.
-					*/
-					isci_task_refuse(ihost, task,
-							 SAS_TASK_COMPLETE,
-							 SAS_QUEUE_FULL);
+					if (test_bit(IDEV_GONE, &idev->flags)) {
+
+						/* Indicate that the device
+						 * is gone.
+						 */
+						isci_task_refuse(ihost, task,
+							SAS_TASK_UNDELIVERED,
+							SAS_DEVICE_UNKNOWN);
+					} else {
+						/* Indicate QUEUE_FULL so that
+						 * the scsi midlayer retries.
+						 * If the request failed for
+						 * remote device reasons, it
+						 * gets returned as
+						 * SAS_TASK_UNDELIVERED next
+						 * time through.
+						 */
+						isci_task_refuse(ihost, task,
+							SAS_TASK_COMPLETE,
+							SAS_QUEUE_FULL);
+					}
 				}
 			}
 		}

