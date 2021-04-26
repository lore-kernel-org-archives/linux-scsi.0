Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57E1FC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24520611CD
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhDZDe2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:34:28 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:11848 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhDZDeZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:34:25 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619408025; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=4RaylY2/fjv4Zb1VLJVf7z2q10tFpluugdOZwxhSiFU=;
 b=GLgLTp9skT32+/ztu031gFHK3AOQbUJZSdljiriofFZaKI2tV8MfkjG0h+h9CTYH1AEj8UKM
 wlfm+wjmCcLprwGIqYpA6ANnhoD/dFVpRtcwgZObeGFdcvRXM4sSeq6UwgFdoo7bQ7iQSAgU
 sf31oJz2hUGAlOuj4JoWKTpTOxg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60863484215b831afb4b673e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 26 Apr 2021 03:33:24
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C3CDEC43143; Mon, 26 Apr 2021 03:33:23 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 24BADC433D3;
        Mon, 26 Apr 2021 03:33:23 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 26 Apr 2021 11:33:23 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     asutoshd@codeaurora.org, ziqichen@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Cancel rpm_dev_flush_recheck_work
 during system suspend
In-Reply-To: <20210426031711epcms2p2b64c07ab98332429204dac7ba920abf2@epcms2p2>
References: <1619403878-28330-3-git-send-email-cang@codeaurora.org>
 <1619403878-28330-1-git-send-email-cang@codeaurora.org>
 <CGME20210426022700epcas2p298d2b9e6dd30781db9bf1e998f80eca1@epcms2p2>
 <20210426031711epcms2p2b64c07ab98332429204dac7ba920abf2@epcms2p2>
Message-ID: <f281cc9eea50cd05b7fe3fd6ddaf7474@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-26 11:17, Daejun Park wrote:
> Hi Can Guo,
> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 7ab6b12..090b654 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -9058,11 +9058,12 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>>         if (!hba->is_powered)
>>                 return 0;
>> 
>> +        cancel_delayed_work_sync(&hba->rpm_dev_flush_recheck_work);
>> +
>>         if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
>>              hba->curr_dev_pwr_mode) &&
>>             (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
>> -             hba->uic_link_state) &&
>> -             !hba->dev_info.b_rpm_dev_flush_capable)
> I think it should not be removed.
> It prevents power drain when runtime suspend and system suspend have 
> same
> power mode.
> 

I will add it back in next ver.

Thanks,
Can Guo

> Thanks,
> Daejun
