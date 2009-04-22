From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Subject: Re: [usb-storage] [PATCH] SCSI: add check_capacity flag and
	sd_read_last_sector()
Date: Thu, 23 Apr 2009 01:03:19 +0200
Message-ID: <20090422230319.GA24621@ub>
References: <20090422191752.GA24309@ub> <Pine.LNX.4.44L0.0904221633050.3405-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:47944 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZDVXEm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 19:04:42 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904221633050.3405-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>, James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, Apr 22, 2009 at 04:47:03PM -0400, Alan Stern wrote:
> On Wed, 22 Apr 2009, Andries E. Brouwer wrote:
> 
> > On Wed, Apr 22, 2009 at 10:42:36AM -0400, Alan Stern wrote:
> > > This patch (as1196) adds a new scsi_device flag to tell sd.c that it
> > > should verify the results of READ CAPACITY by trying the read the last
> > > sector.
> > 
> > Hi Alan,
> > 
> > I can see why you want to do this, but allow me to mutter a bit nevertheless.
> > Many devices are flaky and get into strange states requiring error-recovery
> > or reboot when you try an I/O that they do not like.
> > For this reason, and also for aesthetical reasons, I would prefer never to
> > do I/O to a device unless user space asks for it.
> 
> I appreciate your caution -- and your aesthetic sensibilities!
> 
> Note that a certain amount of I/O goes on independent of userspace (to
> determine the partitioning, if nothing else).  One can make a good case
> that this "check the last sector" falls into the same category.

Yes - I have often muttered about that as well. It has caused problems.
One should not try to read a partition table when confronted with a
random block device with random data. Only when user space asks.

There have been times when the random device was a magtape, and reading
the last tape block would take an hour or so. Timing is something to
worry about. When I started using computers boot time was much less
than 0.1 second, not noticeable. Today lots of nonsensical things happen
and together cause a minute delay, even though computers are ten thousand
times faster.
Also the error recovery of a SCSI device takes seconds, and only because
I removed code that did make it minutes (with many retries on all levels).

Police needs systems that do not tamper with their data.
If they take or copy a disk for forensic purposes the disk or copy
should remain pristine, precisely as it was found, and not one bit
should be changed. Especially time stamps can be important in
investigations. But if one mounts ext3 read-only, Linux will (or
perhaps would, I have not checked recently) still write to the disk
as a result of replaying the journal.

Some disks are used with a whole-disk filesystem, without partition table.

A good system does no I/O at all, unless there is a request.

> > (So - this would be much more work, but I would prefer a capacity value
> > that says "it reported this, but we have not checked yet - try an actual
> > I/O if you really want to know", and leave it at that until the value is
> > needed. Typically one needs the value (i) to check against it if one
> > wants to do I/O, or (ii) when user space asks for it because some fdisk type
> > program is invoked. In case (i) an additional read is superfluous.
> > In case (ii) user space asked and we try to make sure.)
> > 
> > Comments?
> 
> How would the kernel know when it needed to make sure?  By the time an 
> actual I/O request from userspace arrives, it's probably too late -- 
> the task has already looked at the capacity value and doesn't know that 
> the capacity might change spontaneously.

Consider the situation of the old days: a magtape. We used magtape
as a block device, but asking for the capacity was a very expensive
question - it would involve spooling to the end, and hoping that there
was a good tape mark. (Otherwise operator intervention would be needed.)
It is not difficult for software to cope with the situation of unknown
capacity. It is just a bit silly to write the corresponding code today.
There is not enough motivation.

So, I do not object to your code, I just hope that you have a little bit
of a bad conscience - the hope to do things right at some unspecified
moment in the future.

> As a more theoretical point, consider what would happen if the last 
> partition included the "last" sector.  If the capacity got changed 
> after the partitions were determined, we could run into trouble.  
> Better to adjust the capacity right away, before a bogus value can get 
> used.

I disagree. Indeed, consider the situation that some file includes
the last sector. Then probably that last sector really exists,
and probing is superfluous, a waste of time, possibly needless wear of
the device. Consider the situation that a partition includes the last
sector. Then the entity that was responsible for the partitioning
determined that this last sector is there, and we need not check again.

You see - really the only ordinary software that would be interested
is fdisk type software. It does a get_capacity ioctl, and this ioctl
should cause the kernel to really find out about the size.

(Yes, I know, there are a few other cases, e.g. for RAIDs.)

And, something I have seen several times: for forensic use one
sometimes copies the start of a device, just because one's own
disk is smaller than the suspect's disk. Linux should be able to
handle the situation of a partition table that describes a
partition that extends beyond the end of the disk. All should be
fine, except of course that actual I/O to nonexistent sectors causes
an I/O error.

Andries


