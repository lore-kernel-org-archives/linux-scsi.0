Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F21C433E6
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B414364F25
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581574AbhCBS7D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381966AbhCBO16 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 09:27:58 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BDDC06178A;
        Tue,  2 Mar 2021 06:27:09 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id mm21so35294699ejb.12;
        Tue, 02 Mar 2021 06:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PJEEKD0ZqT1c9UTQN+/5T3c6Vm2BFnBI5jKv2Cyez3c=;
        b=r7z6GR1P02KelMOnsQBVVnGnNaKtaeGhwwNn1XWKDajbceLrR0tBRQHm0qwfJh/lm3
         zlOHG4CH16E/ALRPxxWXqAo5tJ04IL6jIvxFoDgEzseJ9d//kQBKCMGqqn14NRxqPESj
         Z6U68O21ySBf5Zm1F/8R1JgyG995N57jaO9tPw7sm/12Cd+4S6N23/Z6GCCpwZ0xK8kd
         RRVdagSjEyYU6w64ucK1bILxyRKyx9mOs4Hvyv0+LuFteuPOjk3I4lO/vguUKK23tGh+
         c14OZ/yg65vVZn0eRmhKVr0d+KddQ/aES4TvOV8jBWUVs1uXEcra4Kqsmnq6dNe356Y3
         6rJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJEEKD0ZqT1c9UTQN+/5T3c6Vm2BFnBI5jKv2Cyez3c=;
        b=NThSdo7gM+WAxIqLs+ER1+d5iEYTOzJKrhx7nJeMB0nXG24EbUxS+I1uIFowGMfBxR
         gkftlfMeWoC10LuAc5g5NG7manrWd8RUU320vi3GuAAXaTJ69Mko1FIp/h77vNv68EdB
         QIChsRBrjCWPvkvROHB7Q4qxL+psDewd1WqpB+VJUWZSPeGySqSr7SGzvGvRXG99a6Ff
         PoduvHu6XxuZ0v6GtRu0EYEKXE2i04qYt1O4TDI1AooVJb1aFDEMS3TcfTYjVqdBktqG
         XrePyGYdxGbawur4hg9wa1q5oNwocLbkYDRSylR9Ct0cNNvmNacqWOD8/wS5WdRj84m4
         Xbpg==
X-Gm-Message-State: AOAM532KbXWCwFOHHPp28iQAu6ymE6CkVNXqUGL0QaCN/1/HwcHmA25l
        cwjV36j4JbrbzRcwcA2P5+k=
X-Google-Smtp-Source: ABdhPJwpKSWA19gaNSZHH2q1RU452CqqaZ5KOoK21T5yGvYbD1UNFKth8ESBhqu2r7T8AgcdwzcI+A==
X-Received: by 2002:a17:906:63c2:: with SMTP id u2mr20708201ejk.346.1614695228198;
        Tue, 02 Mar 2021 06:27:08 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id i17sm20170143ejo.25.2021.03.02.06.27.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Mar 2021 06:27:07 -0800 (PST)
Message-ID: <c3560201c8dad085b0c5a661256eef837095b24b.camel@gmail.com>
Subject: Re: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
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
Date:   Tue, 02 Mar 2021 15:27:01 +0100
In-Reply-To: <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
References: <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
         <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p5>
         <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-26 at 16:35 +0900, Daejun Park wrote:
> +
> +/*
> + * In this driver, WRITE_BUFFER CMD support 36KB (len=9) ~ 512KB
> (len=128) as
> + * default. It is possible to change range of transfer_len through
> sysfs.
> + */
> +static inline bool ufshpb_is_required_wb(struct ufshpb_lu *hpb, int
> len)
> +{
> +       return (len >= hpb->pre_req_min_tr_len &&

Here is wrong, should be : len > hpb->pre_req_min_tr_len.


Bean

> +               len <= hpb->pre_req_max_tr_len);
>  }




