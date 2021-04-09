Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AFAC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 21:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9781F61108
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 21:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhDIU76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:59:58 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:37806 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhDIU7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 16:59:51 -0400
Received: by mail-pj1-f52.google.com with SMTP id mj7-20020a17090b3687b029014d162a65b6so5577686pjb.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Apr 2021 13:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EWITV8n/i1LnO9Y3xInCS4vHc5Dypwns5DB9I0/1OYg=;
        b=Yr3fT1yLvSumF4XtwiIb/kRv00sCL1YlLDVTfWesdc9A0v1HdnKhnZIIBaSIbCItEY
         g54AMgXE41JSlZ4fscmd8k1WNi29PYf/Srviwu1R4B0bcpqw/N5yTDmBbR2w8avzz2XV
         3VQo1Lf09UyzkTZOh2gRI0s4eQZ2objYZstj9FjQmVF0hR2PFLxToIekR7zra0bWgW41
         KEIo48WExS56zhEtq3C58W/HdAwh26/5O1pIqpRswSKOaesf8aANNcWqq9j6kZKJ1S5X
         3nH+uHgH85WhzUBbcWiFeBXK4qxHz7cgZHrfCr4NGcHPPKTgNsA7rTT/emgQJ74ecp0C
         +8Jg==
X-Gm-Message-State: AOAM531mewY0md21ObSnCVAD3OqDaKE107Z0N4XDilq8gmXWW2dD7tL9
        PT1jaGxnh036RPIeWtcJnFQ=
X-Google-Smtp-Source: ABdhPJy356ajyY0HK8mu+BY2JHr8eQ+kcj/kusv5jvq3mcVDUnahLDaxR4a+pL1UMX306AJuRLRNFw==
X-Received: by 2002:a17:90a:2b01:: with SMTP id x1mr15528095pjc.99.1618001975810;
        Fri, 09 Apr 2021 13:59:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b754:80ab:7763:7f30? ([2601:647:4000:d7:b754:80ab:7763:7f30])
        by smtp.gmail.com with ESMTPSA id x194sm3433771pfc.18.2021.04.09.13.59.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 13:59:35 -0700 (PDT)
Subject: Re: [PATCH] scsi_mod: Add a new parameter to scsi_mod to control
 storage logging
To:     Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org,
        hare@suse.de, emilne@redhat.com, martin.petersen@oracle.com,
        jpittman@redhat.com, djeffery@redhat.com,
        dgilbert <dgilbert@interlog.com>, axboe@fb.com, hch@lst.de
References: <1617325783-20740-1-git-send-email-loberman@redhat.com>
 <3ab37563-c620-395c-bd12-74376962728d@acm.org>
 <3a8e9cfadbb646ed5a520d4972c1f450aae6b5d2.camel@redhat.com>
 <3579fa05385e8f13b15b3e2ca184a33619dd627d.camel@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4b4cb739-a76d-711b-6c7a-0661fc6c4896@acm.org>
Date:   Fri, 9 Apr 2021 13:59:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <3579fa05385e8f13b15b3e2ca184a33619dd627d.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/8/21 8:56 AM, Laurence Oberman wrote:
> Hi Bart the original macro is the same so I think best not to change it
> other than the wrapper I added. What are your thoughts.

Hi Laurence,

Since the current definition is not optimal from a source code
readability standpoint and since this patch changes the sd_printk()
definition I think this is a great opportunity to improve that
definition. Please note that I don't have a strong opinion about this.

Bart.
