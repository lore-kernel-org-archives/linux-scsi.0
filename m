Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65A2C678D5
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 22:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCDWop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Mar 2023 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjCDWoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2023 17:44:44 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB8F1117A
        for <linux-scsi@vger.kernel.org>; Sat,  4 Mar 2023 14:44:42 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id e82so4968934ybh.9
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2023 14:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wi4QifgERwa5AVgTKR7nOPXsxBrSHQ8fL11+CaqhDD4=;
        b=Jiw/oxqIhxzUAN/Yy08zIctHAtzScMxgeodOlzgqled1K9yy2VDj3f5N073lyCxGfK
         EU6owtM0cN6hfgm7oXaMX5tEZzLaBqlZzHSsCJKBsXqbVsyeFu0mbiLrqwphnqlGcK0j
         LKvWKX+uFhdVMmLxORqMI+RHv8e0Si22PU7Sb+40qk+pNPr2djsNXZcxAPyLq8WQjF28
         VAtato4GN/ypwqCo7EHqT41yW1OaQ9BBul83DzcjtgnJJGVW0aYEVvfYFP+eVTrAI4G3
         uEvwng6KDOUUKyV9zUXUX+pHEOwJU0hjIFKr+ZF8B6jC3JiZTIfxfP3G1TGShJzGXLXJ
         ZLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wi4QifgERwa5AVgTKR7nOPXsxBrSHQ8fL11+CaqhDD4=;
        b=ufJIia0nj1ymODdnirdL1xUaGbSE3P3ZUkQdjSIaqbFqNlENWwTodEGPyH1pj6hZB0
         +YCB3Na0rMRQXJR1Yj+xpDaaD5pW2LF704gt7RcJy5Da0Lb/jfNwMDofIKpYLARwrHEW
         HsZ8oEoHfJsq1sZ1GhrVayjcdS3QSvONw9xzs1S+myQtGUd3yX8hsymqQ7JLJoyp29Gt
         M2WsCVV29Szpumx0dCpM9nvBFXjXV2mJJVC8O4fpMftQafK8K2qP5zEQ6xfbREh16BPd
         SyYwx7qDYVbrg+XXwOV7mzfWq4M4ECkYkr/v/0p4J9NQb57MXMZt6MCJPQTz7jQYJIsZ
         S/Og==
X-Gm-Message-State: AO0yUKWSoECx7OvRBK16T8pKiRAEeT1xicwYF8dMoVL4VBUAMtVP9jqb
        wNODCe/g9fhcHBuPBSVv0JuzVgTMnVTxYFC2QEyfuA==
X-Google-Smtp-Source: AK7set+fnJaosHn/7Vc/KOmstknBYTPW/nd3cW7Y9+GdTOLCEsm1zXL3If9DYLDKagAb+ChpzA7bfml1O2m4hwGAzyg=
X-Received: by 2002:a5b:b84:0:b0:ab8:1ed9:cfd2 with SMTP id
 l4-20020a5b0b84000000b00ab81ed9cfd2mr3619308ybq.5.1677969881909; Sat, 04 Mar
 2023 14:44:41 -0800 (PST)
MIME-Version: 1.0
References: <20230304003103.2572793-1-bvanassche@acm.org> <20230304003103.2572793-5-bvanassche@acm.org>
In-Reply-To: <20230304003103.2572793-5-bvanassche@acm.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 4 Mar 2023 23:44:30 +0100
Message-ID: <CACRpkdYJigG3GFygT1B6SDsSeM6muO+m19OZU0yvkc=J2=tR=w@mail.gmail.com>
Subject: Re: [PATCH 04/81] ata: Declare SCSI host templates const
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 4, 2023 at 1:31=E2=80=AFAM Bart Van Assche <bvanassche@acm.org>=
 wrote:

> Make it explicit that ATA host templates are not modified.
>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks reasonable.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
