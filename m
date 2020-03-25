Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FC2C1975A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 08:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A372D20714
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 08:56:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lh5L0X84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgCYI4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 04:56:50 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:42144 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727299AbgCYI4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 04:56:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585126609; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=662V76aKosOhR0NwjziZiUV5ztE2ikA4eLXKCXRhr8M=;
 b=lh5L0X84+JJSK7ilyNXPu1fcD40Age3zvwdz9LdTpanmG5LUW8BsuRtVfGADBIFMpSGFIKr4
 XqgNbYLifql9VTwWbqUjvTgNrQkkWQ8NgDXInQsz0WPk5p5R2IldKWRG0nJo8X4TsPz79c6s
 QMH4BBAc18GZ0cDnNgfg1OM3Q/Y=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7b1cc7.7f0ca6e57b58-smtp-out-n02;
 Wed, 25 Mar 2020 08:56:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76B2DC43636; Wed, 25 Mar 2020 08:56:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F3DDCC433BA;
        Wed, 25 Mar 2020 08:56:37 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Mar 2020 16:56:37 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Clean up ufshcd_scale_clks() and clock
 scaling error out path
In-Reply-To: <SN6PR04MB4640E8EF26802A44B1F5D38AFCF70@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1584342373-10282-1-git-send-email-cang@codeaurora.org>
 <1584342373-10282-2-git-send-email-cang@codeaurora.org>
 <SN6PR04MB4640E8EF26802A44B1F5D38AFCF70@SN6PR04MB4640.namprd04.prod.outlook.com>
Message-ID: <d930bd05f2614092e6d8d3ef62017d89@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-18 16:19, Avri Altman wrote:
> Hi,
> 
>> 
>> From: Subhash Jadavani <subhashj@codeaurora.org>
>> 
>> This change introduces a func ufshcd_set_clk_freq() to explicitly
>> set clock frequency so that it can be used in reset_and_resotre path 
>> and
>> in ufshcd_scale_clks(). Meanwhile, this change cleans up the clock 
>> scaling
>> error out path.
>> 
>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 2a2a63b..63aaa88f 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -855,28 +855,29 @@ static bool
>> ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
>>                 return false;
>>  }
>> 
>> -static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
>> +/**
>> + * ufshcd_set_clk_freq - set UFS controller clock frequencies
>> + * @hba: per adapter instance
>> + * @scale_up: If True, set max possible frequency othewise set low
>> frequency
>> + *
>> + * Returns 0 if successful
>> + * Returns < 0 for any other errors
>> + */
>> +static int ufshcd_set_clk_freq(struct ufs_hba *hba, bool scale_up)
> Personally I prefer using the convention of "__scale_clks" to describe
> the privet core of scale_clks,
> But I know that many people are against it.
> 
>>  {
>>         int ret = 0;
>>         struct ufs_clk_info *clki;
>>         struct list_head *head = &hba->clk_list_head;
>> -       ktime_t start = ktime_get();
>> -       bool clk_state_changed = false;
>> 
>>         if (list_empty(head))
>>                 goto out;
>> 
>> -       ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
>> -       if (ret)
>> -               return ret;
>> -
>>         list_for_each_entry(clki, head, list) {
>>                 if (!IS_ERR_OR_NULL(clki->clk)) {
>>                         if (scale_up && clki->max_freq) {
>>                                 if (clki->curr_freq == clki->max_freq)
>>                                         continue;
>> 
>> -                               clk_state_changed = true;
>>                                 ret = clk_set_rate(clki->clk, 
>> clki->max_freq);
>>                                 if (ret) {
>>                                         dev_err(hba->dev, "%s: %s clk 
>> set rate(%dHz) failed,
>> %d\n",
>> @@ -895,7 +896,6 @@ static int ufshcd_scale_clks(struct ufs_hba *hba,
>> bool scale_up)
>>                                 if (clki->curr_freq == clki->min_freq)
>>                                         continue;
>> 
>> -                               clk_state_changed = true;
>>                                 ret = clk_set_rate(clki->clk, 
>> clki->min_freq);
>>                                 if (ret) {
>>                                         dev_err(hba->dev, "%s: %s clk 
>> set rate(%dHz) failed,
>> %d\n",
>> @@ -914,13 +914,36 @@ static int ufshcd_scale_clks(struct ufs_hba 
>> *hba,
>> bool scale_up)
>>                                 clki->name, clk_get_rate(clki->clk));
>>         }
>> 
>> +out:
>> +       return ret;
>> +}
>> +
>> +/**
>> + * ufshcd_scale_clks - scale up or scale down UFS controller clocks
>> + * @hba: per adapter instance
>> + * @scale_up: True if scaling up and false if scaling down
>> + *
>> + * Returns 0 if successful
>> + * Returns < 0 for any other errors
>> + */
>> +static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up)
>> +{
>> +       int ret = 0;
>> +
>> +       ret = ufshcd_vops_clk_scale_notify(hba, scale_up, PRE_CHANGE);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = ufshcd_set_clk_freq(hba, scale_up);
>> +       if (ret)
>> +               return ret;
>> +
>>         ret = ufshcd_vops_clk_scale_notify(hba, scale_up, 
>> POST_CHANGE);
>> +       if (ret) {
>> +               ufshcd_set_clk_freq(hba, !scale_up);
>> +               return ret;
>> +       }
>> 
>> -out:
>> -       if (clk_state_changed)
>> -               trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
>> -                       (scale_up ? "up" : "down"),
>> -                       ktime_to_us(ktime_sub(ktime_get(), start)), 
>> ret);
> 
> Why remove the ufshcd_profile_clk_scaling trace?
> 
> 

Shall add it back, this is just a collection of Subhash's changes.

>>         return ret;
>>  }
>> 
>> @@ -1106,35 +1129,36 @@ static int ufshcd_devfreq_scale(struct ufs_hba
>> *hba, bool scale_up)
>> 
>>         ret = ufshcd_clock_scaling_prepare(hba);
>>         if (ret)
>> -               return ret;
>> +               goto out;
> Are you fixing here a hold without release?
> Should make note of that.
> 

Yes, true

>> 
>>         /* scale down the gear before scaling down clocks */
>>         if (!scale_up) {
>>                 ret = ufshcd_scale_gear(hba, false);
>>                 if (ret)
>> -                       goto out;
>> +                       goto clk_scaling_unprepare;
>>         }
>> 
>>         ret = ufshcd_scale_clks(hba, scale_up);
>> -       if (ret) {
>> -               if (!scale_up)
>> -                       ufshcd_scale_gear(hba, true);
>> -               goto out;
>> -       }
>> +       if (ret)
>> +               goto scale_up_gear;
>> 
>>         /* scale up the gear after scaling up clocks */
>>         if (scale_up) {
>>                 ret = ufshcd_scale_gear(hba, true);
>>                 if (ret) {
>>                         ufshcd_scale_clks(hba, false);
>> -                       goto out;
>> +                       goto clk_scaling_unprepare;
>>                 }
>>         }
>> 
>> -       ret = ufshcd_vops_clk_scale_notify(hba, scale_up, 
>> POST_CHANGE);
>> +       goto clk_scaling_unprepare;
> I think you should find a way to make this function more readable.
> Adding all those "spaghetti" gotos making it even harder to read.
> 
> Thanks,
> Avri
> 

This is just a collection of Subhash's changes. I think the 2
clk_scaling_unprepare and out gotos make sense, but the
scale_up_gear goto is a bit vague. I will remove the
scale_up_gear goto.

Thanks,

Can Guo.

>> 
>> -out:
>> +scale_up_gear:
>> +       if (!scale_up)
>> +               ufshcd_scale_gear(hba, true);
>> +clk_scaling_unprepare:
>>         ufshcd_clock_scaling_unprepare(hba);
>> +out:
>>         ufshcd_release(hba);
>>         return ret;
>>  }
>> @@ -6251,7 +6275,7 @@ static int ufshcd_host_reset_and_restore(struct
>> ufs_hba *hba)
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> 
>>         /* scale up clocks to max frequency before full 
>> reinitialization */
>> -       ufshcd_scale_clks(hba, true);
>> +       ufshcd_set_clk_freq(hba, true);
>> 
>>         err = ufshcd_hba_enable(hba);
>>         if (err)
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
>> Linux Foundation Collaborative Project.
