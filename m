From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 4/2] HCIL drivers update; sdev_printk
Date: Sun, 23 Oct 2005 17:40:34 -0400
Message-ID: <20051023214034.GA15599@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:35816 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750788AbVJWVkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 17:40:35 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 4B9851C09604
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 17:40:34 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9NLeY6Y015626
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 17:40:34 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Yet more driver work.  Some bugs added (and noted).

Added sdev_printk() to save typing.


 drivers/scsi/aic7xxx_old.c              |  232 ++++++++++++++++----------------
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    8 -
 drivers/scsi/fd_mcs.c                   |    4 
 drivers/scsi/in2000.c                   |   91 +++++++-----
 drivers/scsi/ips.c                      |   34 ++--
 drivers/scsi/pcmcia/nsp_cs.c            |    5 
 drivers/scsi/u14-34f.c                  |   60 ++++----
 drivers/scsi/ultrastor.c                |    4 
 include/scsi/scsi_device.h              |    3 
 9 files changed, 234 insertions(+), 207 deletions(-)

3223e9b240cb8927b528c0f75566a752aa26ea06
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 52b72d7..694a557 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -255,7 +255,7 @@
 
 #define ALL_TARGETS -1
 #define ALL_CHANNELS -1
-#define ALL_LUNS -1
+#define ALL_LUNS NULL
 #define MAX_TARGETS  16
 #define MAX_LUNS     8
 #ifndef TRUE
@@ -1035,11 +1035,12 @@ static struct aic7xxx_syncrate {
                         (((scb->hscb)->target_channel_lun >> 4) & 0xf), \
                         ((scb->hscb)->target_channel_lun & 0x07)
 
-#define CTL_OF_CMD(cmd) ((cmd->device->channel) & 0x01),  \
-                        ((cmd->device->id) & 0x0f), \
-                        ((cmd->device->lun) & 0x07)
+#define CTL_OF_CMD(cmd) ((sdev_channel(cmd->device)) & 0x01),  \
+                        ((sdev_id(cmd->device)) & 0x0f), \
+                        ((scsilun_to_int(&cmd->device->lun)) & 0x07)
 
-#define TARGET_INDEX(cmd)  ((cmd)->device->id | ((cmd)->device->channel << 3))
+#define TARGET_INDEX(cmd) \
+	(sdev_id((cmd)->device) | (sdev_channel((cmd)->device) << 3))
 
 /*
  * A nice little define to make doing our printks a little easier
@@ -1271,7 +1272,7 @@ static void aic7xxx_set_syncrate(struct 
 		unsigned int period, unsigned int offset, unsigned char options,
 		unsigned int type, struct aic_dev_data *aic_dev);
 static void aic7xxx_set_width(struct aic7xxx_host *p, int target, int channel,
-		int lun, unsigned int width, unsigned int type,
+		const struct scsi_lun *lun, unsigned int width, unsigned int type,
 		struct aic_dev_data *aic_dev);
 static void aic7xxx_panic_abort(struct aic7xxx_host *p, Scsi_Cmnd *cmd);
 static void aic7xxx_print_card(struct aic7xxx_host *p);
@@ -2072,6 +2073,7 @@ aic7xxx_set_syncrate(struct aic7xxx_host
   unsigned short target_mask;
   unsigned char lun, old_options;
   unsigned int old_period, old_offset;
+  struct scsi_device *sd = aic_dev->SDptr;
 
   tindex = target | (channel << 3);
   target_mask = 0x01 << tindex;
@@ -2159,14 +2161,13 @@ aic7xxx_set_syncrate(struct aic7xxx_host
       {
         int rate_mod = (scsirate & WIDEXFER) ? 1 : 0;
       
-        printk(INFO_LEAD "Synchronous at %s Mbyte/sec, "
-               "offset %d.\n", p->host_no, channel, target, lun,
+        sdev_printk(KERN_INFO, sd, "Synchronous at %s Mbyte/sec, "
+               "offset %d.\n",
                syncrate->rate[rate_mod], offset);
       }
       else
       {
-        printk(INFO_LEAD "Using asynchronous transfers.\n",
-               p->host_no, channel, target, lun);
+        sdev_printk(KERN_INFO, sd, "Using asynchronous transfers.\n");
       }
       aic_dev->flags &= ~DEVICE_PRINT_DTR;
     }
@@ -2195,12 +2196,14 @@ aic7xxx_set_syncrate(struct aic7xxx_host
  *   Set the actual width down in the card and in our host structs
  *-F*************************************************************************/
 static void
-aic7xxx_set_width(struct aic7xxx_host *p, int target, int channel, int lun,
-    unsigned int width, unsigned int type, struct aic_dev_data *aic_dev)
+aic7xxx_set_width(struct aic7xxx_host *p, int target, int channel,
+    const struct scsi_lun *lun, unsigned int width, unsigned int type,
+    struct aic_dev_data *aic_dev)
 {
   unsigned char tindex;
   unsigned short target_mask;
   unsigned int old_width;
+  struct scsi_device *sd = aic_dev->SDptr;
 
   tindex = target | (channel << 3);
   target_mask = 1 << tindex;
@@ -2228,8 +2231,8 @@ aic7xxx_set_width(struct aic7xxx_host *p
           (aic7xxx_verbose & VERBOSE_NEGOTIATION2) && 
           (aic_dev->flags & DEVICE_PRINT_DTR) )
     {
-      printk(INFO_LEAD "Using %s transfers\n", p->host_no, channel, target,
-        lun, (scsirate & WIDEXFER) ? "Wide(16bit)" : "Narrow(8bit)" );
+      sdev_printk(KERN_INFO, sd, "Using %s transfers\n",
+         (scsirate & WIDEXFER) ? "Wide(16bit)" : "Narrow(8bit)" );
     }
   }
 
@@ -2380,18 +2383,21 @@ scbq_insert_tail(volatile scb_queue_type
  *-F*************************************************************************/
 static int
 aic7xxx_match_scb(struct aic7xxx_host *p, struct aic7xxx_scb *scb,
-    int target, int channel, int lun, unsigned char tag)
+    int target, int channel, const struct scsi_lun *lun, unsigned char tag)
 {
   int targ = (scb->hscb->target_channel_lun >> 4) & 0x0F;
   int chan = (scb->hscb->target_channel_lun >> 3) & 0x01;
   int slun = scb->hscb->target_channel_lun & 0x07;
   int match;
+  struct scsi_lun __slun;
+
+  int_to_scsilun(slun, &__slun);
 
   match = ((chan == channel) || (channel == ALL_CHANNELS));
   if (match != 0)
     match = ((targ == target) || (target == ALL_TARGETS));
   if (match != 0)
-    match = ((lun == slun) || (lun == ALL_LUNS));
+    match = (scsilun_eq(lun, &__slun) || (lun == ALL_LUNS));
   if (match != 0)
     match = ((tag == scb->hscb->tag) || (tag == SCB_LIST_NULL));
 
@@ -3000,7 +3006,7 @@ aic7xxx_abort_waiting_scb(struct aic7xxx
  *-F*************************************************************************/
 static int
 aic7xxx_search_qinfifo(struct aic7xxx_host *p, int target, int channel,
-    int lun, unsigned char tag, int flags, int requeue,
+    const struct scsi_lun *lun, unsigned char tag, int flags, int requeue,
     volatile scb_queue_type *queue)
 {
   int      found;
@@ -3127,10 +3133,10 @@ aic7xxx_scb_on_qoutfifo(struct aic7xxx_h
  *-F*************************************************************************/
 static void
 aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
-                     int lun, unsigned char tag)
+                     const struct scsi_lun *lun, unsigned char tag)
 {
   struct aic7xxx_scb *scbp, *prev_scbp;
-  struct scsi_device *sd;
+  struct scsi_device *sd = NULL; /* FIXME: initializer very wrong!!! */
   unsigned char active_scb, tcl, scb_tag;
   int i = 0, init_lists = FALSE;
   struct aic_dev_data *aic_dev;
@@ -3143,19 +3149,21 @@ aic7xxx_reset_device(struct aic7xxx_host
 
   if (aic7xxx_verbose & (VERBOSE_RESET_PROCESS | VERBOSE_ABORT_PROCESS))
   {
+    unsigned int lunv = scsilun_to_int(lun);
+
     printk(INFO_LEAD "Reset device, hardware_scb %d,\n",
-         p->host_no, channel, target, lun, active_scb);
+         p->host_no, channel, target, lunv, active_scb);
     printk(INFO_LEAD "Current scb %d, SEQADDR 0x%x, LASTPHASE "
            "0x%x\n",
-         p->host_no, channel, target, lun, scb_tag,
+         p->host_no, channel, target, lunv, scb_tag,
          aic_inb(p, SEQADDR0) | (aic_inb(p, SEQADDR1) << 8),
          aic_inb(p, LASTPHASE));
     printk(INFO_LEAD "SG_CACHEPTR 0x%x, SG_COUNT %d, SCSISIGI 0x%x\n",
-         p->host_no, channel, target, lun,
+         p->host_no, channel, target, lunv,
          (p->features & AHC_ULTRA2) ?  aic_inb(p, SG_CACHEPTR) : 0,
          aic_inb(p, SG_COUNT), aic_inb(p, SCSISIGI));
     printk(INFO_LEAD "SSTAT0 0x%x, SSTAT1 0x%x, SSTAT2 0x%x\n",
-         p->host_no, channel, target, lun, aic_inb(p, SSTAT0),
+         p->host_no, channel, target, lunv, aic_inb(p, SSTAT0),
          aic_inb(p, SSTAT1), aic_inb(p, SSTAT2));
   }
 
@@ -3165,16 +3173,15 @@ aic7xxx_reset_device(struct aic7xxx_host
   list_for_each_entry(aic_dev, &p->aic_devs, list)
   {
     if (aic7xxx_verbose & (VERBOSE_RESET_PROCESS | VERBOSE_ABORT_PROCESS))
-      printk(INFO_LEAD "processing aic_dev %p\n", p->host_no, channel, target,
-		    lun, aic_dev);
+      sdev_printk(KERN_INFO, sd, "processing aic_dev %p\n", aic_dev);
     sd = aic_dev->SDptr;
 
-    if((target != ALL_TARGETS && target != sd->id) ||
-       (channel != ALL_CHANNELS && channel != sd->channel))
+    if((target != ALL_TARGETS && target != sdev_id(sd)) ||
+       (channel != ALL_CHANNELS && channel != sdev_channel(sd)))
       continue;
     if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
-        printk(INFO_LEAD "Cleaning up status information "
-          "and delayed_scbs.\n", p->host_no, sd->channel, sd->id, sd->lun);
+        sdev_printk(KERN_INFO, sd, "Cleaning up status information "
+          "and delayed_scbs.\n");
     aic_dev->flags &= ~BUS_DEVICE_RESET_PENDING;
     if ( tag == SCB_LIST_NULL )
     {
@@ -3185,7 +3192,8 @@ aic7xxx_reset_device(struct aic7xxx_host
       aic_dev->flags = DEVICE_PRINT_DTR;
       aic_dev->temp_q_depth = aic_dev->max_q_depth;
     }
-    tcl = (sd->id << 4) | (sd->channel << 3) | sd->lun;
+    tcl = (sdev_id(sd) << 4) | (sdev_channel(sd) << 3) |
+          scsilun_to_int(&sd->lun);
     if ( (aic7xxx_index_busy_target(p, tcl, FALSE) == tag) ||
          (tag == SCB_LIST_NULL) )
       aic7xxx_index_busy_target(p, tcl, /* unbusy */ TRUE);
@@ -3210,7 +3218,8 @@ aic7xxx_reset_device(struct aic7xxx_host
   }
 
   if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
-    printk(INFO_LEAD "Cleaning QINFIFO.\n", p->host_no, channel, target, lun );
+    sdev_printk(KERN_INFO, sd, "Cleaning QINFIFO.\n");
+
   aic7xxx_search_qinfifo(p, target, channel, lun, tag,
       SCB_RESET | SCB_QUEUED_FOR_DONE, /* requeue */ FALSE, NULL);
 
@@ -3219,8 +3228,7 @@ aic7xxx_reset_device(struct aic7xxx_host
  *  ABORT/RESET commands.
  */
   if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
-    printk(INFO_LEAD "Cleaning waiting_scbs.\n", p->host_no, channel,
-      target, lun );
+    sdev_printk(KERN_INFO, sd, "Cleaning waiting_scbs.\n");
   {
     struct aic7xxx_scb *scbp, *prev_scbp;
 
@@ -3249,8 +3257,7 @@ aic7xxx_reset_device(struct aic7xxx_host
    * Search waiting for selection list.
    */
   if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
-    printk(INFO_LEAD "Cleaning waiting for selection "
-      "list.\n", p->host_no, channel, target, lun);
+    sdev_printk(KERN_INFO, sd, "Cleaning waiting for selection list.\n");
   {
     unsigned char next, prev, scb_index;
 
@@ -3266,9 +3273,8 @@ aic7xxx_reset_device(struct aic7xxx_host
         * No aic7xxx_verbose check here.....we want to see this since it
         * means either the kernel driver or the sequencer screwed things up
         */
-        printk(WARN_LEAD "Waiting List inconsistency; SCB index=%d, "
-          "numscbs=%d\n", p->host_no, channel, target, lun, scb_index,
-          p->scb_data->numscbs);
+        sdev_printk(KERN_WARNING, sd, "Waiting List inconsistency; SCB index=%d, "
+          "numscbs=%d\n", scb_index, p->scb_data->numscbs);
         next = aic_inb(p, SCB_NEXT);
         aic7xxx_add_curscb_to_free_list(p);
       }
@@ -3311,8 +3317,7 @@ aic7xxx_reset_device(struct aic7xxx_host
    * for completion, zeroing their control byte too.
    */
   if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
-    printk(INFO_LEAD "Cleaning disconnected scbs "
-      "list.\n", p->host_no, channel, target, lun);
+    sdev_printk(KERN_INFO, sd, "Cleaning disconnected scbs list.\n");
   if (p->flags & AHC_PAGESCBS)
   {
     unsigned char next, prev, scb_index;
@@ -3325,8 +3330,8 @@ aic7xxx_reset_device(struct aic7xxx_host
       scb_index = aic_inb(p, SCB_TAG);
       if (scb_index > p->scb_data->numscbs)
       {
-        printk(WARN_LEAD "Disconnected List inconsistency; SCB index=%d, "
-          "numscbs=%d\n", p->host_no, channel, target, lun, scb_index,
+        sdev_printk(KERN_WARNING, sd, "Disconnected List inconsistency; SCB index=%d, "
+          "numscbs=%d\n", scb_index,
           p->scb_data->numscbs);
         next = aic7xxx_rem_scb_from_disc_list(p, next, prev);
       }
@@ -3368,8 +3373,7 @@ aic7xxx_reset_device(struct aic7xxx_host
       aic_outb(p, next, SCBPTR);
       if (aic_inb(p, SCB_TAG) < p->scb_data->numscbs)
       {
-        printk(WARN_LEAD "Free list inconsistency!.\n", p->host_no, channel,
-          target, lun);
+        sdev_printk(KERN_WARNING, sd, "Free list inconsistency!.\n");
         init_lists = TRUE;
         next = SCB_LIST_NULL;
       }
@@ -3929,10 +3933,12 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
   struct aic7xxx_scb *scb;
   struct aic_dev_data *aic_dev;
   unsigned short target_mask;
-  unsigned char target, lun, tindex;
+  unsigned char target, tindex;
+  const struct scsi_lun *lun;
   unsigned char queue_flag = FALSE;
   char channel;
   int result;
+  struct scsi_device *sd = NULL; /* FIXME: initializer very wrong!!! */
 
   target = ((aic_inb(p, SAVED_TCL) >> 4) & 0x0f);
   if ( (p->chip & AHC_CHIPID_MASK) == AHC_AIC7770 )
@@ -3954,10 +3960,9 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
       {
         aic_outb(p, aic_inb(p, SCSISEQ) & (ENSELI|ENRSELI|ENAUTOATNP),
                  SCSISEQ);
-        printk(WARN_LEAD "No active SCB for reconnecting target - Issuing "
-               "BUS DEVICE RESET.\n", p->host_no, channel, target, lun);
-        printk(WARN_LEAD "      SAVED_TCL=0x%x, ARG_1=0x%x, SEQADDR=0x%x\n",
-               p->host_no, channel, target, lun,
+        sdev_printk(KERN_WARNING, sd, "No active SCB for reconnecting target - Issuing "
+               "BUS DEVICE RESET.\n");
+        sdev_printk(KERN_WARNING, sd, "      SAVED_TCL=0x%x, ARG_1=0x%x, SEQADDR=0x%x\n",
                aic_inb(p, SAVED_TCL), aic_inb(p, ARG_1),
                (aic_inb(p, SEQADDR1) << 8) | aic_inb(p, SEQADDR0));
         if (aic7xxx_panic_on_abort)
@@ -3968,8 +3973,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
     case SEND_REJECT:
       {
         if (aic7xxx_verbose & VERBOSE_MINOR_ERROR)
-          printk(INFO_LEAD "Rejecting unknown message (0x%x) received from "
-            "target, SEQ_FLAGS=0x%x\n", p->host_no, channel, target, lun,
+          sdev_printk(KERN_INFO, sd, "Rejecting unknown message (0x%x) received from "
+            "target, SEQ_FLAGS=0x%x\n",
             aic_inb(p, ACCUM), aic_inb(p, SEQ_FLAGS));
       }
       break;
@@ -3984,9 +3989,9 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
          * reset.
          */
         if (aic7xxx_verbose & (VERBOSE_SEQINT | VERBOSE_RESET_MID))
-          printk(INFO_LEAD "Target did not send an IDENTIFY message; "
-            "LASTPHASE 0x%x, SAVED_TCL 0x%x\n", p->host_no, channel, target,
-            lun, aic_inb(p, LASTPHASE), aic_inb(p, SAVED_TCL));
+          sdev_printk(KERN_INFO, sd, "Target did not send an IDENTIFY message; "
+            "LASTPHASE 0x%x, SAVED_TCL 0x%x\n",
+            aic_inb(p, LASTPHASE), aic_inb(p, SAVED_TCL));
 
         aic7xxx_reset_channel(p, channel, /*initiate reset*/ TRUE);
         aic7xxx_run_done_queue(p, TRUE);
@@ -3998,15 +4003,13 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
       if (aic_inb(p, LASTPHASE) == P_BUSFREE)
       {
         if (aic7xxx_verbose & VERBOSE_SEQINT)
-          printk(INFO_LEAD "Missed busfree.\n", p->host_no, channel,
-            target, lun);
+          sdev_printk(KERN_INFO, sd, "Missed busfree.\n");
         restart_sequencer(p);
       }
       else
       {
         if (aic7xxx_verbose & VERBOSE_SEQINT)
-          printk(INFO_LEAD "Unknown scsi bus phase, continuing\n", p->host_no,
-            channel, target, lun);
+          sdev_printk(KERN_INFO, sd, "Unknown scsi bus phase, continuing\n");
       }
       break;
 
@@ -4018,8 +4021,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
 
 #ifdef AIC7XXX_VERBOSE_DEBUGGING
         if (aic7xxx_verbose > 0xffff)
-          printk(INFO_LEAD "Enabling REQINITs for MSG_IN\n", p->host_no,
-                 channel, target, lun);
+          sdev_printk(KERN_INFO, sd, "Enabling REQINITs for MSG_IN\n");
 #endif
 
        /*      
@@ -4124,8 +4126,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
              * operation.
              */
             aic7xxx_busy_target(p, scb);
-            printk(INFO_LEAD "Device is refusing tagged commands, using "
-              "untagged I/O.\n", p->host_no, channel, target, lun);
+            sdev_printk(KERN_INFO, sd, "Device is refusing tagged commands, using "
+              "untagged I/O.\n");
             aic_outb(p, MSG_IDENTIFYFLAG, MSG_OUT);
             aic_outb(p, aic_inb(p, SCSISIGI) | ATNO, SCSISIGO);
           }
@@ -4150,8 +4152,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
           scb->flags &= ~SCB_MSGOUT_BITS;
           if(aic7xxx_verbose & VERBOSE_NEGOTIATION2)
           {
-            printk(INFO_LEAD "Device is rejecting PPR messages, falling "
-              "back.\n", p->host_no, channel, target, lun);
+            sdev_printk(KERN_INFO, sd, "Device is rejecting PPR messages, falling "
+              "back.\n");
           }
           if ( aic_dev->goal.width )
           {
@@ -4188,8 +4190,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
 			       aic_dev);
           if(aic7xxx_verbose & VERBOSE_NEGOTIATION2)
           {
-            printk(INFO_LEAD "Device is rejecting WDTR messages, using "
-              "narrow transfers.\n", p->host_no, channel, target, lun);
+            sdev_printk(KERN_INFO, sd, "Device is rejecting WDTR messages, using "
+              "narrow transfers.\n");
           }
           aic_dev->needsdtr = aic_dev->needsdtr_copy;
         }
@@ -4204,8 +4206,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
             (AHC_TRANS_CUR|AHC_TRANS_ACTIVE|AHC_TRANS_GOAL), aic_dev);
           if(aic7xxx_verbose & VERBOSE_NEGOTIATION2)
           {
-            printk(INFO_LEAD "Device is rejecting SDTR messages, using "
-              "async transfers.\n", p->host_no, channel, target, lun);
+            sdev_printk(KERN_INFO, sd, "Device is rejecting SDTR messages, using "
+              "async transfers.\n");
           }
         }
         else if (aic7xxx_verbose & VERBOSE_SEQINT)
@@ -4213,8 +4215,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
           /*
            * Otherwise, we ignore it.
            */
-          printk(INFO_LEAD "Received MESSAGE_REJECT for unknown cause.  "
-            "Ignoring.\n", p->host_no, channel, target, lun);
+          sdev_printk(KERN_INFO, sd, "Received MESSAGE_REJECT for unknown cause.  "
+            "Ignoring.\n");
         }
       }
       break;
@@ -4239,8 +4241,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
         scb_index = aic_inb(p, SCB_TAG);
         if (scb_index > p->scb_data->numscbs)
         {
-          printk(WARN_LEAD "Invalid SCB during SEQINT 0x%02x, SCB_TAG %d.\n",
-            p->host_no, channel, target, lun, intstat, scb_index);
+          sdev_printk(KERN_WARNING, sd, "Invalid SCB during SEQINT 0x%02x, SCB_TAG %d.\n",
+            intstat, scb_index);
           break;
         }
         scb = p->scb_data->scb_array[scb_index];
@@ -4248,8 +4250,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
 
         if (!(scb->flags & SCB_ACTIVE) || (scb->cmd == NULL))
         {
-          printk(WARN_LEAD "Invalid SCB during SEQINT 0x%x, scb %d, flags 0x%x,"
-            " cmd 0x%lx.\n", p->host_no, channel, target, lun, intstat,
+          sdev_printk(KERN_WARNING, sd, "Invalid SCB during SEQINT 0x%x, scb %d, flags 0x%x,"
+            " cmd 0x%lx.\n", intstat,
             scb_index, scb->flags, (unsigned long) scb->cmd);
         }
         else
@@ -4280,7 +4282,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
                 memcpy(scb->sense_cmd, &generic_sense[0],
                        sizeof(generic_sense));
 
-                scb->sense_cmd[1] = (cmd->device->lun << 5);
+                scb->sense_cmd[1] = (scsilun_to_int(&cmd->device->lun) << 5);
                 scb->sense_cmd[4] = sizeof(cmd->sense_buffer);
 
                 scb->sg_list[0].length = 
@@ -4898,9 +4900,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
 #endif
 
     default:                   /* unknown */
-      printk(WARN_LEAD "Unknown SEQINT, INTSTAT 0x%x, SCSISIGI 0x%x.\n",
-             p->host_no, channel, target, lun, intstat,
-             aic_inb(p, SCSISIGI));
+      sdev_printk(KERN_WARNING, sd, "Unknown SEQINT, INTSTAT 0x%x, SCSISIGI 0x%x.\n",
+             intstat, aic_inb(p, SCSISIGI));
       break;
   }
 
@@ -4924,16 +4925,17 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
   int reject, reply, done;
   unsigned char target_scsirate, tindex;
   unsigned short target_mask;
-  unsigned char target, channel, lun;
+  unsigned char target, channel;
+  const struct scsi_lun *lun;
   unsigned char bus_width, new_bus_width;
   unsigned char trans_options, new_trans_options;
   unsigned int period, new_period, offset, new_offset, maxsync;
   struct aic7xxx_syncrate *syncrate;
   struct aic_dev_data *aic_dev;
 
-  target = scb->cmd->device->id;
-  channel = scb->cmd->device->channel;
-  lun = scb->cmd->device->lun;
+  target = sdev_id(scb->cmd->device);
+  channel = sdev_channel(scb->cmd->device);
+  lun = &scb->cmd->device->lun;
   reply = reject = done = FALSE;
   tindex = TARGET_INDEX(scb->cmd);
   aic_dev = AIC_DEV(scb->cmd);
@@ -5666,6 +5668,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
   unsigned char status;
   struct aic7xxx_scb *scb;
   struct aic_dev_data *aic_dev;
+  struct scsi_device *sd;
 
   scb_index = aic_inb(p, SCB_TAG);
   status = aic_inb(p, SSTAT1);
@@ -6021,20 +6024,25 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
        * like our settings.
        */
       aic_dev = AIC_DEV(scb->cmd);
+      sd = aic_dev->SDptr;
       aic_dev->needppr = aic_dev->needppr_copy = 0;
-      aic7xxx_set_width(p, scb->cmd->device->id, scb->cmd->device->channel, scb->cmd->device->lun,
+      aic7xxx_set_width(p, sdev_id(scb->cmd->device),
+      			sdev_channel(scb->cmd->device),
+      			&scb->cmd->device->lun,
                         MSG_EXT_WDTR_BUS_8_BIT,
                         (AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE),
 			aic_dev);
-      aic7xxx_set_syncrate(p, NULL, scb->cmd->device->id, scb->cmd->device->channel, 0, 0,
+      aic7xxx_set_syncrate(p, NULL,
+      			   sdev_id(scb->cmd->device),
+			   sdev_channel(scb->cmd->device), 0, 0,
                            0, AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE,
 			   aic_dev);
       aic_dev->goal.options = 0;
       scb->flags &= ~SCB_MSGOUT_BITS;
       if(aic7xxx_verbose & VERBOSE_NEGOTIATION2)
       {
-        printk(INFO_LEAD "parity error during PPR message, reverting "
-               "to WDTR/SDTR\n", p->host_no, CTL_OF_SCB(scb));
+        sdev_printk(KERN_INFO, sd, "parity error during PPR message, reverting "
+               "to WDTR/SDTR\n");
       }
       if ( aic_dev->goal.width )
       {
@@ -6303,8 +6311,10 @@ aic7xxx_handle_command_completion_intr(s
         unpause_sequencer(p, FALSE);
         continue;
       }
-      aic7xxx_reset_device(p, scb->cmd->device->id, scb->cmd->device->channel,
-        scb->cmd->device->lun, scb->hscb->tag);
+      aic7xxx_reset_device(p,
+        sdev_id(scb->cmd->device),
+	sdev_channel(scb->cmd->device),
+        &scb->cmd->device->lun, scb->hscb->tag);
       scb->flags &= ~(SCB_QUEUED_FOR_DONE | SCB_RESET | SCB_ABORT |
         SCB_QUEUED_ABORT);
       unpause_sequencer(p, FALSE);
@@ -6517,7 +6527,7 @@ aic7xxx_init_transinfo(struct aic7xxx_ho
   Scsi_Device *sdpnt = aic_dev->SDptr;
   unsigned char tindex;
 
-  tindex = sdpnt->id | (sdpnt->channel << 3);
+  tindex = sdev_id(sdpnt) | (sdev_channel(sdpnt) << 3);
   if (!(aic_dev->flags & DEVICE_DTR_SCANNED))
   {
     aic_dev->flags |= DEVICE_DTR_SCANNED;
@@ -6531,7 +6541,7 @@ aic7xxx_init_transinfo(struct aic7xxx_ho
     {
       aic_dev->needwdtr = aic_dev->needwdtr_copy = 0;
       pause_sequencer(p);
-      aic7xxx_set_width(p, sdpnt->id, sdpnt->channel, sdpnt->lun,
+      aic7xxx_set_width(p, sdev_id(sdpnt), sdev_channel(sdpnt), &sdpnt->lun,
                         MSG_EXT_WDTR_BUS_8_BIT, (AHC_TRANS_ACTIVE |
                                                  AHC_TRANS_GOAL |
                                                  AHC_TRANS_CUR), aic_dev );
@@ -6593,7 +6603,7 @@ aic7xxx_slave_alloc(Scsi_Device *SDptr)
    * Check to see if channel was scanned.
    */
   
-  if (!(p->flags & AHC_A_SCANNED) && (SDptr->channel == 0))
+  if (!(p->flags & AHC_A_SCANNED) && (sdev_channel(SDptr) == 0))
   {
     if (aic7xxx_verbose & VERBOSE_PROBE2)
       printk(INFO_LEAD "Scanning channel for devices.\n",
@@ -6602,7 +6612,7 @@ aic7xxx_slave_alloc(Scsi_Device *SDptr)
   }
   else
   {
-    if (!(p->flags & AHC_B_SCANNED) && (SDptr->channel == 1))
+    if (!(p->flags & AHC_B_SCANNED) && (sdev_channel(SDptr) == 1))
     {
       if (aic7xxx_verbose & VERBOSE_PROBE2)
         printk(INFO_LEAD "Scanning channel for devices.\n",
@@ -6650,7 +6660,7 @@ aic7xxx_device_queue_depth(struct aic7xx
   struct aic_dev_data *aic_dev = device->hostdata;
   unsigned char tindex;
 
-  tindex = device->id | (device->channel << 3);
+  tindex = sdev_id(device) | (sdev_channel(device) << 3);
 
   if (device->simple_tags)
     return; // We've already enabled this device
@@ -6662,9 +6672,8 @@ aic7xxx_device_queue_depth(struct aic7xx
     if (!(p->discenable & (1 << tindex)))
     {
       if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
-        printk(INFO_LEAD "Disconnection disabled, unable to "
-             "enable tagged queueing.\n",
-             p->host_no, device->channel, device->id, device->lun);
+        sdev_printk(KERN_INFO, device, "Disconnection disabled, unable to "
+             "enable tagged queueing.\n");
       tag_enabled = FALSE;
     }
     else
@@ -6707,9 +6716,9 @@ aic7xxx_device_queue_depth(struct aic7xx
   {
     if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
     {
-          printk(INFO_LEAD "Tagged queuing enabled, queue depth %d.\n",
-            p->host_no, device->channel, device->id,
-            device->lun, aic_dev->max_q_depth);
+          sdev_printk(KERN_INFO, device,
+	  	"Tagged queuing enabled, queue depth %d.\n",
+            	aic_dev->max_q_depth);
     }
     scsi_adjust_queue_depth(device, MSG_ORDERED_TAG, aic_dev->max_q_depth);
   }
@@ -6717,9 +6726,9 @@ aic7xxx_device_queue_depth(struct aic7xx
   {
     if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
     {
-          printk(INFO_LEAD "Tagged queuing disabled, queue depth %d.\n",
-            p->host_no, device->channel, device->id,
-            device->lun, device->host->cmd_per_lun);
+          sdev_printk(KERN_INFO, device,
+	  	"Tagged queuing disabled, queue depth %d.\n",
+            	device->host->cmd_per_lun);
     }
     scsi_adjust_queue_depth(device, 0, device->host->cmd_per_lun);
   }
@@ -10195,8 +10204,9 @@ aic7xxx_buildscb(struct aic7xxx_host *p,
     }
     scb->flags |= SCB_DTR_SCB;
   }
-  hscb->target_channel_lun = ((cmd->device->id << 4) & 0xF0) |
-        ((cmd->device->channel & 0x01) << 3) | (cmd->device->lun & 0x07);
+  hscb->target_channel_lun = ((sdev_id(cmd->device) << 4) & 0xF0) |
+        ((sdev_channel(cmd->device) & 0x01) << 3) |
+	(scsilun_to_int(&cmd->device->lun) & 0x07);
 
   /*
    * The interpretation of request_buffer and request_bufflen
@@ -10435,7 +10445,7 @@ __aic7xxx_bus_device_reset(Scsi_Cmnd *cm
          aic_inb(p, STCNT));
   }
 
-  channel = cmd->device->channel;
+  channel = sdev_channel(cmd->device);
 
     /*
      * Send a Device Reset Message:
@@ -10502,7 +10512,8 @@ __aic7xxx_bus_device_reset(Scsi_Cmnd *cm
    * Check to see if the command is on the qinfifo.  If it is, then we will
    * not need to queue the command again since the card should start it soon
    */
-  if (aic7xxx_search_qinfifo(p, cmd->device->channel, cmd->device->id, cmd->device->lun, hscb->tag,
+  if (aic7xxx_search_qinfifo(p, sdev_channel(cmd->device),
+  			sdev_id(cmd->device), &cmd->device->lun, hscb->tag,
 			  0, TRUE, NULL) == 0)
   {
     disconnected = TRUE;
@@ -10669,8 +10680,9 @@ __aic7xxx_abort(Scsi_Cmnd *cmd)
 /*
  *  We just checked the waiting_q, now for the QINFIFO
  */
-  if ( ((found = aic7xxx_search_qinfifo(p, cmd->device->id, cmd->device->channel,
-                     cmd->device->lun, scb->hscb->tag, SCB_ABORT | SCB_QUEUED_FOR_DONE,
+  if ( ((found = aic7xxx_search_qinfifo(p, sdev_id(cmd->device),
+  			sdev_channel(cmd->device),
+                     	&cmd->device->lun, scb->hscb->tag, SCB_ABORT | SCB_QUEUED_FOR_DONE,
                      FALSE, NULL)) != 0) &&
                     (aic7xxx_verbose & VERBOSE_ABORT_PROCESS))
   {
@@ -10893,10 +10905,10 @@ aic7xxx_reset(Scsi_Cmnd *cmd)
  *  By this point, we want to already know what we are going to do and
  *  only have the following code implement our course of action.
  */
-  aic7xxx_reset_channel(p, cmd->device->channel, TRUE);
+  aic7xxx_reset_channel(p, sdev_channel(cmd->device), TRUE);
   if (p->features & AHC_TWIN)
   {
-    aic7xxx_reset_channel(p, cmd->device->channel ^ 0x01, TRUE);
+    aic7xxx_reset_channel(p, sdev_channel(cmd->device) ^ 0x01, TRUE);
     restart_sequencer(p);
   }
   aic_outb(p,  aic_inb(p, SIMODE1) & ~(ENREQINIT|ENBUSFREE), SIMODE1);
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
index 3bf3349..af4f7fe 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
@@ -89,6 +89,7 @@ aic7xxx_proc_info ( struct Scsi_Host *HB
   int    size = 0;
   unsigned char i;
   unsigned char tindex;
+  char lunstr[SCSILUN_STR_LEN];
 
   for(p=first_aic7xxx; p && p->host != HBAptr; p=p->next)
     ;
@@ -261,9 +262,10 @@ aic7xxx_proc_info ( struct Scsi_Host *HB
   list_for_each_entry(aic_dev, &p->aic_devs, list)
   {
     sdptr = aic_dev->SDptr;
-    tindex = sdptr->channel << 3 | sdptr->id;
-    size += sprintf(BLS, "(scsi%d:%d:%d:%d)\n",
-        p->host_no, sdptr->channel, sdptr->id, sdptr->lun);
+    tindex = sdev_channel(sdptr) << 3 | sdev_id(sdptr);
+    size += sprintf(BLS, "(scsi%d:%d:%d:%s)\n",
+        p->host_no, sdev_channel(sdptr), sdev_id(sdptr),
+	scsilun_to_str(&sdptr->lun, lunstr));
     size += sprintf(BLS, "  Device using %s/%s",
           (aic_dev->cur.width == MSG_EXT_WDTR_BUS_16_BIT) ?
           "Wide" : "Narrow",
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index d59d449..80c202e 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -671,7 +671,7 @@ static irqreturn_t fd_mcs_intr(int irq, 
 		outb(0x40 | FIFO_COUNT, Interrupt_Cntl_port);
 
 		outb(0x82, SCSI_Cntl_port);	/* Bus Enable + Select */
-		outb(adapter_mask | (1 << current_SC->device->id), SCSI_Data_NoACK_port);
+		outb(adapter_mask | (1 << sdev_id(current_SC->device)), SCSI_Data_NoACK_port);
 
 		/* Stop arbitration and enable parity */
 		outb(0x10 | PARITY_MASK, TMC_Cntl_port);
@@ -683,7 +683,7 @@ static irqreturn_t fd_mcs_intr(int irq, 
 		status = inb(SCSI_Status_port);
 		if (!(status & 0x01)) {
 			/* Try again, for slow devices */
-			if (fd_mcs_select(shpnt, current_SC->device->id)) {
+			if (fd_mcs_select(shpnt, sdev_id(current_SC->device))) {
 #if EVERY_ACCESS
 				printk(" SFAIL ");
 #endif
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index aed7e64..1f03112 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -343,7 +343,7 @@ static int in2000_queuecommand(Scsi_Cmnd
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
-	DB(DB_QUEUE_COMMAND, printk("Q-%d-%02x-%ld(", cmd->device->id, cmd->cmnd[0], cmd->pid))
+	DB(DB_QUEUE_COMMAND, sdev_printk(KERN_DEBUG, cmd->device, "Q-%02x-%ld(", cmd->cmnd[0], cmd->pid))
 
 /* Set up a few fields in the Scsi_Cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
@@ -470,7 +470,7 @@ static void in2000_execute(struct Scsi_H
 	cmd = (Scsi_Cmnd *) hostdata->input_Q;
 	prev = NULL;
 	while (cmd) {
-		if (!(hostdata->busy[cmd->device->id] & (1 << cmd->device->lun)))
+		if (!(hostdata->busy[sdev_id(cmd->device)] & (1 << scsilun_to_int(&cmd->device->lun))))
 			break;
 		prev = cmd;
 		cmd = (Scsi_Cmnd *) cmd->host_scribble;
@@ -493,7 +493,7 @@ static void in2000_execute(struct Scsi_H
 		hostdata->input_Q = (Scsi_Cmnd *) cmd->host_scribble;
 
 #ifdef PROC_STATISTICS
-	hostdata->cmd_cnt[cmd->device->id]++;
+	hostdata->cmd_cnt[sdev_id(cmd->device)]++;
 #endif
 
 /*
@@ -501,9 +501,9 @@ static void in2000_execute(struct Scsi_H
  */
 
 	if (is_dir_out(cmd))
-		write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id);
+		write_3393(hostdata, WD_DESTINATION_ID, sdev_id(cmd->device));
 	else
-		write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id | DSTID_DPD);
+		write_3393(hostdata, WD_DESTINATION_ID, sdev_id(cmd->device) | DSTID_DPD);
 
 /* Now we need to figure out whether or not this command is a good
  * candidate for disconnect/reselect. We guess to the best of our
@@ -540,7 +540,8 @@ static void in2000_execute(struct Scsi_H
 	if (!(hostdata->input_Q))	/* input_Q empty? */
 		goto no;
 	for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev; prev = (Scsi_Cmnd *) prev->host_scribble) {
-		if ((prev->device->id != cmd->device->id) || (prev->device->lun != cmd->device->lun)) {
+		if ((sdev_id(prev->device) != sdev_id(cmd->device)) ||
+		     (!scsilun_eq(&prev->device->lun, &cmd->device->lun))) {
 			for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev; prev = (Scsi_Cmnd *) prev->host_scribble)
 				prev->SCp.phase = 1;
 			goto yes;
@@ -552,17 +553,17 @@ static void in2000_execute(struct Scsi_H
 	cmd->SCp.phase = 1;
 
 #ifdef PROC_STATISTICS
-	hostdata->disc_allowed_cnt[cmd->device->id]++;
+	hostdata->disc_allowed_cnt[sdev_id(cmd->device)]++;
 #endif
 
       no:
 	write_3393(hostdata, WD_SOURCE_ID, ((cmd->SCp.phase) ? SRCID_ER : 0));
 
-	write_3393(hostdata, WD_TARGET_LUN, cmd->device->lun);
-	write_3393(hostdata, WD_SYNCHRONOUS_TRANSFER, hostdata->sync_xfer[cmd->device->id]);
-	hostdata->busy[cmd->device->id] |= (1 << cmd->device->lun);
+	write_3393(hostdata, WD_TARGET_LUN, scsilun_to_int(&cmd->device->lun));
+	write_3393(hostdata, WD_SYNCHRONOUS_TRANSFER, hostdata->sync_xfer[sdev_id(cmd->device)]);
+	hostdata->busy[sdev_id(cmd->device)] |= (1 << scsilun_to_int(&cmd->device->lun));
 
-	if ((hostdata->level2 <= L2_NONE) || (hostdata->sync_stat[cmd->device->id] == SS_UNSET)) {
+	if ((hostdata->level2 <= L2_NONE) || (hostdata->sync_stat[sdev_id(cmd->device)] == SS_UNSET)) {
 
 		/*
 		 * Do a 'Select-With-ATN' command. This will end with
@@ -584,11 +585,11 @@ static void in2000_execute(struct Scsi_H
  * unless we don't want to even _try_ synchronous transfers: In this
  * case we set SS_SET to make the defaults final.
  */
-		if (hostdata->sync_stat[cmd->device->id] == SS_UNSET) {
-			if (hostdata->sync_off & (1 << cmd->device->id))
-				hostdata->sync_stat[cmd->device->id] = SS_SET;
+		if (hostdata->sync_stat[sdev_id(cmd->device)] == SS_UNSET) {
+			if (hostdata->sync_off & (1 << sdev_id(cmd->device)))
+				hostdata->sync_stat[sdev_id(cmd->device)] = SS_SET;
 			else
-				hostdata->sync_stat[cmd->device->id] = SS_FIRST;
+				hostdata->sync_stat[sdev_id(cmd->device)] = SS_FIRST;
 		}
 		hostdata->state = S_SELECTING;
 		write_3393_count(hostdata, 0);	/* this guarantees a DATA_PHASE interrupt */
@@ -769,7 +770,7 @@ static void transfer_bytes(Scsi_Cmnd * c
 
 /* Set up hardware registers */
 
-	write_3393(hostdata, WD_SYNCHRONOUS_TRANSFER, hostdata->sync_xfer[cmd->device->id]);
+	write_3393(hostdata, WD_SYNCHRONOUS_TRANSFER, hostdata->sync_xfer[sdev_id(cmd->device)]);
 	write_3393_count(hostdata, cmd->SCp.this_residual);
 	write_3393(hostdata, WD_CONTROL, CTRL_IDI | CTRL_EDI | CTRL_BUS);
 	write1_io(0, IO_FIFO_WRITE);	/* zero counter, assume write */
@@ -1074,7 +1075,7 @@ static irqreturn_t in2000_intr(int irqnu
 		}
 
 		cmd->result = DID_NO_CONNECT << 16;
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 		hostdata->state = S_UNCONNECTED;
 		cmd->scsi_done(cmd);
 
@@ -1096,16 +1097,16 @@ static irqreturn_t in2000_intr(int irqnu
 
 		/* construct an IDENTIFY message with correct disconnect bit */
 
-		hostdata->outgoing_msg[0] = (0x80 | 0x00 | cmd->device->lun);
+		hostdata->outgoing_msg[0] = (0x80 | 0x00 | scsilun_to_int(&cmd->device->lun));
 		if (cmd->SCp.phase)
 			hostdata->outgoing_msg[0] |= 0x40;
 
-		if (hostdata->sync_stat[cmd->device->id] == SS_FIRST) {
+		if (hostdata->sync_stat[sdev_id(cmd->device)] == SS_FIRST) {
 #ifdef SYNC_DEBUG
 			printk(" sending SDTR ");
 #endif
 
-			hostdata->sync_stat[cmd->device->id] = SS_WAITING;
+			hostdata->sync_stat[sdev_id(cmd->device)] = SS_WAITING;
 
 			/* tack on a 2nd message to ask about synchronous transfers */
 
@@ -1224,8 +1225,8 @@ static irqreturn_t in2000_intr(int irqnu
 #ifdef SYNC_DEBUG
 			    printk("-REJ-");
 #endif
-			if (hostdata->sync_stat[cmd->device->id] == SS_WAITING)
-				hostdata->sync_stat[cmd->device->id] = SS_SET;
+			if (hostdata->sync_stat[sdev_id(cmd->device)] == SS_WAITING)
+				hostdata->sync_stat[sdev_id(cmd->device)] = SS_SET;
 			write_3393_cmd(hostdata, WD_CMD_NEGATE_ACK);
 			hostdata->state = S_CONNECTED;
 			break;
@@ -1245,7 +1246,7 @@ static irqreturn_t in2000_intr(int irqnu
 				switch (ucp[2]) {	/* what's the EXTENDED code? */
 				case EXTENDED_SDTR:
 					id = calc_sync_xfer(ucp[3], ucp[4]);
-					if (hostdata->sync_stat[cmd->device->id] != SS_WAITING) {
+					if (hostdata->sync_stat[sdev_id(cmd->device)] != SS_WAITING) {
 
 /* A device has sent an unsolicited SDTR message; rather than go
  * through the effort of decoding it and then figuring out what
@@ -1263,14 +1264,14 @@ static irqreturn_t in2000_intr(int irqnu
 						hostdata->outgoing_msg[3] = hostdata->default_sx_per / 4;
 						hostdata->outgoing_msg[4] = 0;
 						hostdata->outgoing_len = 5;
-						hostdata->sync_xfer[cmd->device->id] = calc_sync_xfer(hostdata->default_sx_per / 4, 0);
+						hostdata->sync_xfer[sdev_id(cmd->device)] = calc_sync_xfer(hostdata->default_sx_per / 4, 0);
 					} else {
-						hostdata->sync_xfer[cmd->device->id] = id;
+						hostdata->sync_xfer[sdev_id(cmd->device)] = id;
 					}
 #ifdef SYNC_DEBUG
-					printk("sync_xfer=%02x", hostdata->sync_xfer[cmd->device->id]);
+					printk("sync_xfer=%02x", hostdata->sync_xfer[sdev_id(cmd->device)]);
 #endif
-					hostdata->sync_stat[cmd->device->id] = SS_SET;
+					hostdata->sync_stat[sdev_id(cmd->device)] = SS_SET;
 					write_3393_cmd(hostdata, WD_CMD_NEGATE_ACK);
 					hostdata->state = S_CONNECTED;
 					break;
@@ -1332,7 +1333,7 @@ static irqreturn_t in2000_intr(int irqnu
 			lun = read_3393(hostdata, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
 			    hostdata->connected = NULL;
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+			hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 			hostdata->state = S_UNCONNECTED;
 			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
 				cmd->SCp.Status = lun;
@@ -1417,7 +1418,7 @@ static irqreturn_t in2000_intr(int irqnu
 		}
 		DB(DB_INTR, printk("UNEXP_DISC-%ld", cmd->pid))
 		    hostdata->connected = NULL;
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 		hostdata->state = S_UNCONNECTED;
 		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
 			cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
@@ -1448,7 +1449,7 @@ static irqreturn_t in2000_intr(int irqnu
 		switch (hostdata->state) {
 		case S_PRE_CMP_DISC:
 			hostdata->connected = NULL;
-			hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+			hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 			hostdata->state = S_UNCONNECTED;
 			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
 			    if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
@@ -1465,7 +1466,7 @@ static irqreturn_t in2000_intr(int irqnu
 			hostdata->state = S_UNCONNECTED;
 
 #ifdef PROC_STATISTICS
-			hostdata->disc_done_cnt[cmd->device->id]++;
+			hostdata->disc_done_cnt[sdev_id(cmd->device)]++;
 #endif
 
 			break;
@@ -1493,7 +1494,7 @@ static irqreturn_t in2000_intr(int irqnu
 			if (hostdata->selecting) {
 				cmd = (Scsi_Cmnd *) hostdata->selecting;
 				hostdata->selecting = NULL;
-				hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+				hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 				cmd->host_scribble = (uchar *) hostdata->input_Q;
 				hostdata->input_Q = cmd;
 			}
@@ -1503,7 +1504,7 @@ static irqreturn_t in2000_intr(int irqnu
 
 			if (cmd) {
 				if (phs == 0x00) {
-					hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+					hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 					cmd->host_scribble = (uchar *) hostdata->input_Q;
 					hostdata->input_Q = cmd;
 				} else {
@@ -1535,7 +1536,7 @@ static irqreturn_t in2000_intr(int irqnu
 		cmd = (Scsi_Cmnd *) hostdata->disconnected_Q;
 		patch = NULL;
 		while (cmd) {
-			if (id == cmd->device->id && lun == cmd->device->lun)
+			if (id == sdev_id(cmd->device) && lun == scsilun_to_int(&cmd->device->lun))
 				break;
 			patch = cmd;
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
@@ -1562,9 +1563,9 @@ static irqreturn_t in2000_intr(int irqnu
 		 */
 
 		if (is_dir_out(cmd))
-			write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id);
+			write_3393(hostdata, WD_DESTINATION_ID, sdev_id(cmd->device));
 		else
-			write_3393(hostdata, WD_DESTINATION_ID, cmd->device->id | DSTID_DPD);
+			write_3393(hostdata, WD_DESTINATION_ID, sdev_id(cmd->device) | DSTID_DPD);
 		if (hostdata->level2 >= L2_RESELECT) {
 			write_3393_count(hostdata, 0);	/* we want a DATA_PHASE interrupt */
 			write_3393(hostdata, WD_COMMAND_PHASE, 0x45);
@@ -1757,7 +1758,7 @@ static int __in2000_abort(Scsi_Cmnd * cm
 		sr = read_3393(hostdata, WD_SCSI_STATUS);
 		printk("asr=%02x, sr=%02x.", asr, sr);
 
-		hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
+		hostdata->busy[sdev_id(cmd->device)] &= ~(1 << scsilun_to_int(&cmd->device->lun));
 		hostdata->connected = NULL;
 		hostdata->state = S_UNCONNECTED;
 		cmd->result = DID_ABORT << 16;
@@ -2166,6 +2167,7 @@ static int in2000_proc_info(struct Scsi_
 	Scsi_Cmnd *cmd;
 	int x, i;
 	static int stop = 0;
+	char lunstr[SCSILUN_STR_LEN];
 
 	hd = (struct IN2000_hostdata *) instance->hostdata;
 
@@ -2256,7 +2258,10 @@ static int in2000_proc_info(struct Scsi_
 		strcat(bp, "\nconnected:     ");
 		if (hd->connected) {
 			cmd = (Scsi_Cmnd *) hd->connected;
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %ld-%d:%s(%02x)", cmd->pid,
+				sdev_id(cmd->device),
+				scsilun_to_str(&cmd->device->lun, lunstr),
+				cmd->cmnd[0]);
 			strcat(bp, tbuf);
 		}
 	}
@@ -2264,7 +2269,10 @@ static int in2000_proc_info(struct Scsi_
 		strcat(bp, "\ninput_Q:       ");
 		cmd = (Scsi_Cmnd *) hd->input_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %ld-%d:%s(%02x)", cmd->pid,
+				sdev_id(cmd->device),
+				scsilun_to_str(&cmd->device->lun, lunstr),
+				cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
@@ -2273,7 +2281,10 @@ static int in2000_proc_info(struct Scsi_
 		strcat(bp, "\ndisconnected_Q:");
 		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
 		while (cmd) {
-			sprintf(tbuf, " %ld-%d:%d(%02x)", cmd->pid, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
+			sprintf(tbuf, " %ld-%d:%s(%02x)", cmd->pid,
+				sdev_id(cmd->device),
+				scsilun_to_str(&cmd->device->lun, lunstr),
+				cmd->cmnd[0]);
 			strcat(bp, tbuf);
 			cmd = (Scsi_Cmnd *) cmd->host_scribble;
 		}
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 4cdd891..10d9981 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1125,8 +1125,8 @@ ips_queue(Scsi_Cmnd * SC, void (*done) (
 		  SC->device->channel, SC->device->id, SC->device->lun);
 
 	/* Check for command to initiator IDs */
-	if ((SC->device->channel > 0)
-	    && (SC->device->id == ha->ha_id[SC->device->channel])) {
+	if ((sdev_channel(SC->device) > 0)
+	    && (sdev_id(SC->device) == ha->ha_id[sdev_channel(SC->device)])) {
 		SC->result = DID_NO_CONNECT << 16;
 		done(SC);
 
@@ -1611,9 +1611,9 @@ ips_is_passthru(Scsi_Cmnd * SC)
 		return (0);
 
 	if ((SC->cmnd[0] == IPS_IOCTL_COMMAND) &&
-	    (SC->device->channel == 0) &&
-	    (SC->device->id == IPS_ADAPTER_ID) &&
-	    (SC->device->lun == 0) && SC->request_buffer) {
+	    (sdev_channel(SC->device) == 0) &&
+	    (sdev_id(SC->device) == IPS_ADAPTER_ID) &&
+	    (scsilun_zero(&SC->device->lun) == 0) && SC->request_buffer) {
 		if ((!SC->use_sg) && SC->request_bufflen &&
 		    (((char *) SC->request_buffer)[0] == 'C') &&
 		    (((char *) SC->request_buffer)[1] == 'O') &&
@@ -1969,9 +1969,9 @@ ips_flash_firmware(ips_ha_t * ha, ips_pa
 	/* FIX stuff that might be wrong */
 	scb->sg_list.list = sg_list.list;
 	scb->scb_busaddr = cmd_busaddr;
-	scb->bus = scb->scsi_cmd->device->channel;
-	scb->target_id = scb->scsi_cmd->device->id;
-	scb->lun = scb->scsi_cmd->device->lun;
+	scb->bus = sdev_channel(scb->scsi_cmd->device);
+	scb->target_id = sdev_id(scb->scsi_cmd->device);
+	scb->lun = scsilun_to_int(&scb->scsi_cmd->device->lun);
 	scb->sg_len = 0;
 	scb->data_len = 0;
 	scb->flags = 0;
@@ -2038,9 +2038,9 @@ ips_usrcmd(ips_ha_t * ha, ips_passthru_t
 	/* FIX stuff that might be wrong */
 	scb->sg_list.list = sg_list.list;
 	scb->scb_busaddr = cmd_busaddr;
-	scb->bus = scb->scsi_cmd->device->channel;
-	scb->target_id = scb->scsi_cmd->device->id;
-	scb->lun = scb->scsi_cmd->device->lun;
+	scb->bus = sdev_channel(scb->scsi_cmd->device);
+	scb->target_id = sdev_id(scb->scsi_cmd->device);
+	scb->lun = scsilun_to_int(&scb->scsi_cmd->device->lun);
 	scb->sg_len = 0;
 	scb->data_len = 0;
 	scb->flags = 0;
@@ -2830,10 +2830,10 @@ ips_next(ips_ha_t * ha, int intr)
 
 	p = ha->scb_waitlist.head;
 	while ((p) && (scb = ips_getscb(ha))) {
-		if ((p->device->channel > 0)
+		if ((sdev_channel(p->device) > 0)
 		    && (ha->
-			dcdb_active[p->device->channel -
-				    1] & (1 << p->device->id))) {
+			dcdb_active[sdev_channel(p->device) -
+				    1] & (1 << sdev_id(p->device)))) {
 			ips_freescb(ha, scb);
 			p = (Scsi_Cmnd *) p->host_scribble;
 			continue;
@@ -2850,9 +2850,9 @@ ips_next(ips_ha_t * ha, int intr)
 
 		memset(SC->sense_buffer, 0, sizeof (SC->sense_buffer));
 
-		scb->target_id = SC->device->id;
-		scb->lun = SC->device->lun;
-		scb->bus = SC->device->channel;
+		scb->target_id = sdev_id(SC->device);
+		scb->lun = scsilun_to_int(&SC->device->lun);
+		scb->bus = sdev_channel(SC->device);
 		scb->scsi_cmd = SC;
 		scb->breakup = 0;
 		scb->data_len = 0;
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index b5fb13d..1a8bf14 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -957,7 +957,8 @@ static irqreturn_t nspintr(int irq, void
 	unsigned int   base;
 	unsigned char  irq_status, irq_phase, phase;
 	Scsi_Cmnd     *tmpSC;
-	unsigned char  target, lun;
+	unsigned char  target;
+	const struct scsi_lun *lun;
 	unsigned int  *sync_neg;
 	int            i, tmp;
 	nsp_hw_data   *data;
@@ -1052,7 +1053,7 @@ static irqreturn_t nspintr(int irq, void
 
 	tmpSC    = data->CurrentSC;
 	target   = sdev_id(tmpSC->device);
-	lun      = scsilun_to_int(&tmpSC->device->lun);
+	lun      = &tmpSC->device->lun;
 	sync_neg = &(data->Sync[target].SyncNegotiation);
 
 	/*
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index b0b6cdf..38f562c 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -726,8 +726,7 @@ static int u14_34f_slave_configure(struc
    else
       link_suffix = "";
 
-   printk("%s: scsi%d, channel %d, id %d, lun %d, cmds/lun %d%s%s.\n",
-          BN(j), host->host_no, dev->channel, dev->id, dev->lun,
+   sdev_printk(KERN_INFO, dev, "cmds/lun %d%s%s.\n",
           dev->queue_depth, link_suffix, tag_suffix);
 
    return FALSE;
@@ -1291,14 +1290,14 @@ static int u14_34f_queuecommand(struct s
    cpp->cpp_index = i;
    SCpnt->host_scribble = (unsigned char *) &cpp->cpp_index;
 
-   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%d, pid %ld.\n",
-                        BN(j), i, SCpnt->device->channel, SCpnt->device->id,
-                        SCpnt->device->lun, SCpnt->pid);
+   if (do_trace)
+   	sdev_printk(KERN_INFO, SCpnt->device,
+		"qcomm, mbox %d, pid %ld.\n", i, SCpnt->pid);
 
    cpp->opcode = OP_SCSI;
-   cpp->channel = SCpnt->device->channel;
-   cpp->target = SCpnt->device->id;
-   cpp->lun = SCpnt->device->lun;
+   cpp->channel = sdev_channel(SCpnt->device);
+   cpp->target = sdev_id(SCpnt->device);
+   cpp->lun = scsilun_to_int(&SCpnt->device->lun);
    cpp->SCpnt = SCpnt;
    cpp->cdb_len = SCpnt->cmd_len;
    memcpy(cpp->cdb, SCpnt->cmnd, SCpnt->cmd_len);
@@ -1319,8 +1318,8 @@ static int u14_34f_queuecommand(struct s
    if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
       unmap_dma(i, j);
       SCpnt->host_scribble = NULL;
-      printk("%s: qcomm, target %d.%d:%d, pid %ld, adapter busy.\n",
-             BN(j), SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun, SCpnt->pid);
+      sdev_printk(KERN_INFO, SCpnt->device, 
+      		"qcomm, pid %ld, adapter busy.\n", SCpnt->pid);
       return 1;
       }
 
@@ -1340,14 +1339,14 @@ static int u14_34f_eh_abort(struct scsi_
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
 
    if (SCarg->host_scribble == NULL) {
-      printk("%s: abort, target %d.%d:%d, pid %ld inactive.\n",
-             BN(j), SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);
+      sdev_printk(KERN_INFO, SCarg->device, "abort, pid %ld inactive.\n",
+             SCarg->pid);
       return SUCCESS;
       }
 
    i = *(unsigned int *)SCarg->host_scribble;
-   printk("%s: abort, mbox %d, target %d.%d:%d, pid %ld.\n",
-          BN(j), i, SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);
+   sdev_printk(KERN_INFO, SCarg->device, "abort, mbox %d, pid %ld.\n",
+	       i, SCarg->pid);
 
    if (i >= sh[j]->can_queue)
       panic("%s: abort, invalid SCarg->host_scribble.\n", BN(j));
@@ -1405,8 +1404,8 @@ static int u14_34f_eh_host_reset(struct 
    struct scsi_cmnd *SCpnt;
 
    j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
-   printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
-          BN(j), SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);
+   sdev_printk(KERN_INFO, SCarg->device,
+   	"reset, enter, pid %ld.\n", SCarg->pid);
 
    spin_lock_irq(sh[j]->host_lock);
 
@@ -1709,9 +1708,10 @@ static void flush_dev(struct scsi_device
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
 
       if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
-         printk("%s: %s, target %d.%d:%d, pid %ld, mbox %d, adapter"\
-                " busy, will abort.\n", BN(j), (ihdlr ? "ihdlr" : "qcomm"),
-                SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun, SCpnt->pid, k);
+         sdev_printk(KERN_INFO, SCpnt->device,
+	 	"%s, pid %ld, mbox %d, adapter"\
+                " busy, will abort.\n", (ihdlr ? "ihdlr" : "qcomm"),
+                SCpnt->pid, k);
          HD(j)->cp_stat[k] = ABORTING;
          continue;
          }
@@ -1823,7 +1823,7 @@ static irqreturn_t ihdlr(int irq, unsign
 
          /* If there was a bus reset, redo operation on each target */
          else if (tstatus != GOOD && SCpnt->device->type == TYPE_DISK
-                  && HD(j)->target_redo[SCpnt->device->id][SCpnt->device->channel])
+                  && HD(j)->target_redo[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)])
             status = DID_BUS_BUSY << 16;
 
          /* Works around a flaw in scsi.c */
@@ -1836,29 +1836,28 @@ static irqreturn_t ihdlr(int irq, unsign
             status = DID_OK << 16;
 
          if (tstatus == GOOD)
-            HD(j)->target_redo[SCpnt->device->id][SCpnt->device->channel] = FALSE;
+            HD(j)->target_redo[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)] = FALSE;
 
          if (spp->target_status && SCpnt->device->type == TYPE_DISK &&
              (!(tstatus == CHECK_CONDITION && HD(j)->iocount <= 1000 &&
                (SCpnt->sense_buffer[2] & 0xf) == NOT_READY)))
-            printk("%s: ihdlr, target %d.%d:%d, pid %ld, "\
-                   "target_status 0x%x, sense key 0x%x.\n", BN(j),
-                   SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
+            sdev_printk(KERN_INFO, SCpnt->device,
+	    	"ihdlr, pid %ld, target_status 0x%x, sense key 0x%x.\n",
                    SCpnt->pid, spp->target_status,
                    SCpnt->sense_buffer[2]);
 
-         HD(j)->target_to[SCpnt->device->id][SCpnt->device->channel] = 0;
+         HD(j)->target_to[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)] = 0;
 
          if (HD(j)->last_retried_pid == SCpnt->pid) HD(j)->retries = 0;
 
          break;
       case ASST:     /* Selection Time Out */
 
-         if (HD(j)->target_to[SCpnt->device->id][SCpnt->device->channel] > 1)
+         if (HD(j)->target_to[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)] > 1)
             status = DID_ERROR << 16;
          else {
             status = DID_TIME_OUT << 16;
-            HD(j)->target_to[SCpnt->device->id][SCpnt->device->channel]++;
+            HD(j)->target_to[sdev_id(SCpnt->device)][sdev_channel(SCpnt->device)]++;
             }
 
          break;
@@ -1914,10 +1913,9 @@ static irqreturn_t ihdlr(int irq, unsign
         spp->adapter_status != ASST && HD(j)->iocount <= 1000) ||
         do_trace || msg_byte(spp->target_status))
 #endif
-      printk("%s: ihdlr, mbox %2d, err 0x%x:%x,"\
-             " target %d.%d:%d, pid %ld, reg 0x%x, count %d.\n",
-             BN(j), i, spp->adapter_status, spp->target_status,
-             SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun, SCpnt->pid,
+      sdev_printk(KERN_INFO, SCpnt->device, "ihdlr, mbox %2d, err 0x%x:%x,"\
+             " pid %ld, reg 0x%x, count %d.\n",
+             i, spp->adapter_status, spp->target_status, SCpnt->pid,
              reg, HD(j)->iocount);
 
    unmap_dma(i, j);
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 486551b..eb1ed30 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -726,9 +726,9 @@ static int ultrastor_queuecommand(Scsi_C
 
        ???  Which other device types should never use the cache?   */
     my_mscp->ca = SCpnt->device->type != TYPE_TAPE;
-    my_mscp->target_id = SCpnt->device->id;
+    my_mscp->target_id = sdev_id(SCpnt->device);
     my_mscp->ch_no = 0;
-    my_mscp->lun = SCpnt->device->lun;
+    my_mscp->lun = scsilun_to_int(&SCpnt->device->lun);
     if (SCpnt->use_sg) {
 	/* Set scatter/gather flag in SCSI command packet */
 	my_mscp->sg = TRUE;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9e22d3b..986a59d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -268,6 +268,9 @@ extern int scsi_execute_req(struct scsi_
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
 
+#define sdev_printk(loglevel, scsidev, fmt, args...) \
+	dev_printk(loglevel, &(scsidev)->sdev_gendev, fmt, ## args)
+
 static inline unsigned int sdev_channel(struct scsi_device *sdev)
 {
 	return sdev->sdev_target->channel;
