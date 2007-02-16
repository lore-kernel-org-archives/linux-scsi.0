From: akpm@linux-foundation.org
Subject: [patch 27/30] drivers/scsi/aic7xxx_old: Convert to generic boolean-values
Date: Fri, 16 Feb 2007 01:46:46 -0800
Message-ID: <200702160946.l1G9kkaK026703@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423509AbXBPJq5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:46:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ricknu-0@student.ltu.se

From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert:
FALSE -> false
TRUE  -> true

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx_old.c              |  242 ++++++++++------------
 drivers/scsi/aic7xxx_old/aic7xxx_proc.c |    2 
 2 files changed, 119 insertions(+), 125 deletions(-)

diff -puN drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx_old.c
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
+            unsigned char done = false;
 
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
@@ -1771,7 +1765,7 @@ aic7xxx_loadseq(struct aic7xxx_host *p)
   aic_outb(p, 0, SEQADDR0);
   aic_outb(p, 0, SEQADDR1);
   aic_outb(p, FASTMODE | FAILDIS, SEQCTL);
-  unpause_sequencer(p, TRUE);
+  unpause_sequencer(p, true);
   mdelay(1);
   pause_sequencer(p);
   aic_outb(p, FASTMODE, SEQCTL);
@@ -1820,7 +1814,7 @@ aic7xxx_print_sequencer(struct aic7xxx_h
   aic_outb(p, 0, SEQADDR0);
   aic_outb(p, 0, SEQADDR1);
   aic_outb(p, FASTMODE | FAILDIS, SEQCTL);
-  unpause_sequencer(p, TRUE);
+  unpause_sequencer(p, true);
   mdelay(1);
   pause_sequencer(p);
   aic_outb(p, FASTMODE, SEQCTL);
@@ -1868,7 +1862,7 @@ aic7xxx_find_syncrate(struct aic7xxx_hos
   unsigned int maxsync, unsigned char *options)
 {
   struct aic7xxx_syncrate *syncrate;
-  int done = FALSE;
+  int done = false;
 
   switch(*options)
   {
@@ -1924,7 +1918,7 @@ aic7xxx_find_syncrate(struct aic7xxx_hos
         case MSG_EXT_PPR_OPTION_DT_UNITS:
           if(!(syncrate->sxfr_ultra2 & AHC_SYNCRATE_CRC))
           {
-            done = TRUE;
+            done = true;
             /*
              * oops, we went too low for the CRC/DualEdge signalling, so
              * clear the options byte
@@ -1938,7 +1932,7 @@ aic7xxx_find_syncrate(struct aic7xxx_hos
           }
           else
           {
-            done = TRUE;
+            done = true;
             if(syncrate == &aic7xxx_syncrates[maxsync])
             {
               *period = syncrate->period;
@@ -1948,7 +1942,7 @@ aic7xxx_find_syncrate(struct aic7xxx_hos
         default:
           if(!(syncrate->sxfr_ultra2 & AHC_SYNCRATE_CRC))
           {
-            done = TRUE;
+            done = true;
             if(syncrate == &aic7xxx_syncrates[maxsync])
             {
               *period = syncrate->period;
@@ -2720,7 +2714,7 @@ aic7xxx_done(struct aic7xxx_host *p, str
   if ((scb->flags & SCB_MSGOUT_BITS) != 0)
   {
     unsigned short mask;
-    int message_error = FALSE;
+    int message_error = false;
 
     mask = 0x01 << tindex;
  
@@ -2732,7 +2726,7 @@ aic7xxx_done(struct aic7xxx_host *p, str
           ((scb->cmd->sense_buffer[12] == 0x43) ||  /* INVALID_MESSAGE */
           (scb->cmd->sense_buffer[12] == 0x49))) /* MESSAGE_ERROR  */
     {
-      message_error = TRUE;
+      message_error = true;
     }
 
     if (scb->flags & SCB_MSGOUT_WDTR)
@@ -2830,7 +2824,7 @@ aic7xxx_done(struct aic7xxx_host *p, str
   if (!(scb->tag_action))
   {
     aic7xxx_index_busy_target(p, scb->hscb->target_channel_lun,
-                              /* unbusy */ TRUE);
+                              /* unbusy */ true);
     if (cmd->device->simple_tags)
     {
       aic_dev->temp_q_depth = aic_dev->max_q_depth;
@@ -2890,7 +2884,7 @@ aic7xxx_done(struct aic7xxx_host *p, str
  * Description:
  *   Calls the aic7xxx_done() for the scsi_cmnd of each scb in the
  *   aborted list, and adds each scb to the free list.  If complete
- *   is TRUE, we also process the commands complete list.
+ *   is 'true', we also process the commands complete list.
  *-F*************************************************************************/
 static void
 aic7xxx_run_done_queue(struct aic7xxx_host *p, /*complete*/ int complete)
@@ -3033,7 +3027,7 @@ aic7xxx_search_qinfifo(struct aic7xxx_ho
          if ( !(scbp->tag_action & TAG_ENB) )
          {
            aic7xxx_index_busy_target(p, scbp->hscb->target_channel_lun,
-             TRUE);
+             true);
          }
        }
        else if (requeue)
@@ -3049,10 +3043,10 @@ aic7xxx_search_qinfifo(struct aic7xxx_ho
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
@@ -3097,11 +3091,11 @@ aic7xxx_scb_on_qoutfifo(struct aic7xxx_h
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
 
 
@@ -3127,7 +3121,7 @@ aic7xxx_reset_device(struct aic7xxx_host
   struct aic7xxx_scb *scbp, *prev_scbp;
   struct scsi_device *sd;
   unsigned char active_scb, tcl, scb_tag;
-  int i = 0, init_lists = FALSE;
+  int i = 0, init_lists = false;
   struct aic_dev_data *aic_dev;
 
   /*
@@ -3181,9 +3175,9 @@ aic7xxx_reset_device(struct aic7xxx_host
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
@@ -3207,7 +3201,7 @@ aic7xxx_reset_device(struct aic7xxx_host
   if (aic7xxx_verbose & (VERBOSE_ABORT_PROCESS | VERBOSE_RESET_PROCESS))
     printk(INFO_LEAD "Cleaning QINFIFO.\n", p->host_no, channel, target, lun );
   aic7xxx_search_qinfifo(p, target, channel, lun, tag,
-      SCB_RESET | SCB_QUEUED_FOR_DONE, /* requeue */ FALSE, NULL);
+      SCB_RESET | SCB_QUEUED_FOR_DONE, /* requeue */ false, NULL);
 
 /*
  *  Search the waiting_scbs queue for matches, this catches any SCB_QUEUED
@@ -3365,7 +3359,7 @@ aic7xxx_reset_device(struct aic7xxx_host
       {
         printk(WARN_LEAD "Free list inconsistency!.\n", p->host_no, channel,
           target, lun);
-        init_lists = TRUE;
+        init_lists = true;
         next = SCB_LIST_NULL;
       }
       else
@@ -3526,7 +3520,7 @@ aic7xxx_reset_channel(struct aic7xxx_hos
 
   if (aic7xxx_verbose & VERBOSE_RESET_PROCESS)
     printk(INFO_LEAD "Reset channel called, %s initiate reset.\n",
-      p->host_no, channel, -1, -1, (initiate_reset==TRUE) ? "will" : "won't" );
+      p->host_no, channel, -1, -1, initiate_reset ? "will" : "won't" );
 
 
   if (channel == 1)
@@ -3690,7 +3684,7 @@ aic7xxx_run_waiting_queues(struct aic7xx
     {
       pause_sequencer(p);
       aic_outb(p, p->qinfifonext, KERNEL_QINPOS);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
     }
     if (p->activescbs > p->max_activescbs)
       p->max_activescbs = p->activescbs;
@@ -3908,7 +3902,7 @@ aic7xxx_handle_device_reset(struct aic7x
   if (aic7xxx_verbose & VERBOSE_RESET_PROCESS)
     printk(INFO_LEAD "Bus Device Reset delivered.\n", p->host_no, channel,
       target, -1);
-  aic7xxx_run_done_queue(p, /*complete*/ TRUE);
+  aic7xxx_run_done_queue(p, /*complete*/ true);
 }
 
 /*+F*************************************************************************
@@ -3925,7 +3919,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
   struct aic_dev_data *aic_dev;
   unsigned short target_mask;
   unsigned char target, lun, tindex;
-  unsigned char queue_flag = FALSE;
+  unsigned char queue_flag = false;
   char channel;
   int result;
 
@@ -3983,8 +3977,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
             "LASTPHASE 0x%x, SAVED_TCL 0x%x\n", p->host_no, channel, target,
             lun, aic_inb(p, LASTPHASE), aic_inb(p, SAVED_TCL));
 
-        aic7xxx_reset_channel(p, channel, /*initiate reset*/ TRUE);
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_reset_channel(p, channel, /*initiate reset*/ true);
+        aic7xxx_run_done_queue(p, true);
 
       }
       break;
@@ -4111,7 +4105,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
                 }
               }
             }
-            aic7xxx_run_done_queue(p, TRUE);
+            aic7xxx_run_done_queue(p, true);
             aic7xxx_verbose = old_verbose;
             /*
              * Wait until after the for loop to set the busy index since
@@ -4336,7 +4330,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
               break;
 
             case QUEUE_FULL:
-              queue_flag = TRUE;    /* Mark that this is a QUEUE_FULL and */
+              queue_flag = true;    /* Mark that this is a QUEUE_FULL and */
             case BUSY:              /* drop through to here */
             {
               struct aic7xxx_scb *next_scbp, *prev_scbp;
@@ -4370,7 +4364,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
               }
               aic7xxx_search_qinfifo(p, target, channel, lun,
                 SCB_LIST_NULL, SCB_QUEUED_FOR_DONE | SCB_QUEUE_FULL,
-	       	FALSE, NULL);
+		false, NULL);
               next_scbp = NULL;
               active_hscb = aic_inb(p, SCBPTR);
               prev_hscb = next_hscb = scb_index = SCB_LIST_NULL;
@@ -4415,7 +4409,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
                 } /* scb_index >= p->scb_data->numscbs */
               }
               aic_outb(p, active_hscb, SCBPTR);
-	      aic7xxx_run_done_queue(p, FALSE);
+	      aic7xxx_run_done_queue(p, false);
                   
 #ifdef AIC7XXX_VERBOSE_DEBUGGING
               if( (aic7xxx_verbose & VERBOSE_MINOR_ERROR) ||
@@ -4902,7 +4896,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
   /*
    * Clear the sequencer interrupt and unpause the sequencer.
    */
-  unpause_sequencer(p, /* unpause always */ TRUE);
+  unpause_sequencer(p, /* unpause always */ true);
 }
 
 /*+F*************************************************************************
@@ -4929,7 +4923,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
   target = scb->cmd->device->id;
   channel = scb->cmd->device->channel;
   lun = scb->cmd->device->lun;
-  reply = reject = done = FALSE;
+  reply = reject = done = false;
   tindex = TARGET_INDEX(scb->cmd);
   aic_dev = AIC_DEV(scb->cmd);
   target_scsirate = aic_inb(p, TARG_SCSIRATE + tindex);
@@ -4939,13 +4933,13 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
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
@@ -4991,7 +4985,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
         
         if (p->msg_buf[1] != MSG_EXT_SDTR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5059,12 +5053,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
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
@@ -5096,7 +5090,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
         if ((new_offset == 0) && (new_offset != offset))
         {
           aic_dev->needsdtr_copy = 0;
-          reply = TRUE;
+          reply = true;
         }
         
         /*
@@ -5126,7 +5120,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
                                AHC_TRANS_ACTIVE|AHC_TRANS_CUR, aic_dev);
           aic_dev->needsdtr = 0;
         }
-        done = TRUE;
+        done = true;
         break;
       }
       case MSG_EXT_WDTR:
@@ -5134,7 +5128,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
           
         if (p->msg_buf[1] != MSG_EXT_WDTR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5152,7 +5146,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
           {
             default:
             {
-              reject = TRUE;
+              reject = true;
               if ( (aic7xxx_verbose & VERBOSE_NEGOTIATION2) &&
                    ((aic_dev->flags & DEVICE_PRINT_DTR) ||
                     (aic7xxx_verbose > 0xffff)) )
@@ -5228,12 +5222,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
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
@@ -5294,7 +5288,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
                              AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE,
 			     aic_dev);
         aic_dev->needsdtr = aic_dev->needsdtr_copy;
-        done = TRUE;
+        done = true;
         break;
       }
       case MSG_EXT_PPR:
@@ -5302,7 +5296,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
         
         if (p->msg_buf[1] != MSG_EXT_PPR_LEN)
         {
-          reject = TRUE;
+          reject = true;
           break;
         }
 
@@ -5388,12 +5382,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
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
@@ -5419,7 +5413,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
                  ((aic_dev->flags & DEVICE_PRINT_DTR) ||
                   (aic7xxx_verbose > 0xffff)) )
             {
-              reply = TRUE;
+              reply = true;
               printk(INFO_LEAD "Requesting %d bit transfers, rejecting.\n",
                 p->host_no, CTL_OF_SCB(scb), 8 * (0x01 << bus_width));
             }
@@ -5493,7 +5487,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
            * to async (should never happen with a device that uses PPR
            * messages, but have to be complete)
            */
-          reply = TRUE;
+          reply = true;
         }
 
         if(reply)
@@ -5507,12 +5501,12 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
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
@@ -5522,7 +5516,7 @@ aic7xxx_parse_msg(struct aic7xxx_host *p
   {
     aic_outb(p, MSG_MESSAGE_REJECT, MSG_OUT);
     aic_outb(p, aic_inb(p, SCSISIGO) | ATNO, SCSISIGO);
-    done = TRUE;
+    done = true;
   }
   return(done);
 }
@@ -5541,7 +5535,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_ho
 {
   unsigned char lastbyte;
   unsigned char phasemis;
-  int done = FALSE;
+  int done = false;
 
   switch(p->msg_type)
   {
@@ -5586,7 +5580,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_ho
                      p->host_no, CTL_OF_SCB(scb));
 #endif
           }
-          unpause_sequencer(p, TRUE);
+          unpause_sequencer(p, true);
         }
         else
         {
@@ -5635,7 +5629,7 @@ aic7xxx_handle_reqinit(struct aic7xxx_ho
           aic_outb(p, aic_inb(p, SIMODE1) & ~ENREQINIT, SIMODE1);
           aic_outb(p, CLRSCSIINT, CLRINT);
           p->flags &= ~AHC_HANDLING_REQINITS;
-          unpause_sequencer(p, TRUE);
+          unpause_sequencer(p, true);
         }
         break;
       }
@@ -5697,8 +5691,8 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
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
@@ -5712,7 +5706,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
     unsigned char saved_tcl = aic_inb(p, SAVED_TCL);
     unsigned char target = (saved_tcl >> 4) & 0x0F;
     int channel;
-    int printerror = TRUE;
+    int printerror = true;
 
     if ( (p->chip & AHC_CHIPID_MASK) == AHC_AIC7770 )
       channel = (aic_inb(p, SBLKCTL) & SELBUSB) >> 3;
@@ -5734,7 +5728,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
             CTL_OF_SCB(scb), scb->hscb->tag);
         aic7xxx_reset_device(p, target, channel, ALL_LUNS,
                 (message == MSG_ABORT) ? SCB_LIST_NULL : scb->hscb->tag );
-        aic7xxx_run_done_queue(p, TRUE);
+        aic7xxx_run_done_queue(p, true);
         scb = NULL;
         printerror = 0;
       }
@@ -5756,7 +5750,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
        */
       printerror = 0;
       aic7xxx_reset_device(p, target, channel, ALL_LUNS, scb->hscb->tag);
-      aic7xxx_run_done_queue(p, TRUE);
+      aic7xxx_run_done_queue(p, true);
       scb = NULL;
     }
     if (printerror != 0)
@@ -5774,12 +5768,12 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
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
@@ -5793,7 +5787,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
     aic_outb(p, CLRBUSFREE, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
     restart_sequencer(p);
-    unpause_sequencer(p, TRUE);
+    unpause_sequencer(p, true);
   }
   else if ((status & SELTO) != 0)
   {
@@ -5914,7 +5908,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
      * are allowed to reselect in.
      */
     restart_sequencer(p);
-    unpause_sequencer(p, TRUE);
+    unpause_sequencer(p, true);
   }
   else if (scb == NULL)
   {
@@ -5930,7 +5924,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
      */
     aic_outb(p, status, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause always */ TRUE);
+    unpause_sequencer(p, /* unpause always */ true);
     scb = NULL;
   }
   else if (status & SCSIPERR)
@@ -6060,7 +6054,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
     }
     aic_outb(p, CLRSCSIPERR, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause_always */ TRUE);
+    unpause_sequencer(p, /* unpause_always */ true);
   }
   else if ( (status & REQINIT) &&
             (p->flags & AHC_HANDLING_REQINITS) )
@@ -6084,7 +6078,7 @@ aic7xxx_handle_scsiint(struct aic7xxx_ho
         p->host_no, -1, -1, -1, status);
     aic_outb(p, status, CLRSINT1);
     aic_outb(p, CLRSCSIINT, CLRINT);
-    unpause_sequencer(p, /* unpause always */ TRUE);
+    unpause_sequencer(p, /* unpause always */ true);
     scb = NULL;
   }
   if (scb != NULL)
@@ -6116,14 +6110,14 @@ aic7xxx_check_scbs(struct aic7xxx_host *
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
@@ -6131,7 +6125,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *
        (free_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus FREE_SCBH %d\n", free_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6142,7 +6136,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_FREE_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_FREE_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6155,7 +6149,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *
        (dis_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus DISCONNECTED_SCBH %d\n", dis_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6166,7 +6160,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_DISCONNECTED_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_DISCONNECTED_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6179,7 +6173,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *
        (wait_scbh >= p->scb_data->maxhscbs) )
   {
     printk("Bogus WAITING_SCBH %d\n", wait_scbh);
-    bogus = TRUE;
+    bogus = true;
   }
   else
   {
@@ -6190,7 +6184,7 @@ aic7xxx_check_scbs(struct aic7xxx_host *
       {
         printk("HSCB %d on multiple lists, status 0x%02x", temp,
                scb_status[temp] | SCB_WAITING_LIST);
-        bogus = TRUE;
+        bogus = true;
       }
       scb_status[temp] |= SCB_WAITING_LIST;
       aic_outb(p, temp, SCBPTR);
@@ -6207,23 +6201,23 @@ aic7xxx_check_scbs(struct aic7xxx_host *
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
@@ -6295,14 +6289,14 @@ aic7xxx_handle_command_completion_intr(s
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
@@ -6438,7 +6432,7 @@ aic7xxx_isr(void *dev_id)
     }
 #endif
     aic_outb(p, CLRPARERR | CLRBRKADRINT, CLRINT);
-    unpause_sequencer(p, FALSE);
+    unpause_sequencer(p, false);
   }
 
   if (intstat & SEQINT)
@@ -6530,7 +6524,7 @@ aic7xxx_init_transinfo(struct aic7xxx_ho
                         MSG_EXT_WDTR_BUS_8_BIT, (AHC_TRANS_ACTIVE |
                                                  AHC_TRANS_GOAL |
                                                  AHC_TRANS_CUR), aic_dev );
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
     }
     if ( sdpnt->sdtr && p->user[tindex].offset )
     {
@@ -6641,7 +6635,7 @@ aic7xxx_slave_alloc(struct scsi_device *
 static void
 aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 {
-  int tag_enabled = FALSE;
+  int tag_enabled = false;
   struct aic_dev_data *aic_dev = device->hostdata;
   unsigned char tindex;
 
@@ -6652,7 +6646,7 @@ aic7xxx_device_queue_depth(struct aic7xx
 
   if (device->tagged_supported)
   {
-    tag_enabled = TRUE;
+    tag_enabled = true;
 
     if (!(p->discenable & (1 << tindex)))
     {
@@ -6660,20 +6654,20 @@ aic7xxx_device_queue_depth(struct aic7xx
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
@@ -6683,7 +6677,7 @@ aic7xxx_device_queue_depth(struct aic7xx
 
         if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 255)
         {
-          tag_enabled = FALSE;
+          tag_enabled = false;
         }
         else if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 0)
         {
@@ -6822,13 +6816,13 @@ aic7xxx_probe(int slot, int base, ahc_fl
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
@@ -8339,7 +8333,7 @@ aic7xxx_register(struct scsi_host_templa
       p->host_no, -1, -1 , -1);
   aic7xxx_clear_intstat(p);
 
-  unpause_sequencer(p, /* unpause_always */ TRUE);
+  unpause_sequencer(p, /* unpause_always */ true);
 
   return (found);
 }
@@ -10108,7 +10102,7 @@ skip_pci_controller:
               pause_sequencer(p);
               aic7xxx_print_card(p);
               aic7xxx_print_scratch_ram(p);
-              unpause_sequencer(p, TRUE);
+              unpause_sequencer(p, true);
             }
           }
           current_p = temp_p;
@@ -10444,7 +10438,7 @@ static int __aic7xxx_bus_device_reset(st
      * attempt a bus reset.
      */
   saved_scbptr = aic_inb(p, SCBPTR);
-  disconnected = FALSE;
+  disconnected = false;
 
   if (lastphase != P_BUSFREE)
   {
@@ -10453,7 +10447,7 @@ static int __aic7xxx_bus_device_reset(st
       printk(WARN_LEAD "Invalid SCB ID %d is active, "
              "SCB flags = 0x%x.\n", p->host_no,
             CTL_OF_CMD(cmd), scb->hscb->tag, scb->flags);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
       return FAILED;
     }
     if (scb->hscb->tag == aic_inb(p, SCB_TAG))
@@ -10462,7 +10456,7 @@ static int __aic7xxx_bus_device_reset(st
       {
         printk(WARN_LEAD "Device reset, Message buffer "
                 "in use\n", p->host_no, CTL_OF_SCB(scb));
-        unpause_sequencer(p, FALSE);
+        unpause_sequencer(p, false);
 	return FAILED;
       }
 	
@@ -10475,7 +10469,7 @@ static int __aic7xxx_bus_device_reset(st
       /* Send the abort message to the active SCB. */
       aic_outb(p, HOST_MSG, MSG_OUT);
       aic_outb(p, lastphase | ATNO, SCSISIGO);
-      unpause_sequencer(p, FALSE);
+      unpause_sequencer(p, false);
       spin_unlock_irq(p->host->host_lock);
       ssleep(1);
       spin_lock_irq(p->host->host_lock);
@@ -10497,9 +10491,9 @@ static int __aic7xxx_bus_device_reset(st
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
@@ -10534,7 +10528,7 @@ static int __aic7xxx_bus_device_reset(st
     }
   }
   aic_outb(p, saved_scbptr, SCBPTR);
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   spin_unlock_irq(p->host->host_lock);
   msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
@@ -10662,7 +10656,7 @@ static int __aic7xxx_abort(struct scsi_c
  */
   if ( ((found = aic7xxx_search_qinfifo(p, cmd->device->id, cmd->device->channel,
                      cmd->device->lun, scb->hscb->tag, SCB_ABORT | SCB_QUEUED_FOR_DONE,
-                     FALSE, NULL)) != 0) &&
+                     false, NULL)) != 0) &&
                     (aic7xxx_verbose & VERBOSE_ABORT_PROCESS))
   {
     printk(INFO_LEAD "SCB found in QINFIFO and aborted.\n", p->host_no,
@@ -10743,7 +10737,7 @@ static int __aic7xxx_abort(struct scsi_c
 	 */
 	printk(INFO_LEAD "message buffer busy, unable to abort.\n",
 			  p->host_no, CTL_OF_SCB(scb));
-	unpause_sequencer(p, FALSE);
+	unpause_sequencer(p, false);
 	return FAILED;
       }
       /* Fallthrough to below, set ATNO after we set SCB_CONTROL */
@@ -10780,7 +10774,7 @@ static int __aic7xxx_abort(struct scsi_c
     else
       aic_outb(p, p->qinfifonext, KERNEL_QINPOS);
   }
-  unpause_sequencer(p, FALSE);
+  unpause_sequencer(p, false);
   spin_unlock_irq(p->host->host_lock);
   msleep(1000/4);
   spin_lock_irq(p->host->host_lock);
@@ -10799,8 +10793,8 @@ static int __aic7xxx_abort(struct scsi_c
 success:
   if (aic7xxx_verbose & VERBOSE_ABORT_RETURN)
     printk(INFO_LEAD "Abort successful.\n", p->host_no, CTL_OF_CMD(cmd));
-  aic7xxx_run_done_queue(p, TRUE);
-  unpause_sequencer(p, FALSE);
+  aic7xxx_run_done_queue(p, true);
+  unpause_sequencer(p, false);
   return SUCCESS;
 }
 
@@ -10873,7 +10867,7 @@ static int aic7xxx_reset(struct scsi_cmn
      * We just completed the command when we ran the isr stuff, so we no
      * longer have it.
      */
-    unpause_sequencer(p, FALSE);
+    unpause_sequencer(p, false);
     spin_unlock_irq(p->host->host_lock);
     return SUCCESS;
   }
@@ -10882,10 +10876,10 @@ static int aic7xxx_reset(struct scsi_cmn
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
@@ -10894,8 +10888,8 @@ static int aic7xxx_reset(struct scsi_cmn
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
diff -puN drivers/scsi/aic7xxx_old/aic7xxx_proc.c~drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values drivers/scsi/aic7xxx_old/aic7xxx_proc.c
--- a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c~drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values
+++ a/drivers/scsi/aic7xxx_old/aic7xxx_proc.c
@@ -105,7 +105,7 @@ aic7xxx_proc_info ( struct Scsi_Host *HB
     }
   }
 
-  if (inout == TRUE) /* Has data been written to the file? */ 
+  if (inout) /* Has data been written to the file? */
   {
     return (aic7xxx_set_info(buffer, length, HBAptr));
   }
_
