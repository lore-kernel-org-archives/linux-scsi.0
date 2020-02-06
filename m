Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59686C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 08:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2176520720
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 08:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Yd5/EuFs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgBFIJT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 03:09:19 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:54232 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbgBFIJT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 03:09:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580976558; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UR4pcD6kHt3ajr7Ug3n5divxQiNCuXB4xxvOg0HUq6k=;
 b=Yd5/EuFsfJSiB8OCNIV/IYagoL1mSvFOQX/Vw8c1vOU/JTpshxVkh2hBHI/kqqM46Iqm5B8E
 MQKrEdAhrLcn9XI5yQyudE7U5xrNpPMj6SJHmwdUhaJ2sV8zZulSmQPd69DkfIUP9gOLRV4H
 OR/qoaKHvhTmXJSGgAuTUIRkV8I=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3bc9a7.7f7f24ee1228-smtp-out-n01;
 Thu, 06 Feb 2020 08:09:11 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 028E6C447A2; Thu,  6 Feb 2020 08:09:10 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D74F5C43383;
        Thu,  6 Feb 2020 08:09:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Feb 2020 16:09:09 +0800
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
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] scsi: ufs: Add dev ref clock gating wait time support
In-Reply-To: <MN2PR04MB69914C6980E32674B38F9152FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1580972212-29881-1-git-send-email-cang@codeaurora.org>
 <1580972212-29881-7-git-send-email-cang@codeaurora.org>
 <MN2PR04MB69914C6980E32674B38F9152FC1D0@MN2PR04MB6991.namprd04.prod.outlook.com>
Message-ID: <6222003c478f11ce6fb6564e722800a0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-06 15:57, Avri Altman wrote:
>> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime 
>> defines
>> the minimum time for which the reference clock is required by device 
>> during
>> transition to LS-MODE or HIBERN8 state. Make this change to reflect 
>> the new
>> requirement by adding delays before turning off the clock.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
>> Reviewed-by: Bean Huo <beanhuo@micron.com>
>> 
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>> index cfe3803..990cb48 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -167,6 +167,7 @@ enum attr_idn {
>>         QUERY_ATTR_IDN_FFU_STATUS               = 0x14,
>>         QUERY_ATTR_IDN_PSA_STATE                = 0x15,
>>         QUERY_ATTR_IDN_PSA_DATA_SIZE            = 0x16,
>> +       QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME = 0x17,
>>  };
>> 
>>  /* Descriptor idn for Query requests */
>> @@ -534,6 +535,8 @@ struct ufs_dev_info {
>>         u16 wmanufacturerid;
>>         /*UFS device Product Name */
>>         u8 *model;
>> +       u16 wspecversion;
>> +       u32 clk_gating_wait_us;
>>  };
>> 
>>  /**
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index e8f7f9d..76beaf9 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -91,6 +91,9 @@
>>  /* default delay of autosuspend: 2000 ms */
>>  #define RPM_AUTOSUSPEND_DELAY_MS 2000
>> 
>> +/* Default value of wait time before gating device ref clock */
>> +#define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
>> +
>>  #define ufshcd_toggle_vreg(_dev, _vreg, _on)                          
>>  \
>>         ({                                                             
>>  \
>>                 int _ret;                                              
>>  \
>> @@ -3281,6 +3284,29 @@ static inline int
>> ufshcd_read_unit_desc_param(struct ufs_hba *hba,
>>                                       param_offset, param_read_buf, 
>> param_size);
>>  }
>> 
>> +static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
>> +{
>> +       int err = 0;
>> +       u32 gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
>> +
>> +       if (hba->dev_info.wspecversion >= 0x300) {
>> +               err = ufshcd_query_attr_retry(hba,
>> UPIU_QUERY_OPCODE_READ_ATTR,
>> +                               
>> QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME, 0, 0,
>> +                               &gating_wait);
>> +               if (err)
>> +                       dev_err(hba->dev, "Failed reading 
>> bRefClkGatingWait. err =
>> %d, use default %uus\n",
>> +                                        err, gating_wait);
>> +
>> +               if (gating_wait == 0) {
>> +                       gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
>> +                       dev_err(hba->dev, "Undefined ref clk gating 
>> wait time, use
>> default %uus\n",
>> +                                        gating_wait);
>> +               }
> 
> You forgot to set
> hba->dev_info.clk_gating_wait_us = gating_wait
> 
> Thanks,
> Avri

oops, shall add it back. Thanks.

Can Guo
