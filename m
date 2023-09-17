Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAC8CD13D8
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Sep 2023 20:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbjIQUO5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Sep 2023 16:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240709AbjIQUOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Sep 2023 16:14:54 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828BF101
        for <linux-scsi@vger.kernel.org>; Sun, 17 Sep 2023 13:14:49 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-31c5cac3ae2so3387007f8f.3
        for <linux-scsi@vger.kernel.org>; Sun, 17 Sep 2023 13:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694981688; x=1695586488; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rTSDWNpHGODMozyRSMDpPuav7IAuR4u7AKVtV48p5Ng=;
        b=HwkMkEBMhGP5w5VzmgX5nseBAEnD94N31FoKTRPlYEiXPvHRLjm1ACUhm3POfJ19wc
         D/gWc2ffkHYzo2MTGnut5HOcDhy1cKWfXyEXZ1qndZOD5yqq/5hW+iN5o85P1g4AF8Ht
         Kl1FSZAwBipy7bHSq3oQdm1Y5jVnWwYTU6ZsfNGTdGaR/DZcHyj+kY+nUrhsLbcvqh6T
         QkAV1TLoy1uikX5WlQCiTpm0m4XeFRuP0MSqpeQlLBiabZ9AT4jHOQzTvAjyam1eC5lh
         3WFAqYAMR2IyYh//H9GaCywdhi4cp0LKgXU8l8xBcBfhKs+U2KM8i73IcFzJjTVAmtJr
         3QAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694981688; x=1695586488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rTSDWNpHGODMozyRSMDpPuav7IAuR4u7AKVtV48p5Ng=;
        b=XW83xtekgsd8pHAjcNdCYnxEhDR3ck477sef7yqbnvryhrqCGAQL5vv7NfTc0G5+nu
         zEZU9CnVlefMLBSIbafACduQex3V29MgcIqJyOygDDguFWKP9+1jtxOGx/iUs7ZK45ou
         1JhP1EJX/mS/cppDtSaXqoRMHVs2oZV/TBb9LJbrf2EexFLyftCjKjlcn4ik08RUHjCO
         LC5WiKrxZ16ktlH6Fh/cFyHyiDbcTOKOVNnrnw36F1cPnn7Wm/f4NYrvXVlwIphBPyAF
         j+s55OKnb8IOMK+96VWHL+TF/ExL9RjCon4tPzv+BGV2+tbBFc3VKw94LmMwEI9Dhx4z
         TEQQ==
X-Gm-Message-State: AOJu0Yzq24wj8QeC5liOFABgJt22+Icyj5w3jj3pHj918EQeDPvgsnRZ
        XLl1u+OVXB1ekY79WkoLDps=
X-Google-Smtp-Source: AGHT+IEyAZxPlA9KUq13rpqz1u7r0f0oX5Li5fyU/rAN5v/Al9bY8RVHzOhEnuyjGAPYhjY9tSG7xg==
X-Received: by 2002:a5d:58e1:0:b0:319:79bb:980c with SMTP id f1-20020a5d58e1000000b0031979bb980cmr5522174wrd.64.1694981687569;
        Sun, 17 Sep 2023 13:14:47 -0700 (PDT)
Received: from ?IPV6:2003:c5:8703:581b:3128:19b3:9271:2fb6? (p200300c58703581b312819b392712fb6.dip0.t-ipconnect.de. [2003:c5:8703:581b:3128:19b3:9271:2fb6])
        by smtp.gmail.com with ESMTPSA id br20-20020a170906d15400b0098669cc16b2sm5361950ejb.83.2023.09.17.13.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Sep 2023 13:14:47 -0700 (PDT)
Message-ID: <efe8a1c5-4f33-1c14-8412-61f007d966de@gmail.com>
Date:   Sun, 17 Sep 2023 22:14:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] scsi: ufs: Convert all platform drivers to return void
Content-Language: en-US
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
References: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
From:   Bean Huo <huobean@gmail.com>
In-Reply-To: <20230917145722.1131557-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Review-by: Bean Huo <beanhuo@micron.com>
