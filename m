Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E455C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5260923340
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLGLSx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 06:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgLGLSx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 06:18:53 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE826C0613D0;
        Mon,  7 Dec 2020 03:18:12 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id cw27so13290559edb.5;
        Mon, 07 Dec 2020 03:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LzuHMjHqXt98AxqLTSyAQqGYo+32ZS7gzfcD3uCXQW4=;
        b=nH0ybEha6h0mKYzN4F5umyS6sby7ByHgwez3MrADauhPUEDAi/eVEnr58E6kfkfLCD
         ZX6EpvQ0OovXbSMoSybu+F5FY2PMD+nkOKqlQzI5p1Dn9L8Mh7vTILMME5LTuJCk5JuL
         CeiGnTZJJjcReRevzasOGNHEjhsSP0LzS8LsKDSrJF0hpZ6J7sLhQFeOu6A1Z6hf96mc
         DePi0De/vBGUH5jYQIDA12biyYzv/H1T96mGOhDlti6t1Bjdi+IFOdvy8HviYrRrdmXW
         4/HHfi0odQKbXaIoPdv/zNcNkW+xZ9uAg9vWpedGcfPhfxMF+yRwy7KMVFTnnKN74I4t
         5bOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LzuHMjHqXt98AxqLTSyAQqGYo+32ZS7gzfcD3uCXQW4=;
        b=o6JXFs36l5PdxU+BWQDIO35W/qXE8+TIoki0k6BUGg6z7OFULSnz3nC93v4eVNDDhG
         dM9xxhUYf2D2zajiqVYuYmWyJkFphlVrq/uN8E5t8qf225OQ9kxMoQLIkQKKayw1aaMt
         JygEKyyZFa5mDI/Zuq/PGLqTm/u+XhBqK2FIje9aPtVW9zrhs6Q3U3sKiBAGkkWTcu1Q
         T5aaQLKHSz3uOmJPhtkeMz7muFszx8LHTsXSCb47JLkC02vSamKSKt+SZt4+eyZYouCP
         eWwNwajvfy0Gq64E1xL0HVGMzynilEmVFg7Tw6sk6C2zXUGHRXVFneq9O/2NzYiD3YM7
         3naA==
X-Gm-Message-State: AOAM532kUyJeX6jfZ0OCMGuJhYMWbhpZQ2Y6G1K1GUN0RUG4GsQExfqW
        j+GhYeQWgpueps6TYnxhhp4=
X-Google-Smtp-Source: ABdhPJzl+PN+VkJLuyn63SQwtZ1OPssyI9WwqBcUHgDh9IZW4ri99HI4fxdqY9W5GXUBbjc68zEtQQ==
X-Received: by 2002:a05:6402:1a54:: with SMTP id bf20mr3385270edb.65.1607339891647;
        Mon, 07 Dec 2020 03:18:11 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id z9sm12090123eju.123.2020.12.07.03.18.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Dec 2020 03:18:11 -0800 (PST)
Message-ID: <2ef12e328ecdc411e7d145a331d7c8ce668bf2be.camel@gmail.com>
Subject: Re: [PATCH v2 2/3] scsi: ufs: Keep device active mode only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Mon, 07 Dec 2020 12:18:10 +0100
In-Reply-To: <DM6PR04MB6575AED736BE44CA8D4B8998FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206101335.3418-1-huobean@gmail.com>
         <20201206101335.3418-3-huobean@gmail.com>
         <DM6PR04MB6575AED736BE44CA8D4B8998FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-07 at 08:02 +0000, Avri Altman wrote:
> > According to the JEDEC UFS 3.1 Spec, If
> > fWriteBoosterBufferFlushDuringHibernate
> > is set to one, the device flushes the WriteBooster Buffer data
> > automatically
> > whenever the link enters the hibernate (HIBERN8) state. While the
> > flushing
> > operation is in progress, the device should be kept in Active power
> > mode.
> > Currently, we set this flag during the UFSHCD probe stage, but we
> > didn't deal
> > with its programming failure. Even this failure is less likely to
> > occur, but
> > still it is possible.
> > This patch is to add checkup of
> > fWriteBoosterBufferFlushDuringHibernate
> > setting,
> > keep the device as "active power mode" only when this flag be
> > successfully
> > set
> > to 1.
> > 
> > Fixes: 51dd905bd2f6 ("scsi: ufs: Fix WriteBooster flush during
> > runtime
> > suspend")
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> 
> You've added the fixes tag,

yes,it is a bug.

>  but my previous comment is still unanswered:
> you are adding protection to a single device management command.
> Why this command in particular? 
> What makes it so special that it needs this extra care?
> 

see the Spec: 
"
If fWriteBoosterBufferFlushDuringHibernate is set to one, the device
flushes the WriteBooster Buffer data automatically whenever the link
enters the hibernate (HIBERN8) state.

The device shall stop the flushing operation if
fWriteBoosterBufferFlushDuringHibernate are set to zero.
....

"
If fWriteBoosterBufferFlushDuringHibernate ==0, device will not flush
WB, even if you keep device as "active mode" and LINK in hibernate
state.

Bean
Thanks,


