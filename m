Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1B9C7EE2A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjFEJqB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjFEJqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:46:00 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E33FD2;
        Mon,  5 Jun 2023 02:45:59 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b1b72dc2feso29057451fa.3;
        Mon, 05 Jun 2023 02:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685958357; x=1688550357;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nAaZBQC1j8Z0dkeLw3PfufR9+euc6xcZNZw/hB72Ftw=;
        b=pHUTuVVuixSpygXmvNXGKULLNqa/2KQ4AFB8HmVS1mAGMefT+kEUAKiKBlNBd9y2M/
         VP583eK/o76p0TplBOP7c9GaVlUi9TvLKMeXpPBt5D8Yu8BW7nzqaMEzyoE4hsTILfl9
         6iYTKB1hBzFDd/lQtwgphSvcHCWuS9Ym79MaqRsGxUFNXvC01F1iSf4pB8dFvvbm+yte
         1JlE6V7qXn1vw87i3Hxj5ivqvLctmkcw2m/Z+hL+71J8aQ7iBgnpjaifIE1EQDCW9fbs
         5fS4dC5kJtaBhxD9aAyZZSxsOeJ7HLVtbngSpSaADjJqK81GrbofnRoz330lPxBTOjvQ
         3vnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685958357; x=1688550357;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nAaZBQC1j8Z0dkeLw3PfufR9+euc6xcZNZw/hB72Ftw=;
        b=jymmei1IyAELP24bxjNV8141SOyaURu/ECyc65hrBkMO1Uo7DtbL2iSKbGkBmH8y4J
         nsH4C9DbCtUkas124liliC0bsxCWuvLm3NYHMcD+wxPqZEbA5Y5peHa4CYqXtplk5Iko
         QXHrUMG29111cvE1aQY5krb0wYfP2Za46n5sHk9dQR7yl6b38vNMeJStm4xVzWlOq/nV
         FolNWvPgX+h1nsa/o+MFBa6La8fCB6mvoDqdUxswHs7DpDDpp/jdl4qLUxlF5ePpv6KH
         IFCEXi6HMu8a1PlFZs/gNHqlOmlfk/FuHYeW/qce6oddsThAVJSYWy4TfPx7TyIi3vmA
         PtsQ==
X-Gm-Message-State: AC+VfDyYEz6F/tzpnY5mhZJSowqB/r/IZqXAB6r+OyU0dQ33FWLvDRoD
        plG5tjfpsjNOt+8759chj0HXkE65ANc=
X-Google-Smtp-Source: ACHHUZ5AJL6RlrODdj2rBzsInxm1Mkr8x4Vs5bIcGfi1HdIUAvHE82SKNgNI7Hung1RIGCeMS7+q7Q==
X-Received: by 2002:a2e:87da:0:b0:2af:2871:9a66 with SMTP id v26-20020a2e87da000000b002af28719a66mr4179372ljj.39.1685958357095;
        Mon, 05 Jun 2023 02:45:57 -0700 (PDT)
Received: from [192.168.1.103] ([31.173.85.227])
        by smtp.gmail.com with ESMTPSA id n21-20020a2e82d5000000b002a8c1462ecbsm1384949ljh.137.2023.06.05.02.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 02:45:56 -0700 (PDT)
Subject: Re: [PATCH 2/3] ata: libata-eh: Use ata_ncq_enabled() in
 ata_eh_speed_down()
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-3-dlemoal@kernel.org>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <932a4de0-8858-13b7-0b76-520c81f5b0ea@gmail.com>
Date:   Mon, 5 Jun 2023 12:45:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20230605013212.573489-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 4:32 AM, Damien Le Moal wrote:

> Instead of hardconfign the device flag tests to detect if NCQ is

   Hardcoding?

> supported and enabled in ata_eh_speed_down(), use ata_ncq_enabled().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
[...]

MBR, Sergey
