Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08E8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5EDD6044F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 17:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239464AbhIMR2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhIMR2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 13:28:43 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C569C061574;
        Mon, 13 Sep 2021 10:27:27 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l10so10894090ilh.8;
        Mon, 13 Sep 2021 10:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xSARZJQ5YAoGeRg4cb1w9teZ8eBbMh7jYvTDIyUb0K8=;
        b=WuuOMMfotN2bgRawb+bw9VOL/sMzldC/ko1wvu1pD0dlms6lKUll54OnTwrgNQkdgY
         XMhcvugn5Sbz5cD0t2w8RfOb5j3teeU4A8GBpHJ9NeZm6co3baMNsEUeRjDCQgwhIfdW
         Ezm7MqMBCxdGtLS+5Zp1ct1HRQVj8GTl4CjXzwTVLQg1nQhaE+igxr/Doe/fx/TXVHTK
         AXtWPy6s53pQ7kQ+tVeNJYgch3BDPAl/AJOb5ZtosFWViMReP/cBa8bs/H9Qy/jZ2D8R
         i+aMdKAsSu4yCL4vi6Ge+uEUXgL9l5tmRwUj8zuk8IVuL/gzkcgWfQf0H7SnIhtycfrP
         Xt9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xSARZJQ5YAoGeRg4cb1w9teZ8eBbMh7jYvTDIyUb0K8=;
        b=nxuBlz9diFaIuHHHs8R3lIiBalw83L5F0YT2/dmJfWIyaDLFVEymg7dpzLqdFwrhvv
         PiElDOlvpeNgVOc/7Dtsu3yGPKVGCBAwLQEpfTb7jqSBpf51qCO6NNZLXUr9DM17++a8
         7dNbHbHoVMRIHafrHxERf/3VH7nLX4Y0UhA8lx6TdmvIHjyO11OT/+uMzRf1CGWWY4Xj
         WtIDCrYHuYM6r3NNzfuS9UxSMbOGGelfIIs0Z2bZQTgCX0P9QUdycN/RayPKa/IAVBtU
         qXGu8ZOv0+RPtTSgo72+NLPWg+MReiTJYDn3UbK3KLaFAqurpz0XwH8Z4JkwSdeZbDLX
         SnpQ==
X-Gm-Message-State: AOAM5328ZQ6bXRoJKsuSzgf0hOLxVEIpKcC0NNZiIdC1c8HRThiO7ujN
        BygMjseUFwCQwvNws1wDZ9n48sX4hpzno4CZE1U=
X-Google-Smtp-Source: ABdhPJzku6ajJWNIuWGq4QNw2jHxveT8x1HGe9xc/beOqXsm+SHLo5hlaSEUieXfWziememH5sRW6x3kxrgBCxzSpmQ=
X-Received: by 2002:a92:3012:: with SMTP id x18mr9192859ile.249.1631554045994;
 Mon, 13 Sep 2021 10:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210913081148epcas2p21c23ca6a745f40083ee7d6e7da4d7c00@epcas2p2.samsung.com>
 <cover.1631519695.git.kwmad.kim@samsung.com> <fbdd02bc-01ab-c5b3-9355-3ebe04601b04@acm.org>
In-Reply-To: <fbdd02bc-01ab-c5b3-9355-3ebe04601b04@acm.org>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Mon, 13 Sep 2021 22:56:48 +0530
Message-ID: <CAGOxZ51X-ThsqV35PiTh-awRvAkQ=Fjf9m+KRd1HLZ+pDNi=Xg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] scsi: ufs: introduce vendor isr
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Mon, Sep 13, 2021 at 9:42 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 9/13/21 12:55 AM, Kiwoong Kim wrote:
> > This patch is to activate some interrupt sources
> > that aren't defined in UFSHCI specifications. Those
> > purpose could be error handling, workaround or whatever.
> >
> > Kiwoong Kim (3):
> >    scsi: ufs: introduce vendor isr
> >    scsi: ufs: introduce force requeue
> >    scsi: ufs: ufs-exynos: implement exynos isr
> >
> >   drivers/scsi/ufs/ufs-exynos.c | 84 ++++++++++++++++++++++++++++++++++++-------
> >   drivers/scsi/ufs/ufshcd.c     | 22 ++++++++++--
> >   drivers/scsi/ufs/ufshcd.h     |  2 ++
> >   3 files changed, 93 insertions(+), 15 deletions(-)
>
> The UFS protocol is standardized. Your employer has a representative in the
> UFS standardization committee. Please work with that representative to
> standardize this feature instead of adding non-standard extensions to the UFS
> driver.
>
Thanks for your input. Completely agree with you, in fact your suggestions
make sense to me. As a driver developer, surely we can take these concerns
to the IP designers and see how far we can get in terms of standardization.
That, however, is not something that can be accomplished overnight. My main
concern is, what about millions of devices which are already in the market?
UFS subsystem does support _vops_ to handle vendor specific hooks/modifications.
I am not saying we should always follow this path, but surely until
these deviations
are either fixed or become part of UFS standard itself, IMO.

Thanks!

> Thanks,
>
> Bart.
>
>


-- 
Regards,
Alim
