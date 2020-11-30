Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E69BAC71155
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952D1206B5
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Or/BD3MP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387555AbgK3S6t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbgK3S6t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 13:58:49 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034AEC0613D3;
        Mon, 30 Nov 2020 10:58:09 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id s13so8480962ejr.1;
        Mon, 30 Nov 2020 10:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K1nwrgwdlgahLE+sT1LepWeqLEeq6rtvc3fqhn9miCI=;
        b=Or/BD3MPUeagR342cBpDuNrFA/E/tWxQ47Pny6vdg0o2Z5ilV8jNv9o+9y/s90ATYC
         XVrNkZdcC+1aNMKSh6uHrfVOHpwd1Dyoh9bYSOLjIrR90S9HdEyIizWw2vQfA97VqjM/
         /683LkIY2/Z3BIA6JYGTC3gLy9WvpoUMS9oKmK64DGhwyGe2+Ty1cUWd5Gv/iQLZV4Hh
         eoG8z9AKQdh3/5qoe0QY6U2MU1/XAWD+g/NDFQySOSyHQx//UjCH0aVBDB0j2r3HEnxK
         tsDlBHhU2WfFLmITHz80B+GMkLwlyNBI8KMGRZujOCQadoY2Spl9q2/yoEioJUN+OLWa
         6Y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K1nwrgwdlgahLE+sT1LepWeqLEeq6rtvc3fqhn9miCI=;
        b=XQ4op9Yn78bkNTebmdCgdFDnviy+UpoCZ8/xfDWNf6upkctv3RJi8l6uk+zEven651
         glTI25tcQnw9tyULbllTmBUNLdfGuvmy3BrggmPvUajTStyGjxw/Gxf8+pDGNSlmN7Ob
         D1qsFD7iwusI51mAL0Lz9rIYUnAV9cGZKckncbq7atYDljNBlQocBrH8u1gkZ6CGwcTp
         rG2zj5LO1hKeW1ZBnb0mRzX8WNXcTBGA39yvlpLO2LdjvwyW8geKcZEBcz7FLV4JayFf
         eHiLmD6wXFYzCtjbJppew9VhyGY7z0ybt5HRT+V09UmansfIGM4SIRlfoi/2iUDR4Ovd
         Lchw==
X-Gm-Message-State: AOAM530CylZ6j+Pdk+q/8ETGbfld84ZKVSkzcXdTOmh9PJPkNwtZxbLZ
        6xTQN78JuJXEx1Cp2cwiqBA=
X-Google-Smtp-Source: ABdhPJy2G3S4C66qaqKoMK2QbTvtEY8xaJZKMGcj5wzhIYQVx51LT3L3sOTPrf6l00OpHX7zCWSLPw==
X-Received: by 2002:a17:906:2798:: with SMTP id j24mr942064ejc.328.1606762687726;
        Mon, 30 Nov 2020 10:58:07 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id dd12sm825263edb.6.2020.11.30.10.58.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Nov 2020 10:58:06 -0800 (PST)
Message-ID: <f11450e55934a2226ffb915c2b90206a524eb47d.camel@gmail.com>
Subject: Re: [PATCH 1/1] scsi: ufs: Remove scale down gear hard code
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Mon, 30 Nov 2020 19:58:05 +0100
In-Reply-To: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
References: <1606442334-22641-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-11-26 at 17:58 -0800, Can Guo wrote:
> Instead of making the scale down gear a hard code, make it a member
> of
> ufs_clk_scaling struct.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

