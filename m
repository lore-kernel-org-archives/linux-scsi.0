Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A60C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C12222242
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389288AbhARKsa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 05:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390070AbhARKXe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:23:34 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4077EC061757
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2021 02:22:54 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s11so9639836edd.5
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jan 2021 02:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NVnd2dTqFgKPXCVm7NYzbiiSu1FiTEUGZr/l5h+PSFI=;
        b=NoGOY1SHqahPLz59ZT4Bd4qXVIlhKgntp3DttcdLUMKUyriKpC/Yw+WvtpDU6H44Ww
         Cr8S89pNeBDl8hWqLccduJYvOyZiCCIgE1Ds7xdAJA09s4U9HEdfOWzmi2BaLr/qK4eG
         fFPk4zDaCnl6AhtIz2gW/OuKJddLZt6D0pNWnBLs442ZlgbCfBLcgkJFdbKJiJ33hROZ
         gs1Wag1owjG4dwud8tLPas7tW+RGJJehhB6XLTvekldZCed0NefLhCed8u1v2NTH7bhx
         T8uCC42ACxhr03C3PZugyNu4VecRnBcTMEXaJXGQPCOHXOHtkGUdWIgvwZDy4TFM6PeY
         0e5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NVnd2dTqFgKPXCVm7NYzbiiSu1FiTEUGZr/l5h+PSFI=;
        b=H5XGeFE0sV2VpmEyXKpCzdvm1cU1EzQfe82gSWrO932fqtU13RBTE+s304BgMtXQk2
         GaNL3+jygnOQ5NNU2rV45KK7pcGnXmLuVYaS+x7xu9BRdxaEjUtk/DrL9UMSUHhQc1Y3
         wU0+/p1fMAso40q0094lOswuYQLxD8scplnqY2iMUNp4mCDkCjr5bbAbTHD2Stk5yExZ
         5CBfAXLs2tocrHqNSuINkYQf0facoGCl9Ko01lVbvi4UHCMKgKMW+ZKjhZenTsLTJ2vk
         ITi1d9j+bkq9vWxngkuVcsF9KPa++3NKqIt+vlKZ6SknvE4nEZ7qCb72Ty0+0HVuR2fw
         Va3A==
X-Gm-Message-State: AOAM530XOWZD1bTM7G96ReFhbwpzzvzumkbU/ccO84AC4M/q7aypX/Gy
        m+CZR2+bAEwx0x3+9khO8PYlIdqgUUR/bP0YY33EJ2QKLY0=
X-Google-Smtp-Source: ABdhPJxfwh3z0HRakrXQH67XgrGvut1ROZGmo6cd3/HfucTAMZCwkdY6vKLAQjzzmSj/SPW7MCRgpgKUutXGQEbTLZY=
X-Received: by 2002:a05:6402:1c0b:: with SMTP id ck11mr9185032edb.35.1610965372974;
 Mon, 18 Jan 2021 02:22:52 -0800 (PST)
MIME-Version: 1.0
References: <20210118100955.1761652-1-a.darwish@linutronix.de> <20210118100955.1761652-2-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-2-a.darwish@linutronix.de>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 18 Jan 2021 11:22:42 +0100
Message-ID: <CAMGffEk92QqBMCjnzm-uB_EHWU4NwarzbTa7URKYkjjrjOToPQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/19] Documentation: scsi: libsas: Remove notify_ha_event()
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 18, 2021 at 11:10 AM Ahmed S. Darwish
<a.darwish@linutronix.de> wrote:
>
> The ->notify_ha_event() hook has long been removed from the libsas event
> interface.
>
> Remove it from documentation.
>
> Fixes: 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Reviewed-by: John Garry <john.garry@huawei.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  Documentation/scsi/libsas.rst | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
> index 7216b5d25800..f9b77c7879db 100644
> --- a/Documentation/scsi/libsas.rst
> +++ b/Documentation/scsi/libsas.rst
> @@ -189,7 +189,6 @@ num_phys
>  The event interface::
>
>         /* LLDD calls these to notify the class of an event. */
> -       void (*notify_ha_event)(struct sas_ha_struct *, enum ha_event);
>         void (*notify_port_event)(struct sas_phy *, enum port_event);
>         void (*notify_phy_event)(struct sas_phy *, enum phy_event);
>
> --
> 2.30.0
>
