Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C02C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 20:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGKUFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKUE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 16:04:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4A027B04;
        Mon, 11 Jul 2022 13:04:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id i8-20020a17090a4b8800b001ef8a65bfbdso5933808pjh.1;
        Mon, 11 Jul 2022 13:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=sdt0jHJgDduETZ3dWgaNry7cBWYeR2McIlCaKxzRSzs=;
        b=RuYVdJujcFi1sLxzzLi5qJOlCPZhpI3vFHFdjdj4Dhv1/V6qb8aJfeO/IxDwqFoXy0
         nd4Lu536L3dx8o/wLjPbrBJ1FiPaUVmG0WQmKz9jzqCZBVsIkaWS8E9/mLfXO+uvNe0r
         9krsZFZJUs8KHBfr4i5bMi2VZvyYMqE5qVevrP9Mq5hewXgHNRsFqV+NF4iWLoAgEpNC
         nh4j+8IO8cRPwIZZUMuvcKcZI57tJdXbB0x1HkthVUEaICmD9dF8f0pSBA5QFey64IVc
         s0d3Dc5is5BPNAhj7GIdM7mBRZDMTpUcd+r17JdBnxYHhnM1rbwI1w42aqI4Tpn71N21
         jr6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=sdt0jHJgDduETZ3dWgaNry7cBWYeR2McIlCaKxzRSzs=;
        b=YML10cIkhG/E/OOyGcaRGsJtW6TAglSggxQd+KtEozkTKSD+G1tlCVSK+4qeQmtXge
         055/F+EG93hLtphzU2YHQCAAI307vJhxyhaBzgRMQ072PFWfl1cUJf2kvpjTHNJFP26v
         EQ6VQzwZiePP+AH8wcJEQcpd0ko2O9/SLxgmau3XpxgsQq8AfmvY0goOf8JR3iIb2UJg
         QFHpc2oPCuH8cyyaoHa0TD9KTcjNCDt4IIHJNiAd+ljzsZtT7/n3af6latHlhA1tBTj7
         y79tt+HIa51BZF7OWbq2LsL9pNhXGDlRxMP9itpNgdEsPZgaobVIGPjRRWiiMf2BJsI4
         f3ow==
X-Gm-Message-State: AJIora/bmHf0YBfXLqIat764WgTX2+WD6/JRc6idvazTGeEzjpECX7XA
        2/uvO8lSM1PJVqfM2Q0+wHqd2a6p39U=
X-Google-Smtp-Source: AGRyM1sCmhNSYgttcMPlPLHQE62z2zdUSbpxoedR1E+/DtsFTck/jX/kZrNn7X8s9xfRXrMbNykwmg==
X-Received: by 2002:a17:90a:bc95:b0:1ef:8b48:fa0b with SMTP id x21-20020a17090abc9500b001ef8b48fa0bmr48424pjr.189.1657569897196;
        Mon, 11 Jul 2022 13:04:57 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902e5cf00b0016bffc59718sm5188045plf.58.2022.07.11.13.04.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jul 2022 13:04:56 -0700 (PDT)
Subject: Re: [PATCH v1 1/4] m68k - add MVME147 SCSI base address to
 mvme147hw.h
To:     Arnd Bergmann <arnd@kernel.org>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
 <20220709001019.11149-2-schmitzmic@gmail.com>
 <CAK8P3a2kwg56-UTv275GJ1r_SDsfoX2fMcmXrvNURN+L3UHoSA@mail.gmail.com>
 <89f0efa9-9626-2380-49dc-432ac04fe6f2@gmail.com>
 <CAK8P3a0JRhKj9aoS3-RKsu3yGW+0geSB7CqEytdbBn622nREFw@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <45072190-af84-d275-b36f-d7f3ff11f403@gmail.com>
Date:   Tue, 12 Jul 2022 08:04:51 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0JRhKj9aoS3-RKsu3yGW+0geSB7CqEytdbBn622nREFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Am 11.07.2022 um 20:45 schrieb Arnd Bergmann:
> On Mon, Jul 11, 2022 at 6:16 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Am 11.07.2022 um 04:06 schrieb Arnd Bergmann:
>>> On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>>> I think this should be an 'void *__iomem' token, not a plain integer.
>>> Apparently the driver internally uses a 'volatile void *', but some of
>>> the other front-ends are already converted to use __iomem.
>>
>> I'll pass the base address through a platform data struct in the next
>> version to address your other concerns. Haven't seen __iomem types used
>> in the other drivers - two are Zorro devices, and two platform devices
>> (a3000 and sgiwd93). Found no other wd33c93 drivers...
>
> Right, I noticed this as well. The ideal way to do this would be to change
> all of these files to use __iomem tokens consistently, and then use
> ioread32be()/iowrite32be() in place of the volatile pointer dereference.

On a second glance, the Amiga drivers _do_ use iomem types (ZTWO_VADDR() 
does the Right Thing, leaving this driver and SGI.

Changes in wd33c93.c proper (which I read your mail to suggest) would 
require actual hardware regression testing IMO. Not sure I can do that.

Cheers,

	Michael

>
> Maybe leave that for a follow-up series, you'll probably uncover
> more of these issues once you take that step.
>
>        Arnd
>
