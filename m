From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH] sr: Ensure disk is revalidated when media changes
Date: Fri, 8 Apr 2011 17:43:16 +0100
Message-ID: <BANLkTimYBDvcUO9Z2wdk4VFk88NpGJiZJA@mail.gmail.com>
References: <8d830b21c0b944d26f29dc1e0c42c0bef8d448c2.1301595169.git.amit.shah@redhat.com>
	<20110401154327.GA6593@mtj.dyndns.org>
	<20110405065129.GC2872@amit-x200.redhat.com>
	<20110406100620.GA4142@mtj.dyndns.org>
	<BANLkTinpRJHr+293kPzS1=hCWRPamOOGfw@mail.gmail.com>
	<20110408162041.GB3871@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110408162041.GB3871@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, Markus Armbruster <armbru@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 8, 2011 at 5:20 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Apr 08, 2011 at 12:37:56PM +0100, Stefan Hajnoczi wrote:
>> There is a related issue I have been discussing with Amit:
>> https://lkml.org/lkml/2011/3/23/156
>>
>> On media change the inode size is not updated by the sr driver or th=
e
>> universal cdrom driver. =A0A userspace process that holds a /dev/sr0
>> file descriptor open across media change causes all processes on the
>> system to see the old medium size when they do lseek(fd, 0, SEEK_END=
).
>>
>> I think it would make sense to refresh the inode size on media chang=
e
>> so that even open file descriptors see the new size and a single
>> process cannot force a stale value for all other userspace processes
>> on the system.
>
> Hmmm... I don't know. =A0Maybe we can but I'm not sure whether there'=
s a
> good reason for it. =A0cdrom is locked while opened after all. =A0Are
> there actual problems?

Yeah, sorry I didn't explain what the use case was.  With QEMU you can
pass through the physical CD-ROM into the virtual machine.

QEMU opens /dev/cdrom with O_NONBLOCK | O_RDONLY.  The guest can test
if the medium is present and QEMU will do ioctl(fd,
CDROM_DRIVE_STATUS, CDSL_CURRENT).  The guest can also lock the tray
and eject, again using the respective ioctls.  Read operations are
serviced by performing a read on the file descriptor in QEMU.  And
finally the medium size is queried by QEMU using lseek(fd, 0,
SEEK_END).

Today QEMU cannot keep /dev/cdrom open across media change because it
will have an outdated inode size returned from lseek(fd, 0, SEEK_END).
 But if the cdrom driver (or sr) refresh the inode size on media
change then there is no need to work around this from userspace.

Stefan
