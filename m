Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93679C3B188
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 02:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 699D3206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 02:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="kmqENplD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgBMCxT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 21:53:19 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:53761 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729378AbgBMCxT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 21:53:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581562398; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=qAAa2KbFfMvP0Xd5tKYvsl66uX6NHBgKUC21HuQOjBU=;
 b=kmqENplDK8lQ4uYZYf16cgLWKcj7BoXCUYk+1q7hw4xXAQejL/SpUOwv0vz0ArKTGTPlJ59o
 OkR0gj284F7oSH1jLcYWugfslALn2T6LEsZGcqCcXYw4I/ZU3GMbb2DxN5teDMCXppYbwYTu
 OB94kmg+FR4MPxktqcs4eisNPHs=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e44ba1c.7fa3b0c77a40-smtp-out-n02;
 Thu, 13 Feb 2020 02:53:16 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 43D3BC433A2; Thu, 13 Feb 2020 02:53:16 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DDC35C43383;
        Thu, 13 Feb 2020 02:53:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 13 Feb 2020 10:53:13 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/2] scsi: ufs: Use ufshcd_config_pwr_mode() when scale
 gear
In-Reply-To: <MN2PR04MB6991136AD340D28D930F27F3FC1B0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
 <1581485910-8307-2-git-send-email-cang@codeaurora.org>
 <MN2PR04MB6991136AD340D28D930F27F3FC1B0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <5a54ea8f5c9f24a5c14b022d1d087a6d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-12 20:21, Avri Altman wrote:
> Hi,
> 
>> 
>> When scale gear, use ufshcd_config_pwr_mode() instead of
>> ufshcd_change_power_mode() so that
>> vops_pwr_change_notify(PRE_CHANGE)
>> can be utilized to allow vendors use customized settings before change
>> the power mode.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index adcce41..67bd4f2 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1059,8 +1059,7 @@ static int ufshcd_scale_gear(struct ufs_hba 
>> *hba,
>> bool scale_up)
>>         }
>> 
>>         /* check if the power mode needs to be changed or not? */
>> -       ret = ufshcd_change_power_mode(hba, &new_pwr_info);
>> -
>> +       ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
> 
> You might want to inform ufshcd_config_pwr_mode() of the caller,
> As now it will be called much more frequently, and you want/don't want
> To call your vops on probe but not on scale_gear?
> 
> Also, Alim exported ufshcd_config_pwr_mode a while ago,
> In commit 0d846e703dc8 "scsi: ufs: make ufshcd_config_pwr_mode of
> non-static func"),
> But nobody uses it outside ufshcd - so maybe revert this commit as
> part of this series?
> 
> 
> 

Hi Avri,

Thanks for your review and suggestion.

What I get from your suggestion is that add one more parameter to
ufshcd_config_pwr_mode(say: bool from_probe), and pass the param to
ufshcd_vops_pwr_change_notify() so that vendor drivers know where
is the call comes from? If I get it correctly, then yes, we can
do that.

However, in ufs-qcom.c, ufs_qcom_pwr_change_notify(PRE_CHANGE)
is fine being called every time whenever there is a power mode change,
we have no problem with that. And as we are the only user of clock 
scaling
in the latest code base, so this change does not impact any other 
vendors.
If later other vendors need to use clock scaling, they can do this
change as you suggested above.

As for the commit from Alim, I think I should leave it to Alim's
call on it, maybe he has changes that use this func outside ufshcd.c
but not uploaded yet.

Thanks,
Can Guo.

>>         if (ret)
>>                 dev_err(hba->dev, "%s: failed err %d, old gear: (tx %d 
>> rx %d), new
>> gear: (tx %d rx %d)",
>>                         __func__, ret,
>> @@ -4126,8 +4125,6 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>>                 memcpy(&final_params, desired_pwr_mode, 
>> sizeof(final_params));
>> 
>>         ret = ufshcd_change_power_mode(hba, &final_params);
>> -       if (!ret)
>> -               ufshcd_print_pwr_info(hba);
>> 
>>         return ret;
>>  }
>> @@ -7157,6 +7154,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
>> bool async)
>>                                         __func__, ret);
>>                         goto out;
>>                 }
>> +               ufshcd_print_pwr_info(hba);
>>         }
>> 
>>         /* set the state as operational after switching to desired 
>> gear */
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> Forum,
>> a Linux Foundation Collaborative Project
