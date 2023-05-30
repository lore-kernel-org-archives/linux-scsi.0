Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F34C77B73
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 13:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbjE3Nfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 09:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbjE3Nfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 09:35:41 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34472E5;
        Tue, 30 May 2023 06:35:38 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2af7081c9ebso47225901fa.1;
        Tue, 30 May 2023 06:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685453736; x=1688045736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kEycXkYKRLRpxEwUXtZ7ALwt5KCXp4fBeeC6hygqMU=;
        b=qTxyaglAvkzM6Pxye5rwyFxfQQDvXnVY5js+9godxnL2a1ZdlJeqNyQktc66fR2ZpO
         OG+JM3Qr3E7Sca7lCP8NlbMnr95lPPMdKC3/UYIhUYbWcPHwdp6Uopbno1JoTGzbwLeL
         YPGIrD1uoAFQlUZsbz6sIyjs/5VHyN2ujXfwOAk/7MxnzT7+eoOPYYm3YPA5VnFYXA/l
         lKX4lfsXECZqiXTiBRFjOsidTVUQ6EC1A4YHmA6xdR0EJUy87k65G7//rK4okyp7aSkV
         9mDfsf6XPGfpABYU5ymBhwh90mz1UGBCuxJTNEsN2VM6ouLE9ZAcQrfWtPrYnho5b+dy
         Lvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685453736; x=1688045736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5kEycXkYKRLRpxEwUXtZ7ALwt5KCXp4fBeeC6hygqMU=;
        b=GczffXyvRf81RnM5nl9DfrIul//i1dlb3XJW6xRrStea2OLnTc7b7HTeb0cCMZiGTL
         FjUZCSoj3rcFrqIj4iQ8jvH1FHAEWBdE2FLpSXKIcpGVsfUdQo6WhARJEUZUhj8Zj6RC
         cQ8amsGZcVXscGswctOSiW779EVtpguvCFjGBo4nRThF1glR3AGhPOYA+vJ4hlQe1wYH
         A5QzWUNlSvzAM1r3FPb61fOXFTo+FtatldkCZt+I500Ixg55BSPT+64YTCuqybEAdJK4
         e92gPBRM3YtgVliA/3t95FJEE47Y71QSfrHck9AVSL7BYWnYn+H1DEqGalkW0Esd1WCY
         PcHw==
X-Gm-Message-State: AC+VfDydw0rR/ES+4RzwSFy55+vuBy8OUiMEXTkmqN3hEv2aV6LZPiF5
        Ar3VnH+EUuOG0Wb3CQ4A7LIwSe4fAVZT0DxTCg==
X-Google-Smtp-Source: ACHHUZ7Vi0nd71flZWzb24MAnvs1nFjE3mGbWsNfiZdwsqrBpHuz496GJmDubGDwYF5FTyd3unJmUPr3miOjy1FU6OE=
X-Received: by 2002:a2e:834b:0:b0:2ac:66c8:3c4b with SMTP id
 l11-20020a2e834b000000b002ac66c83c4bmr727518ljh.11.1685453735886; Tue, 30 May
 2023 06:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230530075033.11006-1-avri.altman@wdc.com> <93839d61500f626e78f8c63b3a11b29ef4f17b11.camel@gmail.com>
In-Reply-To: <93839d61500f626e78f8c63b3a11b29ef4f17b11.camel@gmail.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Tue, 30 May 2023 21:35:24 +0800
Message-ID: <CAGaU9a-vanwZjyE_ygZKo-uEL0AOU4sW0hdQ5Ge=6sqZT8_34A@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: core: Do not open code SZ_x
To:     Bean Huo <huobean@gmail.com>
Cc:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 30, 2023 at 7:22=E2=80=AFPM Bean Huo <huobean@gmail.com> wrote:
>
> On Tue, 2023-05-30 at 10:50 +0300, Avri Altman wrote:
> > A tad cleanup - No functional change.
> >
> > Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
