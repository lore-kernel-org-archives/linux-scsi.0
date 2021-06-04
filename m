Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACF7C47082
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 02:54:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8FC161246
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 02:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFDC4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 22:56:17 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:41752 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDC4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 22:56:17 -0400
Received: by mail-pl1-f173.google.com with SMTP id o12so532600plk.8;
        Thu, 03 Jun 2021 19:54:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lfarpHwfp7BSQa/GuG0n45sx11I+xDYjLeTC1R+2hdY=;
        b=h6287yTu9DfgNt8W5XbTY5qArOJDz67YqZqRPMwAUnDHeA0sXfld82P/8SBJCQy7VL
         fJoi+oRfDPT05pYCSC4HjfP4utSeIheMhsps78P5OSdvh8pWUxgEHE283GmDo0IC7gtR
         7q49ndCBDautlhp+5rtB4wrCOMzRZrE/pv96Vk+hvO8z9layIGHTNEfRfiItz6Y4NkF9
         Uhp9k4M/sNAUz7hy0tUyXsiqmKS2l1/zAh3TGwF3FzSFrEQRPzUyisu6WQYhITzOhJZc
         UwPq0LRVXriSuVgdV/6sB9pKh8QWj7wTRJqIlFXxYuU6hHACVS8K0N+EMEX1QMMxV7sF
         x42Q==
X-Gm-Message-State: AOAM530KI0lA72ZZc0sv8OO7GVyfTfb/UJAWlJ+gQTf4HFvR+hi2pZgi
        ldLf4RBuZekx4iqd2sUtqfk=
X-Google-Smtp-Source: ABdhPJyOQnoyoKo/oXvCTEtseCc8AZciO65zt5hHMLY7TRhe8BGzAFT+4cWEuQF5BtdF1E/pvtCHVw==
X-Received: by 2002:a17:90a:16c2:: with SMTP id y2mr2457951pje.236.1622775257215;
        Thu, 03 Jun 2021 19:54:17 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s22sm365790pfd.94.2021.06.03.19.54.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 19:54:16 -0700 (PDT)
Subject: Re: [PATCH v35 3/4] scsi: ufs: Prepare HPB read for cached sub-region
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
References: <12392bef-e018-8260-5279-16b7b43f5a8f@acm.org>
 <20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p6>
 <20210524084546epcms2p2c91dc1df482fd593307892825532c6dd@epcms2p2>
 <CGME20210524084345epcms2p63dde85f3fdc127c29d25ada7d7f539cb@epcms2p3>
 <20210604011124epcms2p39a466db169ebbfd2c889e25fba9aa0b4@epcms2p3>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4bf317c8-4c74-2207-95e2-34c59b14c454@acm.org>
Date:   Thu, 3 Jun 2021 19:54:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604011124epcms2p39a466db169ebbfd2c889e25fba9aa0b4@epcms2p3>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/21 6:11 PM, Daejun Park wrote:

>>> +/*
>>> + * This function will set up HPB read command using host-side L2P map data.
>>> + * In HPB v1.0, maximum size of HPB read command is 4KB.
>>> + */
>>> +void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>>> +{
>> [ ... ]
>>> +
>>> +        ufshpb_set_hpb_read_to_upiu(hpb, lrbp, lpn, ppn, transfer_len);
>>
>> 'transfer_len' has type int and is truncated to type 'u8' when passed as
>> an argument to ufshpb_set_hpb_read_to_upiu(). Please handle transfer_len
>> values >= 256 properly.
> 
> Before entering the function, ufshpb_is_supported_chunk() checks whether
> transfer_len <= hpb->pre_req_max_tr_len which is set to
> HPB_MULTI_CHUNK_HIGH (128) on initalization.

How about adding a WARN_ON_ONCE() in ufshpb_prep() that verifies that
transfer_len is <= HPB_MULTI_CHUNK_HIGH?

Thanks,

Bart.
