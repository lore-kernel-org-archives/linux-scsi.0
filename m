From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2 of 8] block: Export I/O topology for block devices	and partitions
Date: Thu, 23 Apr 2009 12:44:19 -0600
Message-ID: <20090423184418.GT1926@parisc-linux.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <cbdae69a14895dab8ba7.1240464569@sermon.lab.mkp.net> <20090423105145.GW4593@kernel.dk> <20090423181312.GA8768@mars.virtualiron.com> <49F0B2CD.2020706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46480 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbZDWSoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 14:44:20 -0400
Content-Disposition: inline
In-Reply-To: <49F0B2CD.2020706@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Konrad Rzeszutek <konrad@virtualiron.com>, Jens Axboe <jens.axboe@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 02:26:21PM -0400, Ric Wheeler wrote:
> >Should there be a comment/Documentation blurb on how to remediate a
> >misaligment? Such as how to modify the partition tables and what to look
> >for in the BIOS (if anything) to take advantage of 4K sectors?
> >
> >Is there a corresponding patch for fdisk that understands 4K sectors? Or
> >is that already covered by it doing ioctl calls on the block device?
> 
> We need to update the various tools to deal with this data and prevent 
> misalignment, some of which is going on already.
> 
> I am afraid that if you are misaligned, the only remedy would be to tar up 
> your data, recreate an aligned device and then restore :-)

We could write a dd_move command (analagous to memmove) that reads a chunk
of your block device into memory, then writes it back shifted slightly.

Of course, if you lose power midway through, you're completely hosed.

A better solution might be for the filesystem to perform subsequent
writes to the device that are aligned.  I'm thinking about the case
where you've been using a filesystem on one device, you dd it to another
device (accidentally misaligning it) and then start modifying it on the
new device.  If all writes on the new drive go to an aligned address,
the performance implications shouldn't be too bad.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
