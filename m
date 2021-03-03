Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8096EC28E89
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43DB260234
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378180AbhCCMq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:46:56 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:17600 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1840259AbhCCEHs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Mar 2021 23:07:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614744449; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=OAYIqDL54kNUhO/pb0sEl71JP7mX7pyoMVNmwKKljuI=;
 b=vZuvaig6jMRvnfLUECEgqP9Bal0y8UbJUQBWlqLhPD93P3JgvO6O5ZoQJV58vILIcmo1PPNU
 1FXr5Ya29PxL4o92IVdPQcrLQh6jYyxBHrMWgeDS93jJEEK1MLbp7Hy0RdTBT5I1IkCTg1As
 zUM+tB2y/nsgQrLhIQGBapznOZs=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 603f0b7d2a53a9538abc64d3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 04:07:25
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6C59FC43462; Wed,  3 Mar 2021 04:07:24 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AE9C6C433C6;
        Wed,  3 Mar 2021 04:07:23 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Mar 2021 12:07:23 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Nitin Rawat <nitirawa@codeaurora.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: ufs-qcom: Disable interrupt in reset path
In-Reply-To: <DM6PR04MB65753665BA9BF63ABF20656FFC9B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
 <1614145010-36079-3-git-send-email-cang@codeaurora.org>
 <DM6PR04MB65753665BA9BF63ABF20656FFC9B9@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <96fbfe6fba7a7cd4d2d764186bb8650b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-28 22:23, Avri Altman wrote:
>> 
>> From: Nitin Rawat <nitirawa@codeaurora.org>
>> 
>> Disable interrupt in reset path to flush pending IRQ handler in order 
>> to
>> avoid possible NoC issues.
>> 
>> Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufs-qcom.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index f97d7b0..a9dc8d7 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -253,12 +253,17 @@ static int ufs_qcom_host_reset(struct ufs_hba 
>> *hba)
>>  {
>>         int ret = 0;
>>         struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>> +       bool reenable_intr = false;
>> 
>>         if (!host->core_reset) {
>>                 dev_warn(hba->dev, "%s: reset control not set\n", 
>> __func__);
>>                 goto out;
>>         }
>> 
>> +       reenable_intr = hba->is_irq_enabled;
>> +       disable_irq(hba->irq);
>> +       hba->is_irq_enabled = false;
>> +
>>         ret = reset_control_assert(host->core_reset);
>>         if (ret) {
>>                 dev_err(hba->dev, "%s: core_reset assert failed, err = 
>> %d\n",
>> @@ -280,6 +285,11 @@ static int ufs_qcom_host_reset(struct ufs_hba 
>> *hba)
>> 
>>         usleep_range(1000, 1100);
>> 
>> +       if (reenable_intr) {
>> +               enable_irq(hba->irq);
>> +               hba->is_irq_enabled = true;
>> +       }
>> +
> If in the future, you will enable UFSHCI_QUIRK_BROKEN_HCE on your
> platform (currently only for Exynos),
> Will this code still work?

Yes, it still works.

Thanks,
Can Guo.
