Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49398C00140
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 02:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbiHACLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jul 2022 22:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiHACLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jul 2022 22:11:36 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCC21117D
        for <linux-scsi@vger.kernel.org>; Sun, 31 Jul 2022 19:11:35 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id z25so15214261lfr.2
        for <linux-scsi@vger.kernel.org>; Sun, 31 Jul 2022 19:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=puY3oiFSpcaTS44Ce5+uMyvw4oTZVMyBbnsQcCRh46Q=;
        b=a89p68ZPVNCO/UyOmafVIvY9kjI9t15Ftr7IcW+U3Aid7E3ZmpZ4UVAmqcLBSanfC2
         kh4oWcF5OPLJYSs2ZqNDHm/PVVZD4J3V0OSKq3ZzIcQQ4emApZmwVt34LL8SbGVfcP9a
         Xd8QgKtNOrC37916YVPH/udJ/lOSJO1eqOIQ7560uoQDUOTNdqqN3FWN5F183FmnViad
         QWXGcx3bVlITOEeyDIflamf2ZtWzJsvY9tDIGMgzPxUxQf0M6o3V99BXRg0iRQYiuNrZ
         Sz5kQXnTH/JjR5FyoIm2KZSi5JlyKa8eSSe0gUpuX7IUJodMY7kk/YHgGRnChvQRhK7q
         5qug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=puY3oiFSpcaTS44Ce5+uMyvw4oTZVMyBbnsQcCRh46Q=;
        b=3uWrDUfNpElFpB91yVMZVtqARCi+ySHRBrynJ5QX0Ij2ytfLwsQ/T4PIYlvNCcerRw
         WKZ4UqO3DrMUE6p1Fcy0tiVaJBp6FaRAlZU00tIX/hkAuc1LSmqp6Ocs53DppV+0HJhz
         KzoSKEfIKjXkQl+KBKCycwjDHd74jG7ul6L02QfSCqjK9MRJ6Jrcah1Vkjcwqf784nEd
         U4oNiKwiMy1s5MROpnQoMTXcqPMTkch6/vaoIqDHeIu28VO/tCmbhsqbZCPjr0ViRO04
         3z0rv4M9wbLaGHY7ECdA+uJtyvpOXnX983tRwNmmD7Kao2tHTFPiaigLY/fJhyzFSv+y
         NJIQ==
X-Gm-Message-State: ACgBeo0DBqP2PzB6uUrCGiFH8WSGA4RyyCU7HLIFtirUN6gPr/BQpI+m
        CS3jfbcW5kDwlyp81T5AwpFfBWwYnb8AC5p0ow==
X-Google-Smtp-Source: AA6agR4D3dYa6o2IdEGflSmvSoavwQ66L1VtEMBbCzDvB3t/+5xYfRLZmq+uf6Z8BGOcFEnQI0T4/ELYMPnWQ1q9bsM=
X-Received: by 2002:ac2:5df2:0:b0:48a:e657:3b6c with SMTP id
 z18-20020ac25df2000000b0048ae6573b6cmr4404152lfq.215.1659319893535; Sun, 31
 Jul 2022 19:11:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220728071637.22364-1-peter.wang@mediatek.com>
 <968f5255-f7b9-e011-2bd3-aa711bdd142a@acm.org> <e2fba3fe9b10d060a9906c440dd1f55e52404d77.camel@gmail.com>
In-Reply-To: <e2fba3fe9b10d060a9906c440dd1f55e52404d77.camel@gmail.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Mon, 1 Aug 2022 10:11:21 +0800
Message-ID: <CAGaU9a9nYnATi2QvMYp8M0K=iu7tAMNu1PDJ-SN1vACtY5aSCQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] ufs: allow vendor disable wb toggle in clock scaling
To:     Bean Huo <huobean@gmail.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, peter.wang@mediatek.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        Chun-Hung Wu <chun-hung.wu@mediatek.com>,
        alice.chao@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        powen.kao@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Fri, Jul 29, 2022 at 5:27 AM Bean Huo <huobean@gmail.com> wrote:
>
> On Thu, 2022-07-28 at 14:09 -0700, Bart Van Assche wrote:
> > On 7/28/22 00:16, peter.wang@mediatek.com wrote:
> > > Mediatek ufs do not want to toggle write booster when clock
> > > scaling.
> > > This patch set allow vendor disable wb toggle in clock scaling.
> >
> > I don't like this approach. Whether or not to toggle the write
> > booster
> > when scaling the clock is not dependent on the host controller and
> > hence
> > should not depend on the host controller driver.
> >
> > Has it been considered to add a sysfs attribute in the UFS driver
> > core
> > to control this behavior?
> >
>
> Bart,
> we already have wb_on sysfs node, but it only allows to write this node
> when clock scaling is not supported.
>
>
> static ssize_t wb_on_store(..)
> {
>         struct ufs_hba *hba = dev_get_drvdata(dev);
>         unsigned int wb_enable;
>         ssize_t res;
>
>         if (ufshcd_is_clkscaling_supported(hba)) {
>                 /*
>                  * If the platform supports
> UFSHCD_CAP_AUTO_BKOPS_SUSPEND,
>                  * turn WB on/off will be done while clock scaling
> up/down.
>                  */
>                 dev_warn(dev, "To control WB through wb_on is not
> allowed!\n");
>                 return -EOPNOTSUPP;
>         }
>
>
> Kind regards,
> Bean
>
> > Thanks,
> >
> > Bart.

Acked to this patch series.

Clk-Scaling is aimed to save power by fine-tuning any possible
resources depending on the workload.

Currently below items would be tuned,
1. Clk rate
2. Gear
3. Write Booster switch on/off

The truth is that each host (and device) vendor has different designs
to reduce the power, therefore those tunings may not be suitable or
need different ways for all host platforms.

Take below cases for example,

1. The clk cannot be set at different rates directly because it is
shared with other users.

2. The Write Booster feature does not need to be disabled because this
impacts the performance too much. Performance may be even worse than
the case when clk-scaling is disabled. In addition, system power may
be not reduced if a long data write period is harmful to the system
low-power design.

Thanks,
Stanley
