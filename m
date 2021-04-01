Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8EFC43603
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 03:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61957610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 03:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhDADjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 23:39:42 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:39760 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhDADjb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 23:39:31 -0400
Received: by mail-pf1-f172.google.com with SMTP id c17so458646pfn.6;
        Wed, 31 Mar 2021 20:39:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZUzB2TfM1k6bbkpAhqsg/vqqGpQdkYUtRjbJgsJe7Uk=;
        b=nZTvc8ZM5zpx7oP4FnkZ2tIWS0tBJdj0sKlrGB8DAU3XP0BMFX7z+Uha5sKg8Dtq0C
         2p1Lxb1oYKIEI28pQQT0+oUmeUqraZweLOMQ29JniunaIfoFzX+4xaUMDF0kGO+Bt417
         fLPuxg97Ma/dZmntSq0s0RslN3EmFsxA7TwYMIinDnM16xagcYeY1jEce00xdD5pxLyc
         SH0QXQbTS88rC8tqsPSihkW5lCutK7dIvK2vMoxTZI3hCDUh0CpbngWYYTVB4NxHj9/p
         N43/5gnkOA6gkOIxCWC5euVyMBwqGYlDs9pwlvhpkoOxes+mFLWX+q8YHNOd2T2TCm6C
         gCEg==
X-Gm-Message-State: AOAM531LDmknDrTsNx/wL7wcGLvsp+b9FbE7DemRyjny9EC69UjLTp7Z
        vq+ZB8OzbbXVPnW18GRowXjy05KteZk=
X-Google-Smtp-Source: ABdhPJzbUa5bstIPClaRRbGKOnyS1OuOyapcj0/01e7SKWIuLKAG1HdFxVfygwkCQnEPhFgENMUUTA==
X-Received: by 2002:a63:fd45:: with SMTP id m5mr5860603pgj.264.1617248370879;
        Wed, 31 Mar 2021 20:39:30 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:be87:d7bf:6a65:f00d? ([2601:647:4000:d7:be87:d7bf:6a65:f00d])
        by smtp.gmail.com with ESMTPSA id g10sm3787013pgh.36.2021.03.31.20.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Mar 2021 20:39:29 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] scsi: ufs: Fix task management request completion
 timeout
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1617166236-39908-1-git-send-email-cang@codeaurora.org>
 <1617166236-39908-2-git-send-email-cang@codeaurora.org>
 <BL0PR04MB656448E22577076A27F1EADAFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3206bafd-6a5a-1e9b-7939-a1360b5c55fc@acm.org>
Date:   Wed, 31 Mar 2021 20:39:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB656448E22577076A27F1EADAFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/21 9:45 AM, Avri Altman wrote:
>> ufshcd_tmc_handler() calls blk_mq_tagset_busy_iter(fn =
>> ufshcd_compl_tm()),
>> but since blk_mq_tagset_busy_iter() only iterates over all reserved tags
>> and requests which are not in IDLE state, ufshcd_compl_tm() never gets a
>> chance to run. Thus, TMR always ends up with completion timeout. Fix it by
>> calling blk_mq_start_request() in  __ufshcd_issue_tm_cmd().
>>
>> Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to allocate and
>> free TMFs")
>>
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b49555fa..d4f8cb2 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6464,6 +6464,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
>> *hba,
>>
>>         spin_lock_irqsave(host->host_lock, flags);
>>         task_tag = hba->nutrs + free_slot;
>> +       blk_mq_start_request(req);
> Maybe just set req->state to MQ_RQ_IN_FLIGHT
> Without all other irrelevant initializations such as add timeout etc.

Hmm ... I'm not sure that any of the actions performed by
blk_mq_start_request() are irrelevant in this context. Additionally, no
other block or SCSI driver sets MQ_RQ_IN_FLIGHT directly.

Thanks,

Bart.
