From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within a
 USB payload burst
Date: Tue, 7 Jan 2014 16:47:24 -0800
Message-ID: <20140108004724.GA14082@xanatos>
References: <52CC944C.50702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5123 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbaAHArY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jan 2014 19:47:24 -0500
Content-Disposition: inline
In-Reply-To: <52CC944C.50702@gmail.com>
 <20140107212101.GA4199@xanatos>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: walt <w41ter@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
> On 01/07/2014 01:21 PM, Sarah Sharp wrote:
> 
> > Can you please try the attached patch, on top of the previous three
> > patches, and send me dmesg?
> 
> Hi Sarah, I just now finished running 0001-More-debugging.patch for the
> first time.  The previous dmesg didn't include that patch, but this one
> does.
> 
> I read through this dmesg but I nodded off somewhere around line 500.
> I hope you can stay awake :)

Well, it has all the info I need, but the results don't make me too
happy.  Everything I've checked seems consistent, and I don't know why
the host stopped.  The link TRBs are intact, the dequeue pointer for the
endpoint was pointing to the transfer that timed out and it had the
cycle bit set correctly, etc.  Perhaps the no-op TRBs are really the
issue.

I'll have to take a look at the log again tomorrow.  I posted the dmesg
on pastebin if David wants to check it out as well:
http://pastebin.com/a4AUpsL1

Can you send me the output of `sudo lspci -vvv -n`?  Maybe we can just
turn off scatter-gather for your host controller until we get a proper
fix in that uses link TRBs instead of no-op TRBs.

Sarah Sharp
