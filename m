From: "haruo tomita" <haruo.tomita@toshiba.co.jp>
Subject: (PATCH)The megaraid driver v2.00.5 for kernel 2.4
Date: Tue, 29 Jul 2003 16:47:54 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307290752.QAA08889@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from inet-tsb.toshiba.co.jp ([202.33.96.40]:55800 "EHLO
	inet-tsb.toshiba.co.jp") by vger.kernel.org with ESMTP
	id S271329AbTG2HxO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 03:53:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org, atulm@lsil.com, Matt_Domsch@Dell.com, haruo.tomita@toshiba.co.jp
Cc: linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org

Dear All,

A final patch is resent.  Alan, please apply.


diff -Nru linux-2.4.22-pre6-ac1/drivers/scsi/megaraid2.c linux-2.4.22-pre6-ac1-mr/drivers/scsi/megaraid2.c
--- linux-2.4.22-pre6-ac1/drivers/scsi/megaraid2.c      2003-07-24 10:27:17.000000000 +0900
+++ linux-2.4.22-pre6-ac1-mr/drivers/scsi/megaraid2.c   2003-07-24 12:38:36.000000000 +0900
@@ -49,6 +49,10 @@
 MODULE_DESCRIPTION ("LSI Logic MegaRAID driver");
 MODULE_LICENSE ("GPL");

+static unsigned int max_commands = MAX_COMMANDS;
+MODULE_PARM(max_commands, "i");
+MODULE_PARM_DESC(max_commands, "Maximum number of commands which can be issued to a single controller (default=MAX_COMMANDS=126)");
+
 static unsigned int max_cmd_per_lun = DEF_CMD_PER_LUN;
 MODULE_PARM(max_cmd_per_lun, "i");
 MODULE_PARM_DESC(max_cmd_per_lun, "Maximum number of commands which can be issued to a single LUN (default=DEF_CMD_PER_LUN=63)");
@@ -122,6 +126,8 @@
 static void
 megaraid_validate_parms(void)
 {
+        if( (max_commands <= 0) || (max_commands > MAX_COMMANDS) )
+                max_commands = MAX_COMMANDS;
     if( (max_cmd_per_lun <= 0) || (max_cmd_per_lun > MAX_CMD_PER_LUN) )
          max_cmd_per_lun = MAX_CMD_PER_LUN;
     if( max_mbox_busy_wait > MBOX_BUSY_WAIT )
@@ -380,7 +386,6 @@
          INIT_LIST_HEAD(&adapter->pending_list);

          adapter->flag = flag;
-         spin_lock_init(&adapter->lock);

          host->cmd_per_lun = max_cmd_per_lun;
          host->max_sectors = max_sectors_per_io;
@@ -838,8 +843,8 @@

     adapter->max_cmds = adapter->product_info.max_commands;

-    if(adapter->max_cmds > MAX_COMMANDS)
-         adapter->max_cmds = MAX_COMMANDS;
+    if(adapter->max_cmds > max_commands)
+         adapter->max_cmds = max_commands;

     adapter->host->can_queue = adapter->max_cmds - 1;

@@ -1098,7 +1103,6 @@

               scb->raw_mbox[0] = MEGA_CLUSTER_CMD;
               scb->raw_mbox[2] = MEGA_RESERVATION_STATUS;
-              scb->raw_mbox[3] = ldrv_num;

               scb->dma_direction = PCI_DMA_NONE;

@@ -1707,7 +1711,8 @@
          while((volatile u8)mbox->numstatus == 0xFF)
               cpu_relax();

-         mbox->numstatus = 0xFF;
+         while((volatile u8)mbox->status == 0xFF)
+              cpu_relax();

          while( (volatile u8)mbox->poll != 0x77 )
               cpu_relax();
@@ -1758,7 +1763,7 @@
     unsigned long  flags;


-    spin_lock_irqsave(&adapter->lock, flags);
+    spin_lock_irqsave(&io_request_lock, flags);

     megaraid_iombox_ack_sequence(adapter);

@@ -1767,7 +1772,7 @@
          mega_runpendq(adapter);
     }

-    spin_unlock_irqrestore(&adapter->lock, flags);
+    spin_unlock_irqrestore(&io_request_lock, flags);

     return;
 }
@@ -1800,11 +1805,13 @@
          set_irq_state(adapter, byte);

          while((nstatus = (volatile u8)adapter->mbox->numstatus)
-                   == 0xFF)
+                    == 0xFF)
               cpu_relax();
-         adapter->mbox->numstatus = 0xFF;

-         status = adapter->mbox->status;
+         status = 0xFF;
+         while((status = (volatile u8)adapter->mbox->status)
+                   == 0xFF)
+              cpu_relax();

          /*
           * decrement the pending queue counter
@@ -1819,6 +1826,7 @@
          mega_cmd_done(adapter, completed, nstatus, status);

     } while(1);
+
 }


@@ -1839,7 +1847,7 @@
     unsigned long  flags;


-    spin_lock_irqsave(&adapter->lock, flags);
+    spin_lock_irqsave(&io_request_lock, flags);

     megaraid_memmbox_ack_sequence(adapter);

@@ -1848,7 +1856,7 @@
          mega_runpendq(adapter);
     }

-    spin_unlock_irqrestore(&adapter->lock, flags);
+    spin_unlock_irqrestore(&io_request_lock, flags);

     return;
 }
@@ -1881,14 +1889,15 @@
                */
               return;
          }
-         WROUTDOOR(adapter, 0x10001234);

-         while((nstatus = adapter->mbox->numstatus) == 0xFF) {
+         while((nstatus = (volatile u8)adapter->mbox->numstatus)
+                    == 0xFF)
               cpu_relax();
-         }
-         adapter->mbox->numstatus = 0xFF;

-         status = adapter->mbox->status;
+         status = 0xFF;
+         while((status = (volatile u8)adapter->mbox->status)
+                    == 0xFF)
+              cpu_relax();

          /*
           * decrement the pending queue counter
@@ -1898,6 +1907,7 @@
          memcpy(completed, (void *)adapter->mbox->completed, nstatus);

          /* Acknowledge interrupt */
+         WROUTDOOR(adapter, 0x10001234);
          WRINDOOR(adapter, 0x2);

          while( RDINDOOR(adapter) & 0x02 ) cpu_relax();
@@ -2597,7 +2607,7 @@

     adapter = (adapter_t *)scp->host->hostdata;

-    ASSERT( spin_is_locked(&adapter->lock) );
+    ASSERT( spin_is_locked(&io_request_lock) );

     printk("megaraid: aborting-%ld cmd=%x <c=%d t=%d l=%d>\n",
          scp->serial_number, scp->cmnd[0], scp->channel, scp->target,
@@ -2694,7 +2704,7 @@

     adapter = (adapter_t *)cmd->host->hostdata;

-    ASSERT( spin_is_locked(&adapter->lock) );
+    ASSERT( spin_is_locked(&io_request_lock) );

     printk("megaraid: reset-%ld cmd=%x <c=%d t=%d l=%d>\n",
          cmd->serial_number, cmd->cmnd[0], cmd->channel, cmd->target,
@@ -2705,7 +2715,7 @@
     mc.cmd = MEGA_CLUSTER_CMD;
     mc.opcode = MEGA_RESET_RESERVATIONS;

-    spin_unlock_irq(&adapter->lock);
+    spin_unlock_irq(&io_request_lock);
     if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
          printk(KERN_WARNING
                    "megaraid: reservation reset failed.\n");
@@ -2713,7 +2723,7 @@
     else {
          printk(KERN_INFO "megaraid: reservation reset.\n");
     }
-    spin_lock_irq(&adapter->lock);
+    spin_lock_irq(&io_request_lock);
 #endif

     /*
@@ -2920,6 +2930,8 @@
               adapter->has_cluster);

     len += sprintf(page+len, "\nModule Parameters:\n");
+    len += sprintf(page+len, "max_commands       = %d\n",
+              max_commands);
     len += sprintf(page+len, "max_cmd_per_lun    = %d\n",
               max_cmd_per_lun);
     len += sprintf(page+len, "max_sectors_per_io = %d\n",
@@ -4917,7 +4929,7 @@
     scb_t *scb;
     int rval;

-    ASSERT( !spin_is_locked(&adapter->lock) );
+    ASSERT( !spin_is_locked(&io_request_lock) );

     /*
      * Stop sending commands to the controller, queue them internally.
@@ -4937,7 +4949,7 @@
     rval = mega_do_del_logdrv(adapter, logdrv);


-    spin_lock_irqsave(&adapter->lock, flags);
+    spin_lock_irqsave(&io_request_lock, flags);

     /*
      * If delete operation was successful, add 0x80 to the logical drive
@@ -4956,7 +4968,7 @@

     mega_runpendq(adapter);

-    spin_unlock_irqrestore(&adapter->lock, flags);
+    spin_unlock_irqrestore(&io_request_lock, flags);

     return rval;
 }
@@ -5504,11 +5516,11 @@
     /*
      * Get the lock only if the caller has not acquired it already
      */
-    if( ls == LOCK_INT ) spin_lock_irqsave(&adapter->lock, flags);
+    if( ls == LOCK_INT ) spin_lock_irqsave(&io_request_lock, flags);

     megaraid_queue(scmd, mega_internal_done);

-    if( ls == LOCK_INT ) spin_unlock_irqrestore(&adapter->lock, flags);
+    if( ls == LOCK_INT ) spin_unlock_irqrestore(&io_request_lock, flags);

     /*
      * Wait till this command finishes. Do not use


