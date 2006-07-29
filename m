From: Douglas Gilbert <dougg@torque.net>
Subject: Re: cd burning with plextor drives.
Date: Sat, 29 Jul 2006 16:12:05 -0400
Message-ID: <44CBC115.2080401@torque.net>
References: <20060729045249.GA23398@redhat.com>  <20060729111240.GG13095@suse.de> <1154180419.9447.61.camel@mulgrave.il.steeleye.com> <Pine.LNX.4.64.0607291005200.4168@g5.osdl.org> <44CBAB4B.7050308@torque.net> <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28852 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751346AbWG2UMR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jul 2006 16:12:17 -0400
In-Reply-To: <Pine.LNX.4.64.0607291145250.4168@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <axboe@suse.de>, Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 29 Jul 2006, Douglas Gilbert wrote:
>> Command filtering has always been dubious.
> 
> No it has not.
> 
> Command filtering falls under the _very_ non-dubious heading of "of 
> _course_ we have to do it". There is absolutely zero doubt about it at 
> all. 
> 
> You literally have two choices:
>  - you can filter commands
>  - you can disallow all command access for non-specific-capability users.
> 
> Those are the two choices. There really is no third choice. The only 
> question is the details of _how_ you do the filtering and/or disallowing.
> 
>> If a user has read write permissions on
>> a full device (not just a partition in it) why shouldn't
>> they be able to send any (SCSI/ATA/...) pass through
>> command to it?
> 
> They have read-write access to the PLATTER. 
> 
> The fact that you may have access to write data to a disk does _not_ mean 
> that you must necessarily be able to set the password on the disk so that 
> nobody else can ever read or write data to that disk without your 
> permission.

See below. Non-root users do not usually have read
or write permissions to a _disk_. We were talking
about a different class of devices: cd/dvd drives.

> Quite frankly, if you don't see that as an "obvious", and that I'm 100% 
> right when I say that you have the above _two_ choices, and that your 
> choice simply is not a choice at all, but total idiocy, then I don't know 
> what to say.

Well if you want to filter, I'll be happy to find
flaws, both over and under filtering. Are you sure
SCSI commands are being sent through the pass through?
How about ATA commands tunnelled in SCSI commands
(already supported by libata). There was recent talk
of tunnelling SAS SMP functions through SCSI (SSP)
to name another (ab)use.

> Put another way: you will remove that command filtering in 
> block/scsi_ioctl.c only in a kernel that I don't maintain, or by disabling 
> it in some way that is so hidden that I won't notice. Because I'm not so 
> stupid as to think that it's ok for normal users to set driver passwords 
> or rewrite the disk firmware just because they have write permissions to 
> the device. That's pretty damn final.

You weren't at the storage summit. As stated in other
posts to this thread it was concluded that command
filtering is a flawed strategy. With that consensus
that leaves the "disallow all command access for
non-specific-capability users" option.

> But you can try to _improve_ the filtering. We've certainly done that 
> before. Quite frankly, I don't think there's a lot there that can be 
> improved upon any more, but it's certainly an option that we could change 
> that filtering to be (a) per-device and (b) allow root to explicitly 
> change it on a per-machine and per-device setting, with the current 
> filtering rules being just the "default rules".

By current rules I suppose you mean the block SG_IO rules. Do you really
mean "per-device" as in /dev/hdc or "per-device-type" as in disk versus
cd/dvd drive? The current rules are skewed towards MMC so far that
they are broken in that some SBC (i.e. hard disk) modifying commands
can slip through in the guise of innocent MMC commands.

> Then you could encode any additional rules you want in a /sbin/hotplug 
> script or something. But the filtering isn't going _anywhere_, and what 
> you suggest is just totally and utterly insane.

Sounds like you are playing the man and not the ball.
Why didn't you jump on either of these posts:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115417174425242&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=115418046812126&w=2
Hmm?


As you are no doubt aware, disk permissions and cd/dvd drive
permissions are set up differently:

$ df -hT
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/hda2     ext3     19G   15G  3.4G  82% /

$ ls -l /dev/hda /dev/hda2
brw-r----- 1 root disk 3, 0 Jul 29 05:14 /dev/hda
brw-r----- 1 root disk 3, 2 Jul 29 09:14 /dev/hda2

This email has been saved on /dev/hda2 but I don't have
permissions on it. I can't send any pass through commands
to /dev/hda or /dev/hda2 as a non-root user (unless
my user is in group 'disk' and the command only needs
O_RDONLY which rules out the SCSI WRITE command).

Here is my cd/dvd combo drive:

$ ls -l /dev/hdc
brw------- 1 dougg disk 22, 0 Jul 29 09:14 /dev/hdc

The GUI (kde of FC5) was started as user 'dougg' but
I'm writing this email as user 'torque' so I can't
access that cd/dvd drive at the pass through level.


There is another class of commands that the sg driver does
require CAP_SYS_RAW_IO capability for. Those are the ones
that do collateral damage. A bus reset command comes to
mind (also ATA soft resets on PATA can take out the other
device on the cable). IMO collateral damage is something
the OS should take special care with.

Doug Gilbert
