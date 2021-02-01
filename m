Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF19EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 02:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C0B64E27
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 02:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhBACkL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:40:11 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:37565 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhBACkE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 21:40:04 -0500
Received: by mail-pl1-f172.google.com with SMTP id q2so9152960plk.4;
        Sun, 31 Jan 2021 18:39:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tK0a4Xo4ptkxzB0G42n+8D8QUtFhHfX1haG6vf5kKJI=;
        b=picoz5wfm4PyUtinBhrypPeTxVs3u7ME1vpyKZjYewmjbCzeCCTqA98lgv/ZlN0Omo
         KB5Tw8dWiKeveivS3HOMc4CmoBbj0KyiE8C2nfp1WA6STaLL0ITrV1GP8ZvF2H5xgG1T
         OkumO1jmv95AnvNauwlzt73KWKaCQgoVVIjSgYhVAZX5jEtULwYCNb16H2OTgqMbDtxj
         gLnE7XNVabuM82u4khvlkEa6ZtJ/8VwqgnkyJLYFXeTRYLHofN4C96tvBGWFmln82O/N
         iVnlTkMKKgsTKnezXoZJrDHAienpwGDHJamQ4k87NoEMneh7Y87YLypdTuZJ59cMolSM
         MGhw==
X-Gm-Message-State: AOAM533D4S2ucWsLJ2ZxPIieyL3hfHeTKZ8wOyD3lelm01StCPTQGypw
        ZAqyluwND8YYp+LJTWLcpz84hArh42g=
X-Google-Smtp-Source: ABdhPJzrzZFBKw1jvRRW5plU9Th08DTdyIDE43AFyvR2D2ccc0yltCkKp1gbLV8RZH6h6Ry/a4rz7A==
X-Received: by 2002:a17:902:309:b029:e1:536b:4ab with SMTP id 9-20020a1709020309b02900e1536b04abmr4207825pld.65.1612147162696;
        Sun, 31 Jan 2021 18:39:22 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:50bb:dc2d:705:e8e2? ([2601:647:4000:d7:50bb:dc2d:705:e8e2])
        by smtp.gmail.com with ESMTPSA id k128sm15255359pfd.137.2021.01.31.18.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 18:39:21 -0800 (PST)
Subject: Re: [PATCH v3 3/3] scsi: ufs: Fix wrong Task Tag used in task
 management request UPIUs
To:     Can Guo <cang@codeaurora.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-4-git-send-email-cang@codeaurora.org>
 <8351747f-0ec9-3c66-1bdf-b4b73fcee698@acm.org>
 <f0d1c6a196a044198647df6ca4b06efb@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cd83aa1d-444e-d4ba-c363-517dbf07891a@acm.org>
Date:   Sun, 31 Jan 2021 18:39:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <f0d1c6a196a044198647df6ca4b06efb@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/21 9:57 PM, Can Guo wrote:
> On 2021-01-29 11:15, Bart Van Assche wrote:
>> On 1/27/21 8:16 PM, Can Guo wrote:
>>> In __ufshcd_issue_tm_cmd(), it is not right to use hba->nutrs +
>>> req->tag as
>>> the Task Tag in one TMR UPIU. Directly use req->tag as the Task Tag.
>>
>> Why is the current code wrong and why is this patch the proper fix?
>> Please explain this in the patch description.
> 
> req->tag is the tag allocated for one TMR, no?

Hi Can,
 Commit e293313262d3 ("scsi: ufs: Fix broken task management command
implementation") includes the following changes:

+       task_tag = hba->nutrs + free_slot;
        task_req_upiup->header.dword_0 =
                UPIU_HEADER_DWORD(UPIU_TRANSACTION_TASK_REQ, 0,
-                                            lrbp->lun, lrbp->task_tag);
+                                            lun_id, task_tag);
        task_req_upiup->header.dword_1 =
                UPIU_HEADER_DWORD(0, tm_function, 0, 0);

As one can see the value written in dword_0 starts at hba->nutrs. Was
that code correct? If that code was correct, does your patch perhaps
break task management support?

Thanks,

Bart.
