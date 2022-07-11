Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08612CCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 04:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiGKEQY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 00:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGKEQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 00:16:23 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8092186D2;
        Sun, 10 Jul 2022 21:16:22 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y141so3789387pfb.7;
        Sun, 10 Jul 2022 21:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=iwm4KR+Ov0FEvLj/mmJMHaz72Rm4jmdZepyhwcav7CQ=;
        b=mx9B/20kn0GthfqeVNgtCGX5eH1DSCK/5AErMVenOPYWzacXSQNlYb9Co7EmgStvrs
         Msg9JHV+cxIRX2CMr3zAtf+NOOFQR6wj/UmdNLFC2TpQdHE9INwh6r9HhZB96KnJsCbD
         4rZhUml/qS0JCjXDk6KjX5U8wOgG7CWAhXzjivBACmQMgDJ3uEeyehmSXGU9MaR/CIQg
         SIrXj+jEWjqAktX+l6N3HQ0zZPQ/hujKD1xoZPKwnEHXcA/DEjXmoWGnEWWroVAlOSjr
         pzzluXwtKV6KBoGcLc9JY7ikQorDokj3Lx1JUI+mm9FXQflwdt3vcGYD9XI6kPJMSnOa
         uyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=iwm4KR+Ov0FEvLj/mmJMHaz72Rm4jmdZepyhwcav7CQ=;
        b=Lpr1mOTkZFb8T/cd+ivm/F2BHSNcTkOCDKBKDIdKZ8IIu2M9sJSzOZkhk1Z/FtWO/G
         4ouR1FIIvimjaHi29PDA1Uf0mO65ieBR7EvowvEDeWy/DpnWn9TaVzZ8btrzzc+jDQSw
         SjJXqej2fkjwRsekSYmf9OznMreIHLSfcP6dLRMZcUovhgF5ckyrYXwvqHY7/JJRehTN
         cu5/h8ifx/Pj1xxUp7usd26PZdNFerY8VVh76pNQ9QoZVWGotPWJqv8s7b3MYv9++iXc
         NEKlklXiGX3w2Rti0IPTJx0kdvj7deucc8lBTdf3SJF7bppWgD6uoplju5rDC0wONNHe
         0xgg==
X-Gm-Message-State: AJIora/+kGM4RFI3cRdrZneU9Sk57Mss7xZWh2dObtq5k3N2WBMwhJjI
        Hti/Yg89R4JMkRlT4rzQPOU=
X-Google-Smtp-Source: AGRyM1vWkCeiVRdfrnYjH6FPGdh/5xPTdmYl3q5PSUDA3xpzEej7KZK8Hk+WXoZhlk43M9jx7+f46g==
X-Received: by 2002:a63:141a:0:b0:411:a3b7:bb19 with SMTP id u26-20020a63141a000000b00411a3b7bb19mr14429779pgl.518.1657512982230;
        Sun, 10 Jul 2022 21:16:22 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902650800b0015e8d4eb231sm3532085plk.123.2022.07.10.21.16.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Jul 2022 21:16:21 -0700 (PDT)
Subject: Re: [PATCH v1 1/4] m68k - add MVME147 SCSI base address to
 mvme147hw.h
To:     Arnd Bergmann <arnd@kernel.org>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
 <20220709001019.11149-2-schmitzmic@gmail.com>
 <CAK8P3a2kwg56-UTv275GJ1r_SDsfoX2fMcmXrvNURN+L3UHoSA@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <89f0efa9-9626-2380-49dc-432ac04fe6f2@gmail.com>
Date:   Mon, 11 Jul 2022 16:16:17 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2kwg56-UTv275GJ1r_SDsfoX2fMcmXrvNURN+L3UHoSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arns,

Am 11.07.2022 um 04:06 schrieb Arnd Bergmann:
> On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
>> index e28eb1c0e0bf..fd8c1e4fc7be 100644
>> --- a/arch/m68k/include/asm/mvme147hw.h
>> +++ b/arch/m68k/include/asm/mvme147hw.h
>> @@ -93,6 +93,7 @@ struct pcc_regs {
>>  #define M147_SCC_B_ADDR                0xfffe3000
>>  #define M147_SCC_PCLK          5000000
>>
>> +#define MVME147_SCSI_BASE      0xfffe4000
>
> I think this should be an 'void *__iomem' token, not a plain integer.
> Apparently the driver internally uses a 'volatile void *', but some of
> the other front-ends are already converted to use __iomem.

I'll pass the base address through a platform data struct in the next 
version to address your other concerns. Haven't seen __iomem types used 
in the other drivers - two are Zorro devices, and two platform devices 
(a3000 and sgiwd93). Found no other wd33c93 drivers...

Cheers,

	Michael


>
>         Arnd
>
