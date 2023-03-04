Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3716FC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 02:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCDCZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 21:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDCZ1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 21:25:27 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C459513DD4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 18:25:26 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so8000008pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 18:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677896726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ryzENQoWyOnusFoiMkYRq+3gM8Uv/jqHhiSmhXTB5FY=;
        b=Mzq5w9vsLFHcnqNA2WnZ3WBKnyF9wdGoP533BWB3BRnT41DDTPubLSbDoYRUY5B+p8
         5zFWy4XjigU3aoc7tTkj6uGx1ksLkoU9L8YXrxf/OEQVi3/MhAg+qtonrd8JBtw0nmt2
         lrJLala1Em78mTD2hEhKvB/fgzcTsMd+ulEp47odnjKIKBHfLYNZbrXnRS0RxNbM3ra4
         p2GOf+cRZtE7gVsYoJ0xhvQWX8V8ErtS015jkX5gEeqLuMAHQx9t0S5jaJYBA48VFTKj
         fdsIMDhv9NKJJa7g4GDcZRduknneiuQJyHdx/B3xgBuD6XHDdkfxYzwMRXAqa7OtywYa
         Axhw==
X-Gm-Message-State: AO0yUKWs20YhE4z8bjpCKJiQ4bzMyeqL3dBp/GmITwn4HVJAoBC0bfbv
        X0jK0fVL/SEd8cnOvAUBmSM=
X-Google-Smtp-Source: AK7set+X4J/8AYWH7i8m2j1UnC8jjaNnmYLTg2njMfN8oLYUj0mEiKwFh8ExZPJrZWmtDIKOjUV9HQ==
X-Received: by 2002:a05:6a20:394f:b0:bc:8254:ddff with SMTP id r15-20020a056a20394f00b000bc8254ddffmr5110634pzg.1.1677896726098;
        Fri, 03 Mar 2023 18:25:26 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id x2-20020aa79182000000b0058bc7453285sm2211038pfa.217.2023.03.03.18.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 18:25:25 -0800 (PST)
Message-ID: <5604011a-0b1a-1be7-5a1f-014e81a2ed74@acm.org>
Date:   Fri, 3 Mar 2023 18:25:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 65/81] scsi: ps3rom: Declare SCSI host template const
Content-Language: en-US
To:     Geoff Levand <geoff@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-66-bvanassche@acm.org>
 <1a56500e-f92d-93b9-77c7-20186fe43a6d@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1a56500e-f92d-93b9-77c7-20186fe43a6d@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 16:53, Geoff Levand wrote:
> I want to test this.  Please let me know where I can find the whole patch
> series, or better, a git repository and branch I can clone.

Thanks Geoff. A git branch is available here: 
https://github.com/bvanassche/linux/tree/scsi-const-host-template. The 
entire patch series is available at 
https://lore.kernel.org/linux-scsi/20230304003103.2572793-1-bvanassche@acm.org/T/#t.

Bart.

