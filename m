Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39B9C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 22:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98BC123D1F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 22:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388361AbgLIWJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 17:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388292AbgLIWJc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 17:09:32 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A76C0613CF;
        Wed,  9 Dec 2020 14:08:51 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id h16so3306301edt.7;
        Wed, 09 Dec 2020 14:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gTPM8owPg4KHLk7mw/dSVPYEe8lfzBgm5ehHl0CdL3k=;
        b=TUrf/f7C2p1tLXtCa0MBWz0IOriWcbgsJ5mkf/v4ovUrWYfxJ/kgphXXbBUucEnFcD
         n0TRTslG9RXB05aDskvYpZEtWTUIBypRb7UsQLVEKEn5Qrx2Bzstop6YtaNsHbAqIt/I
         5zIpJNloR8pUEm8/DLw6nIUloitsDTOjs9jrgs0Ls4FIo0aFc6Boc1ibc1yjYCsEg90i
         TLe+gPvf01qeNxWjpwi20at5FnO6t8Sys+VN3O8cPt0xZ3PohvLrXtz80JRJwJ5iey6j
         iwnzUEg3f3n3iDeX7pz/TPNOhrPjBsAJlJSUkeCudY0Ziq8FCFPT3wihvaT3l1zgmr3T
         4r7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gTPM8owPg4KHLk7mw/dSVPYEe8lfzBgm5ehHl0CdL3k=;
        b=rwumGhXwj8fZnbfdyIQbQYZ68N1bsf54pjeVMojyREiZHyi7KTwDFTufZG2eRFdX7D
         o07kkZxbeskZsdbSeALutmHsb6qWsqD3EhzMfbo7fxc4HE87YIWAHb6KlDZx2MWqeYzq
         jYMfTRRcLBpwVEO4CxQoUfreNK31HJatfSixvIgQM3ZDjBCWGfhu0GTC9zW3wbHEf3bE
         M4vuUPfEe8PD82esd0X96Gn3y72uGR9wwGDSQnLKEHJAJOtRVUF398xJ2AhoEwhT5QwT
         7hagZWBlD93C8dMTlf4ACJi2a770OaQJ6c9Mfk/Gqr41hzXBZIP/R6j4JkhQauVXVhgF
         aI/Q==
X-Gm-Message-State: AOAM530ErEnbI3EYLd1tYEVKOgfJ8KiJYRdaT1fgQTPMIVqCnCDE0aJ5
        Hcxr44VMxf6B4w+OjQ0ReWY=
X-Google-Smtp-Source: ABdhPJylyY+2dsfkfrSmLw74jj4bZHS11cM+UcXOzQ8Jhv6o5Esrxxb1l03IIZU8f0gWJH8W8wWAbw==
X-Received: by 2002:a50:9e8b:: with SMTP id a11mr3901460edf.276.1607551730377;
        Wed, 09 Dec 2020 14:08:50 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id z10sm2597154ejl.30.2020.12.09.14.08.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Dec 2020 14:08:49 -0800 (PST)
Message-ID: <9fedcb0301c44e03a21bc5deba83c09e1d64b3f4.camel@gmail.com>
Subject: Re: [PATCH v3 2/3] scsi: ufs: Keep device active mode only
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
Date:   Wed, 09 Dec 2020 23:08:48 +0100
In-Reply-To: <DM6PR04MB6575B928898B319E8ACF1395FCCC0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201208210941.2177-1-huobean@gmail.com>
         <20201208210941.2177-3-huobean@gmail.com>
         <DM6PR04MB6575B928898B319E8ACF1395FCCC0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-09 at 07:40 +0000, Avri Altman wrote:
> > From: Bean Huo <beanhuo@micron.com>
> > 
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

Hi, Can and Stanley
Please review this patch, and leave your comments.
or if you look good, leave your review-tag, in order that Martin can
accept this series patch easily.

Thanks,
Bean


