From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Mon, 10 Mar 2008 10:11:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803101001340.3493-100000@iolanthe.rowland.org>
References: <47D53AC4.8030407@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52885 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750875AbYCJOLj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2008 10:11:39 -0400
In-Reply-To: <47D53AC4.8030407@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Mar 2008, Boaz Harrosh wrote:

> > What's the reason for this baroque arrangement?  Why tell the block 
> > layer that the data was transferred successfully and then use a 
> > back-door arrangement like req->data_len to let the caller know that 
> > no, the data wan't really all transferred?
> 
> Yes this is very ugly and bug-full. We tripped over that a few times
> in the passed. There was somewhat an agreement at LSF that struct request
> should have a residue field, just as scsi_cmnd do. and that the scsi_cmnd's
> field can go away. (Easily done with scsi accessors in place). Current system
> was an HACK to reuse req->data_len for residue after the request was completed.
> for sg only at the time. It is on my TODO list, together with some other changes
> that we agree upon.

Sounds like a good thing to do.

> > P.S.: In case you're interested...
> > 
> > It's not common, even among USB devices, to return a residue without
> > identifying the bad sector.  The one example where I saw it happen was
> > explained by the fact that max_sectors was too high.  The device
> > returned as much data as it could, with the residue set to indicate
> > that some was missing.  But since it never actually encountered a
> > sector-read error, it didn't return any sense information.
> 
> There was a fix submitted to sd.c and separately to sr.c not long ago, I 
> would say 2.6.25, (haven't checked though). That fixes such a problem. It was 
> agreed that other ULDs do not really use proper FS commands. What are the 
> kernels you have reports for? Do you need that I dig up the commits / mailinglist
> posts?

No need, the problem you're thinking of in sd has been fixed.  The
problem was that sd did not check the value of error_sector to make
sure it was within the range of sectors accessed by the command.  I'm
not sure if an equivalent fix has been applied to sr, however.

> > Yes, the device _should_ have returned Illegal Request, Invalid 
> > Field in CDB, or something of the sort.  That would have alerted us to 
> > the problem.  But it didn't.  And as a result, the midlayer thought the 
> > missing data was present and correct.  The user reported it as data 
> > corruption: Files written to the device and then read back did not 
> > compare equal to the original files.
> > 
> 
> The way I see it, what you are saying is impossible, since there is a check
> for max sector in place, and VFS/ULD will not write passed that.

As I said, max_sectors was too big.  It was set to 120 KB but it 
should have been 56 KB, or something like that.  Hence the VFS/ULD 
tried to transfer more data than the device was capable of handling.

>  If so it's a bug
> that should be fixed. (Wherever the bug is).

It has already been fixed; there is now a blacklist entry for that
particular device specifying a lower value for max_sectors.

> If this was done as a BLOCK_PC via sg then surly the residue was reported back
> to user mode and the application should be fixed.

No, it was done by a normal filesystem I/O.

Alan Stern

