From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 2/2] cciss:fix regression firmware not displayed in
 procfs (again and again)
Date: Wed, 22 Oct 2008 15:38:13 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884C01AB25E5@GVW0547EXC.americas.hpqcorp.net>
References: <20081021212322.GA6421@roadking.ldev.net>
 <20081021154408.ed96c9b3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17940 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYJVPiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 11:38:52 -0400
In-Reply-To: <20081021154408.ed96c9b3.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "adobriyan@gmail.com" <adobriyan@gmail.com>



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, October 21, 2008 5:44 PM
> To: Miller, Mike (OS Dev)
> Cc: jens.axboe@oracle.com; linux-kernel@vger.kernel.org;
> linux-scsi@vger.kernel.org; fujita.tomonori@lab.ntt.co.jp;
> adobriyan@gmail.com
> Subject: Re: [PATCH 2/2] cciss:fix regression firmware not
> displayed in procfs (again and again)
>
> On Tue, 21 Oct 2008 16:23:22 -0500
> Mike Miller <mike.miller@hp.com> wrote:
>
> > Patch 2 of 2
>
> What happened with "1 of 2"?

Andrew,
That was the patch to fix the sysfs symlink. You merged it and then superceded with my later patch.

--- snip -----

The patch titled
     cciss: fix sysfs regression
has been removed from the -mm tree.  Its filename was
     cciss-fix-sysfs-regression.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix sysfs regression
From: Mike Miller <mike.miller@hp.com>

Fix a broken symlink in sysfs.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/cciss.c~cciss-fix-sysfs-regression drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-sysfs-regression
+++ a/drivers/block/cciss.c
@@ -1365,6 +1365,7 @@ static void cciss_add_disk(ctlr_info_t *
        disk->first_minor = drv_index << NWD_SHIFT;
        disk->fops = &cciss_fops;
        disk->private_data = &h->drv[drv_index];
+       disk->driverfs_dev = &h->pdev->dev;

        /* Set up queue information */
        blk_queue_bounce_limit(disk->queue, h->pdev->dma_mask); _

Patches currently in -mm which might be from mike.miller@hp.com are

origin.patch
cciss-fix-sysfs-regression.patch

----snip-----

Actually, this looks like the right one.

-- mikem

>
> > Sorry for the delay. I've been out of the office and the
> network has
> > been down since before lunch CDT. This regression was introduced by
> > commit 6ae5ce8e8d4de666f31286808d2285aa6a50fa40.
> > This patch fixes a regression where the controller firmware
> version is
> > not displayed in procfs. The previous patch would be called anytime
> > something changed. This will get called only once for each
> controller.
> >
> > In this patch I again initialize *inq_buff to NULL per Tomo's
> > comments. I also use a goto clean 4 instead of returning
> -ENOMEM if the kzalloc fails.
> >
> > I hope this finally meets everyones expectations.
> >
> > Please consider this for inclusion.
> >
> > Signed-off-by: Mike Miller <mike.miller@hp.com>
>
> So this fix is needed in 2.6.27.x, yes?
>
