Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B19C38142
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 23:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjAQX0l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 18:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAQX0N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 18:26:13 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566E638B55
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 13:23:24 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id q9so23015708pgq.5
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 13:23:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQ0gKcTRtyeTq1Jz8qr10zYW03O3Af8RS8II3BuYjUo=;
        b=BNbVPuIBDvH4q713e23fLbyRs0ghYA0/0yDL8QnGod3rNQ/r+hvFn4p7A645o6AiYY
         gI4cJZ1EVR+IeB/CzeyJQ2MB45iR+yXT90bC2wQjDXdONem23UNj7LWs8JcvJ3dv4tG9
         zbZukhRvB9wj9JV4ot/Yn3bws7WjSCaw/Mq8OzLWt7ZSZF2ioF59HrT2GbEaRIJd009P
         +dDdcuw2subR0HySSr1b0lzym+GcghODDpJZn/XWgUjMqOx+CNgyMuOIy7+TZkgxNqqj
         1tO+zuaDXhC0VO985pKmOOSyc3VWqWi9gzPovgtX41xhvOGs9CNsZqQ6lHNQR7zzzP5U
         tjaA==
X-Gm-Message-State: AFqh2krGowscTDSI8zmSjiYWsW3/wfeYeDOzQdliWYUb8nsVBZzr0Qiv
        SuIziZSa9IjAQtvda1HDmno=
X-Google-Smtp-Source: AMrXdXu/69KIqDKbNpLwHNX1Ngqqr5C4Xl8n/vV2CUlRskbs5EjozvC3o5xm1SNT/n9jym21ViF+mQ==
X-Received: by 2002:aa7:8286:0:b0:582:b7a7:de13 with SMTP id s6-20020aa78286000000b00582b7a7de13mr5329124pfm.10.1673990603624;
        Tue, 17 Jan 2023 13:23:23 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:f632:d9f5:6cbb:17d0? ([2620:15c:211:201:f632:d9f5:6cbb:17d0])
        by smtp.gmail.com with ESMTPSA id w4-20020aa79544000000b0058db5d4b391sm3562459pfq.19.2023.01.17.13.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 13:23:22 -0800 (PST)
Message-ID: <531f3f82-712c-eb0b-d22d-710e8a36b3c2@acm.org>
Date:   Tue, 17 Jan 2023 13:23:19 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [lvc-project] [PATCH] scsi: hpsa: fix allocation size for
 scsi_host_alloc()
Content-Language: en-US
To:     "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        storagedev@microchip.com, Don Brace <don.brace@microchip.com>,
        lvc-project@linuxtesting.org
References: <20230116133140.GB8107@altlinux.org>
 <39006233-ff6f-82ad-b772-e00e789375a5@acm.org>
 <20230117095644.GA12547@altlinux.org>
 <30d3e555-4fb0-23df-abeb-e1c3dc41543e@ispras.ru>
 <20230117211201.GD15213@altlinux.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230117211201.GD15213@altlinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 13:12, Alexey V. Vissarionov wrote:
> 2 BVA: please use the correct commit number.

???

My understanding is that you used an incorrect commit hash. Hence, it is 
up to you to fix the commit hash.

Did I perhaps misunderstand something?

Bart.

