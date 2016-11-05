From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.9-rc3
Date: Sat, 05 Nov 2016 07:29:51 -0600
Message-ID: <1478352591.2858.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49178 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754130AbcKENaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Nov 2016 09:30:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Two more important data integrity fixes related to RAID device drivers
which wrongly throw away the SYNCHRONIZE CACHE command in the non-RAID
path and a memory leak fix in the scsi_debug driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ching Huang (1):
      scsi: arcmsr: Send SYNCHRONIZE_CACHE command to firmware

Ewan D. Milne (1):
      scsi: scsi_debug: Fix memory leak if LBP enabled and module is unloaded

Kashyap Desai (1):
      scsi: megaraid_sas: Fix data integrity failure for JBOD (passthrough) devices

And the diffstat:

 drivers/scsi/arcmsr/arcmsr_hba.c          |  9 ---------
 drivers/scsi/megaraid/megaraid_sas_base.c | 13 +++++--------
 drivers/scsi/scsi_debug.c                 |  1 +
 3 files changed, 6 insertions(+), 17 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 3d53d63..f0cfb04 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2636,18 +2636,9 @@ static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	struct CommandControlBlock *ccb;
 	int target = cmd->device->id;
-	int lun = cmd->device->lun;
-	uint8_t scsicmd = cmd->cmnd[0];
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
-	if ((scsicmd == SYNCHRONIZE_CACHE) ||(scsicmd == SEND_DIAGNOSTIC)){
-		if(acb->devstate[target][lun] == ARECA_RAID_GONE) {
-    			cmd->result = (DID_NO_CONNECT << 16);
-		}
-		cmd->scsi_done(cmd);
-		return 0;
-	}
 	if (target == 16) {
 		/* virtual device for iop message transfer */
 		arcmsr_handle_virtual_command(acb, cmd);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9ff57de..d8b1fbd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1700,16 +1700,13 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		goto out_done;
 	}
 
-	switch (scmd->cmnd[0]) {
-	case SYNCHRONIZE_CACHE:
-		/*
-		 * FW takes care of flush cache on its own
-		 * No need to send it down
-		 */
+	/*
+	 * FW takes care of flush cache on its own for Virtual Disk.
+	 * No need to send it down for VD. For JBOD send SYNCHRONIZE_CACHE to FW.
+	 */
+	if ((scmd->cmnd[0] == SYNCHRONIZE_CACHE) && MEGASAS_IS_LOGICAL(scmd)) {
 		scmd->result = DID_OK << 16;
 		goto out_done;
-	default:
-		break;
 	}
 
 	return instance->instancet->build_and_issue_cmd(instance, scmd);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c905709..cf04a36 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5134,6 +5134,7 @@ static void __exit scsi_debug_exit(void)
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
 
+	vfree(map_storep);
 	vfree(dif_storep);
 	vfree(fake_storep);
 	kfree(sdebug_q_arr);
