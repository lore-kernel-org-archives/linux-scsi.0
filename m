Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F842C7EE2D
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 19:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbjEVT2e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 15:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbjEVT22 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 15:28:28 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C3F6138;
        Mon, 22 May 2023 12:28:26 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ae763f9c0bso34063205ad.2;
        Mon, 22 May 2023 12:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684783705; x=1687375705;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JDLVme7cQW9uRtsD1UVWARAozjiu6N7bQTx8gZDxsdQ=;
        b=OvyI//kvkR2CsF2sWdueTmiRyNUDffrjew+igYByOOLgNPOtBOq05PdRSfF8xGgZwu
         NsIUKflX7Cg88bRnoxyUTQLQtjXFTxQAm4WTPmRqw6AL2zlbsHbLVh0kHAO9tYCY0qxn
         zW480EaZxR07piBt6g6l6X/Mh3brH6TF+AC49jPdoUtvXopD4z9b5BVbmxnlOkupobJs
         bcdjf7ZE+61QPiWcy7KNtWpQpxj5BRHkr5hEEWjlEqCvZDa8Jb8ydhlowkneQBlBdZ6l
         HPyT+fIs+inM7NKG5e3bLdvpCTfrMQ3LuHnl7WlIALguS00iTkoQ+PofGkbfUj9dUAh2
         773Q==
X-Gm-Message-State: AC+VfDxU2s5UV529iJoV1raqvgdKbZRZbYALbFRffAGJEyzLCEliYHMQ
        QsBW59xHCMHRokNOR+eGKqE=
X-Google-Smtp-Source: ACHHUZ5J0wE2koZk8s5RFZPNkjJcT9HU32czYmQLoWwjVphgoj7dOovDzODtz6Og4MZsW8cXNQNgCg==
X-Received: by 2002:a17:902:f547:b0:1ac:9890:1c49 with SMTP id h7-20020a170902f54700b001ac98901c49mr16629605plf.15.1684783705569;
        Mon, 22 May 2023 12:28:25 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:642f:e57f:85fb:3794? ([2620:15c:211:201:642f:e57f:85fb:3794])
        by smtp.gmail.com with ESMTPSA id r14-20020a17090a454e00b002535e5e6078sm6185316pjm.56.2023.05.22.12.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 12:28:25 -0700 (PDT)
Message-ID: <89053bf1-6bc3-3778-7662-14d15bd778a3@acm.org>
Date:   Mon, 22 May 2023 12:28:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: spinlock recursion in aio_complete()
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-aio@kvack.org, linux-parisc <linux-parisc@vger.kernel.org>
References: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/23 22:43, Helge Deller wrote:
> On a single-CPU parisc64 machine I face the spinlock recursion below.
> Happens reproduceably directly at bootup since kernel 6.2 (and ~ 6.1.5).
> Kernel is built for SMP. Same kernel binary works nicely on machines with more than
> one CPU, but stops on UP machines.
> Any idea or patch I could try?

How about performing one or more of the following actions?
* Translating aio_complete+0x68 into a line number.
* Repeating the test with lockdep enabled.
* Bisecting this issue.

Thanks,

Bart.
