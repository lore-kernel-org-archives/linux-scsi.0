Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99D0C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 22:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5E3661283
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 22:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhGIWsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 18:48:23 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:33335 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIWsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 18:48:22 -0400
Received: by mail-pl1-f180.google.com with SMTP id d1so568561plg.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 15:45:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s4hR7A0FZCgfzEtTkiBRl3Cr56iUGNrXGu1maP3XBWw=;
        b=hBShM5GjanVfDlgaACnIJsjHhpwPmm+yhKQt13FiT6tjGWR3myNan/rbl//HahuCZW
         1Nik9KJ+aPvq/nBHc3B+3v9lQOlJE2jDJo28W+w9a6TgnhGPJUJZmqe1qwVVSfZLNWS1
         xHCAMHeBU8fq7iX/jt4fO+LP5HcierU1jXPO2MmlG1yhhk5rlBdNlk97QKKcG/BbOOvE
         UVOCHps4QHYcLQj6jOqSFrcEkSgVOg5t08djiu5jrBhY4eVN5pxdniSMVip8v638bX0B
         +kn47uBebSi9sgx6c+N5S0NROU8zc/XFSV2pBZ9gwFQlu96d2IV6idrg2yaMbZhG5HJi
         nz+Q==
X-Gm-Message-State: AOAM533Gbqy3P1T+GLHrbZ+kCA7JmKc1S48iSdOGrTT4baKj2ovjr2So
        KceT1/tCE8s2ytqRCN2rc60=
X-Google-Smtp-Source: ABdhPJwv6pTH73+v3hRVs/G+mFtVj+jCJoUOhMyH0qYxSXb9+BfkwY/HPAEh2CykB0OIREAYC4Ei8g==
X-Received: by 2002:a17:902:aa0a:b029:128:c224:4f0a with SMTP id be10-20020a170902aa0ab0290128c2244f0amr32781407plb.58.1625870737895;
        Fri, 09 Jul 2021 15:45:37 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:eeaf:c266:e6cc:b591? ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id b2sm4813806pgh.9.2021.07.09.15.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 15:45:37 -0700 (PDT)
Subject: Re: [PATCH v2 19/19] scsi: ufs: Add fault injection support
To:     Randy Dunlap <rdunlap@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Avri Altman <avri.altman@wdc.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-21-bvanassche@acm.org>
 <251e9d94-f7ff-3be8-24ae-6b7572c11945@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <de212d27-c9c7-273a-d8ca-986e5edba3fe@acm.org>
Date:   Fri, 9 Jul 2021 15:45:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <251e9d94-f7ff-3be8-24ae-6b7572c11945@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/9/21 2:56 PM, Randy Dunlap wrote:
> On 7/9/21 1:26 PM, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>> index 2d137953e7b4..4272d7365595 100644
>> --- a/drivers/scsi/ufs/Kconfig
>> +++ b/drivers/scsi/ufs/Kconfig
>> @@ -183,3 +183,10 @@ config SCSI_UFS_CRYPTO
>>  	  Enabling this makes it possible for the kernel to use the crypto
>>  	  capabilities of the UFS device (if present) to perform crypto
>>  	  operations on data being transferred to/from the device.
>> +
>> +config SCSI_UFS_FAULT_INJECTION
>> +       bool "UFS Fault Injection Support"
>> +       depends on SCSI_UFSHCD && FAULT_INJECTION
>> +       help
>> +         Enable fault injection support in the UFS driver. This makes it easier
> 
> Nit: use one tab + 2 spaces above for indentation.

I will change the indentation in the Kconfig file. Thanks for the feedback.

Bart.
