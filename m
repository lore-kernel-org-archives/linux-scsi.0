Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FD6C43331
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 02:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FBAE206F6
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 02:31:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="QsHumuai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgC1CbN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 22:31:13 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:21719 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbgC1CbN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 22:31:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585362672; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Of5ocX2I8A4I7iRsteJ/OLVXwTCgwzzL3AIvQdlsXYI=;
 b=QsHumuaiwx9AxmA6uF6ZfdomG2ngpNiVjV2SlNl7KYRgekqZqtssUEfnml2c4iQWmELA3/Ku
 7ArbZ7Djz2JV53LH8ZrDH5fEqB/i2HX5ed+MsJW9i9QyA4+CyYgazhnIURqlrsuTkFcCLiLq
 PjfZ6dtYP4fwFe0napR/HvuzcXc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e7eb6e2.7ff3070eb298-smtp-out-n03;
 Sat, 28 Mar 2020 02:30:58 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 939D4C44791; Sat, 28 Mar 2020 02:30:56 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EA983C433D2;
        Sat, 28 Mar 2020 02:30:54 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 28 Mar 2020 10:30:54 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 1/1] scsi: ufs: set device as active power mode after
 resetting device
In-Reply-To: <d5096a58cce94669fef459834134ffab@codeaurora.org>
References: <20200327095835.10293-1-stanley.chu@mediatek.com>
 <d5096a58cce94669fef459834134ffab@codeaurora.org>
Message-ID: <354de5d2a3bc4d19d2972885fa9189d1@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-03-28 10:14, Can Guo wrote:
> On 2020-03-27 17:58, Stanley Chu wrote:
>> Currently ufshcd driver assumes that bInitPowerMode parameter
>> is not changed by any vendors thus device power mode can be set as
>> "Active" during initialization.
>> 
>> According to UFS JEDEC specification, device power mode shall be
>> "Active" after HW Reset is triggered if the bInitPowerMode parameter
>> in Device Descriptor is default value.
>> 
>> By above description, we can set device power mode as "Active" after
>> device reset is triggered by vendor's callback. With this change,
>> the link startup performance can be improved in some cases
>> by not setting link_startup_again as true in ufshcd_link_startup().
>> 
>> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 13 -------------
>>  drivers/scsi/ufs/ufshcd.h | 14 ++++++++++++++
>>  2 files changed, 14 insertions(+), 13 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 227660a1a446..f0a35b289b7c 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -171,19 +171,6 @@ enum {
>>  #define ufshcd_clear_eh_in_progress(h) \
>>  	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
>> 
>> -#define ufshcd_set_ufs_dev_active(h) \
>> -	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
>> -#define ufshcd_set_ufs_dev_sleep(h) \
>> -	((h)->curr_dev_pwr_mode = UFS_SLEEP_PWR_MODE)
>> -#define ufshcd_set_ufs_dev_poweroff(h) \
>> -	((h)->curr_dev_pwr_mode = UFS_POWERDOWN_PWR_MODE)
>> -#define ufshcd_is_ufs_dev_active(h) \
>> -	((h)->curr_dev_pwr_mode == UFS_ACTIVE_PWR_MODE)
>> -#define ufshcd_is_ufs_dev_sleep(h) \
>> -	((h)->curr_dev_pwr_mode == UFS_SLEEP_PWR_MODE)
>> -#define ufshcd_is_ufs_dev_poweroff(h) \
>> -	((h)->curr_dev_pwr_mode == UFS_POWERDOWN_PWR_MODE)
>> -
>>  struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
>>  	{UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
>>  	{UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index b7bd81795c24..7a9d1d170719 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -129,6 +129,19 @@ enum uic_link_state {
>>  #define ufshcd_set_link_hibern8(hba) ((hba)->uic_link_state = \
>>  				    UIC_LINK_HIBERN8_STATE)
>> 
>> +#define ufshcd_set_ufs_dev_active(h) \
>> +	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
>> +#define ufshcd_set_ufs_dev_sleep(h) \
>> +	((h)->curr_dev_pwr_mode = UFS_SLEEP_PWR_MODE)
>> +#define ufshcd_set_ufs_dev_poweroff(h) \
>> +	((h)->curr_dev_pwr_mode = UFS_POWERDOWN_PWR_MODE)
>> +#define ufshcd_is_ufs_dev_active(h) \
>> +	((h)->curr_dev_pwr_mode == UFS_ACTIVE_PWR_MODE)
>> +#define ufshcd_is_ufs_dev_sleep(h) \
>> +	((h)->curr_dev_pwr_mode == UFS_SLEEP_PWR_MODE)
>> +#define ufshcd_is_ufs_dev_poweroff(h) \
>> +	((h)->curr_dev_pwr_mode == UFS_POWERDOWN_PWR_MODE)
>> +
>>  /*
>>   * UFS Power management levels.
>>   * Each level is in increasing order of power savings.
>> @@ -1091,6 +1104,7 @@ static inline void
>> ufshcd_vops_device_reset(struct ufs_hba *hba)
>>  {
>>  	if (hba->vops && hba->vops->device_reset) {
>>  		hba->vops->device_reset(hba);
>> +		ufshcd_set_ufs_dev_active(hba);
>>  		ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, 0);
>>  	}
>>  }
> 
> Reviewed-by: Can Guo <cang@codeaurora.org>

I guess what you also want my patch -

"scsi: ufs: full reinit upon resume if link was off"

Please help review it, thanks.

Best regard,
Can Guo.
