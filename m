Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83668C388F7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CAAE20809
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:12:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="PbbVPrCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421814AbgJZDMC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 23:12:02 -0400
Received: from z5.mailgun.us ([104.130.96.5]:29761 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1420939AbgJZDMC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 23:12:02 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603681921; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GkQq1NKiH6b1ab589HosLYnWoE9lNlF7O6rZsWzr/SA=;
 b=PbbVPrCIjC3mVTf/qfVlhsUKueGzohnZFMDhXu5ZHUXvSQufd44E6PtJFwS9+LrunvUDYHdA
 9yfRmST0jwn6MefAmK7A/0up8huNY0mntKHzRYmy9MgaOq8mydmVJkYObhL5dTTeWyWlxr6E
 a8nFVUzW2ZtowZjPcKkpfQnbcUg=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f963e8107e1682233949a0d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Oct 2020 03:12:01
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 28FD3C433C9; Mon, 26 Oct 2020 03:12:01 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4243EC433CB;
        Mon, 26 Oct 2020 03:12:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Oct 2020 11:12:00 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2 5/5] scsi: ufs: fix clkgating on/off correctly
In-Reply-To: <20201022201825.GA3329812@google.com>
References: <20201020195258.2005605-1-jaegeuk@kernel.org>
 <20201020195258.2005605-6-jaegeuk@kernel.org>
 <2a8ecc4185b3a5411077f4e3fc66000f@codeaurora.org>
 <20201021045213.GB3004521@google.com>
 <e3e58a89474d23f1b9446fe2e38a7426@codeaurora.org>
 <20201022201825.GA3329812@google.com>
Message-ID: <ccf9079dc1767c7d200fe55b5a849ba0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-23 08:53, Jaegeuk Kim wrote:
> On 10/21, Can Guo wrote:
>> On 2020-10-21 12:52, jaegeuk@kernel.org wrote:
>> > On 10/21, Can Guo wrote:
>> > > On 2020-10-21 03:52, Jaegeuk Kim wrote:
>> > > > The below call stack prevents clk_gating at every IO completion.
>> > > > We can remove the condition, ufshcd_any_tag_in_use(), since
>> > > > clkgating_work
>> > > > will check it again.
>> > > >
>> > >
>> > > I think checking ufshcd_any_tag_in_use() in either ufshcd_release() or
>> > > gate_work() can break UFS clk gating's functionality.
>> > >
>> > > ufshcd_any_tag_in_use() was introduced to replace hba->lrb_in_use.
>> > > However,
>> > > they are not exactly same - ufshcd_any_tag_in_use() returns true if
>> > > any tag
>> > > assigned from block layer is still in use, but tags are released
>> > > asynchronously
>> > > (through block softirq), meaning it does not reflect the real
>> > > occupation of
>> > > UFS host.
>> > > That is after UFS host finishes all tasks, ufshcd_any_tag_in_use()
>> > > can still
>> > > return true.
>> > >
>> > > This change only removes the check of ufshcd_any_tag_in_use() in
>> > > ufshcd_release(),
>> > > but having the check of it in gate_work() can still prevent gating
>> > > from
>> > > happening.
>> > > The current change works for you maybe because the tags are release
>> > > before
>> > > hba->clk_gating.delay_ms expires, but if hba->clk_gating.delay_ms is
>> > > shorter
>> > > or
>> > > somehow block softirq is retarded, gate_work() may have chance to see
>> > > ufshcd_any_tag_in_use()
>> > > returns true. What do you think?
>> >
>> > I don't think this breaks clkgating, but fix the wrong condition check
>> > which
>> > prevented gate_work at all. As you mentioned, even if this schedules
>> > gate_work
>> > by racy conditions, gate_work will handle it as a last resort.
>> >
>> 
>> If clocks cannot be gated after the last task is cleared from UFS 
>> host, then
>> clk gating
>> is broken, no? Assume UFS has completed the last task in its queue, as 
>> this
>> change says,
>> ufshcd_any_tag_in_use() is preventing ufshcd_release() from invoking
>> gate_work().
>> Similarly, ufshcd_any_tag_in_use() can prevent gate_work() from doing 
>> its
>> real work -
>> disabling the clocks. Do you agree?
>> 
>>         if (hba->clk_gating.active_reqs
>>                 || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
>>                 || ufshcd_any_tag_in_use(hba) || 
>> hba->outstanding_tasks
>>                 || hba->active_uic_cmd || hba->uic_async_done)
>>                 goto rel_lock;
> 
> I see the point, but this happens only when clkgate_delay_ms is too 
> short
> to give enough time for releasing tag. If it's correctly set, I think 
> there'd
> be no problem, unless softirq was delayed by other RT threads which is 
> just
> a corner case tho.
> 

Yes, we are fixing corner cases, aren't we? I thought you would like to
address it since you are fixing clk gating.

Regards,

Can Guo.

>> 
>> Thanks,
>> 
>> Can Guo.
>> 
>> > >
>> > > Thanks,
>> > >
>> > > Can Guo.
>> > >
>> > > In __ufshcd_transfer_req_compl
>> > > Ihba->lrb_in_use is cleared immediately when UFS driver
>> > > finishes all tasks
>> > >
>> > > > ufshcd_complete_requests(struct ufs_hba *hba)
>> > > >   ufshcd_transfer_req_compl()
>> > > >     __ufshcd_transfer_req_compl()
>> > > >       __ufshcd_release(hba)
>> > > >         if (ufshcd_any_tag_in_use() == 1)
>> > > >            return;
>> > > >   ufshcd_tmc_handler(hba);
>> > > >     blk_mq_tagset_busy_iter();
>> > > >
>> > > > Cc: Alim Akhtar <alim.akhtar@samsung.com>
>> > > > Cc: Avri Altman <avri.altman@wdc.com>
>> > > > Cc: Can Guo <cang@codeaurora.org>
>> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
>> > > > ---
>> > > >  drivers/scsi/ufs/ufshcd.c | 2 +-
>> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > > > index b5ca0effe636..cecbd4ace8b4 100644
>> > > > --- a/drivers/scsi/ufs/ufshcd.c
>> > > > +++ b/drivers/scsi/ufs/ufshcd.c
>> > > > @@ -1746,7 +1746,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
>> > > >
>> > > >  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
>> > > >  	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
>> > > > -	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
>> > > > +	    hba->outstanding_tasks ||
>> > > >  	    hba->active_uic_cmd || hba->uic_async_done)
>> > > >  		return;
