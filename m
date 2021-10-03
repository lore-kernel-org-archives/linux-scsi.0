Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4F4C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93AF061351
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Oct 2021 21:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhJCVMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Oct 2021 17:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbhJCVMu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2021 17:12:50 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A295CC0613EC
        for <linux-scsi@vger.kernel.org>; Sun,  3 Oct 2021 14:11:02 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id r10so10250268wra.12
        for <linux-scsi@vger.kernel.org>; Sun, 03 Oct 2021 14:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=uX5Tb624nsq1lpGntP6v6Y9yblzZK6DN8jG1yFskDAU=;
        b=QkI7XlGbgNxU4Agd7Kq+zmyKawrUyPIT5s1e0AnGymBQr5AprQepVVNosEISDUxaLa
         SgDnjp6oY3+0bShaFK6kTwNFUzxNE0JU9p0upfFJ0JsYjOH4+aJNPSuMxZGg0PWxMoFT
         GG7Lba+MZoh9zYUiXUi/nAMbTV7xaIfrrmt8rYYoFmSS1sU3yM+FbvBRY/YYExM+C9aj
         hih1kr+imSH2QtqGprquS+qqg3ijGQf79sgdgYEk0uxszLj0Aix6HyfYPvZoMfcAIa17
         YoMWHchmkaSCQ6A5ev6wxDIEPswi4qkfXO1oUumHKNmww79djBrQqLqREUVSOOqvBHvU
         NkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uX5Tb624nsq1lpGntP6v6Y9yblzZK6DN8jG1yFskDAU=;
        b=ir+BRevMQhMJ8kkOpb4n4G5Rv6nKobqJLPCDmR8dF95XtXVCxfq3JpfGIegkSdkOlM
         Tj95idDWGlUktC+HKG9u18MQE1C7A7ynG2IvElAP0zSNTGwWNdosZM/HiOcuYe4YQvDe
         9BXNfwuVFcDUuERXheY5nyrxZz7kPlSkURrFPpbl7Q+mnGSUX1NPqZb7WF/4qZf4CXLp
         5kJuoctIRMuOu1asYfQYkysQsHhrlHpF4UF4191cFtPTVy4wz2dc2k67VLWXdeXZWKZb
         aEHXLk4y2jo667XOXoFQFcxX4axLB3Vc246Ccmyy2Um84KfuIS06eEc4gGXW543yBi1p
         JIZw==
X-Gm-Message-State: AOAM530XPa8ZRAoopgY5w1MY8ujM9V3NQAmKk4l+Gi+wLFYwFXrmNC9D
        VpRkB8vlzn6V7lqFjeFdp04=
X-Google-Smtp-Source: ABdhPJwMGX1MEuyYPWgThaR20MBLCUmw1sb5iiPGC28PXO4ospQFxAhq1MTqRj1isKkvRxGJy287kg==
X-Received: by 2002:a5d:58ec:: with SMTP id f12mr10211073wrd.24.1633295461243;
        Sun, 03 Oct 2021 14:11:01 -0700 (PDT)
Received: from p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de (p200300e94717cf648712b27b14e4a39f.dip0.t-ipconnect.de. [2003:e9:4717:cf64:8712:b27b:14e4:a39f])
        by smtp.googlemail.com with ESMTPSA id j27sm14419528wms.6.2021.10.03.14.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 14:11:00 -0700 (PDT)
Message-ID: <0581f83f72f00798aa2f34d82a0dc6f60cfdceeb.camel@gmail.com>
Subject: Re: [PATCH v2 74/84] ufs: Call scsi_done() directly
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Date:   Sun, 03 Oct 2021 23:10:59 +0200
In-Reply-To: <20210929220600.3509089-75-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
         <20210929220600.3509089-75-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-29 at 15:05 -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> 
> scsi_done() directly.
> 
> 
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

