From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Fri, 13 May 2016 01:13:19 +0800
Message-ID: <CAGnHSEm_iQF7o1sLWecR2=rDDinZHfZ2ii9zfjU-dighwetWoA@mail.gmail.com>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
	<20160512040433.GA20240@ad.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:35000 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbcELRNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2016 13:13:23 -0400
Received: by mail-qg0-f68.google.com with SMTP id b14so5199576qge.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2016 10:13:23 -0700 (PDT)
In-Reply-To: <20160512040433.GA20240@ad.usersys.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

On 12 May 2016 at 12:04, Fam Zheng <famz@redhat.com> wrote:
>
> Following is:
>
>         else
>                 rw_max = BLK_DEF_MAX_SECTORS;
>
> Which seems in sector unit, and is already making above change suspicious, and

Yes BLK_DEF_MAX_SECTORS is in sector unit. It has been bumped from
1024 to 2560 not long ago btw:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/include/linux/blkdev.h?id=d2be537c3ba3568acd79cd178327b842e60d035e

I suppose the code should be changed to something like this:
...
{
rw_max = sdkp->opt_xfer_blocks;
q->limits.io_opt = rw_max * sdp->sector_size;
}

> further down:
>
>         /* Combine with controller limits */
>         q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
>
> looks like a unit mismatch to me.  IIUC q->limits.max_sectors _is_ in sector
> unit, similar to queue_max_hw_sectors().
>
> Is the error reported by Christian fixed just because we are setting an
> incorrect high max?

However in the worst case max_sectors should still be limited by
max_hw_sectors, which apparently depends on the host. For example uas
devices (without any quirks) have max_hw_sectors set to 1024
(SCSI_DEFAULT_MAX_SECTORS defined in include/scsi/scsi_host.h).

Speaking of this, shouldn't SCSI_DEFAULT_MAX_SECTORS be increased? For
example at least to the new BLK_DEF_MAX_SECTORS (2560), or maybe even
SD_DEF_XFER_BLOCKS (65535)?
