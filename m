Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6FAC6FA8F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 18:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbjH3SiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242294AbjH3HwT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2023 03:52:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C019C12D;
        Wed, 30 Aug 2023 00:52:16 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1c0c6d4d650so41550665ad.0;
        Wed, 30 Aug 2023 00:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693381936; x=1693986736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTX3Lx7+PX0ytopG3z19Vhc/qw7Mn3Qfeg0mDBlt8ZE=;
        b=DsgewdZz6kJikm5ycudx4PauNd/3IqsslTznftlUAplnzX+ECkjNTNgH2L/swmfVxD
         od6jY99awebFvSDqQVoLZcuRt2zWAyoqX82nnEvdI3ay2nBvEg+Ch4SLJaQdRz1iXE3A
         D26Vhz9KoMbVizglPLzC3B8cVw0ILd67gwg51QWTkalkdDOvfBvuvStwKVI9ujQBXgOr
         4X1r+42MOrpfr/AA1aed05JyQKWWuc2FiZzfMcFwPxP2ttqvyFLKRwMLvQcb9UcjtMBQ
         7HtNnX18PZQKcRZF65mBVguk2LcJ5j97mssiDbIZBe+7Otvfi22W18vbcfCMOb6hpXLg
         WwXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693381936; x=1693986736;
        h=content-transfer-encoding:in-reply-to:mime-version:user-agent:date
         :message-id:from:cc:references:to:subject:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XTX3Lx7+PX0ytopG3z19Vhc/qw7Mn3Qfeg0mDBlt8ZE=;
        b=fOLWQSG7HwtXL12wfoWLm32juTrXCX6sZR337ff+v5jNfiaL8dDEbEEwpj3olQq+i3
         IiK7Q1lwCvuJh5sEr1FjTgUT6DheBunDeF57U2aUrFSaMU6LK2LolpgKM2x+/HFLs4q7
         xQcXchAJyn/FNW1gN8orpzwGaROOeLnQ8OqQYfYnJ4A7JxOVUEsK9gFp9QH8xezq+8Bz
         1ee+PcebMNbs6anIG4y9xw7SOCr8E4avPuAC7h3ukGWbdY2bb5wIBs27Zb6Lp+bntkn/
         T5h1P2zem3fclIb8sRSPd/MrrfBJcGosWoxGv7X+/0Zj8WR2rwE1NOrmmnqk6Fe82oJZ
         JF/A==
X-Gm-Message-State: AOJu0YzRlvFvUv55CudEXYKdOzIS7nPUbz5c534701a4DB3NRahCaFq/
        tUM5uQPQpBBm6Xgkjjtx37LcKHlhFPo=
X-Google-Smtp-Source: AGHT+IFIXxpvzcf2OM8MkqNkmkUIfW4fd7TzDUgWlO1sxkPeB58yZIh+PdWue0wKWJrFt6pLEE9zOw==
X-Received: by 2002:a17:902:ce8f:b0:1b8:aee8:a21c with SMTP id f15-20020a170902ce8f00b001b8aee8a21cmr1795151plg.31.1693381935764;
        Wed, 30 Aug 2023 00:52:15 -0700 (PDT)
Received: from [10.1.1.24] (125-236-136-221-fibre.sparkbb.co.nz. [125.236.136.221])
        by smtp.gmail.com with ESMTPSA id z11-20020a170903018b00b001b89b7e208fsm10569639plg.88.2023.08.30.00.52.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Aug 2023 00:52:15 -0700 (PDT)
Subject: Re: [PATCH] scsi: gvp11: add module parameter for DMA transfer bit
 mask
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20230829214517.14448-1-schmitzmic@gmail.com>
 <4a7d0dda-c24f-4875-892f-c8c5ef700882@app.fastmail.com>
 <ab78a254-ee6a-a2f1-c3cd-3b608e0c9e60@gmail.com>
 <CAMuHMdU-VmQcH+envdwFpRmMF2RpdZb3FE60u1RPROXwWzsbMw@mail.gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <b4e22628-9e5f-c635-93a2-7b24d546afed@gmail.com>
Date:   Wed, 30 Aug 2023 19:52:09 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU-VmQcH+envdwFpRmMF2RpdZb3FE60u1RPROXwWzsbMw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert

Am 30.08.2023 um 19:32 schrieb Geert Uytterhoeven:
> Hi Michael,
>
> On Wed, Aug 30, 2023 at 12:26 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> On 30/08/23 10:05, Arnd Bergmann wrote:
>>> On Tue, Aug 29, 2023, at 17:45, Michael Schmitz wrote:
>>>> SCSI boards on Amiga. There now is no way to set a non-default
>>>> DMA mask on these boards.
>>> It might help to mention here in which cases the default mask
>>> is actually wrong.
>>
>> All I have is:
>>
>> Probably it's needed on A2000 with an accelerator card and GVP II SCSI,
>> to prevent DMA to RAM banks that do not support fast DMA cycles.
>>
>> from Geert's reply. I can add that. It just did sound a shade
>> speculative...
>
> Apparently gvp11_setup() became unused in 2.3.13pre2 (in 1999), when all
> *_setup() functions were removed from init/main.c, and some of them were
> reimplemented using __setup() in the driver sources where they belonged.

But that wasn't done for gvp11_setup() ...

>>>> +module_param(gvp11_xfer_mask,  int, 0444);
>>>> +MODULE_PARM_DESC(gvp11_xfer_mask, "DMA mask (0xff000000 == 24 bit DMA)");
>>>> +
>>> I think the comment is the wrong way round, it should be
>>> 0x00ffffff in this case, which also matches the default
>>> mask for ZORRO_PROD_GVP_SERIES_II, in the match table:
>>>
>>> static struct zorro_device_id gvp11_zorro_tbl[] = {
>>>          { ZORRO_PROD_GVP_COMBO_030_R3_SCSI,     ~0x00ffffff },
>>>          { ZORRO_PROD_GVP_SERIES_II,             ~0x00ffffff },
>>>          { ZORRO_PROD_GVP_GFORCE_030_SCSI,       ~0x01ffffff },
>>>          { ZORRO_PROD_GVP_A530_SCSI,             ~0x01ffffff },
>>>          { ZORRO_PROD_GVP_COMBO_030_R4_SCSI,     ~0x01ffffff },
>>>          { ZORRO_PROD_GVP_A1291,                 ~0x07ffffff },
>>>          { ZORRO_PROD_GVP_GFORCE_040_SCSI_1,     ~0x07ffffff },
>>>          { 0 }
>>> };
>
> The default masks above were added (in some other form) in 2.1.91pre1
> (in 1998).  Before, people had to use gvp11_setup() to do that.

... because gvp11_setup() was already obsolete.

Thanks for dredging up that bit of history!

> So I think it is safe to assume there is no longer a need to configure
> this manually.

I'll take your word for that. No need to apply this patch, then!

(Apologies for the noise, Arnd ...)

Cheers,

	Michael




> Gr{oetje,eeting}s,
>
>                         Geert
>
