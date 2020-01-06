Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B929C33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66EA42075A
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:25:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="dUvHnQfr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgAFQZb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:25:31 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37289 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFQZa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 11:25:30 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so18839541ioc.4
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2020 08:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQWLANc4WOoFGEzefMvi7nCheJcbXElxmNDS3b9Y34I=;
        b=dUvHnQfrRF5b8XzCtB12RkvZB5sme7YoF4JWJxhjOy4t57DMbMgamr/xz7hqMkDmCn
         MDFsiMEdaUap98imvi6RTwQNHl78DReLowKgW3VzWwL1aDC/b0NCthFMew9ZVtLQp0pJ
         Fzx0yMbj95A7zCWuvcEQlQjlOQjf+gSeWqMWQNssuldiPSgtpGesqwYydRi/CfDweWIq
         QKrdAwOw7obdL7Ia2+NlisfoqI2r34i5Eqv2iki3XeBMxGkUwAnxKn3ATRBsQO4xjT1n
         Y1bWH3LultcRKVCLhn+pYQDOufjpfdSXRAi/3qQ6f+W7qZwzl/ddISWVi7xhJMkuuTPL
         ckfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQWLANc4WOoFGEzefMvi7nCheJcbXElxmNDS3b9Y34I=;
        b=gmDMScJD0PDw+A9I1rVcxq6WrIdlFgSQVaBbrsUuqUIWc5rkT+y0dIPDeX/wRnbst8
         g8SVVlvldTL+iZOucNqgTzuo0GDwOa7eB7pAo/M/D9WCiXvgcpmVh30b+j7ahPz3CThq
         R8KKL0j813O5jCyM6o8CQFT0rfnh6iIPvgi6EEjbvY1c7MKzMmiV28u8f6Jo9evDzs8B
         u1zUEcnApVMLyXexj2kuCBQ/2nGE61X9oRhHEQBM472pBq/o8V3NQGMg1ROf8gBoK8ZG
         s6P00jibpLfXSEET1vK7TQMeXJZY/L2PXZVZsbT7+nt0qGODm+7bx2UZfjCkb9orzZh+
         3/xw==
X-Gm-Message-State: APjAAAVL3QoBNgDNElc0WsfM2fzMVu06mQaR5jXO4KBJWNylzV/f1EWA
        sV42c6zgpRipMiHS1w7iU0RDrcZlG2gpHnAwrNOEkw==
X-Google-Smtp-Source: APXvYqxwaE4hlcgERGGToiNLuvoCt1D2p41icQ4UN+ynWO/8l7Wbg+Af3w5/DjnC3EcvcGiJrPqBM1GJOFtKaLUZVFY=
X-Received: by 2002:a6b:6e02:: with SMTP id d2mr70774902ioh.22.1578327930210;
 Mon, 06 Jan 2020 08:25:30 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-9-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-9-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 6 Jan 2020 17:25:19 +0100
Message-ID: <CAMGffEk6SpVkqCGSMUJwdscmbLTFVt_3g0-YD4MxB9d5_+i9iA@mail.gmail.com>
Subject: Re: [PATCH 08/12] pm80xx : IOCTL functionality for GPIO.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added IOCTL functionality for GPIO.
> The SPCv controller provides 24 GPIO signals. The first 12 signals
> [11:0] and the last 4 signals [23:20] are for customer use. Eight
> signals [19:12] are reserved for the SPCv controller firmware.
> Whenever the host performs GPIO setup or a read/write operation
> using the GPIO command the host needs to make sure that it does
> not disturb the GPIO configuration for the bits [19:12].
> Each signal can be configured either as an input or as an output.
> When configured as an output, the host can use the GPIO Command to
> set the desired level. GPIO inputs can also be configured so that
> the SPCv controller sends the GPIO Event notification when specific
> GPIO events occur.
> Different GPIO features implemented:
> 1) GPIO Pin Setup
> 2) GPIO Event Setup
> 3) GPIO Read
> 4) GPIO Write
>

I think you can also implement lldd_write_gpio callback, so smp_utils
can also control gpio, right?
