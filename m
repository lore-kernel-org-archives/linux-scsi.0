From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 13:33:42 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0607291314500.4168@g5.osdl.org>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de>
 <1154180419.9447.61.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net>
 <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org> <44CBC115.2080401@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15796 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932191AbWG2Ud6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 16:33:58 -0400
In-Reply-To: <44CBC115.2080401@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org



On Sat, 29 Jul 2006, Douglas Gilbert wrote:
> 
> See below. Non-root users do not usually have read
> or write permissions to a _disk_. We were talking
> about a different class of devices: cd/dvd drives.

What has that got to do with _anything_?

What do you think is the difference between a disk and a CD drive?

And do you really think that it's the _medium_ that looks at the commands? 
I don't think so. Regardless of whether it's a disk or a CD-ROM, it's the 
controller in the _drive_ that looks and acts on those commands.

And that CD drive (that you have write access to) also has things like 
firmware. And how do you think that firmware is updated? By magic? Or by 
SCSI commands sent to the drive?

(Yeah, I realize that it's also possible that the firmware update could 
happen by the drive just reading a disk, since the controller will do 
various things on its own anyway. I don't actually know if that is ever 
the case, or possibly even the _common_ case, but my wild guess would be 
that it's a lot more common to have a firmware update SCSI command than to 
have the drive able to update its own firmware).

Are you _really_ suggesting that people who happen to log in to the 
console should automatically also be allowed to rewrite the CD-ROM drive 
firmware, just because they are supposed to be able to write to the CD-ROM 
media in that drive? Or do other random things that the kernel really 
doesn't know what they do?

For all we know, every single vendor-specific command might be a "please 
self-descruct now" command. That would be a pretty stupid vendor, but hey, 
nothing is impossible.

If you really think that normal people should be able to send arbitrary 
SCSI commands to their CD-ROM unit, just because they should be able to 
write to the _platter_ that happens to have been inserted into that unit, 
then you really are crazy.

By updating the firmware on the CD-ROM drive, you can basically make it be 
nonfunctional.

Or do you know what all those vendor-specific commands do? In that case, 
we could just say "ok, for this particular device, we know this command is 
safe, so we can let it through".

> You weren't at the storage summit. As stated in other
> posts to this thread it was concluded that command
> filtering is a flawed strategy. With that consensus
> that leaves the "disallow all command access for
> non-specific-capability users" option.

Apparently it was good that I wasn't at that storage summit, because you 
guys clearly don't care about users or sanity, and I'd just have been 
frustrated.

We _do_ want to allow users to write their own disks without SUID programs 
if at all possible, and if for no other reason than the fact that people 
expect it to work, and so far every SUID program to do so has been a 
disaster (I'm not saying that it necessarily _always_ is a disaster, and 
I'm not saying it's wrong, but at least historically it has been).

And that BY DEFINITION means that we need to do filtering. No ifs, buts or 
maybes about it.

> By current rules I suppose you mean the block SG_IO rules. Do you really
> mean "per-device" as in /dev/hdc or "per-device-type" as in disk versus
> cd/dvd drive?

Per-device as in /dev/hdc. Every device node would need to have its own 
filtering rule.

> Why didn't you jump on either of these posts:

Because I don't read linux-scsi? I replied when I was Cc'd and noticed 
(and hey, I sometimes get too much personal email too, so that "and 
noticed" is actually important. The fact that I don't reply to everything 
doesn't mean that I read it, understood it, and agreed with it).

			Linus
