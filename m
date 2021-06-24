Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7B6C48BC2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F066A613AA
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFXCS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 22:18:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:59086 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFXCSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 22:18:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624500997; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=80wRw21hYrKAh7JPxu/zpapRJZdQHIOHCkh9C+b3tEc=;
 b=GpT0HsJM73iZLJ6VIaPPbOdhfVE+ddUkxGU0tIG0npdONdlQPOGdk2p4CI81AGcwnHI0IuaQ
 qEvTbNFd7Mc8y7BQNSDNtzRF5+8gvCk4uRXQTGbhdfj3t+FYUlvnedQ+bhcJagWfDx0/SP74
 S+52c0AUht+exo6anmu9qP/L3PQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60d3eaee01dd9a94315a9b49 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 02:16:14
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 425E9C43143; Thu, 24 Jun 2021 02:16:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10DB5C433F1;
        Thu, 24 Jun 2021 02:16:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Jun 2021 10:16:12 +0800
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
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] scsi: ufs: Remove host_sem used in
 suspend/resume
In-Reply-To: <ed59d61a-6951-2acd-4f89-40f8dc5015e1@intel.com>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-8-git-send-email-cang@codeaurora.org>
 <ed59d61a-6951-2acd-4f89-40f8dc5015e1@intel.com>
Message-ID: <9105f328ee6ce916a7f01027b0d28332@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-23 22:30, Adrian Hunter wrote:
> On 23/06/21 10:35 am, Can Guo wrote:
>> To protect system suspend/resume from being disturbed by error 
>> handling,
>> instead of using host_sem, let error handler call lock_system_sleep() 
>> and
>> unlock_system_sleep() which achieve the same purpose. Remove the 
>> host_sem
>> used in suspend/resume paths to make the code more readable.
>> 
>> Suggested-by: Bart Van Assche <bvanassche@acm.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 3695dd2..a09e4a2 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -5907,6 +5907,11 @@ static void ufshcd_clk_scaling_suspend(struct 
>> ufs_hba *hba, bool suspend)
>> 
>>  static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>  {
>> +	/*
>> +	 * It is not safe to perform error handling while suspend or resume 
>> is
>> +	 * in progress. Hence the lock_system_sleep() call.
>> +	 */
>> +	lock_system_sleep();
> 
> It looks to me like the system takes this lock quite early, even before
> freezing tasks, so if anything needs the error handler to run it will
> deadlock.

Hi Adrian,

UFS/hba system suspend/resume does not invoke or call error handling in 
a
synchronous way. So, whatever UFS errors (which schedules the error 
handler)
happens during suspend/resume, error handler will just wait here till 
system
suspend/resume release the lock. Hence no worries of deadlock here.

Thanks,

Can Guo.

> 
>>  	ufshcd_rpm_get_sync(hba);
>>  	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) 
>> ||
>>  	    hba->is_wlu_sys_suspended) {
>> @@ -5951,6 +5956,7 @@ static void ufshcd_err_handling_unprepare(struct 
>> ufs_hba *hba)
>>  		ufshcd_clk_scaling_suspend(hba, false);
>>  	ufshcd_clear_ua_wluns(hba);
>>  	ufshcd_rpm_put(hba);
>> +	unlock_system_sleep();
>>  }
>> 
>>  static inline bool ufshcd_err_handling_should_stop(struct ufs_hba 
>> *hba)
>> @@ -9053,16 +9059,13 @@ static int ufshcd_wl_suspend(struct device 
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
>> @@ -9095,7 +9098,6 @@ static int ufshcd_wl_resume(struct device *dev)
>>  		hba->curr_dev_pwr_mode, hba->uic_link_state);
>>  	if (!ret)
>>  		hba->is_wlu_sys_suspended = false;
>> -	up(&hba->host_sem);
>>  	return ret;
>>  }
>>  #endif
>> 
