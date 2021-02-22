Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAE2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 11:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03A3564E27
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 11:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBVL6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 06:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBVL6Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 06:58:16 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CD7C06178A;
        Mon, 22 Feb 2021 03:57:35 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id t11so28841233ejx.6;
        Mon, 22 Feb 2021 03:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4y7BXbCaoSy8pcfvh1FBhUbCtj/O5tRWQAH/XOjXyKg=;
        b=HLTyMuhK9Vg+w8AORWrIVwa+cCF2eqsH28sl5TBQmyOtjU6LX+n+uURVooqvwC00Be
         aDu9svXUUz4N8Uzs5rkKYO+/mur83q5rjWTSCwBTBxLo79IZwXancOzctloRBGRFG7hp
         wtTVvcm4mwbv91Gj5JJvNYCGjc7Xsa7WWI4J1MWg0K9bOOIszrnwHp6tebH0t9uwnpss
         W+b2DdEJbsBPOxD+xMHXGnKyZeRVmMoDNv8ia/lzaFs3bgwjttWTbjqFMPyt2iZFPB8M
         y/sscJxJB8AZ9KyKYC0dxBptIgK9vZHEUKgycav/GoH6KtiVFXOJFn0wcvIJx+8kZWMg
         8XbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4y7BXbCaoSy8pcfvh1FBhUbCtj/O5tRWQAH/XOjXyKg=;
        b=AnbyO2eaAk9cwZf5FDXgrc761raZUmuVFnHBxPVTAGZFxWKvMKC27l2QFeY5bnTNf7
         U7NN8q6vmA53im7NRXaozwluXBdac+ayJ1ufgEgroZ7RR1BA21h5DWy7tF9p65MaH03s
         W5DMJUsiwQJICajwAdjzrVU0KOKIUap8NU46wrghA/r0V/zK0uTTpo5wsB0wCRbML4cO
         ODcLAk1sxhoM5j5oSnIXgflwm9Gpgzx3kknPPugPtswB91N67q75LM1WOf1Flrf+Gyf+
         Job/v4Ptw5WVIF80eSUvCgY7RquEM6o5n0sL6N1yK7SnK/0gmVUcEugSrPLLyhcps45D
         VSRw==
X-Gm-Message-State: AOAM532VK3Omi9IckDUOdHKGYpwGx7GDc4MoUlnLbWOPUu40EWkicLQH
        HPuwZhWOIK72nSM1e88fV6Q=
X-Google-Smtp-Source: ABdhPJz39+SdxiXFr5MMnpEJiLHx3DSeN1Lq85wDaSV9T4iNTINmkI3flM+bQR/2/XTK38naYu6Vig==
X-Received: by 2002:a17:906:2c44:: with SMTP id f4mr3158242ejh.234.1613995054362;
        Mon, 22 Feb 2021 03:57:34 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec1d.dynamic.kabel-deutschland.de. [95.91.236.29])
        by smtp.googlemail.com with ESMTPSA id e11sm10291120ejz.94.2021.02.22.03.57.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 03:57:33 -0800 (PST)
Message-ID: <62be9fcfbd79b5977b34de85e486409ec74b7359.camel@gmail.com>
Subject: Re: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Mon, 22 Feb 2021 12:57:32 +0100
In-Reply-To: <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
         <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
         <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p1>
         <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2021-02-22 at 18:31 +0900, Daejun Park wrote:
> +}
> +static DEVICE_ATTR_RW(requeue_timeout_ms);
> +
> +static struct attribute *hpb_dev_param_attrs[] = {
> +       &dev_attr_requeue_timeout_ms.attr,
> +};

here, you lost a NULL member at the end of attribute struct.

Bean

