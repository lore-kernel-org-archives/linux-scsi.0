Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106B7C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 08:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9CE120E65
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 08:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgLWIba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgLWIb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 03:31:29 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3D1C0613D6;
        Wed, 23 Dec 2020 00:30:49 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id d17so21716077ejy.9;
        Wed, 23 Dec 2020 00:30:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WtYexIyhlM9lX5mngNLqPuHefdFfD3uM5BTMUld2bcc=;
        b=mbm1QT+KJePLw8j1NViPPEgVFnTlG7QHzCjaH7cwaw43zHsBrPnl26NsYuV4/KO1OP
         egsSIGsRl3XMEoeUknuGThQUGGfeNBEM5TV3q8qxz2raRAuTpXeTVikfkLO6ENSPo1gQ
         uzae7pCWLIPOlJhXb3G0Jq/dIze7etT3TJA/31lETWgoM4XtLt+oQo5tUemzwZMwqjef
         hZbu/oJtzcu042/eFqQP9EHrWHCt/Hrdd6iR+njuK1qWmOJkp3HfhEhqDEAPYkHZ35Ia
         e07qNGM1YIkT5APV+tBEovpopeh6XAXkH40nW9hjrLhawC/mfNvZOM16PtPLqLqrtj8C
         AwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WtYexIyhlM9lX5mngNLqPuHefdFfD3uM5BTMUld2bcc=;
        b=fM6VuafHop/nN3uu02KgRk+icPeUfTsd+SDU6rc0oy5jyjJNiSlq299P76rdEkXQB2
         eZdEx+wnlS2wB+prRjTbSp4d7dxDGcM7djpD9cXhPMm6c/otnY9Gw4+2LiqC4EAugmgU
         zjGWNKW9pUsyHvP4o8iLEsxyGElsZmzWvTo8XXw2brkQ8Oh+0zIUbaDOe5tN3H0nNeyF
         RdoaT+GMUUf26wlT2phlG9Aa3VX842ZPUr8scQBIEd3m35kdrn15vWSccnQnqcp3IV/q
         jxOMR7SH6/T5eIWSEeYDkCopO5Lt534P6RdWPxKvCP7W8UoK9VIruaIJiRiukdSawSSs
         D1yw==
X-Gm-Message-State: AOAM530O2p1kvbTdezTtapZxBWEPCQNUPVW5CWNacrScPNmAkEs9c6dH
        Ob5FQN8esVekfHczHDGDTVSQmwEJdE0Wpg==
X-Google-Smtp-Source: ABdhPJwSZF6ixpvIm6gsX+1JFIH9IVgJTuAunOdpXPZ3Ar3yfbWZsburaMs7OJyDN85/PkMfeo9MHw==
X-Received: by 2002:a17:906:55d0:: with SMTP id z16mr22986625ejp.466.1608712248053;
        Wed, 23 Dec 2020 00:30:48 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id d6sm11161702ejy.114.2020.12.23.00.30.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Dec 2020 00:30:47 -0800 (PST)
Message-ID: <729eb3500cd89cdad13414f9f867f9f69848712e.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 23 Dec 2020 09:30:46 +0100
In-Reply-To: <862483add1462510b809aee6d3678435@codeaurora.org>
References: <20201215230519.15158-1-huobean@gmail.com>
         <20201215230519.15158-2-huobean@gmail.com>
         <1608617307.14045.3.camel@mtkswgap22>
         <a01cdd4ff6afd2a9166741caed3c2b3d@codeaurora.org>
         <eb4cd8f151c43e5754bb7725bce3e8ee34a49b51.camel@gmail.com>
         <28211d08700d1e4876a9aea342e8fcb79534cd2c.camel@gmail.com>
         <862483add1462510b809aee6d3678435@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-23 at 09:31 +0800, Can Guo wrote:
> First of all, this check is not helping at all, during 
> ufshcd_shutdown(),
> both the link and dev can be active for a moment, so this check is
> not
> helping the race condition.

yes, This checkup doesn't fix race, it is to address your remove of
sysfs nodes in the ufshcd_shutdown().

Bean

