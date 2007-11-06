From: malahal@us.ibm.com
Subject: Re: [PATCH] gdth: scp timeout clean up (try #2)
Date: Tue, 6 Nov 2007 14:34:53 -0800
Message-ID: <20071106223453.GA5668@us.ibm.com>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:54282 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbXKFWfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Nov 2007 17:35:03 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id lA6LYPiu024988
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 16:34:25 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA6MYu7o125450
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 15:34:56 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA6MYtuv012948
	for <linux-scsi@vger.kernel.org>; Tue, 6 Nov 2007 15:34:55 -0700
Content-Disposition: inline
In-Reply-To: <47301DA7.8000202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Achim_Leubner@adaptec.com, jens.axboe@oracle.com

gdth driver is modified NOT to use scp->eh_timeout. Now, it has
eh_timed_out (gdth_timed_out) to handle command timeouts for locked
I/O's. Have not tested as I don't have needed hardware! Patch is
against 2.6.23-mm1.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r dbb45a1edd2a drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c	Mon Nov 05 21:32:26 2007 -0800
+++ b/drivers/scsi/gdth.c	Tue Nov 06 08:15:48 2007 -0800
@@ -2056,22 +2056,12 @@ static void gdth_putq(gdth_ha_str *ha, S
     register Scsi_Cmnd *pscp;
     register Scsi_Cmnd *nscp;
     ulong flags;
-    unchar b, t;
 
     TRACE(("gdth_putq() priority %d\n",priority));
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     if (!cmndinfo->internal_command) {
         cmndinfo->priority = priority;
-        b = scp->device->channel;
-        t = scp->device->id;
-        if (priority >= DEFAULT_PRI) {
-            if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
-                (b==ha->virt_bus && t<MAX_HDRIVES && ha->hdr[t].lock)) {
-                TRACE2(("gdth_putq(): locked IO ->update_timeout()\n"));
-                cmndinfo->timeout = gdth_update_timeout(scp, 0);
-            }
-        }
     }
 
     if (ha->req_first==NULL) {
@@ -2359,7 +2349,7 @@ static void gdth_copy_internal_data(gdth
 {
     ushort cpcount,i, max_sg = gdth_sg_count(scp);
     ushort cpsum,cpnow;
-    struct scatterlist *sl, *sg;
+    struct scatterlist *sl;
     char *address;
 
     cpcount = min_t(ushort, count, gdth_bufflen(scp));
@@ -3938,6 +3928,38 @@ static const char *gdth_info(struct Scsi
     return ((const char *)ha->binfo.type_string);
 }
 
+static enum scsi_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
+{
+	gdth_ha_str *ha = shost_priv(scp->device->host);
+	struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
+	unchar b, t;
+	ulong flags;
+	enum scsi_eh_timer_return retval = EH_NOT_HANDLED;
+
+	TRACE(("%s() cmd 0x%x\n", scp->cmnd[0], __FUNCTION__));
+	b = scp->device->channel;
+	t = scp->device->id;
+
+	/*
+	 * We don't really honor the command timeout, but we try to
+	 * honor 6 times of the actual command timeout! So reset the
+	 * timer if this is less than 6th timeout on this command!
+	 */
+	if (++cmndinfo->timeout_count < 6)
+		retval = EH_RESET_TIMER;
+
+	/* Reset the timeout if it is locked IO */
+	spin_lock_irqsave(&ha->smp_lock, flags);
+	if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha, b)].lock) ||
+	    (b == ha->virt_bus && t < MAX_HDRIVES && ha->hdr[t].lock)) {
+		TRACE2(("%s(): locked IO, reset timeout\n", __FUNCTION__));
+		retval = EH_RESET_TIMER;
+	}
+	spin_unlock_irqrestore(&ha->smp_lock, flags);
+
+	return retval;
+}
+
 static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
@@ -4031,7 +4053,7 @@ static int gdth_queuecommand(struct scsi
     BUG_ON(!cmndinfo);
 
     scp->scsi_done = done;
-    gdth_update_timeout(scp, scp->timeout_per_command * 6);
+    cmndinfo->timeout_count = 0;
     cmndinfo->priority = DEFAULT_PRI;
 
     gdth_set_bufflen(scp, scsi_bufflen(scp));
@@ -4137,12 +4159,10 @@ static int ioc_lockdrv(void __user *arg)
             ha->hdr[j].lock = 1;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
             gdth_wait_completion(ha, ha->bus_cnt, j);
-            gdth_stop_timeout(ha, ha->bus_cnt, j);
         } else {
             spin_lock_irqsave(&ha->smp_lock, flags);
             ha->hdr[j].lock = 0;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
-            gdth_start_timeout(ha, ha->bus_cnt, j);
             gdth_next(ha);
         }
     } 
@@ -4582,14 +4602,12 @@ static int gdth_ioctl(struct inode *inod
                 spin_unlock_irqrestore(&ha->smp_lock, flags);
                 for (j = 0; j < ha->tid_cnt; ++j) {
                     gdth_wait_completion(ha, i, j);
-                    gdth_stop_timeout(ha, i, j);
                 }
             } else {
                 spin_lock_irqsave(&ha->smp_lock, flags);
                 ha->raw[i].lock = 0;
                 spin_unlock_irqrestore(&ha->smp_lock, flags);
                 for (j = 0; j < ha->tid_cnt; ++j) {
-                    gdth_start_timeout(ha, i, j);
                     gdth_next(ha);
                 }
             }
@@ -4724,6 +4742,7 @@ static struct scsi_host_template gdth_te
         .slave_configure        = gdth_slave_configure,
         .bios_param             = gdth_bios_param,
         .proc_info              = gdth_proc_info,
+	.eh_timed_out		= gdth_timed_out,
         .proc_name              = "gdth",
         .can_queue              = GDTH_MAXCMDS,
         .this_id                = -1,
diff -r dbb45a1edd2a drivers/scsi/gdth.h
--- a/drivers/scsi/gdth.h	Mon Nov 05 21:32:26 2007 -0800
+++ b/drivers/scsi/gdth.h	Mon Nov 05 22:44:43 2007 -0800
@@ -917,7 +917,7 @@ typedef struct {
         int internal_command;                   /* don't call scsi_done */
         dma_addr_t sense_paddr;                 /* sense dma-addr */
         unchar priority;
-        int timeout;
+	int timeout_count;			/* # of timeout calls */
         volatile int wait_for_completion;
         ushort status;
         ulong32 info;
diff -r dbb45a1edd2a drivers/scsi/gdth_proc.c
--- a/drivers/scsi/gdth_proc.c	Mon Nov 05 21:32:26 2007 -0800
+++ b/drivers/scsi/gdth_proc.c	Mon Nov 05 22:44:50 2007 -0800
@@ -750,69 +750,3 @@ static void gdth_wait_completion(gdth_ha
     }
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
-
-static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id)
-{
-    ulong flags;
-    Scsi_Cmnd *scp;
-    unchar b, t;
-
-    spin_lock_irqsave(&ha->smp_lock, flags);
-
-    for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-        if (!cmndinfo->internal_command) {
-            b = scp->device->channel;
-            t = scp->device->id;
-            if (t == (unchar)id && b == (unchar)busnum) {
-                TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
-                cmndinfo->timeout = gdth_update_timeout(scp, 0);
-            }
-        }
-    }
-    spin_unlock_irqrestore(&ha->smp_lock, flags);
-}
-
-static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id)
-{
-    ulong flags;
-    Scsi_Cmnd *scp;
-    unchar b, t;
-
-    spin_lock_irqsave(&ha->smp_lock, flags);
-
-    for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-        if (!cmndinfo->internal_command) {
-            b = scp->device->channel;
-            t = scp->device->id;
-            if (t == (unchar)id && b == (unchar)busnum) {
-                TRACE2(("gdth_start_timeout(): update_timeout()\n"));
-                gdth_update_timeout(scp, cmndinfo->timeout);
-            }
-        }
-    }
-    spin_unlock_irqrestore(&ha->smp_lock, flags);
-}
-
-static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout)
-{
-    int oldto;
-
-    oldto = scp->timeout_per_command;
-    scp->timeout_per_command = timeout;
-
-    if (timeout == 0) {
-        del_timer(&scp->eh_timeout);
-        scp->eh_timeout.data = (unsigned long) NULL;
-        scp->eh_timeout.expires = 0;
-    } else {
-        if (scp->eh_timeout.data != (unsigned long) NULL) 
-            del_timer(&scp->eh_timeout);
-        scp->eh_timeout.data = (unsigned long) scp;
-        scp->eh_timeout.expires = jiffies + timeout;
-        add_timer(&scp->eh_timeout);
-    }
-
-    return oldto;
-}
diff -r dbb45a1edd2a drivers/scsi/gdth_proc.h
--- a/drivers/scsi/gdth_proc.h	Mon Nov 05 21:32:26 2007 -0800
+++ b/drivers/scsi/gdth_proc.h	Mon Nov 05 22:44:50 2007 -0800
@@ -20,9 +20,6 @@ static char *gdth_ioctl_alloc(gdth_ha_st
                               ulong64 *paddr);
 static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr);
 static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id);
-static void gdth_stop_timeout(gdth_ha_str *ha, int busnum, int id);
-static void gdth_start_timeout(gdth_ha_str *ha, int busnum, int id);
-static int gdth_update_timeout(Scsi_Cmnd *scp, int timeout);
 
 #endif
 
