From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Linux doesn't support bigger than 2TB IEEE-1394 disk
Date: Mon, 04 May 2009 14:51:26 +0000
Message-ID: <1241448686.3315.27.camel@mulgrave.int.hansenpartnership.com>
References: <85681F9DCBFF144DA59C70D83EBC1DA2E1EDE7@EIOISER.ioi.com.tw>
	 <49FEFF7A.3090603@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54945 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756816AbZEDOv1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 10:51:27 -0400
In-Reply-To: <49FEFF7A.3090603@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ronald <Ronald@ioi.com.tw>, linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, 2009-05-04 at 16:45 +0200, Stefan Richter wrote:
> Ronald wrote at linux1394-user:
> > Linux doesn't support bigger than 2TB IEEE-1394 disk.
> > 
> > Will Linux have new driver for this issue?
> 
> (Adding Cc: linux-scsi)
> 
> As far as I can tell, Linux does support IEEE 1394 disks of any size. 
> However, if I'm not mistaken, disks larger than 2 TB require that the 
> READ CAPACITY (16) command is used to check the disk's capacity, rather 
> than the usual READ CAPACITY (10) command.  Somebody correct me if I'm 
> wrong.
> 
> By far most firmwares of IEEE 1394/ SBP-2 chipsets implement only the 
> RBC (Reduced Block Commands) command set specification, or at least 
> claim so in their INQUIRY response.  If I understood correctly, the 
> Linux SCSI stack will never send READ CAPACITY (16) to them since this 
> command is not included in RBC.

That's true ... but not quite the way we work.  There's a standard
defined return for READ CAPACITY(10) which means ... I have more
sectors, please use READ CAPACITY (16).  If we get that return, we'll
try again with READ CAPACITY (16) regardless of whether the device says
it's only RBC or not.

> It is only part of the more general SBC (SCSI Block Commands) 
> specification.  But Linux won't also send READ CAPACITY (16) to disks 
> which claim SBC support, unless they also claim conformance to a 
> reasonably recent SCSI revision (I don't remember which one and am too 
> lazy to check).  This is because older firmwares may crash if they 
> receive READ CAPACITY (16).

Again, no.  Standards conformance alters the way we probe.  Recently we
altered this at Intel's request because some details of thin
provisioning (TRIM support) are only available in READ CAPACITY (16)
response.  So, since 2.6.30 we lead with READ CAPACITY (16) for recent
standard supporting devices.  For all others, we lead with READ CAPACITY
(10) but we'd still move to READ CAPACITY (10) if we get the
conventional I'm bigger than READ CAPACITY (10) will support return.

> Ronald, do you know of a specific series of SBP-2 firmwares which do 
> actually support READ CAPACITY (16) properly but are treated by Linux as 
> if they wouldn't?  If so, we could add a workaround to our drivers to 
> treat them like recent SBC implementations.  We would have to match 
> against their firmware_revision field which you get logged in dmesg if 
> you load the sbp2 or firewire-sbp2 driver with the module parameter 
> workarounds=0x1000.
> 
> (Still, I could be mistaken and the problem might be something else than 
> which READ CAPACITY flavor to use.  Maybe somebody more familiar with 
> the block oriented SCSI command sets could comment.)

James


