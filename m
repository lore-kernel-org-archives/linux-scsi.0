Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3469DC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 14:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB21664EC3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 14:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhBYOi7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 09:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhBYOi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 09:38:57 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF218C061574;
        Thu, 25 Feb 2021 06:38:16 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id n20so9259719ejb.5;
        Thu, 25 Feb 2021 06:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AGEE2575c0gJxe/ojj9iv1qzlHIKXvtl4Fpc/Q6GFGY=;
        b=csrT8UvqNhfkzlrzmOgHLKaLKSvXagdgJkSte1UVBKonkXeMB2RG7FJ8cDx954OVCa
         bUuq/IZruM+qx4qEz1aVilOUN5wKd/yICoW2ZOWv6oUIVXbOJ7iTiRzJHY010p1F1tfa
         6bwDFy9tjYshwHnLmYhBJWtjM3UAQyfEoOOrTpGv4sQY0LiceSqhprTi17//WZN3EuDV
         ep3r3KmBns3mPosJUzUerYD84lwZ0Y2aDZIxn/wi/M8a/PM5VIYRJ67y7+i88ikV6SmC
         wmk2iJwtZ9qQAPUqUpjF/MgXVBCYNessl3DJ7ngMlHOf8z4YI2yIcT3xp3VqNw5dakXw
         Y/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AGEE2575c0gJxe/ojj9iv1qzlHIKXvtl4Fpc/Q6GFGY=;
        b=KW/9NKqmf8YguFckH2wxm5X+8dr5eV5le1DMIdMXNBxfK6TeP2Odtce3WScTFNQLvt
         u5TD+4KikuM4txqd98VjRVGH+RaNeyqZucItR5mlNhxF8oFhehLDOab2QxmRlEYKDSgo
         rY0ID/zjRB5ZGGIH/s4l0ey6597k5szJvnoheLJliW8hBOnsuPHAqQNORK8YAF526A5M
         z1BrONBL5Kytu3JQwdbJHtEUGvmtqlbgdlNVhYGl/SZy374YBsPfawHzH4muJXvTgZO3
         cbyldCl8uwGlc5bnee8KXy6JSf2bUlWs5pIXeBjiCP8GiXrJB0MgvX4+PRf/ji62PCU1
         cwtg==
X-Gm-Message-State: AOAM532F/ulwsa7Gorsh/0DQruoxdmmsWYK9y8Ez7RDzTdTfZNimiHKZ
        7ZExVi2g6Bc0qbbRMtO2iZs=
X-Google-Smtp-Source: ABdhPJxtdrjQgm8rYi9MIVGsRmgyWTLm2t1CSbgFHlYJ04QkWFdpirrWKutVzO98hDtxNMh0bZNQRw==
X-Received: by 2002:a17:907:9688:: with SMTP id hd8mr2829798ejc.528.1614263895497;
        Thu, 25 Feb 2021 06:38:15 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec1d.dynamic.kabel-deutschland.de. [95.91.236.29])
        by smtp.googlemail.com with ESMTPSA id r4sm3420879edv.27.2021.02.25.06.38.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Feb 2021 06:38:15 -0800 (PST)
Message-ID: <50f8a0963e887542a467e690b6d406675279a4e5.camel@gmail.com>
Subject: Re: [PATCH v24 1/4] scsi: ufs: Introduce HPB feature
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Thu, 25 Feb 2021 15:38:12 +0100
In-Reply-To: <20210224045405epcms2p2d05f8563b1f121d2c2cc79b343e5af77@epcms2p2>
References: <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
         <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p2>
         <20210224045405epcms2p2d05f8563b1f121d2c2cc79b343e5af77@epcms2p2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-02-24 at 13:54 +0900, Daejun Park wrote:
> 
> +void ufshpb_init(struct ufs_hba *hba)
> +{
> +	struct ufshpb_dev_info *hpb_dev_info = &hba->ufshpb_dev;
> +	int try;
> +	int ret;
> +
> +	if (!ufshpb_is_allowed(hba))
> +		return;
> +

Here it is better to check "dev_info->hpb_enable", if HPB is not
enabled from UFS device level,  doesn't need to create mempool and take
other memory resource.

Bean



