From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: Always check queue limits for cloned requests
Date: Sun, 29 Nov 2015 11:49:48 -0500
Message-ID: <20151129164947.GA15021@redhat.com>
References: <1448524017-130967-1-git-send-email-hare@suse.de>
 <20151126131104.GA24297@redhat.com>
 <20151129114956.GA321@x4>
 <565B1D2A.5010603@suse.de>
 <20151129161532.GA302@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbbK2Qtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Nov 2015 11:49:49 -0500
Content-Disposition: inline
In-Reply-To: <20151129161532.GA302@x4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

On Sun, Nov 29 2015 at 11:15am -0500,
Markus Trippelsdorf <markus@trippelsdorf.de> wrote:

> On 2015.11.29 at 16:43 +0100, Hannes Reinecke wrote:
> > On 11/29/2015 12:49 PM, Markus Trippelsdorf wrote:
> > > 
> > > I'm still seeing the issue (BUG at drivers/scsi/scsi_lib.c:1096!) even
> > > with this patch applied.
> > > 
> > > markus@x4 linux % git describe
> > > v4.4-rc2-215-g081f3698e606
> > > 
> > Can you generate a crashdump?
> > I would need to cross-check with the other dumps I'm having to figure
> > out if this really is the same issue.
> > There have been other reports (and fixes) which show we're fighting
> > several distinct issues here.
> 
> Unfortunately no. The crash happens on the disk where I store my log
> files. And after it happened the magic SysRq keys don't work anymore.
> 
> The crash only happens on my spinning rust drive that uses the cfq
> scheduler. The SSDs (deadline) are fine.
> 
> The BUG happens reproducibly when building http://www.sagemath.org/ on
> that drive.

Are you using DM multipath?  If unsure, please let us know which
device(s) map to the "spinning rust drive", and provide output from:
lsblk
