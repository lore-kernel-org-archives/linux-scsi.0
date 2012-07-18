From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 44771] [REGRESSION] a7a20d103994fd760766e6c9d494daa569cbfe06
 makes kernel 3.5 unbootable on an Intel chipset based motherboard
Date: Wed, 18 Jul 2012 16:25:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207181608410.1429-100000@iolanthe.rowland.org>
References: <1342562588.3039.104.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36087 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751813Ab2GRUZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2012 16:25:54 -0400
In-Reply-To: <1342562588.3039.104.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "Artem S. Tashkinov" <t.artem@mailcity.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Borislav Petkov <bp@amd64.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 17 Jul 2012, James Bottomley wrote:

> On Tue, 2012-07-17 at 12:51 -0700, Linus Torvalds wrote:
> > Wrong people cc'd, it looks like.
> > 
> > Guys, commit a7a20d103994 ("sd: limit the scope of the async probe
> > domain") is causing boot problems. It's timing-dependent and
> > apparently sometimes works, which makes sense with that commit.
> > 
> > However, it *should* have been fixed by commit 43a8d39d0137 ("fix
> > async probe regression"), but Artem seems to report the problem even
> > in -rc7.
> > 
> > Comments?
> 
> As far as I can tell, the fix should have worked.  However, there are a
> lot of assumptions in the async stuff that end up not being true in the
> presence of separate async domains.   We should be fixing it all here:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=shortlog;h=refs/heads/async

Those commits haven't been merged into 3.5-rc7, right?  So Artem isn't 
using them.

> I've got to say, I don't understand the bug report.  all of those
> commits were about probing for devices.  However, the screen shot
> 
> https://bugzilla.kernel.org/attachment.cgi?id=75351
> 
> shows the devices were found, it's the partition tables that weren't.
> For us to see the message about sda's capacity, we're already in the
> async code the commits were trying to synchronise with.

That's understandable, given that those commits aren't present in
Artem's kernel.  Are they queued for -stable?

> However, there are some missing messages: there's no partition table
> print and no final 
> 
> 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
> 		  sdp->removable ? "removable " : "");
> 
> So sd_probe_async() got stuck somewhere after the first
> sd_revalidata_disk().

No, it didn't get stuck.  The problem is that the scsi_wait_scan module 
didn't wait for the async scanning to finish.

And the reason for that is one you're already familiar with: 
CONFIG_SCSI_MOD=y.

Artem, if you change all your SCSI drivers to be modular rather than 
built-in, that ought to fix the problem.  Alternatively, you can simply 
continue to use the "rootwait" option.

Alan Stern

