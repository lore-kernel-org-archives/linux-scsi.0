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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F31C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 10:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2824B64DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 10:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhA1K25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 05:28:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhA1K2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 05:28:53 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE264C061573;
        Thu, 28 Jan 2021 02:28:12 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id c2so5953078edr.11;
        Thu, 28 Jan 2021 02:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jQ5Hlu/ZfdYUm4Mstk8XMC0psWWUDqeKF2vH90g7FI0=;
        b=sm8mLVrrlk3rdtTrwvsW4NGujP3HAlJZlmofB65pxL5iNBh8s/6G2gfxIIjIR9/fzn
         8X6rkeR0NP3Redik3XApoPkjp+1aWf/gmecBUxOvjLqNQ7RLxumhKUhtsqZVuhJ66Bg2
         klCWRlh0QtlkeXa3LnmHlGOiKj0yMvNJF4wWBzlq+9PPMAnfh5m2dOBJC4SwVsesyCfE
         JukSQpf/QCjpQFzZAK/7mz6v9h6RwgrUaC1JVxSuO9eh9AymygsGMqLcPrfNMAAsuzey
         QB2K6T4g023tUEzzG7yCyll3l+ZRKsetJx6YIohdMB5wXzV9QFoJ9Y+KkJnU1Usnzo5U
         /XxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jQ5Hlu/ZfdYUm4Mstk8XMC0psWWUDqeKF2vH90g7FI0=;
        b=FiBAXp7jfsJEVbFR37j2P+obuAwoffxm4ULoB4nihLQy/HkxXa2MHc7+DFvQ6WX/6j
         y7q1WTljJ06ZUSrkajcyHt9pEXPTmrk9IG34FSS4CdFi+UkJ3qhh4RQu85klskRfOHxL
         3QpK4gdH542qPkc8U6bEOBJkfurKCnQKmN63+KTzwK6ma/Q0NK5uT+Ntc35xtk+4sdUG
         9t4OFPm530BeLWe9C9+micjT11TwcnTjcSZHteK5in22s7z9iWMfnTcnbStFhKCXoNxp
         fZ0pN6gYWzs3vzbnaUBtlVk0TWjlOY5LcdEUK8Z1OkoFkhVWi9C6K1Sei8tWVNoBEYAi
         /1Bg==
X-Gm-Message-State: AOAM533GPHE9dEPyI/rdjjH3agVvcINFlRuxhkX5aAcSZSEbhOY2AwGD
        EdsVYm5uG/7G5m0kNULFW8Cb2ssFvFg=
X-Google-Smtp-Source: ABdhPJypo1mcpMMpDB4PqZKFmSy/mCBuuqGMWZhFqSfRu0ZmlaavYLQoxiSuoBENI6C97sV3WkXjLA==
X-Received: by 2002:a50:f288:: with SMTP id f8mr13159540edm.388.1611829691430;
        Thu, 28 Jan 2021 02:28:11 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id l1sm2054762eje.12.2021.01.28.02.28.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Jan 2021 02:28:10 -0800 (PST)
Message-ID: <7436d052ddf9e59cfa7358069d3e0f3a84f89777.camel@gmail.com>
Subject: Re: [PATCH v2] scsi: ufs: Give clk scaling min gear a value
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, jaegeuk@kernel.org,
        asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, bjorn.andersson@linaro.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 28 Jan 2021 11:28:08 +0100
In-Reply-To: <1611802172-37802-1-git-send-email-cang@codeaurora.org>
References: <1611802172-37802-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-01-27 at 18:49 -0800, Can Guo wrote:
> The initialization of clk_scaling.min_gear was removed by mistake.
> This
> change adds it back, otherwise clock scaling down would fail.
> 
> Fixes: 4543d9d78227 ("scsi: ufs: Refactor
> ufshcd_init/exit_clk_scaling/gating()")
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>

