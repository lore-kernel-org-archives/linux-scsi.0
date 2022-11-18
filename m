Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5A6C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 05:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbiKRFmm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 00:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiKRFml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 00:42:41 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1B278D68
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 21:42:38 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id s8so6513621lfc.8
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 21:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S1Idlevq+1pR9IxtCs+CXM/bKSijLUs0q/kM+1SG5ps=;
        b=fBKazR34EOd9IlI9Z3uxVpTitXx+sJREyfYAuv/2nS/cJ19yUV2MKRFyD1oEss/1j9
         +MHg0mcaiTi2MMxt7yEXrvDrfD2sCvtsJ1OBYXgBfPpdNGa8yYny06olNgyQQOgcm3QA
         ErUkjqP9drM1I5wv2ZRGA6e4jpqynTCzXRTbpLJbDXHKBx0Mon33tqQM5FqP6FGstFFO
         lidM4GxdjYa3/m2gkZpmccF/f1yyeIiKNjbDxUECXHQ3RaZpEpMmxj6Hq/s4Q1zwFWNb
         0v52SApEvPBlEiWrfE9+zWt1C8fzWrzILBI7de6+7XcmAQgf35hVtXKozazjmz7Tq2kK
         kJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1Idlevq+1pR9IxtCs+CXM/bKSijLUs0q/kM+1SG5ps=;
        b=KWFW6+BgS565C5vYAJY6RAvRL37nVS2L094BhoU18stMSMKluyfGWKQDG8cVG7e6Uu
         8qGZj2/uVIKJPHQJu69u+w6yrmSjOdGgxDUhyVZSqvbeAunf6YEbvEweQjbT52P5hhoa
         u3mEFzQ4kAX9bmEruk0UahlBjb6OozlzA27YbAzMoLKpEfeCNZt1VmrLjpf5vbqrY8X8
         05CNlZBsOn9WflEow2S+DgZX5hMaA7Urtxcc8J49SVZzOQc5BKMqZqnv4RvKK4wO4XGL
         bCczJNVbufJ+xp1B4aHEIMfnjkq/Hw8sSIaddQmnNQfjoFwyI+Fz0UtPmU1iM0qjdgs5
         /PoQ==
X-Gm-Message-State: ANoB5pnZ0YtQvoZxPuwAMYmrArYY10/LH7OmHjlSKu89i0MBc28qFEWq
        TMZbmQRCgsg4fpe6Lm2dUrlKV4EXRQuPD7aSedO8eo1Zn8IK
X-Google-Smtp-Source: AA0mqf6mk3iGB58/qI/27zszWRU2A1nPFyd7t7C79yoW0QG06IVxbpzAHRBvKv9dVGVjPu3C8R88gMBdXmNQnHzYu9Q=
X-Received: by 2002:a19:8c1e:0:b0:4a2:48d6:2181 with SMTP id
 o30-20020a198c1e000000b004a248d62181mr2094023lfd.591.1668750156585; Thu, 17
 Nov 2022 21:42:36 -0800 (PST)
MIME-Version: 1.0
References: <CGME20221118044223epcas1p12eab9a6fb08ec382625b3fb43f401e07@epcas1p1.samsung.com>
 <20221118044136.921-1-cw9316.lee@samsung.com>
In-Reply-To: <20221118044136.921-1-cw9316.lee@samsung.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Fri, 18 Nov 2022 13:42:24 +0800
Message-ID: <CAGaU9a-FVGqeQB+97WGgWaMcFJUtKbsT_N7sWDza=NWkApBK1A@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Remove unneeded code
To:     Chanwoo Lee <cw9316.lee@samsung.com>
Cc:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 18, 2022 at 12:50 PM Chanwoo Lee <cw9316.lee@samsung.com> wrote:
>
> From: ChanWoo Lee <cw9316.lee@samsung.com>
>
> Remove unnecessary if/goto code.
>
> Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
