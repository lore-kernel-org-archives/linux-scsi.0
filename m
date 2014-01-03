From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Fri, 3 Jan 2014 14:00:41 -0800
Message-ID: <20140103220041.GC4193@xanatos>
References: <20131220231810.GA2835@xanatos>
 <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org>
 <20140103004551.GA2970@xanatos>
 <52C67B4D.9060101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:9867 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaACWAn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jan 2014 17:00:43 -0500
Content-Disposition: inline
In-Reply-To: <52C67B4D.9060101@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Fri, Jan 03, 2014 at 09:56:45AM +0100, Hans de Goede wrote:
> Hi,
> 
> On 01/03/2014 01:45 AM, Sarah Sharp wrote:
> >Ok, Alan's additional patch fixed the warnings I was seeing on UAS
> >device unplug.  James, can you Cc me on the finished patch when you send
> >it in?
> >
> >Hans, I don't want to send the UAS patches off to Greg until James'
> >patches get into mainline.  I believe Greg's usb-next tree is frozen at
> >this point, so they'll have to wait until 3.15.
> 
> Ugh, I must say I'm rather unhappy about this, waiting till 3.14 to give
> time to shake things out was fine. But since the start of the 3.13 cycle,
> there have been no issues found in the xhci / uas code.

I completely understand why you're unhappy.  I agree that the pull
request you sent me on Nov 18th is fine (aside from not being a GPG
signed git tag). [1]  I also agree that the UAS and xHCI driver changes
have been stable during my testing, other than triggering the SCSI oops
on UAS disconnect.

> Yes it triggered an existing problem in another subsys, but the code itself
> has been issue free all this time. If Greg's tree is indeed already frozen I
> would rather have us asking an exception for this.

Detach yourself emotionally from your code and look at this request from
a maintainer's perspective.

You're asking me to push 69 patches to Greg after -rc6 is out, for a
driver that's been marked broken for several kernel releases (uas).  The
patches enable a feature that's been basically untested across all xHCI
host controllers (streams), and they add new userspace API for usbfs to
expose streams.

In the meantime, there's a big push to get code into linux-next at least
a week or two before the merge window opens.  I sent my last pull request
on Dec 20th, and Felipe closed his USB gadget tree on Dec 26th.  I had
hoped to get the SCSI issue settled so I could send in the UAS patches
on the 20th, but that didn't happen.  My tree is closed.

These fixes should get merged (and will!), but I will not ask Greg for
an exception to get these patches into 3.14.

> Alternatively we could add all of it to 3.14 except for the patch removing
> the BROKEN marking from uas. Or at least all the non uas bits, which are
> useful to have by themselves.

I think the best way to proceed with this is for me to queue all the
xHCI patches in that pull request for usb-next once 3.14-rc1 is out, and
then you send a separate pull request to Greg.  You're going to need to
be able to send him pull requests with a signed git tag in the future
anyway.

> James, what is the status of getting the fix for the refcount issue into
> mainline ?

(Greg, James will be queuing the SCSI fix for the 3.14 merge window.)

Sarah Sharp

[1] http://marc.info/?l=linux-usb&m=138478555324055&w=2
