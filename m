Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE757C2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 07:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9639461C2F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 07:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhF1HTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 03:19:24 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:17800 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232303AbhF1HTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Jun 2021 03:19:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624864617; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=uKsM4OsjoQR+ZWj/WMZSOh24CzDj0Tz1OAP3ZDdL3QE=;
 b=DlyrcwaNxsxiam9d1adGtoSvkVeqVR+BSEw7v7hsLpv2gTvVcB4aOqHXy6iMxD1NVbs9lGJ8
 zTivr+A9YxkgkDM47JYt+G56QZeF67n7nso4UD+Hr79MhPmWbItntVSo9iwWn3dKzCCmYptY
 XZW2DY4bGmLdoxeF+YSp7SoMiT4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60d97765d2559fe392630d1d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Jun 2021 07:16:53
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 471DFC43460; Mon, 28 Jun 2021 07:16:53 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D7FFC4338A;
        Mon, 28 Jun 2021 07:16:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 28 Jun 2021 15:16:52 +0800
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
In-Reply-To: <e803db99-947c-f217-e0c8-091241014086@acm.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-12-git-send-email-cang@codeaurora.org>
 <89a3c8bf-bbfc-4a2a-73f0-a0db956fbf0e@acm.org>
 <d9db00ef6dd4b28d0ba2019dcf026479@codeaurora.org>
 <e803db99-947c-f217-e0c8-091241014086@acm.org>
Message-ID: <0c859144bb1570331853d6eaf441fad9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-06-25 06:25, Bart Van Assche wrote:
> On 6/23/21 7:23 PM, Can Guo wrote:
>> On 2021-06-24 05:51, Bart Van Assche wrote:
>>> On 6/23/21 12:35 AM, Can Guo wrote:
>>> - During system suspend, user space software is paused before the 
>>> device
>>>   driver freeze callbacks are invoked. Hence, the 
>>> hba->is_sys_suspended
>>>   check can be left out.
>> 
>> is_sys_suspended indicates that system resume failed (power/clk is 
>> OFF).
>> 
>>> - If a LUN is runtime suspended, it should be resumed if accessed 
>>> from
>>>   user space instead of failing user space accesses. In other words, 
>>> the
>>>   hba->is_wlu_sys_suspended check seems inappropriate to me.
>> 
>> hba->is_wlu_sys_suspended indicates that wl system resume failed, 
>> device
>> is not operational.
> 
> Hi Can,
> 
> Thanks for the clarification. How about converting the above two 
> answers
> into comments inside ufshcd_is_user_access_allowed()?
> 

Sure.

> Should ufshcd_is_user_access_allowed() perhaps be called after
> ufshcd_rpm_get_sync() instead of before to prevent that the value of
> hba->is_sys_suspended or hba->is_wlu_sys_suspended changes after having
> been checked and before the UFS device is accessed?
> 

is_sys_suspended and is_wlu_sys_suspended only represent system PM 
status,
not runtime PM status.

My understanding is that user threads are frozen before system PM 
starts,
so it does not matter we call  ufshcd_is_user_access_allowed() before or
after ufshcd_rpm_get_sync().

If my understanding is wrong, then we need to either call 
lock_system_sleep()
in get_user_access() or wrap 
ufshcd_suspend_prepare/ufshcd_resume_complete()
with host_sem.

Thanks,

Can Guo.

> Thanks,
> 
> Bart.
