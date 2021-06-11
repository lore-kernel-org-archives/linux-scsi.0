Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112E0C48BDF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 03:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0FE061040
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 03:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhFKDDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 23:03:41 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:43585 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhFKDDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 23:03:40 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623380503; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=NtUfSAY2TI2KByvNRqSjTQMjSvMHjaJI6zcIYfUAq1E=;
 b=Fh8rEHoud7TFoUpowiWYHczXnewq1yFgj6zLidXcyn5Tckd/K4DYU6ABbCEm/AO/DIlSgp7p
 XjPfi11JjVKFQwOvOuI32n6qT1VI1aa+8BkzUkajS4Nn5Cb9zIVdwVzpZOwv9EFIIQibJOwT
 PckRt6TPtObL7Tvk8OAcf8HocgM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 60c2d1fbe27c0cc77f7adb39 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Jun 2021 03:01:15
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D5D9DC43144; Fri, 11 Jun 2021 03:01:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B1CEC43460;
        Fri, 11 Jun 2021 03:01:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Jun 2021 11:01:12 +0800
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
Subject: Re: [PATCH v3 5/9] scsi: ufs: Simplify error handling preparation
In-Reply-To: <6abb81f6-4dd2-082e-9440-4b549f105788@intel.com>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-6-git-send-email-cang@codeaurora.org>
 <6abb81f6-4dd2-082e-9440-4b549f105788@intel.com>
Message-ID: <f0ae504bccc428fa674a183608174bdd@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Adrian,

On 2021-06-10 20:30, Adrian Hunter wrote:
> On 10/06/21 7:43 am, Can Guo wrote:
>> Commit cb7e6f05fce67c965194ac04467e1ba7bc70b069 ("scsi: ufs: core: 
>> Enable
>> power management for wlun") moves UFS operations out of 
>> ufshcd_resume(), so
>> in error handling preparation, if ufshcd hba has failed to resume, 
>> there is
>> no point to re-enable IRQ/clk/pwr.
> 
> I am not sure how cb7e6f05fce67c965194ac04467e1ba7bc70b069 made things 
> any
> different,

Previously, without commit cb7e6f05fce67c965194ac04467e1ba7bc70b069, 
ufshcd_resume()
may turn off pwr and clk due to UFS error, e.g., link transition failure 
and SSU
error/abort (and these UFS error would invoke error handling).  When 
error handling
kicks start, it should re-enable the pwr and clk before proceeding. Now, 
commit
cb7e6f05fce67c965194ac04467e1ba7bc70b069 makes ufshcd_resume() purely 
control pwr and
clk, meaning if ufshcd_resume() fails, there is nothing we can do about 
it - pwr or
clk enabling must have failed, and it is not because of UFS error. This 
is why I am
removing the re-enabling pwr/clk in error handling prepare.

> but what I really wonder is why we don't just do recovery
> directly in __ufshcd_wl_suspend() and  __ufshcd_wl_resume() and strip 
> all
> the PM complexity out of ufshcd_err_handling()?
> 

This is a good question and I've been strugled with this idea ever since 
I
started to fix error handling.

Just so you know, there are runtime and system suspend/resume. And error
handling has the same nature of user access - it is unpredictable, 
meaning it
can be invoked at any time (from IRQ handler), even when there is no 
ongoing
cmd/data transactions (like auto hibern8 failure and UIC errors, such as 
DME
error and some errors in data link layer) [1], unless you disable UFS 
IRQ.

For runtime suspend/resume, it is fine, since we call 
pm_runtime_get/put_sync() in
error handling - error handling won't run into parallel with runtime 
suspend/resume.

For system suspend/resume, since error handling has the same nature like 
user
access, so we are using host_sem to avoid concurrency of error handling 
and
system suspend/resume.

Back to your question - can we just do recovery directly in 
__ufshcd_wl_suspend()
and __ufshcd_wl_resume()? Yes, we can.

However, the reasons why I choose not to do it that way are (althrough 
error
handler prepare has became much more simple after apply this change)

1. I want to keep all the complexity within error handler, and re-direct 
all error
recovery needs to error handler. It can avoid calling 
ufshcd_reset_and_restore()
and/or flush_work(&hba->eh_work) here and there. The entire UFS 
suspend/resume is
already complex enough, I don't want to mess up with it.

2. We do explicit recovery only when we see certain errors, e.g., H8 
enter func
returns an error during suspend, but as mentioned above [1], error 
handling can
be invoked already from IRQ handler (due to all kinds of UIC errors 
before H8 enter
func returns). So, we still need host_sem (in case of system 
suspend/resume) to
avoid concurrency.

3. During system suspend/resume, error handling can be invoked (due to 
non-fatal
errors) but still UFS cmds return no error at all. Similar like above, 
we need
host_sem to avoid concurrency.

There are more reasons why I chose this way, but it is really this way 
or others.
I am glad to see someone cares about error handling and can make it 
better and
more robust, no matter what that way is. :)

Thanks,
Can Guo.

>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 58 
>> +++++++++++++++++++++++++----------------------
>>  1 file changed, 31 insertions(+), 27 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 7dc0fda..0afad6b 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2727,8 +2727,8 @@ static int ufshcd_queuecommand(struct Scsi_Host 
>> *host, struct scsi_cmnd *cmd)
>>  		break;
>>  	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
>>  		/*
>> -		 * pm_runtime_get_sync() is used at error handling preparation
>> -		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
>> +		 * ufshcd_rpm_get_sync() is used at error handling preparation
>> +		 * stage. If a scsi cmd, e.g., the SSU cmd, is sent from the
>>  		 * PM ops, it can never be finished if we let SCSI layer keep
>>  		 * retrying it, which gets err handler stuck forever. Neither
>>  		 * can we let the scsi cmd pass through, because UFS is in bad
>> @@ -5915,29 +5915,26 @@ static void ufshcd_clk_scaling_suspend(struct 
>> ufs_hba *hba, bool suspend)
>>  	}
>>  }
>> 
>> -static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>> +static int ufshcd_err_handling_prepare(struct ufs_hba *hba)
>>  {
>> +	/*
>> +	 * Exclusively call pm_runtime_get_sync(hba->dev) once, in case
>> +	 * following ufshcd_rpm_get_sync() fails.
>> +	 */
>> +	pm_runtime_get_sync(hba->dev);
>> +	/* End of the world. */
>> +	if (pm_runtime_suspended(hba->dev)) {
>> +		pm_runtime_put(hba->dev);
>> +		return -EINVAL;
>> +	}
>> +
>> +	ufshcd_set_eh_in_progress(hba);
>>  	ufshcd_rpm_get_sync(hba);
>> -	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) 
>> ||
>> +	if (pm_runtime_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
>>  	    hba->is_wl_sys_suspended) {
>> -		enum ufs_pm_op pm_op;
>> +		enum ufs_pm_op pm_op = hba->is_wl_sys_suspended ?
>> +				       UFS_SYSTEM_PM : UFS_RUNTIME_PM;
>> 
>> -		/*
>> -		 * Don't assume anything of resume, if
>> -		 * resume fails, irq and clocks can be OFF, and powers
>> -		 * can be OFF or in LPM.
>> -		 */
>> -		ufshcd_setup_hba_vreg(hba, true);
>> -		ufshcd_setup_vreg(hba, true);
>> -		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
>> -		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
>> -		ufshcd_hold(hba, false);
>> -		if (!ufshcd_is_clkgating_allowed(hba)) {
>> -			ufshcd_setup_clocks(hba, true);
>> -			ufshcd_enable_irq(hba);
>> -		}
>> -		ufshcd_release(hba);
>> -		pm_op = hba->is_wl_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
>>  		ufshcd_vops_resume(hba, pm_op);
>>  	} else {
>>  		ufshcd_hold(hba, false);
>> @@ -5951,22 +5948,25 @@ static void ufshcd_err_handling_prepare(struct 
>> ufs_hba *hba)
>>  	down_write(&hba->clk_scaling_lock);
>>  	up_write(&hba->clk_scaling_lock);
>>  	cancel_work_sync(&hba->eeh_work);
>> +	return 0;
>>  }
>> 
>>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>>  {
>> +	ufshcd_clear_eh_in_progress(hba);
>>  	ufshcd_scsi_unblock_requests(hba);
>>  	ufshcd_release(hba);
>>  	if (ufshcd_is_clkscaling_supported(hba))
>>  		ufshcd_clk_scaling_suspend(hba, false);
>>  	ufshcd_clear_ua_wluns(hba);
>>  	ufshcd_rpm_put(hba);
>> +	pm_runtime_put(hba->dev);
>>  }
>> 
>>  static inline bool ufshcd_err_handling_should_stop(struct ufs_hba 
>> *hba)
>>  {
>>  	return (!hba->is_powered || hba->shutting_down ||
>> -		!hba->sdev_ufs_device ||
>> +		!hba->sdev_ufs_device || hba->is_sys_suspended ||
>>  		hba->ufshcd_state == UFSHCD_STATE_ERROR ||
>>  		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
>>  		   ufshcd_is_link_broken(hba))));
>> @@ -6052,9 +6052,13 @@ static void ufshcd_err_handler(struct 
>> work_struct *work)
>>  		up(&hba->host_sem);
>>  		return;
>>  	}
>> -	ufshcd_set_eh_in_progress(hba);
>>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -	ufshcd_err_handling_prepare(hba);
>> +	if (ufshcd_err_handling_prepare(hba)) {
>> +		dev_err(hba->dev, "%s: error handling preparation failed\n",
>> +				__func__);
>> +		up(&hba->host_sem);
>> +		return;
>> +	}
>>  	/* Complete requests that have door-bell cleared by h/w */
>>  	ufshcd_complete_requests(hba);
>>  	spin_lock_irqsave(hba->host->host_lock, flags);
>> @@ -6198,7 +6202,6 @@ static void ufshcd_err_handler(struct 
>> work_struct *work)
>>  			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x 
>> saved_uic_err 0x%x",
>>  			    __func__, hba->saved_err, hba->saved_uic_err);
>>  	}
>> -	ufshcd_clear_eh_in_progress(hba);
>>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>>  	ufshcd_err_handling_unprepare(hba);
>>  	up(&hba->host_sem);
>> @@ -8999,6 +9002,9 @@ static int __ufshcd_wl_resume(struct ufs_hba 
>> *hba, enum ufs_pm_op pm_op)
>> 
>>  	/* Enable Auto-Hibernate if configured */
>>  	ufshcd_auto_hibern8_enable(hba);
>> +
>> +	hba->clk_gating.is_suspended = false;
>> +	ufshcd_release(hba);
>>  	goto out;
>> 
>>  set_old_link_state:
>> @@ -9008,8 +9014,6 @@ static int __ufshcd_wl_resume(struct ufs_hba 
>> *hba, enum ufs_pm_op pm_op)
>>  out:
>>  	if (ret)
>>  		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
>> -	hba->clk_gating.is_suspended = false;
>> -	ufshcd_release(hba);
>>  	hba->wl_pm_op_in_progress = false;
>>  	return ret <= 0 ? ret : -EINVAL;
>>  }
>> 
