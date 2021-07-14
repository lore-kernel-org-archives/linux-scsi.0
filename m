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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F0BC12002
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 20:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF5B1613C0
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 20:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhGNUlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 16:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGNUll (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 16:41:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E505CC06175F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 13:38:47 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l4-20020a05600c4f04b0290220f8455631so2245012wmq.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 13:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oOza+3c27xARRe7PtEIyYeQJyWBBSuYs0gMsoyn58X8=;
        b=ciyopdVdk/Udg5los5yUDU9qMh2zsRSKAkD7y2eEsTcT7QnUcwdqwxO/EoIAZa1CbW
         DNNNOvzgKP70DUPjYPjG59qaL2XimZzS6+ZBsUb/Cx4a2qt2Bik8w3TuufPKkHhJXnww
         68HM/zRuFI/82ObGDTnjlN+6IHl3MurM1qyBvhtYlpA2Dr6J99wqEObdQHUcA70KZhyD
         GvY1fOEoTNeTqMb3V/E2OSA4CM9bJJ9/GrMufVfvNe5fGBWDwUf5odXBkyYHwTYKN6KD
         B1bz1PQkbRShAdr7O8hQUvJ8RUgiKeDMrlH2NswZSyi0w9e9f6FxcBOcmQFnng7hHzxD
         VG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oOza+3c27xARRe7PtEIyYeQJyWBBSuYs0gMsoyn58X8=;
        b=Zq+Mpkt/KN6daxd+g1sbckFdpRRuHLbhOKG5IEX6LECUlI2INZ+AIhtto9E3OQNUSp
         mYoMJwlFCs0rnPn2JgQTew1Ea2wsLgNL3hrBZSbhyR+fsbUqoz8ToDXZjADpjXKX+hTd
         rTZJROikOCv0hqA0dInz5HMqBTOUkm+lR9VxLXvRppMJOSLS+IhnZ+Rytmfo5xdimF3I
         xIWYZRaxmdjFbZRAMZ9Odm0CKgVqoP147OH7TbBvPV7jxFTO7/DK0CIgy0f5E7gluInZ
         6n85TXr6bNxRZeb31ZZeuYFTHgV4q/3urofnA8a3w7oO8Sc9uDo5HL7F1zKo1ADdt5Aq
         CJ+A==
X-Gm-Message-State: AOAM530svYntSzRvGn+AgFLCACE5sW3W4y+dm/Gb+sGV6JD/kZ1blqLF
        lSKe3yLEGA3s/zTwK7xfkkM=
X-Google-Smtp-Source: ABdhPJyIq4wrMHCCS2KOp45kuiVodVBfTSHY/Aty1hniwMn79ruTpvAvPpIUzHDpxf7Q7mk+6d8PUw==
X-Received: by 2002:a7b:c5d2:: with SMTP id n18mr6067657wmk.97.1626295126486;
        Wed, 14 Jul 2021 13:38:46 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id s13sm3748727wrm.13.2021.07.14.13.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 13:38:45 -0700 (PDT)
Message-ID: <d88ad4532d2b1931adf533cd08c0af9dedc38c55.camel@gmail.com>
Subject: Re: [PATCH v2 03/19] scsi: ufs: Only include power management code
 if necessary
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Date:   Wed, 14 Jul 2021 22:38:44 +0200
In-Reply-To: <20210709202638.9480-5-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
         <20210709202638.9480-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-07-09 at 13:26 -0700, Bart Van Assche wrote:
> This patch slightly reduces the UFS driver size if built with power
> 
> management support disabled.
> 
> 
> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> 
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> 
> Cc: Can Guo <cang@codeaurora.org>
> 
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

