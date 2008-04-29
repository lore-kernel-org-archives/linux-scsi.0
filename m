From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/6] add large command support to the block layer
Date: Tue, 29 Apr 2008 21:45:34 +0900
Message-ID: <20080429214614T.tomof@acm.org>
References: <58cb370e0804290455m3892d5efi6ab293075f8277ca@mail.gmail.com>
	<20080429213325P.tomof@acm.org>
	<20080429123712.GO12774@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:38990 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbYD2Mts (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Apr 2008 08:49:48 -0400
In-Reply-To: <20080429123712.GO12774@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bharrosh@panasas.com, James.Bottomley@hansenpartnership.com, agk@redhat.com, Geert.Uytterhoeven@sonycom.com

On Tue, 29 Apr 2008 14:37:12 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Apr 29 2008, FUJITA Tomonori wrote:
> > On Tue, 29 Apr 2008 13:55:13 +0200
> > "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com> wrote:
> > 
> > > On Tue, Apr 29, 2008 at 9:54 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > >
> > > > On Sat, Apr 26 2008, FUJITA Tomonori wrote:
> > > >  > This is an updated patchset for large command support to the block
> > > >  > layer:
> > > >  >
> > > >  > http://marc.info/?l=linux-scsi&m=120817127118449&w=2
> > > >  >
> > > >  > We rarely handle large commands. So for optimization, a struct request
> > > >  > still has a static array for a command. rq_init sets rq->cmd pointer
> > > >  > to the static array. In short, rq_init() does
> > > >  >
> > > >  > rq->cmd = rq->__cmd;
> > > >  >
> > > >  > So we can access to rq->cmd and rq->cmd_len as before.
> > > >  >
> > > >  > This change requires everyone to initialize the request in a proper
> > > >  > way (that is, just doing a memset() will not work). Now we have
> > > >  > rq_init() that works for any path so this patchset can cleanly convert
> > > >  > users of requests on the stack or kmalloced requests to use it (the
> > > >  > previous patchset does it in a hacky way):
> > > >  >
> > > >  > http://marc.info/?l=linux-scsi&m=120911792725876&w=2
> > > >  >
> > > >  > This patchset is against Jens' for-linus branch.
> > > >  >
> > > >  > #1-#4 patches can be applied via Jens' tree now. #5 patch is for
> > > >  > IDE. It cleanly can be applied to both Bart's latest quilt tree and
> > > >  > Jens' tree though Bart's quilt tree has some pending IDE patches. #4
> > > >  > patch depends on #4. #6 patch depends on #1-#5.
> > > >  >
> > > >  > I guess that the easiest way to apply this patchset would be:
> > > >  >
> > > >  > 1. Pushing Bart's quilt tree to mainline.
> > > >  > 2. Rebasing Jens' tree to mainline.
> > > >  > 3. Pushing this patchset via Jens' tree.
> > > >  >
> > > >  > Jens and Bart, let me know if I can do something to make the process
> > > >  > easier.
> > > >  >
> > > >  > Bart, I will try to push the patchset to remove the requests on the
> > > >  > stack for 2.6.27:
> > > >  >
> > > >  > http://marc.info/?l=linux-ide&m=120882410712466&w=2
> > > >
> > > >  I've applied all patches to the for-linus branch, it should go up
> > > >  soonish. If anyone has problems with this, please holler SOON.
> > > 
> > > Fine with me (patches look good and survived quick testing).
> > 
> > Thanks,
> > 
> > 
> > > My only concern is that the final series from Tomo lacked
> > > 
> > > 	"block: replace sizeof(rq->cmd) with BLK_MAX_CDB"
> > > 
> > > and it is also not in for-linus branch (it has to be merged
> > > before "block: add large command support" patch or ide-cd
> > > will break).
> > 
> > Sorry, somehow I forgot to put it in the patchset. Yeah, probabaly
> > initializing only 4 (or 8) bytes in rq->cmd would not work for ide-cd.
> > 
> > Jens, please put this to the for-linus branch.
> 
> Done, please inspect the result (and ordering), thanks.

Thanks, it should work.

BTW, I think that the commit 09225d2 in for-linus branch (block: make
queue flags non-atomic) needs to export blk_run_queue.
