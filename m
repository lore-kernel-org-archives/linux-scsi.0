From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Trivial patch for scsi logging text string
Date: Tue, 15 Apr 2003 15:31:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304151524010.699-100000@ida.rowland.org>
References: <1050426654.2571.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3844 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264036AbTDOTTb
	(for <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Apr 2003 15:19:31 -0400
In-Reply-To: <1050426654.2571.14.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 15 Apr 2003, James Bottomley wrote:

> On Tue, 2003-04-15 at 12:03, Greg KH wrote:
> > Hm, I don't think I can submit scsi patches to Linus :)
> > Why not send them to the scsi maintainers...
> 
> The SCSI maintainers are linux-scsi@vger.kernel.org, so we've already
> been copied on this one.
> 
> James

Does that mean that linux-scsi will forward my patch to Linus?  I hope so,
because I've got another one to submit (to Marcelo), more substantive this
time.

In 2.4.21-pre7, when the scsi error-handler decides that it has cleaned 
things up and retries the original command, it neglects to zero out the 
command's sense buffer first.  In all likelihood the sense buffer will 
contain old data left over from the error recovery operations.  This 
confuses scan_scsis(), which thinks that because there is valid sense data 
its INQUIRY probe must have failed.  This patch clears the sense buffer 
before a retry.

If nobody on the linux-scsi list objects to it, this patch should be 
applied.

Alan Stern


--- 2.4.21-pre7/drivers/scsi/scsi_error.c.orig	Tue Apr 15 11:18:35 2003
+++ 2.4.21-pre7/drivers/scsi/scsi_error.c	Tue Apr 15 11:19:29 2003
@@ -393,6 +393,7 @@
 	SCpnt->cmd_len = SCpnt->old_cmd_len;
 	SCpnt->sc_data_direction = SCpnt->sc_old_data_direction;
 	SCpnt->underflow = SCpnt->old_underflow;
+	memset(SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
 
 	scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
 

