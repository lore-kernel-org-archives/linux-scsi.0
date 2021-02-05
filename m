Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05D7C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AC4964DB2
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBELjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 06:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhBELhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 06:37:08 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB61BC06178C;
        Fri,  5 Feb 2021 03:36:27 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id df22so8497394edb.1;
        Fri, 05 Feb 2021 03:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KvkjREFnB7ZZLsFy2LdQDPIfvthhxo4Mnax/Ejh8xcw=;
        b=cPrqyn/8pAeyh0nCMJQZ34Au7ooPvHq/hid7MG2LTlpfutMLJ0rUegURJVALyXK/gs
         Z6sCi6f6kWyhgLM+h7poEBIxasq3Eoqqz6UU7Mq3y1N9rLjP/Di7t/4aonOteSh5KTtH
         pCw4ataATzH5Xui181yq3guih0VRjyKJENqxxoA4pxG8NVl9aYTIwG4tuYXRjeT8nu5D
         feZ3ZElkTcq6jtGe9A1Itg6FBwNtmqoz5051byq11AEaYrrb1gjBR+Psti9E6TzI6rTk
         Q16AIM73inDrkG/iiCa3iFWX5hNhZnRiWvXBdrr3zM1JQuC3BKLXRRdqZgCISE69ByJO
         hFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KvkjREFnB7ZZLsFy2LdQDPIfvthhxo4Mnax/Ejh8xcw=;
        b=hdegMr0ar5b4srS+T4w7lt9bEFqTmfYoFp7w9MTsE2WSd30eocv5t/P9FKXo/Gpu69
         JwCaXAbPrDfkm2AypmST6riVQJFD2kedOmb589vXmi67Hg6g/EVeKSeoBMJZo95hzigT
         iKDmYH+ZpMu608ImTBTNT3K3doz2pagKbXpi0ADdEV6Uf572LG8OVOWHRXzDdFPPCTgf
         eEZsFkEjNwOd8mgWRaA4RVqfo9eompMQLh8k1hGQCTD0mNQcp72H16wvfijQdKTaADR7
         VuV28P0h2PQBO4m0dbHVLUshAteL96laA6R1ZcoZjIuLKgxHaHHnOfjyfvLaO/MwvDzA
         jnlA==
X-Gm-Message-State: AOAM533tzq0H1U6R8Ta4dDzTNcUDrujrOD4HS4In5vwVIMqbSQSlt73C
        hVZis2EWliO4arW+Yuzz73s=
X-Google-Smtp-Source: ABdhPJzS41x6oeTcfMwdomDx86VuIwl/JxxZgw0/4emNSSSou+tCyDSbXXPNthGpDG/bDmDuJgoU2w==
X-Received: by 2002:a05:6402:3553:: with SMTP id f19mr3099709edd.271.1612524986395;
        Fri, 05 Feb 2021 03:36:26 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id di27sm2002517edb.21.2021.02.05.03.36.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Feb 2021 03:36:25 -0800 (PST)
Message-ID: <ec32248a3e56eef83744cd4844210d347add27d3.camel@gmail.com>
Subject: Re: [PATCH v2 0/9] Add Host control mode to HPB
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com
Date:   Fri, 05 Feb 2021 12:36:24 +0100
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-02-02 at 10:29 +0200, Avri Altman wrote:
> v1 -> v2:
>  - attend Greg's and Daejun's comments
>  - add patch 9 making host mode parameters configurable
>  - rebase on Daejun's v19
> 
> 
> The HPB spec defines 2 control modes - device control mode and host
> control mode. In oppose to device control mode, in which the host
> obey
> to whatever recommendation received from the device - In host control
> mode, the host uses its own algorithms to decide which regions should
> be activated or inactivated.
> 
> We kept the host managed heuristic simple and concise.
> 
> Aside from adding a by-spec functionality, host control mode entails
> some further potential benefits: makes the hpb logic transparent and
> readable, while allow tuning / scaling its various parameters, and
> utilize system-wide info to optimize HPB potential.

Hi Avri
In addition to the above advantage of HPB device mode, would you please
share the performance comparison data with host mode? that will draw
more attention, since you mentioned "you tested on Galaxy S20, and
Xiaomi Mi10 pro", I think you have this kind of data.

Your HPB host driver sits in the ufs driver. Since my HPB host mode
driver is also implemented in the UFS driver layer, I did test my HPB
driver between device mode and host mode. Saw there is an improvement,
but not significant. If you can share your HPB drviver data, that will
be awesome.

Kind regards,
Bean

