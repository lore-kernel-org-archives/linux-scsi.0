From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Wed, 05 Dec 2012 09:20:54 +0000
Message-ID: <1354699254.2243.5.camel@dabdike.int.hansenpartnership.com>
References: <8134827.27.1354128708501.JavaMail.root@zimbra>
		<50B67230.4080602@genband.com>
	 <CADNH=7Hv2RgBv=0Xia=yMyzKmgAOgvxJSAKn2arcE7k1x_T4FQ@mail.gmail.com>
	 <50B67417.2020606@genband.com> <50BD09EC.5060705@redhat.com>
	 <50BD0F44.7010808@genband.com> <50BD1127.6090304@redhat.com>
	 <50BD14B1.7000203@genband.com> <50BD1F45.1040802@redhat.com>
	 <50BE7293.8060200@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50BE7293.8060200@genband.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-12-04 at 16:00 -0600, Chris Friesen wrote:
> As another data point, it looks like we may be doing a SEND DIAGNOSTIC
> command specifying the default self-test in addition to the background
> short self-test.  This seems a bit risky and excessive to me, but
> apparently the guy that wrote it is no longer with the company.

This is a really bad idea.  A lot of disks go out to lunch until the
diagnostics complete (the same goes for SMART diagnostics).  This means
that if you do diagnostics on a running device, the drivers start to get
timeouts on commands which are queued waiting for diagnostics to
complete ... if those go over the standard SCSI timeouts, we'll start to
try error recovery and likely have the disaster you see above.

> What is the recommended method for monitoring disks on a system that
> is likely to go a long time between boots?  Do we avoid any in-service
> testing and just monitor the SMART data and only test it if something
> actually goes wrong?  Or should we intentionally drop a disk out of the
> array and test it?  (The downside of that is that we lose
> redundancy since we only have 2 disks.)

What do you mean by "monitoring" ... as in what are you looking for?  To
make sure the disk is healthy and responding, a simple test unit ready
works.  To look at other parameters, read the mode pages.

Anything that actively causes the disk to go out and check something is
a bad idea in a running environment.  Only do this if you can quiesce
the I/O before starting the active diagnostic (or drop the disk from the
array as you suggest).

To be honest, though, modern disks do a whole host of diagnostics as
they write data just to check that it is safely committed, so passive
monitoring should be fine.

James


