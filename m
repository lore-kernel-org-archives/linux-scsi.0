Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3B1C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6060722DBF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgLUCiU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:38:20 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:26803 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgLUCiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:38:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608518274; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=97dgF1cOD7h2R3jEjxNUO21gMCHQ35s85F14RfWUWi8=;
 b=akddDcNJ+zYTxoZma51+uErlsasjCGaPzz954kt17dx5V6y3glzCg7/T1ksU5RB5OKu6xBM7
 8nWMTWjSQqZ5AH+H0QceHAxIqTOcuuzrDdjNVBXs8aNygh0MQiCDkPo0e83ULKfYVrdsFzSE
 ltawKBrYKq8Ft2BtDsDNCwYeayE=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5fe00a5a7549779c5b463c8b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Dec 2020 02:37:14
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 30B43C43465; Mon, 21 Dec 2020 02:37:13 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C5F60C433C6;
        Mon, 21 Dec 2020 02:37:11 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Dec 2020 10:37:11 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Subject: Re: [RFC PATCH v1] ufs: relocate turning off device power sources
In-Reply-To: <000001d6d73a$e44dd770$ace98650$@samsung.com>
References: <CGME20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599@epcas2p1.samsung.com>
 <1608359248-16079-1-git-send-email-kwmad.kim@samsung.com>
 <3d662ee3155a56108da13e3cf12f17dc@codeaurora.org>
 <000001d6d73a$e44dd770$ace98650$@samsung.com>
Message-ID: <ba859a31c04068671dfca42aa7cf9d05@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-21 09:44, Kiwoong Kim wrote:
>> On 2020-12-19 14:27, Kiwoong Kim wrote:
>> > UFS specification says that while powering off the device, RST_n
>> > signal and REF_CLK signal should be between VSS and VCCQ.
>> > One of ways to make it is to drive both RST_n and REF_CLK to low.
>> >
>> > However, the current location of turning off them doesn't guarantee
>> > that. ufshcd_link_state_transition make enter hibern8 but it's not
>> > supposed to adjust the level of REF_CLK. Adding
>> > ufshcd_vops_device_reset isn't proper because it just drives the level
>> > of RST_n to low and then to high, not keep low.
>> > In this situation, it could make those levels be diverged from those
>> > proper ranges with actual hardware situations, especially right when
>> > the driver turns off power.
>> >
>> > The easist way to make it is just to move the location of turning off
>> > because lowering the levels can be enabled through the callbacks named
>> > suspend and setup_clocks.
>> >
>> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
>> > ---
>> >  drivers/scsi/ufs/ufshcd.c | 9 +++++++--
>> >  1 file changed, 7 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > index 92d433d..dab9840 100644
>> > --- a/drivers/scsi/ufs/ufshcd.c
>> > +++ b/drivers/scsi/ufs/ufshcd.c
>> > @@ -8633,8 +8633,6 @@ static int ufshcd_suspend(struct ufs_hba *hba,
>> > enum ufs_pm_op pm_op)
>> >  	if (ret)
>> >  		goto set_dev_active;
>> >
>> > -	ufshcd_vreg_set_lpm(hba);
>> > -
>> >  disable_clks:
>> >  	/*
>> >  	 * Call vendor specific suspend callback. As these callbacks may
>> > access @@ -8662,6 +8660,13 @@ static int ufshcd_suspend(struct ufs_hba
>> > *hba, enum ufs_pm_op pm_op)
>> >  					hba->clk_gating.state);
>> >  	}
>> >
>> > +	/*
>> > +	 * It should follows driving RST_n and REF_CLK
>> > +	 * in the range specified in UFS specification
>> > +	 */
>> > +	if (!ufshcd_is_ufs_dev_active(hba))
>> > +		ufshcd_vreg_set_lpm(hba);
>> > +
>> >  	/* Put the host controller in low power mode if possible */
>> >  	ufshcd_hba_vreg_set_lpm(hba);
>> >  	goto out;
>> 
>> Ziqi Chen has a change to totally fix the UFS power-on/off spec 
>> violation,
>> see https://lore.kernel.org/patchwork/patch/1351118/ and he is working 
>> on
>> V2, can we wait for his change?
> 
> Two questions.
> 1. If his patch covers what I said, it's okay.

Yes, it does cover your fix as you can tell from V1.

> 2. What does he plan to post?

Within today.

Thanks,

Can Guo.

> What do you think?
> 
> Thanks.
> Kiwoong Kim
>> 
>> Thanks,
>> 
>> Can Guo.
