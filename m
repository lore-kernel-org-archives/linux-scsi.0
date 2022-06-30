Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A34CCA473
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 19:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbiF3TnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236883AbiF3TnC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 15:43:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE0243AF1;
        Thu, 30 Jun 2022 12:43:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d129so287245pgc.9;
        Thu, 30 Jun 2022 12:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xvEaFA6L9X7f6lr8BSnAnlsPZYQCBWZ+D/OUmyYmQxQ=;
        b=azwPIg8iyvR2TPyzC4A8BLZI4a2l3sXTgXC+acBdrYmHdSkJ9DQxZK+Yv378EXfjVg
         u3f6abTQURR0zB24WV/pO0H2P7lg9olJWCsGfFL0AizvGLIxqbMa803F/KAQJKtz8Pds
         PQNOfQpesTQ7jjN0HQM4GM/ZXmiI2QzFY7lRQnkhWFwkk9L6Jxry50QLbknDlT4K0xd7
         kbngKnhkgTVTiUDu8xAF/+KSZAy7LfMLr2WWkAKPkqtnTHj36OvWO/t3cIjMdmt6kkKj
         P+qkwiGhrV8NWs/6X8qNitjWbirY7GvcHnVsGfnvVHLfo2kuLraQVIcpefykM4mYAQJv
         1C4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xvEaFA6L9X7f6lr8BSnAnlsPZYQCBWZ+D/OUmyYmQxQ=;
        b=ma0fOX0u7gQFhKWbfwm+ISfaLB686qoTZoqVpFBgmLeG1vbE9loewhOnx+bb32tscD
         cyTdpusbDhCnHMCcAMZKG8pfQMW8DlrT/O4X4EL9tou1XPF/ARv6xnK7BwrjI0TtT4Zd
         qP6c+UUtyT7ciO5xRCdRK/Rav/QaOd6nFA0XeCdVl9JQJQs9gi6X8kxZQ7toYn9RgwoU
         X8R2BR358grcHgqIE7135DFtVoU2oWhaexAWNDn4CD72PO3MrRtwZ1AIaejBre35Peda
         5yNlklCewgWSMVuaUnS56w3RVHz4J8AA22hkhV8n5Rcd19tGK71h0KH7JATAvxXBFPcR
         2Xmw==
X-Gm-Message-State: AJIora9Ows7ILxmRJ5EouhI5pgcitvwAuolqAjPSEtz1lL4uQ/HRqZfx
        dwG8h/4GPV98ncZpbkUfj/M=
X-Google-Smtp-Source: AGRyM1vO/U7arIww3Inj3VCTepUIpgFTkb8ftK56K/9/R2rIm4lO9B0tbU5dzbdgga/sgCgRX4p8PA==
X-Received: by 2002:a63:b1e:0:b0:3fd:43d9:5354 with SMTP id 30-20020a630b1e000000b003fd43d95354mr9126450pgl.294.1656618181101;
        Thu, 30 Jun 2022 12:43:01 -0700 (PDT)
Received: from ?IPV6:2001:df0:0:200c:b411:35d2:9458:bbe5? ([2001:df0:0:200c:b411:35d2:9458:bbe5])
        by smtp.gmail.com with ESMTPSA id b1-20020a1709027e0100b001641b2d61d4sm14009820plm.30.2022.06.30.12.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 12:43:00 -0700 (PDT)
Message-ID: <8bbac75c-dd77-6fc9-3755-bd640816fb79@gmail.com>
Date:   Fri, 1 Jul 2022 07:42:56 +1200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to
 DMA API
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
 <20220629011638.21783-3-schmitzmic@gmail.com>
 <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com>
 <554d6fa7-01b7-d3c8-a72a-6474e9c5038e@gmail.com>
 <CAMuHMdX0x3nL5fhmv2T01o8=H6Gp1jog_MZt9gjFe2A7YyMAuQ@mail.gmail.com>
 <39114583-9c4a-7b19-54d5-516feb556fac@gmail.com>
 <CAMuHMdVFYNc5TPxqjo-NxOPEpVgJ8SkuB-Mb4curd731Z4NE5Q@mail.gmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
In-Reply-To: <CAMuHMdVFYNc5TPxqjo-NxOPEpVgJ8SkuB-Mb4curd731Z4NE5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert,

On 30/06/22 21:27, Geert Uytterhoeven wrote:
>
>>> Note that you can use it as a bounce buffer, by looking for and marking
>>> free chunks in the zorro_unused_z2ram bitmap.
>> That would be similar to what amiga_chip_alloc() does, right? Any
>> advantages over using chip RAM (faster, perhaps)?
> Yes, Z2RAM is faster, as Amiga custom chip DMA does not steal cycles
> from Z2RAM.

OK, would make sense to use that, but that's well outside scope for this 
series.

Cheers,

     Michael


>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
