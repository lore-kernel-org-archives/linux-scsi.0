Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9ABC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A46664E24
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhBAIQ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 03:16:56 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:36172 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231598AbhBAIQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 03:16:55 -0500
X-Greylist: delayed 353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2021 03:16:54 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612167390; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7q0hkkI7/SV27tS3zZ2DRirnX6KJs9dHuIgjQx1XVLU=;
 b=VDpvxZEpYqyb0TWQROBcsYEKr/7lI2GTXi1joQtyDOroHbmZd3pHIkMp2jz8ris6dM9iouhC
 Aiqmle1LNXMoF0DMkZKxJiaD3REHOJX4QOfWDnOc6aINgxAMLVSlb/yJAF2C2p+Xkv/BTTZX
 z5cYv0bp9CVkpV1KcsEICD3RZVE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6017b7647a21b36a9d30efd4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Feb 2021 08:10:12
 GMT
Sender: nitirawa=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3FA96C43465; Mon,  1 Feb 2021 08:10:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nitirawa)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 20FBFC433C6;
        Mon,  1 Feb 2021 08:10:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 13:40:10 +0530
From:   nitirawa@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Bao D . Nguyen" <nguyenb@codeaurora.org>
Subject: Re: [PATCH V1 1/3] scsi: ufs: export api for use in vendor file
In-Reply-To: <DM6PR04MB657574D3D8B99F3A4997D810FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
 <1611852899-2171-2-git-send-email-nitirawa@codeaurora.org>
 <DM6PR04MB657574D3D8B99F3A4997D810FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <505fe60c90b13953d0fd0192aa9e6166@codeaurora.org>
X-Sender: nitirawa@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-31 19:29, Avri Altman wrote:
>> 
>> Exporting functions ufshcd_set_dev_pwr_mode, ufshcd_disable_vreg
>> and ufshcd_enable_vreg so that vendor drivers can make use of
>> them in setting vendor specific regulator setting
>> in vendor specific file.
> As for ufshcd_{enable,disable}_vreg - maybe inline ufshcd_toggle_vreg
> and use it instead?
> 
>> 
>> Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
>> Signed-off-by: Bao D. Nguyen <nguyenb@codeaurora.org>
>> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 9 ++++++---
>>  drivers/scsi/ufs/ufshcd.h | 4 ++++
>>  2 files changed, 10 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 9c691e4..000a03a 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8091,7 +8091,7 @@ static int ufshcd_config_vreg(struct device 
>> *dev,
>>         return ret;
>>  }
>> 
>> -static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg 
>> *vreg)
>> +int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
>>  {
>>         int ret = 0;
>> 
>> @@ -8110,8 +8110,9 @@ static int ufshcd_enable_vreg(struct device 
>> *dev,
>> struct ufs_vreg *vreg)
>>  out:
>>         return ret;
>>  }
>> +EXPORT_SYMBOL(ufshcd_enable_vreg);
> Why do you need to export it across the kernel?
> Isn't making it non-static suffices?
> Do you need it for a loadable module?
> 
>> 
>> -static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg 
>> *vreg)
>> +int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
>>  {
>>         int ret = 0;
>> 
>> @@ -8131,6 +8132,7 @@ static int ufshcd_disable_vreg(struct device 
>> *dev,
>> struct ufs_vreg *vreg)
>>  out:
>>         return ret;
>>  }
>> +EXPORT_SYMBOL(ufshcd_disable_vreg);
>> 
>>  static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on)
>>  {
>> @@ -8455,7 +8457,7 @@ ufshcd_send_request_sense(struct ufs_hba *hba,
>> struct scsi_device *sdp)
>>   * Returns 0 if requested power mode is set successfully
>>   * Returns non-zero if failed to set the requested power mode
>>   */
>> -static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>> +int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>>                                      enum ufs_dev_pwr_mode pwr_mode)
>>  {
>>         unsigned char cmd[6] = { START_STOP };
>> @@ -8513,6 +8515,7 @@ static int ufshcd_set_dev_pwr_mode(struct 
>> ufs_hba
>> *hba,
>>         hba->host->eh_noresume = 0;
>>         return ret;
>>  }
>> +EXPORT_SYMBOL(ufshcd_set_dev_pwr_mode);
>> 
>>  static int ufshcd_link_state_transition(struct ufs_hba *hba,
>>                                         enum uic_link_state 
>> req_link_state,
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index ee61f82..1410c95 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -997,6 +997,10 @@ extern int ufshcd_dme_get_attr(struct ufs_hba 
>> *hba,
>> u32 attr_sel,
>>                                u32 *mib_val, u8 peer);
>>  extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>>                         struct ufs_pa_layer_attr *desired_pwr_mode);
>> +extern int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>> +                                               enum ufs_dev_pwr_mode 
>> pwr_mode);
>> +extern int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg 
>> *vreg);
>> +extern int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg 
>> *vreg);
>> 
>>  /* UIC command interfaces for DME primitives */
>>  #define DME_LOCAL      0
>> --
>> 2.7.4

Hi Avri,
Thanks for reviewing it.
ufs-qcom.c can be a loadable module, so just inlining won't suffice in 
that case.
Hence export is needed.

Thanks,
Nitin
