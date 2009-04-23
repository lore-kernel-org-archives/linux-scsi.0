From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [PATCH] SCSI: add check_capacity flag and
 sd_read_last_sector()
Date: Wed, 22 Apr 2009 22:33:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0904222225030.23171-100000@netrider.rowland.org>
References: <20090422230319.GA24621@ub>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:48839 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752081AbZDWCdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 22:33:51 -0400
In-Reply-To: <20090422230319.GA24621@ub>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 23 Apr 2009, Andries E. Brouwer wrote:

> > Note that a certain amount of I/O goes on independent of userspace (to
> > determine the partitioning, if nothing else).  One can make a good case
> > that this "check the last sector" falls into the same category.
> 
> Yes - I have often muttered about that as well. It has caused problems.
> One should not try to read a partition table when confronted with a
> random block device with random data. Only when user space asks.
> 
> There have been times when the random device was a magtape, and reading
> the last tape block would take an hour or so. Timing is something to
> worry about. When I started using computers boot time was much less
> than 0.1 second, not noticeable. Today lots of nonsensical things happen
> and together cause a minute delay, even though computers are ten thousand
> times faster.
> Also the error recovery of a SCSI device takes seconds, and only because
> I removed code that did make it minutes (with many retries on all levels).
> 
> Police needs systems that do not tamper with their data.
> If they take or copy a disk for forensic purposes the disk or copy
> should remain pristine, precisely as it was found, and not one bit
> should be changed. Especially time stamps can be important in
> investigations. But if one mounts ext3 read-only, Linux will (or
> perhaps would, I have not checked recently) still write to the disk
> as a result of replaying the journal.
> 
> Some disks are used with a whole-disk filesystem, without partition table.
> 
> A good system does no I/O at all, unless there is a request.
> 
> > > (So - this would be much more work, but I would prefer a capacity value
> > > that says "it reported this, but we have not checked yet - try an actual
> > > I/O if you really want to know", and leave it at that until the value is
> > > needed. Typically one needs the value (i) to check against it if one
> > > wants to do I/O, or (ii) when user space asks for it because some fdisk type
> > > program is invoked. In case (i) an additional read is superfluous.
> > > In case (ii) user space asked and we try to make sure.)
> > > 
> > > Comments?
> > 
> > How would the kernel know when it needed to make sure?  By the time an 
> > actual I/O request from userspace arrives, it's probably too late -- 
> > the task has already looked at the capacity value and doesn't know that 
> > the capacity might change spontaneously.
> 
> Consider the situation of the old days: a magtape. We used magtape
> as a block device, but asking for the capacity was a very expensive
> question - it would involve spooling to the end, and hoping that there
> was a good tape mark. (Otherwise operator intervention would be needed.)
> It is not difficult for software to cope with the situation of unknown
> capacity. It is just a bit silly to write the corresponding code today.
> There is not enough motivation.
> 
> So, I do not object to your code, I just hope that you have a little bit
> of a bad conscience - the hope to do things right at some unspecified
> moment in the future.
> 
> > As a more theoretical point, consider what would happen if the last 
> > partition included the "last" sector.  If the capacity got changed 
> > after the partitions were determined, we could run into trouble.  
> > Better to adjust the capacity right away, before a bogus value can get 
> > used.
> 
> I disagree. Indeed, consider the situation that some file includes
> the last sector. Then probably that last sector really exists,
> and probing is superfluous, a waste of time, possibly needless wear of
> the device. Consider the situation that a partition includes the last
> sector. Then the entity that was responsible for the partitioning
> determined that this last sector is there, and we need not check again.
> 
> You see - really the only ordinary software that would be interested
> is fdisk type software. It does a get_capacity ioctl, and this ioctl
> should cause the kernel to really find out about the size.
> 
> (Yes, I know, there are a few other cases, e.g. for RAIDs.)
> 
> And, something I have seen several times: for forensic use one
> sometimes copies the start of a device, just because one's own
> disk is smaller than the suspect's disk. Linux should be able to
> handle the situation of a partition table that describes a
> partition that extends beyond the end of the disk. All should be
> fine, except of course that actual I/O to nonexistent sectors causes
> an I/O error.

I agree with quite a lot (though not all) of what you say.  However
there's no reason to argue/discuss it further; no doubt you are already
aware of all the important points on both sides of the issue.

I _do_ have a somewhat guilty conscience over introducing an extra 
unsolicited read (actually a pair of reads, since the patch reads 
sector 0 before trying to read the last sector).  In the end, the only 
justification is practicality -- the alternative was less workable.

Alan Stern

