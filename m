From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 0/3] Fix return code for ioctl( BLKRRPART ) if device is
 down
Date: Thu, 16 Apr 2015 13:05:41 +0800
Message-ID: <20150416050541.GC28705@ad.nay.redhat.com>
References: <1427192175-23802-1-git-send-email-famz@redhat.com>
 <55113DC7.7080002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbbDPFFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2015 01:05:44 -0400
Content-Disposition: inline
In-Reply-To: <55113DC7.7080002@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>

On Tue, 03/24 11:34, Paolo Bonzini wrote:
> 
> 
> On 24/03/2015 11:16, Fam Zheng wrote:
> > If issued right after link down, "blockdev --rereadpt" will be stuck for a
> > while and then return normally. Although the underlying capacity and partition
> > table are not correctly updated. And it means that userspace can't detect the
> > error at all.
> > 
> > Fix this by propargating the error of "read capacity" command through the
> > stack, so that the ioctl could fail with -EIO.
> > 
> > Fam Zheng (3):
> >   block: Return error in rescan_partitions if revalidating disk failed
> >   sd: Return error in sd_revalidate_disk if read capacity failed
> >   sd: Return -EIO if read capacity failed
> > 
> >  block/partition-generic.c |  6 +++---
> >  drivers/scsi/sd.c         | 22 +++++++++++++---------
> >  2 files changed, 16 insertions(+), 12 deletions(-)
> > 
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Ping?

> 
> Though patch 3 could be seen as a change in userspace ABI, so I'm less
> sure about it.
> 
> Paolo
