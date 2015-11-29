From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: block: Always check queue limits for cloned requests
Date: Sun, 29 Nov 2015 17:15:32 +0100
Message-ID: <20151129161532.GA302@x4>
References: <1448524017-130967-1-git-send-email-hare@suse.de>
 <20151126131104.GA24297@redhat.com>
 <20151129114956.GA321@x4>
 <565B1D2A.5010603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:50256 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbbK2QPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2015 11:15:35 -0500
Content-Disposition: inline
In-Reply-To: <565B1D2A.5010603@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

On 2015.11.29 at 16:43 +0100, Hannes Reinecke wrote:
> On 11/29/2015 12:49 PM, Markus Trippelsdorf wrote:
> > On 2015.11.26 at 08:11 -0500, Mike Snitzer wrote:
> >> On Thu, Nov 26 2015 at  2:46am -0500,
> >> Hannes Reinecke <hare@suse.de> wrote:
> >>
> >>> When a cloned request is retried on other queues it always needs
> >>> to be checked against the queue limits of that queue.
> >>> Otherwise the calculations for nr_phys_segments might be wrong,
> >>> leading to a crash in scsi_init_sgtable().
> >>>
> >>> To clarify this the patch renames blk_rq_check_limits()
> >>> to blk_cloned_rq_check_limits() and removes the symbol
> >>> export, as the new function should only be used for
> >>> cloned requests and never exported.
> >>>
> >>> Cc: Mike Snitzer <snitzer@redhat.com>
> >>> Cc: Ewan Milne <emilne@redhat.com>
> >>> Cc: Jeff Moyer <jmoyer@redhat.com>
> >>> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >>
> >> Patch looks good.  Thanks for getting to the bottom of this.
> >>
> >> Jens, please add these extra tags when you pick this up:
> >>
> >> Fixes: e2a60da74 ("block: Clean up special command handling logic")
> >> Cc: stable@vger.kernel.org # 3.7+
> >> Acked-by: Mike Snitzer <snitzer@redhat.com>
> > 
> > I'm still seeing the issue (BUG at drivers/scsi/scsi_lib.c:1096!) even
> > with this patch applied.
> > 
> > markus@x4 linux % git describe
> > v4.4-rc2-215-g081f3698e606
> > 
> Can you generate a crashdump?
> I would need to cross-check with the other dumps I'm having to figure
> out if this really is the same issue.
> There have been other reports (and fixes) which show we're fighting
> several distinct issues here.

Unfortunately no. The crash happens on the disk where I store my log
files. And after it happened the magic SysRq keys don't work anymore.

The crash only happens on my spinning rust drive that uses the cfq
scheduler. The SSDs (deadline) are fine.

The BUG happens reproducibly when building http://www.sagemath.org/ on
that drive.

-- 
Markus
