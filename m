From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, 2.6] tmscsim - no internal command-queuing
Date: Sun, 1 Feb 2004 11:17:26 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201111726.A14042@infradead.org>
References: <Pine.LNX.4.44.0401310015520.8401-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:10 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265259AbUBALR2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 06:17:28 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401310015520.8401-200000@poirot.grange>; from g.liakhovetski@gmx.de on Sat, Jan 31, 2004 at 12:23:48AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org, Kurt Garloff <kurt@garloff.de>

On Sat, Jan 31, 2004 at 12:23:48AM +0100, Guennadi Liakhovetski wrote:
> Hi
> 
> The attached patch removes the internal command-queuing in tmscsim. The
> driver still works:-) Don't know though if this is quite correct. Please,
> comment. Goes on the top of my yesterday's patch.

Patch looks mostly good for me.  But there's some fishyness in queuecommand,
mostly from before you patch:

 - many failure cases return one with the new EH code although we wouldn't
   want to requeue the midlayer in that case.  I removed the ifdef and added
   a failed goto to handle them.
 - we need to set cmd->result onlyh if we have an error instead of always
   an overriding it - else it will leak to the midlayer in the return 1
   case.
 - the check for ids out of range are superflous (this was one of the errors
   above, I decided to remove it instead of fixing it).
 - you don't do DC390_UNLOCK_ACB when failing.  While it's a noop I think
   it's bad to have locking macros in place and don't balance them.  You
   should probably remove it completly in one of the next patches.
 - the pDCB->pWaitingSRB looks a bit strange.  By unifying the the codepathes
   it becomes much more readable.

While I'm looking at queuecommand here's some suggestions for future driver
revisions:

 - dc390_initDCB should move to the slave_alloc callback - you get that once
   allocate scsi device, which is much cleaner.  Then you can store it
   in sdev->hostdata and easily retrieve it in ->queuecommand instead of the
   dc390_findDCB and free it in ->slave_destroy.
 - Above change would probably also get rid of the whole scan device mess,
   but I'd like to hear some words from Kurt on the details of it first.

And here's my patch ontop of your two (completely untested due to lack of
hardware):


--- drivers/scsi/tmscsim.c~	2004-01-31 02:04:47.000000000 +0100
+++ drivers/scsi/tmscsim.c	2004-01-31 02:27:12.000000000 +0100
@@ -1117,9 +1117,6 @@ int DC390_queue_command (Scsi_Cmnd *cmd,
 
     DC390_LOCK_ACB;
     
-    /* Assume BAD_TARGET; will be cleared later */
-    cmd->result = DID_BAD_TARGET << 16;
-   
     /* TODO: Change the policy: Alway accept TEST_UNIT_READY or INQUIRY 
      * commands and alloc a DCB for the device if not yet there. DCB will
      * be removed in dc390_SRBdone if SEL_TIMEOUT */
@@ -1130,17 +1127,6 @@ int DC390_queue_command (Scsi_Cmnd *cmd,
     else if( (pACB->scan_devices) && (cmd->cmnd[0] == READ_6) )
 	pACB->scan_devices = 0;
 
-    if ( ( cmd->device->id >= pACB->pScsiHost->max_id ) || 
-	 (cmd->device->lun >= pACB->pScsiHost->max_lun) )
-    {
-/*	printk ("DC390: Ignore target %d lun %d\n",
-		cmd->device->id, cmd->device->lun); */
-	DC390_UNLOCK_ACB;
-	//return (1);
-	done (cmd);
-	return (0);
-    }
-
     if( (pACB->scan_devices || cmd->cmnd[0] == TEST_UNIT_READY || cmd->cmnd[0] == INQUIRY) && 
        !(pACB->DCBmap[cmd->device->id] & (1 << cmd->device->lun)) )
     {
@@ -1151,14 +1137,7 @@ int DC390_queue_command (Scsi_Cmnd *cmd,
 	  {
 	    printk (KERN_ERR "DC390: kmalloc for DCB failed, target %02x lun %02x\n", 
 		    cmd->device->id, cmd->device->lun);
-	    DC390_UNLOCK_ACB;
-	    printk ("DC390: No DCB in queue_command!\n");
-#ifdef USE_NEW_EH
-	    return (1);
-#else
-	    done (cmd);
-	    return (0);
-#endif
+	    goto fail;
 	  }
             
     }
@@ -1166,10 +1145,7 @@ int DC390_queue_command (Scsi_Cmnd *cmd,
     {
 	printk(KERN_INFO "DC390: Ignore target %02x lun %02x\n",
 		cmd->device->id, cmd->device->lun); 
-	DC390_UNLOCK_ACB;
-	//return (1);
-	done (cmd);
-	return (0);
+	goto fail;
     }
     else
     {
@@ -1178,52 +1154,37 @@ int DC390_queue_command (Scsi_Cmnd *cmd,
 	 {  /* should never happen */
 	    printk (KERN_ERR "DC390: no DCB failed, target %02x lun %02x\n", 
 		    cmd->device->id, cmd->device->lun);
-	    DC390_UNLOCK_ACB;
-	    printk ("DC390: No DCB in queuecommand (2)!\n");
-#ifdef USE_NEW_EH
-	    return (1);
-#else
-	    done (cmd);
-	    return (0);
-#endif
+	    goto fail;
 	 }
     }
 
     pACB->Cmds++;
     cmd->scsi_done = done;
     cmd->result = 0;
-    if (pDCB->pWaitingSRB)
-    {
- 	pSRB = dc390_Free_get ( pACB );
-	DEBUG0(if (!pSRB) printk ("DC390: No free SRB but Waiting\n"); else printk ("DC390: Free SRB w/ Waiting\n"));
-	if (!pSRB)
-	    return 1;
-	else 
-	  {
-	    dc390_BuildSRB (cmd, pDCB, pSRB);
-	    dc390_Waiting_append (pDCB, pSRB);
-	  }
-	dc390_Waiting_process (pACB);
-    }
-    else
-    {
- 	pSRB = dc390_Free_get ( pACB );
-	DEBUG0(if (!pSRB) printk ("DC390: No free SRB w/o Waiting\n"); else printk ("DC390: Free SRB w/o Waiting\n"));
-	if (!pSRB)
-	{
-	    dc390_Waiting_process (pACB);
-	    return 1;
-	}
-	else 
-	{
-	    dc390_BuildSRB (cmd, pDCB, pSRB);
-	    dc390_SendSRB (pACB, pSRB);
-	}
-    }
+
+    pSRB = dc390_Free_get(pACB);
+    if (!pSRB)
+	    goto requeue;
+
+    dc390_BuildSRB(cmd, pDCB, pSRB);
+    if (pDCB->pWaitingSRB) {
+	    dc390_Waiting_append(pDCB, pSRB);
+	    dc390_Waiting_process(pACB);
+    } else
+	    dc390_SendSRB(pACB, pSRB);
 
     DC390_UNLOCK_ACB;
     DEBUG1(printk (KERN_DEBUG " ... command (pid %li) queued successfully.\n", cmd->pid));
     return(0);
+
+ requeue:
+    DC390_UNLOCK_ACB;
+    return 1;
+ fail:
+    DC390_UNLOCK_ACB;
+    cmd->result = DID_BAD_TARGET << 16;
+    done(cmd);
+    return 0;
 }
 
 /* We ignore mapping problems, as we expect everybody to respect 
