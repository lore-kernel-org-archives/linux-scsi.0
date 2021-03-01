Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1980C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 20:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B980601FC
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 20:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243296AbhCAUtY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 15:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243673AbhCAUrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 15:47:25 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B15BC061756;
        Mon,  1 Mar 2021 12:46:42 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bm21so12002123ejb.4;
        Mon, 01 Mar 2021 12:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dBubGKWvVT6jxU0D8dAJXoL1TxNJII6GdSK8b9P2cGw=;
        b=O43vI0XbSOcLK7LCpa2xESi/DhxuVSF6X0xrpx5QtrKuw09QG/ULrngA0moUUM50EW
         dsVcvdhcBNEODUkSfCEAcb+ePrIUAqidwnws266NXscvDOZBVtsbAFtfOiI3ZEl+TKTY
         LokJcBgRsixH/IZW748zVgH2hGlGoiG8Q4L34NUSWfd6tRMWktG/ZGKXNwgfIzuIYCHY
         DWhK2OpQzj6ILCngYgdVp+DttM3jmgnCBzc3Pjm6rTn3Uo+aVCeLRlTiYCM8ndosUIY3
         aQtJ0IV0Vfjv9t2MQ3EmoVj0D9n3jmbqbiJ/5diGcBQzi+VQsphJZtiayVoguvlmDrTG
         sc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dBubGKWvVT6jxU0D8dAJXoL1TxNJII6GdSK8b9P2cGw=;
        b=FDBwSkotSAHRXUjWHpcGQi1FN7FlI1Kcdpy2oQEqBwbQtS8Ee4N3wEMiu0vDqkFjtR
         wcBKVbT+RL+YWP7ZZy1o9F/XdXdBJx97fVKni4mXxdOadt8jHf1b23R3ew1CskJxPst6
         ho3mYsZS0EyKrGKH0x8PQTcvvO+iEV++kGWd1pWYewaTRqMXBQq4AiTSmBM9Qql8cCYh
         dTrRD87RP0ofIHMBrsGLCq4q8UGMI+E9CLvQF4nmHRMiDwmN6qwvJzUK52ohYDv3nlvM
         UqDgNc5080JK1oKoddtzk3K9o+0fGIcscGKZj5ayPMo8GWXeBZnwvIDUPsvUtZG4IWVC
         IAcQ==
X-Gm-Message-State: AOAM530Fp95AFS2ms1+HUiqbLaVHJcpK25a/H6eSwLEl4EC7SKGGbOel
        t7Fn0olthTqVEcVu3o1kn2g=
X-Google-Smtp-Source: ABdhPJySq9BsbmoAmeDGJ4uOOSP1hh/GX2gpKbucpK+YQgJF7RRKdl8pSV9o+hF7WFiSD5u4ldpDOw==
X-Received: by 2002:a17:906:1a44:: with SMTP id j4mr18094458ejf.401.1614631601276;
        Mon, 01 Mar 2021 12:46:41 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec1d.dynamic.kabel-deutschland.de. [95.91.236.29])
        by smtp.googlemail.com with ESMTPSA id dc20sm15248811ejb.103.2021.03.01.12.46.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Mar 2021 12:46:41 -0800 (PST)
Message-ID: <abbf014dfa28f3a8690c14a0ffad32ce24fa35aa.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Fix incorrect ufshcd_state after
 ufshcd_reset_and_restore()
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Mon, 01 Mar 2021 21:46:40 +0100
In-Reply-To: <20210301191940.15247-1-adrian.hunter@intel.com>
References: <20210301191940.15247-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-03-01 at 21:19 +0200, Adrian Hunter wrote:
> If ufshcd_probe_hba() fails it sets ufshcd_state to
> UFSHCD_STATE_ERROR,
> however, if it is called again, as it is within a loop in
> ufshcd_reset_and_restore(), and succeeds, then it will not set the
> state
> back to UFSHCD_STATE_OPERATIONAL unless the state was
> UFSHCD_STATE_RESET.
> 
> That can result in the state being UFSHCD_STATE_ERROR even though
> ufshcd_reset_and_restore() is successful and returns zero.
> 
> Fix by initializing the state to UFSHCD_STATE_RESET in the start of
> each
> loop in ufshcd_reset_and_restore().  If there is an error,
> ufshcd_reset_and_restore() will change the state to
> UFSHCD_STATE_ERROR,
> otherwise ufshcd_probe_hba() will have set the state appropriately.
> 
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and
> other error recovery paths")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

We used to directly set hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL at
the beginning of ufshcd_probe_hba(), and didn't have checkup if (hba-
>ufshcd_state == UFSHCD_STATE_RESET). Remove this checkup, also works,
but in This loop, it it better that, before going to reset flow,
ufshcd_state should be set UFSHCD_STATE_RESET.


Reviewed-by: Bean Huo <beanhuo@micron.com>

