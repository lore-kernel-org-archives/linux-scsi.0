Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D6EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 12:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8BB224B1
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 12:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgLXMC2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 07:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgLXMC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 07:02:27 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8EEC061794;
        Thu, 24 Dec 2020 04:01:47 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cw27so1957686edb.5;
        Thu, 24 Dec 2020 04:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzsn8Vxs757yl7BHdUzFyubVzeoZHsr9IiDUX1zD8zc=;
        b=FpJp+IlhsmMdNnsUqF8aI4pdK4FqwjQh3HB1yyOQIt5Oo0ZFqETQgxAIFM75ALPYTC
         FvCI6KxRazcUKJc4c7WkI8DPN6DB+hJJdNJCddYF72hMQSFIuqNK9O62j7zRLj80BCLH
         ozLQeLNCX9wiChonQ+oaCk5T8vEUXITckpEqLJ951854ggOsigYdJXWWbrV6C9pJ1Emn
         g8WMns50PjTT0KBOneP7R7ulTEJccOt3fC93pewVXTJbouAgu/g/A/fUDnjLFXhbpYJo
         2f5QQJa1ZuZLmzOFiMSNNIRfnsj39mZ7NuL1eui6Z2dfv/0vNVm96mrM8eF9z0hzBimw
         YSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzsn8Vxs757yl7BHdUzFyubVzeoZHsr9IiDUX1zD8zc=;
        b=Uoi9j0qzgoCgWv0rpuydv21PPTBsw48CSEIhHZ+4MWe4xoFWzCLkf4weZ2dbIZ8ReP
         G8juTr637ZqpJGRSVTUWpZzgZz+kZYrfmwV9+BLbIz71PBydT883vWeKlRyPP8AE1SUy
         fB2ZeCHK1MR8wKD6QSBSeNlA66uUaSFP8GsMqB7DDIGActYzN9ANG4j2hRVIG0kAwQ/8
         OQrWTvZfcVs6qXOgf5MIEZH0Ly210xshDOtBfv5O1xWi8mXeFssPtRTYc3glRSyOUf4Z
         6ifGsEB1pYfXBYGODCb1/pp7qnC56wINpbJHEFxrcolr2do7T/T1/7VEoxpzeKzbC4rZ
         uCaQ==
X-Gm-Message-State: AOAM533TncwtbVBTfeYOVLqkRc1y0oJVdVQVAu+2VD3AZOd3ugi9C4ot
        oDzZLbG66/c9/6WKbAaqKII=
X-Google-Smtp-Source: ABdhPJxLczptfWF++SxwxaJX138UWcvlI/ti2uNMxZ4xxghDoEqg027sexvcopSPGShyw+hEBUxv+w==
X-Received: by 2002:aa7:c2d8:: with SMTP id m24mr28190070edp.300.1608811306048;
        Thu, 24 Dec 2020 04:01:46 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id i13sm22800403edu.22.2020.12.24.04.01.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Dec 2020 04:01:45 -0800 (PST)
Message-ID: <5eb12622222bd9ba5e705801a204f3160ba3966b.camel@gmail.com>
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
Date:   Thu, 24 Dec 2020 13:01:43 +0100
In-Reply-To: <DM6PR04MB6575D0DD2C04692AEF771494FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
         <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
         <1608697172.14045.5.camel@mtkswgap22>
         <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
         <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
         <1608796334.14045.21.camel@mtkswgap22>
         <DM6PR04MB6575D0DD2C04692AEF771494FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-24 at 11:03 +0000, Avri Altman wrote:
> > > Do you see any substantial benefit of having
> > > fWriteBoosterBufferFlushEn
> > > disabled?
> > 
> > 1. The definition of fWriteBoosterBufferFlushEn is that host allows
> > device to do flush in anytime after fWriteBoosterBufferFlushEn is
> > set as
> > on. This is not what we want.
> > 
> > Just Like BKOP, We do not want flush happening beyond host's
> > expected
> > timing that device performance may be "randomly" dropped.
> 
> Explicit flush takes place only when the device is idle:
> if fWriteBoosterBufferFlushEn is set, the device is idle, and before
> h8 received.
> If a request arrives, the flush operation should be halted.
> So no performance degradation is expected. 

Hi Stanley

Avri's comment is correct, fWriteBoosterBufferFlushEn==1, device will
flush only when it is in idle, once there is new incoming request, the
flush will be suspended. You should be very careful when you want to
skip this stetting of this flag.

Bean

