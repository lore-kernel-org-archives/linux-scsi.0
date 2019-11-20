Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E612C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 00:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C4B4222B6
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 00:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfKTAPJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 19:15:09 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34876 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfKTAPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 19:15:09 -0500
Received: by mail-pl1-f194.google.com with SMTP id s10so12898437plp.2
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 16:15:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5e1pakyY874apaoAQAoEdsMsi6VKbfNb9VD2VwanHIw=;
        b=VZ2MLFXIi5ttYBYsdRj+YQkuEMBh12wp/WJ6pFFjVZ/2iT0yqnD8MNLays5GLB/JQf
         q+Rg2VmSk4v3Yz1JeKfBiYvsOVsfQrvKj55seQ5kk8SZbYjtAcaoYBv+LoS+iOpdTnNl
         0OmJTCfzirZMaAJjhkBWdtInWgNo6COi87DOwyM416ba53hrZ6ED45++BzXjiYtHbj40
         p75BXmRbboGJAYZZ6zI9lthK5ij/Rc7SuxKoWgB2lXPgixUdz4RSmM0CZG8766Wpv/fG
         jlneuUIMlnUxdnsD32xHnwffGZViyt4kIsbLa6SqZjqoUZv6a8rggir6sDa3icuHuyxz
         U6XQ==
X-Gm-Message-State: APjAAAVPyrTgV9RBv3mHMiTdZfC7w/aDtLJAv0Dg5Qxc5Ef1JMGaJo2U
        eWvXivVoKuGvHLs7vlGTXh2Bjcpz
X-Google-Smtp-Source: APXvYqyjFPC3HcuJos0sY1MJcOTdXVOwAo3r8zjs4J/7N49bKAC2MJ9IZraYafq1fHfrs/CB9hJ51A==
X-Received: by 2002:a17:90a:24b:: with SMTP id t11mr326400pje.77.1574208907278;
        Tue, 19 Nov 2019 16:15:07 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p16sm4860767pjp.31.2019.11.19.16.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 16:15:06 -0800 (PST)
Subject: Re: [PATCH] Revert "qla2xxx: Fix Nport ID display value"
From:   Bart Van Assche <bvanassche@acm.org>
To:     Himanshu Madhani <hmadhani@marvell.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>
References: <20191109042135.12125-1-bvanassche@acm.org>
 <20191111112804.nycfzaddewlz6yzl@SPB-NB-133.local>
 <32187dd9-f222-fbed-cc93-1c6abca6e06c@acm.org>
 <19433666-FCA3-4340-8A81-707F85B87F02@marvell.com>
 <1dac96c3-54d5-11bf-292b-c25a62a3c919@acm.org>
Message-ID: <fa7d57ec-77b3-3397-063e-d949716abaa8@acm.org>
Date:   Tue, 19 Nov 2019 16:15:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1dac96c3-54d5-11bf-292b-c25a62a3c919@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/19 6:34 PM, Bart Van Assche wrote:
> On 2019-11-13 07:29, Himanshu Madhani wrote:
>> On Nov 11, 2019, at 8:48 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>> Himanshu, can you tell us which adapters and/or firmware versions need
>>> which version of the above code?
>>
>> All adapters with FW v4.4 will behave same. If you are running into issue with P2P connection,
>> it might be something different than specific to this code change. Original code in the driver was not
>> following firmware spec. This code is now used in initiator mode as well due to introduction of
>> FC-NVMe handling in the driver.  Also, can you tell me what version of firmware you have on your
>> remote port.
> 
> Hi Himanshu,
> 
> My test was run on a setup with a single QLE2562 adapter with both FC
> ports connected directly to each other. The kernel driver identifies
> that adapter as follows: ISP2532: PCIe (5.0GT/s x8) @ 0000:00:0a.0 hdma+
> host#=12 fw=8.07.00 (90d5). Please let me know if you need more information.

Ping?

Bart.
