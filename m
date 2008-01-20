From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: udev hangs USB-storage (HP r707 camera)
Date: Sat, 19 Jan 2008 22:11:05 -0600
Message-ID: <1200802265.11214.8.camel@localhost.localdomain>
References: <20080119174556.GE11553@colo.lackof.org>
	 <47929B9F.8080607@s5r6.in-berlin.de>
	 <20080120022829.GG11553@colo.lackof.org>
	 <1200797791.11214.3.camel@localhost.localdomain>
	 <20080120031008.GI11553@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080120031008.GI11553-lGaJ6EKWmV+kGg0756fqLw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Grundler <grundler-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Cc: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


On Sat, 2008-01-19 at 20:10 -0700, Grant Grundler wrote:
> On Sat, Jan 19, 2008 at 08:56:31PM -0600, James Bottomley wrote:
> ....
> > > it's children a few days ago (probably with 2.6.22-14-generic (Ubuntu
> > > kernel). I've appended everything for PID 17972 (which is only 12k, full
> > > output is 559KB). Key bit is this:
> > > 17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
> > > 17972 read(3,  <unfinished ...>
> > > 17972 <... read resumed> 0x804dc80, 512) = -1 EIO (Input/output error)
> > > 
> > > given the device reports "60801 512-byte hardware sectors (31 MB)"
> > > and "31129600/512 == 60800"...it's obvious vol_id is trying to read
> > > the last sector on the disk (I assume it's to verify the size).
> > > ISTR "reading the last sector" caused problems else where.
> > > I'll try to hunt that down.
> > 
> > If this is the problem, it ought to be reproducible without vol_id by
> > doing
> > 
> > dd bs=512b if=/dev/<dev> of=/dev/null seek=60800 count=1
> 
> root@mb500:~ # dd bs=512b if=/dev/sda of=/dev/null seek=60800 count=1
> 1+0 records in
> 1+0 records out
> 262144 bytes (262 kB) copied, 0.433933 seconds, 604 kB/s
> 
> but since 512B is the default (I thought), I tried:
> root@mb500:~ # dd if=/dev/sda of=/dev/null seek=60800 count=1
> 1+0 records in
> 1+0 records out
> 512 bytes (512 B) copied, 0.0239289 seconds, 21.4 kB/s
> 
> and got different output....wth?
> 
> Oh...and you mean "skip", not "seek"...no wonder that worked.
> 
> root@mb500:~ # strace -o strace-dd-HPr707.out dd if=/dev/sda of=/dev/null skip=60800 count=1
> dd: reading `/dev/sda': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 55.7303 seconds, 0.0 kB/s
> 
> 
> dmesg output:
> Jan 19 19:08:12 localhost kernel: usb 1-1.1.4: reset full speed USB device using uhci_hcd and address 8
> Jan 19 19:08:37 localhost last message repeated 3 times
> Jan 19 19:08:37 localhost kernel: sd 3:0:0:0: scsi: Device offlined - not ready after error recovery
> Jan 19 19:08:37 localhost kernel: sd 3:0:0:0: [sda] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK,SUGGEST_OK
> Jan 19 19:08:37 localhost kernel: end_request: I/O error, dev sda, sector 60800
> 
> 
> > There is a READ_CAPACITY bug where incompetent usb vendors misread the
> > SCSI standard and actually report one sector more than the actual
> > capacity (and crash when this is accessed), but let's verify first.
> 
> This seems to be exactly the case.
> What's the work around?

Add the device to drivers/usb/storage/unusual_devs.h with
US_FL_FIX_CAPACITY.  You'll need to know it's USB ids as well for this
file.

James
