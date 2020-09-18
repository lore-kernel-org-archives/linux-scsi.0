Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC26C43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 19:52:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 340AC22208
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 19:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIRTv6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 15:51:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45268 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRTv6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 15:51:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id k15so4090756pfc.12;
        Fri, 18 Sep 2020 12:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jwJFqifRVAKIV7cNFiI3hJtWYZIgH2Laudl3kyC7pSQ=;
        b=Y79Ylw6oXwBBMLQ86h1WCITPSyTZJ3RXHZPjTOpk4VMfVHFWXc8c51OwkqM1YuHqED
         fWFNXfAOHWgFhjxvei6XKX7mXLmXOg814XAg8/RLDMObZhKjSLWWXy9/c4+ogTYRbrBt
         plf3L4Fd7iOfLu2vmkdehHdnPNbNjuHRpfip5BkJUqSiAXfeDBezEJsIooDBaHctMvEs
         rCtybvsK1qRiQY7FtuvUH5LvUFCf0Yn6TSH3Rs5puTiygPJMsuwvgE8I+IYyXjhItzVU
         RIwgzjpHp6cExQxYAoacw0yIJah+wfV+uH7QdR8b8gU7PhswDknyb8JRQ8XT1PzBawEP
         87nA==
X-Gm-Message-State: AOAM530koaCMAOnM1nli5NJvKdWWQZOECbq3gU06IcG6ALFDDCYW+wuc
        p3yoZTDNIL0FDspIHQMtb7M=
X-Google-Smtp-Source: ABdhPJzVciLn/oCo2sInI+EDeWE+Is9ojVhKgRldY01jQsB/CIJFydhY6sB7tPTYZUe7oqZr2zXqgA==
X-Received: by 2002:a62:8607:0:b029:13c:1611:6593 with SMTP id x7-20020a6286070000b029013c16116593mr32701757pfd.16.1600458717129;
        Fri, 18 Sep 2020 12:51:57 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k28sm4002499pfh.196.2020.09.18.12.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 12:51:55 -0700 (PDT)
Subject: Re: [PATCH v11 0/4] scsi: ufs: Add Host Performance Booster Support
To:     Christoph Hellwig <hch@infradead.org>,
        Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
References: <231786897.01599016802080.JavaMail.epsvc@epcpadp1>
 <CGME20200902031713epcms2p664cebf386ba19d3d05895fec89aaf4fe@epcms2p3>
 <231786897.01600211401846.JavaMail.epsvc@epcpadp1>
 <20200916052208.GB12923@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <2aecb02b-f845-b860-facd-e31bd964ac64@acm.org>
Date:   Fri, 18 Sep 2020 12:51:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916052208.GB12923@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/20 10:22 PM, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 08:05:17AM +0900, Daejun Park wrote:
>> Hi All,
>>
>> I want to know how to improve this patch.
> 
> Drop it and fix the actual UFS feature to not be so horrible?

A new UFS specification could be defined and could be implemented for future UFS
devices. I think this patch series is intended to support the millions of UFS
devices that are already in use, e.g. in Android smartphones.

Thanks,

Bart.


