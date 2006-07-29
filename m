From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 13:53:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607291338530.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net>
 <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org> <44CBC115.2080401@torque.net>
 <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61624 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932240AbWG2UyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 16:54:14 -0400
In-Reply-To: <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Sat, 29 Jul 2006, Linus Torvalds wrote:
>
> Are you _really_ suggesting that people who happen to log in to the 
> console should automatically also be allowed to rewrite the CD-ROM drive 
> firmware, just because they are supposed to be able to write to the CD-ROM 
> media in that drive? Or do other random things that the kernel really 
> doesn't know what they do?

Btw, in the name of full disclosure, I should probably admit that when I 
did some of the block/scsi_ioctl.c reorganizations and tried to push 
people to realize that it was much better to do "cdrecord dev=/dev/hda" 
than by going through sg.c and the ide-scsi emulation thing, the code not 
only only first missed the CAP_SYS_RAWIO check entirely, I also then made 
the decision that only root could do any SCSI command ioctl's, and that I 
thought it was reasonable.

I was disabused of that notion fairly quickly. People _really_ didn't like 
the "if (!capable(CAP_SYS_RAWIO)) return -EPERM;" approach, and 
"verify_command()" was written pretty quickly.

So I have been disabused of that notion myself, the same way I now hope to 
pass on that wisdom to the next generation of abusees ;)

Anyway, the kernel _has_ gone both ways in the past - not having any 
access checks at all, and only allowing root. We tried it, and neither 
really worked.

And no, to my knowledge, nobody _actually_ ever fried their CD-ROM by a 
bad user overwriting the firmware, but quite frankly, I don't want to risk 
it.

(As a historical oddity - there _was_ this bug in some drive that would 
corrupt the firmware by mistake, though - I think we _did_ actually fry 
some drives by sending it a "cache flush" command that it wasn't 
expecting, and that it turned into firmware reload thing or something. I 
think Alan Cox knows all the gruesome details, but that we could 
definitely blame on bad hardware..

I think that actually happened to be a CD-ROM drive, but it wasn't even a 
user-generated command at all, it was the kernel doing the cache-flush all 
on its sorry own.. Somebody who remembers the exact details can fill us 
in just for completeness)

		Linus
