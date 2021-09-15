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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C7EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 08:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E94561209
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 08:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhIOIf7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 04:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236685AbhIOIf6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 04:35:58 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7593C061574;
        Wed, 15 Sep 2021 01:34:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bt14so4465804ejb.3;
        Wed, 15 Sep 2021 01:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=uHx1FBkOZgBu2z6gXW8baJkMa7HzKTTxej9rhTBZe/g=;
        b=EexIG0L9qzdNEIyV51FyZ3OH4qVdDbddJ4e17zaKSkPuwhiy6/R6/SFTNhBRaxMUrC
         nppmNk6nIHmvH78wfqixg5ZZ9y1egDMaL/VXrZLs7pxPbrC9AkkoNpAL8Ff/TVEEyLRo
         WZ2dyqEH6CKjgL1aoj3bFPz1sB/j5r6w3+jGPBsXTPT3umMervBUYrCuCN+rW3bgh2W3
         jMr02Uc0sGBLIvH9dRSQj4b79e38v+lpWBPb8d3VrwOP7oO+Fc13CghPGzFI0rk1AviV
         pm7ASNUFVTGaQFyiPZqURz6ea/dL4HrYCQDT8QL+NkuO2dCy0CWiY8laeX/8KiRszy3e
         GqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uHx1FBkOZgBu2z6gXW8baJkMa7HzKTTxej9rhTBZe/g=;
        b=8PGfLxoWG20uNkKBdkJMANJZNc1aichHZbvJ0N1Lu196XyjAnCrw3pOzQG2RbtIkZj
         cMw1Zsd/xSG42ZlmOAOuhBItYce7qkH5ElYmt60Tt/0iNWW/BAtVc0pupYkaAyiMgGFs
         eEBT5FlBIIo1os4HAwfSSZaeuBuNSNKUDvRGgsh5OH2WnFM/dVSpd71YTUrgEjS55wpM
         mAbJeAgU2Eh4A7TriHEAor/FaOwfrSERNyLPjna1tqD0Y9wGWrcZPJfkFWvpIYnOGRmy
         tyvyXl8ZyrcOcEJCL0jbjXRG7RWfL7RYPt3zqjkHLWf15VYbCubQ9mOlWCqVSEBZSnSx
         psuw==
X-Gm-Message-State: AOAM530d+NJfvw1CE4Hz8wBoYTBCf2C7rTXAPmYGczijgE6D7fPtTg6g
        J2zOV8+CtWsG4HtXWx4HY6Y=
X-Google-Smtp-Source: ABdhPJy3ZGlA2nSXGxfZZtRX76XZ5iaXLdbkwh5CLZEj+3P122VnK0f2huyCYcETEhZz7Qn4kfRv9w==
X-Received: by 2002:a17:907:2717:: with SMTP id w23mr23854696ejk.283.1631694878558;
        Wed, 15 Sep 2021 01:34:38 -0700 (PDT)
Received: from ubuntu-laptop ([165.225.203.49])
        by smtp.googlemail.com with ESMTPSA id r2sm6804859edv.78.2021.09.15.01.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 01:34:38 -0700 (PDT)
Message-ID: <517b6249f64c938193d88c729c44e07a736c6d79.camel@gmail.com>
Subject: Re: [PATCH v7 1/2] scsi: ufs: Probe for temperature notification
 support
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>
Date:   Wed, 15 Sep 2021 10:34:36 +0200
In-Reply-To: <20210915060407.40-2-avri.altman@wdc.com>
References: <20210915060407.40-1-avri.altman@wdc.com>
         <20210915060407.40-2-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-09-15 at 09:04 +0300, Avri Altman wrote:
> Probe the dExtendedUFSFeaturesSupport register for the device's
> 
> temperature notification support, and if supported, add a hw monitor
> 
> device.
> 
> 
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Thanks!

Reviewed-by: Bean Huo <beanhuo@micron.com>

