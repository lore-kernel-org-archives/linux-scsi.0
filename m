From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: [Bug 3466] New: Bug while connecting  
 USB-HDD (fwd)
Date: Wed, 29 Sep 2004 13:31:07 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409291320260.1700-100000@ida.rowland.org>
References: <cjcmtl$knh$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:13316 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268742AbUI2RbJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:31:09 -0400
In-Reply-To: <cjcmtl$knh$1@sea.gmane.org>
List-Id: linux-scsi@vger.kernel.org
To: Sacher Khoudari <ng04@craesh.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 29 Sep 2004, Sacher Khoudari wrote:

> | OK, I have a definite theory about this, but it hinges on finding the
> | above message in the logs.
> |
> | I think we tried to destroy the command slab while some commands were
> | still active.  The refcounting only applies to in-flight commands, but
> | commands can also be allocated and queued in the block layer.
> |
> | If I'm right, the attached will close this refcounting hole.
> |
> | James

There is some confusion about when active commands should be destroyed.  
See http://marc.theaimsgroup.com/?l=linux-scsi&m=109647697621208&w=2


> Hi!
> 
> I think you theory is right. I just found some interesting linesin
> kern.log (see attachment). I remember I had some problems with my
> USB-HDD while copying some big files, I had to detach the drive and plug
> in again. As I can see in the logs there were some errors reading the
> FAT-filesystem (although the filesytem fscks without errors). Strange...
> 
> Greatings!
> Sacher

Your log shows multiple errors, and it's hard to sort them out.

First of all, try upgrading to 2.6.9-rc2.  There is a problem with Genesys
interface chips in 2.6.8.1 -- the correct workaround wasn't added until
2.6.9-rc1.  If I had known before that your device used the Genesys chip I
would have told you to do this earlier.

Second, if that doesn't solve all your problems, try turning on the 
usb-storage verbose debugging option in the kernel configuration.  That 
will add lots of extra information about failed commands, retries, and so 
on to your system log.

Alan Stern

