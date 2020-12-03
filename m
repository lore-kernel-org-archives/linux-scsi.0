Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F023C4361A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 11:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D66722D6F
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 11:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgLELGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Dec 2020 06:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729340AbgLELE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2020 06:04:59 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BCDC0613D1;
        Sat,  5 Dec 2020 03:04:16 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id a16so12486706ejj.5;
        Sat, 05 Dec 2020 03:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:in-reply-to:references:date
         :mime-version:content-transfer-encoding;
        bh=NHruUIRUPikDpSK6wixebj+vz7uT4fAyp4/i/do8fV8=;
        b=W0/7KLvOybvPHt9/gLEJ2+/fnwDOiUQ0v1CmDyPHhjbZl9DeSZv5qG0e2gESoM4UCO
         biPJLR1X+G1El98j815+M/L46QJm81cc17aOYg/dKUqF6llsIl4zAIFPFpt9OIwMNXyQ
         WRy+qhiFlxG/nm+7IiYAkFYSU9RrFlCBmMCGD0kGPp+cn9qQ46fJ10MHHRLeUPhFP3AA
         2R5RnEFCjsv16TJUAVVaBmLPSRyE/lYeRh5EOqbrOrI4tsNXKtusJ9fG6jMsVFQaGAqn
         p5HSzIBb5ejuiEWFLSBs8QX186Gd6bpAyECcOXqSbhbvsGXn8hgqFp00GAYnhv0id7FT
         i6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:in-reply-to
         :references:date:mime-version:content-transfer-encoding;
        bh=NHruUIRUPikDpSK6wixebj+vz7uT4fAyp4/i/do8fV8=;
        b=O5fJmPGpec03AF/nQNcQUIxbQVcWTZfc0gN7Lh+/05Vp/WC99SnReG/t+g53yKlfXO
         TZ+coV50fcroCrSkWi1byDchzcGp1kxBNHs1NKcyqQqW/hgwduNq0PmovbPtQ2t3k88w
         sW/GmP9p1pk5R31XIEPkKKU5+MyIxORn03EZhbKacCvXWxhNUo2kYb581X3btv443JLh
         72KV2N/mVUIJmplbs1/Ip1VnxKYb0VDu2+ZhG7b9DNe4Itt0qJHc5jFJidCqv/BGtq4W
         eR+LWoE7f9f51s7Z/0evM4xhdE2nIlJ3CZF17rMk0f0Y1+e/BdvllDBOw/K12wi3GFj5
         JD3A==
X-Gm-Message-State: AOAM5334AhaMuy6LHS++ta78KN81IE8d85dIzd+ZOIFN3JYaeiJSVppv
        KhXpGQ31wsvHI0FPVD9rvl0=
X-Google-Smtp-Source: ABdhPJw1M6GA3TK87awBb7U1UCkDdWQ40/pNmPu/G2RzenLtohJsLODrRYOyIpEZwwlJkVjukxbDsg==
X-Received: by 2002:a17:906:38c8:: with SMTP id r8mr11360628ejd.39.1607166255415;
        Sat, 05 Dec 2020 03:04:15 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id u1sm5436338edf.65.2020.12.05.03.04.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 05 Dec 2020 03:04:14 -0800 (PST)
Message-ID: <d323ea3e12dbd8a7683c6d6c194f422519157728.camel@gmail.com>
Subject: Re: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-3-huobean@gmail.com>
         <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
         <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 03 Dec 2020 10:36:08 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-03 at 07:27 +0000, Avri Altman wrote:
> > 
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Keep device power mode as active power mode and VCC supply only if
> > fWriteBoosterBufferFlushDuringHibernate setting 1 is successful.
> 
Hi Avri
Thanks so much taking time reiew.

> Why would it fail?

During the reliability testing in harsh environments, such as:
EMS testing, in the high/low-temperature environment. The system would
reboot itself, there will be programming failure very likely.
If we assume failure will never hit, why we capture its result
following with dev_err(). If you keep using your phone in a harsh
environment, you will see this print message.

Of course, in a normal environment, the chance of failure likes you to
win a lottery, but the possibility still exists.

  
> Since UFSHCD_CAP_WB_EN is toggled off on ufshcd_wb_probe If the
> device doesn't support wb,
> The check ufshcd_is_wb_allowed should suffice, isn't it?
> 
Tot at all, UFSHCD_CAP_WB_EN only tells us if the platform supports WB,
doesn't tell us fWriteBoosterBufferFlushDuringHibernate status.

Thanks,
Bean


