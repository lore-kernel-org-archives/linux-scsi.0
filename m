From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Revert "block: WARN in __blk_put_request() for
 potential bio leak"
Date: Wed, 10 Jun 2009 17:29:47 +0900
Message-ID: <20090610172956C.fujita.tomonori@lab.ntt.co.jp>
References: <4A2E645F.9090008@panasas.com>
	<20090610080039B.fujita.tomonori@lab.ntt.co.jp>
	<4A2F6B8E.8060700@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:44512 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZFJIaB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 04:30:01 -0400
In-Reply-To: <4A2F6B8E.8060700@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, 10 Jun 2009 11:15:10 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 06/10/2009 02:00 AM, FUJITA Tomonori wrote:
> > On Tue, 09 Jun 2009 16:32:15 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> On 06/09/2009 04:10 PM, FUJITA Tomonori wrote:
> >>> On Tue, 09 Jun 2009 14:53:51 +0300
> >>> Boaz Harrosh <bharrosh@panasas.com> wrote:
> >>>
> >>>> Please do not revert. This is the point of all this.
> >>>>
> >>>> If there is no leak, You should NULL out the req->bio
> >>>> for now, and for 2.6.31 change the code to do 
> >>>> blk_end_request_all(). That's what blk_end_request does,
> >>>> since you are doing your own completion then set req->bio
> >>>> to null after you're done. (And before put_request)
> >>>>
> >>>> This stuff is good for error paths to catch leaks, please
> >>>> leave it?
> >>> Has this your good stuff found any bio leak bugs in mainline? In
> >>> addition, breaking working code is not a proper development style.
> >>>
> >> It has found for me in error paths. That's why I put it.
> >>
> >> I Issue bsg bidi commands every day all day, and never seen this.
> >> What driver are you using? and can you post the stack trace.
> > 
> > See the original mail. I already said, "BSG SMP requests get the
> > following warnings". I use mptsas however all BSG SMP users hit this
> > bug. The stack trace is not useful because the bsg users don't call
> > blk_put_request directly.
> > 
> > But If you want to see:
> > 
> > Call Trace:
> >  [<ffffffff80320349>] ? __blk_put_request+0x52/0xc0
> >  [<ffffffff8022fd26>] warn_slowpath_common+0x77/0xa4
> >  [<ffffffff8022fd62>] warn_slowpath_null+0xf/0x11
> >  [<ffffffff80320349>] __blk_put_request+0x52/0xc0
> >  [<ffffffff803206d6>] ? blk_put_request+0x20/0x46
> >  [<ffffffff803206e4>] blk_put_request+0x2e/0x46
> >  [<ffffffff80327f64>] blk_complete_sgv4_hdr_rq+0x1a8/0x1b7
> >  [<ffffffff80328a36>] bsg_ioctl+0x1b4/0x1eb
> >  [<ffffffff8032dfea>] ? __up_read+0x1c/0x9a
> >  [<ffffffff804aab20>] ? _spin_unlock_irqrestore+0x3f/0x47
> >  [<ffffffff802a0f10>] vfs_ioctl+0x2a/0x78
> >  [<ffffffff802a13cc>] do_vfs_ioctl+0x46e/0x4aa
> >  [<ffffffff80246384>] ? up_read+0x26/0x2b
> >  [<ffffffff8020b8e9>] ? retint_swapgs+0xe/0x13
> >  [<ffffffff802a144a>] sys_ioctl+0x42/0x65
> >  [<ffffffff8020aeab>] system_call_fastpath+0x16/0x1b
> > 
> >> The driver does something wrong. bsg over scsi-ml does not have this
> >> problem. Why?
> > 
> > Because scsi-ml calls blk_end_request() but BSG SMP users don't.
> > 
> > 
> 
> That is a violation of block API. All block drivers must call
> blk_end_request().

Where can I find a documentation about it?

If not, can you stop claiming a new rule?

If you want to propose a new rule, you need to fix the existing users
first.


> If they do not, then they can not for example be
> called from inside Kernel. They relay on special bsg behavior
> that always uses map_user.

Of course, we send SMP requests only via BSG. SMP is the first reason
why we invented BSG.


> This must be fixed. So you see that WARN_ON was right on the spot ;)
> 
> >>> Anyway, setting req->bio in bsg works. Either is fine by me.
> >>>
> >>>
> >>> Jens, can you please send either patch to Linus now?
> >>>
> >>> =
> >>> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >>> Subject: [PATCH] bsg: setting rq->bio to NULL
> >>>
> >>> Due to commit 1cd96c242a829d52f7a5ae98f554ca9775429685 ("block: WARN
> >>> in __blk_put_request() for potential bio leak"), BSG SMP requests get
> >>> the false warnings:
> >>>
> >>> WARNING: at block/blk-core.c:1068 __blk_put_request+0x52/0xc0()
> >>>
> >>> This sets rq->bio to NULL to avoid that false warnings.
> >>>
> >>>
> >>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >>> ---
> >>>  block/bsg.c |    3 +++
> >>>  1 files changed, 3 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/block/bsg.c b/block/bsg.c
> >>> index 206060e..dd81be4 100644
> >>> --- a/block/bsg.c
> >>> +++ b/block/bsg.c
> >>> @@ -315,6 +315,7 @@ out:
> >>>  	blk_put_request(rq);
> >>>  	if (next_rq) {
> >>>  		blk_rq_unmap_user(next_rq->bio);
> >> I do not understand this here please explain? We have called blk_rq_map_user()
> >> and have bailed out on error later, without calling blk_execute_rq*. Now usually
> >> the bios are *double* referenced, one for the usual call of blk_end_request() that will
> >> release bios once, and second for the blk_rq_unmap_user() that will release second time.
> >> But here you only call blk_rq_unmap_user() don't you need to call blk_end_request() also?
> > 
> > If I understand correctly, blk_end_request() doesn't release bios of a
> > request that blk_rq_map_user was called against.
> > 
> 
> This is the part I do not understand. The comment in map_user says that the bio
> ref count is taken twice, so when reference drops once at  blk_end_request()
> the bio is not yet freed, but will so in unmap_user. But if blk_end_request()
> is not called then there is no double drop of reference. I do want to understand,
> how is the bio gets freed, is it forced some how?

Read the code. I think that you totally misunderstand these functions.


> > You can test this without any SAS hardware. Let me know when you find
> > a bio leak here.
> 
> How can I test this without SAS hardware? Please point me to documentation.

You don't need SAS hardware to play with blk_rq_map_user() and
blk_rq_unmap_user(). All you need to do is writing a module that play
with these functions.


> I do believe you that there is no leak, I just want to understand why?
> And any way, all "BSG SMP" drivers must be fixed to call blk_end_request().
> They can not be dependent on the specific ULD that calls them.
