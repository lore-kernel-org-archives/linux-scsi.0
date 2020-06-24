Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957D8C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 10:35:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74B4620644
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 10:35:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UsCxnKJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390476AbgFXKff (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 06:35:35 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50725 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390453AbgFXKfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 06:35:34 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200624103532euoutp01ef47eb96953c6dbc915628fbb69e8001~bdHOUT--H0241202412euoutp01I
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2020 10:35:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200624103532euoutp01ef47eb96953c6dbc915628fbb69e8001~bdHOUT--H0241202412euoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592994933;
        bh=cgq7cSppU5LAD7VtZeYGv/qH3grOh9DdE93FnJSNbas=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=UsCxnKJdpQZrP/2wFgTKwBZJaAhwL8EzC595XaMxc5jNiwvM3cITF9GKnCk9aNEvE
         jhQUvdjWywp+JP7ML4zMAcUq9Rr1RRUMxOtuzG52ZuM0E3RS/MJbed6noOlcyyW1vL
         97CFBMygu6Szgabg7Pg4omj794XSbfM8D/5ekd0k=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624103532eucas1p24f77eb3ce614964b68095bc85a93a432~bdHOGZ6tC0311503115eucas1p2z;
        Wed, 24 Jun 2020 10:35:32 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id BF.10.06456.47C23FE5; Wed, 24
        Jun 2020 11:35:32 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee~bdHNzconj0099900999eucas1p2l;
        Wed, 24 Jun 2020 10:35:32 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624103532eusmtrp174e591c276848756b8c365b99a5d0bfd~bdHNxdV152952029520eusmtrp1Q;
        Wed, 24 Jun 2020 10:35:32 +0000 (GMT)
X-AuditID: cbfec7f2-7efff70000001938-d6-5ef32c74cc96
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 72.FA.06314.47C23FE5; Wed, 24
        Jun 2020 11:35:32 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200624103532eusmtip1bea3eaec23007592a7a405bd1fbcca73~bdHNhGt5Y1053510535eusmtip1D;
        Wed, 24 Jun 2020 10:35:32 +0000 (GMT)
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     Tony Asleson <tasleson@redhat.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
Date:   Wed, 24 Jun 2020 12:35:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200623191749.115200-6-tasleson@redhat.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42LZduznOd0Snc9xBve3q1vsvaVtcWzHIyaL
        7us72Cwu3rvJ7sDi8X7fVTaPz5vkApiiuGxSUnMyy1KL9O0SuDL+PtnHWrBWqKLraQtbA+Nz
        vi5GTg4JAROJZTOmMHYxcnEICaxglFi4qAPK+cIosejUaVYI5zOjRPPFVWwwLdNajjJBJJYz
        SlxoPwnlvGWUWH7yCFALB4ewgJ3E4p+FIA0iAmoSN35PYAKxmQUiJHb/u88OYrMJWElMbF/F
        CGLzApU/2d8NFmcRUJU4/WwS2DJRoPpPDw6zQtQISpyc+YQFxOYE6l3y8igLxExxiVtP5kPN
        l5fY/nYOM8g9EgLN7BLd59pZIa52kTh2qo0FwhaWeHV8CzuELSNxenIPC0TDOkaJvx0voLq3
        A30z+R/Uz9YSd879YgP5jFlAU2L9Ln2IsKPE3SPvWEDCEgJ8EjfeCkIcwScxadt0Zogwr0RH
        mxBEtZrEhmUb2GDWdu1cyTyBUWkWktdmIXlnFpJ3ZiHsXcDIsopRPLW0ODc9tdgwL7Vcrzgx
        t7g0L10vOT93EyMwjZz+d/zTDsavl5IOMQpwMCrx8G548DFOiDWxrLgy9xCjBAezkgiv09nT
        cUK8KYmVValF+fFFpTmpxYcYpTlYlMR5jRe9jBUSSE8sSc1OTS1ILYLJMnFwSjUwhqmuF1JY
        6TKB15Cz7KP2pCIh/40Hl6dNu7Zb5s4/Z/+U0PXHM0sP+qsVCU+Mty7+NveZ3b1dJ1YpbPml
        OPn4VlWnPZ3xRlHmZmuivVi/79bbnntjFefiNY9t7GuaPkybtXDXg611C1x4hbitt0pa7mW4
        Yf76ndIkftaUF5l5Qjd8EmQmFU6qVmIpzkg01GIuKk4EAOAF2ewfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t/xu7olOp/jDJ79E7bYe0vb4tiOR0wW
        3dd3sFlcvHeT3YHF4/2+q2wenzfJBTBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqb
        x1oZmSrp29mkpOZklqUW6dsl6GX8fbKPtWCtUEXX0xa2BsbnfF2MnBwSAiYS01qOMnUxcnEI
        CSxllFgyZy97FyMHUEJG4vj6MogaYYk/17rYIGpeM0rcOf+UFaRGWMBOYvHPQpAaEQE1iRu/
        JzCB2EICmRJ9E7eyg9jMAhESV/vegNlsAlYSE9tXMYLYvECtT/Z3g8VZBFQlTj+bxAZiiwLV
        H94xC6pGUOLkzCcsIDYnUO+Sl0dZIGaqS/yZd4kZwhaXuPVkPhOELS+x/e0c5gmMQrOQtM9C
        0jILScssJC0LGFlWMYqklhbnpucWG+oVJ+YWl+al6yXn525iBMbMtmM/N+9gvLQx+BCjAAej
        Eg/vhgcf44RYE8uKK3MPMUpwMCuJ8DqdPR0nxJuSWFmVWpQfX1Sak1p8iNEU6LmJzFKiyfnA
        eM4riTc0NTS3sDQ0NzY3NrNQEuftEDgYIySQnliSmp2aWpBaBNPHxMEp1cBY7fzkhjSXzYKV
        riKPbj7ZLXpRI+NE89HfW5WeO5bPnHNpftk1620z/GMlvx+QK753Llw/ISA7fP6Ts5n1j7V2
        1EiqPa/1Wvpixzm3F9fcJomKLzVaaO2pcczf2b3iI/vHXeYXD5VPW1ml0l1iq5Ks869m41Th
        p7vX+ue5hZUU17fO87l6NCtHiaU4I9FQi7moOBEAgOU9Oq8CAAA=
X-CMS-MailID: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee
References: <20200623191749.115200-1-tasleson@redhat.com>
        <20200623191749.115200-6-tasleson@redhat.com>
        <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


[ added linux-ide ML to Cc: ]

Hi,

On 6/23/20 9:17 PM, Tony Asleson wrote:
> Utilize the dev_printk function which will add structured data
> to the log message.
> 
> Signed-off-by: Tony Asleson <tasleson@redhat.com>
> ---
>  drivers/ata/libata-core.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index beca5f91bb4c..44c874367fe3 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6475,6 +6475,7 @@ EXPORT_SYMBOL(ata_link_printk);
>  void ata_dev_printk(const struct ata_device *dev, const char *level,
>  		    const char *fmt, ...)
>  {
> +	const struct device *gendev;
>  	struct va_format vaf;
>  	va_list args;
>  
> @@ -6483,9 +6484,12 @@ void ata_dev_printk(const struct ata_device *dev, const char *level,
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
>  
> -	printk("%sata%u.%02u: %pV",
> -	       level, dev->link->ap->print_id, dev->link->pmp + dev->devno,
> -	       &vaf);
> +	gendev = (dev->sdev) ? &dev->sdev->sdev_gendev : &dev->tdev;
> +
> +	dev_printk(level, gendev, "ata%u.%02u: %pV",
> +			dev->link->ap->print_id,

This duplicates the device information and breaks integrity of
libata logging functionality (ata_{dev,link,port}_printk() should
be all converted to use dev_printk() at the same time).

The root source of problem is that libata transport uses different
naming scheme for ->tdev devices (please see dev_set_name() in
ata_t{dev,link,port}_add()) than libata core for its logging
functionality (ata_{dev,link,port}_printk()).

Since libata transport is part of sysfs ABI we should be careful
to not break it so one idea for solving the issue is to convert
ata_t{dev,link,port}_add() to use libata logging naming scheme and
at the same time add sysfs symlinks for the old libata transport
naming scheme.

dev->sdev usage is not required for dev_printk() conversion and
should be considered as a separate change (since it also breaks
integrity of libata logging and can be considered as a mild
"layering violation" I don't think that it should be applied).

> +			dev->link->pmp + dev->devno,
> +			&vaf);
>  
>  	va_end(args);
>  }
> 

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
