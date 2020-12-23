Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FAEC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BC6120760
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 09:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgLWJLt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 04:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgLWJLt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 04:11:49 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4E2C0613D3;
        Wed, 23 Dec 2020 01:11:08 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id b9so21946017ejy.0;
        Wed, 23 Dec 2020 01:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AHWpVX6q+qCh8ODzxkS4UNsn41pmzdeXyK0+HQYdwAQ=;
        b=hQ5zJFDGwR5gnkH8b7qXuqD3qpqmP0KYGHz0TZwd1qPuoT5rYQXyHIqU+0J1imLWQ5
         GtlCdfkCMgBR12tMUuNJU88PJXODRLRc6aLuERuRi9WEluEYrFHPjk6MRt07JQB7sH7Y
         aeThOZ0W8KCwzJqc7rc/L45W9rRwGGQoB4QnxcxYfasqzbYO8/THtIY67kz7BUpoYF3D
         o4VDBcCxiJb1JbONNlPbegdaXAD1izNLmypEAzJi3Mb6s+n6xI+g37UM4o+vMraxqWZm
         iRnsgfkfMBOjoD3PAWj4pTyP8gxOzWb1xeve7sMa/4t/txyuYSXw1Hee91xfuIiW3S3z
         uzrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AHWpVX6q+qCh8ODzxkS4UNsn41pmzdeXyK0+HQYdwAQ=;
        b=UfUxu+U4x4YR2RzpcnRz6IflAT5YJoPdwZ40w1asOpprE5kEtN7xYyD1hl14utHe8l
         JbHTV4C04wAMZyjr4brU1c+hHWaFawo9B0RFxbbhFse+BZuZR7YmCmJSRraN1QLc/BSd
         +Eawb2BKWI8wOL0scOtH5Avg4YsLs5adsEoYOid4Mebo5gi0KVz/qtbS79Hyk8d58ZTM
         6qeUOm3BPX6qwQ20+ie8MGaFnitLAPotZuBdKCIP++vHOnj8q2vLWmLkJAYf6AqW3UWw
         9M+OmxMuGoNLpsEDtcHh5xZTAfD59AckwQANVplYTg40q2eJIHXL3DOx+MFgR1b/PiQg
         ysJA==
X-Gm-Message-State: AOAM533G9oDcWec+P/eJz6T4vohjgt7Z1wMq9PA1BK0yQnpVP51FYbID
        6IV0qbjm6Tk4juUKcEWkV1o=
X-Google-Smtp-Source: ABdhPJyCnRFzifrnB1qIJAII8mzKYvsLHjmIud+i6RMnN4NZ1aHFWnE7wRrsE6PWT+UTLpN3I6wd2Q==
X-Received: by 2002:a17:906:16da:: with SMTP id t26mr23142020ejd.478.1608714667319;
        Wed, 23 Dec 2020 01:11:07 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id k16sm11319781ejd.78.2020.12.23.01.11.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 23 Dec 2020 01:11:06 -0800 (PST)
Message-ID: <8a680bed6a421fe2cfeec6867af966354e38a9c0.camel@gmail.com>
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     Stanley Chu <stanley.chu@mediatek.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 23 Dec 2020 10:11:05 +0100
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
> And assume you come up with a better check,
> you want to add the check everywhere? You must have noticed the fix
> to
> the func ufshcd_clk_gate_enable_store() from Jaegeuk Kim.

Do you mean lock spin_lock_irqsave(hba->host->host_lock, flags)?
It can completely fix race issue, but it is different with here.
ufshcd_clkgate_enable_store() doesn't call ufshcd_hold().
If you want using this lock, we should change ufshcd_hold() and
ufshcd_query_*().

Bean

