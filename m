Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59937C5518A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:09:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3510920767
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 03:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifYJddLR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgDWDJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 23:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWDJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 23:09:40 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0821EC03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:09:39 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id s9so3583369eju.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 20:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZL4aDZ+YC4x+HiBwjE0mhqgEP2w/XBS3OvcvPk1ksNg=;
        b=ifYJddLRZ6MCUWXWLSiWIONpWtWtODc2xPlh5MTqeuG/uoM4fwpWaz51M+MRWEJuRd
         MULB4/8xWguSQvUpx7oEK7zu1EVJBn29XmB4H+cx+sg1leqdkc82kTX3MCb4dGuYNqAD
         fTbqnTxBsk3TlU3daDWC701317WtnBPHgsU+MgQU1uCMLwCzQy9ciLuu+ZUxO+xDeQKC
         nAHUhRoR9oKxTHHL5/yGn2E5cJ+Qe3bgbVJDoegolbs4aC8d2vUuyLFnDkbKg2l/i0aq
         NxpHs4unoruxbU+gr9msDjekEeUhE9cskuOZJZXX+A0LFwIpPCgMqfLPgTNecWK2sRiO
         Jm9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZL4aDZ+YC4x+HiBwjE0mhqgEP2w/XBS3OvcvPk1ksNg=;
        b=E9f19+/ZH3G7F0lwd2z7o0s1XEr3lUFdfVEPhJ6n1T8qPWfgRmLuEy76KB3bXRdvsC
         MRtnXy8YTMR0asDmyRD3UmZbOCGvwUZbB5RKQWmqwlDxm6gFTEhnMQDjt7fcioozMM+V
         JJjgk4+nazvJ7y400wsjLT9+nexYPoeylQBJnCko0Mm0Y3Y9hWo4kbV0/LHwl+595UQx
         dVWmM8OWWHllUaqTWBPj+iYoHLNExfRPdyth7BZDJDyNQCSrczbSZoywxAo3VJc93mVc
         TMKgieCkspVfXbJL9Mbf8p+ApCAD8tMVzSX3YkcJcviEjwuqOvYOjPreW2z5oK+pxV/p
         362g==
X-Gm-Message-State: AGi0PubXkpA1iriPrYloCTNNAhXDWynnONynV5GoWN2/HpJ4PUO+mLIU
        z3w3vEffogWgML1JJLRp6M0=
X-Google-Smtp-Source: APiQypK9nIcWzZwYvAjYBHGs3gjqtE23UsJ/NamYEVz5EirevGODQYxFS1UNQ+/DVKB8Z4/Y+H/w+A==
X-Received: by 2002:a17:906:348d:: with SMTP id g13mr1020295ejb.374.1587611378587;
        Wed, 22 Apr 2020 20:09:38 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id h9sm248167ejb.47.2020.04.22.20.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 20:09:38 -0700 (PDT)
Subject: Re: [PATCH v3 16/31] elx: efct: Driver initialization routines
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-17-jsmart2021@gmail.com>
 <01037050-b4f8-c171-ce53-deda6b9b0aa7@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <fe96ead8-38a4-3744-cde4-d820f0798b22@gmail.com>
Date:   Wed, 22 Apr 2020 20:09:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <01037050-b4f8-c171-ce53-deda6b9b0aa7@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/2020 12:11 AM, Hannes Reinecke wrote:
...
>> +    if (efct) {
>> +        memset(efct, 0, sizeof(*efct));
>> +        for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
>> +            if (!efct_devices[i]) {
>> +                efct->instance_index = i;
>> +                efct_devices[i] = efct;
>> +                break;
>> +            }
>> +        }
>> +
>> +        if (i == ARRAY_SIZE(efct_devices)) {
>> +            pr_err("Exceeded max supported devices.\n");
>> +            kfree(efct);
>> +            efct = NULL;
>> +        } else {
>> +            efct->attached = false;
>> +        }
> 
> Errm. This is wrong.
> When we exit the for() loop above, i _will_ equal the array size.
> Surely you mean
> 
> if (i < ARRAY_SIZE())
> 
> right?
> 

No. We want to free the structure if we went through the array and 
didn't find an empty slot. It only breaks from the loop if it found an 
empty slot and used it.



>> +        } else if (event->topology == SLI_LINK_TOPO_LOOP) {
>> +            u8    *buf = NULL;
>> +
>> +            efc_log_info(hw->os, "Link Up, LOOP, speed is %d\n",
>> +                      event->speed);
>> +            dma = &hw->loop_map;
>> +            dma->size = SLI4_MIN_LOOP_MAP_BYTES;
>> +            dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
>> +                               dma->size, &dma->phys,
>> +                               GFP_DMA);
>> +            if (!dma->virt)
>> +                efc_log_err(hw->os, "efct_dma_alloc_fail\n");
>> +
>> +            buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
>> +            if (!buf)
>> +                break;
>> +
>> +            if (!sli_cmd_read_topology(&hw->sli, buf,
>> +                          SLI4_BMBX_SIZE,
>> +                               &hw->loop_map)) {
>> +                rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
>> +                             __efct_read_topology_cb,
>> +                             NULL);
>> +            }
>> +
> 
> Not sure if this is a good idea; we'll have to allocate extra memory 
> whenever the loop topology changes.
> Which typically happens when there had been a failure somewhere, and 
> chances are that it'll affect our root fs, making memory allocation 
> something we really need to look at.
> Can't we pre-allocate a buffer here somewhere in the global 
> initialisation so that we don't have to allocate it every time?

Agree. will look into it.


...
> 
> What happened to multiqueue support?
> The original lpfc driver did it, so we should regress for the new driver...

For a target driver ?

When something like this is in the tgt infrastructure we'll do something 
with it.

-- james

