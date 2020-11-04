Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9958DC388F7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 08:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DA3321556
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 08:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tm5fT6N6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgKDIob (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 03:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgKDIob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 03:44:31 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6384C0613D3;
        Wed,  4 Nov 2020 00:44:30 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id a10so4376581edt.12;
        Wed, 04 Nov 2020 00:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bBctKzvczeux6BWZZgQsrhXX2Z5+FC8qYBjVK3QSzVI=;
        b=tm5fT6N6paoIDlu61WIrpETJH6CnUWROhYoXMfqrKrrTyNnf1vrMWWzbPVVHwq4v2b
         +14c0FGDFHAWg5SIs0pn8ZNP8vnORlWtxAWyZIuPs9txb0wd9KHvkqcabIrt0t7imUNw
         2qPx9o7lli5THvU+sZIo7W3vVo2/BccWvQ/1thzYZ9emhW6oIyQ34T6fDrxKj/eY0er1
         spTKOQG/trBQTEqIxXvtXn34/r+PGYRoNf4Lp6/xsu2g7uQPGYwWkHWuS7teUKZqKMaB
         /0QVZBxpYPWh1Vwnun+rY82gfshcZA6fa198KqLshQmfE2iNZAD/Si/2Z+VWBY6Ygyvc
         Gk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bBctKzvczeux6BWZZgQsrhXX2Z5+FC8qYBjVK3QSzVI=;
        b=eZf5TK3/h2A28fMPPLkdzLd8z2BuLD3pMTlfkjp7hlN0tZePUZR9VD/Pc3217IRR01
         +szk0bq573EVWR2CVNuEfsQC2v/aIyf1CYJFNuzU/S7J+dRBjxmNZVDqx0gNYO1byWqo
         Iqe6n7pWUGWAOoZYVAXpu2kPOcRmonsAUtkCcX4Xjr/4ES4zkDelLbxC4O2jo8nwPWjM
         l9Rh/Qp3vMFu68VKEx9dMPcVlt3CNHPToRVwq+w4ktPofrTf5zVZT1ny81cKYwcGYCDm
         qj97AZK8OY3ozsZrFG8PvMRlwjOOzKoX+P239aRwdJdTtw4pHx/wuUAs27anGcLiRcNb
         WiiA==
X-Gm-Message-State: AOAM530jcDo2ZVT6n1iw5MvRbJFdBhGOArmm/OkQAv06GltC9zVyeLEP
        yCI05ACQx4w7u9ugrgE9VNw=
X-Google-Smtp-Source: ABdhPJw8oVt0OiCLkME3hNgqWRqT718ku1iiS3h/rVFqEaxUH3yV2PTVbd7OWCyy5SIKwwulTX7/nQ==
X-Received: by 2002:aa7:d787:: with SMTP id s7mr19586948edq.205.1604479469690;
        Wed, 04 Nov 2020 00:44:29 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee22.dynamic.kabel-deutschland.de. [95.91.238.34])
        by smtp.googlemail.com with ESMTPSA id j4sm619495ejs.8.2020.11.04.00.44.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 00:44:29 -0800 (PST)
Message-ID: <73d4aff5c11424cf2f18735804a6cffccba07cad.camel@gmail.com>
Subject: Re: [PATCH V4 2/2] scsi: ufs: Allow an error return value from
 ->device_reset()
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Wed, 04 Nov 2020 09:44:27 +0100
In-Reply-To: <20201103141403.2142-3-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
         <20201103141403.2142-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-11-03 at 16:14 +0200, Adrian Hunter wrote:
> It is simpler for drivers to provide a ->device_reset() callback
> irrespective of whether the GPIO, or firmware interface necessary to
> do the
> reset, is discovered during probe.
> 
> Change ->device_reset() to return an error code.  Drivers that
> provide
> the callback, but do not do the reset operation should return
> -EOPNOTSUPP.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Bean huo <beanhuo@micron.com>


