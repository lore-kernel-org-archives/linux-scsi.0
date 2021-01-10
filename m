Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA9BC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 12:56:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E5BA23108
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Jan 2021 12:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbhAJM4j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 07:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJM4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 07:56:38 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741DCC061786;
        Sun, 10 Jan 2021 04:55:58 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id dk8so16068855edb.1;
        Sun, 10 Jan 2021 04:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0V57Vb+0sFCgztOz5DR/A3AaU9+g4X59JOpRHevJ9hI=;
        b=iAKddSodN1R98E6GPQKKYujD3Uc1RdzB39Xd/Pv+7Om38YeFrTIBhRslL3Y9bUF5pM
         ABU3g0GDNBgZktDTHwgmeSYRej19FQ+DABVS92Xxx18+Mos5so56KJGwIznf6E2NjKTR
         8pnqDS8GdTqHoxJLuDy4dwo4E4MRbM1fDRyaAiRmo3GbWyM9xRwRuCCxAv9Q5FRTMQnH
         xkmMwZtShkDEd9OBhqIRm5J2rwDTasaIvR5WUvc31yQ5utgZZ0CfO7OKDM2XRpTcIjUd
         d3Spz4yZSf5LuDa46Es1ur0pV8L4UNXzVrAM8Hz3Bb14KJOOyicQCUaW5QEKWMPERH8R
         rK7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0V57Vb+0sFCgztOz5DR/A3AaU9+g4X59JOpRHevJ9hI=;
        b=ubmLw7d7nM52pPIDLuYX2aXX6d5xfxlCLgMd/nDcEzcP/HgR8I61hbgeMXYz47u28n
         qDbk3arILvypjklvfNwhw9Tp1IPvEi9e6LL6dyFLt5Kz2601FrQeb7uoOZG8rDtsPLPQ
         q9EkF1Rs0Pyh6qKvgcAiH8g702aLwudfH/Umh0fFvBt7uEBRMPsuYaX72P8jj6PlZn8B
         nhiD8diLP9tvP8x6hXKW1acGiWAqaiHIW8Lme5zQ6ykrrJ1oGaGDUFe1UuqHKtHjWvZm
         YOm3GnIjxX0fcc/v3j7GDsPOYglQi5TWMo0E6RzzuNCjJ4iv6bQyYf76N19hq7qrSWiD
         msnQ==
X-Gm-Message-State: AOAM530vQdY2EwyveSaXbejCim4nDZQ9Ew6lHE35oVc0Nqh0Z+GtVIv5
        mgl7K2czt/IvaG2HUrq0dhs=
X-Google-Smtp-Source: ABdhPJxT8XMHZEuENZ+U2Bau0+6SL4s2o6LRwqCIXKCDS7iGxYxARhRUUUegcsljecansWsEGR6joA==
X-Received: by 2002:a50:eb97:: with SMTP id y23mr11215202edr.29.1610283357204;
        Sun, 10 Jan 2021 04:55:57 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id f11sm5693447ejd.40.2021.01.10.04.55.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 10 Jan 2021 04:55:56 -0800 (PST)
Message-ID: <d32949dc2f4be9bd0b4912967b2f10af021cc097.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: A tad optimization in query upiu trace
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>
Date:   Sun, 10 Jan 2021 13:55:55 +0100
In-Reply-To: <20210110084618.189371-1-avri.altman@wdc.com>
References: <20210110084618.189371-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-01-10 at 10:46 +0200, Avri Altman wrote:
> Remove a redundant if clause in ufshcd_add_query_upiu_trace.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Looks good to me, thanks.

Reviewed-by: Bean Huo <beanhuo@micron.com>

