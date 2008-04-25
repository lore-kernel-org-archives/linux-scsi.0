From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [dm-devel] [PATCH 2/6] block: no need to initialize rq->cmd
	with blk_get_request
Date: Sat, 26 Apr 2008 01:54:52 +0900
Message-ID: <20080426015440M.tomof@acm.org>
References: <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1209140607-28654-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1209141901.3087.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35751 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbYDYQ4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 12:56:24 -0400
In-Reply-To: <1209141901.3087.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, linux-ide@vger.kernel.org, bharrosh@panasas.com, agk@redhat.com

On Fri, 25 Apr 2008 11:45:01 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sat, 2008-04-26 at 01:23 +0900, FUJITA Tomonori wrote:
> > blk_get_request initializes rq->cmd (rq_init does) so the users don't
> > need to do that.
> > 
> > The purpose of this patch is to remove sizeof(rq->cmd) and &rq->cmd,
> > as a preparation for large command support, which changes rq->cmd from
> > the static array to a pointer. sizeof(rq->cmd) will not make sense and
> > &rq->cmd won't work.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Cc: Alasdair G Kergon <agk@redhat.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  block/scsi_ioctl.c          |    3 ---
> >  drivers/block/pktcdvd.c     |    2 --
> >  drivers/cdrom/cdrom.c       |    1 -
> 
> These:
> 
> >  drivers/md/dm-emc.c         |    2 --
> >  drivers/md/dm-mpath-hp-sw.c |    1 -
> >  drivers/md/dm-mpath-rdac.c  |    1 -
> 
> Conflict with this set of patches:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-pending-2.6.git;a=summary
> 
> Which move the dm pieces to being request based.  The patch series
> hasn't had an ACK yet from Alasdair, but it would be nice if you could
> look it over and see if it needs the memsets pulling out.

Seems that it needs the memsets pulling out. For example,

[PATCH 2/7] scsi_dh: add lsi rdac device handler has:

+	memset(&rq->cmd, 0, BLK_MAX_CDB);


Do you want a patch against scsi-pending?
