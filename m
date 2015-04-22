From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 1/3] block: Return error in rescan_partitions if
 revalidating disk failed
Date: Wed, 22 Apr 2015 12:13:10 +0800
Message-ID: <20150422041310.GF2723@ad.nay.redhat.com>
References: <1427192175-23802-1-git-send-email-famz@redhat.com>
 <1427192175-23802-2-git-send-email-famz@redhat.com>
 <1429671506.18798.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbbDVENP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2015 00:13:15 -0400
Content-Disposition: inline
In-Reply-To: <1429671506.18798.4.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On Tue, 04/21 19:58, James Bottomley wrote:
> On Tue, 2015-03-24 at 18:16 +0800, Fam Zheng wrote:
> > If the disk can't read capacity, we should return an error.
> 
> I'm not sure I buy this: you need to justify why.
> 
> For instance removable media return an error in revalidate that causes
> the medium not present flag to be set ... do we really want to propagate
> the error in that case?

I think we should. There is a command failed, and the user won't get a valid
disk size.

> 
> > Signed-off-by: Fam Zheng <famz@redhat.com>
> > ---
> >  block/partition-generic.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/block/partition-generic.c b/block/partition-generic.c
> > index 0d9e5f9..1e60d7d 100644
> > --- a/block/partition-generic.c
> > +++ b/block/partition-generic.c
> > @@ -427,11 +427,11 @@ rescan:
> >  		return res;
> >  
> >  	if (disk->fops->revalidate_disk)
> > -		disk->fops->revalidate_disk(disk);
> > +		res = disk->fops->revalidate_disk(disk);
> 
> You're assuming here that a negative error code is being returned, but
> some (cciss) seem to be returning 1 on error.
> 
> You'll need to assure us that you've checked all the consumers before
> making this change.

I'll look at the return values.

Fam

> 
> James
> 
> >  	check_disk_size_change(disk, bdev);
> >  	bdev->bd_invalidated = 0;
> > -	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
> > -		return 0;
> > +	if (res || !get_capacity(disk) || !(state = check_partition(disk, bdev)))
> > +		return res;
> >  	if (IS_ERR(state)) {
> >  		/*
> >  		 * I/O error reading the partition table.  If any
> 
> 
> 
