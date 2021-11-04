Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE590C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 14:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D132D611C3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 14:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhKDO0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 10:26:47 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:37911 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhKDO0q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 10:26:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636035848; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=sttjvltaxAxJW4LytASOupOrEOzMe95PnK38QtFiLFI=; b=pIGHnJPxadtRxtXP9Va9E9iskSdfS8YyeQggrzcoRIB6HApoPa6TZ+qLqm4C2UKxM2S+vFRq
 NFvAVlGJU/EOrK0ppgoAPZRwDDe36OZnaAAFVxdtdwk/awWYEjrxc3+fa6JHl4q6gNbYvH9H
 b7VM1Sly00lxkWWFHaR553wqKpA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6183ecf7f97c48cc48ac9dbc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 04 Nov 2021 14:23:51
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 48970C43617; Thu,  4 Nov 2021 14:23:50 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9AE0C4360D;
        Thu,  4 Nov 2021 14:23:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A9AE0C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <4895a54b-6d49-9204-e7b2-336854c83ed4@codeaurora.org>
Date:   Thu, 4 Nov 2021 07:23:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
 <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
 <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
 <d3d70c8e-f260-ca2d-f4c1-2c9dd1a08c5d@acm.org>
 <3f4ef5e8-38e8-2e90-6da4-abc67aac9e4d@intel.com>
 <263538ad-51b5-4594-9951-8bcc2373da19@acm.org>
 <24399ee4-4feb-4670-ce9c-0872795c03ea@intel.com>
 <1a6fef86-9917-ddad-1845-d0406150ecb8@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <1a6fef86-9917-ddad-1845-d0406150ecb8@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/2021 10:06 AM, Bart Van Assche wrote:
> On 11/3/21 12:46 AM, Adrian Hunter wrote:
>> On 02/11/2021 22:49, Bart Van Assche wrote:
>>>   static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>>>   {
>>> -    #define DOORBELL_CLR_TOUT_US        (1000 * 1000) /* 1 sec */
>>>       int ret = 0;
>>> +
>>>       /*
>>> -     * make sure that there are no outstanding requests when
>>> -     * clock scaling is in progress
>>> +     * Make sure that there are no outstanding requests while clock 
>>> scaling
>>> +     * is in progress. Since the error handler may submit TMFs, 
>>> limit the
>>> +     * time during which to block hba->tmf_queue in order not to 
>>> block the
>>> +     * UFS error handler.
>>> +     *
>>> +     * Since ufshcd_exec_dev_cmd() and 
>>> ufshcd_issue_devman_upiu_cmd() lock
>>> +     * the clk_scaling_lock before calling blk_get_request(), lock
>>> +     * clk_scaling_lock before freezing the request queues to prevent a
>>> +     * deadlock.
>>>        */
>>> -    ufshcd_scsi_block_requests(hba);
>>
>> How are requests from LUN queues blocked?
> 
> I will add blk_freeze_queue() calls for the LUNs.
> 
> Thanks,
> 
> Bart.
Hi Bart,

In the current clock scaling code, the expectation is to scale up as 
soon as possible.

For e.g. say, the current gear is G1 and there're pending requests in 
the queue but the DBR is empty and there's a decision to scale up. 
During scale-up, if the queues are frozen, wouldn't those requests be 
issued to the driver and executed in G1 instead of G4?
I think this would lead to higher run to run variance in performance.

What do you think?

Thanks,
-asd

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
