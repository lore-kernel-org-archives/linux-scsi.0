Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D20AC38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDAF5206D4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3zD4KFi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgDVEoF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgDVEoF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 00:44:05 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2923EC061BD3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:44:05 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t9so365386pjw.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 21:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x5+rDgdqsjlhAqlssmv1yKmSS4kmyyb4nQerz8hh3tc=;
        b=N3zD4KFi/Ke134bYRzUhGoMPtLJlF2VIe5yRYgPDB3xSMiNit76wdD7fmxGAIca05o
         /iGb09WdvhWvESq6yimxNdj2TJ6eIJVVexTMyeVDJEPb3raf9azNTjr2MBTe4KUIaYPt
         Vn3lKF7f16LNL1v5u8ZJuR8Rfocd3eWLdxkyX06rZBdpXaFkglCA4MJtMegnBMVZwe+U
         BJ/boB3XPAcEX/EkrsWt8IAw0RBEbONIanVDoRICi0TkUfMhOMKPO+7xT6F2wRwPeWrF
         ygzlbeWph8C5CfAZuuRDnqeGEkEHW0njOCqWA9bFcBcpgSmkxnvUj7k/by7zKOYns5PQ
         VuOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x5+rDgdqsjlhAqlssmv1yKmSS4kmyyb4nQerz8hh3tc=;
        b=W1KSNRLLIMD5lJfNUOZJPfsToqmKLncAvJ5k4RcJ324vf0RdwwC3ya2EkwwFtm8FPk
         WDJKqQl2Qs62I7cs4zxAVc+EO1/yXn78YXhyuMB3HWCymc5kaZfIlVFa0PH4nRq8+Owk
         NCeUwbAid04wB+T8NvGhQkF3g5/0caLFvnm2u0B/XbjWdK2tqDQ0YNON0HfsEG7exHpL
         EiF1Nyfvt4L6GhQBIWht/V7FDW2GmdUDTwdasn3+2JfBCOiLqN0FaopG/LX8AEJUmR/w
         CqBnMb393N1nankovUEWQXBX+nVUPluNBmMEfzbJZeDlbAXYZbM8iW7YVWXCyGZUV+wr
         yrhw==
X-Gm-Message-State: AGi0PuZxAPC4k7yYIRfrsMUaLtCs8lQvArJQbbFRDN0/S0rxF5+OqZwJ
        7pnUuj1J64ikECSXgq6Woq4=
X-Google-Smtp-Source: APiQypJeepTL/ZfjzBf1nw90ytbgrHbYCR50l8Vvil95IwhloOMd1ZsTc8cTyhcudeRzO4I9UNeUcg==
X-Received: by 2002:a17:902:968a:: with SMTP id n10mr23278365plp.96.1587530644394;
        Tue, 21 Apr 2020 21:44:04 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 62sm4131579pfu.181.2020.04.21.21.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 21:44:03 -0700 (PDT)
Subject: Re: [PATCH v3 02/31] elx: libefc_sli: SLI Descriptors and Queue
 entries
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-3-jsmart2021@gmail.com>
 <e02f4879-9d7e-e37d-b1ea-db6305ac6308@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <e8f2ba40-5139-7d65-60a2-3509e56763fb@gmail.com>
Date:   Tue, 21 Apr 2020 21:44:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e02f4879-9d7e-e37d-b1ea-db6305ac6308@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> 
> And the remainder seems to be all hardware-dependent structures.
> Would it be possible to rearrange stuff so that hardware/SLI related 
> structures are being kept separate from the software/driver dependent ones?
> Just so that one is clear which structures can or must mot be changed.
> 
> Cheers,
> 
> Hannes

Agree with the comments and will address. Will look at the header split 
as well.

-- james
