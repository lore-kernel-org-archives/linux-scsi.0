Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93199C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 16:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63C39613BC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 16:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhEMQFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 12:05:11 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:38845 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhEMQFI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 12:05:08 -0400
Received: by mail-pl1-f173.google.com with SMTP id 69so10015160plc.5;
        Thu, 13 May 2021 09:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eCNLl70K9BYuPwJF2PlIKpPDZ8MF+Uba1A4FKW8XSDg=;
        b=ojUmVyPcs9QTOl8vi+H0qz9xqZ6MbBBL+x4rtILzKnwpo+hNvOWWQdhVZVZyso6Ibk
         hvuHby+mectPHhR0r5oZeHGkgX8T8/4PLpYB3Fm1k1H+gZNMNRhsbuYW7PEjRzOQWsIL
         vbABFJfvwLBUeKEyNpQTU6VNPEEFGVB48Z6gAgdPXancBPFRLOrgFpxU+VvIwRhSHbPE
         MFPYhnnVde0AEczUF/JyuSO4JRx4+g+hvlknCCmALXOaYjV/nzX1ZXQdm4+n1Xhn/VWH
         lSTkiFcKGw2sIjVtMqzE7JLVgAKY+tD/a3QhVxt3mqZEDg6zwgJ5eoUI6Qdo+KIoA5T+
         s+Gw==
X-Gm-Message-State: AOAM53252w936sXPfMmNev1DqQhuDjvLHq6CjEEaQvg6+EFzn5ZKjI0T
        UTXpu2wnqdH1NXTotfYR5MQ3RhnBHXYHhg==
X-Google-Smtp-Source: ABdhPJxDFEKEu3UQxEQSLFZs0BHZ1TxGTBL0IilyK5hKeCGz9m+//b98buOIlh0wk/TQ3B84ZMjtBg==
X-Received: by 2002:a17:902:e74b:b029:ed:8636:c532 with SMTP id p11-20020a170902e74bb02900ed8636c532mr41898202plf.51.1620921837955;
        Thu, 13 May 2021 09:03:57 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6dd7:5386:8c63:ccae? ([2601:647:4000:d7:6dd7:5386:8c63:ccae])
        by smtp.gmail.com with ESMTPSA id y3sm2463368pfl.153.2021.05.13.09.03.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 09:03:57 -0700 (PDT)
Subject: Re: [PATCH] scsi: target: Avoid smp_processor_id() in preemptible
 code
To:     Mike Christie <michael.christie@oracle.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
 <d25b35e2-5ed6-4a00-56f4-71f31463ba1a@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <58bd8a10-a3a1-3d87-0342-f6d49f5fe808@acm.org>
Date:   Thu, 13 May 2021 09:03:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <d25b35e2-5ed6-4a00-56f4-71f31463ba1a@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 8:36 AM, Mike Christie wrote:
> Is there something else that's used normally? raw_smp_processor_id?

+1 for raw_smp_processor_id() since my understanding is that
SCF_USE_CPUID is a performance optimization only and correctness of the
target code is not affected if the running thread is moved to another
CPU core by the scheduler.

Thanks,

Bart.


