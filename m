From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Drivers accessors latest version
Date: Sat, 03 Nov 2007 14:41:32 -0500
Message-ID: <1194118892.4230.1.camel@localhost.localdomain>
References: <47276EB9.7070603@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:49666 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755361AbXKCTlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Nov 2007 15:41:35 -0400
In-Reply-To: <47276EB9.7070603@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2007-10-30 at 19:49 +0200, Boaz Harrosh wrote:
> Hi
> 
> lots of drivers changed yet again do to latest SG API fixes.
> There is no use me sending all of them again. They are available
> on a public git tree.
> 
> you can pull them from:
> git-pull git://bhalevy.com/open-osd accessors
> 
> They are based on todays scsi-misc tree. If you want that I preform
> any changes before you pull please just ask.
> 
> shortlog below

I'm going through these now ... I'll cherry pick most into the relevant
trees.

> b6f2026... isd200.c: use one-element sg list in issuing commands
> 6b3727d... usb: transport - convert to accessors and !use_sg code path removal
> 3439a91... usb: protocol.c - convert to accessors and !use_sg code path removal
> 8739148... usb: shuttle_usbat.c - convert to accessors and !use_sg code path removal
> a5207db... usb: freecom.c & sddr09.c - convert to accessors and !use_sg cleanup
> 1390243... NCR5380 familly convert to accessors & !use_sg cleanup

This one has a clear merge bug:

index 2597209..bc63349 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -295,16 +295,24 @@ static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
         * various queues are valid.
         */
 
+<<<<<<< HEAD:drivers/scsi/NCR5380.c
        if (cmd->use_sg) {
                cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
                cmd->SCp.buffers_residual = cmd->use_sg - 1;
                cmd->SCp.ptr = sg_virt(cmd->SCp.buffer);
+=======
+       if (scsi_bufflen(cmd)) {
+               cmd->SCp.buffer = scsi_sglist(cmd);
+               cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
+               cmd->SCp.ptr = page_address(cmd->SCp.buffer->page)+
+                              cmd->SCp.buffer->offset;
+>>>>>>> d9ab658... NCR5380 familly convert to accessors & !use_sg cleanup:drive

So could you fix it up correctly, please (and just email the patch, I
think it's the only problem commit).

Thanks,

James


