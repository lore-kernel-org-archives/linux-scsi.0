Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85608C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 07:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB2160F02
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 07:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234713AbhG2HmM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 03:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbhG2HmL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 03:42:11 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC35C061757
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:42:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n12so5697328wrr.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=qGt+UHsJSEn1D5mL2G7Zb1QSJ2qUYRZBpgqaGJEwg7k=;
        b=NMllJy7buVP/wlyVE34BMYtu2thTMWRzXC5PWhAQIsg509JugqJg4xDsppI+LKxYGw
         0y5XWR+dOcSOxZiTIji8KfjJVybkNgmM0SVXBEUG7o/Fz4qGHHMkf1QKpYqWpKey7kW9
         UQvvya36OscH57LOhNiEdyjbHqnnGGpJXBvRllIArcFFI8K4wgaAbhlUMB7nz0UIzwhx
         iJm8bqpyeFtw0hAzW3Y5mpYMpy7tRZSw0ZK/E+iU9/s3RdYQSPWslcEvPaUiEW0bCwWz
         IKHa3986sMFpC/iZSNrmnG1b/UeCy2MeB/ZgZz8RDIlQZaplDRiKBdCL9tLP/hAJbW5L
         EZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qGt+UHsJSEn1D5mL2G7Zb1QSJ2qUYRZBpgqaGJEwg7k=;
        b=hY4NhzUqcqMUOgLCWc+MmRsD6FfdZY4iP9zsH9YXHsy+5d2kxnsUGZcGjXWgVK6cSC
         OiwCJ4oK9kbgPpClhEUQyMMF03nWs0oKQbK1M62oPXLYUTtntuBJiZGidtdcEZwWg6wY
         jY9OfDOn0u+b1dfl8sFb28DaYmWL3o6M/4qTpg2ll/e/+GSA2hjd0SuA0+e31ltyRsBV
         UueinkJ2DF5JA7xhnyeU3EY9NO3YaE+odw85d92OF7L+v6U58oDmiruOfu7x2Cjgq9OF
         VmcjiIPL+0mjABgC2bvoDy/rzYzUz9ebkn+xVWg9Cenv/7215D8ARHfcASUipfBZlQCl
         7Z4g==
X-Gm-Message-State: AOAM533VMlx7CMa3nbTPUzBni6FYV3Jqduf0yeR2AXai7QkuEc00TMp6
        3P0BFZhXSpgE7MIEkW9iHX0=
X-Google-Smtp-Source: ABdhPJwPCyQJhiYbsHXEDLWV9f/LvqCHMqMhC7PE3Os2DKyeZ2otahVLiAyziuEbNqfOoiwhaT7ZaA==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr3277294wrw.163.1627544527479;
        Thu, 29 Jul 2021 00:42:07 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id p11sm2388900wro.78.2021.07.29.00.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:42:07 -0700 (PDT)
Message-ID: <9e793d9db2f34fd3457ba3f7d1f99a035f2a5f2b.camel@gmail.com>
Subject: Re: [PATCH v3 10/18] scsi: ufs: Inline
 ufshcd_outstanding_req_clear()
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Date:   Thu, 29 Jul 2021 09:42:06 +0200
In-Reply-To: <20210722033439.26550-11-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-11-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Inline ufshcd_outstanding_req_clear() since it only has one caller
> and
> 
> since its body is only one line long.
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

