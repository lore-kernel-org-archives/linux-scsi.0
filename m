Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752CFC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 22:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A8A260F51
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 22:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhJFWNa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 18:13:30 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:35375 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhJFWN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 18:13:29 -0400
Received: by mail-pj1-f53.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so5491545pjw.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 15:11:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lzott+MP6ZW8Lr8bEijAbLBGSJZzF3vFogX/ePnbk7w=;
        b=nAKh9AJnMjFlnCH9UFEI2boYZz2EelD3A7UMri8ulG3wIAMMmShFHFkmT8c9iKrkOM
         xHVcK6oxFt0Qh2Tw9QXLxg5HBUsTxfDnJH6J223pVq9nNR5OEMn0TZH+UeKKhBBvJ2I0
         4NglArICQXdO+nwavR3f19bVJVmV7sT6eQMER4YGDcgy5mc/jzqf71uyikaYfRU2R0x/
         spH+xQVqN1CWdWt+9bZU2v7tP3OaJBtnc8yyeh8n4cvZIR/klA/lYp0spoDvzEpnEmOv
         vWo9a79xhfvkmI2Obekp4wH7blDPVWEJGEtiscoqOfhRpf/Hho+5zfsKwhmYbUTl3Xjb
         Zc9A==
X-Gm-Message-State: AOAM531DhQOG+GsNjq0r/EDSxb0rdijM8K7XytPTwUolzre/W6Hkwabf
        jY/veoq7gG6As71smldFDjc=
X-Google-Smtp-Source: ABdhPJyNp3YmoZVOoaAX107mxbHZEwolWPLGatVXYk/V3y/5cuHyu0TGWL5jSmtvO74Mr0ACYqa2Pg==
X-Received: by 2002:a17:902:be0f:b0:13a:19b6:6870 with SMTP id r15-20020a170902be0f00b0013a19b66870mr374262pls.64.1633558296720;
        Wed, 06 Oct 2021 15:11:36 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2514:d77c:c0ef:3719:236? ([2620:0:1000:2514:d77c:c0ef:3719:236])
        by smtp.gmail.com with ESMTPSA id v7sm21248888pff.195.2021.10.06.15.11.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 15:11:36 -0700 (PDT)
Subject: Re: [PATCH v2 72/84] storvsc_drv: Call scsi_done() directly
To:     Wei Liu <wei.liu@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929220600.3509089-73-bvanassche@acm.org>
 <BN8PR21MB12841C43D1775DACB542A1A8CAAA9@BN8PR21MB1284.namprd21.prod.outlook.com>
 <20211006120020.dhop72wlqjanymoz@liuwe-devbox-debian-v2>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <693fede4-cc94-cb7f-1d55-cb8be7cf4a11@acm.org>
Date:   Wed, 6 Oct 2021 15:11:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006120020.dhop72wlqjanymoz@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/21 5:00 AM, Wei Liu wrote:
> Seeing this patch is part of a large patch series, I am expecting
> whoever funnels the whole series applies this patch together with other
> patches. Let me know if I should do anything else.

Hi Wei,

This patch series has been sent to Martin Petersen, the SCSI maintainer. I
hope that Martin will merge this series in its entirety.

Thanks,

Bart.
