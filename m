From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v2 11/11] buslogic: Remove host_lock unlock() + lock() from BusLogic_QueueCommand()
Date: Fri, 17 Sep 2010 11:23:24 -0700
Message-ID: <1284747804-21052-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from buslogic.c:BusLogic_QueueCommand()

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/BusLogic.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index fc0b4b8..f39b4fc 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2837,9 +2837,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 	 */
 	CCB = BusLogic_AllocateCCB(HostAdapter);
 	if (CCB == NULL) {
-		spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
 		BusLogic_Delay(1);
-		spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
 		CCB = BusLogic_AllocateCCB(HostAdapter);
 		if (CCB == NULL) {
 			Command->result = DID_ERROR << 16;
@@ -2965,10 +2963,8 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 		   error as a Host Adapter Hard Reset should be initiated soon.
 		 */
 		if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
-			spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
 			BusLogic_Warning("Unable to write Outgoing Mailbox - " "Pausing for 1 second\n", HostAdapter);
 			BusLogic_Delay(1);
-			spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
 			if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
 				BusLogic_Warning("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", HostAdapter);
 				BusLogic_DeallocateCCB(CCB);
-- 
1.7.2.3
