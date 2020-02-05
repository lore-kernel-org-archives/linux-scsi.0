Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB55C35249
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 04:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4654F217F4
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 04:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="AmpZDnHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgBEEwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 23:52:22 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:53358 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727836AbgBEEwV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Feb 2020 23:52:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580878340; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=qIsXFy+HHp7SSvQVHd8PMPwqr2p1gsi3igCBMs8ZZZg=;
 b=AmpZDnHmZPgFmIBLtIxHyDsGhMppomTCve1hMzFKLXzb3FLzeK8vcos2W8I6Jf+KzPuv6m4H
 N7vgUUW2KYxFAo0l8diwsfsVGGPiCmeYNb6ELIQhh308B4FeoJYp8iPjNaCarxQ6hF0ZqA3T
 pjnY1ZydJ5MynInZWJYPJhjPhjE=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3a49fb.7f46fdfc9dc0-smtp-out-n03;
 Wed, 05 Feb 2020 04:52:11 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B9D1BC447A6; Wed,  5 Feb 2020 04:52:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85B99C43383;
        Wed,  5 Feb 2020 04:52:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 05 Feb 2020 12:52:10 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
In-Reply-To: <1580871040.21785.7.camel@mtksdccf07>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-7-git-send-email-cang@codeaurora.org>
 <1580871040.21785.7.camel@mtksdccf07>
Message-ID: <d37515ab264b0c46848ee2b88ba0a676@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-02-05 10:50, Stanley Chu wrote:
> Hi Can,
> 
> On Mon, 2020-02-03 at 01:17 -0800, Can Guo wrote:
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
>> ---
>>  drivers/scsi/ufs/ufs.h    |  3 +++
>>  drivers/scsi/ufs/ufshcd.c | 40 
>> ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 43 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>> index cfe3803..304076e 100644
>> --- a/drivers/scsi/ufs/ufs.h
>> +++ b/drivers/scsi/ufs/ufs.h
>> @@ -167,6 +167,7 @@ enum attr_idn {
>>  	QUERY_ATTR_IDN_FFU_STATUS		= 0x14,
>>  	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
>>  	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
>> +	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
>>  };
>> 
>>  /* Descriptor idn for Query requests */
>> @@ -534,6 +535,8 @@ struct ufs_dev_info {
>>  	u16 wmanufacturerid;
>>  	/*UFS device Product Name */
>>  	u8 *model;
>> +	u16 spec_version;
>> +	u32 clk_gating_wait_us;
>>  };
>> 
>>  /**
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index e8f7f9d..d5c547b 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -91,6 +91,9 @@
>>  /* default delay of autosuspend: 2000 ms */
>>  #define RPM_AUTOSUSPEND_DELAY_MS 2000
>> 
>> +/* Default value of wait time before gating device ref clock */
>> +#define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
>> +
>>  #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
>>  	({                                                              \
>>  		int _ret;                                               \
>> @@ -3281,6 +3284,37 @@ static inline int 
>> ufshcd_read_unit_desc_param(struct ufs_hba *hba,
>>  				      param_offset, param_read_buf, param_size);
>>  }
>> 
>> +static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
>> +{
>> +	int err = 0;
>> +	u32 gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
>> +
>> +	if (hba->dev_info.spec_version >= 0x300) {
>> +		err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>> +				QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME, 0, 0,
>> +				&gating_wait);
>> +		if (err)
>> +			dev_err(hba->dev, "Failed reading bRefClkGatingWait. err = %d, use 
>> default %uus\n",
>> +					 err, gating_wait);
>> +
>> +		if (gating_wait == 0) {
>> +			gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
>> +			dev_err(hba->dev, "Undefined ref clk gating wait time, use default 
>> %uus\n",
>> +					 gating_wait);
>> +		}
>> +
>> +		/*
>> +		 * bRefClkGatingWaitTime defines the minimum time for which the
>> +		 * reference clock is required by device during transition from
>> +		 * HS-MODE to LS-MODE or HIBERN8 state. Give it more time to be
>> +		 * on the safe side.
>> +		 */
>> +		hba->dev_info.clk_gating_wait_us = gating_wait + 50;
> 
> 
> Not sure if the additional 50us wait time here is too large.
> 
> Is there any special reason to fix it as "50"?
> 
> 
> Thanks,
> Stanley
> 

Hi Stanley,

We used to ask vendors about it, 50 is somehow agreed by them. Do you 
have a
better value in mind?

For me, I just wanted to give it 10, so that we can directly use 
usleep_range
with it, no need to decide whether to use udelay or usleep_range.

Thanks,
Can Guo.

>>  				      &dev_info->model, SD_ASCII_STD);
>> @@ -7003,6 +7041,8 @@ static int ufshcd_device_params_init(struct 
>> ufs_hba *hba)
>>  		goto out;
>>  	}
>> 
>> +	ufshcd_get_ref_clk_gating_wait(hba);
>> +
>>  	ufs_fixup_device_setup(hba);
>> 
>>  	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
