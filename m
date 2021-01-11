Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367A4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 01:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAB3922473
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 01:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbhAKBbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 20:31:23 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:11626 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbhAKBbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 20:31:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610328658; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=tJucEep97bOmAJEr8rEkZDiX7IXLVOWZYNkRQGwG56g=;
 b=mYGutqX1ieLFi+vg1g+1N4IqH2hybqOnEa3La6ADbevFpDx5xYxeJkC6A+Tnfru4PcXYn8PN
 +E7iCFHTdklE368Huv2VreoojB0r/PrREfLKXYttack/a5z2/xD+LVRsYpaoJoQiJa0CKo+V
 WU9vz7Cetpwri+Q+gY6fcUVO9UE=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5ffbaa32415a6293c58105a7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Jan 2021 01:30:26
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 84857C433ED; Mon, 11 Jan 2021 01:30:26 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 00FBEC433C6;
        Mon, 11 Jan 2021 01:30:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 11 Jan 2021 09:30:24 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
In-Reply-To: <0ad818b10110c4c383afbc2c39235a4f7f17f4c7.camel@gmail.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
 <1609595975-12219-3-git-send-email-cang@codeaurora.org>
 <0ad818b10110c4c383afbc2c39235a4f7f17f4c7.camel@gmail.com>
Message-ID: <4d1ad38dbe0235020183e474a3610294@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-11 00:18, Bean Huo wrote:
> On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
>> + * @shutting_down: flag to check if shutdown has been invoked
>> + * @host_sem: semaphore used to serialize concurrent contexts
>>   * @eh_wq: Workqueue that eh_work works on
>>   * @eh_work: Worker to handle UFS errors that require s/w attention
>>   * @eeh_work: Worker to handle exception events
>> @@ -751,7 +753,8 @@ struct ufs_hba {
>>         u32 intr_mask;
>>         u16 ee_ctrl_mask;
>>         bool is_powered;
>> -       struct semaphore eh_sem;
>> +       bool shutting_down;
>> +       struct semaphore host_sem;
>> 
>>         /* Work Queues */
>>         struct workqueue_struct *eh_wq;
>> @@ -875,6 +878,11 @@ static inline bool ufshcd_is_wb_allowed(struct
>> ufs_hba *hba)
>>         return hba->caps & UFSHCD_CAP_WB_EN;
>>  }
>> 
>> +static inline bool ufshcd_is_sysfs_allowed(struct ufs_hba *hba)
>> +{
>> +       return !hba->shutting_down;
>> +}
>> +
> 
> 
> Can,
> 
> Instead adding new shutting_down flag, can we use availible variable
> system_state?
> 
> Thanks,
> Bean

Hi Bean,

I prefer the flag shutting_down, it tells us whether ufshcd_shutdown()
has been invoked or not. It comes handy when debug some system crash
issues caused by UFS during reboot/shutdown tests. system_state is too
wide in this case.

Thanks,
Can Guo.
