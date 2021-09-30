Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD09DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DF0061439
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348676AbhI3HXl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:23:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348577AbhI3HXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 03:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7411361242;
        Thu, 30 Sep 2021 07:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632986518;
        bh=4j4qOttJx5l+/qKXLDHbRCWD4XE/N8LaFsjbbuu2rsQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jwFg/895RuUhWERS1imfC1lnOAeZw0dLJFe5DB0O8bZy4nDkKIGobN43U2SznZx1Y
         lNitu3jaWWqRNc9gTZ9UMpoPzuAY8R8bS2zPyAnuuHrvDenITCM197por5X/8fy3kp
         wXIf1kFr60UxJraCRzRgq800UD9q/dPwCxLrCnGKPR9WdsJofu5pX3uHJSbSshBipa
         CwjLHaoT9alWbG6Z9gxgfvfR44FR7RpUpwTlIufThCXUY4zRWMNO2wCx+7Keb6lHie
         xKljeAr7PBtakYpbgMxme/mnJ7knnZILoy47lO1NzIDlavRpWfZg18e/+ro2GtPCuZ
         ziA/8N1EI6tUA==
Received: by mail-wr1-f52.google.com with SMTP id w29so8358944wra.8;
        Thu, 30 Sep 2021 00:21:58 -0700 (PDT)
X-Gm-Message-State: AOAM530gYuexscJJhfF354a9g/umUTaDWvhIEo0AHyY8Cz4kYVkF6Kef
        edrggAKrffISUFPImXFVrY3NdxfBmGwtnh+rGCg=
X-Google-Smtp-Source: ABdhPJyIqDCpAPNyCZSQJ+mGxiy60RU5uthBQ+7IWWfFetKjjZQQsrln5rUXBrSwvZrIgzTuD9A4y0knnFJS3zl+6oA=
X-Received: by 2002:a5d:564f:: with SMTP id j15mr4315506wrw.336.1632986517097;
 Thu, 30 Sep 2021 00:21:57 -0700 (PDT)
MIME-Version: 1.0
References: <1631696835-136198-1-git-send-email-john.garry@huawei.com> <1631696835-136198-3-git-send-email-john.garry@huawei.com>
In-Reply-To: <1631696835-136198-3-git-send-email-john.garry@huawei.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 30 Sep 2021 09:21:40 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3U+yaRe+P68DMQy_37jog=9gz7-dkHT10Vev3FrvMYyg@mail.gmail.com>
Message-ID: <CAK8P3a3U+yaRe+P68DMQy_37jog=9gz7-dkHT10Vev3FrvMYyg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] acornscsi: remove tagged queuing vestiges
To:     John Garry <john.garry@huawei.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 11:16 AM John Garry <john.garry@huawei.com> wrote:
>
> From: Hannes Reinecke <hare@suse.de>
>
> The acornscsi driver has a config option to enable tagged queuing,
> but this option gets disabled in the driver itself with the comment
> 'needs to be debugged'.
> As this is a _really_ old driver I doubt anyone will be wanting to
> invest time here, so remove the tagged queue vestiges and make
> our live easier.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> jpg: Use scsi_cmd_to_rq()
> Signed-off-by: John Garry <john.garry@huawei.com>

A few thousand randconfig builds later, I actually came across
building this driver.

> @@ -1821,7 +1776,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
>         host->scsi.disconnectable = 0;
>         if (host->SCpnt->device->id  == host->scsi.reconnected.target &&
>             host->SCpnt->device->lun == host->scsi.reconnected.lun &&
> -           host->SCpnt->tag         == host->scsi.reconnected.tag) {
> +           scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
>  #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
>             DBG(host->SCpnt, printk("scsi%d.%c: reconnected",
>                     host->host->host_no, acornscsi_target(host)));

drivers/scsi/arm/acornscsi.c: In function 'acornscsi_reconnect_finish':
drivers/scsi/arm/acornscsi.c:1779:6: error: implicit declaration of
function 'scsi_cmd_to_tag'; did you mean 'scsi_cmd_to_rq'?
[-Werror=implicit-function-declaration]
      scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
      ^~~~~~~~~~~~~~~
      scsi_cmd_to_rq

I have no idea what this is meant to do instead, but scsi_cmd_to_tag()
does not appear to be defined in any kernel I can find.

       Arnd
