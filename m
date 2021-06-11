Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3561C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 03:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E94061178
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 03:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhFKDId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 23:08:33 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11379 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhFKDIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 23:08:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623380795; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=wexlSlPWte1V+0zEqCj9//EPjbPqVl3tfJdfC6N/SxU=;
 b=NrmFKDRjIu3ZFwnFNYvVf64q/hRLCJWPbwlOrAJKJ7ce+sJKIUvWkX8sU8jRG98HGw2z7+me
 j6mtjOzlw+KY2C9CA03eH4oGWO8qBLwQ9RcfMY9vaNI7p8MZFWEgP7kH8njZhT8XrazcjDZR
 NiXA+T0kBFbvlOZ+vpMts1lo/wU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 60c2d33a8491191eb355d58a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Jun 2021 03:06:34
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 22F91C4360C; Fri, 11 Jun 2021 03:06:34 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DA525C433D3;
        Fri, 11 Jun 2021 03:06:32 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Jun 2021 11:06:32 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 7/9] scsi: ufs: Let host_sem cover the entire system
 suspend/resume
In-Reply-To: <6d31becb-98f8-2302-8ffa-657e6cadd8ec@intel.com>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-8-git-send-email-cang@codeaurora.org>
 <6d31becb-98f8-2302-8ffa-657e6cadd8ec@intel.com>
Message-ID: <eb268cc191916686f45c161f3f191049@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Adrian,

On 2021-06-10 21:32, Adrian Hunter wrote:
> On 10/06/21 7:43 am, Can Guo wrote:
>> UFS error handling now is doing more than just re-probing, but also 
>> sending
>> scsi cmds, e.g., for clearing UACs, and recovering runtime PM error, 
>> which
>> may change runtime status of scsi devices. To protect system 
>> suspend/resume
>> from being disturbed by error handling, move the host_sem from wl pm 
>> ops
>> to ufshcd_suspend_prepare() and ufshcd_resume_complete().
> 
> Have you checked whether error handling might actually be needed after
> ufshcd_suspend_prepare()?

I intend to make it this (simple) way - if error handling is invoked
during system suspend/resume, it should just wait until system resume
is finished. suspend/resume does not count on error handling, if 
suspend/resume
run into errors, they just fail and bail.

> 
> Wouldn't this complexity go away if we just did recovery
> directly in __ufshcd_wl_suspend() and  __ufshcd_wl_resume()?
> 

Please kindly check my reply in patch #5.

Thanks,
Can Guo.

>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 8 +++-----
>>  drivers/scsi/ufs/ufshcd.h | 2 +-
>>  2 files changed, 4 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c418a19..861942b 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -9060,16 +9060,13 @@ static int ufshcd_wl_suspend(struct device 
>> *dev)
>>  	ktime_t start = ktime_get();
>> 
>>  	hba = shost_priv(sdev->host);
>> -	down(&hba->host_sem);
>> 
>>  	if (pm_runtime_suspended(dev))
>>  		goto out;
>> 
>>  	ret = __ufshcd_wl_suspend(hba, UFS_SYSTEM_PM);
>> -	if (ret) {
>> +	if (ret)
>>  		dev_err(&sdev->sdev_gendev, "%s failed: %d\n", __func__,  ret);
>> -		up(&hba->host_sem);
>> -	}
>> 
>>  out:
>>  	if (!ret)
>> @@ -9102,7 +9099,6 @@ static int ufshcd_wl_resume(struct device *dev)
>>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>>  	if (!ret)
>>  		hba->is_wl_sys_suspended = false;
>> -	up(&hba->host_sem);
>>  	return ret;
>>  }
>>  #endif
>> @@ -9665,6 +9661,7 @@ void ufshcd_resume_complete(struct device *dev)
>>  		ufshcd_rpmb_rpm_put(hba);
>>  		hba->rpmb_complete_put = false;
>>  	}
>> +	up(&hba->host_sem);
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_resume_complete);
>> 
>> @@ -9691,6 +9688,7 @@ int ufshcd_suspend_prepare(struct device *dev)
>>  		ufshcd_rpmb_rpm_get_sync(hba);
>>  		hba->rpmb_complete_put = true;
>>  	}
>> +	down(&hba->host_sem);
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_suspend_prepare);
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index eaebb4e..47da47c 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -693,7 +693,7 @@ struct ufs_hba_monitor {
>>   * @ee_ctrl_mask: Exception event control mask
>>   * @is_powered: flag to check if HBA is powered
>>   * @shutting_down: flag to check if shutdown has been invoked
>> - * @host_sem: semaphore used to serialize concurrent contexts
>> + * @host_sem: semaphore used to avoid concurrency of contexts
>>   * @eh_wq: Workqueue that eh_work works on
>>   * @eh_work: Worker to handle UFS errors that require s/w attention
>>   * @eeh_work: Worker to handle exception events
>> 
