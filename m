From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: [ANNOUNCE] megaraid 2.00.6 patch for kernels without hostlock
Date: Wed, 30 Jul 2003 17:00:26 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230C551@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

Please apply this patch to megaraid 2.00.6 driver for kernels that don't
support per host lock. This can be found at :

ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.00.6/

Sreenivas Bagalkote
LSI Logic

--- megaraid_2006/megaraid2.c	2003-07-30 14:43:36.000000000 -0400
+++ megaraid_2006_wo_hostlock/megaraid2.c	2003-07-30
15:05:35.000000000 -0400
@@ -394,7 +394,6 @@
 
 		adapter->flag = flag;
 		spin_lock_init(&adapter->lock);
-		host->lock = &adapter->lock;
 
 		host->cmd_per_lun = max_cmd_per_lun;
 		host->max_sectors = max_sectors_per_io;
@@ -1775,7 +1774,7 @@
 	unsigned long	flags;
 
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	megaraid_iombox_ack_sequence(adapter);
 
@@ -1784,7 +1783,7 @@
 		mega_runpendq(adapter);
 	}
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return;
 }
@@ -1857,7 +1856,7 @@
 	unsigned long	flags;
 
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	megaraid_memmbox_ack_sequence(adapter);
 
@@ -1866,7 +1865,7 @@
 		mega_runpendq(adapter);
 	}
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return;
 }
@@ -2618,7 +2617,7 @@
 
 	adapter = (adapter_t *)scp->host->hostdata;
 
-	ASSERT( spin_is_locked(&adapter->lock) );
+	ASSERT( spin_is_locked(&io_request_lock) );
 
 	printk("megaraid: aborting-%ld cmd=%x <c=%d t=%d l=%d>\n",
 		scp->serial_number, scp->cmnd[0], scp->channel, scp->target,
@@ -2715,7 +2714,7 @@
 
 	adapter = (adapter_t *)cmd->host->hostdata;
 
-	ASSERT( spin_is_locked(&adapter->lock) );
+	ASSERT( spin_is_locked(&io_request_lock) );
 
 	printk("megaraid: reset-%ld cmd=%x <c=%d t=%d l=%d>\n",
 		cmd->serial_number, cmd->cmnd[0], cmd->channel, cmd->target,
@@ -2726,7 +2725,7 @@
 	mc.cmd = MEGA_CLUSTER_CMD;
 	mc.opcode = MEGA_RESET_RESERVATIONS;
 
-	spin_unlock_irq(&adapter->lock);
+	spin_unlock_irq(&io_request_lock);
 	if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
 		printk(KERN_WARNING
 				"megaraid: reservation reset failed.\n");
@@ -2734,7 +2733,7 @@
 	else {
 		printk(KERN_INFO "megaraid: reservation reset.\n");
 	}
-	spin_lock_irq(&adapter->lock);
+	spin_lock_irq(&io_request_lock);
 #endif
 
 	/*
@@ -4958,7 +4957,7 @@
 	scb_t *scb;
 	int rval;
 
-	ASSERT( !spin_is_locked(&adapter->lock) );
+	ASSERT( !spin_is_locked(&io_request_lock) );
 
 	/*
 	 * Stop sending commands to the controller, queue them internally.
@@ -4978,7 +4977,7 @@
 	rval = mega_do_del_logdrv(adapter, logdrv);
 
 
-	spin_lock_irqsave(&adapter->lock, flags);
+	spin_lock_irqsave(&io_request_lock, flags);
 
 	/*
 	 * If delete operation was successful, add 0x80 to the logical drive
@@ -4997,7 +4996,7 @@
 
 	mega_runpendq(adapter);
 
-	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(&io_request_lock, flags);
 
 	return rval;
 }
@@ -5547,11 +5546,11 @@
 	/*
 	 * Get the lock only if the caller has not acquired it already
 	 */
-	if( ls == LOCK_INT ) spin_lock_irqsave(&adapter->lock, flags);
+	if( ls == LOCK_INT ) spin_lock_irqsave(&io_request_lock, flags);
 
 	megaraid_queue(scmd, mega_internal_done);
 
-	if( ls == LOCK_INT ) spin_unlock_irqrestore(&adapter->lock, flags);
+	if( ls == LOCK_INT ) spin_unlock_irqrestore(&io_request_lock,
flags);
 
 	/*
 	 * Wait till this command finishes. Do not use
