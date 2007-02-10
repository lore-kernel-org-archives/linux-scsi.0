From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic boolean-values
Date: Sat, 10 Feb 2007 18:46:29 +0100 (MET)
Message-ID: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751682AbXBJRqh@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
List-Id: linux-scsi@vger.kernel.org

Convert:
FALSE -> false
TRUE  -> true

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386
Whitespace cleaning on affected lines

 drivers/scsi/aic7xxx_old.c              |  242 +++++++++++++++-----------------
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    2 
 2 files changed, 119 insertions(+), 125 deletions(-)


diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 7d1fec6..92e32ee 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -256,12 +256,6 @@
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
@@ -1383,7 +1377,7 @@ aic7xxx_setup(char *s)
             char *tok, *tok_end, *tok_end2;
             char tok_list[] = { '.', ',', '{', '}', '\0' };
             int i, instance = -1, device = -1;
-            unsigned char done = FALSE;
+            unsigned char done = false;
 
             base = p;
             tok = base + n + 1;  /* Forward us just past the ':' */
@@ -1411,14 +1405,14 @@ aic7xxx_setup(char *s)
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
@@ -1426,10 +1420,10 @@ aic7xxx_setup(char *s)
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
@@ -1437,7 +1431,7 @@ aic7xxx_setup(char *s)
                     if ( (tok_end2) && (tok_end2 < tok_end) )
                     {
                       tok_end = tok_end2;
-                      done = FALSE;
+                      done = false;
                     }
                   }
                   if ( (instance >= 0) && (device >= 0) &&
@@ -1772,7 +1766,7 @@ aic7xxx_loadseq(struct aic7xxx_host *p)
   aic_outb(p, 0, SEQADDR0);
   aic_outb(p, 0, SEQADDR1);
   aic_outb(p, FASTMODE | FAILDIS, SEQCTL);
-  unpause_sequencer(p, TRUE);
+  unpause_sequencer(p, true);
   mdelay(1);
   pause_sequencer(p);
   aic_outb(p, FASTMODE, SEQCTL);
@@ -1821,7 +1815,7 @@ aic7xxx_print_sequencer(struct aic7xxx_host *p, int downloaded)
   aic_outb(p, 0, SEQADDR0);
   aic_outb(p, 0, SEQADDR1);
   aic_outb(p, FASTMODE | FAILDIS, SEQCTL);
-  unpause_sequencer(p, TRUE);
+  unpause_sequencer(p, true);
   mdelay(1);
   pause_sequencer(p);
   aic_outb(p, FASTMODE, SEQCTL);
@@ -1869,7 +1863,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
   unsigned int maxsync, unsigned char *options)
 {
   struct aic7xxx_syncrate *syncrate;
-  int done = FALSE;
+  int done = false;
 
   switch(*options)
   {
@@ -1925,7 +1919,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
         case MSG_EXT_PPR_OPTION_DT_UNITS:
           if(!(syncrate->sxfr_ultra2 & AHC_SYNCRATE_CRC))
           {
-            done = TRUE;
+            done = true;
             /*
              * oops, we went too low for the CRC/DualEdge signalling, so
              * clear the options byte
@@ -1939,7 +1933,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
           }
           else
           {
-            done = TRUE;
+            done = true;
             if(syncrate == &aic7xxx_syncrates[maxsync])
             {
               *period = syncrate->period;
@@ -1949,7 +1943,7 @@ aic7xxx_find_syncrate(struct aic7xxx_host *p, unsigned int *period,
         default:
           if(!(syncrate->sxfr_ultra2 & AHC_SYNCRATE_CRC))
           {
-            done = TRUE;
+            done = true;
             if(syncrate == &aic7xxx_syncrates[maxsync])
             {
               *period = syncrate->period;
@@ -2721,7 +2715,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   if ((scb->flags & SCB_MSGOUT_BITS) != 0)
   {
     unsigned short mask;
-    int message_error = FALSE;
+    int message_error = false;
 
     mask = 0x01 << tindex;
  
@@ -2733,7 +2727,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           ((scb->cmd->sense_buffer[12] == 0x43) ||  /* INVALID_MESSAGE */
           (scb->cmd->sense_buffer[12] == 0x49))) /* MESSAGE_ERROR  */
     {
-      message_error = TRUE;
+      message_error = true;
     }
 
     if (scb->flags & SCB_MSGOUT_WDTR)
@@ -2831,7 +2825,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   if (!(scb->tag_action))
   {
     aic7xxx_index_busy_target(p, scb->hscb->target_channel_lun,
-                              /* unbusy */ TRUE);
+                              /* unbusy */ true);
     if (cmd->device->simple_tags)
     {
       aic_dev->temp_q_depth = aic_dev->max_q_depth;
@@ -2891,7 +2885,7 @@ aic7xxx_done(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
  * Description:
  *   Calls the aic7xxx_done() for the scsi_cmnd of each scb in the
  *   aborted list, and adds each scb to the free list.  If complete
- *   is TRUE, we also process the commands complete list.
+ *   is 'true', we also process the commands complete list.
  *-F*************************************************************************/
 static void
 aic7xxx_run_done_queue(struct aic7xxx_host *p, /*complete*/ int complete)
@@ -3034,7 +3028,7 @@ aic7xxx_search_qinfifo(struct aic7xxx_host *p, int target, int channel,
          if ( !(scbp->tag_action & TAG_ENB) )
          {
            aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun,
-             TRUE);
+             true);
          }
        }
        else if (requeue)
@@ -3050,10 +3044,10 @@ aic7xxx_search_qinfifo(struct aic7xxx_host *p, int target, int channel,
          */
          scbp->flags = flags | (scbp->flags & SCB_RECOVERY_SCB);
          if (aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun,
-                                       FALSE) == scbp->hscb->tag)
+                                       false) == scbp->hscb->tag)
          {
            aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun,
-             TRUE);
+             true);
          }
        }
        found++;
@@ -3098,11 +3092,11 @@ aic7xxx_scb_on_qoutfifo(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
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
 
 
@@ -3128,7 +3122,7 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
   struct aic7xxx_scb *scbp, *prev_scbp;
   struct scsi_device *sd;
   unsigned char active_scb, tcl, scb_tag;
-  int i = 0, init_lists = FALSE;
+  int i = 0, init_lists = false;
   struct aic_dev_data *aic_dev;
 
   /*
@@ -3182,9 +3176,9 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
       aic_dev->temp_q_depth = aic_dev->max_q_depth;
     }
     tcl = (sd->id << 4) | (sd->channel << 3) | sd->lun;
-    if ( (aic7xxx_index_busy_target(p, tcl, FALSE) == tag) ||
+    if ( (aic7xxx_index_busy_target(p, tcl, false) == tag) ||
          (tag == SCB_LIST_NULL) )
-      aic7xxx_index_busy_target(p, tcl, /* unbusy */ TRUE);
+      aic7xxx_index_busy_target(p, tcl, /* unbusy */ true);
     prev_scbp = NULL; 
     scbp = aic_dev->delayed_scbs.head;
     while (scbp != NULL)
@@ -3208,7 +3202,7 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
   if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
     printk(INFO_LEAD "Cleaning QINFIFO.\n", p->host_no, channel, target, lun );
   aic7xxx_search_qinfifo(p, target, channel, lun, tag,
-      SCB_RESET | SCB_QUEUED_FOR_DONE, /* requeue */ FALSE, NULL);
+      SCB_RESET | SCB_QUEUED_FOR_DONE, /* requeue */ false, NULL);
 
 /*
  *  Search the waiting_scbs queue for matches, this catches any SCB_QUEUED
@@ -3366,7 +3360,7 @@ aic7xxx_reset_device(struct aic7xxx_host *p, int target, int channel,
       {
         printk(WARN_LEAD "Free list inconsistency!.\n", p->host_no, channel,
           target, lun);
-        init_lists = TRUE;
+        init_lists = true;
         next = SCB_LIST_NULL;
       }
       else
@@ -3527,7 +3521,7 @@ aic7xxx_reset_channel(struct aic7xxx_host *p, int channel, int initiate_reset)
 
   if (aic7xxx_verbose & VERBOSE_RESET_PROCESS)
     printk(INFO_LEAD "Reset channel called, %s initiate reset.\n",
-      p->host_no, channel, -1, -1, (initiate_reset==TRUE) ? "will" : "won't" );
+      p->host_no, channel, -1, -1, initiate_reset ? "will" : "won't" );
 
 
   if (channel == 1)
@@ -3691,7 +3685,7 @@ aic7xxx_run_waiting_queues(struct aic7xxx_host *p)
     {
       pause_sequencer(p);
       aic_outb(p, p->qinfifonext, KERNEL_QINPOS);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
     }
     if (p->activescbs > p->max_activescbs)
       p->max_activescbs = p->activescbs;
@@ -3909,7 +3903,7 @@ aic7xxx_handle_device_reset(struct aic7xxx_host *p, int target, int channel)
   if (aic7xxx_verbose & VERBOSE_RESET_PROCESS)
     printk(INFO_LEAD "Bus Device Reset delivered.\n", p->host_no, channel,
       target, -1);
-  aic7xxx_run_done_queue(p, /*complete*/ TRUE);
+  aic7xxx_run_done_queue(p, /*complete*/ true);
 }
 
 /*+F*************************************************************************
@@ -3926,7 +3920,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
   struct aic_dev_data *aic_dev;
   unsigned short target_mask;
   unsigned char target, lun, tindex;
-  unsigned char queue_flag = FALSE;
+  unsigned char queue_flag = false;
   char channel;
   int result;
 
@@ -3984,8 +3978,8 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
             "LASTPHASE 0x%x, SAVED_TCL 0x%x\n", p->host_no, channel, target,
             lun, aic_inb(p, LASTPHASE), aic_inb(p, SAVED_TCL));
 
-        aic7xxx_reset_channel(p, channel, /*initiate reset*/ TRUE);
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_reset_channel(p, channel, /*initiate reset*/ true);
+        aic7xxx_run_done_queue(p, true);
 
       }
       break;
@@ -4112,7 +4106,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                 }
               }
             }
-            aic7xxx_run_done_queue(p, TRUE);
+            aic7xxx_run_done_queue(p, true);
             aic7xxx_verbose = old_verbose;
             /*
              * Wait until after the for loop to set the busy index since
@@ -4337,7 +4331,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
               break;
 
             case QUEUE_FULL:
-              queue_flag = TRUE;    /* Mark that this is a QUEUE_FULL and */
+              queue_flag = true;    /* Mark that this is a QUEUE_FULL and */
             case BUSY:              /* drop through to here */
             {
               struct aic7xxx_scb *next_scbp, *prev_scbp;
@@ -4371,7 +4365,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
               }
               aic7xxx_search_qinfifo(p, target, channel, lun,
                 SCB_LIST_NULL, SCB_QUEUED_FOR_DONE | SCB_QUEUE_FULL,
-	       	FALSE, NULL);
+		false, NULL);
               next_scbp = NULL;
               active_hscb = aic_inb(p, SCBPTR);
               prev_hscb = next_hscb = scb_index = SCB_LIST_NULL;
@@ -4416,7 +4410,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
                 } /* scb_index >= p->scb_data->numscbs */
               }
               aic_outb(p, active_hscb, SCBPTR);
-	      aic7xxx_run_done_queue(p, FALSE);
+	      aic7xxx_run_done_queue(p, false);
                   
 #ifdef AIC7XXX_VERBOSE_DEBUGGING
               if( (aic7xxx_verbose & VERBOSE_MINOR_ERROR) ||
@@ -4903,7 +4897,7 @@ aic7xxx_handle_seqint(struct aic7xxx_host *p, unsigned char intstat)
   /*
    * Clear the sequencer interrupt and unpause the sequencer.
    */
-  unpause_sequencer(p, /* unpause always */ TRUE);
+  unpause_sequencer(p, /* unpause always */ true);
 }
 
 /*+F*************************************************************************
@@ -4930,7 +4924,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   target = scb->cmd->device->id;
   channel = scb->cmd->device->channel;
   lun = scb->cmd->device->lun;
-  reply = reject = done = FALSE;
+  reply = reject = done = false;
   tindex = TARGET_INDEX(scb->cmd);
   aic_dev = AIC_DEV(scb->cmd);
   target_scsirate = aic_inb(p, TARG_SCSIRATE + tindex);
@@ -4940,13 +4934,13 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
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
@@ -4992,7 +4986,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
         
         if (p->msg_buf[1] != MSG_EXT_SDTR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5060,12 +5054,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
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
@@ -5097,7 +5091,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
         if ((new_offset == 0) && (new_offset != offset))
         {
           aic_dev->needsdtr_copy = 0;
-          reply = TRUE;
+          reply = true;
         }
         
         /*
@@ -5127,7 +5121,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                                AHC_TRANS_ACTIVE|AHC_TRANS_CUR, aic_dev);
           aic_dev->needsdtr = 0;
         }
-        done = TRUE;
+        done = true;
         break;
       }
       case MSG_EXT_WDTR:
@@ -5135,7 +5129,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           
         if (p->msg_buf[1] != MSG_EXT_WDTR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5153,7 +5147,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           {
             default:
             {
-              reject = TRUE;
+              reject = true;
               if ( (aic7xxx_verbose & VERBOSE_NEGOTIATION2) &&
                    ((aic_dev->flags & DEVICE_PRINT_DTR) ||
                     (aic7xxx_verbose > 0xffff)) )
@@ -5229,12 +5223,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
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
@@ -5295,7 +5289,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                              AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE,
 			     aic_dev);
         aic_dev->needsdtr = aic_dev->needsdtr_copy;
-        done = TRUE;
+        done = true;
         break;
       }
       case MSG_EXT_PPR:
@@ -5303,7 +5297,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
         
         if (p->msg_buf[1] != MSG_EXT_PPR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5389,12 +5383,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
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
@@ -5420,7 +5414,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                  ((aic_dev->flags & DEVICE_PRINT_DTR) ||
                   (aic7xxx_verbose > 0xffff)) )
             {
-              reply = TRUE;
+              reply = true;
               printk(INFO_LEAD "Requesting %d bit transfers, rejecting.\n",
                 p->host_no, CTL_OF_SCB(scb), 8 * (0x01 << bus_width));
             }
@@ -5494,7 +5488,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
            * to async (should never happen with a device that uses PPR
            * messages, but have to be complete)
            */
-          reply = TRUE;
+          reply = true;
         }
 
         if(reply)
@@ -5508,12 +5502,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
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
@@ -5523,7 +5517,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
   {
     aic_outb(p, MSG_MESSAGE_REJECT, MSG_OUT);
     aic_outb(p, aic_inb(p, SCSISIGO) | ATNO, SCSISIGO);
-    done = TRUE;
+    done = true;
   }
   return(done);
 }
@@ -5542,7 +5536,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
 {
   unsigned char lastbyte;
   unsigned char phasemis;
-  int done = FALSE;
+  int done = false;
 
   switch(p->msg_type)
   {
@@ -5587,7 +5581,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
                      p->host_no, CTL_OF_SCB(scb));
 #endif
           }
-          unpause_sequencer(p, TRUE);
+          unpause_sequencer(p, true);
         }
         else
         {
@@ -5636,7 +5630,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_host *p, struct aic7xxx_scb *scb)
           aic_outb(p, aic_inb(p, SIMODE1) & ~ENREQINIT, SIMODE1);
           aic_outb(p, CLRSCSIINT, CLRINT);
           p->flags &= ~AHC_HANDLING_REQINITS;
-          unpause_sequencer(p, TRUE);
+          unpause_sequencer(p, true);
         }
         break;
       }
@@ -5698,8 +5692,8 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
      * Go through and abort all commands for the channel, but do not
      * reset the channel again.
      */
-    aic7xxx_reset_channel(p, channel, /* Initiate Reset */ FALSE);
-    aic7xxx_run_done_queue(p, TRUE);
+    aic7xxx_reset_channel(p, channel, /* Initiate Reset */ false);
+    aic7xxx_run_done_queue(p, true);
     scb = NULL;
   }
   else if ( ((status & BUSFREE) != 0) && ((status & SELTO) == 0) )
@@ -5713,7 +5707,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
     unsigned char saved_tcl = aic_inb(p, SAVED_TCL);
     unsigned char target = (saved_tcl >> 4) & 0x0F;
     int channel;
-    int printerror = TRUE;
+    int printerror = true;
 
     if ( (p->chip & AHC_CHIPID_MASK) == AHC_AIC7770 )
       channel = (aic_inb(p, SBLKCTL) & SELBUSB) >> 3;
@@ -5735,7 +5729,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
             CTL_OF_SCB(scb), scb->hscb->tag);
         aic7xxx_reset_device(p, target, channel, ALL_LUNS,
                 (message == MSG_ABORT) ? SCB_LIST_NULL : scb->hscb->tag );
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_run_done_queue(p, true);
         scb = NULL;
         printerror = 0;
       }
@@ -5757,7 +5751,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
        */
       printerror = 0;
       aic7xxx_reset_device(p, target, channel, ALL_LUNS, scb->hscb->tag);
-      aic7xxx_run_done_queue(p, TRUE);
+      aic7xxx_run_done_queue(p, true);
       scb = NULL;
     }
     if (printerror != 0)
@@ -5775,12 +5769,12 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
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
@@ -5794,7 +5788,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
     aic_outb(p, CLRBUSFREE, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
     restart_sequencer(p);
-    unpause_sequencer(p, TRUE);
+    unpause_sequencer(p, true);
   }
   else if ((status & SELTO) != 0)
   {
@@ -5915,7 +5909,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
      * are allowed to reselect in.
      */
     restart_sequencer(p);
-    unpause_sequencer(p, TRUE);
+    unpause_sequencer(p, true);
   }
   else if (scb == NULL)
   {
@@ -5931,7 +5925,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
      */
     aic_outb(p, status, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause always */ TRUE);
+    unpause_sequencer(p, /* unpause always */ true);
     scb = NULL;
   }
   else if (status & SCSIPERR)
@@ -6061,7 +6055,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
     }
     aic_outb(p, CLRSCSIPERR, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause_always */ TRUE);
+    unpause_sequencer(p, /* unpause_always */ true);
   }
   else if ( (status & REQINIT) &&
             (p->flags & AHC_HANDLING_REQINITS) )
@@ -6085,7 +6079,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_host *p, unsigned char intstat)
         p->host_no, -1, -1, -1, status);
     aic_outb(p, status, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause always */ TRUE);
+    unpause_sequencer(p, /* unpause always */ true);
     scb = NULL;
   }
   if (scb != NULL)
@@ -6117,14 +6111,14 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
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
@@ -6132,7 +6126,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
        (free_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus FREE_SCBH %d\n", free_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6143,7 +6137,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_FREE_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_FREE_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6156,7 +6150,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
        (dis_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus DISCONNECTED_SCBH %d\n", dis_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6167,7 +6161,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_DISCONNECTED_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_DISCONNECTED_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6180,7 +6174,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
        (wait_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus WAITING_SCBH %d\n", wait_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6191,7 +6185,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_WAITING_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_WAITING_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6208,23 +6202,23 @@ aic7xxx_check_scbs(struct aic7xxx_host *p, char *buffer)
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
+      bogus=true;
     }
   }
   aic_outb(p, saved_scbptr, SCBPTR);
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   if (bogus)
   {
     printk("Bogus parameters found in card SCB array structures.\n");
@@ -6296,14 +6290,14 @@ aic7xxx_handle_command_completion_intr(struct aic7xxx_host *p)
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
@@ -6439,7 +6433,7 @@ aic7xxx_isr(void *dev_id)
     }
 #endif
     aic_outb(p, CLRPARERR | CLRBRKADRINT, CLRINT);
-    unpause_sequencer(p, FALSE);
+    unpause_sequencer(p, false);
   }
 
   if (intstat & SEQINT)
@@ -6531,7 +6525,7 @@ aic7xxx_init_transinfo(struct aic7xxx_host *p, struct aic_dev_data *aic_dev)
                         MSG_EXT_WDTR_BUS_8_BIT, (AHC_TRANS_ACTIVE |
                                                  AHC_TRANS_GOAL |
                                                  AHC_TRANS_CUR), aic_dev );
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
     }
     if ( sdpnt->sdtr && p->user[tindex].offset )
     {
@@ -6642,7 +6636,7 @@ aic7xxx_slave_alloc(struct scsi_device *SDptr)
 static void
 aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 {
-  int tag_enabled = FALSE;
+  int tag_enabled = false;
   struct aic_dev_data *aic_dev = device->hostdata;
   unsigned char tindex;
 
@@ -6653,7 +6647,7 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 
   if (device->tagged_supported)
   {
-    tag_enabled = TRUE;
+    tag_enabled = true;
 
     if (!(p->discenable & (1 << tindex)))
     {
@@ -6661,20 +6655,20 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
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
+        static int print_warning = true;
         if(print_warning)
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
@@ -6684,7 +6678,7 @@ aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 
         if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 255)
         {
-          tag_enabled = FALSE;
+          tag_enabled = false;
         }
         else if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 0)
         {
@@ -6823,13 +6817,13 @@ aic7xxx_probe(int slot, int base, ahc_flag_type *flags)
     int bios_disabled;
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
@@ -8340,7 +8334,7 @@ aic7xxx_register(struct scsi_host_template *template, struct aic7xxx_host *p,
       p->host_no, -1, -1 , -1);
   aic7xxx_clear_intstat(p);
 
-  unpause_sequencer(p, /* unpause_always */ TRUE);
+  unpause_sequencer(p, /* unpause_always */ true);
 
   return (found);
 }
@@ -10109,7 +10103,7 @@ skip_pci_controller:
               pause_sequencer(p);
               aic7xxx_print_card(p);
               aic7xxx_print_scratch_ram(p);
-              unpause_sequencer(p, TRUE);
+              unpause_sequencer(p, true);
             }
           }
           current_p = temp_p;
@@ -10445,7 +10439,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
      * attempt a bus reset.
      */
   saved_scbptr = aic_inb(p, SCBPTR);
-  disconnected = FALSE;
+  disconnected = false;
 
   if (lastphase != P_BUSFREE)
   {
@@ -10454,7 +10448,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
       printk(WARN_LEAD "Invalid SCB ID %d is active, "
              "SCB flags = 0x%x.\n", p->host_no,
             CTL_OF_CMD(cmd), scb->hscb->tag, scb->flags);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
       return FAILED;
     }
     if (scb->hscb->tag == aic_inb(p, SCB_TAG))
@@ -10463,7 +10457,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
       {
         printk(WARN_LEAD "Device reset, Message buffer "
                 "in use\n", p->host_no, CTL_OF_SCB(scb));
-        unpause_sequencer(p, FALSE);
+        unpause_sequencer(p, false);
 	return FAILED;
       }
 	
@@ -10476,7 +10470,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
       /* Send the abort message to the active SCB. */
       aic_outb(p, HOST_MSG, MSG_OUT);
       aic_outb(p, lastphase | ATNO, SCSISIGO);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
       spin_unlock_irq(p->host->host_lock);
       ssleep(1);
       spin_lock_irq(p->host->host_lock);
@@ -10498,9 +10492,9 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
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
@@ -10535,7 +10529,7 @@ static int __aic7xxx_bus_device_reset(struct scsi_cmnd *cmd)
     }
   }
   aic_outb(p, saved_scbptr, SCBPTR);
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   spin_unlock_irq(p->host->host_lock);
   msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
@@ -10663,7 +10657,7 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
  */
   if ( ((found = aic7xxx_search_qinfifo(p, cmd->device->id, cmd->device->channel,
                      cmd->device->lun, scb->hscb->tag, SCB_ABORT | SCB_QUEUED_FOR_DONE,
-                     FALSE, NULL)) != 0) &&
+                     false, NULL)) != 0) &&
                     (aic7xxx_verbose & VERBOSE_ABORT_PROCESS))
   {
     printk(INFO_LEAD "SCB found in QINFIFO and aborted.\n", p->host_no,
@@ -10744,7 +10738,7 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
 	 */
 	printk(INFO_LEAD "message buffer busy, unable to abort.\n",
 			  p->host_no, CTL_OF_SCB(scb));
-	unpause_sequencer(p, FALSE);
+	unpause_sequencer(p, false);
 	return FAILED;
       }
       /* Fallthrough to below, set ATNO after we set SCB_CONTROL */
@@ -10781,7 +10775,7 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
     else
       aic_outb(p, p->qinfifonext, KERNEL_QINPOS);
   }
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   spin_unlock_irq(p->host->host_lock);
   msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
@@ -10800,8 +10794,8 @@ static int __aic7xxx_abort(struct scsi_cmnd *cmd)
 success:
   if (aic7xxx_verbose & VERBOSE_ABORT_RETURN)
     printk(INFO_LEAD "Abort successful.\n", p->host_no, CTL_OF_CMD(cmd));
-  aic7xxx_run_done_queue(p, TRUE);
-  unpause_sequencer(p, FALSE);
+  aic7xxx_run_done_queue(p, true);
+  unpause_sequencer(p, false);
   return SUCCESS;
 }
 
@@ -10874,7 +10868,7 @@ static int aic7xxx_reset(struct scsi_cmnd *cmd)
      * We just completed the command when we ran the isr stuff, so we no
      * longer have it.
      */
-    unpause_sequencer(p, FALSE);
+    unpause_sequencer(p, false);
     spin_unlock_irq(p->host->host_lock);
     return SUCCESS;
   }
@@ -10883,10 +10877,10 @@ static int aic7xxx_reset(struct scsi_cmnd *cmd)
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
@@ -10895,8 +10889,8 @@ static int aic7xxx_reset(struct scsi_cmnd *cmd)
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
index b07e4f0..cb5a119 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
@@ -105,7 +105,7 @@ aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t
     }
   }
 
-  if (inout == TRUE) /* Has data been written to the file? */ 
+  if (inout) /* Has data been written to the file? */
   {
     return (aic7xxx_set_info(buffer, length, HBAptr));
   }
