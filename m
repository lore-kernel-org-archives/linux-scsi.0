From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH 07/11] scsi: ultrastor: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 22:03:59 +0400
Message-ID: <1279130640-11228-1-git-send-email-segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use %p instead of %08x in printk().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/ultrastor.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 27aa40f..4715b7c 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -1061,7 +1061,7 @@ static void ultrastor_interrupt(void *dev_id)
     mscp = (struct mscp *)isa_bus_to_virt(inl(config.icm_address));
     mscp_index = mscp - config.mscp;
     if (mscp_index >= ULTRASTOR_MAX_CMDS) {
-	printk("Ux4F interrupt: bad MSCP address %x\n", (unsigned int) mscp);
+	printk("Ux4F interrupt: bad MSCP address %p\n", mscp);
 	/* A command has been lost.  Reset and report an error
 	   for all commands.  */
 	ultrastor_host_reset(dev_id);
@@ -1074,8 +1074,8 @@ static void ultrastor_interrupt(void *dev_id)
 	unsigned char icm_status = inb(config.icm_address - 1);
 #if ULTRASTOR_DEBUG & (UD_INTERRUPT|UD_ERROR|UD_ABORT)
 	if (icm_status != 1 && icm_status != 2)
-	    printk("US24F: ICM status %x for MSCP %d (%x)\n", icm_status,
-		   mscp_index, (unsigned int) mscp);
+		printk("US24F: ICM status %x for MSCP %d (%p)\n", icm_status,
+					mscp_index, mscp);
 #endif
 	/* The manual says clear interrupt then write 0 to ICM status.
 	   This seems backwards, but I'll do it anyway.  --jfc */
@@ -1104,7 +1104,7 @@ static void ultrastor_interrupt(void *dev_id)
     if (!SCtmp)
       {
 #if ULTRASTOR_DEBUG & (UD_ABORT|UD_INTERRUPT)
-	printk("MSCP %d (%x): no command\n", mscp_index, (unsigned int) mscp);
+	printk("MSCP %d (%p): no command\n", mscp_index, mscp);
 #endif	
 #if ULTRASTOR_MAX_CMDS == 1
 	config.mscp_busy = FALSE;
@@ -1154,8 +1154,8 @@ static void ultrastor_interrupt(void *dev_id)
 
 #if ULTRASTOR_DEBUG & (UD_ABORT|UD_INTERRUPT)
     if (config.aborted[mscp_index])
-	printk("Ux4 interrupt: MSCP %d (%x) aborted = %d\n",
-	       mscp_index, (unsigned int) mscp, config.aborted[mscp_index]);
+	printk("Ux4 interrupt: MSCP %d (%p) aborted = %d\n",
+	       mscp_index, mscp, config.aborted[mscp_index]);
 #endif
     config.aborted[mscp_index] = 0;
 
-- 
1.7.0.4
