From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 3/4] mpt3sas: Fix Firmware fault state 0x2100 during heavy 4K RR FIO stress test.
Date: Thu, 19 Jan 2017 21:19:09 +0530
Message-ID: <1484840950-13656-4-git-send-email-chaitra.basappa@broadcom.com>
References: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484840950-13656-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Due existence of loop in the IO path our HBA will receive heavy IOs and
also as driver is not updating the Reply Post Host Index frequently, So
there will be a high chance that our Firmware unable to find any free entry
in the Reply Post Descriptor Queue (i.e. Queue overflow occurs) and can
observe 0x2100 firmware fault.
So to fix this, we have defined a thresh hold value. After continuously
processing this threshold number of reply descriptors driver will update
the Reply Descriptor Host Index so that this threshold number of reply
descriptors entries will be freed and these entries will be available for
firmware and we won't observe this Firmware fault. We have defined this
threshold value as 1/3rd of the hba queue depth.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
	       Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 722fab9..a3fe1fb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1040,6 +1040,25 @@ _base_interrupt(int irq, void *bus_id)
 		    reply_q->reply_post_free[reply_q->reply_post_host_index].
 		    Default.ReplyFlags & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
 		completed_cmds++;
+		/* Update the reply post host index after continuously
+		 * processing the threshold number of Reply Descriptors.
+		 * So that FW can find enough entries to post the Reply
+		 * Descriptors in the reply descriptor post queue.
+		 */
+		if (completed_cmds > ioc->hba_queue_depth/3) {
+			if (ioc->combined_reply_queue) {
+				writel(reply_q->reply_post_host_index |
+						((msix_index  & 7) <<
+						 MPI2_RPHI_MSIX_INDEX_SHIFT),
+				    ioc->replyPostRegisterIndex[msix_index/8]);
+			} else {
+				writel(reply_q->reply_post_host_index |
+						(msix_index <<
+						 MPI2_RPHI_MSIX_INDEX_SHIFT),
+						&ioc->chip->ReplyPostHostIndex);
+			}
+			completed_cmds = 1;
+		}
 		if (request_desript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
 			goto out;
 		if (!reply_q->reply_post_host_index)
-- 
1.7.1
