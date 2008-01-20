From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: udev hangs USB-storage (HP r707 camera)
Date: Sat, 19 Jan 2008 20:56:31 -0600
Message-ID: <1200797791.11214.3.camel@localhost.localdomain>
References: <20080119174556.GE11553@colo.lackof.org>
	 <47929B9F.8080607@s5r6.in-berlin.de>
	 <20080120022829.GG11553@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53342 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYATC4k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jan 2008 21:56:40 -0500
In-Reply-To: <20080120022829.GG11553@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org


On Sat, 2008-01-19 at 19:28 -0700, Grant Grundler wrote:
> On Sun, Jan 20, 2008 at 01:53:51AM +0100, Stefan Richter wrote:
> > Grant Grundler wrote:
> > >     https://bugs.launchpad.net/ubuntu/+source/hal/+bug/180472
> > ...
> > > I have a usbmon trace for 2.6.23.13 (appended) along with dmesg output.
> > > What I need is someone to interpret this trace, tell me what happened,
> > > then I can work on tracking down "vol_id"'s role in this mess.
> > 
> > You can also enable SCSI command logging.  Perhaps userspace sends a
> > specific command which offends the device (because The Other OS wouldn't
> > send that command in this order of sequence).
> 
> Thanks for reminding me...I had collected strace output of udev and all
> it's children a few days ago (probably with 2.6.22-14-generic (Ubuntu
> kernel). I've appended everything for PID 17972 (which is only 12k, full
> output is 559KB). Key bit is this:
> 17972 _llseek(3, 31129600, [31129600], SEEK_SET) = 0
> 17972 read(3,  <unfinished ...>
> 17972 <... read resumed> 0x804dc80, 512) = -1 EIO (Input/output error)
> 
> given the device reports "60801 512-byte hardware sectors (31 MB)"
> and "31129600/512 == 60800"...it's obvious vol_id is trying to read
> the last sector on the disk (I assume it's to verify the size).
> ISTR "reading the last sector" caused problems else where.
> I'll try to hunt that down.

If this is the problem, it ought to be reproducible without vol_id by
doing

dd bs=512b if=/dev/<dev> of=/dev/null seek=60800 count=1

There is a READ_CAPACITY bug where incompetent usb vendors misread the
SCSI standard and actually report one sector more than the actual
capapcity (and crash when this is accessed), but let's verify first.

James


