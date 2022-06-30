Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4030C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 02:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiF3Cpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 22:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3Cpq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 22:45:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0DF1A3B0;
        Wed, 29 Jun 2022 19:45:45 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k14so15799087plh.4;
        Wed, 29 Jun 2022 19:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=Ev4+82itvCxx5jxqraeA1gGNjalXvR8F+/m9LOFF/5A=;
        b=K7ZVgdrrsWcy1yjAW3ycsPtDtqN6ywgqVKRuyDKbJyN4Y+NGrTZv2hQ7J0w0bEelNV
         i+eCFSfRuEweTConB41DSrPNj71Jr2KYkYvx3kOz1Vh4IHopNW6UAc2vNixslsuMm1wJ
         OeYxQQCqM2Eft2uMNS2MwG+k4IRWeMYJAUAy9eEyPv8mZ0w3NN8KP5IB2ENhcqQ94sIv
         rUiIyuxefipyrsszHFoboTh8dqAPYl1cE4Dse0F7k86V/JIgmzZ/G/hZB5RypDeEN6h+
         UswUdrmueOcQ9kRWPl/svKOtRVP088fpizloWAqZMOmR66bHa8HkQv9a6+5iNTWT706O
         7GLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=Ev4+82itvCxx5jxqraeA1gGNjalXvR8F+/m9LOFF/5A=;
        b=CScifvGkfBTTh++KtnQUvOE1SLl5LxQ+IKWCwMzphBEG3Sg0OYjtwkjfs7UwUc7lyn
         B8DxPTZm6w7hNNNVX+M6UW+DJVeMflVsAILeZHOSICTMIkpzDXNfrRFUr5x51emJYQBX
         2a0FEvKcREh0IZgDoe7V1hzFlromqtO2XuAGC2nUeGCl9CkhpXm72UYy4sc74dpx8gKT
         TALP1atW8CAH5kkj4hXZppVdXDPRymOCn1bjoJE0gEaa6xwqCck1maj1bbBNHFLX1V33
         IlUpz++7yadanbA4+bZNMb6/CZ6QQlBA+Zl8rTjbTdvAG85gYe86OfBWwAO/KR3dUsWB
         0dXw==
X-Gm-Message-State: AJIora9igtJqCfZhX7NuQaw6xK8lOEU8RhXVAH0sL/o3LZE6q+O9Q3dE
        oM2BqkAQB5ACJ0UAkzp1WRa8RaFlGjU=
X-Google-Smtp-Source: AGRyM1uZctpSZI6Mw0Axkt0tNBlPH3nv0kVLFwsCnDfKmsDu5NDV3VVpX02f6F5zRs7NTPrSgBqayw==
X-Received: by 2002:a17:90b:4f8c:b0:1ed:243:ba07 with SMTP id qe12-20020a17090b4f8c00b001ed0243ba07mr9110403pjb.89.1656557145026;
        Wed, 29 Jun 2022 19:45:45 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id d4-20020a170902654400b00168aed83c63sm12151164pln.237.2022.06.29.19.45.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2022 19:45:44 -0700 (PDT)
Subject: Re: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
To:     Arnd Bergmann <arnd@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
 <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
 <5e57e1e1-2b06-e58c-9081-3b2cce11b5ce@gmail.com>
 <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
 <CAMuHMdWcZdN6kZ4pHZfybd9qtPbYVtcys+VOUG+HXvX3rPFwjA@mail.gmail.com>
 <CAK8P3a32A9eqQoOm9qyWV_XpQQnKyaEg5ULKyi1ZkDpn1onL5Q@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <299b7b79-c8b9-46b8-8ae5-30ebd38e2c2c@gmail.com>
Date:   Thu, 30 Jun 2022 14:45:38 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a32A9eqQoOm9qyWV_XpQQnKyaEg5ULKyi1ZkDpn1onL5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

Am 30.06.2022 um 04:44 schrieb Arnd Bergmann:
> For simplicity, the normal bounce buffer could similarly use
> dma_alloc_coherent(), which will also result in an uncached
> buffer. If I read this correctly, this will also ensure that the buffer

No sure we can rule out calling dma_setup() in interrupt context.

> is within the DMA mask, so if ZONE_DMA is larger than the mask,
> it just returns NULL and you have to fall back to the chipram
> page, rather than checking the address and freeing the buffer.

Still need to check what ZONE_DMA is set to on Amiga.

Cheers,
	
	Michael

>
>        Arnd
>
