Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5CAC07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 16:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C97A2610C7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 16:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhGMQwK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 12:52:10 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:41561 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhGMQwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 12:52:10 -0400
Received: by mail-pj1-f52.google.com with SMTP id oj10-20020a17090b4d8ab0290172f77377ebso2530522pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 09:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7Qmnf/Yu6OfI8w51LkazDbPue61DpnihELZ9rMyJ+8M=;
        b=CdjQTCGbw/awU16fEWqjWL3JG6u+wnsQdiWuZf1EjZrm4JqEw3f39QAOg7qr46R9Nk
         RmTJwAo2ysm5B9Unvkkkpvcj2BecSr6hYNcKVrdXDNw48tX9+B09Y4r3Oge+/uwWuuZg
         pc1UDsOwrVkNMItk85H0hQcl+UvQK7EcrWSwfF4w/T1Jy6yjgrDHN0o57mG9DTWRzOIr
         DCbmeCLvwDebj09BIapgfUajSqmtwSVb5cj6CA43+CwDW44KflQC3uKOezPwNeQmDLUd
         /v60u0uqn8OUjcI9IfgBydzOg9vPcorDUgiI2zfn0BHxALsWGTRv5Tp60/GQFalPfOuu
         nCxA==
X-Gm-Message-State: AOAM5314pJs6v2EAp7j4VDY/RY4C/ghgMCaD9MOgOs+AvbANA/nv+fd4
        w9z8mGkValzERMQ2FNT0+MM=
X-Google-Smtp-Source: ABdhPJwbu88LeXxftJmubF3XHikfdHbS9QKMgKcwlowKp/pJlGBwnzSQVNTKCvzvnGyCpyxZdpMdiw==
X-Received: by 2002:a17:90a:c003:: with SMTP id p3mr5152115pjt.14.1626194959670;
        Tue, 13 Jul 2021 09:49:19 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:d6d0:1357:913a:795c? ([2620:0:1000:2004:d6d0:1357:913a:795c])
        by smtp.gmail.com with ESMTPSA id f31sm21966453pgm.1.2021.07.13.09.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jul 2021 09:49:19 -0700 (PDT)
Subject: Re: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
Date:   Tue, 13 Jul 2021 09:49:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/21 5:29 AM, Avri Altman wrote:
>>
>> The following unlikely races can be triggered by the completion path
>> (ufshcd_trc_handler()):
>> - After the UTRLCNR register has been read from interrupt context and
>>    before it is cleared, the UFS error handler reads the UTRLCNR register.
>>    Hold the SCSI host lock until the UTRLCNR register has been cleared to
>>    prevent that this register is accessed from another CPU before it has
>>    been cleared.
>> - After the doorbell register has been read and before outstanding_reqs
>>    is cleared, the error handler reads the doorbell register. This can also
>>    result in double completions. Fix this by clearing outstanding_reqs
>>    before calling ufshcd_transfer_req_compl().
>>
>> Due to this change ufshcd_trc_handler() no longer updates
>> outstanding_reqs
>> atomically. Hence protect all other outstanding_reqs changes with the SCSI
>> host lock.
> But isn't the whole point of REG_UTP_TRANSFER_REQ_LIST_COMPL is to eliminate the host lock
> As a source of contention?

How about avoiding contention by introducing a new spinlock to protect 
hba->outstanding_reqs?

>> This patch is a performance improvement because it reduces the number of
>> atomic operations in the hot path (test_and_clear_bit()).
> Both Can & Stanley reported a performance improvement of RR with "Optimize host lock..".
> Can those short numerical studies can be repeated with this patch?

I will measure the performance impact of this patch for rq_affinity=2 as 
soon as I have the time. As you may know we are close to an internal 
deadline.

Thanks,

Bart.
