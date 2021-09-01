Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00544C432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 19:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3DA261074
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 19:40:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343495AbhIATl4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 15:41:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:34935 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244756AbhIATlz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 15:41:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630525258; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=rfGNsu/8l3t692FJxNuRkch2G6PYTMKpGZz5XTEx3Ks=; b=b7kgrXlbKiFFgtepflNa0lYT/HDvnxJ2sO//M/6QympqBrQg1CEebSRdQEvifYPMpAyv7fAT
 2pqsAtsqxUMoeC7FrcbueWgr7a5S+0WrzSTgVvdc23UzayKc2XddBckGpoRog711JQVosX2w
 9WPBfwaLuTyC58pMETN0KElFu4s=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 612fd74740d2129ac1f1953c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 01 Sep 2021 19:40:55
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4FCE5C43616; Wed,  1 Sep 2021 19:40:55 +0000 (UTC)
Received: from [192.168.1.8] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30BC6C4338F;
        Wed,  1 Sep 2021 19:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 30BC6C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH 2/3] scsi: ufs: Add temperature notification exception
 handling
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
 <20210901123707.5014-3-avri.altman@wdc.com>
 <46a7ea4f-2c6b-7798-5845-ad47c64617dd@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <49a3985a-4d4d-006a-499e-2270bd7db250@codeaurora.org>
Date:   Wed, 1 Sep 2021 12:40:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <46a7ea4f-2c6b-7798-5845-ad47c64617dd@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/1/2021 9:39 AM, Bart Van Assche wrote:
> On 9/1/21 5:37 AM, Avri Altman wrote:
>> It is essentially up to the platform to decide what further actions need
>> to be taken. So add a designated vop for that.  Each chipset vendor can
>> decide if it wants to use the thermal subsystem, hw monitor, or some
>> Privet implementation.
> 
> Why to make chipset vendors define what to do in case of extreme 
> temperatures? I'd prefer a single implementation in ufshcd.c instead of 
> making each vendor come up with a different implementation.
> 
I think it should be either i.e. if a vendor specific implementation is 
defined use that else use the generic implementation in ufshcd.
There may be a bunch of things that each vendor may need/want do 
depending upon use-case, I imagine.

>> +    void    (*temp_notify)(struct ufs_hba *hba, u16 status);
> 
> Please do not add new vops without adding at least one implementation of 
> that vop.
> 
> Thanks,
> 
> Bart.


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
