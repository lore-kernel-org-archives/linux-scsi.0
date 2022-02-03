Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62776C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Feb 2022 06:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbiBCGwk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Feb 2022 01:52:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46430 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiBCGwj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2022 01:52:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 758E7B82FE9;
        Thu,  3 Feb 2022 06:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC48C340ED;
        Thu,  3 Feb 2022 06:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643871157;
        bh=fz5MvNfRWNYgfn/SaRRyX+Dv+C+hsMQ9E+HgMk2p0Yo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XgTi4QIXP0nrNgiS3l/vbZEy9QNLACnlFB/LCCsgxHAuJ8AulBbrha57RqCwYJZKk
         bPYERgwxVoNQJi9IwUBTbO/kYZdRZb5vZmnztsBp23fkHo6nukPMaqRmzwB1va9w6n
         LkrHjUD3NB984RAcG8DsCJqJzd2ZOWvmqZ0YgB4cd6lXV+QAnhGQQkc5JXocLUaUdd
         bPjHowyOO+/4xmx7uNH4TXJwiRVAF7MbCEqy+IhmlDS1eVSSw24P7A6kLBxriwIKXO
         MkZYZGK2PJCQpoiEFUA43/Xsx/QiZ+yEQ6XXrgPfvm8bbRq/FMMVLi8tFRFfmHh8ZW
         wEOt895Ow3jxg==
Received: by mail-yb1-f172.google.com with SMTP id j2so6179795ybu.0;
        Wed, 02 Feb 2022 22:52:36 -0800 (PST)
X-Gm-Message-State: AOAM530Y459QjODSuwhn9cJzllYM1Bfqozg4w76djRde8lRkpb3LeMb5
        DNwO4uBj1ss5Ziic7NL+/Wvu+LPCoh3CkiKBQU0=
X-Google-Smtp-Source: ABdhPJwT3phjdGsczSBHcxGP9Ar1RLKOeEqejDhaQbncDZ931IS4vJZUSzbOC00341TfRRuL6JGmVXaIJjqZtSTMx0Q=
X-Received: by 2002:a0d:f742:: with SMTP id h63mr3233782ywf.410.1643871156127;
 Wed, 02 Feb 2022 22:52:36 -0800 (PST)
MIME-Version: 1.0
References: <20220203064009.1795344-1-song@kernel.org>
In-Reply-To: <20220203064009.1795344-1-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Wed, 2 Feb 2022 22:52:25 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4j+Y-EQvBo6qRHwNu4eupycxDr7Qy3yBe4L5ug0atAHw@mail.gmail.com>
Message-ID: <CAPhsuW4j+Y-EQvBo6qRHwNu4eupycxDr7Qy3yBe4L5ug0atAHw@mail.gmail.com>
Subject: Re: [PATCH 0/2] block: scsi: introduce and use BLK_STS_OFFLINE
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Kernel Team <kernel-team@fb.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CC linux-block (it was a typo in the original email)

On Wed, Feb 2, 2022 at 10:40 PM Song Liu <song@kernel.org> wrote:
>
> We have a use case where HDDs are regularly power on/off to perserve power.
> When a drive is being removed, we often see errors like
>
>    [  172.803279] I/O error, dev sda, sector 3137184
>
> These messages are confusing for automations that grep dmesg, as they look
> very similar to real HDD error.
>
> Solve this issue with a new block state BLK_STS_OFFLINE. After the change,
> the error message looks like
>
>    [  172.803279] device offline error, dev sda, sector 3137184
>
> so that the automations won't confuse them with real I/O error.
>
> Song Liu (2):
>   block: introduce BLK_STS_OFFLINE
>   scsi: use BLK_STS_OFFLINE for not fully online devices
>
>  block/blk-core.c          | 1 +
>  drivers/scsi/scsi_lib.c   | 2 +-
>  include/linux/blk_types.h | 7 +++++++
>  3 files changed, 9 insertions(+), 1 deletion(-)
>
> --
> 2.30.2
