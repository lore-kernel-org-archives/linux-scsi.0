Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A650C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 12:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F712076B
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 12:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="NzwDJiBs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgHCMFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:05:03 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:38637 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726600AbgHCMEq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 08:04:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596456283; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Q9ewY6f6T4tJS+bov5J8Mts7nZEqC8N1FwJDh5ZScHE=;
 b=NzwDJiBsPCzxzFHDXksx+NOLCTrrpAIu1JtPTjCcqd8onXTjgUESx9dbU3FfLbSH8snPmrRN
 j3MfreeygYal/Qn465Y/p1FCGxUYzLVU2vbkErCChSeLXGKABO3by2J7q59I6UFL9U6z9bdB
 UsSDzmWhP0WCuC6+xKpNCy/N0s8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5f27fd5bbcdc2fe4712adc3f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 03 Aug 2020 12:04:43
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 87C20C43391; Mon,  3 Aug 2020 12:04:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CA541C433C9;
        Mon,  3 Aug 2020 12:04:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 03 Aug 2020 20:04:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com
Subject: Re: [PATCH v7] scsi: ufs: Quiesce all scsi devices before shutdown
In-Reply-To: <ee423cd3b5c42942a8895a8f08a26e68@codeaurora.org>
References: <20200803100448.2738-1-stanley.chu@mediatek.com>
 <ee423cd3b5c42942a8895a8f08a26e68@codeaurora.org>
Message-ID: <e413ec4cf7ff317615efd74aa925356a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Slightly updated my comments

On 2020-08-03 19:50, Can Guo wrote:
> Hi Stanley,
> 
> On 2020-08-03 18:04, Stanley Chu wrote:
>> Currently I/O request could be still submitted to UFS device while
>> UFS is working on shutdown flow. This may lead to racing as below
>> scenarios and finally system may crash due to unclocked register
>> accesses.
>> 
>> To fix this kind of issues, in ufshcd_shutdown(),
>> 
>> 1. Use pm_runtime_get_sync() instead of resuming UFS device by
>>    ufshcd_runtime_resume() "internally" to let runtime PM framework
>>    manage and prevent concurrent runtime operations by incoming I/O
>>    requests.
>> 
>> 2. Specifically quiesce all SCSI devices to block all I/O requests
>>    after device is resumed.
>> 
>> Example of racing scenario: While UFS device is runtime-suspended
>> 
>> Thread #1: Executing UFS shutdown flow, e.g.,
>>            ufshcd_suspend(UFS_SHUTDOWN_PM)
>> 
>> Thread #2: Executing runtime resume flow triggered by I/O request,
>>            e.g., ufshcd_resume(UFS_RUNTIME_PM)
>> 
>> This breaks the assumption that UFS PM flows can not be running
>> concurrently and some unexpected racing behavior may happen.
>> 
>> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>> ---
>> Changes:
>>   - Since v6:
>> 	- Do quiesce to all SCSI devices.
>>   - Since v4:
>> 	- Use pm_runtime_get_sync() instead of resuming UFS device by
>> ufshcd_runtime_resume() "internally".
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 27 ++++++++++++++++++++++-----
>>  1 file changed, 22 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 307622284239..7cb220b3fde0 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8640,6 +8640,7 @@ EXPORT_SYMBOL(ufshcd_runtime_idle);
>>  int ufshcd_shutdown(struct ufs_hba *hba)
>>  {
>>  	int ret = 0;
>> +	struct scsi_target *starget;
>> 
>>  	if (!hba->is_powered)
>>  		goto out;
>> @@ -8647,11 +8648,27 @@ int ufshcd_shutdown(struct ufs_hba *hba)
>>  	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
>>  		goto out;
>> 
>> -	if (pm_runtime_suspended(hba->dev)) {
>> -		ret = ufshcd_runtime_resume(hba);
>> -		if (ret)
>> -			goto out;
>> -	}
>> +	/*
>> +	 * Let runtime PM framework manage and prevent concurrent runtime
>> +	 * operations with shutdown flow.
>> +	 */
>> +	pm_runtime_get_sync(hba->dev);
>> +
>> +	/*
>> +	 * Quiesce all SCSI devices to prevent any non-PM requests sending
>> +	 * from block layer during and after shutdown.
>> +	 *
>> +	 * Here we can not use blk_cleanup_queue() since PM requests
>> +	 * (with BLK_MQ_REQ_PREEMPT flag) are still required to be sent
>> +	 * through block layer. Therefore SCSI command queued after the
>> +	 * scsi_target_quiesce() call returned will block until
>> +	 * blk_cleanup_queue() is called.
>> +	 *
>> +	 * Besides, scsi_target_"un"quiesce (e.g., scsi_target_resume) can
>> +	 * be ignored since shutdown is one-way flow.
>> +	 */
>> +	list_for_each_entry(starget, &hba->host->__targets, siblings)
>> +		scsi_target_quiesce(starget);
>> 
> 
> Sorry for misleading you to scsi_target_quiesce(), maybe below is 
> better.
> 
>     shost_for_each_device(sdev, hba->host)
>         scsi_device_quiesce(sdev);
> 
> We may need to discuss more about this quiesce part since I missed 
> something.
> 
> After we quiesce the scsi devices, only PM requests are allowed, but it
> is still not safe: [1] PM requests can still pass through, [2] there 
> can
> be tasks/reqs present in doorbells before the devices are quiesced. So,
> these tasks/reqs in [1] and [2] can still be flying in parallel while
> ufshcd_suspend is running.
> 
> How about only quiescing the UFS device well known scsi device but 
> using
> freeze_queue to the other scsi devices? blk_mq_freeze_queue can 
> eliminate
> the risks mentioned in [1] and [2].
> 
>      shost_for_each_device(sdev, hba->host) {
>          if (sdev == hba->sdev_ufs_device)
>               scsi_device_quiesce(sdev);
>          else
>               blk_mq_freeze_queue(sdev->request_queue);
>      }
> 
> IF blk_mq_freeze_queue is not allowed to be used by LLD (I think we can
> use it as I recalled Bart used to use it in one of his changes to UFS 
> scaling),
> we can use scsi_remove_device instead, it changes scsi device's state 
> to
> SDEV_DEL and calls blk_cleanup_queue.
> 
> We can also make changes like below. [1] is to make sure no more PM 
> requests
> sent to scsi devices, [2] is make sure doorbells are cleared before 
> invoke
> ufshcd_suspend.
> 
>     shost_for_each_device(sdev, hba->host) {
>         scsi_autopm_get_device(sdev); [1]
>         scsi_device_quiesce(sdev);
>     }
> 
>     ufshcd_wait_for_doorbell_clr(hba, U64_MAX); [2]
> 
> Please let me know which one you prefer or if you have better idea, 
> thanks!
> 
> Regards,
> 
> Can Guo.
> 
>>  	ret = ufshcd_suspend(hba, UFS_SHUTDOWN_PM);
>>  out:
