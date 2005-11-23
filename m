From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>
Subject: Optimize scsi_cmnd initialization and bug fix
Date: Wed, 23 Nov 2005 14:50:00 -0800
Message-ID: <200511232250.jANMo0g20086@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr21.intel.com ([143.183.121.13]:20192 "EHLO
	scsfmr001.sc.intel.com") by vger.kernel.org with ESMTP
	id S932350AbVKWWuC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Nov 2005 17:50:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>

struct scsi_cmnd is a fairly large data structure and is used
to construct scsi command.  On x86-64 arch, it is 448 bytes.  

In scsi_get_command(), it is a bit too paranoid in zeroing the
data structure.  Since most of the member variables will be
initialized in various stage of I/O submission, i.e., in
scsi_prep_fn, scsi_init_io, sd_init_command, scsi_init_cmd_errh,
etc.  So instead of blindly zeroing the whole structure, initialize
to some other value later on.  All it needs in scsi_get_command
is to zero out a few member variables that aren't initialized in
the I/O path.

I'm proposing the following patch to optimize scsi_cmnd initialization.
The only part that I'm not 100% sure is struct scsi_pointer SCp and
eh_eflags.  It appears to be safe, but since I don't have every scsi
controllers in the world to test, I can't say so for sure.  I'm willing
to take on the responsibility to fix any hiccup people might have with
this patch.  Comments?

p.s. de-referencing jiffies_at_alloc ought be in the if(cmd!=NULL) block.


Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>

--- ./drivers/scsi/scsi.c.orig	2005-11-23 13:04:46.607198199 -0800
+++ ./drivers/scsi/scsi.c	2005-11-23 13:05:38.154072568 -0800
@@ -258,17 +258,18 @@ struct scsi_cmnd *scsi_get_command(struc
 	if (likely(cmd != NULL)) {
 		unsigned long flags;
 
-		memset(cmd, 0, sizeof(*cmd));
+		cmd->cmd_len = 0;
+		cmd->sc_request = 0;
+		cmd->retries = 0;
 		cmd->device = dev;
 		init_timer(&cmd->eh_timeout);
-		INIT_LIST_HEAD(&cmd->list);
 		spin_lock_irqsave(&dev->list_lock, flags);
 		list_add_tail(&cmd->list, &dev->cmd_list);
 		spin_unlock_irqrestore(&dev->list_lock, flags);
+		cmd->jiffies_at_alloc = jiffies;
 	} else
 		put_device(&dev->sdev_gendev);
 
-	cmd->jiffies_at_alloc = jiffies;
 	return cmd;
 }				
 EXPORT_SYMBOL(scsi_get_command);



