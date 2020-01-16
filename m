Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B0FC33CB6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 05:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B602077B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 05:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILVeTiAH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbgAPFJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 00:09:31 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35795 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgAPFJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 00:09:31 -0500
Received: by mail-pf1-f194.google.com with SMTP id i23so9627703pfo.2;
        Wed, 15 Jan 2020 21:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YENX8hiVU9VGaahzof39zWD+xiTd5KVBkuDLg5pimCk=;
        b=ILVeTiAHzaiiBur5Z3L5U5lwL+6xoe6mE4zF2Gz6yoiUaAc3pEbLDECoNk20sanE9W
         utwzTwrGspzWc4G9mz8fVBTyBFtPGeKlR1Tuc0wRKkaDrlJAiFSBpBwlAdPTQpWjpd8P
         H9hOOG/RzsnGOpLN7C+PMeE4qr/Wd9K4PG4zsu3BjyB9fjqQd7ZB5Cp40w8Xm46Ld2Mj
         2Ou/+4jDsqrXcr1N5FgeDzMsIikU61XqT+KkDCSM7RfdpeYNX7rA+M/WAPrZOH2f46jG
         vxTwlHhE2Ovz3GSMT3FOo+o/jkszDGw3bEB6qU8asXntHydj599/IUSeGfwO09IUulCj
         w5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YENX8hiVU9VGaahzof39zWD+xiTd5KVBkuDLg5pimCk=;
        b=U2RJqk1BOj4UT/jmAQSq4DUvBJxzFc8YFx4uLJhCq2cP5OyrIKKny9S+MBN2/Xx5KL
         ksuhA5j1ZTA7fQ+xDbRa8NYaHJ3FTEOlGL05ra2DPKj6vy8bsK8lNxMCgudELb3ETIqI
         n3mPpopKLlVziZHFNT1cdSOAOuRn4gSZKH9UqVbrgpKWO8K9sWp5BiLmClHcRw7HDWE+
         24nrUH2QCfgX64FEHtNTNIT2g0IkjMsErz9tn3WSapDW6LT31lr38pXnDK0y1ldRYNhd
         gcY7EgFTmgteoIJ/rNGPFyo2i5zwvGzPvrysfM3XJ7kKiVIHXbKXGxF7t6PjVUx1OQWd
         kYUw==
X-Gm-Message-State: APjAAAVybDeaWz5FE0MLtmzZBqM7DPbGX6wu0PX7m+OVtlRRGk+Xl1xk
        vIZ5msW34ucQtAlpD1XUjRs=
X-Google-Smtp-Source: APXvYqzmhidzHKldpgAevjXwhrc2Qa32pr1CDX8k/3+7Fx4vQRmHtCNUHnWVMdHewxzjsqh1rApo5g==
X-Received: by 2002:a63:b4d:: with SMTP id a13mr36135928pgl.388.1579151370463;
        Wed, 15 Jan 2020 21:09:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z30sm22546622pff.131.2020.01.15.21.09.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 21:09:29 -0800 (PST)
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net> <yq1r211dvck.fsf@oracle.com>
 <b22a519c-8f26-e731-345f-9deca1b2150e@roeck-us.net>
 <yq1sgkq21ll.fsf@oracle.com> <20200108153341.GB28530@roeck-us.net>
 <38af9fda-9edf-1b54-bd8d-92f712ae4cda@roeck-us.net>
 <yq1r202spr9.fsf@oracle.com>
 <403cfbf8-79da-94f1-509f-e90d1a165722@roeck-us.net>
 <yq14kwwnioo.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a825a71f-6129-4aac-3430-66c67e4d3985@roeck-us.net>
Date:   Wed, 15 Jan 2020 21:09:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq14kwwnioo.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 1/15/20 8:12 PM, Martin K. Petersen wrote:
> 
> Guenter,
> 
>> The hwmon-next branch is based on v5.5-rc1. It might be better to
>> either merge hwmon-next into mainline, or to apply the drivetemp patch
>> to mainline, and test the result. I have seen some (unrelated) weird
>> tracebacks in the driver core with v5.5-rc1, so that may not be the
>> best baseline for a test.
> 
> I'm afraid the warnings still happen with hwmon-next on top of
> linus/master.
> 

Can you possibly provide details, like the configuration you use for
qemu, the qemu command line, and the exact command sequence you use
in qemu to reproduce the problem ?

Thanks,
Guenter
