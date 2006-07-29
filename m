From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 10:49:48 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607291045540.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de>
  <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <1154194239.9447.89.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:33415 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932199AbWG2RuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 13:50:06 -0400
In-Reply-To: <1154194239.9447.89.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Sat, 29 Jul 2006, James Bottomley wrote:
> 
> But not for every CD burner ... that's the point.  The heuristics we
> have now work for a large subset.  For the rest, we get a stream of "my
> CD won't burn as a user like it's supposed to" bug reports.

That's not _our_ problem. That's likely the problem of "cdrecord" 
_thinking_ that it needs to do something smart, when it really really 
doesn't need to.

I have yet to hear anything that implies anything else than "cdrecord is 
just buggy".

> There are certain CDs that just require vendor specific magic to
> work ... even cdrecord has no choice but to do this.

IF that is actually true (and if you were told this by Joerg, I would 
double- and triple-check it from some other source), then in the end you 
do end up having to have a per-device translation table, and it probably 
shouldn't be in the kernel.

It probably _should_ be in a suid-root thing that validates the commands. 
People used to make cdrecord suid, but that thing really isn't written to 
be done that way. That doesn't mean that something else couldn't be done 
properly.

There's no way the kernel should do this. In a hotplug environment in 
particular (which is not _that_ common with CD-ROM's but certainly not 
unheard of), you don't want to have the kernel know about every quirk of 
every device anyway.

			Linus
