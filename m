From: Jens Axboe <axboe@suse.de>
Subject: Re: drivers/block/scsi_ioctl problem
Date: Thu, 16 Dec 2004 07:32:22 +0100
Message-ID: <20041216063218.GA22982@suse.de>
References: <41BF7C18.9090303@us.ibm.com> <20041215071852.GM3157@suse.de> <41C08CD5.10309@us.ibm.com> <41C0BE3E.3060003@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:35742 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262603AbULPGc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2004 01:32:29 -0500
Content-Disposition: inline
In-Reply-To: <41C0BE3E.3060003@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 15 2004, Brian King wrote:
> Brian King wrote:
> >>It was added to be able to find out which opcode was rejected and thus
> >>caused an application malfunction. It dumps the specific opcode only
> >>once, is that such a huge problem?
> >
> >
> >Ok. I didn't realize that it was only dumped once. That's not as bad. I 
> >guess it might be better if it were only dumped if the op actually failed.
> 
> How about something like this...

> 
> Currently if an SG_IO ioctl is issued to a block device with an
> unknown opcode, an error is logged. This error is logged regardless
> the device successfully processes the command or not. This results in
> an error getting logged for each unknown opcode ever issued. This patch
> changes this policy and only prints the unknown opcode if the command
> fails.

How about just moving it after the CAP_SYS_RAWIO check, so that it only
logs for commands we explicitly reject? The purpose of the opcode dump
is not to log failed commands (the app should do that itself), but
mainly why a specific opcode was _not_ sent to the drive. This is
something you cannot always directly gauge, unless you have the source
for the app. And even then you have to dig :-)

===== drivers/block/scsi_ioctl.c 1.62 vs edited =====
--- 1.62/drivers/block/scsi_ioctl.c	2004-11-20 01:50:56 +01:00
+++ edited/drivers/block/scsi_ioctl.c	2004-12-16 07:30:39 +01:00
@@ -199,14 +199,14 @@
 			return 0;
 	}
 
+	/* And root can do any command.. */
+	if (capable(CAP_SYS_RAWIO))
+		return 0;
+
 	if (!(type & CMD_WARNED)) {
 		cmd_type[cmd[0]] = CMD_WARNED;
 		printk(KERN_WARNING "scsi: unknown opcode 0x%02x\n", cmd[0]);
 	}
-
-	/* And root can do any command.. */
-	if (capable(CAP_SYS_RAWIO))
-		return 0;
 
 	/* Otherwise fail it with an "Operation not permitted" */
 	return -EPERM;


-- 
Jens Axboe

