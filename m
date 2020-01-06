Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DCBC33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1700220848
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:39:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Xju51CLL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgAFQjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:39:21 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40280 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFQjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 11:39:21 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so49223637iop.7
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2020 08:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kWUb0VFlCqVHjIEdjYTXdUeigrnp3juVUGjQEzS9Mn8=;
        b=Xju51CLLH5UJbsp6hfg/Q9uiRhqRF5nPPFBcrxXzHQHjfUoU53lmzR49L3nuQGDibN
         J5JkBuZOGQmZRo+B4IjsH+AHUZkUwWYaSL1pbydTO82czrEPappF5AZ9fE53T3HPpgdb
         qaAcC1xOPflBipPgFPrNHT3XG+TlID1ET1aa9TSVNcuVwauCKmXTR2yt5cd6Acvr126r
         1u2Gh1taigMNWduFuY6twXkC6+7X7S7YoMoPlo4NDv/bgmXfzRLRgrr3A/qSvLj4GJzp
         CSs+t76T6hL4Eg+0SgjTaY9+Mlpc7frn965xXaTmC4UE2JpXZ2OpXiWTdB/QhlDLGddF
         Z1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kWUb0VFlCqVHjIEdjYTXdUeigrnp3juVUGjQEzS9Mn8=;
        b=JYmS2LYiYFlwoXFUiRt5NAKK/axFyRPr+0/Witv32qUNS5mSl3TBnFG+KyvPxfgwh3
         U6e24pOCkOv024tVbPy86WxXgHSyQsUUwhRLUHA/+ShptyUClhereoanOUri8XDWJJkH
         Ea6ciTprzntIc5tqY8FzeDfZyCM+VfErm63kEvCC+47Va3QO0LTVOILysgOD/f3wJ9rC
         x+G0gvMOdLMplKt5UaG3HKF5YeBXTviF3P+nuuqRP3DmzqYlMezGh8ZtRLdiaGbrbSQM
         Z4ehoXSjsG7vyZwDX2fSYPcNzkdzOSnNCTkDp7cE5KpivbOoG7SXnIJ/CdCfo7GA+e/2
         ymMA==
X-Gm-Message-State: APjAAAXP2zsILLzj9GzBN+KoLRTaCaQC8Fm2R1MNT+De8VORui9vU96m
        5Y5akhzuYDFlOwlyUgdCVQ7/OweZOoOc0todngzseg==
X-Google-Smtp-Source: APXvYqw9YyOY5KyqBlhy7+6xYeBApXHcjbUU7WAsP3IZdWo48oJWLsin1g0Ua/9SUlmoWb3Q7++rLW95cDlw4rC0fyo=
X-Received: by 2002:a5d:9158:: with SMTP id y24mr48069648ioq.298.1578328760552;
 Mon, 06 Jan 2020 08:39:20 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-9-deepak.ukey@microchip.com> <CAMGffEk6SpVkqCGSMUJwdscmbLTFVt_3g0-YD4MxB9d5_+i9iA@mail.gmail.com>
In-Reply-To: <CAMGffEk6SpVkqCGSMUJwdscmbLTFVt_3g0-YD4MxB9d5_+i9iA@mail.gmail.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 6 Jan 2020 17:39:09 +0100
Message-ID: <CAMGffEmAAJeq2q36W0+-wETnsws3MDiGTb_ZMOU9OPWrG7NSvg@mail.gmail.com>
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

On Mon, Jan 6, 2020 at 5:25 PM Jinpu Wang <jinpu.wang@cloud.ionos.com> wrote:
>
> On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
> >
> > From: Deepak Ukey <Deepak.Ukey@microchip.com>
> >
> > Added IOCTL functionality for GPIO.
> > The SPCv controller provides 24 GPIO signals. The first 12 signals
> > [11:0] and the last 4 signals [23:20] are for customer use. Eight
> > signals [19:12] are reserved for the SPCv controller firmware.
> > Whenever the host performs GPIO setup or a read/write operation
> > using the GPIO command the host needs to make sure that it does
> > not disturb the GPIO configuration for the bits [19:12].
> > Each signal can be configured either as an input or as an output.
> > When configured as an output, the host can use the GPIO Command to
> > set the desired level. GPIO inputs can also be configured so that
> > the SPCv controller sends the GPIO Event notification when specific
> > GPIO events occur.
> > Different GPIO features implemented:
> > 1) GPIO Pin Setup
> > 2) GPIO Event Setup
> > 3) GPIO Read
> > 4) GPIO Write
> >
>
> I think you can also implement lldd_write_gpio callback, so smp_utils
> can also control gpio, right?
This comment should go to SGPIO, patch09
