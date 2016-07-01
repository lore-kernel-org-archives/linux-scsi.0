From: Howard Cochran <hcochran@kernelspring.com>
Subject: Re: [PATCH] sd: Fix crash due to race when removing scsi disk
Date: Fri, 1 Jul 2016 13:34:33 -0400
Message-ID: <CAEvdpX2Rv9f84tmwAeO0y+wj9609ucYV2tteJCZLoySidtO0JA@mail.gmail.com>
References: <1467389699-10571-1-git-send-email-hcochran@kernelspring.com> <1467390990.2341.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:35144 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbcGARee (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2016 13:34:34 -0400
Received: by mail-oi0-f44.google.com with SMTP id r2so120085735oih.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2016 10:34:34 -0700 (PDT)
In-Reply-To: <1467390990.2341.31.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Howard Cochran <cochran@lexmark.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org

On Fri, Jul 1, 2016 at 12:36 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2016-07-01 at 12:14 -0400, Howard Cochran wrote:
>>

>> This patch fixes the race by making sd_remove() hold bd_mutex during
>> the call to del_gendisk().
>
> OK, so this can't be the proper fix because it's a layering violation.
>  You can see this if you consider what happens to any other block
> device doing the same thing: they would oops in the same way, implying
> that this fix would have to be replicated to every other block device
> remove path.  Instead place to fix it should be somewhere inside the
> block subsystem.  My suspicion is that it should probably be in
> del_gendisk() because that will fix every device, but the block people
> should think more about the problem (linux-block cc added).
>
> James

James,

I originally attempted to fix this by grabbing bd_mutex inside
del_gendisk(). However, I surveyed the kernel and found that some other
block drivers already hold bd_mutex when calling del_gendisk(), so that
would deadlock. For example: blkfront_closing() and blkfront_remove() in
drivers/block/xen-blkfront.c

Some of them ensure that there can be no dirty blocks in the same code
path prior to calling del_gendisk() (e.g. zram_remove()).

Other drivers (e.g. loop) appear to only allow removal via an ioctl(),
which, by definition, means that you have an bd_openers, and therefore
cannot have cleared the bdev->bd_disk pointer.

In fact, it appeared that sd.c may have the only "out of band" way to
remove a device via its "delete" node, but now I see that oasdblk.c has
a "remove" node that appears susceptible to this problem.  Another may
be mg_disk.c

OK, so indeed, a more general solution is needed. But taking bd_mutex
inside del_gendisk() does not appear to be it. Perhaps making
mapping_cap_writeback_dirty() not have to dereference bdev->bd_disk
would be better (as it didn't prior to de1414a654e6)?

Howard
