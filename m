From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 20:06:28 +0300
Message-ID: <4819F894.6020009@panasas.com>
References: <4819C9DB.60104@panasas.com>	 <1209651854.3067.8.camel@localhost.localdomain>	 <4819DA39.70505@panasas.com>	 <1209655360.3067.14.camel@localhost.localdomain>	 <4819E371.2040403@panasas.com>	 <1209656838.3067.16.camel@localhost.localdomain>	 <4819E8C7.3040808@panasas.com>	 <1209657731.3067.19.camel@localhost.localdomain>	 <4819EEEE.5030205@panasas.com> <1209659881.14864.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19427 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbYEARGw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 13:06:52 -0400
In-Reply-To: <1209659881.14864.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>

On Thu, May 01 2008 at 19:38 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
<snip> 
> Er, but
> 
>      1. struct cmdinfo is stack allocated; you can't dma to stack
>      2. even if you fix this, the structure is packed and will have the
>         original ppc coherence issues
>      3. Finally, even on the stack, it's not necessarily reachable with
>         the DMA mask
> 

Ho, thanks for the catch. I really goofed here.

> The whole point of managing sense buffer allocations centrally is to
> prevent driver writers from falling into all these traps.  I really
> don't think going back to hand rolled bounce buffering imporves the
> situation.
> 

We don't have a choice Andi is removing all this. ISA is becoming
ISA's driver private problem.

> James
> 
> 

Here is a new attempt at fixing the ISA case for gdth. Please forgive
me for that nasty bug that stared me in the face.

---
From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3.5/4] gdth: Fix sense handling in the ISA case

Allocate the 16 bytes buffer from host space which is of the right mask
in the ISA case. And always use cmndinfo from host space.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   33 +++++++++++++++++++++------------
 drivers/scsi/gdth.h |    1 +
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3cfbab6..805c616 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -443,7 +443,7 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
     Scsi_Cmnd *scp;
-    struct gdth_cmndinfo cmndinfo;
+    struct gdth_cmndinfo *cmndinfo;
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
@@ -451,26 +451,29 @@ int gdth_execute(gdth_ha_str *ha, gdth_cmd_str *gdtcmd, char *cmnd,
     if (!scp)
         return -ENOMEM;
 
-    memset(&cmndinfo, 0, sizeof(cmndinfo));
+    cmndinfo = gdth_get_cmndinfo(ha);
+    if (!cmndinfo)
+        return -ENOMEM;
 
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
     scp->timeout_per_command = timeout*HZ;
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
-    cmndinfo.priority = IOCTL_PRI;
-    cmndinfo.internal_cmd_str = gdtcmd;
-    cmndinfo.internal_command = 1;
+    cmndinfo->priority = IOCTL_PRI;
+    cmndinfo->internal_cmd_str = gdtcmd;
+    cmndinfo->internal_command = 1;
 
     TRACE(("gdth_execute() cmd 0x%x\n", scp->cmnd[0]));
-    __gdth_queuecommand(ha, scp, &cmndinfo);
+    __gdth_queuecommand(ha, scp, cmndinfo);
 
     wait_for_completion(&wait);
 
-    rval = cmndinfo.status;
+    rval = cmndinfo->status;
     if (info)
-        *info = cmndinfo.info;
+        *info = cmndinfo->info;
 
+    gdth_put_cmndinfo(cmndinfo);
     scsi_put_command(scp);
     return rval;
 }
@@ -2647,8 +2650,8 @@ static int gdth_fill_raw_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, unchar b)
         }
 
     } else {
-        page = virt_to_page(scp->sense_buffer);
-        offset = (ulong)scp->sense_buffer & ~PAGE_MASK;
+        page = virt_to_page(cmndinfo->sense);
+        offset = (ulong)cmndinfo->sense & ~PAGE_MASK;
         sense_paddr = pci_map_page(ha->pdev,page,offset,
                                    16,PCI_DMA_FROMDEVICE);
 
@@ -3317,9 +3320,14 @@ static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
             pci_unmap_sg(ha->pdev, scsi_sglist(scp), scsi_sg_count(scp),
                          cmndinfo->dma_dir);
 
-        if (cmndinfo->sense_paddr)
+        if (cmndinfo->sense_paddr) {
             pci_unmap_page(ha->pdev, cmndinfo->sense_paddr, 16,
                                                            PCI_DMA_FROMDEVICE);
+            /* this here is called before gdth_next so it will not
+             * overwrite fake sense returned there.
+             */
+            memcpy(scp->sense_buffer, cmndinfo->sense, 16);
+	}
 
         if (ha->status == S_OK) {
             cmndinfo->status = S_OK;
@@ -3950,7 +3958,8 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
 
     cmndinfo = gdth_get_cmndinfo(ha);
-    BUG_ON(!cmndinfo);
+    if(!cmndinfo)
+	return 1; /* too meany commands retry later */
 
     scp->scsi_done = done;
     gdth_update_timeout(scp, scp->timeout_per_command * 6);
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index ca92476..445ea7f 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -914,6 +914,7 @@ typedef struct {
         int index;
         int internal_command;                   /* don't call scsi_done */
         gdth_cmd_str *internal_cmd_str;         /* crier for internal messages*/
+        u8 sense[16];                           /* 16 is used allover */
         dma_addr_t sense_paddr;                 /* sense dma-addr */
         unchar priority;
         int timeout;
-- 
1.5.3.3




