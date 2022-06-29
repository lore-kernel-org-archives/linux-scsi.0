Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC36CC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 15:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiF2P4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 11:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiF2P4A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 11:56:00 -0400
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B07134;
        Wed, 29 Jun 2022 08:55:21 -0700 (PDT)
Received: by mail-qv1-f50.google.com with SMTP id p31so25424493qvp.5;
        Wed, 29 Jun 2022 08:55:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OEMWl4TCJsTuvIttBxj/Eh5iikDl97HkNRqb1XE+j6I=;
        b=Xg9/YCWcU4HCNPDh3EPOzGHpXtzEi7mpKF5PiPd+SQAPwzbtlALvkbvsmc9gh3JnkU
         jLnSTa8DCeWjOt0+4rrp8p35z7wvofM/Xuc42LfadBRvanAFCKBbfjRT/OFhgF1xVp0h
         zMXM6hwn8kzn9TbUExMnC/YASISp7Ve/1/tOUafQZsUX8zZi+J2wbxXau3oGYD0+t6tk
         Y8jDGNvPM6ObB0w+p2qYf9p/YAhOgSDR/LoCApMMzegNPsm16fpndBOyimK5B+8jAkzC
         FQDrbqBak6kpMZ+djl83yNawQPEwFRqEiElPlPZwP84ZNdg8SmQywc+Wxhnf5Ia8Yhsl
         ODlw==
X-Gm-Message-State: AJIora/wkb2v7+peFgvoV9n88bI2a+9gaPHmIUbHsiN+W9YlewDutTlj
        tNjVi9jawcGZy4xf4sdOOTzorNKXvsEhOQ==
X-Google-Smtp-Source: AGRyM1sGCveBJqtg69EAI42VcwKhljvdWxn1cOFZ2qy6sttieQ1GEAcYwK1JyauHwHWiirbLPXEUiA==
X-Received: by 2002:a05:6214:f65:b0:470:3e5a:e523 with SMTP id iy5-20020a0562140f6500b004703e5ae523mr7348506qvb.128.1656518120104;
        Wed, 29 Jun 2022 08:55:20 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id s11-20020a05622a1a8b00b003196e8eda26sm5667690qtc.69.2022.06.29.08.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 08:55:19 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id i15so28814890ybp.1;
        Wed, 29 Jun 2022 08:55:19 -0700 (PDT)
X-Received: by 2002:a5b:6c1:0:b0:669:a7c3:4c33 with SMTP id
 r1-20020a5b06c1000000b00669a7c34c33mr4124902ybq.543.1656518119387; Wed, 29
 Jun 2022 08:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220629011638.21783-1-schmitzmic@gmail.com> <20220629011638.21783-3-schmitzmic@gmail.com>
 <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com> <554d6fa7-01b7-d3c8-a72a-6474e9c5038e@gmail.com>
In-Reply-To: <554d6fa7-01b7-d3c8-a72a-6474e9c5038e@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 Jun 2022 17:55:07 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX0x3nL5fhmv2T01o8=H6Gp1jog_MZt9gjFe2A7YyMAuQ@mail.gmail.com>
Message-ID: <CAMuHMdX0x3nL5fhmv2T01o8=H6Gp1jog_MZt9gjFe2A7YyMAuQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to
 DMA API
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

On Wed, Jun 29, 2022 at 9:27 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Most users will opt for loading the kernel to a RAM chunk at a higher
> physical address, making the lower chunk unusable (except as chip RAM),
> meaning allocating a bounce buffer within the first 16 MB will most
> likely fail anyway AIUI (but Geert would know that for sure).

Exactly.  On Zorro III-capable machines, Zorro II RAM is not mapped
for general use, but can be used by the z2ram block device.

Note that you can use it as a bounce buffer, by looking for and marking
free chunks in the zorro_unused_z2ram bitmap.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
