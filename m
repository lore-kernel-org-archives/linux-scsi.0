Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8ABC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:24:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEE672311E
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbhAGHYM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 02:24:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:55066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbhAGHYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 02:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B17220702;
        Thu,  7 Jan 2021 07:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610004210;
        bh=6KhvmE4wUi+XZRq4eWjtyniBSLyYK9acVOXUw/p1uPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d5ReWQERkJPbWchSBskud+rC/Q70WV1dcFFjevLqd1/ORikxQNv3WU1/Uix4Om5Oc
         /eBK6IkKdnqj84uqxM0POUoQ6Ts+MepN2IR9M2XqQEzAIZfSc3Zu3VK5puEEHUkWXi
         1ml0rs8TogCAA7xhMAgnKwTyf0GyGxLuHsVBuo30BvYk0yy2EyEi0k0EuCa5H6UJFh
         v76RQtE6c3ym3H+eQtJJs4SnjLjyefK30UUgOsZpfjOUn1h+iDuVxbj7HPd6dMM+eJ
         fhhT7Y5WXG4s+SCyvNWmudBGLTFRJqbCpx8KEEE2E+Lu1o78PfdCZr8AoNXXzBV5eH
         +1yl4IMTjkH+g==
Date:   Wed, 6 Jan 2021 23:23:29 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v3 2/2] scsi: ufs: handle LINERESET with correct tm_cmd
Message-ID: <X/a28Y8JbKoXHvOs@google.com>
References: <20210106214109.44041-1-jaegeuk@kernel.org>
 <20210106214109.44041-3-jaegeuk@kernel.org>
 <163fae07a94933230e0432e2ca584040@codeaurora.org>
 <X/avWNrpOzWMj6xY@google.com>
 <7261bef7d8aa003d7f8fc984e37390bb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7261bef7d8aa003d7f8fc984e37390bb@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/07, Can Guo wrote:
> On 2021-01-07 14:51, Jaegeuk Kim wrote:
> > On 01/07, Can Guo wrote:
> > > On 2021-01-07 05:41, Jaegeuk Kim wrote:
> > > > From: Jaegeuk Kim <jaegeuk@google.com>
> > > >
> > > > This fixes a warning caused by wrong reserve tag usage in
> > > > __ufshcd_issue_tm_cmd.
> > > >
> > > > WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 blk_get_request+0x68/0x70
> > > > WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82
> > > > blk_mq_get_tag+0x438/0x46c
> > > >
> > > > And, in ufshcd_err_handler(), we can avoid to send tm_cmd before
> > > > aborting
> > > > outstanding commands by waiting a bit for IO completion like this.
> > > >
> > > > __ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out
> > > >
> > > 
> > > Would you mind add a Fixes tag?
> > 
> > Ok.
> > 
> > > 
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > ---
> > > >  drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++++++++++----
> > > >  1 file changed, 32 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > > index 1678cec08b51..47fc8da3cbf9 100644
> > > > --- a/drivers/scsi/ufs/ufshcd.c
> > > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > > @@ -44,6 +44,9 @@
> > > >  /* Query request timeout */
> > > >  #define QUERY_REQ_TIMEOUT 1500 /* 1.5 seconds */
> > > >
> > > > +/* LINERESET TIME OUT */
> > > > +#define LINERESET_IO_TIMEOUT_MS			(30000) /* 30 sec */
> > > > +
> > > >  /* Task management command timeout */
> > > >  #define TM_CMD_TIMEOUT	100 /* msecs */
> > > >
> > > > @@ -5899,6 +5902,8 @@ static void ufshcd_err_handler(struct work_struct
> > > > *work)
> > > >  	 * check if power mode restore is needed.
> > > >  	 */
> > > >  	if (hba->saved_uic_err & UFSHCD_UIC_PA_GENERIC_ERROR) {
> > > > +		ktime_t start = ktime_get();
> > > > +
> > > >  		hba->saved_uic_err &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
> > > >  		if (!hba->saved_uic_err)
> > > >  			hba->saved_err &= ~UIC_ERROR;
> > > > @@ -5906,6 +5911,20 @@ static void ufshcd_err_handler(struct work_struct
> > > > *work)
> > > >  		if (ufshcd_is_pwr_mode_restore_needed(hba))
> > > >  			needs_restore = true;
> > > >  		spin_lock_irqsave(hba->host->host_lock, flags);
> > > > +		/* Wait for IO completion to avoid aborting IOs */
> > > > +		while (hba->outstanding_reqs) {
> > > > +			ufshcd_complete_requests(hba);
> > > > +			spin_unlock_irqrestore(hba->host->host_lock, flags);
> > > > +			schedule();
> > > > +			spin_lock_irqsave(hba->host->host_lock, flags);
> > > > +			if (ktime_to_ms(ktime_sub(ktime_get(), start)) >
> > > > +						LINERESET_IO_TIMEOUT_MS) {
> > > > +				dev_err(hba->dev, "%s: timeout, outstanding=0x%lx\n",
> > > > +					__func__, hba->outstanding_reqs);
> > > > +				break;
> > > > +			}
> > > > +		}
> > > > +
> > > >  		if (!hba->saved_err && !needs_restore)
> > > >  			goto skip_err_handling;
> > > >  	}
> > > > @@ -6302,9 +6321,13 @@ static irqreturn_t ufshcd_intr(int irq, void
> > > > *__hba)
> > > >  		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> > > >  	}
> > > >
> > > > -	if (enabled_intr_status && retval == IRQ_NONE) {
> > > > -		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
> > > > -					__func__, intr_status);
> > > > +	if (enabled_intr_status && retval == IRQ_NONE &&
> > > > +				!ufshcd_eh_in_progress(hba)) {
> > > > +		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x,
> > > > 0x%08x)\n",
> > > > +					__func__,
> > > > +					intr_status,
> > > > +					hba->ufs_stats.last_intr_status,
> > > > +					enabled_intr_status);
> > > >  		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
> > > >  	}
> > > >
> > > > @@ -6348,7 +6371,11 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
> > > > *hba,
> > > >  	 * Even though we use wait_event() which sleeps indefinitely,
> > > >  	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
> > > >  	 */
> > > > -	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
> > > > +	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED |
> > > > +						BLK_MQ_REQ_NOWAIT);
> > > 
> > > Sorry that I didn't pay much attention to this part of code before.
> > > May I know why must we use the BLK_MQ_REQ_RESERVED flag?
> > 
> > What I understood is the reserved tag is used when aborting outstanding
> > IOs when all the 32 tags were used.
> > 
> 
> No, the tm requests and I/O requests are on two different tag sets:
> tm requests come from hba->tmf_tag_set, while I/O requests come from
> hba->shost->tag_set. Meaning they don't share tags with each other.

I see. :)

> 
> > > 
> > > Thanks,
> > > Can Guo.
> > > 
> > > > +	if (IS_ERR(req))
> > > > +		return PTR_ERR(req);
> > > > +
> > > >  	req->end_io_data = &wait;
> > > >  	free_slot = req->tag;
> > > >  	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
> > > > @@ -9355,6 +9382,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> > > > __iomem *mmio_base, unsigned int irq)
> > > >
> > > >  	hba->tmf_tag_set = (struct blk_mq_tag_set) {
> > > >  		.nr_hw_queues	= 1,
> > > > +		.reserved_tags	= 1,
> > > 
> > > If we give reserved_tags as 1 and always ask for a tm requst with
> > > BLK_MQ_REQ_RESERVED flag set, then the tag shall only be allocated
> > > from the reserved sbitmap_queue, whose depth is set to 1 here.
> > > UFS supports tm queue depth as 8, but here is allowing only one tm
> > > req at a time. Why? Please correct me if my understanding is wrong.
> > 
> > I couldn't find tm can be issued in parallel, so thought it was issued
> > one at a time. If we set 8, then we can use 24 for IOs, IIUC.
> > 
> > Please correct me as well. I'm still trying to understand the flow.
> > 
> 
> UFS allows a queue depth as 8, which means it support sending multiple
> tm requests at the same time. You can check commit 69a6c269c097d780a2 -
> before this change, we used to use below func to allocate tags for
> tm reqs, which can tell you the true story.
> 
> So I am thinking why don't we just we remove the BLK_MQ_REQ_RESERVED flag?
> Removing it can also fix the warning I suppose. What do you think?

Yeah, I believe it won't give a warning. Okay, let me check it out.

> 
> -static bool ufshcd_get_tm_free_slot(struct ufs_hba *hba, int *free_slot)
> -{
> -       int tag;
> -       bool ret = false;
> -
> -       if (!free_slot)
> -               goto out;
> -
> -       do {
> -               tag = find_first_zero_bit(&hba->tm_slots_in_use,
> hba->nutmrs);
> -               if (tag >= hba->nutmrs)
> -                       goto out;
> -       } while (test_and_set_bit_lock(tag, &hba->tm_slots_in_use));
> -
> -       *free_slot = tag;
> -       ret = true;
> -out:
> -       return ret;
> -}
> 
> Thanks,
> Can Guo.
> 
> > > 
> > > Thanks,
> > > Can Guo.
> > > 
> > > >  		.queue_depth	= hba->nutmrs,
> > > >  		.ops		= &ufshcd_tmf_ops,
> > > >  		.flags		= BLK_MQ_F_NO_SCHED,
