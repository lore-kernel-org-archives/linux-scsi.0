From: "Mukker, Atul" <atulm@lsil.com>
Subject: RE: (PATCH)The megaraid driver v2.00.5 for kernel 2.4
Date: Tue, 29 Jul 2003 19:14:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570185F3B0@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46836 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S271820AbTG2Xhn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 19:37:43 -0400
Received: from mhbs.lsil.com (mhbs.lsil.com [147.145.31.100])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id h6TNHrGr020808
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2003 16:36:17 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: 'Alan Cox' <alan@redhat.com>
Cc: willy@debian.org, "Mukker, Atul" <Atulm@lsil.com>, Matt_Domsch@dell.com, haruo.tomita@toshiba.co.jp, linux-megaraid-devel@dell.com, linux-scsi@vger.kernel.org

> > A final patch is resent.  Alan, please apply.
> 
> If Atul okays it sure

Tomita San, before I can incorporate your suggestions into the driver - I
will need the patch as an attachment not embedded in the mail. Your mailer
seems to play funny tricks with the formatting of code.

Also note down my comments on this patch.

diff -Nru linux-2.4.22-pre6-ac1/drivers/scsi/megaraid2.c
linux-2.4.22-pre6-ac1-mr/drivers/scsi/megaraid2.c
--- linux-2.4.22-pre6-ac1/drivers/scsi/megaraid2.c      2003-07-24
10:27:17.000000000 +0900
+++ linux-2.4.22-pre6-ac1-mr/drivers/scsi/megaraid2.c   2003-07-24
12:38:36.000000000 +0900
@@ -49,6 +49,10 @@
 MODULE_DESCRIPTION ("LSI Logic MegaRAID driver");
 MODULE_LICENSE ("GPL");

+static unsigned int max_commands = MAX_COMMANDS;
+MODULE_PARM(max_commands, "i");
+MODULE_PARM_DESC(max_commands, "Maximum number of commands which can be
issued to a single controller (default=MAX_COMMANDS=126)");
+
AM> this is not allowed anymore. Driver has placed a hard limit on the
maximum queue depth for the pending commands. This is done because of a
requirement from the firmware.


 static unsigned int max_cmd_per_lun = DEF_CMD_PER_LUN;
 MODULE_PARM(max_cmd_per_lun, "i");
 MODULE_PARM_DESC(max_cmd_per_lun, "Maximum number of commands which can be
issued to a single LUN (default=DEF_CMD_PER_LUN=63)");
@@ -122,6 +126,8 @@
 static void
 megaraid_validate_parms(void)
 {
+        if( (max_commands <= 0) || (max_commands > MAX_COMMANDS) )
+                max_commands = MAX_COMMANDS;
AM> Same as above

     if( (max_cmd_per_lun <= 0) || (max_cmd_per_lun > MAX_CMD_PER_LUN) )
          max_cmd_per_lun = MAX_CMD_PER_LUN;
     if( max_mbox_busy_wait > MBOX_BUSY_WAIT )
@@ -380,7 +386,6 @@
          INIT_LIST_HEAD(&adapter->pending_list);

          adapter->flag = flag;
-         spin_lock_init(&adapter->lock);
AM> Probably ok.

          host->cmd_per_lun = max_cmd_per_lun;
          host->max_sectors = max_sectors_per_io;
@@ -838,8 +843,8 @@

     adapter->max_cmds = adapter->product_info.max_commands;

-    if(adapter->max_cmds > MAX_COMMANDS)
-         adapter->max_cmds = MAX_COMMANDS;
+    if(adapter->max_cmds > max_commands)
+         adapter->max_cmds = max_commands;
AM> Not allowed anymore.

     adapter->host->can_queue = adapter->max_cmds - 1;

@@ -1098,7 +1103,6 @@

               scb->raw_mbox[0] = MEGA_CLUSTER_CMD;
               scb->raw_mbox[2] = MEGA_RESERVATION_STATUS;
-              scb->raw_mbox[3] = ldrv_num;
AM> This is not valid. Reservation status should be inquired per logical
drive basis.

               scb->dma_direction = PCI_DMA_NONE;

@@ -1707,7 +1711,8 @@
          while((volatile u8)mbox->numstatus == 0xFF)
               cpu_relax();

-         mbox->numstatus = 0xFF;
AM> Not Valid. Driver uses this value for subsequent command.

+         while((volatile u8)mbox->status == 0xFF)
+              cpu_relax();
AM> Allowed

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
AM> Invalid. Driver needs to set this value to "invalid" 0xFF. Firmware sets
it to actual value.

-         status = adapter->mbox->status;
+         status = 0xFF;
+         while((status = (volatile u8)adapter->mbox->status)
+                   == 0xFF)
+              cpu_relax();
AM> Ok. Allowed.

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
AM> No No. This is required here.

-         while((nstatus = adapter->mbox->numstatus) == 0xFF) {
+         while((nstatus = (volatile u8)adapter->mbox->numstatus)
+                    == 0xFF)
               cpu_relax();
AM> OK

-         }
-         adapter->mbox->numstatus = 0xFF;
AM> Again, required.

-         status = adapter->mbox->status;
+         status = 0xFF;
+         while((status = (volatile u8)adapter->mbox->status)
+                    == 0xFF)
+              cpu_relax();
AM> OK.
          /*
           * decrement the pending queue counter
@@ -1898,6 +1907,7 @@
          memcpy(completed, (void *)adapter->mbox->completed, nstatus);

          /* Acknowledge interrupt */
+         WROUTDOOR(adapter, 0x10001234);
AM> Not allowed. Already done this.

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
AM> Not required anymore.

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
