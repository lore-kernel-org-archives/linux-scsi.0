Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91659C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 07:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7089222BF5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 07:28:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="grB6UQKQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGUH2V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 03:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgGUH2U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 03:28:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E6FC061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 00:28:20 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id w6so20635692ejq.6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 00:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=44wuaBEOUot0941ibxm8p3e5OFnjQ2Akvsh/COI+pqY=;
        b=grB6UQKQeAAKWvdyU2ARGNkvij/HMuag/XPCNMMXobLg0KQ+OXuCvGfAp/mx8pxaMK
         na6A2wRDM8sdnJZ1P7MJEFkooO+qlMGUTk+U4z2jvGPq58dSb6ECwSTm64ASTzOA+TLa
         Lt2rZti3mKuWJvOdb87RlklT+HlNLp+lOBbxl8HxwDkC8+mCouUy++h06KkVA1H/7IF1
         1tGDA5HEOya4fm3sqVh+f5HyM2M3Z0/SVgyR0xnSq/7cj5CrNzVuvdYNMBBYD2QC/+Bp
         ysE705xu1C3ni2gFGEyEYIlV4Qi0IQQc7j3mPrr9qmMLgSDL5DoNVjwT51AZTURTDEBw
         UlKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=44wuaBEOUot0941ibxm8p3e5OFnjQ2Akvsh/COI+pqY=;
        b=gTecGhzrm+lwvxROrpSHZfuHn3DmLJBbTPZ0aYmUA8KM8uLFNHETHOV34icFOoOVKx
         AnZzoiTv80WBrfYFAzRR9Ik2ceVEDGhDOw3J26JZ6YyWo/mgD7oFl9FhMR7UV9DVq3XJ
         899LmOfQhvhmElf0+6NV/im8XvhJPjIjKdPTxR2OLWaVAKsPXy/uofpDcw8eOWlArdpy
         ON1hYDoHjJLraDYRF1UNvcl0vZ/X11ion9VRk0aTQbU5U0V8R82D+o9EQw7H7EFI/lTC
         Hzs6V4Dyuy/8Aje0tiwU3xVJv58yyiC46U8CAoNfz2lFR178Gj2VL4H6KzycDiO5SFUZ
         5zZA==
X-Gm-Message-State: AOAM5304wO7Vezxgg4cSvtTtObuEeejiavmWIOBun1T/LiexeihlhiRf
        Qogoas/tWULoHcDoV1IDnQVkhewWfx1HsYNuhQV3sw==
X-Google-Smtp-Source: ABdhPJxlagwmgaGZeMOBcGA2rsRqdSbVgYJ2QYHsSME+zOyUAP1od3dmEGFsqS6NSHUa0Kwd8X5OcSqEK63fwI/thQw=
X-Received: by 2002:a17:906:e294:: with SMTP id gg20mr23303804ejb.521.1595316499093;
 Tue, 21 Jul 2020 00:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200720135303.6948-1-deepak.ukey@microchip.com> <20200720135303.6948-3-deepak.ukey@microchip.com>
In-Reply-To: <20200720135303.6948-3-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 21 Jul 2020 09:28:07 +0200
Message-ID: <CAMGffEk3pj4bSaJAZp5oBEy4Pp0MRQKdhJE-DsyY1C147tFLkA@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] pm80xx : Staggered spin up support.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jinpu Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 3:43 PM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Viswas G <Viswas.G@microchip.com>
>
> As a part of drive discovery, driver will initaite the drive spin up.
> If all drives do spin up together, it will result in large power
> consumption. To reduce the power consumption, driver provide an option
> to make a small group of drives (say 3 or 4 drives together) to do the
> spin up. The delay between two spin up group and no of drives to
> spin up (group) can be programmed by the customer in seeprom and
> driver will use it to control the spinup.
>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Deepak Ukey <Deepak.Ukey@microchip.com>
> Signed-off-by: kernel test robot <lkp@intel.com>
Thanks,
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
