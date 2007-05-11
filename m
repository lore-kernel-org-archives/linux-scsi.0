From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic boolean
Date: Fri, 11 May 2007 06:55:20 +0200 (MEST)
Message-ID: <20070511045300.4159.52660.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:64666 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXEKEzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 00:55:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with all(yes|mod|no)config on x86(|_64) & sparc(|64)
  got some warnings on some builds, none related to this patch
Diffed against Linus' git-tree.

 aic7xxx_old.c              |  326 ++++++++++++++++++++++-----------------------
 aic7xxx_old/aic7xxx_proc.c |    2
 2 files changed, 161 insertions(+), 167 deletions(-)


diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index a988d5a..afa5ded 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -255,12 +255,6 @@
 #define ALL_LUNS -1
 #define MAX_TARGETS  16
 #define MAX_LUNS     8
-#ifndef TRUE
-#  define TRUE 1
-#endif
-#ifndef FALSE
-#  define FALSE 0
-#endif
 
 #if defined(__powerpc__) || defined(__i386__) || defined(__x86_64__)
 #  define MMAPIO
@@ -1382,7 +1376,7 @@ aic7xxx_setup(char *s)
             char *tok, *tok_end, *tok_end2;
             char tok_list[] = { '.', ',', '{', '}', '\0' };
             int i, instance = -1, device = -1;
-            unsigned char done = FALSE;
+            bool done = false;
 
             base = p;
             tok = base + n + 1;  /* Forward us just past the ':' */
@@ -1410,14 +1404,14 @@ aic7xxx_setup(char *s)
                 case ',':
                 case '.':
                   if (instance == -1)
-                    done = TRUE;
+                    done = true;
                   else if (device >= 0)
                     device++;
                   else if (instance >= 0)
                     instance++;
                   if ( (device >= MAX_TARGETS) || 
                        (instance >= ARRAY_SIZE(aic7xxx_tag_info)) )
-                    done = TRUE;
+                    done = true;
                   tok++;
                   if (!done)
                   {
@@ -1425,10 +1419,10 @@ aic7xxx_setup(char *s)
                   }
                   break;
                 case '\0':
-                  done = TRUE;
+                  done = true;
                   break;
                 default:
-                  done = TRUE;
+                  done = true;
                   tok_end = strchr(tok, '\0');
                   for(i=0; tok_list[i]; i++)
                   {
@@ -1436,7 +1430,7 @@ aic7xxx_setup(char *s)
                     if ( (tok_end2) && (tok_end2 < tok_end) )
                     {
                       tok_end = tok_end2;
-                      done = FALSE;
+                      done = false;
                     }
                   }
                   if ( (instance >= 0) && (device >= 0) &&
@@ -1512,7 +1506,7 @@ pause_sequencer(struct aic7xxx_host *p)
  *   warrant an easy way to do it.
  *-F*************************************************************************/
 static void
-unpause_sequencer(struct aic7xxx_host *p, int unpause_always)
+unpause_sequencer(struct aic7xxx_host *p, bool unpause_always)
 {
   if (unpause_always ||
       ( !(aic_inb(p, INTSTAT) & (SCSIINT | SEQINT | BRKADRINT)) &&
@@ -1771,7 +1765,7 @@ aic7xxx_loadseq(struct aic7xxx_host *p)
   aic_outb(p, 0, SEQADDR0);
   aic_outb(p, 0, SEQADDR1);
   aic_outb(p, FASTMODE | FAILDIS, SEQCTL);
-  unpause_sequencer(p, TRUE);
+  unpause_sequencer(p, true);
   mdelay(1);
   pause_sequencer(p);
   aic_outb(p, FASTMODE, SEQCTL);
@@ -1820,7 +1814,7 @@ aic7xxx_print_sequencer(struct aic7xxx_host *p, int downloaded)
   aic_outb(p, 0, SEQADDR0);
   aic_outb(p, 0, SEQADDR1);
   aic_outb(p, FASTMODE | FAILDIS, SEQCTL);
-  unpause_sequencer(p, TRUE);
+  unpause_sequencer(p, true);
   mdelay(1);
   pause_sequencer(p);
   aic_outb(p, FASTMODE, SEQCTL);
@@ -1868,7 +1862,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
   unsigned int maxsync, unsigned char *options)
 {
   struct aic7xxx_syncrate *syncrate;
-  int done = FALSE;
+  bool done = false;
 
   switch(*options)
   {
@@ -1924,7 +1918,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
         case MSG_EXT_PPR_OPTION_DT_UNITS:
           if(!(syncrate->sxfr_ultra2 & AHC_SYNCRATE_CRC))
           {
-            done = TRUE;
+            done = true;
             /*
              * oops, we went too low for the CRC/DualEdge signalling, so
              * clear the options byte
@@ -1938,7 +1932,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
           }
           else
           {
-            done = TRUE;
+            done = true;
             if(syncrate == &aic7xxx_syncrates[maxsync])
             {
               *period = syncrate->period;
@@ -1948,7 +1942,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
         default:
           if(!(syncrate->sxfr_ultra2 & AHC_SYNCRATE_CRC))
           {
-            done = TRUE;
+            done = true;
             if(syncrate == &aic7xxx_syncrates[maxsync])
             {
               *period = syncrate->period;
@@ -2375,22 +2369,22 @@ scbq_insert_tail(volatile scb_queue_type *queue, struct aic7xxx_scb *scb)
  *   on the specified channel; this happens when a channel is going
  *   to be reset and all devices on that channel must be aborted.
  *-F*************************************************************************/
-static int
+static bool
 aic7xxx_match_scb(struct aic7xxx_host *p, struct aic7xxx_scb *scb,
     int target, int channel, int lun, unsigned char tag)
 {
   int targ = (scb->hscb->target_channel_lun >> 4) & 0x0F;
   int chan = (scb->hscb->target_channel_lun >> 3) & 0x01;
   int slun = scb->hscb->target_channel_lun & 0x07;
-  int match;
+  bool match;
 
-  match = ((chan == channel) || (channel == ALL_CHANNELS));
-  if (match != 0)
-    match = ((targ == target) || (target == ALL_TARGETS));
-  if (match != 0)
-    match = ((lun == slun) || (lun == ALL_LUNS));
-  if (match != 0)
-    match = ((tag == scb->hscb->tag) || (tag == SCB_LIST_NULL));
+  match = (chan == channel) || (channel == ALL_CHANNELS);
+  if (match)
+    match = (targ == target) || (target == ALL_TARGETS);
+  if (match)
+    match = (lun == slun) || (lun == ALL_LUNS);
+  if (match)
+    match = (tag == scb->hscb->tag) || (tag == SCB_LIST_NULL);
 
   return (match);
 }
@@ -2470,7 +2464,7 @@ aic7xxx_busy_target(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
  *-F*************************************************************************/
 static inline unsigned char
 aic7xxx_index_busy_target(struct aic7xxx_host *p, unsigned char tcl,
-    int unbusy)
+    bool unbusy)
 {
   unsigned char busy_scbid;
 
@@ -2720,7 +2714,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   if ((scb->flags & SCB_MSGOUT_BITS) != 0)
   {
     unsigned short mask;
-    int message_error = FALSE;
+    bool message_error = false;
 
     mask = 0x01 << tindex;
  
@@ -2732,7 +2726,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           ((scb->cmd->sense_buffer[12] == 0x43) ||  /* INVALID_MESSAGE */
           (scb->cmd->sense_buffer[12] == 0x49))) /* MESSAGE_ERROR  */
     {
-      message_error = TRUE;
+      message_error = true;
     }
 
     if (scb->flags & SCB_MSGOUT_WDTR)
@@ -2829,8 +2823,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   }
   if (!(scb->tag_action))
   {
-    aic7xxx_index_busy_target(p, scb->hscb->target_channel_lun,
-                              /* unbusy */ TRUE);
+    aic7xxx_index_busy_target(p, scb->hscb->target_channel_lun, true);
     if (cmd->device->simple_tags)
     {
       aic_dev->temp_q_depth = aic_dev->max_q_depth;
@@ -2890,10 +2883,10 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
  * Description:
  *   Calls the aic7xxx_done() for the scsi_cmnd of each scb in the
  *   aborted list, and adds each scb to the free list.  If complete
- *   is TRUE, we also process the commands complete list.
+ *   is 'true', we also process the commands complete list.
  *-F*************************************************************************/
 static void
-aic7xxx_run_done_queue(struct aic7xxx_host *p, /*complete*/ int complete)
+aic7xxx_run_done_queue(struct aic7xxx_host *p, bool complete)
 {
   struct aic7xxx_scb *scb;
   int i, found = 0;
@@ -2995,7 +2988,7 @@ aic7xxx_abort_waiting_scb(struct aic7xxx_host *p, struct aic7xxx_scb *scb,
  *-F*************************************************************************/
 static int
 aic7xxx_search_qinfifo(struct aic7xxx_host *p, int target, int channel,
-    int lun, unsigned char tag, int flags, int requeue,
+    int lun, unsigned char tag, int flags, bool requeue,
     volatile scb_queue_type *queue)
 {
   int      found;
@@ -3032,8 +3025,7 @@ aic7xxx_search_qinfifo(struct aic7xxx_host *p, int target, int channel,
          scbp->flags |= SCB_WAITINGQ;
          if ( !(scbp->tag_action & TAG_ENB) )
          {
-           aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun,
-             TRUE);
+           aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun, true);
          }
        }
        else if (requeue)
@@ -3048,11 +3040,10 @@ aic7xxx_search_qinfifo(struct aic7xxx_host *p, int target, int channel,
          * can find this scb
          */
          scbp->flags = flags | (scbp->flags & SCB_RECOVERY_SCB);
-         if (aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun,
-                                       FALSE) == scbp->hscb->tag)
+         if (aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun, false)
+              == scbp->hscb->tag)
          {
-           aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun,
-             TRUE);
+           aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun, true);
          }
        }
        found++;
@@ -3089,7 +3080,7 @@ aic7xxx_search_qinfifo(struct aic7xxx_host *p, int target, int channel,
  * Description:
  *   Is the scb that was passed to us currently on the qoutfifo?
  *-F*************************************************************************/
-static int
+static bool
 aic7xxx_scb_on_qoutfifo(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
 {
   int i=0;
@@ -3097,11 +3088,11 @@ aic7xxx_scb_on_qoutfifo(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   while(p->qoutfifo[(p->qoutfifonext + i) & 0xff ] != SCB_LIST_NULL)
   {
     if(p->qoutfifo[(p->qoutfifonext + i) & 0xff ] == scb->hscb->tag)
-      return TRUE;
+      return true;
     else
       i++;
   }
-  return FALSE;
+  return false;
 }
 
 
@@ -3127,7 +3118,8 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
   struct aic7xxx_scb *scbp, *prev_scbp;
   struct scsi_device *sd;
   unsigned char active_scb, tcl, scb_tag;
-  int i = 0, init_lists = FALSE;
+  int i = 0;
+  bool init_lists = false;
   struct aic_dev_data *aic_dev;
 
   /*
@@ -3181,9 +3173,9 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
       aic_dev->temp_q_depth = aic_dev->max_q_depth;
     }
     tcl = (sd->id << 4) | (sd->channel << 3) | sd->lun;
-    if ( (aic7xxx_index_busy_target(p, tcl, FALSE) == tag) ||
-         (tag == SCB_LIST_NULL) )
-      aic7xxx_index_busy_target(p, tcl, /* unbusy */ TRUE);
+    if ((aic7xxx_index_busy_target(p, tcl, false) == tag) ||
+        (tag == SCB_LIST_NULL) )
+      aic7xxx_index_busy_target(p, tcl, true);
     prev_scbp = NULL; 
     scbp = aic_dev->delayed_scbs.head;
     while (scbp != NULL)
@@ -3207,7 +3199,7 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
   if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
     printk(INFO_LEAD "Cleaning QINFIFO.\n", p->host_no, channel, target, lun );
   aic7xxx_search_qinfifo(p, target, channel, lun, tag,
-      SCB_RESET | SCB_QUEUED_FOR_DONE, /* requeue */ FALSE, NULL);
+      SCB_RESET | SCB_QUEUED_FOR_DONE, false, NULL);
 
 /*
  *  Search the waiting_scbs queue for matches, this catches any SCB_QUEUED
@@ -3365,7 +3357,7 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
       {
         printk(WARN_LEAD "Free list inconsistency!.\n", p->host_no, channel,
           target, lun);
-        init_lists = TRUE;
+        init_lists = true;
         next = SCB_LIST_NULL;
       }
       else
@@ -3518,7 +3510,7 @@ aic7xxx_reset_current_bus(struct aic7xxx_host *p)
  *   Reset the channel.
  *-F*************************************************************************/
 static void
-aic7xxx_reset_channel(struct aic7xxx_host *p, int channel, int initiate_reset)
+aic7xxx_reset_channel(struct aic7xxx_host *p, int channel, bool initiate_reset)
 {
   unsigned long offset_min, offset_max;
   unsigned char sblkctl;
@@ -3526,7 +3518,7 @@ aic7xxx_reset_channel(struct aic7xxx_host *p, int channel, int initiate_reset)
 
   if (aic7xxx_verbose & VERBOSE_RESET_PROCESS)
     printk(INFO_LEAD "Reset channel called, %s initiate reset.\n",
-      p->host_no, channel, -1, -1, (initiate_reset==TRUE) ? "will" : "won't" );
+      p->host_no, channel, -1, -1, initiate_reset ? "will" : "won't" );
 
 
   if (channel == 1)
@@ -3690,7 +3682,7 @@ aic7xxx_run_waiting_queues(struct aic7xxx_host *p)
     {
       pause_sequencer(p);
       aic_outb(p, p->qinfifonext, KERNEL_QINPOS);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
     }
     if (p->activescbs > p->max_activescbs)
       p->max_activescbs = p->activescbs;
@@ -3908,7 +3900,7 @@ aic7xxx_handle_device_reset(struct aic7xxx_host *p, int target, int channel)
   if (aic7xxx_verbose & VERBOSE_RESET_PROCESS)
     printk(INFO_LEAD "Bus Device Reset delivered.\n", p->host_no, channel,
       target, -1);
-  aic7xxx_run_done_queue(p, /*complete*/ TRUE);
+  aic7xxx_run_done_queue(p, true);
 }
 
 /*+F*************************************************************************
@@ -3925,7 +3917,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
   struct aic_dev_data *aic_dev;
   unsigned short target_mask;
   unsigned char target, lun, tindex;
-  unsigned char queue_flag = FALSE;
+  bool queue_flag = false;
   char channel;
   int result;
 
@@ -3983,8 +3975,8 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
             "LASTPHASE 0x%x, SAVED_TCL 0x%x\n", p->host_no, channel, target,
             lun, aic_inb(p, LASTPHASE), aic_inb(p, SAVED_TCL));
 
-        aic7xxx_reset_channel(p, channel, /*initiate reset*/ TRUE);
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_reset_channel(p, channel, true);
+        aic7xxx_run_done_queue(p, true);
 
       }
       break;
@@ -4111,7 +4103,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                 }
               }
             }
-            aic7xxx_run_done_queue(p, TRUE);
+            aic7xxx_run_done_queue(p, true);
             aic7xxx_verbose = old_verbose;
             /*
              * Wait until after the for loop to set the busy index since
@@ -4336,7 +4328,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
               break;
 
             case QUEUE_FULL:
-              queue_flag = TRUE;    /* Mark that this is a QUEUE_FULL and */
+              queue_flag = true;    /* Mark that this is a QUEUE_FULL and */
             case BUSY:              /* drop through to here */
             {
               struct aic7xxx_scb *next_scbp, *prev_scbp;
@@ -4370,7 +4362,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
               }
               aic7xxx_search_qinfifo(p, target, channel, lun,
                 SCB_LIST_NULL, SCB_QUEUED_FOR_DONE | SCB_QUEUE_FULL,
-	       	FALSE, NULL);
+                false, NULL);
               next_scbp = NULL;
               active_hscb = aic_inb(p, SCBPTR);
               prev_hscb = next_hscb = scb_index = SCB_LIST_NULL;
@@ -4415,7 +4407,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                 } /* scb_index >= p->scb_data->numscbs */
               }
               aic_outb(p, active_hscb, SCBPTR);
-	      aic7xxx_run_done_queue(p, FALSE);
+	      aic7xxx_run_done_queue(p, false);
                   
 #ifdef AIC7XXX_VERBOSE_DEBUGGING
               if( (aic7xxx_verbose & VERBOSE_MINOR_ERROR) ||
@@ -4902,7 +4894,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
   /*
    * Clear the sequencer interrupt and unpause the sequencer.
    */
-  unpause_sequencer(p, /* unpause always */ TRUE);
+  unpause_sequencer(p, true);
 }
 
 /*+F*************************************************************************
@@ -4913,10 +4905,10 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
  *   Parses incoming messages into actions on behalf of
  *   aic7xxx_handle_reqinit
  *_F*************************************************************************/
-static int
+static bool
 aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
 {
-  int reject, reply, done;
+  bool done, reject, reply;
   unsigned char target_scsirate, tindex;
   unsigned short target_mask;
   unsigned char target, channel, lun;
@@ -4929,7 +4921,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   target = scb->cmd->device->id;
   channel = scb->cmd->device->channel;
   lun = scb->cmd->device->lun;
-  reply = reject = done = FALSE;
+  reply = reject = done = false;
   tindex = TARGET_INDEX(scb->cmd);
   aic_dev = AIC_DEV(scb->cmd);
   target_scsirate = aic_inb(p, TARG_SCSIRATE + tindex);
@@ -4939,13 +4931,13 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
    * Parse as much of the message as is available,
    * rejecting it if we don't support it.  When
    * the entire message is available and has been
-   * handled, return TRUE indicating that we have
+   * handled, return 'true' indicating that we have
    * parsed an entire message.
    */
 
   if (p->msg_buf[0] != MSG_EXTENDED)
   {
-    reject = TRUE;
+    reject = true;
   }
 
   /*
@@ -4982,7 +4974,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
    * more checking once we know the message type.
    */
 
-  if ( !reject && (p->msg_len > 2) )
+  if (!reject && (p->msg_len > 2))
   {
     switch(p->msg_buf[2])
     {
@@ -4991,7 +4983,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
         
         if (p->msg_buf[1] != MSG_EXT_SDTR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5059,12 +5051,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
              * don't need a SDTR with this target (for whatever reason),
              * so reject this incoming SDTR
              */
-            reject = TRUE;
+            reject = true;
             break;
           }
 
           /* The device is sending this message first and we have to reply */
-          reply = TRUE;
+          reply = true;
           
           if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
           {
@@ -5096,14 +5088,14 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
         if ((new_offset == 0) && (new_offset != offset))
         {
           aic_dev->needsdtr_copy = 0;
-          reply = TRUE;
+          reply = true;
         }
         
         /*
          * Did we start this, if not, or if we went too low and had to
          * go async, then send an SDTR back to the target
          */
-        if(reply)
+        if (reply)
         {
           /* when sending a reply, make sure that the goal settings are
            * updated along with current and active since the code that
@@ -5126,7 +5118,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                                AHC_TRANS_ACTIVE|AHC_TRANS_CUR, aic_dev);
           aic_dev->needsdtr = 0;
         }
-        done = TRUE;
+        done = true;
         break;
       }
       case MSG_EXT_WDTR:
@@ -5134,7 +5126,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           
         if (p->msg_buf[1] != MSG_EXT_WDTR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5152,7 +5144,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           {
             default:
             {
-              reject = TRUE;
+              reject = true;
               if ( (aic7xxx_verbose & VERBOSE_NEGOTIATION2) &&
                    ((aic_dev->flags & DEVICE_PRINT_DTR) ||
                     (aic7xxx_verbose > 0xffff)) )
@@ -5228,12 +5220,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
              * don't need a WDTR with this target (for whatever reason),
              * so reject this incoming WDTR
              */
-            reject = TRUE;
+            reject = true;
             break;
           }
 
           /* The device is sending this message first and we have to reply */
-          reply = TRUE;
+          reply = true;
 
           if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
           {
@@ -5294,7 +5286,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                              AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE,
 			     aic_dev);
         aic_dev->needsdtr = aic_dev->needsdtr_copy;
-        done = TRUE;
+        done = true;
         break;
       }
       case MSG_EXT_PPR:
@@ -5302,7 +5294,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
         
         if (p->msg_buf[1] != MSG_EXT_PPR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5388,12 +5380,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
              * don't need a PPR with this target (for whatever reason),
              * so reject this incoming PPR
              */
-            reject = TRUE;
+            reject = true;
             break;
           }
 
           /* The device is sending this message first and we have to reply */
-          reply = TRUE;
+          reply = true;
           
           if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
           {
@@ -5419,7 +5411,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                  ((aic_dev->flags & DEVICE_PRINT_DTR) ||
                   (aic7xxx_verbose > 0xffff)) )
             {
-              reply = TRUE;
+              reply = true;
               printk(INFO_LEAD "Requesting %d bit transfers, rejecting.\n",
                 p->host_no, CTL_OF_SCB(scb), 8 * (0x01 << bus_width));
             }
@@ -5436,7 +5428,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           }
         }
 
-        if(reply)
+        if (reply)
         {
           /* when sending a reply, make sure that the goal settings are
            * updated along with current and active since the code that
@@ -5493,10 +5485,10 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
            * to async (should never happen with a device that uses PPR
            * messages, but have to be complete)
            */
-          reply = TRUE;
+          reply = true;
         }
 
-        if(reply)
+        if (reply)
         {
           scb->flags &= ~SCB_MSGOUT_BITS;
           scb->flags |= SCB_MSGOUT_PPR;
@@ -5507,12 +5499,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
         {
           aic_dev->needppr = 0;
         }
-        done = TRUE;
+        done = true;
         break;
       }
       default:
       {
-        reject = TRUE;
+        reject = true;
         break;
       }
     } /* end of switch(p->msg_type) */
@@ -5522,9 +5514,9 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   {
     aic_outb(p, MSG_MESSAGE_REJECT, MSG_OUT);
     aic_outb(p, aic_inb(p, SCSISIGO) | ATNO, SCSISIGO);
-    done = TRUE;
+    done = true;
   }
-  return(done);
+  return done;
 }
 
 
@@ -5541,7 +5533,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
 {
   unsigned char lastbyte;
   unsigned char phasemis;
-  int done = FALSE;
+  bool done = false;
 
   switch(p->msg_type)
   {
@@ -5586,7 +5578,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                      p->host_no, CTL_OF_SCB(scb));
 #endif
           }
-          unpause_sequencer(p, TRUE);
+          unpause_sequencer(p, true);
         }
         else
         {
@@ -5635,7 +5627,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           aic_outb(p, aic_inb(p, SIMODE1) & ~ENREQINIT, SIMODE1);
           aic_outb(p, CLRSCSIINT, CLRINT);
           p->flags &= ~AHC_HANDLING_REQINITS;
-          unpause_sequencer(p, TRUE);
+          unpause_sequencer(p, true);
         }
         break;
       }
@@ -5697,8 +5689,8 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
      * Go through and abort all commands for the channel, but do not
      * reset the channel again.
      */
-    aic7xxx_reset_channel(p, channel, /* Initiate Reset */ FALSE);
-    aic7xxx_run_done_queue(p, TRUE);
+    aic7xxx_reset_channel(p, channel, false);
+    aic7xxx_run_done_queue(p, true);
     scb = NULL;
   }
   else if ( ((status & BUSFREE) != 0) && ((status & SELTO) == 0) )
@@ -5712,7 +5704,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
     unsigned char saved_tcl = aic_inb(p, SAVED_TCL);
     unsigned char target = (saved_tcl >> 4) & 0x0F;
     int channel;
-    int printerror = TRUE;
+    bool printerror = true;
 
     if ( (p->chip & AHC_CHIPID_MASK) == AHC_AIC7770 )
       channel = (aic_inb(p, SBLKCTL) & SELBUSB) >> 3;
@@ -5734,15 +5726,15 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
             CTL_OF_SCB(scb), scb->hscb->tag);
         aic7xxx_reset_device(p, target, channel, ALL_LUNS,
                 (message == MSG_ABORT) ? SCB_LIST_NULL : scb->hscb->tag );
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_run_done_queue(p, true);
         scb = NULL;
-        printerror = 0;
+        printerror = false;
       }
       else if (message == MSG_BUS_DEV_RESET)
       {
         aic7xxx_handle_device_reset(p, target, channel);
         scb = NULL;
-        printerror = 0;
+        printerror = false;
       }
     }
     if ( (scb != NULL) && (scb->flags & SCB_DTR_SCB) ) 
@@ -5754,12 +5746,12 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
        * negotiation messages, assume the bus is borken for whatever
        * reason.  Complete the command.
        */
-      printerror = 0;
+      printerror = false;
       aic7xxx_reset_device(p, target, channel, ALL_LUNS, scb->hscb->tag);
-      aic7xxx_run_done_queue(p, TRUE);
+      aic7xxx_run_done_queue(p, true);
       scb = NULL;
     }
-    if (printerror != 0)
+    if (printerror)
     {
       if (scb != NULL)
       {
@@ -5774,12 +5766,12 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
           tag = SCB_LIST_NULL;
         }
         aic7xxx_reset_device(p, target, channel, ALL_LUNS, tag);
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_run_done_queue(p, true);
       }
       else
       {
         aic7xxx_reset_device(p, target, channel, ALL_LUNS, SCB_LIST_NULL);
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_run_done_queue(p, true);
       }
       printk(INFO_LEAD "Unexpected busfree, LASTPHASE = 0x%x, "
              "SEQADDR = 0x%x\n", p->host_no, channel, target, -1, lastphase,
@@ -5793,7 +5785,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
     aic_outb(p, CLRBUSFREE, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
     restart_sequencer(p);
-    unpause_sequencer(p, TRUE);
+    unpause_sequencer(p, true);
   }
   else if ((status & SELTO) != 0)
   {
@@ -5914,7 +5906,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
      * are allowed to reselect in.
      */
     restart_sequencer(p);
-    unpause_sequencer(p, TRUE);
+    unpause_sequencer(p, true);
   }
   else if (scb == NULL)
   {
@@ -5930,7 +5922,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
      */
     aic_outb(p, status, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause always */ TRUE);
+    unpause_sequencer(p, true);
     scb = NULL;
   }
   else if (status & SCSIPERR)
@@ -6060,7 +6052,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
     }
     aic_outb(p, CLRSCSIPERR, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause_always */ TRUE);
+    unpause_sequencer(p, true);
   }
   else if ( (status & REQINIT) &&
             (p->flags & AHC_HANDLING_REQINITS) )
@@ -6084,7 +6076,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
         p->host_no, -1, -1, -1, status);
     aic_outb(p, status, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause always */ TRUE);
+    unpause_sequencer(p, true);
     scb = NULL;
   }
   if (scb != NULL)
@@ -6098,7 +6090,8 @@ static void
 aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
 {
   unsigned char saved_scbptr, free_scbh, dis_scbh, wait_scbh, temp;
-  int i, bogus, lost;
+  int i, lost;
+  bool bogus;
   static unsigned char scb_status[AIC7XXX_MAXSCB];
 
 #define SCB_NO_LIST 0
@@ -6116,14 +6109,14 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
    * only partially linked in.  Therefore, once we pass the scan phase
    * of the bus, we really should disable this function.
    */
-  bogus = FALSE;
+  bogus = false;
   memset(&scb_status[0], 0, sizeof(scb_status));
   pause_sequencer(p);
   saved_scbptr = aic_inb(p, SCBPTR);
   if (saved_scbptr >= p->scb_data->maxhscbs)
   {
     printk("Bogus SCBPTR %d\n", saved_scbptr);
-    bogus = TRUE;
+    bogus = true;
   }
   scb_status[saved_scbptr] = SCB_CURRENTLY_ACTIVE;
   free_scbh = aic_inb(p, FREE_SCBH);
@@ -6131,7 +6124,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
        (free_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus FREE_SCBH %d\n", free_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6142,7 +6135,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_FREE_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_FREE_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6155,7 +6148,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
        (dis_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus DISCONNECTED_SCBH %d\n", dis_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6166,7 +6159,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_DISCONNECTED_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_DISCONNECTED_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6179,7 +6172,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
        (wait_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus WAITING_SCBH %d\n", wait_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6190,7 +6183,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_WAITING_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_WAITING_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6207,23 +6200,23 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
           (temp >= p->scb_data->maxhscbs)) )
     {
       printk("HSCB %d bad, SCB_NEXT invalid(%d).\n", i, temp);
-      bogus = TRUE;
+      bogus = true;
     }
     if ( temp == i )
     {
       printk("HSCB %d bad, SCB_NEXT points to self.\n", i);
-      bogus = TRUE;
+      bogus = true;
     }
     if (scb_status[i] == 0)
       lost++;
     if (lost > 1)
     {
       printk("Too many lost scbs.\n");
-      bogus=TRUE;
+      bogus = true;
     }
   }
   aic_outb(p, saved_scbptr, SCBPTR);
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   if (bogus)
   {
     printk("Bogus parameters found in card SCB array structures.\n");
@@ -6295,14 +6288,14 @@ aic7xxx_handle_command_completion_intr(struct aic7xxx_host *p)
       if ( ((aic_inb(p, LASTPHASE) & PHASE_MASK) != P_BUSFREE) &&
            (aic_inb(p, SCB_TAG) == scb->hscb->tag) )
       {
-        unpause_sequencer(p, FALSE);
+        unpause_sequencer(p, false);
         continue;
       }
       aic7xxx_reset_device(p, scb->cmd->device->id, scb->cmd->device->channel,
         scb->cmd->device->lun, scb->hscb->tag);
       scb->flags &= ~(SCB_QUEUED_FOR_DONE | SCB_RESET | SCB_ABORT |
         SCB_QUEUED_ABORT);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
     }
     else if (scb->flags & SCB_ABORT)
     {
@@ -6438,7 +6431,7 @@ aic7xxx_isr(void *dev_id)
     }
 #endif
     aic_outb(p, CLRPARERR | CLRBRKADRINT, CLRINT);
-    unpause_sequencer(p, FALSE);
+    unpause_sequencer(p, false);
   }
 
   if (intstat & SEQINT)
@@ -6530,7 +6523,7 @@ aic7xxx_init_transinfo(struct aic7xxx_host *p, struct aic_dev_data *aic_dev)
                         MSG_EXT_WDTR_BUS_8_BIT, (AHC_TRANS_ACTIVE |
                                                  AHC_TRANS_GOAL |
                                                  AHC_TRANS_CUR), aic_dev );
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
     }
     if ( sdpnt->sdtr && p->user[tindex].offset )
     {
@@ -6641,7 +6634,7 @@ aic7xxx_slave_alloc(struct scsi_device *SDptr)
 static void
 aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 {
-  int tag_enabled = FALSE;
+  bool tag_enabled = false;
   struct aic_dev_data *aic_dev = device->hostdata;
   unsigned char tindex;
 
@@ -6652,7 +6645,7 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 
   if (device->tagged_supported)
   {
-    tag_enabled = TRUE;
+    tag_enabled = true;
 
     if (!(p->discenable & (1 << tindex)))
     {
@@ -6660,20 +6653,20 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
         printk(INFO_LEAD "Disconnection disabled, unable to "
              "enable tagged queueing.\n",
              p->host_no, device->channel, device->id, device->lun);
-      tag_enabled = FALSE;
+      tag_enabled = false;
     }
     else
     {
       if (p->instance >= ARRAY_SIZE(aic7xxx_tag_info))
       {
-        static int print_warning = TRUE;
-        if(print_warning)
+        static bool print_warning = true;
+        if (print_warning)
         {
           printk(KERN_INFO "aic7xxx: WARNING, insufficient tag_info instances for"
                            " installed controllers.\n");
           printk(KERN_INFO "aic7xxx: Please update the aic7xxx_tag_info array in"
                            " the aic7xxx.c source file.\n");
-          print_warning = FALSE;
+          print_warning = false;
         }
         aic_dev->max_q_depth = aic_dev->temp_q_depth =
 		aic7xxx_default_queue_depth;
@@ -6683,7 +6676,7 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 
         if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 255)
         {
-          tag_enabled = FALSE;
+          tag_enabled = false;
         }
         else if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 0)
         {
@@ -6819,16 +6812,16 @@ aic7xxx_probe(int slot, int base, ahc_flag_type *flags)
     int n;
     unsigned char signature[sizeof(buf)];
     ahc_chip type;
-    int bios_disabled;
+    bool bios_disabled;
   } AIC7xxx[] = {
     { 4, { 0x04, 0x90, 0x77, 0x70 },
-      AHC_AIC7770|AHC_EISA, FALSE },  /* mb 7770  */
+      AHC_AIC7770|AHC_EISA, false },  /* mb 7770  */
     { 4, { 0x04, 0x90, 0x77, 0x71 },
-      AHC_AIC7770|AHC_EISA, FALSE }, /* host adapter 274x */
+      AHC_AIC7770|AHC_EISA, false }, /* host adapter 274x */
     { 4, { 0x04, 0x90, 0x77, 0x56 },
-      AHC_AIC7770|AHC_VL, FALSE }, /* 284x BIOS enabled */
+      AHC_AIC7770|AHC_VL, false }, /* 284x BIOS enabled */
     { 4, { 0x04, 0x90, 0x77, 0x57 },
-      AHC_AIC7770|AHC_VL, TRUE }   /* 284x BIOS disabled */
+      AHC_AIC7770|AHC_VL, true }   /* 284x BIOS disabled */
   };
 
   /*
@@ -8339,7 +8332,7 @@ aic7xxx_register(struct scsi_host_template *template, struct aic7xxx_host *p,
       p->host_no, -1, -1 , -1);
   aic7xxx_clear_intstat(p);
 
-  unpause_sequencer(p, /* unpause_always */ TRUE);
+  unpause_sequencer(p, true);
 
   return (found);
 }
@@ -10108,7 +10101,7 @@ skip_pci_controller:
               pause_sequencer(p);
               aic7xxx_print_card(p);
               aic7xxx_print_scratch_ram(p);
-              unpause_sequencer(p, TRUE);
+              unpause_sequencer(p, true);
             }
           }
           current_p = temp_p;
@@ -10359,7 +10352,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
   int channel;
   unsigned char saved_scbptr, lastphase;
   unsigned char hscb_index;
-  int disconnected;
+  bool disconnected;
   struct aic_dev_data *aic_dev;
 
   if(cmd == NULL)
@@ -10444,7 +10437,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
      * attempt a bus reset.
      */
   saved_scbptr = aic_inb(p, SCBPTR);
-  disconnected = FALSE;
+  disconnected = false;
 
   if (lastphase != P_BUSFREE)
   {
@@ -10453,7 +10446,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
       printk(WARN_LEAD "Invalid SCB ID %d is active, "
              "SCB flags = 0x%x.\n", p->host_no,
             CTL_OF_CMD(cmd), scb->hscb->tag, scb->flags);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
       return FAILED;
     }
     if (scb->hscb->tag == aic_inb(p, SCB_TAG))
@@ -10462,7 +10455,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
       {
         printk(WARN_LEAD "Device reset, Message buffer "
                 "in use\n", p->host_no, CTL_OF_SCB(scb));
-        unpause_sequencer(p, FALSE);
+        unpause_sequencer(p, false);
 	return FAILED;
       }
 	
@@ -10475,7 +10468,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
       /* Send the abort message to the active SCB. */
       aic_outb(p, HOST_MSG, MSG_OUT);
       aic_outb(p, lastphase | ATNO, SCSISIGO);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
       spin_unlock_irq(p->host->host_lock);
       ssleep(1);
       spin_lock_irq(p->host->host_lock);
@@ -10497,9 +10490,9 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
    * not need to queue the command again since the card should start it soon
    */
   if (aic7xxx_search_qinfifo(p, cmd->device->channel, cmd->device->id, cmd->device->lun, hscb->tag,
-			  0, TRUE, NULL) == 0)
+			  0, true, NULL) == 0)
   {
-    disconnected = TRUE;
+    disconnected = true;
     if ((hscb_index = aic7xxx_find_scb(p, scb)) != SCB_LIST_NULL)
     {
       unsigned char scb_control;
@@ -10511,7 +10504,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
        * actually on the waiting list, not disconnected, and we don't
        * need to requeue the command.
        */
-      disconnected = (scb_control & DISCONNECTED);
+      disconnected = (scb_control & DISCONNECTED) != 0;
       aic_outb(p, scb_control | MK_MESSAGE, SCB_CONTROL);
     }
     if (disconnected)
@@ -10534,7 +10527,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
     }
   }
   aic_outb(p, saved_scbptr, SCBPTR);
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   spin_unlock_irq(p->host->host_lock);
   msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
@@ -10591,7 +10584,8 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
 {
   struct aic7xxx_scb  *scb = NULL;
   struct aic7xxx_host *p;
-  int    found=0, disconnected;
+  int    found=0;
+  bool   disconnected;
   unsigned char saved_hscbptr, hscbptr, scb_control;
   struct aic_dev_data *aic_dev;
 
@@ -10662,7 +10656,7 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
  */
   if ( ((found = aic7xxx_search_qinfifo(p, cmd->device->id, cmd->device->channel,
                      cmd->device->lun, scb->hscb->tag, SCB_ABORT | SCB_QUEUED_FOR_DONE,
-                     FALSE, NULL)) != 0) &&
+                     false, NULL)) != 0) &&
                     (aic7xxx_verbose & VERBOSE_ABORT_PROCESS))
   {
     printk(INFO_LEAD "SCB found in QINFIFO and aborted.\n", p->host_no,
@@ -10679,12 +10673,12 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
   {
     aic_outb(p, hscbptr, SCBPTR);
     scb_control = aic_inb(p, SCB_CONTROL);
-    disconnected = scb_control & DISCONNECTED;
+    disconnected = (scb_control & DISCONNECTED) != 0;
     /*
      * If the DISCONNECTED bit is not set in SCB_CONTROL, then we are
      * either currently active or on the waiting list.
      */
-    if(!disconnected && aic_inb(p, LASTPHASE) == P_BUSFREE) {
+    if (!disconnected && aic_inb(p, LASTPHASE) == P_BUSFREE) {
       if (aic7xxx_verbose & VERBOSE_ABORT_PROCESS)
         printk(INFO_LEAD "SCB found on hardware waiting"
           " list and aborted.\n", p->host_no, CTL_OF_SCB(scb));
@@ -10743,13 +10737,13 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
 	 */
 	printk(INFO_LEAD "message buffer busy, unable to abort.\n",
 			  p->host_no, CTL_OF_SCB(scb));
-	unpause_sequencer(p, FALSE);
+	unpause_sequencer(p, false);
 	return FAILED;
       }
       /* Fallthrough to below, set ATNO after we set SCB_CONTROL */
     } 
     aic_outb(p,  scb_control | MK_MESSAGE, SCB_CONTROL);
-    if(!disconnected)
+    if (!disconnected)
     {
       aic_outb(p, HOST_MSG, MSG_OUT);
       aic_outb(p, aic_inb(p, SCSISIGI) | ATNO, SCSISIGO);
@@ -10763,13 +10757,13 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
      * any of the queues, so it must be disconnected and paged out.  Fall
      * through to the code below.
      */
-    disconnected = 1;
+    disconnected = true;
   }
         
   p->flags |= AHC_ABORT_PENDING;
   scb->flags |= SCB_QUEUED_ABORT | SCB_ABORT | SCB_RECOVERY_SCB;
   scb->hscb->control |= MK_MESSAGE;
-  if(disconnected)
+  if (disconnected)
   {
     if (aic7xxx_verbose & VERBOSE_ABORT_PROCESS)
       printk(INFO_LEAD "SCB disconnected.  Queueing Abort"
@@ -10780,7 +10774,7 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
     else
       aic_outb(p, p->qinfifonext, KERNEL_QINPOS);
   }
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   spin_unlock_irq(p->host->host_lock);
   msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
@@ -10799,8 +10793,8 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
 success:
   if (aic7xxx_verbose & VERBOSE_ABORT_RETURN)
     printk(INFO_LEAD "Abort successful.\n", p->host_no, CTL_OF_CMD(cmd));
-  aic7xxx_run_done_queue(p, TRUE);
-  unpause_sequencer(p, FALSE);
+  aic7xxx_run_done_queue(p, true);
+  unpause_sequencer(p, false);
   return SUCCESS;
 }
 
@@ -10873,7 +10867,7 @@ static int aic7xxx_reset(struct scsi_cmnd *cmd)
      * We just completed the command when we ran the isr stuff, so we no
      * longer have it.
      */
-    unpause_sequencer(p, FALSE);
+    unpause_sequencer(p, false);
     spin_unlock_irq(p->host->host_lock);
     return SUCCESS;
   }
@@ -10882,10 +10876,10 @@ static int aic7xxx_reset(struct scsi_cmnd *cmd)
  *  By this point, we want to already know what we are going to do and
  *  only have the following code implement our course of action.
  */
-  aic7xxx_reset_channel(p, cmd->device->channel, TRUE);
+  aic7xxx_reset_channel(p, cmd->device->channel, true);
   if (p->features & AHC_TWIN)
   {
-    aic7xxx_reset_channel(p, cmd->device->channel ^ 0x01, TRUE);
+    aic7xxx_reset_channel(p, cmd->device->channel ^ 0x01, true);
     restart_sequencer(p);
   }
   aic_outb(p,  aic_inb(p, SIMODE1) & ~(ENREQINIT|ENBUSFREE), SIMODE1);
@@ -10894,8 +10888,8 @@ static int aic7xxx_reset(struct scsi_cmnd *cmd)
   p->msg_type = MSG_TYPE_NONE;
   p->msg_index = 0;
   p->msg_len = 0;
-  aic7xxx_run_done_queue(p, TRUE);
-  unpause_sequencer(p, FALSE);
+  aic7xxx_run_done_queue(p, true);
+  unpause_sequencer(p, false);
   spin_unlock_irq(p->host->host_lock);
   ssleep(2);
   return SUCCESS;
diff --git a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
index b07e4f0..109076e 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
@@ -105,7 +105,7 @@ aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t
     }
   }
 
-  if (inout == TRUE) /* Has data been written to the file? */ 
+  if (inout == 1) /* Has data been written to the file? */
   {
     return (aic7xxx_set_info(buffer, length, HBAptr));
   }
