Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419DDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 20:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351785AbiCOUnV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 16:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351780AbiCOUnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 16:43:20 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF88159398
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 13:42:07 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 195so249123iou.0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 13:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=3LYA3F2vS7/qRcuHKgfo+jK9meyWqLhonxVb0i4Hx5E=;
        b=JeaFSWMAHkn88CJQ7Mt1LcJQgY6H3z7RzwGpe0n8y3L0NI06u9lVkivHPoeAw0zRmZ
         K2qGAtbPX8jksaz032oREYbw/0yMTOWJhCv2Or9dsjzcHDEVojzLbdykPuNgiqjKwMni
         B5OCnDwbIszh/wytrjATI/83XWdwSWil+C/TGz27DNTT/v9TUDHl4qNC7+9tkisJI9ao
         KtIYrS0WF5D7th0tM1ik+R3w1SV00MX9jDR9O8GENmNV1Bq5JIr6CQU93gUQGVQuynrf
         aJMq10vY9CPJfe4rDbeT+Q2Y36j2zYZBvWPNct8SlYtiSSs1WsUUsm8RJy+MUE3WUYQQ
         P+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=3LYA3F2vS7/qRcuHKgfo+jK9meyWqLhonxVb0i4Hx5E=;
        b=b7u+tbTsimNIO3kK37C+UxQpOoCWWm2egMh+nozlZ/iWaCjQSrO9TwrYDCSGYf7+mq
         TRHCpD1wxOU6vQpYRIGCIfVR7UojFYp1w98fgcN3j2dU9gs6ap2OvPZbzSPR31ci0AQm
         UBGwL8I+yLUA9eChsz83BnmN+NZCKt75Dtu2ZELljW9fl3eRD4k118JQ01EwApTEGrPl
         55pmQO0umkdzJMcRG/AhZDQHklFCDdQwPmztbFL+enkaD8VRwW5SYq1zqZf9HXWk3Dbj
         ErG68iaalw5Uv2OyZgKTrn9m9xrzkNv/l+h45kVOAszAd96y5RgLI0+CjJPruVkulc7c
         jaCA==
X-Gm-Message-State: AOAM532FrP9kIXLneAd4ogf8zo0tiokkuuYnLG1sQYl+twHGHMw1L5X3
        0/VdZcu4HRMsDeHloF7Bx10OkQ==
X-Google-Smtp-Source: ABdhPJxyYA1foZ099T/TN7q5N1/aFnC/sZVxSPSTvM5nF2IoFH3QbFH+2gatQLGEz+Ob6ehjUf8AyQ==
X-Received: by 2002:a05:6638:259:b0:319:e237:b6f9 with SMTP id w25-20020a056638025900b00319e237b6f9mr16110035jaq.186.1647376927106;
        Tue, 15 Mar 2022 13:42:07 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k5-20020a5d97c5000000b006412c791f90sm10260598ios.31.2022.03.15.13.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 13:42:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org
In-Reply-To: <20220314150321.17720-1-lukas.bulwahn@gmail.com>
References: <20220314150321.17720-1-lukas.bulwahn@gmail.com>
Subject: Re: [PATCH] sr: simplify the local variable initialization in sr_block_open()
Message-Id: <164737692606.34720.13651107602467649811.b4-ty@kernel.dk>
Date:   Tue, 15 Mar 2022 14:42:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 14 Mar 2022 16:03:21 +0100, Lukas Bulwahn wrote:
> Commit 01d0c698536f ("sr: implement ->free_disk to simplify refcounting")
> refactored sr_block_open(), initialized one variable with a duplicate
> assignment (probably an unintended copy & paste duplication) and turned one
> error case into an early return, which makes the initialization of the
> return variable needless.
> 
> So, simplify the local variable initialization in sr_block_open() to make
> the code a bit more clear.
> 
> [...]

Applied, thanks!

[1/1] sr: simplify the local variable initialization in sr_block_open()
      commit: 79d45f57a19537a1ec6ebf836944e968b154f86e

Best regards,
-- 
Jens Axboe


