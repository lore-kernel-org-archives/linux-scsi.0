Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF219C48BC2
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CD5613B3
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 02:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFXCZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 22:25:26 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:48924 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhFXCZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 22:25:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624501388; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Wbj0g0OsECqzVg7j+YUqU2RzLznVnn89S4KbNLzazb0=;
 b=r1Di1k2Bu300382v78noUoV3cQXrmac4cH70XHZWYxqYIURjGf6k4mZwyfNgWWQEcfGQKT+b
 SCIOnUfp8j0OIuoKoQmoSPmQSmIMB4iBNEw6Hx7O/xOXRotvTP7fP7I+U2YMYCcMxGjg14gd
 gaP5JUDMYTRWQJ1wsuvRDu5Agrc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60d3ec880090905e16612b6d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Jun 2021 02:23:04
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 74768C43151; Thu, 24 Jun 2021 02:23:03 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E2CF8C433D3;
        Thu, 24 Jun 2021 02:23:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Jun 2021 10:23:01 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 10/10] scsi: ufs: Apply more limitations to user access
In-Reply-To: <89a3c8bf-bbfc-4a2a-73f0-a0db956fbf0e@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-12-git-send-email-cang@codeaurora.org>
 <89a3c8bf-bbfc-4a2a-73f0-a0db956fbf0e@acm.org>
Message-ID: <d9db00ef6dd4b28d0ba2019dcf026479@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-24 05:51, Bart Van Assche wrote:
> On 6/23/21 12:35 AM, Can Guo wrote:
>> +int ufshcd_get_user_access(struct ufs_hba *hba)
>> +__acquires(&hba->host_sem)
>> +{
>> +	down(&hba->host_sem);
>> +	if (!ufshcd_is_user_access_allowed(hba)) {
>> +		up(&hba->host_sem);
>> +		return -EBUSY;
>> +	}
>> +	if (ufshcd_rpm_get_sync(hba)) {
>> +		ufshcd_rpm_put_sync(hba);
>> +		up(&hba->host_sem);
>> +		return -EBUSY;
>> +	}
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_get_user_access);
>> +
>> +void ufshcd_put_user_access(struct ufs_hba *hba)
>> +__releases(&hba->host_sem)
>> +{
>> +	ufshcd_rpm_put_sync(hba);
>> +	up(&hba->host_sem);
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_put_user_access);
> 
> Please indent __acquires() and __releases() annotations by one tab as 
> is
> done elsewhere in the kernel.

OK.

> 
>>  static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
>>  {
>> -	return !hba->shutting_down;
>> +	return !hba->shutting_down && !hba->is_sys_suspended &&
>> +		!hba->is_wlu_sys_suspended &&
>> +		hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL;
>>  }
> 
> Is my understanding of the following correct?
> - ufshcd_is_user_access_allowed() is not in the hot path and hence
>   should not be inline.

OK.

> - The hba->shutting_down member variable is set from inside a shutdown
>   callback. Hence, the hba->shutting_down test can be left out since
>   no UFS sysfs attributes are accessed after shutdown has started.

We see that user can still access UFS sysfs during shutdown if shutdown
is invoked by: reboot -f, hence the check.

> - During system suspend, user space software is paused before the 
> device
>   driver freeze callbacks are invoked. Hence, the hba->is_sys_suspended
>   check can be left out.

is_sys_suspended indicates that system resume failed (power/clk is OFF).

> - If a LUN is runtime suspended, it should be resumed if accessed from
>   user space instead of failing user space accesses. In other words, 
> the
>   hba->is_wlu_sys_suspended check seems inappropriate to me.

hba->is_wlu_sys_suspended indicates that wl system resume failed, device
is not operational.

> - If the HBA is not in an operational state, user space accesses
>   should be blocked until error handling has finished. After error
>   handling has finished, the user space access should fail if and only
>   if error handling failed.
> 

Yes, which is why ufshcd_get_user_access() acquires host_sem first and
checks the OPERATOINAL flag here. host_sem shall make sure that user
space accesses should be blocked until error handling has finished.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
