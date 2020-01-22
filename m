Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E848C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 08:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E0682253D
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 08:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Zqokv9zN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAVI73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 03:59:29 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44291 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgAVI73 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 03:59:29 -0500
Received: by mail-io1-f68.google.com with SMTP id e7so1204085iof.11
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 00:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KVa7WJGPgltDwCBat5YNbEXwy/XjfdXnK0iTgFv8atw=;
        b=Zqokv9zNuu3PWlZvB0s3lwoks10hWBLmW2BCkojQthMzqsH5H/sdCvdv7qkVBLmTYZ
         JWNY+2YN7OT06fD5F3JKzUJn3s5Etrl5TEAttCz+EXnxE3+rtZQc1ypyWDbbcKEqBB47
         pkssgYVshuniNa2jA+RX5+3JKptRDHGKBlveRiql30b+0rOIcJCffeaia/hqeNTCDfE0
         2ldN+sGtlOdbyR2zMkagoQvo0mJ7oeA7quCvNfjVFFHNmvd4GOqWbKscA6Ki6cXIX1wr
         qA+ZNqqQufTOcasX+IflI3CeDJv2AevcMG9ouK+fNGzj8oUhuc4cIL0V/b3meuMq1LFx
         Wa4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KVa7WJGPgltDwCBat5YNbEXwy/XjfdXnK0iTgFv8atw=;
        b=p1Oit9obpCtWNXIvfifK+f37fkLXIUHUFfPhcHd3KMWd7OvfE435RpJOI3hNyDFYaq
         787Pl3UQsxQRb/Rhh7QtqOsth5+xEwWEjIayiceYAJMuoOUSHX3X5bAkzmLU+TRoPb62
         RMdSrX0TTgjWwkJQXy8eKnKCH5ejtV3A8OpdO5rFLCqBwI0XXIab8wq9wcLpWt7P8MrN
         rgnSZuEBHhRFDcga7z9Zv6iQ4J2B1vS9oAnYQBji850ugtHe4ioRDVS3CI2Vcn+uP4LV
         ScDkrGNKRJ493i8lh6xjcKQ1wU0Jd6YQsfYuOCMRDPSnpekS1Y/QqiVOz73rSHwSK1Ey
         puzQ==
X-Gm-Message-State: APjAAAWgZRTI2QLmVcuQw8tX7bk4h8CwnrHTlpEfDhJX0ILZNRG1xnLD
        FIjt0RnkaCSvtqTNj8KghMot8sWLOrmN32jKpQYBLA==
X-Google-Smtp-Source: APXvYqxxBrr4rF5SdpHfNyJbj88WDzkUC88umVXr9k3S4K/dY6U475lZjaQc79+TELefjV0lOZ24iBcBY6oNFVR1ya0=
X-Received: by 2002:a05:6638:72c:: with SMTP id j12mr6542900jad.136.1579683568875;
 Wed, 22 Jan 2020 00:59:28 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com> <20200117071923.7445-11-deepak.ukey@microchip.com>
In-Reply-To: <20200117071923.7445-11-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 22 Jan 2020 09:59:18 +0100
Message-ID: <CAMGffE=XWevtZLtOxyNx1SYdiEtgRNrzgv=wmvZtdfCYT=WP6w@mail.gmail.com>
Subject: Re: [PATCH V2 10/13] pm80xx : IOCTL functionality for SGPIO.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 8:10 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added the IOCTL functionality for SGPIO through which management
> utility can controls SGPIO LEDs on the enclosure of locally attached
> drives only. It is used to read from/write into SGPIO registers and
> sets one or more SGPIO registers.
Hi,
Thanks for addressing my comments.
another question:
Is it enough to only hook lldd_write_gpio without IOCTL to control SGPIO LED?

Thanks
