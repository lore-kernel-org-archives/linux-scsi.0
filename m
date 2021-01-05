Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 669C1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C0612073C
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbhAEBIO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:08:14 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:16975 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbhAEBIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 20:08:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609808873; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=IUb+uoL2QPaHR3+XZA+O6oy7Xj6ruPwUwYDS5AvtzhE=;
 b=Xg2Mf9TzScKYj+4d5E0UzG5+s4K1fdChJ36ZOGti/HDM011Zqq5kdAQmg3DK9M0N7n2tt7vJ
 ud4kVkl4dLa13xjsjt4Azj6KSnpmiRpnX3sYCWoTrKM5+OJ8pVeWKCYNJJnsMdp4t2PnQPFG
 +grzk8oz0CpJflG/r7UUSa+a/i4=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5ff3bbce584481b01ba287e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 05 Jan 2021 01:07:26
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4D690C4323B; Tue,  5 Jan 2021 01:07:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6007AC4346E;
        Tue,  5 Jan 2021 01:07:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Jan 2021 09:07:24 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        rjw@rjwysocki.net, Alim Akhtar <alim.akhtar@samsung.com>,
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
In-Reply-To: <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
 <1609595975-12219-3-git-send-email-cang@codeaurora.org>
 <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
Message-ID: <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-05 04:05, Bean Huo wrote:
> On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
>> + * @shutting_down: flag to check if shutdown has been invoked
> 
> I am not much sure if this flag is need, since once PM going in
> shutdown path, what will be returnded by pm_runtime_get_sync()?
> 
> If pm_runtime_get_sync() will fail, just check its return.
> 

That depends. During/after shutdown, for UFS's case only,
pm_runtime_get_sync(hba->dev) will most likely return 0,
because it is already RUNTIME_ACTIVE, pm_runtime_get_sync()
will directly return 0... meaning you cannot count on it.

Check Stanley's change -
https://lore.kernel.org/patchwork/patch/1341389/

Can Guo.

> Hi Rafael
> would you please help us confirm this?
> 
> thanks,
> Bean
> 
> 
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
