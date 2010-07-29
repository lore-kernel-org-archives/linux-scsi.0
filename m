From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 19:04:06 -0400
Message-ID: <20100729230406.GI4506@thunk.org>
References: <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <4C51DA1F.2040701@redhat.com>
 <20100729194904.GA17098@lst.de>
 <4C51DCF1.3010507@redhat.com>
 <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56970 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab0G2XEP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 19:04:15 -0400
Content-Disposition: inline
In-Reply-To: <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Thu, Jul 29, 2010 at 04:30:54PM -0600, Andreas Dilger wrote: 
> Like James wrote, this is basically everything FUA.  It is OK for
> ordered mode to allow the device to aggregate the normal filesystem
> and journal IO, but when the commit block is written it should flush
> all of the previously written data to disk.  This still allows
> request re-ordering and merging inside the device, but orders the
> data vs. the commit block.  Having the proposed "flush ranges"
> interface to the disk would be ideal, since there would be no wasted
> time flushing data that does not need it (i.e. other partitions).

My understanding is that "everything FUA" can be a performance
disaster.  That's because it bypasses the track buffer, and things get
written directly to disk.  So there is no possibility to reorder
buffers so that they get written in one disk rotation.  Depending on
the disk, it might even be that if you send N sequential sectors all
tagged with FUA, it could be slower than sending the N sectors
followed by a cache flush or SYNCHRONIZE_CACHE command.

It may be worth doing some experiments to see how big N is for various
disks, but I'm pretty sure that FUA will probably turn out to not be
such a great idea for ext3/ext4.

						- Ted
