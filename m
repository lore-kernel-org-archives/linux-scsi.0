From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] until blockdev --setrw /dev/scd$n works
Date: 05 Dec 2003 18:32:18 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1070674338.2939.31.camel@patibmrh9>
References: <1070673881.2939.20.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1070673881.2939.20.camel@patibmrh9>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, axboe@suse.de, patmans@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

> -	if (CDROM_CONFIG_FLAGS(drive)->dvd_ram)
> -		set_disk_ro(drive->disk, 0);
> +	set_disk_ro(drive->disk, 0);
> +	if (!CDROM_CONFIG_FLAGS(drive)->dvd_ram)
> +		printk("lk 2.5 ide-cd.c would refuse write\n");
> ...
> -			return 0;
> +			printk("lk 2.5 sr.c would refuse write\n");
> ...
> -			return -EROFS;
> +			printk("lk 2.5 cdrom.c would refuse write\n");

Want details?  I've got Six:

1) This three-line kluge works for me.

2) I have two pre-production samples of the same device: one ATAPI, one
USB.  Without my patch my ATAPI device never writes, and for my USB
device I have to volunteer `blockdev --setrw` or `blockdev --setro`
again after each disc insertion.

My patch makes both devices write, but I guess my patch somehow breaks
the devices other people have, else the kernel wouldn't include this
seemingly useless feature of filtering out writes on demand.

3) I think growing to three lines my kluge of a two-line patch deepens,
and thus clarifies the shock we first saw non-newbies express as:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106546474421692

> From: Jens Axboe (axboe@suse.de)
> Subject: Re: writable mmc profiles actually are writable
> Date: 2003-10-06 11:40:27 PST
>
> This is obviously wrong. What are you trying to
> do?  The uniform layer uses CDC_DVD_RAM as
> meaning randomly writable media, the only
> thing the kernel supports out of the box.

4) At least while I remain a newbie I believe the unanswered non-newbie
explanation:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106323818918929

> Newsgroups: mlist.linux.scsi
> Date: 2003-09-10 16:00:27 PST
> Subject: Re: [PATCH] mount -w of dvd+rw etc. in vanilla 2.6
> From: Patrick Mansfield (patmans@us.ibm.com)
>
> Should sd.c and sr.c be calling set_device_ro?
> (after adding a read only block device, or
> changing back to read/write)?

5) With my patch in place, dmesg reports:

hdc: ATAPI 48X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
lk 2.5 ide-cd.c would refuse write

Uniform CD-ROM driver Revision: 3.12
hdd: ATAPI 126X CD-ROM drive, 2048kB Cache, UDMA(33)
lk 2.5 ide-cd.c would refuse write
cdrom: This disc doesn't have any tracks I recognize!
cdrom: This disc doesn't have any tracks I recognize!
lk 2.5 cdrom.c would refuse write
lk 2.5 cdrom.c would refuse write
lk 2.5 cdrom.c would refuse write

sr0: scsi3-mmc drive: 125x/125x caddy
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 0, lun 0
lk 2.5 cdrom.c would refuse write
lk 2.5 sr.c would refuse write
lk 2.5 cdrom.c would refuse write
lk 2.5 sr.c would refuse write
lk 2.5 cdrom.c would refuse write
lk 2.5 sr.c would refuse write

in reply to such stimuli as:

dd of=/dev/hdd bs=2K if=/dev/zero count=1
dd of=/dev/hdd bs=2K if=/dev/zero count=1
dd of=/dev/hdd bs=2K if=/dev/zero count=1

dd of=/dev/scd0 bs=2K if=/dev/zero count=1
dd of=/dev/scd0 bs=2K if=/dev/zero count=1
dd of=/dev/scd0 bs=2K if=/dev/zero count=1

See the message pairing?  As yet we have ide-cd pointlessly redundant
with cdrom and sr pointlessly redundant with cdrom.

6) I guessed the to/cc list here after reviewing:

grep -i sr MAINTAINERS
grep @ drivers/scsi/sr.c

Pat LaVarre

P.S. Me digesting those six details produced my initial summary post:

"I say, as yet, `blockdev --setrw /dev/scd$n` does not work as well as
`blockdev --setrw /dev/hd$v`."

"Do you agree?"

"Do you agree we (e.g. I) should fix that?"

"...
