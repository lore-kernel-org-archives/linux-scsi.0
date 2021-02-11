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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332A9C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 11:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F006A64E2F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 11:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhBKLe7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 06:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhBKLcF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 06:32:05 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B89C06178A;
        Thu, 11 Feb 2021 03:31:22 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id w1so9478294ejf.11;
        Thu, 11 Feb 2021 03:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/Hxaah1Jm5CLVabs5Fz69D0UE1pYPi/qdy076fMO6d0=;
        b=lvgpVAn4vCZE1M3lZCUCYxso65UtYsRV/i0HyLwZn57fWq976WXkAYsKz+6K3m5fUD
         ckay3B0I3UTeQ1IIlNidtECOByMareer3PfeDEbIUCEtDZljBGQP2CzWZ8/OBzQYWcrp
         NTBaHNU++2hCp7y9esPu2kdm7LPaJgfA6iHDjKjolz4i9lqc+U3VJU+uk1ItoSZ+pVHL
         p79wVtRPhYGm04ICRZR56iG2T7b10+0kzjBjBSSIzgUh1RmjMZFx6vPWc7+d7lW8HWIP
         pKj7TukWVybSbGPOb0V8pUW/6KbFE9pyfGejcEddSYT768ND9KkZtDx5wnr/Un825iQ+
         adTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/Hxaah1Jm5CLVabs5Fz69D0UE1pYPi/qdy076fMO6d0=;
        b=TxM8ZO9kiPSX3iu4J33QhUO2WcCjEXYxXrg9Cmve23SwvTD61UBW9d5mTPnonp+mmd
         Dq9V7Hbot2KJdiGPWZe3FEMWC754Iz+V5SB1w7BqtT6f5C810QnVCQP7wpu5qRUFfknO
         QXNHgLtHybSxoNxM8WLLBRrCsi7+MxW+ZMig2aYFPQY7MIKTwSEjojH2TYm6SktMV1XG
         Pwiyz3dpIpnCGNIB6VkANYcVoHgvq5jq+svZMSMLOAvXPOeic9jeF6iVm63CylouwjRT
         Gvv6dG9YiafmrdUAYjq9qTkGp200jW3Arm0tciFMRGMaN2zvzPvBEOB9CqArHx4mf0Ms
         /lXg==
X-Gm-Message-State: AOAM533t0QTA6C4mj0wSeb0oL8mn39qOsqORKuGlVbtwfQAhvhloolxL
        R1ioHyA0yh40JvEr/hrIod0=
X-Google-Smtp-Source: ABdhPJwag89z1VgS1UgIeycZWYqgNje3pe7gbUyZx8DYXhUwPBo0guw0yjNPXg8MArVPoDJCeFZYxQ==
X-Received: by 2002:a17:906:398c:: with SMTP id h12mr8103902eje.469.1613043080946;
        Thu, 11 Feb 2021 03:31:20 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec65.dynamic.kabel-deutschland.de. [95.91.236.101])
        by smtp.googlemail.com with ESMTPSA id q9sm4116967ejd.113.2021.02.11.03.31.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Feb 2021 03:31:20 -0800 (PST)
Message-ID: <1df17efddf5741b114ff455c6f87925b186e5cbb.camel@gmail.com>
Subject: Re: [PATCH] scsi: ufs: Fix a duplicate dev quirk number
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     alim.akhtar@samsung.com
Date:   Thu, 11 Feb 2021 12:31:20 +0100
In-Reply-To: <20210211104638.292499-1-avri.altman@wdc.com>
References: <20210211104638.292499-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-02-11 at 12:46 +0200, Avri Altman wrote:
> fixes: 2b2bfc8aa519 (scsi: ufs: Introduce a quirk to allow only
> page-aligned sg entries)
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

thanks Avri.

Reviewed-by: Bean Huo <beanhuo@micron.com>

