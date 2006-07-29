From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 11:54:35 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24723 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751346AbWG2Syx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 14:54:53 -0400
In-Reply-To: <44CBAB4B.7050308@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Sat, 29 Jul 2006, Douglas Gilbert wrote:
>
> Command filtering has always been dubious.

No it has not.

Command filtering falls under the _very_ non-dubious heading of "of 
_course_ we have to do it". There is absolutely zero doubt about it at 
all. 

You literally have two choices:
 - you can filter commands
 - you can disallow all command access for non-specific-capability users.

Those are the two choices. There really is no third choice. The only 
question is the details of _how_ you do the filtering and/or disallowing.

> If a user has read write permissions on
> a full device (not just a partition in it) why shouldn't
> they be able to send any (SCSI/ATA/...) pass through
> command to it?

They have read-write access to the PLATTER. 

The fact that you may have access to write data to a disk does _not_ mean 
that you must necessarily be able to set the password on the disk so that 
nobody else can ever read or write data to that disk without your 
permission.

Quite frankly, if you don't see that as an "obvious", and that I'm 100% 
right when I say that you have the above _two_ choices, and that your 
choice simply is not a choice at all, but total idiocy, then I don't know 
what to say.

Put another way: you will remove that command filtering in 
block/scsi_ioctl.c only in a kernel that I don't maintain, or by disabling 
it in some way that is so hidden that I won't notice. Because I'm not so 
stupid as to think that it's ok for normal users to set driver passwords 
or rewrite the disk firmware just because they have write permissions to 
the device. That's pretty damn final.

But you can try to _improve_ the filtering. We've certainly done that 
before. Quite frankly, I don't think there's a lot there that can be 
improved upon any more, but it's certainly an option that we could change 
that filtering to be (a) per-device and (b) allow root to explicitly 
change it on a per-machine and per-device setting, with the current 
filtering rules being just the "default rules".

Then you could encode any additional rules you want in a /sbin/hotplug 
script or something. But the filtering isn't going _anywhere_, and what 
you suggest is just totally and utterly insane.

			Linus
