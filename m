From: Doug Ledford <dledford@redhat.com>
Subject: [PATCH + RFC] Beginning of some updates to scsi mid layer
Date: Tue, 18 Jun 2002 20:47:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020618204753.A8597@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: torvalds@transmeta.com

Linus,

I've got some things queued up to start sending through to you as they 
pass my testing here.  However, I wanted to get some input from people to 
make sure that these are heading down paths people can agree with...

So, this first patch extends the slave_attach() function that Eric put as 
a stub in scsi.c long ago and then never used.  The idea is actually 
sound, it was just never implemented.  Specifically, the scsi upper layer 
knows when a device is ready to be used, but some of the limitations on 
that device are low level driver imposed (and sometimes the low level 
driver needs to know certain things about a device in order to act 
appropriately).  This patch makes it so that any time we attach a new 
device into the scsi chain, we call the scsi low level driver's 
slave_attach() routine.  This is where the low level driver should do 
things like look at the INQUIRY data to determine U160+ support, set queue 
depths, things like that.  When we are removing the device, we call the 
(new) slave_detach() routine in the driver.  The slave_detach will replace 
the revoke() routine once I've removed the usage of revoke() from the one 
and only driver that uses it.

Currently, the low level driver can:

1.  Poke into the INQUIRY data for sync speed info
2.  Set the queue depth on the device (using the new 
scsi_adjust_queue_depth function)
3.  Allocate any needed structs and such for this device

Future plans include allowing drivers to:

4.  Set the default timeout for the device (so RAID controllers can have 
their 60 second disk timeouts while non-RAID controllers can have their 
much shorter 5 to 10 second timeouts, really helps responsiveness of 
system in the face of any error conditions when using the non-RAID 
controllers)
5.  Configure other queueing parameters (queue type, ordering 
capabilities, etc. as appropriate in light of other changes I have in 
mind)
6.  Anything else that makes sense.

As mentioned, this adds a new scsi_adjust_queue_depth routine that lets 
the low level driver update the queue depth on a device at any point in 
time.  So, when Justin Gibbs' driver allocates a queue depth of 253 
commands on drive X, then finds out that drive X has a hard limit of 64, 
then we aren't continuing to waste 189 commands worth of allocated kernel 
memory that can never be effectively used.  Future plans here include 
linking this into the bio queueing so that adjusting the mid layer queue 
depth does the "right thing" in regards to the bio layer (for all I know 
it does already, I haven't gotten into the bio->scsi interface yet).

Once this stuff is in place, then my next goal is to get the queueing code 
in the mid layer up to useable standards (the goal is to be able to rip 
the buts of the QUEUE_FULL and BUSY handling out of my driver and still 
have the system do the "right thing" instead of my driver having it's own 
complete internal queue mechanism including timers and such like it does 
now).

Side note: the work I'm doing on the aic7xxx_old driver here is simply 
because that's the easiest sandbox for me to verify my changes, it doesn't 
imply that I'll be updating the driver in any meaningful way.

Comments?

--- linux-2.5.22/drivers/scsi/aic7xxx_old/aic7xxx.h.slave	Sun Jun 16 22:31:23 2002
+++ linux-2.5.22/drivers/scsi/aic7xxx_old/aic7xxx.h	Tue Jun 18 18:04:50 2002
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
 
--- linux-2.5.22/drivers/scsi/aic7xxx_old.c.slave	Sun Jun 16 22:31:31 2002
+++ linux-2.5.22/drivers/scsi/aic7xxx_old.c	Tue Jun 18 19:34:13 2002
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
@@ -7026,10 +6955,10 @@
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
 
@@ -7039,12 +6968,69 @@
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
@@ -7054,7 +7040,7 @@
     int tag_enabled = TRUE;
 
     default_depth = AIC7XXX_CMDS_PER_DEVICE;
- 
+
     if (!(p->discenable & target_mask))
     {
       if (aic7xxx_verbose & VERBOSE_NEGOTIATION2)
@@ -7075,7 +7061,7 @@
                            " the aic7xxx.c source file.\n");
           print_warning = FALSE;
         }
-        device->queue_depth = default_depth;
+        p->dev_lun_queue_depth[tindex] = default_depth;
       }
       else
       {
@@ -7083,19 +7069,18 @@
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
@@ -7103,46 +7088,70 @@
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
@@ -7151,8 +7160,91 @@
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
+#define WIDE_INQUIRY_BITS 0x60
+#define SYNC_INQUIRY_BITS 0x10
+#define SCSI_VERSION_BITS 0x07
+#define SCSI_DT_BIT       0x04
+
+    if ( (sdpnt->inquiry[7] & WIDE_INQUIRY_BITS) &&
+         (p->features & AHC_WIDE) )
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
+    if ( (sdpnt->inquiry[7] & SYNC_INQUIRY_BITS) &&
+          p->transinfo[tindex].user_offset )
+    {
+      p->transinfo[tindex].goal_period = p->transinfo[tindex].user_period;
+      p->transinfo[tindex].goal_options = p->transinfo[tindex].user_options;
+      if (p->features & AHC_ULTRA2)
+        p->transinfo[tindex].goal_offset = MAX_OFFSET_ULTRA2;
+      else if (p->transinfo[tindex].goal_width == MSG_EXT_WDTR_BUS_16_BIT)
+        p->transinfo[tindex].goal_offset = MAX_OFFSET_16BIT;
+      else
+        p->transinfo[tindex].goal_offset = MAX_OFFSET_8BIT;
+      if ( (((sdpnt->inquiry[2] & SCSI_VERSION_BITS) >= 3) ||
+             ((sdpnt->inquiry_len >= 57) && 
+	      (sdpnt->inquiry[56] & SCSI_DT_BIT)) ||
+             (p->dev_flags[tindex] & DEVICE_SCSI_3) ) &&
+             (p->transinfo[tindex].user_period <= 9) &&
+             (p->transinfo[tindex].user_options) )
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
+#undef WIDE_INQUIRY_BITS
+#undef SYNC_INQUIRY_BITS
+#undef SCSI_VERSION_BITS
+#undef SCSI_DT_BIT
   }
+
+  return(0);
 }
 
 /*+F*************************************************************************
@@ -8249,7 +8341,6 @@
   host->can_queue = AIC7XXX_MAXSCB;
   host->cmd_per_lun = 3;
   host->sg_tablesize = AIC7XXX_MAX_SG;
-  host->select_queue_depths = aic7xxx_select_queue_depth;
   host->this_id = p->scsi_id;
   host->io_port = p->base;
   host->n_io_port = 0xFF;
--- linux-2.5.22/drivers/scsi/hosts.h.slave	Sun Jun 16 22:31:29 2002
+++ linux-2.5.22/drivers/scsi/hosts.h	Tue Jun 18 18:04:50 2002
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
 
--- linux-2.5.22/drivers/scsi/scsi.c.slave	Sun Jun 16 22:31:33 2002
+++ linux-2.5.22/drivers/scsi/scsi.c	Tue Jun 18 20:29:43 2002
@@ -575,6 +575,54 @@
 		up(SCpnt->host->eh_wait);
 	}
 
+	if(SDpnt->queue_depth && SDpnt->queue_depth != SDpnt->new_queue_depth) {
+		if(SDpnt->new_queue_depth > SDpnt->queue_depth) {
+			Scsi_Cmnd *newSCpnt;
+
+			newSCpnt = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
+					(SDpnt->host->unchecked_isa_dma ?
+					 GFP_DMA : 0));
+			if(newSCpnt) {
+				memset(newSCpnt, 0, sizeof(Scsi_Cmnd));
+				newSCpnt->host = SDpnt->host;
+				newSCpnt->device = SDpnt;
+				newSCpnt->target = SDpnt->id;
+				newSCpnt->lun = SDpnt->lun;
+				newSCpnt->channel = SDpnt->channel;
+				newSCpnt->request.rq_status = RQ_INACTIVE;
+				newSCpnt->use_sg = 0;
+				newSCpnt->old_use_sg = 0;
+				newSCpnt->old_cmd_len = 0;
+				newSCpnt->underflow = 0;
+				newSCpnt->old_underflow = 0;
+				newSCpnt->transfersize = 0;
+				newSCpnt->resid = 0;
+				newSCpnt->serial_number = 0;
+				newSCpnt->serial_number_at_timeout = 0;
+				newSCpnt->host_scribble = NULL;
+				newSCpnt->next = SDpnt->device_queue;
+				SDpnt->device_queue = newSCpnt;
+				newSCpnt->state = SCSI_STATE_UNUSED;
+				newSCpnt->owner = SCSI_OWNER_NOBODY;
+				SDpnt->queue_depth++;
+			}
+		} else {
+			Scsi_Cmnd *prev, *next;
+			/*
+			 * Release the command block and decrement the queue
+			 * depth.
+			 */
+			SDpnt->queue_depth--;
+			for(prev = NULL, next = SDpnt->device_queue;
+					next != SCpnt;
+					prev = next, next = next->next) ;
+			if(prev == NULL)
+				SDpnt->device_queue = next->next;
+			else
+				prev->next = next->next;
+			kfree((char *)SCpnt);
+		}
+	}
 	spin_unlock_irqrestore(&device_request_lock, flags);
 
         /*
@@ -1514,6 +1562,60 @@
 	spin_unlock_irqrestore(&device_request_lock, flags);
 }
 
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
+	spin_lock_irqsave(&device_request_lock, flags);
+	SDpnt->new_queue_depth = tags;
+	SDpnt->tagged_queue = tagged;
+	if(SDpnt->has_cmdblocks == 0)
+	{
+		SDpnt->queue_depth = tags;
+	}
+	spin_unlock_irqrestore(&device_request_lock, flags);
+}
+
 void __init scsi_host_no_insert(char *str, int n)
 {
     Scsi_Host_Name *shn, *shn2;
@@ -1818,6 +1920,8 @@
 			 */
                         if (HBA_ptr->hostt->revoke)
                                 HBA_ptr->hostt->revoke(scd);
+			if (HBA_ptr->hostt->slave_detach)
+				(*HBA_ptr->hostt->slave_detach) (scd);
 			devfs_unregister (scd->de);
 			scsi_release_commandblocks(scd);
 
@@ -2100,6 +2204,8 @@
 				printk(KERN_ERR "Attached usage count = %d\n", SDpnt->attached);
 				goto err_out;
 			}
+			if (shpnt->hostt->slave_detach)
+				(*shpnt->hostt->slave_detach) (SDpnt);
 			devfs_unregister (SDpnt->de);
 		}
 	}
@@ -2307,6 +2413,8 @@
 				 * Nobody is using this device any more.  Free all of the
 				 * command structures.
 				 */
+				if (shpnt->hostt->slave_detach)
+					(*shpnt->hostt->slave_detach) (SDpnt);
 				scsi_release_commandblocks(SDpnt);
 			}
 		}
--- linux-2.5.22/drivers/scsi/scsi.h.slave	Sun Jun 16 22:31:27 2002
+++ linux-2.5.22/drivers/scsi/scsi.h	Tue Jun 18 18:04:50 2002
@@ -485,6 +485,7 @@
 extern void scsi_bottom_half_handler(void);
 extern void scsi_release_commandblocks(Scsi_Device * SDpnt);
 extern void scsi_build_commandblocks(Scsi_Device * SDpnt);
+extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);
@@ -562,10 +563,14 @@
 	wait_queue_head_t   scpnt_wait;	/* Used to wait if
 					   device is busy */
 	struct Scsi_Host *host;
+	void *host_device_ptr;	/* host private data ptr, can be alloc'ed on
+				   attach and free'ed on detach */
 	request_queue_t request_queue;
         atomic_t                device_active; /* commands checked out for device */
 	volatile unsigned short device_busy;	/* commands actually active on low-level */
 	Scsi_Cmnd *device_queue;	/* queue of SCSI Command structures */
+	unsigned char queue_depth;	/* How deep a queue to use */
+	unsigned char new_queue_depth;  /* If we need to raise/lower depth */
 
 	unsigned int id, lun, channel;
 
@@ -589,7 +594,6 @@
 	unsigned char current_tag;	/* current tag */
 	unsigned char sync_min_period;	/* Not less than this period */
 	unsigned char sync_max_offset;	/* Not greater than this offset */
-	unsigned char queue_depth;	/* How deep a queue to use */
 
 	unsigned online:1;
 	unsigned writeable:1;
--- linux-2.5.22/drivers/scsi/scsi_scan.c.slave	Sun Jun 16 22:31:35 2002
+++ linux-2.5.22/drivers/scsi/scsi_scan.c	Tue Jun 18 18:04:50 2002
@@ -860,6 +860,17 @@
 
 	scsi_release_commandblocks(SDpnt);
 
+	if(shpnt->hostt->slave_attach != NULL)
+		if((shpnt->hostt->slave_attach)(SDpnt) != 0) {
+			/*
+			 * Low level driver failed to attach this device,
+			 * we've got to kick it back out now :-(
+			 */
+			printk("scsi: scan_scsis_single: slave_attach failed, "
+				"marking OFF-LINE.\n");
+			SDpnt->online = FALSE;
+		}
+
 	/*
 	 * This device was already hooked up to the host in question,
 	 * so at this point we just let go of it and it should be fine.  We do need to
--- linux-2.5.22/drivers/scsi/scsi_syms.c.slave	Tue Jun 18 18:33:15 2002
+++ linux-2.5.22/drivers/scsi/scsi_syms.c	Tue Jun 18 18:34:44 2002
@@ -62,6 +62,7 @@
 EXPORT_SYMBOL(scsi_release_request);
 EXPORT_SYMBOL(scsi_wait_req);
 EXPORT_SYMBOL(scsi_do_req);
+EXPORT_SYMBOL(scsi_adjust_queue_depth);
 
 EXPORT_SYMBOL(scsi_report_bus_reset);
 EXPORT_SYMBOL(scsi_block_requests);

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
