Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42812C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 00:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F96B216C4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 00:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599612949;
	bh=NljrK6DZ67Y2lgb5dD1jWF3Bw2u9eqUapVKXFIgps3U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=y5kVg51HcH1vPGynsjZuK9b9eCjc/u1lMbmdEewsa/HyfNrQ9gLERSPy/GCfa+6BR
	 3iiqKkFVgFNAtNiBKseu6BFFWmR8YRZfyRoBdHIcPb1BN7DDiumkIdDLYpf/s/YTcK
	 9Q8vFLe3e52q9l2WzzlAqOft0AbJ17yic/TjNjhU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgIIAzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 20:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgIIAzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 20:55:43 -0400
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1279216C4;
        Wed,  9 Sep 2020 00:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599612942;
        bh=NljrK6DZ67Y2lgb5dD1jWF3Bw2u9eqUapVKXFIgps3U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GOiNe8A+Z0vTTTifPiCPBcHcdbEHQkfWlRxTDBj/Pe0I88gYH9vzSKUDLD27Jcns2
         5pdMRPZ/uvmf9F4zMSASsMr58Na9advGa///ZSw/JngxR332XN39tr/EYePt27PZKM
         ZYhwsKS7Z+Y39YoQL3C0SH2R0XvxsGhvJw+cD5lI=
Received: by mail-lj1-f182.google.com with SMTP id v23so1314350ljd.1;
        Tue, 08 Sep 2020 17:55:41 -0700 (PDT)
X-Gm-Message-State: AOAM5334n58LSKdKFGwwTaZNM5DOloWuZLb4IuyA1HB/PbymqaaMf7ji
        ufTtlaSwSNiS8h4afMtvncN31VW+DElumS8G1l4=
X-Google-Smtp-Source: ABdhPJxQq74vo5JbuRHxUTS8m9tdD+iAtivYUG50MMcb53T1num8JutKqyxkzEWd0qSatAXELIL2sCltGdwuDe8hang=
X-Received: by 2002:a2e:8597:: with SMTP id b23mr561854lji.41.1599612940170;
 Tue, 08 Sep 2020 17:55:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200903054104.228829-1-hch@lst.de> <20200903054104.228829-4-hch@lst.de>
In-Reply-To: <20200903054104.228829-4-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 8 Sep 2020 17:55:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7ZtGruPhBWZpjCDoyq1DwoA3t_p3UXbSPrHGMnHh7enw@mail.gmail.com>
Message-ID: <CAPhsuW7ZtGruPhBWZpjCDoyq1DwoA3t_p3UXbSPrHGMnHh7enw@mail.gmail.com>
Subject: Re: [PATCH 3/9] md: compare bd_disk instead of bd_contains
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        linux-ide@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>,
        linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 2, 2020 at 10:43 PM Christoph Hellwig <hch@lst.de> wrote:
>
> To check for partitions of the same disk bd_contains works as well, but
> bd_disk is way more obvious.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <song@kernel.org>

> ---
>  drivers/md/md.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9562ef598ae1f4..3f33562d10d6f5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2322,8 +2322,7 @@ static int match_mddev_units(struct mddev *mddev1, struct mddev *mddev2)
>                             test_bit(Journal, &rdev2->flags) ||
>                             rdev2->raid_disk == -1)
>                                 continue;
> -                       if (rdev->bdev->bd_contains ==
> -                           rdev2->bdev->bd_contains) {
> +                       if (rdev->bdev->bd_disk == rdev2->bdev->bd_disk) {
>                                 rcu_read_unlock();
>                                 return 1;
>                         }
> @@ -5944,8 +5943,8 @@ int md_run(struct mddev *mddev)
>                 rdev_for_each(rdev, mddev)
>                         rdev_for_each(rdev2, mddev) {
>                                 if (rdev < rdev2 &&
> -                                   rdev->bdev->bd_contains ==
> -                                   rdev2->bdev->bd_contains) {
> +                                   rdev->bdev->bd_disk ==
> +                                   rdev2->bdev->bd_disk) {
>                                         pr_warn("%s: WARNING: %s appears to be on the same physical disk as %s.\n",
>                                                 mdname(mddev),
>                                                 bdevname(rdev->bdev,b),
> --
> 2.28.0
>
