From: Doug Ledford <dledford@redhat.com>
Subject: PATCH: scsi device queue depth adjustability patch
Date: Tue, 1 Oct 2002 20:28:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002002854.GF28265@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id g920Ss9Y029071
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 20:28:54 -0400
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id g920SsHK029069
	for linux-scsi@vger.kernel.org; Tue, 1 Oct 2002 20:28:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch makes it possible to adjust the queue depth of a scsi device 
after it has been in use some time and you have a better idea of what the 
optimal queue depth should be.  For the most part this should work, but my 
2.5.40 test machine is blowing chunks on the serverworks IDE support right 
now so it isn't tested :-(

What I need, people to test this with the old aic7xxx driver (which 
implements the new code paths, no other drivers do) and people to test 
with other drivers to make sure it doesn't break them.  If I don't hear 
complaints then I'll move on to my next change which is far more intrusive 
on drivers in general.

Side note: I left the control of queue depth setting solely in the hands 
of the low level drivers since they are the *only* ones that can get an 
accurate queue depth reading at the time of any given QUEUE_FULL message 
(see what the aic7xxx_old driver has to do in the QUEUE_FULL handler to 
find out how many commands the drive has seen at this exact point in time 
vs. how many we may have queued up to the card, the difference in numbers 
can be significant).  For that reason, the adjust_queue_depth call was 
made to defer the action until later so that it was interrupt context 
safe.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="scsi-queue.patch"

--- 2.5/drivers/scsi/aic7xxx_old/aic7xxx.h.queue	2002-08-02 16:24:32.000000000 -0400
+++ 2.5/drivers/scsi/aic7xxx_old/aic7xxx.h	2002-10-01 19:19:37.000000000 -0400
@@ -46,7 +46,9 @@
 	eh_host_reset_handler: NULL,				\
 	abort: aic7xxx_abort,					\
 	reset: aic7xxx_reset,					\
-	slave_attach: NULL,					\
+	select_queue_depths: NULL,				\
+	slave_attach: aic7xxx_slave_attach,			\
+	slave_detach: aic7xxx_slave_detach,			\
 	bios_param: aic7xxx_biosparam,				\
 	can_queue: 255,		/* max simultaneous cmds      */\
 	this_id: -1,		/* scsi id of host adapter    */\
@@ -64,6 +66,8 @@
 extern int aic7xxx_reset(Scsi_Cmnd *, unsigned int);
 extern int aic7xxx_abort(Scsi_Cmnd *);
 extern int aic7xxx_release(struct Scsi_Host *);
+extern int aic7xxx_slave_attach(Scsi_Device *);
+extern void aic7xxx_slave_detach(Scsi_Device *);
 
 extern const char *aic7xxx_info(struct Scsi_Host *);
 
--- 2.5/drivers/scsi/aic7xxx_old.c.queue	2002-08-27 19:50:42.000000000 -0400
+++ 2.5/drivers/scsi/aic7xxx_old.c	2002-10-01 19:19:37.000000000 -0400
@@ -977,7 +977,7 @@
 #define  DEVICE_DTR_SCANNED             0x40
   volatile unsigned char   dev_flags[MAX_TARGETS];
   volatile unsigned char   dev_active_cmds[MAX_TARGETS];
-  volatile unsigned char   dev_temp_queue_depth[MAX_TARGETS];
+  volatile unsigned short  dev_temp_queue_depth[MAX_TARGETS];
   unsigned char            dev_commands_sent[MAX_TARGETS];
 
   unsigned int             dev_timer_active; /* Which devs have a timer set */
@@ -989,7 +989,9 @@
 
   unsigned char            dev_last_queue_full[MAX_TARGETS];
   unsigned char            dev_last_queue_full_count[MAX_TARGETS];
-  unsigned char            dev_max_queue_depth[MAX_TARGETS];
+  unsigned char            dev_lun_queue_depth[MAX_TARGETS];
+  unsigned short           dev_scbs_needed[MAX_TARGETS];
+  unsigned short           dev_max_queue_depth[MAX_TARGETS];
 
   volatile scb_queue_type  delayed_scbs[MAX_TARGETS];
 
@@ -1036,6 +1038,7 @@
   ahc_chip                 chip;             /* chip type */
   ahc_bugs                 bugs;
   dma_addr_t		   fifo_dma;	     /* DMA handle for fifo arrays */
+  Scsi_Device		  *Scsi_Dev[MAX_TARGETS][MAX_LUNS];
 
   /*
    * Statistics Kept:
@@ -2821,94 +2824,6 @@
     cmd->result |= (DID_RESET << 16);
   }
 
-  if (!(p->dev_flags[tindex] & DEVICE_PRESENT))
-  {
-    if ( (cmd->cmnd[0] == INQUIRY) && (cmd->result == DID_OK) )
-    {
-    
-      p->dev_flags[tindex] |= DEVICE_PRESENT;
-#define WIDE_INQUIRY_BITS 0x60
-#define SYNC_INQUIRY_BITS 0x10
-#define SCSI_VERSION_BITS 0x07
-#define SCSI_DT_BIT       0x04
-      if(!(p->dev_flags[tindex] & DEVICE_DTR_SCANNED)) {
-        char *buffer;
-
-        if(cmd->use_sg)
-          BUG();
-
-        buffer = (char *)cmd->request_buffer;
-
-        if ( (buffer[7] & WIDE_INQUIRY_BITS) &&
-             (p->features & AHC_WIDE) )
-        {
-          p->needwdtr |= (1<<tindex);
-          p->needwdtr_copy |= (1<<tindex);
-          p->transinfo[tindex].goal_width = p->transinfo[tindex].user_width;
-        }
-        else
-        {
-          p->needwdtr &= ~(1<<tindex);
-          p->needwdtr_copy &= ~(1<<tindex);
-          pause_sequencer(p);
-          aic7xxx_set_width(p, cmd->target, cmd->channel, cmd->lun,
-                            MSG_EXT_WDTR_BUS_8_BIT, (AHC_TRANS_ACTIVE |
-                                                     AHC_TRANS_GOAL |
-                                                     AHC_TRANS_CUR) );
-          unpause_sequencer(p, FALSE);
-        }
-        if ( (buffer[7] & SYNC_INQUIRY_BITS) &&
-              p->transinfo[tindex].user_offset )
-        {
-          p->transinfo[tindex].goal_period = p->transinfo[tindex].user_period;
-          p->transinfo[tindex].goal_options = p->transinfo[tindex].user_options;
-          if (p->features & AHC_ULTRA2)
-            p->transinfo[tindex].goal_offset = MAX_OFFSET_ULTRA2;
-          else if (p->transinfo[tindex].goal_width == MSG_EXT_WDTR_BUS_16_BIT)
-            p->transinfo[tindex].goal_offset = MAX_OFFSET_16BIT;
-          else
-            p->transinfo[tindex].goal_offset = MAX_OFFSET_8BIT;
-          if ( (((buffer[2] & SCSI_VERSION_BITS) >= 3) ||
-                 (buffer[56] & SCSI_DT_BIT) ||
-                 (p->dev_flags[tindex] & DEVICE_SCSI_3) ) &&
-                 (p->transinfo[tindex].user_period <= 9) &&
-                 (p->transinfo[tindex].user_options) )
-          {
-            p->needppr |= (1<<tindex);
-            p->needppr_copy |= (1<<tindex);
-            p->needsdtr &= ~(1<<tindex);
-            p->needsdtr_copy &= ~(1<<tindex);
-            p->needwdtr &= ~(1<<tindex);
-            p->needwdtr_copy &= ~(1<<tindex);
-            p->dev_flags[tindex] |= DEVICE_SCSI_3;
-          }
-          else
-          {
-            p->needsdtr |= (1<<tindex);
-            p->needsdtr_copy |= (1<<tindex);
-            p->transinfo[tindex].goal_period = 
-              MAX(10, p->transinfo[tindex].goal_period);
-            p->transinfo[tindex].goal_options = 0;
-          }
-        }
-        else
-        {
-          p->needsdtr &= ~(1<<tindex);
-          p->needsdtr_copy &= ~(1<<tindex);
-          p->transinfo[tindex].goal_period = 255;
-          p->transinfo[tindex].goal_offset = 0;
-          p->transinfo[tindex].goal_options = 0;
-        }
-        p->dev_flags[tindex] |= DEVICE_DTR_SCANNED;
-        p->dev_flags[tindex] |= DEVICE_PRINT_DTR;
-      }
-#undef WIDE_INQUIRY_BITS
-#undef SYNC_INQUIRY_BITS
-#undef SCSI_VERSION_BITS
-#undef SCSI_DT_BIT
-    }
-  }
-
   if ((scb->flags & SCB_MSGOUT_BITS) != 0)
   {
     unsigned short mask;
@@ -4920,15 +4835,29 @@
                 if ( (p->dev_last_queue_full_count[tindex] > 14) &&
                      (p->dev_active_cmds[tindex] > 4) )
                 {
+		  int diff, lun;
+		  if (p->dev_active_cmds[tindex] > p->dev_lun_queue_depth[tindex])
+		    /* We don't know what to do here, so bail. */
+		    break;
                   if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
                     printk(INFO_LEAD "Queue depth reduced to %d\n", p->host_no,
                       CTL_OF_SCB(scb), p->dev_active_cmds[tindex]);
-                  p->dev_max_queue_depth[tindex] = 
-                      p->dev_active_cmds[tindex];
+		  diff = p->dev_lun_queue_depth[tindex] -
+			 p->dev_active_cmds[tindex];
+		  p->dev_lun_queue_depth[tindex] -= diff;
+		  for(lun = 0; lun < p->host->max_lun; lun++)
+		  {
+		    if(p->Scsi_Dev[tindex][lun] != NULL)
+		    {
+		      p->dev_max_queue_depth[tindex] -= diff;
+		      scsi_adjust_queue_depth(p->Scsi_Dev[tindex][lun], 1,
+				              p->dev_lun_queue_depth[tindex]);
+		      if(p->dev_temp_queue_depth[tindex] > p->dev_max_queue_depth[tindex])
+		        p->dev_temp_queue_depth[tindex] = p->dev_max_queue_depth[tindex];
+		    }
+		  }
                   p->dev_last_queue_full[tindex] = 0;
                   p->dev_last_queue_full_count[tindex] = 0;
-                  p->dev_temp_queue_depth[tindex] = 
-                    p->dev_active_cmds[tindex];
                 }
                 else if (p->dev_active_cmds[tindex] == 0)
                 {
@@ -7024,10 +6953,10 @@
  *   with queue depths for individual devices.  It also allows tagged
  *   queueing to be [en|dis]abled for a specific adapter.
  *-F*************************************************************************/
-static int
+static void
 aic7xxx_device_queue_depth(struct aic7xxx_host *p, Scsi_Device *device)
 {
-  int default_depth = 3;
+  int default_depth = p->host->hostt->cmd_per_lun;
   unsigned char tindex;
   unsigned short target_mask;
 
@@ -7037,12 +6966,69 @@
   if (p->dev_max_queue_depth[tindex] > 1)
   {
     /*
-     * We've already scanned this device, leave it alone
+     * We've already scanned some lun on this device and enabled tagged
+     * queueing on it.  So, as long as this lun also supports tagged
+     * queueing, enable it here with the same depth.  Call SCSI mid layer
+     * to adjust depth on this device, and add enough to the max_queue_depth
+     * to cover the commands for this lun.
+     *
+     * Note: there is a shortcoming here.  The aic7xxx driver really assumes
+     * that if any lun on a device supports tagged queueing, then they *all*
+     * do.  Our p->tagenable field is on a per target id basis and doesn't
+     * differentiate for different luns.  If we end up with one lun that
+     * doesn't support tagged queueing, it's going to disable tagged queueing
+     * on *all* the luns on that target ID :-(
      */
-    return(p->dev_max_queue_depth[tindex]);
+    if(device->tagged_supported) {
+      if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
+      {
+        printk(INFO_LEAD "Enabled tagged queuing, queue depth %d.\n",
+               p->host_no, device->channel, device->id,
+               device->lun, device->queue_depth);
+      }
+      p->dev_max_queue_depth[tindex] += p->dev_lun_queue_depth[tindex];
+      p->dev_temp_queue_depth[tindex] += p->dev_lun_queue_depth[tindex];
+      scsi_adjust_queue_depth(device, 1, p->dev_lun_queue_depth[tindex]);
+    }
+    else
+    {
+      int lun;
+      /*
+       * Uh ohh, this is what I was talking about.  All the other devices on
+       * this target ID that support tagged queueing are going to end up
+       * getting tagged queueing turned off because of this device.  Print
+       * out a message to this effect for the user, then disable tagged
+       * queueing on all the devices on this ID.
+       */
+      printk(WARN_LEAD "does not support tagged queuing while other luns on\n"
+             "          the same target ID do!!  Tagged queueing will be disabled for\n"
+             "          all luns on this target ID!!\n", p->host_no,
+	     device->channel, device->id, device->lun);
+      
+      p->dev_lun_queue_depth[tindex] = default_depth;
+      p->dev_scbs_needed[tindex] = 0;
+      p->dev_temp_queue_depth[tindex] = 1;
+      p->dev_max_queue_depth[tindex] = 1;
+      p->tagenable &= ~target_mask;
+
+      for(lun=0; lun < p->host->max_lun; lun++)
+      {
+        if(p->Scsi_Dev[tindex][lun] != NULL)
+	{
+          printk(WARN_LEAD "disabling tagged queuing.\n", p->host_no,
+                 p->Scsi_Dev[tindex][lun]->channel,
+		 p->Scsi_Dev[tindex][lun]->id,
+		 p->Scsi_Dev[tindex][lun]->lun);
+          scsi_adjust_queue_depth(p->Scsi_Dev[tindex][lun], 0, default_depth);
+	  p->dev_scbs_needed[tindex] += default_depth;
+	}
+      }
+    }
+    return;
   }
 
-  device->queue_depth = default_depth;
+  p->dev_lun_queue_depth[tindex] = default_depth;
+  p->dev_scbs_needed[tindex] = default_depth;
   p->dev_temp_queue_depth[tindex] = 1;
   p->dev_max_queue_depth[tindex] = 1;
   p->tagenable &= ~target_mask;
@@ -7052,7 +7038,7 @@
     int tag_enabled = TRUE;
 
     default_depth = AIC7XXX_CMDS_PER_DEVICE;
- 
+
     if (!(p->discenable & target_mask))
     {
       if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
@@ -7073,7 +7059,7 @@
                            " the aic7xxx.c source file.\n");
           print_warning = FALSE;
         }
-        device->queue_depth = default_depth;
+        p->dev_lun_queue_depth[tindex] = default_depth;
       }
       else
       {
@@ -7081,19 +7067,18 @@
         if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 255)
         {
           tag_enabled = FALSE;
-          device->queue_depth = 3;  /* Tagged queueing is disabled. */
         }
         else if (aic7xxx_tag_info[p->instance].tag_commands[tindex] == 0)
         {
-          device->queue_depth = default_depth;
+          p->dev_lun_queue_depth[tindex] = default_depth;
         }
         else
         {
-          device->queue_depth =
+          p->dev_lun_queue_depth[tindex] =
             aic7xxx_tag_info[p->instance].tag_commands[tindex];
         }
       }
-      if ((device->tagged_queue == 0) && tag_enabled)
+      if (tag_enabled)
       {
         if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
         {
@@ -7101,46 +7086,70 @@
                 p->host_no, device->channel, device->id,
                 device->lun, device->queue_depth);
         }
-        p->dev_max_queue_depth[tindex] = device->queue_depth;
-        p->dev_temp_queue_depth[tindex] = device->queue_depth;
+        p->dev_max_queue_depth[tindex] = p->dev_lun_queue_depth[tindex];
+        p->dev_temp_queue_depth[tindex] = p->dev_lun_queue_depth[tindex];
+        p->dev_scbs_needed[tindex] = p->dev_lun_queue_depth[tindex];
         p->tagenable |= target_mask;
         p->orderedtag |= target_mask;
-        device->tagged_queue = 1;
-        device->current_tag = SCB_LIST_NULL;
+	scsi_adjust_queue_depth(device, 1, p->dev_lun_queue_depth[tindex]);
       }
     }
   }
-  return(p->dev_max_queue_depth[tindex]);
+  return;
 }
 
 /*+F*************************************************************************
  * Function:
- *   aic7xxx_select_queue_depth
+ *   aic7xxx_slave_detach
  *
  * Description:
- *   Sets the queue depth for each SCSI device hanging off the input
- *   host adapter.  We use a queue depth of 2 for devices that do not
- *   support tagged queueing.  If AIC7XXX_CMDS_PER_LUN is defined, we
- *   use that for tagged queueing devices; otherwise we use our own
- *   algorithm for determining the queue depth based on the maximum
- *   SCBs for the controller.
+ *   prepare for this device to go away
  *-F*************************************************************************/
-static void
-aic7xxx_select_queue_depth(struct Scsi_Host *host,
-    Scsi_Device *scsi_devs)
+void
+aic7xxx_slave_detach(Scsi_Device *sdpnt)
 {
-  Scsi_Device *device;
-  struct aic7xxx_host *p = (struct aic7xxx_host *) host->hostdata;
-  int scbnum;
+  struct aic7xxx_host *p = (struct aic7xxx_host *) sdpnt->host->hostdata;
+  int lun, tindex;
+
+  tindex = sdpnt->id | (sdpnt->channel << 3);
+  lun = sdpnt->lun;
+  if(p->Scsi_Dev[tindex][lun] == NULL)
+    return;
 
-  scbnum = 0;
-  for (device = scsi_devs; device != NULL; device = device->next)
+  if(p->tagenable & (1 << tindex))
   {
-    if (device->host == host)
-    {
-      scbnum += aic7xxx_device_queue_depth(p, device);
-    }
+    p->dev_max_queue_depth[tindex] -= p->dev_lun_queue_depth[tindex];
+    if(p->dev_temp_queue_depth[tindex] > p->dev_max_queue_depth[tindex])
+      p->dev_temp_queue_depth[tindex] = p->dev_max_queue_depth[tindex];
   }
+  p->dev_scbs_needed[tindex] -= p->dev_lun_queue_depth[tindex];
+  p->Scsi_Dev[tindex][lun] = NULL;
+  return;
+}
+
+/*+F*************************************************************************
+ * Function:
+ *   aic7xxx_slave_attach
+ *
+ * Description:
+ *   Configure the device we are attaching to the controller.  This is
+ *   where we get to do things like scan the INQUIRY data, set queue
+ *   depths, allocate command structs, etc.
+ *-F*************************************************************************/
+int
+aic7xxx_slave_attach(Scsi_Device *sdpnt)
+{
+  struct aic7xxx_host *p = (struct aic7xxx_host *) sdpnt->host->hostdata;
+  int scbnum, tindex, i;
+
+  tindex = sdpnt->id | (sdpnt->channel << 3);
+  p->dev_flags[tindex] |= DEVICE_PRESENT;
+
+  p->Scsi_Dev[tindex][sdpnt->lun] = sdpnt;
+  aic7xxx_device_queue_depth(p, sdpnt);
+
+  for(i = 0, scbnum = 0; i < p->host->max_id; i++)
+    scbnum += p->dev_scbs_needed[i];
   while (scbnum > p->scb_data->numscbs)
   {
     /*
@@ -7149,8 +7158,77 @@
      * the SCB in order to perform a swap operation (possible deadlock)
      */
     if ( aic7xxx_allocate_scb(p) == 0 )
-      return;
+      break;
+  }
+
+  /*
+   * We only need to check INQUIRY data on one lun of multi lun devices
+   * since speed negotiations are not lun specific.  Once we've check this
+   * particular target id once, the DEVICE_PRESENT flag will be set.
+   */
+  if (!(p->dev_flags[tindex] & DEVICE_DTR_SCANNED))
+  {
+    p->dev_flags[tindex] |= DEVICE_DTR_SCANNED;
+
+    if ( sdpnt->wdtr && (p->features & AHC_WIDE) )
+    {
+      p->needwdtr |= (1<<tindex);
+      p->needwdtr_copy |= (1<<tindex);
+      p->transinfo[tindex].goal_width = p->transinfo[tindex].user_width;
+    }
+    else
+    {
+      p->needwdtr &= ~(1<<tindex);
+      p->needwdtr_copy &= ~(1<<tindex);
+      pause_sequencer(p);
+      aic7xxx_set_width(p, sdpnt->id, sdpnt->channel, sdpnt->lun,
+                        MSG_EXT_WDTR_BUS_8_BIT, (AHC_TRANS_ACTIVE |
+                                                 AHC_TRANS_GOAL |
+                                                 AHC_TRANS_CUR) );
+      unpause_sequencer(p, FALSE);
+    }
+    if ( sdpnt->sdtr && p->transinfo[tindex].user_offset )
+    {
+      p->transinfo[tindex].goal_period = p->transinfo[tindex].user_period;
+      p->transinfo[tindex].goal_options = p->transinfo[tindex].user_options;
+      if (p->features & AHC_ULTRA2)
+        p->transinfo[tindex].goal_offset = MAX_OFFSET_ULTRA2;
+      else if (p->transinfo[tindex].goal_width == MSG_EXT_WDTR_BUS_16_BIT)
+        p->transinfo[tindex].goal_offset = MAX_OFFSET_16BIT;
+      else
+        p->transinfo[tindex].goal_offset = MAX_OFFSET_8BIT;
+      if ( sdpnt->ppr && p->transinfo[tindex].user_period <= 9 &&
+             p->transinfo[tindex].user_options )
+      {
+        p->needppr |= (1<<tindex);
+        p->needppr_copy |= (1<<tindex);
+        p->needsdtr &= ~(1<<tindex);
+        p->needsdtr_copy &= ~(1<<tindex);
+        p->needwdtr &= ~(1<<tindex);
+        p->needwdtr_copy &= ~(1<<tindex);
+        p->dev_flags[tindex] |= DEVICE_SCSI_3;
+      }
+      else
+      {
+        p->needsdtr |= (1<<tindex);
+        p->needsdtr_copy |= (1<<tindex);
+        p->transinfo[tindex].goal_period = 
+          MAX(10, p->transinfo[tindex].goal_period);
+        p->transinfo[tindex].goal_options = 0;
+      }
+    }
+    else
+    {
+      p->needsdtr &= ~(1<<tindex);
+      p->needsdtr_copy &= ~(1<<tindex);
+      p->transinfo[tindex].goal_period = 255;
+      p->transinfo[tindex].goal_offset = 0;
+      p->transinfo[tindex].goal_options = 0;
+    }
+    p->dev_flags[tindex] |= DEVICE_PRINT_DTR;
   }
+
+  return(0);
 }
 
 /*+F*************************************************************************
@@ -8247,7 +8325,6 @@
   host->can_queue = AIC7XXX_MAXSCB;
   host->cmd_per_lun = 3;
   host->sg_tablesize = AIC7XXX_MAX_SG;
-  host->select_queue_depths = aic7xxx_select_queue_depth;
   host->this_id = p->scsi_id;
   host->io_port = p->base;
   host->n_io_port = 0xFF;
--- 2.5/drivers/scsi/hosts.h.queue	2002-10-01 15:46:04.000000000 -0400
+++ 2.5/drivers/scsi/hosts.h	2002-10-01 19:19:37.000000000 -0400
@@ -97,6 +97,10 @@
      */
     int (* detect)(struct SHT *);
 
+    /*
+     * This function is only used by one driver and will be going away
+     * once it switches over to using the slave_detach() function instead.
+     */
     int (*revoke)(Scsi_Device *);
 
     /* Used with loadable modules to unload the host structures.  Note:
@@ -200,11 +204,59 @@
     int (* reset)(Scsi_Cmnd *, unsigned int);
 
     /*
-     * This function is used to select synchronous communications,
-     * which will result in a higher data throughput.  Not implemented
-     * yet.
+     * Once the device has responded to an INQUIRY and we know the device
+     * is online, call into the low level driver with the Scsi_Device *
+     * (so that the low level driver may save it off in a safe location
+     * for later use in calling scsi_adjust_queue_depth() or possibly
+     * other scsi_* functions) and char * to the INQUIRY return data buffer.
+     * This way, low level drivers will no longer have to snoop INQUIRY data
+     * to see if a drive supports PPR message protocol for Ultra160 speed
+     * negotiations or other similar items.  Instead it can simply wait until
+     * the scsi mid layer calls them with the data in hand and then it can
+     * do it's checking of INQUIRY data.  This will happen once for each new
+     * device added on this controller (including once for each lun on
+     * multi-lun devices, so low level drivers should take care to make
+     * sure that if they do tagged queueing on a per physical unit basis
+     * instead of a per logical unit basis that they have the mid layer
+     * allocate tags accordingly).
+     *
+     * Things currently recommended to be handled at this time include:
+     *
+     * 1.  Checking for tagged queueing capability and if able then calling
+     *     scsi_adjust_queue_depth() with the device pointer and the
+     *     suggested new queue depth.
+     * 2.  Checking for things such as SCSI level or DT bit in order to
+     *     determine if PPR message protocols are appropriate on this
+     *     device (or any other scsi INQUIRY data specific things the
+     *     driver wants to know in order to properly handle this device).
+     * 3.  Allocating command structs that the device will need.
+     * 4.  Setting the default timeout on this device (if needed).
+     * 5.  Saving the Scsi_Device pointer so that the low level driver
+     *     will be able to easily call back into scsi_adjust_queue_depth
+     *     again should it be determined that the queue depth for this
+     *     device should be lower or higher than it is initially set to.
+     * 6.  Allocate device data structures as needed that can be attached
+     *     to the Scsi_Device * via SDpnt->host_device_ptr
+     * 7.  Anything else the low level driver might want to do on a device
+     *     specific setup basis...
+     * 8.  Return 0 on success, non-0 on error.  The device will be marked
+     *     as offline on error so that no access will occur.
+     */
+    int (* slave_attach)(Scsi_Device *);
+
+    /*
+     * If we are getting ready to remove a device from the scsi chain then
+     * we call into the low level driver to let them know.  Once a low
+     * level driver has been informed that a drive is going away, the low
+     * level driver *must* remove it's pointer to the Scsi_Device because
+     * it is going to be kfree()'ed shortly.  It is no longer safe to call
+     * any mid layer functions with this Scsi_Device *.  Additionally, the
+     * mid layer will not make any more calls into the low level driver's
+     * queue routine with this device, so it is safe for the device driver
+     * to deallocate all structs/commands/etc that is has allocated
+     * specifically for this device at the time of this call.
      */
-    int (* slave_attach)(int, int);
+    void (* slave_detach)(Scsi_Device *);
 
     /*
      * This function determines the bios parameters for a given
@@ -217,6 +269,8 @@
 
     /*
      * Used to set the queue depth for a specific device.
+     *
+     * Once the slave_attach() function is in full use, this will go away.
      */
     void (*select_queue_depths)(struct Scsi_Host *, Scsi_Device *);
 
--- 2.5/drivers/scsi/scsi.c.queue	2002-10-01 15:46:06.000000000 -0400
+++ 2.5/drivers/scsi/scsi.c	2002-10-01 19:22:12.000000000 -0400
@@ -551,6 +551,7 @@
 {
 	unsigned long flags;
         Scsi_Device * SDpnt;
+	int alloc_cmd = 0;
 
 	spin_lock_irqsave(&device_request_lock, flags);
 
@@ -567,6 +568,25 @@
 				   atomic_read(&SCpnt->host->host_active),
 				   SCpnt->host->host_failed));
 
+	if(SDpnt->queue_depth > SDpnt->new_queue_depth) {
+		Scsi_Cmnd *prev, *next;
+		/*
+		 * Release the command block and decrement the queue
+		 * depth.
+		 */
+		for(prev = NULL, next = SDpnt->device_queue;
+				next != SCpnt;
+				prev = next, next = next->next) ;
+		if(prev == NULL)
+			SDpnt->device_queue = next->next;
+		else
+			prev->next = next->next;
+		kfree((char *)SCpnt);
+		SDpnt->queue_depth--;
+	} else if(SDpnt->queue_depth < SDpnt->new_queue_depth) {
+		alloc_cmd = 1;
+		SDpnt->queue_depth++;
+	}
 	spin_unlock_irqrestore(&device_request_lock, flags);
 
         /*
@@ -575,6 +595,48 @@
          * they wake up.  
          */
 	wake_up(&SDpnt->scpnt_wait);
+
+	/*
+	 * We are happy to release command blocks in the scope of the
+	 * device_request_lock since that's nice and quick, but allocation
+	 * can take more time so do it outside that scope instead.
+	 */
+	if(alloc_cmd) {
+		Scsi_Cmnd *newSCpnt;
+
+		newSCpnt = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
+				(SDpnt->host->unchecked_isa_dma ?
+				 GFP_DMA : 0));
+		if(newSCpnt) {
+			memset(newSCpnt, 0, sizeof(Scsi_Cmnd));
+			newSCpnt->host = SDpnt->host;
+			newSCpnt->device = SDpnt;
+			newSCpnt->target = SDpnt->id;
+			newSCpnt->lun = SDpnt->lun;
+			newSCpnt->channel = SDpnt->channel;
+			newSCpnt->request = NULL;
+			newSCpnt->use_sg = 0;
+			newSCpnt->old_use_sg = 0;
+			newSCpnt->old_cmd_len = 0;
+			newSCpnt->underflow = 0;
+			newSCpnt->old_underflow = 0;
+			newSCpnt->transfersize = 0;
+			newSCpnt->resid = 0;
+			newSCpnt->serial_number = 0;
+			newSCpnt->serial_number_at_timeout = 0;
+			newSCpnt->host_scribble = NULL;
+			newSCpnt->state = SCSI_STATE_UNUSED;
+			newSCpnt->owner = SCSI_OWNER_NOBODY;
+			spin_lock_irqsave(&device_request_lock, flags);
+			newSCpnt->next = SDpnt->device_queue;
+			SDpnt->device_queue = newSCpnt;
+			spin_unlock_irqrestore(&device_request_lock, flags);
+		} else {
+			spin_lock_irqsave(&device_request_lock, flags);
+			SDpnt->queue_depth--;
+			spin_unlock_irqrestore(&device_request_lock, flags);
+		}
+	}
 }
 
 /*
@@ -1455,8 +1517,8 @@
 		SDpnt->device_queue = SCnext = SCpnt->next;
 		kfree((char *) SCpnt);
 	}
-	SDpnt->has_cmdblocks = 0;
 	SDpnt->queue_depth = 0;
+	SDpnt->new_queue_depth = 0;
 	spin_unlock_irqrestore(&device_request_lock, flags);
 }
 
@@ -1471,63 +1533,115 @@
  *
  * Lock status: No locking assumed or required.
  *
- * Notes:
+ * Notes:	We really only allocate one command here.  We will allocate
+ *		more commands as needed once the device goes into real use.
  */
 void scsi_build_commandblocks(Scsi_Device * SDpnt)
 {
 	unsigned long flags;
-	struct Scsi_Host *host = SDpnt->host;
-	int j;
 	Scsi_Cmnd *SCpnt;
 
+	if (SDpnt->queue_depth != 0)
+		return;
+		
+	SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
+			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
+	if (NULL == SCpnt) {
+		/*
+		 * Since we don't currently have *any* command blocks on this
+		 * device, go ahead and try an atomic allocation...
+		 */
+		SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
+			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
+		if (NULL == SCpnt)
+			return;	/* Oops, we aren't going anywhere for now */
+	}
+
+	memset(SCpnt, 0, sizeof(Scsi_Cmnd));
+	SCpnt->host = SDpnt->host;
+	SCpnt->device = SDpnt;
+	SCpnt->target = SDpnt->id;
+	SCpnt->lun = SDpnt->lun;
+	SCpnt->channel = SDpnt->channel;
+	SCpnt->request = NULL;
+	SCpnt->use_sg = 0;
+	SCpnt->old_use_sg = 0;
+	SCpnt->old_cmd_len = 0;
+	SCpnt->underflow = 0;
+	SCpnt->old_underflow = 0;
+	SCpnt->transfersize = 0;
+	SCpnt->resid = 0;
+	SCpnt->serial_number = 0;
+	SCpnt->serial_number_at_timeout = 0;
+	SCpnt->host_scribble = NULL;
+	SCpnt->state = SCSI_STATE_UNUSED;
+	SCpnt->owner = SCSI_OWNER_NOBODY;
 	spin_lock_irqsave(&device_request_lock, flags);
+	if(SDpnt->new_queue_depth == 0)
+		SDpnt->new_queue_depth = 1;
+	SDpnt->queue_depth++;
+	SCpnt->next = SDpnt->device_queue;
+	SDpnt->device_queue = SCpnt;
+	spin_unlock_irqrestore(&device_request_lock, flags);
+}
 
-	if (SDpnt->queue_depth == 0)
+/*
+ * Function:	scsi_adjust_queue_depth()
+ *
+ * Purpose:	Allow low level drivers to tell us to change the queue depth
+ * 		on a specific SCSI device
+ *
+ * Arguments:	SDpnt	- SCSI Device in question
+ * 		tagged	- Do we use tagged queueing (non-0) or do we treat
+ * 			  this device as an untagged device (0)
+ * 		tags	- Number of tags allowed if tagged queueing enabled,
+ * 			  or number of commands the low level driver can
+ * 			  queue up in non-tagged mode (as per cmd_per_lun).
+ *
+ * Returns:	Nothing
+ *
+ * Lock Status:	None held on entry
+ *
+ * Notes:	Low level drivers may call this at any time and we will do
+ * 		the right thing depending on whether or not the device is
+ * 		currently active and whether or not it even has the
+ * 		command blocks built yet.
+ *
+ * 		If cmdblocks != 0 then we are a live device.  We just set the
+ * 		new_queue_depth variable and when the scsi completion handler
+ * 		notices that queue_depth != new_queue_depth it will work to
+ *		rectify the situation.  If new_queue_depth is less than current
+ *		queue_depth, then it will free the completed command instead of
+ *		putting it back on the free list and dec queue_depth.  Otherwise
+ *		it will try to allocate a new command block for the device and
+ *		put it on the free list along with the command that is being
+ *		completed.  Obviously, if the device isn't doing anything then
+ *		neither is this code, so it will bring the devices queue depth
+ *		back into line when the device is actually being used.  This
+ *		keeps us from needing to fire off a kernel thread or some such
+ *		nonsense (this routine can be called from interrupt code, so
+ *		handling allocations here would be tricky and risky, making
+ *		a kernel thread a much safer way to go if we wanted to handle
+ *		the work immediately instead of letting it get done a little
+ *		at a time in the completion handler).
+ */
+void scsi_adjust_queue_depth(Scsi_Device *SDpnt, int tagged, int tags)
+{
+	unsigned long flags;
+
+	/*
+	 * refuse to set tagged depth to an unworkable size
+	 */
+	if(tags == 0)
+		return;
+	spin_lock_irqsave(&device_request_lock, flags);
+	SDpnt->new_queue_depth = tags;
+	SDpnt->tagged_queue = tagged;
+	spin_unlock_irqrestore(&device_request_lock, flags);
+	if(SDpnt->queue_depth == 0)
 	{
-		SDpnt->queue_depth = host->cmd_per_lun;
-		if (SDpnt->queue_depth == 0)
-			SDpnt->queue_depth = 1; /* live to fight another day */
-	}
-	SDpnt->device_queue = NULL;
-
-	for (j = 0; j < SDpnt->queue_depth; j++) {
-		SCpnt = (Scsi_Cmnd *)
-		    kmalloc(sizeof(Scsi_Cmnd),
-				     GFP_ATOMIC |
-				(host->unchecked_isa_dma ? GFP_DMA : 0));
-		if (NULL == SCpnt)
-			break;	/* If not, the next line will oops ... */
-		memset(SCpnt, 0, sizeof(Scsi_Cmnd));
-		SCpnt->host = host;
-		SCpnt->device = SDpnt;
-		SCpnt->target = SDpnt->id;
-		SCpnt->lun = SDpnt->lun;
-		SCpnt->channel = SDpnt->channel;
-		SCpnt->request = NULL;
-		SCpnt->use_sg = 0;
-		SCpnt->old_use_sg = 0;
-		SCpnt->old_cmd_len = 0;
-		SCpnt->underflow = 0;
-		SCpnt->old_underflow = 0;
-		SCpnt->transfersize = 0;
-		SCpnt->resid = 0;
-		SCpnt->serial_number = 0;
-		SCpnt->serial_number_at_timeout = 0;
-		SCpnt->host_scribble = NULL;
-		SCpnt->next = SDpnt->device_queue;
-		SDpnt->device_queue = SCpnt;
-		SCpnt->state = SCSI_STATE_UNUSED;
-		SCpnt->owner = SCSI_OWNER_NOBODY;
-	}
-	if (j < SDpnt->queue_depth) {	/* low on space (D.Gilbert 990424) */
-		printk(KERN_WARNING "scsi_build_commandblocks: want=%d, space for=%d blocks\n",
-		       SDpnt->queue_depth, j);
-		SDpnt->queue_depth = j;
-		SDpnt->has_cmdblocks = (0 != j);
-	} else {
-		SDpnt->has_cmdblocks = 1;
+		scsi_build_commandblocks(SDpnt);
 	}
-	spin_unlock_irqrestore(&device_request_lock, flags);
 }
 
 void __init scsi_host_no_insert(char *str, int n)
@@ -1766,13 +1880,6 @@
 			goto out;	/* We do not yet support unplugging */
 
 		scan_scsis(HBA_ptr, 1, channel, id, lun);
-
-		/* FIXME (DB) This assumes that the queue_depth routines can be used
-		   in this context as well, while they were all designed to be
-		   called only once after the detect routine. (DB) */
-		/* queue_depth routine moved to inside scan_scsis(,1,,,) so
-		   it is called before build_commandblocks() */
-
 		err = length;
 		goto out;
 	}
@@ -1834,6 +1941,8 @@
 			 */
                         if (HBA_ptr->hostt->revoke)
                                 HBA_ptr->hostt->revoke(scd);
+			if (HBA_ptr->hostt->slave_detach)
+				(*HBA_ptr->hostt->slave_detach) (scd);
 			devfs_unregister (scd->de);
 			scsi_release_commandblocks(scd);
 
@@ -1993,7 +2099,7 @@
 							(*sdtpnt->attach) (SDpnt);
 					if (SDpnt->attached) {
 						scsi_build_commandblocks(SDpnt);
-						if (0 == SDpnt->has_cmdblocks)
+						if (SDpnt->queue_depth == 0)
 							out_of_space = 1;
 					}
 				}
@@ -2124,6 +2230,8 @@
 				printk(KERN_ERR "Attached usage count = %d\n", SDpnt->attached);
 				goto err_out;
 			}
+			if (shpnt->hostt->slave_detach)
+				(*shpnt->hostt->slave_detach) (SDpnt);
 			devfs_unregister (SDpnt->de);
 			put_device(&SDpnt->sdev_driverfs_dev);
 		}
@@ -2280,10 +2388,10 @@
 			 * If this driver attached to the device, and don't have any
 			 * command blocks for this device, allocate some.
 			 */
-			if (SDpnt->attached && SDpnt->has_cmdblocks == 0) {
+			if (SDpnt->attached && SDpnt->queue_depth == 0) {
 				SDpnt->online = TRUE;
 				scsi_build_commandblocks(SDpnt);
-				if (0 == SDpnt->has_cmdblocks)
+				if (SDpnt->queue_depth == 0)
 					out_of_space = 1;
 			}
 		}
@@ -2333,6 +2441,8 @@
 				 * Nobody is using this device any more.  Free all of the
 				 * command structures.
 				 */
+				if (shpnt->hostt->slave_detach)
+					(*shpnt->hostt->slave_detach) (SDpnt);
 				scsi_release_commandblocks(SDpnt);
 			}
 		}
@@ -2686,9 +2796,13 @@
         SDpnt->host = SHpnt;
         SDpnt->id = SHpnt->this_id;
         SDpnt->type = -1;
-        SDpnt->queue_depth = 1;
+	SDpnt->new_queue_depth = 1;
         
 	scsi_build_commandblocks(SDpnt);
+	if(SDpnt->queue_depth == 0) {
+		kfree(SDpnt);
+		return NULL;
+	}
 
 	scsi_initialize_queue(SDpnt, SHpnt);
 
--- 2.5/drivers/scsi/scsi.h.queue	2002-10-01 15:46:04.000000000 -0400
+++ 2.5/drivers/scsi/scsi.h	2002-10-01 19:19:37.000000000 -0400
@@ -481,6 +481,7 @@
 extern void scsi_bottom_half_handler(void);
 extern void scsi_release_commandblocks(Scsi_Device * SDpnt);
 extern void scsi_build_commandblocks(Scsi_Device * SDpnt);
+extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);
@@ -563,6 +564,8 @@
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
 	Scsi_Cmnd *device_queue;	/* queue of SCSI Command structures */
         Scsi_Cmnd *current_cmnd;	/* currently active command */
+	unsigned short queue_depth;	/* How deep of a queue we have */
+	unsigned short new_queue_depth; /* How deep of a queue we want */
 
 	unsigned int id, lun, channel;
 
@@ -586,24 +589,25 @@
 	unsigned char current_tag;	/* current tag */
 	unsigned char sync_min_period;	/* Not less than this period */
 	unsigned char sync_max_offset;	/* Not greater than this offset */
-	unsigned char queue_depth;	/* How deep a queue to use */
 
 	unsigned online:1;
 	unsigned writeable:1;
 	unsigned removable:1;
 	unsigned random:1;
-	unsigned has_cmdblocks:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
 	unsigned lockable:1;	/* Able to prevent media removal */
 	unsigned borken:1;	/* Tell the Seagate driver to be 
 				 * painfully slow on this device */
-	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
-	unsigned tagged_queue:1;	/* SCSI-II tagged queuing enabled */
 	unsigned disconnect:1;	/* can disconnect */
 	unsigned soft_reset:1;	/* Uses soft reset option */
-	unsigned sync:1;	/* Negotiate for sync transfers */
-	unsigned wide:1;	/* Negotiate for WIDE transfers */
+	unsigned sdtr:1;	/* Device supports SDTR messages */
+	unsigned wdtr:1;	/* Device supports WDTR messages */
+	unsigned ppr:1;		/* Device supports PPR messages */
+	unsigned tagged_supported:1;	/* Supports SCSI-II tagged queuing */
+	unsigned tagged_queue:1;	/* SCSI-II tagged queuing enabled */
+	unsigned simple_tags:1;	/* Device supports simple queue tag messages */
+	unsigned ordered_tags:1;/* Device supports ordered queue tag messages */
 	unsigned single_lun:1;	/* Indicates we should only allow I/O to
 				 * one of the luns for the device at a 
 				 * time. */
--- 2.5/drivers/scsi/scsi_scan.c.queue	2002-08-27 19:50:45.000000000 -0400
+++ 2.5/drivers/scsi/scsi_scan.c	2002-10-01 19:19:37.000000000 -0400
@@ -1409,6 +1409,14 @@
 	sdev->lockable = sdev->removable;
 	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
 
+	if (sdev->scsi_level >= SCSI_3 || (sdev->inquiry_len > 56 &&
+		inq_result[56] & 0x04))
+		sdev->ppr = 1;
+	if (inq_result[7] & 0x60)
+		sdev->wdtr = 1;
+	if (inq_result[7] & 0x10)
+		sdev->sdtr = 1;
+
 	/*
 	 * XXX maybe move the identifier and driverfs/devfs setup to a new
 	 * function, and call them after this function is called.
@@ -1509,9 +1517,9 @@
 	 * XXX maybe change scsi_release_commandblocks to not reset
 	 * queue_depth to 0.
 	 */
-	sdevscan->queue_depth = 1;
+	sdevscan->new_queue_depth = 1;
 	scsi_build_commandblocks(sdevscan);
-	if (sdevscan->has_cmdblocks == 0)
+	if (sdevscan->queue_depth == 0)
 		goto alloc_failed;
 
 	sreq = scsi_allocate_request(sdevscan);
@@ -1585,7 +1593,7 @@
 		kfree(scsi_result);
 	if (sreq != NULL)
 		scsi_release_request(sreq);
-	if (sdevscan->has_cmdblocks != 0)
+	if (sdevscan->queue_depth != 0)
 		scsi_release_commandblocks(sdevscan);
 	return SCSI_SCAN_NO_RESPONSE;
 }
@@ -1739,9 +1747,9 @@
 	if (sdevscan->scsi_level < SCSI_3)
 		return 1;
 
-	sdevscan->queue_depth = 1;
+	sdevscan->new_queue_depth = 1;
 	scsi_build_commandblocks(sdevscan);
-	if (sdevscan->has_cmdblocks == 0) {
+	if (sdevscan->queue_depth == 0) {
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 		/*
 		 * We are out of memory, don't try scanning any further.
@@ -2014,6 +2022,17 @@
 		 */
 		if (shost->select_queue_depths != NULL)
 			(shost->select_queue_depths) (shost, shost->host_queue);
+		if (shost->hostt->slave_attach != NULL)
+			if ((shost->hostt->slave_attach) (sdev) != 0) {
+				/*
+				 * Low level driver failed to attach this
+				 * device, we've got to kick it back out
+				 * now as a result :-(
+				 */
+				printk("scsi_scan_selected_lun: slave_attach "
+					"failed, marking device OFFLINE.\n");
+				sdev->online = FALSE;
+			}
 
 		for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
 			if (sdt->init && sdt->dev_noticed)
@@ -2024,7 +2043,7 @@
 				(*sdt->attach) (sdev);
 				if (sdev->attached) {
 					scsi_build_commandblocks(sdev);
-					if (sdev->has_cmdblocks == 0)
+					if (sdev->queue_depth == 0)
 						printk(ALLOC_FAILURE_MSG,
 						       __FUNCTION__);
 				}
--- 2.5/drivers/scsi/scsi_syms.c.queue	2002-10-01 19:26:44.000000000 -0400
+++ 2.5/drivers/scsi/scsi_syms.c	2002-10-01 19:27:24.000000000 -0400
@@ -66,6 +66,7 @@
 EXPORT_SYMBOL(scsi_report_bus_reset);
 EXPORT_SYMBOL(scsi_block_requests);
 EXPORT_SYMBOL(scsi_unblock_requests);
+EXPORT_SYMBOL(scsi_adjust_queue_depth);
 
 EXPORT_SYMBOL(scsi_get_host_dev);
 EXPORT_SYMBOL(scsi_free_host_dev);

--jRHKVT23PllUwdXP--
