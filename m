Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A17EC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 15:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ABD560FC4
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 15:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhHBPEC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 11:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhHBPEB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 11:04:01 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FCDC06175F
        for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2021 08:03:50 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j2so21794874wrx.9
        for <linux-scsi@vger.kernel.org>; Mon, 02 Aug 2021 08:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=2EFYDDl8VZkAnMxyzTEkCb4yyJCcsCWWBgJV0oww80Y=;
        b=bDs2T+hHqReyg5r7a6lOMnkNHhqRxOutnN+je9iFhvTfYvOnji9P+oO/W+N1WTw5Ue
         gsOexYHHVfZIKTvFN+rh6WhMRfJf940qqLHXXziKXeGt72NpodtoZDm3Skc/rjpVDgLU
         IPV1BPPkh/wcgfuXHGmGSWCn3eLecVRx5kCI6gIltxVgeQZ7RGAUSeKqOiGWBKKZJEqO
         WfB35fJ6gkkTvUslsZtRVqxsNIGqiqd/0a/7rK/F67wOcKmm19dbbLAo4nZLND2oY7NN
         66xGOu5aNooxZ28XLnih1JnfM4GMWwj/CeXGMUBTkTEB6ZvqVcqSfmwCIDMKJRCHWcrg
         0RYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2EFYDDl8VZkAnMxyzTEkCb4yyJCcsCWWBgJV0oww80Y=;
        b=fo9nyDJJzUdDxpKr5ueXsFdf6R4E2wmBDyOgxy8TVmDinNbeQkLWR7hNaqRhpfjejo
         nUSx3vhQsogPtBg8vRkLnyky8J6Ede7u3Pd6Q80X6dxtHfkpllm1J9QJ/wbLcxwuGOyJ
         2xZo9XxmLjCiNJBQ0fZf6tk4n8v2+yz3rqwvqVPtMLJtLGd9x4bLMySYwdUnff9B/nQ/
         Y1DSaqE5EaWyNCiXHv39VCkoE5iSc8QBRGQfiEY03KV47NRa6V3qEKR+L+zR+GmyKTQb
         nlRPvKUlUhVARq3XeOhZOL4rSz0/tOW/TFd1Ngt9HO9FGRK7vTkT5w4aIKW6iE91ros+
         dU5A==
X-Gm-Message-State: AOAM532WDeg1T/YL7UpUelO28sSqFCh8XMbquwgEOR/aifZc1QFg1i5H
        gtVbcx4h/UGBftxOR10QEF0=
X-Google-Smtp-Source: ABdhPJykzWQlGd83bNYA3B07KZW9xRlj0d55r6PEHYjKhAE0Gr9SI0ikVaayr3oVUa1m4RMdKrqHrg==
X-Received: by 2002:a05:6000:136f:: with SMTP id q15mr18268687wrz.148.1627916629442;
        Mon, 02 Aug 2021 08:03:49 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id f3sm11698539wro.30.2021.08.02.08.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:03:49 -0700 (PDT)
Message-ID: <1167666510ec4444bec7cd97ddfe77422268f45b.camel@gmail.com>
Subject: Re: [PATCH v3 18/18] scsi: ufs: Add fault injection support
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Mon, 02 Aug 2021 17:03:48 +0200
In-Reply-To: <20210722033439.26550-19-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-19-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Make it easier to test the UFS error handler and abort handler.
> 
> 
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Bean Huo <beanhuo@micron.com>

