Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B43C55182
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 06:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C6F20CC7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 06:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vQmfxwM1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgDUGB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 02:01:29 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:62024 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbgDUGB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 02:01:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587448888; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UHhQSl23mVF75ah5gdbC88+420hzwfoQQOGiSxbyQmw=;
 b=vQmfxwM1+Zq2btBHmmnWzsFr+x5C0a9mWxCGnyDrBCM5kuChYhZKbn79WGDoynsQpGBq7bwz
 w+r8Zuh8qfoi3kqK0MKZKQHvrpn/wR1rLuPq5SIvc8HT+Y7g7bQPHCUauPcsklfVwb+bdzIx
 C45u6Aq15ekP2yjmNXpUeqERJpc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9e8c0b.7fe7ea7eadc0-smtp-out-n02;
 Tue, 21 Apr 2020 06:00:43 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 43ADEC433F2; Tue, 21 Apr 2020 06:00:42 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C8284C433D2;
        Tue, 21 Apr 2020 06:00:41 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 Apr 2020 14:00:41 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 03/10] scsi: ufs: add quirk to enable host controller
 without hce
In-Reply-To: <f03a005a77a96d337aa5d532c534577e@codeaurora.org>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
 <CGME20200417181012epcas5p2004ac8f0d793abd4d58c096ff490da68@epcas5p2.samsung.com>
 <20200417175944.47189-4-alim.akhtar@samsung.com>
 <f03a005a77a96d337aa5d532c534577e@codeaurora.org>
Message-ID: <4c262b2a842d1a517248c101896e15ff@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-21 13:59, Can Guo wrote:
> On 2020-04-18 01:59, Alim Akhtar wrote:
>> Some host controllers don't support host controller enable via HCE.
>> 
>> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> 
> They are back again finally...
> 
> Reviewd-by: Can Guo <cang@codeaurora.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> 
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 76 
>> +++++++++++++++++++++++++++++++++++++--
>>  drivers/scsi/ufs/ufshcd.h |  6 ++++
>>  2 files changed, 80 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 0e9704da58bd..ee30ed6cc805 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -3534,6 +3534,52 @@ static int ufshcd_dme_link_startup(struct 
>> ufs_hba *hba)
>>  			"dme-link-startup: error code %d\n", ret);
>>  	return ret;
>>  }
>> +/**
>> + * ufshcd_dme_reset - UIC command for DME_RESET
>> + * @hba: per adapter instance
>> + *
>> + * DME_RESET command is issued in order to reset UniPro stack.
>> + * This function now deal with cold reset.
>> + *
>> + * Returns 0 on success, non-zero value on failure
>> + */
>> +static int ufshcd_dme_reset(struct ufs_hba *hba)
>> +{
>> +	struct uic_command uic_cmd = {0};
>> +	int ret;
>> +
>> +	uic_cmd.command = UIC_CMD_DME_RESET;
>> +
>> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>> +	if (ret)
>> +		dev_err(hba->dev,
>> +			"dme-reset: error code %d\n", ret);
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * ufshcd_dme_enable - UIC command for DME_ENABLE
>> + * @hba: per adapter instance
>> + *
>> + * DME_ENABLE command is issued in order to enable UniPro stack.
>> + *
>> + * Returns 0 on success, non-zero value on failure
>> + */
>> +static int ufshcd_dme_enable(struct ufs_hba *hba)
>> +{
>> +	struct uic_command uic_cmd = {0};
>> +	int ret;
>> +
>> +	uic_cmd.command = UIC_CMD_DME_ENABLE;
>> +
>> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
>> +	if (ret)
>> +		dev_err(hba->dev,
>> +			"dme-reset: error code %d\n", ret);
>> +
>> +	return ret;
>> +}
>> 
>>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba 
>> *hba)
>>  {
>> @@ -4251,7 +4297,7 @@ static inline void ufshcd_hba_stop(struct
>> ufs_hba *hba, bool can_sleep)
>>  }
>> 
>>  /**
>> - * ufshcd_hba_enable - initialize the controller
>> + * ufshcd_hba_execute_hce - initialize the controller
>>   * @hba: per adapter instance
>>   *
>>   * The controller resets itself and controller firmware 
>> initialization
>> @@ -4260,7 +4306,7 @@ static inline void ufshcd_hba_stop(struct
>> ufs_hba *hba, bool can_sleep)
>>   *
>>   * Returns 0 on success, non-zero value on failure
>>   */
>> -int ufshcd_hba_enable(struct ufs_hba *hba)
>> +static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>>  {
>>  	int retry;
>> 
>> @@ -4308,6 +4354,32 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
>> 
>>  	return 0;
>>  }
>> +
>> +int ufshcd_hba_enable(struct ufs_hba *hba)
>> +{
>> +	int ret;
>> +
>> +	if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
>> +		ufshcd_set_link_off(hba);
>> +		ufshcd_vops_hce_enable_notify(hba, PRE_CHANGE);
>> +
>> +		/* enable UIC related interrupts */
>> +		ufshcd_enable_intr(hba, UFSHCD_UIC_MASK);
>> +		ret = ufshcd_dme_reset(hba);
>> +		if (!ret) {
>> +			ret = ufshcd_dme_enable(hba);
>> +			if (!ret)
>> +				ufshcd_vops_hce_enable_notify(hba, POST_CHANGE);
>> +			if (ret)
>> +				dev_err(hba->dev,
>> +					"Host controller enable failed with non-hce\n");
>> +		}
>> +	} else {
>> +		ret = ufshcd_hba_execute_hce(hba);
>> +	}
>> +
>> +	return ret;
>> +}
>>  EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
>> 
>>  static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 53096642f9a8..f8d08cb9caf7 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -529,6 +529,12 @@ enum ufshcd_quirks {
>>  	 * that the interrupt aggregation timer and counter are reset by 
>> s/w.
>>  	 */
>>  	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
>> +
>> +	/*
>> +	 * This quirks needs to be enabled if host controller cannot be
>> +	 * enabled via HCE register.
>> +	 */
>> +	UFSHCI_QUIRK_BROKEN_HCE				= 1 << 8,
>>  };
>> 
>>  enum ufshcd_caps {
