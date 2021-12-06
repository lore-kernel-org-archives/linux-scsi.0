Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A44C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Dec 2021 17:05:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbhLFRI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 12:08:58 -0500
Received: from mail-pg1-f181.google.com ([209.85.215.181]:41935 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349567AbhLFRE1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 12:04:27 -0500
Received: by mail-pg1-f181.google.com with SMTP id k4so11041721pgb.8
        for <linux-scsi@vger.kernel.org>; Mon, 06 Dec 2021 09:00:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zoQiiF6RoE4pj7ANn1G+Fd4eNhBsO/e09yU1b0+qbPU=;
        b=5/4COW7qXm1E14beQq8C+KbMlAoi8u195w7Nmx+DW7d3NaRSpOpILfwc/y4H8ddkZp
         Pl9Ytj98NP3b58lRWj24R3Uye/NcXF/OCzQpzMUBm/C8WpRukmO7paloLfjHPEkvoNq+
         XtFocfzIWbVAFZqWr/ThoX8qtecgpEn5fOYzKAVonVD27zPSJOcQvADtKELIN5ckAW+Z
         Xjn4iNvvQcZ1RhhonpoDIfXS7rRXffiPn2nM4RvptzbSfeb3fqcyEAd/UDKIxjd5M5De
         7aF6+Iwo9KtO2MPBVsZJcmbSiRow3NOAdPpWM7M0G31xE/z4GB5xaBVLDUGd/suaHkmn
         C7bA==
X-Gm-Message-State: AOAM530Qqtb4YS+tM4QU9FHzN6g6UV18Rmg1sWUnvmpNhi9/cYCNSz8o
        VruZe4pozmg+fEnbmhzOJ/U=
X-Google-Smtp-Source: ABdhPJx5Q16Mqbzx/hWZ1US8GLpYY6GwTZnkvu5XsYz4RY4kZxEsyLtOctfm8L1ks+5xft2mHdsnDw==
X-Received: by 2002:a05:6a00:10c7:b0:4ad:bbfd:7b3b with SMTP id d7-20020a056a0010c700b004adbbfd7b3bmr8680528pfu.78.1638810058037;
        Mon, 06 Dec 2021 09:00:58 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c500:c5f2:b7a5:d7c6])
        by smtp.gmail.com with ESMTPSA id u11sm5351313pfg.120.2021.12.06.09.00.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 09:00:57 -0800 (PST)
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Hannes Reinecke <hare@suse.de>, Yanling Song <songyl@ramaxel.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
 <99fb2d55-88c0-2911-3b71-7670d386ab1c@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7d6f4200-9140-5f1c-b962-8762703ccba1@acm.org>
Date:   Mon, 6 Dec 2021 09:00:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <99fb2d55-88c0-2911-3b71-7670d386ab1c@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/29/21 5:04 AM, Hannes Reinecke wrote:
> This entire thing looks like an NVMe controller which is made to look like a SCSI controller.
> It even uses most of the NVMe structures.
> And from what I've seen there is not much SCSI specific in here; I/O and queue setup is pretty much what every NVMe controller does.
> So why not make it a true NVMe controller?
> Yes, you would need to discuss with the NVMe folks on how a RAID controller should look like in NVMe terms.
> But overall I guess the driver would be far smaller and possibly easier to maintain.
> 
> So where's the benefit having it as a SCSI driver (apart from the fact that is allows you to side-step having to discuss the interface with NVMexpress.org ...)?
> Or, to put it the other way round: Is there anything SCSI specific which would prevent such an approach?

Hi Hannes,

Isn't every driver that defines a struct scsi_host_template by definition a
SCSI driver?

If there is enough code that is shared between the spraid driver and the NVMe
core one could look into creating a library with the shared code. However,
I'm not sure this is worth the effort nor that the NVMe maintainers will
agree with this.

Thanks,

Bart.
