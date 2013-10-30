From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] [SCSI] hpsa: fix return value check in start_controller_lockup_detector()
Date: Wed, 30 Oct 2013 08:33:15 -0500
Message-ID: <20131030133315.GD31390@beardog.cce.hp.com>
References: <CAPgLHd8NoumfDWXN7fqDucWJ7Nr0KppW=24sCJpn9ynGOzLhcQ@mail.gmail.com> <20131029160927.GB31390@beardog.cce.hp.com> <1383083558.2071.38.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:11305 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3J3Nd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2013 09:33:26 -0400
Content-Disposition: inline
In-Reply-To: <1383083558.2071.38.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, yongjun_wei@trendmicro.com.cn, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com

On Tue, Oct 29, 2013 at 02:52:38PM -0700, James Bottomley wrote:
> On Tue, 2013-10-29 at 11:09 -0500, scameron@beardog.cce.hp.com wrote:
> > On Tue, Oct 29, 2013 at 02:43:56PM +0800, Wei Yongjun wrote:
> > > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > 
> > > In case of error, the function kthread_run() returns ERR_PTR()
> > > and never returns NULL. The NULL test in the return value check
> > > should be replaced with IS_ERR().
> > > 
> > > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > ---
> > >  drivers/scsi/hpsa.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > > index 891c86b..f413b14 100644
> > > --- a/drivers/scsi/hpsa.c
> > > +++ b/drivers/scsi/hpsa.c
> > > @@ -4757,7 +4757,8 @@ static void start_controller_lockup_detector(struct ctlr_info *h)
> > >  			kthread_run(detect_controller_lockup_thread,
> > >  						NULL, HPSA);
> > >  	}
> > > -	if (!hpsa_lockup_detector) {
> > > +	if (IS_ERR(hpsa_lockup_detector)) {
> > > +		hpsa_lockup_detector = NULL;
> > >  		dev_warn(&h->pdev->dev,
> > >  			"Could not start lockup detector thread\n");
> > >  		return;
> > 
> > Ack.
> 
> Hmm, this whole lockup thread start/stop thing is horribly racy with
> hotplug (and bind and unbind).
> 
> Firstly, why do you need an actual thread, why not just use a workqueue?
> That way you don't need a list or a lock, you can just schedule work for
> each instance?  since they don't interfere, no global list and no lock.
> 
> If you insist on a thread, it should probably start at module insertion
> and be shut down at module removal, so no races.  You can have it sleep
> forever on list_empty(&hpsa_ctlr_list) and wake it when you add a
> controller.

Alright, I'll work on it.  Thanks.

-- steve

