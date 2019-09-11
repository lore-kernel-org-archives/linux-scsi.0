Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D36ECDE20
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 08:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E5022085B
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 08:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfIKIXu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Sep 2019 04:23:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53360 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfIKIXu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2019 04:23:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id q18so2318168wmq.3;
        Wed, 11 Sep 2019 01:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7iC288htQQShWEzvGgwOYDZwehD1Nka894QH5xX/9cI=;
        b=bIbVJ5HE3gQwAEeK7mWeYFOcSozt87POGxCQbIw99379d/CS8fd7gOBXclZT7GirQs
         LWdvwP9jjdSwcjKBhXSKSfzTwdG0Ish3sE8Lm92vmhEnm7uNMCyh9dXl+3redKxjB01O
         GY2WhQdkZu8qo+ELm2+jWK8LRDHF8DKrYHPW0hMgmeOiktLLbNuKm5dH7x+KVpk/btU/
         dHu5EqbspB4t5tN+XpuQKEAN6fi9EDPuIyS6G4BksWB+jDID3/jZ7SCb2bjcbw1t1/EO
         TPrDdhPY9y1YqqJkAzhVTL23VNHkJFDXrUfS9yARhahPK1vzfRtNJSeWej33Iy6MhRDK
         yDpQ==
X-Gm-Message-State: APjAAAUn8vBYPcXEDyJzjyMm3dbVvFwmvuHlgaRfGKqU/9VTlUMZ4CPe
        /1HNL/UhNgV1UZ1lTAh0WMmmCjWjc7c=
X-Google-Smtp-Source: APXvYqzUwDcbcQE58BGg+dWRNRxA/vR89ms+O87wrc5oL3XiHLhR8v5MoMDUEg0gRuW1m/BiGRujoA==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr2959578wmd.7.1568190227313;
        Wed, 11 Sep 2019 01:23:47 -0700 (PDT)
Received: from [10.0.4.250] (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id s1sm30205463wrg.80.2019.09.11.01.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 01:23:46 -0700 (PDT)
Subject: Re: [RFC PATCH] Add proc interface to set PF_MEMALLOC flags
To:     Mike Christie <mchristi@redhat.com>, axboe@kernel.dk,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20190909162804.5694-1-mchristi@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3e32b453-0350-0a09-9b1b-b0c49e2609df@acm.org>
Date:   Wed, 11 Sep 2019 09:23:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190909162804.5694-1-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/19 5:28 PM, Mike Christie wrote:
> There are several storage drivers like dm-multipath, iscsi, and nbd that
> have userspace components that can run in the IO path. For example,
> iscsi and nbd's userspace deamons may need to recreate a socket and/or
> send IO on it, and dm-multipath's daemon multipathd may need to send IO
> to figure out the state of paths and re-set them up.
> 
> [ ... ]

Should the linux-api mailing list be Cc-ed for a patch like this one?
See also https://www.kernel.org/doc/man-pages/linux-api-ml.html.

Thanks,

Bart.

