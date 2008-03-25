From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Tue, 25 Mar 2008 12:47:50 -0400
Message-ID: <20080325164750.GG16358@mit.edu>
References: <47E875AD.1000901@rtr.ca> <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org> <47E8FF58.8050209@rtr.ca> <47E90CDA.600@emc.com> <20080325153423.GD16721@parisc-linux.org> <47E91EE2.9080801@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56739 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755115AbYCYQtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Mar 2008 12:49:52 -0400
Content-Disposition: inline
In-Reply-To: <47E91EE2.9080801@emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH l <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Mar 25, 2008 at 11:48:50AM -0400, Ric Wheeler wrote:
>> Don't those devices run into trouble with fsck?  The amount of memory
>> you need to fsck a device is obviously going to depend on the filesystem,
>> but it has to grow with device size, and I'm not sure that 4GB is enough
>> virtual address space to fsck 2TB.

Well 2TB, assuming a 4k blocksize, means a block bitmap is 512 megs.
So at least for ext3, 4GB should be just enough, unless you hit
certainly really nasty complicated corruptions (i.e. large number of
blocks claimed by more than one inode, which can happen if an inode
table is written to the wrong location on disk --- on top of some
other portion of the inode table), or if the filesystem has a large
number of files with hard links (such as the case with certain backup
programs).

The plan is to implement some kind of run-length encoding to compress
the in-memory requirements for storing the bitmaps, but that hasn't
been coded yet.  If someone is a staff programmer for one of these
bookshelf NAS manufacturers is interested in implementing such a
beast, they should talk to me; I've thought quite a bit about the
design, and I just need a minion to implement it.  :-)

> Absolutely - they more or less hit a stonewall once the disk has any 
> trouble and you need to fsck.  On the other hand, this might be merciful 
> since on 64 bit boxes, we will let you run the fsck and watch it run for a 
> week or so before you despair ;-)
>
> On a serious note, fsck time tends to track more the number of active 
> inodes, so you can fsck a large file system if you use it to store large 
> files (especially if you use a file system with dynamic inode creation or 
> something like the uninitialized ext4 inodes).

And ext4 extents will help because it reduces the number of indirect
blocks you have to read, which will significantly reduce the fsck
time.  So there will be improvements on the horizon.

       	  	     		     	- Ted

