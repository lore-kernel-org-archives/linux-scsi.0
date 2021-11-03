Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50FCC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9161060F58
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:23:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhKCQ0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:26:08 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:44628 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhKCQ0H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:26:07 -0400
Received: by mail-pl1-f179.google.com with SMTP id t11so2778429plq.11;
        Wed, 03 Nov 2021 09:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cUoN3Jf7ze15Ze1I6TWgtZLhkp0qQPWGYTaiuciHyZM=;
        b=1GwGI93OqzZt0P0NeTl7+gYc0KLfdO50iA4oatHEwaZNnUuMC1xADKTEg8C5Rnk0AP
         U3DZPZk1sGiZgOugQx3VSJWfj5zB7GhoCm8SVA3GccN0rWMpE9ANH2wDT/i0gMD0Psn/
         e7mHwTiejwd31MHyX7aR9eBEM15tw7jYmUuE/7dwV5MUId0Gs/VvqvOmfiXnlmKl5X5t
         be3LBbyS1spDFHTco8PPHyLU+OTjZHs2lRLt/2xPtmy9ZT0U5zMeVe7CLr134/lgDiwg
         fgzEObuE3ZFh82tMhhhHhiPXZ4UMQmiD1+SZoIZR+XRZNSgNl1OGLSFz5RWxfdHNE0dq
         Kyhw==
X-Gm-Message-State: AOAM532T3QQQiHxl1ZBaZVZChPE2bycHljo2psHeAgSoCqYPrKJFgx3h
        tDx84e3fXatZs4Bwr5d2tU+4flRR+53lcw==
X-Google-Smtp-Source: ABdhPJzP11S30D47yxpOmjlgXUSpOLbouptt4JxJyV6701Q4HkduWL0HOfIqY5cQJtAM7sGPH3zG2w==
X-Received: by 2002:a17:902:900c:b0:13f:974c:19b0 with SMTP id a12-20020a170902900c00b0013f974c19b0mr38732145plp.12.1635956607230;
        Wed, 03 Nov 2021 09:23:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9416:5327:a40e:e300])
        by smtp.gmail.com with ESMTPSA id h12sm2959965pfv.117.2021.11.03.09.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 09:23:26 -0700 (PDT)
Subject: Re: kernel 5.15 does not boot with 3ware card (never had this issue
 <= 5.14) - scsi 0:0:0:0: WARNING: (0x06:0x002C) : Command (0x12) timed out,
 resetting card
To:     Justin Piszcz <jpiszcz@lucidpixels.com>,
        Douglas Miller <dougmill@linux.vnet.ibm.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
References: <006a01d7cead$b9262d70$2b728850$@lucidpixels.com>
 <a4a88807-8f52-ef9a-c58e-0ff454da5ade@acm.org>
 <CAO9zADxiobgwDE5dtvo98EL0djdgQyrGJA_w4Oxb+pZ9pvOEjQ@mail.gmail.com>
 <CAO9zADycForyq9cmh=epw9r-Wzz=xt32vL3mePuBAPehCgUTjw@mail.gmail.com>
 <50a16ee2-dfa4-d009-17c5-1984cf0a6161@linux.vnet.ibm.com>
 <CAO9zADwVnuKU-tfZxm4USjf76yJhTZqWfZw4yspv8sc93RuBbQ@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e0c2935d-d961-11a0-1b4c-580b55dc6b59@acm.org>
Date:   Wed, 3 Nov 2021 09:23:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAO9zADwVnuKU-tfZxm4USjf76yJhTZqWfZw4yspv8sc93RuBbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/21 9:18 AM, Justin Piszcz wrote:
> Thanks!-- Has anyone else reading run into this issue and/or are there
> any suggestions how I can troubleshoot this further (as all -rc's have
> the same issue)?

How about bisecting this issue
(https://www.kernel.org/doc/html/latest/admin-guide/bug-bisect.html)?

Thanks,

Bart.
