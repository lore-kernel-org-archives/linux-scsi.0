Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 101B3C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E7164FD7
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 11:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhBEL5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 06:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbhBELy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 06:54:59 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F136C0613D6;
        Fri,  5 Feb 2021 03:54:18 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id b9so11443118ejy.12;
        Fri, 05 Feb 2021 03:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pca7yULDBNu4TLScGZnnvR4Eqjg+DgmKbpOuQ5aWZ0s=;
        b=NqXIXDXe2cfYtChuO9cMWpHpKARL9W/EaCpZLvWv335UJ2i1QuRBJ4PpNn94Ub4jIA
         A1sA67Jru17CM2nMD0gQbpz/vgmw0IuLUCqhP/JqR0RZt308DQTCge30dAT8B8Mq7Ruy
         154+7aYtk9FkquyezgNOFvA42mFI4g+Tlc5IFJrKBnjkErGQnFY4i5NIjORW6SUEBZ+L
         ZGFXdfhxrFnsJ8Q1BIgo0lj3QQbf7WxIV7QoBZwx5Ig+9D+OuUSR3GvagPfAX8a9vEK0
         zIGlQsScU7gT+DzHU92GecJhvQ4zFEL8yURZb85SEFI035oY9g5Y3MmZBBoL0B28Hiv9
         oNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pca7yULDBNu4TLScGZnnvR4Eqjg+DgmKbpOuQ5aWZ0s=;
        b=dNaJs4WqEHMRtrCPFAz7yeoHxu6ntUgD2H2yEiEw6a2BZ+sOASPQO2/QSqJevVoW4T
         MFWYprCefZGjNIIW2G36aoIQX3D89rF+DTpZ4FCwU4j9a4eRviANY3O6+vLQ2Mhiocxb
         KTjkFS9HW6jLyBXuCVjr/Lkc8WquJnTBAlOu/hiJm65pmLqxodNkbHZmY01ArlvSj4Br
         JQhb7mmfgwvHs0i1folvcmXPNgwnXRqEzua6s3EyEDqJ0UjCauDVgO1ZhknGDdSvjiJF
         k2VXsWWnlCv5lPjs1hDbeNuikSg++55WklN7ohnS4aYNkJgC9JL+X7iNdcpBeDETuyOi
         XSmw==
X-Gm-Message-State: AOAM533cYSQ3CsEtz5aw9aPWL/VQADbm48JlagyyHsn18++aXboqhEW3
        H1Ba34AE7K/nmOT2oe1/UBM=
X-Google-Smtp-Source: ABdhPJxCq02Qk/px5e72mtIZ2CxxdODbCmvqoKlJpHoAlQ0E87sw21rwb+eluApapRByDWbEYUAZVw==
X-Received: by 2002:a17:906:805:: with SMTP id e5mr3663996ejd.104.1612526056991;
        Fri, 05 Feb 2021 03:54:16 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id p2sm3770951ejg.45.2021.02.05.03.54.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Feb 2021 03:54:16 -0800 (PST)
Message-ID: <527b4233f6118cf7e9d90eb726394d85fe1bb26d.camel@gmail.com>
Subject: Re: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Fri, 05 Feb 2021 12:54:14 +0100
In-Reply-To: <DM6PR04MB65759D6418E8FCD4B0BD6236FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p3>
         <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
         <218be362c71a9cdb8312f6d8156a0935985aae04.camel@gmail.com>
         <DM6PR04MB65759D6418E8FCD4B0BD6236FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-05 at 11:42 +0000, Avri Altman wrote:
> > "If the requested field of the HPB Region or HPB Sub-Region is out
> > of
> > range, then the device shall terminate the command by sending
> > RESPONSE
> > UPIU with CHECK CONDITION status, with the SENSE KEY set to ILLEGAL
> > REQUEST, and the additional sense code set to INVALID FIELD IN CDB"
> 
> You don't need to worry about setting invalid ppn to HPB-READ command
> - 
> you'll never get a read request for those LBAs.
> 
> Say all subregions are 16MB and the last subregion of the last region
> is 10MB.
> Keep all sizes the same - 16MB, and the ppn of the last subregion
> contain some invalid data.
> But you'll never get a read request for those LBAs anyway - they
> don't exist,
> so you'll never get to use those invalid ppns.
> 
> Thanks,
> Avri

Hi Avri
ah, I don't know if your above comments are inline with Spec.

Spec:
"A HPB Region is divided into HPB Sub-Regions. HPB Sub-Region size is
specified by the bHPBSubRegionSize parameter of Geometry Descriptor.
HPB Sub-Regions are equally sized except for the last one which is
smaller if the last HPB Region is not an interger multiple of
bHPBSubRegionSize."

It is not invalidate ppn concern, it is illegal request issue in sense
key.

Kind regards,
Bean



