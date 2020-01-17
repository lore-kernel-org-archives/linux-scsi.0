Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0057AC33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 15:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C63342064C
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 15:53:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="GncFoLWT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgAQPxi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 10:53:38 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44985 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgAQPxi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 10:53:38 -0500
Received: by mail-il1-f194.google.com with SMTP id z12so21623224iln.11
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 07:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s8a7YZ8PfwPZmWS58CNXp7O4j5LLlCUiGromruPiT8k=;
        b=GncFoLWTkGoboNeziHtgLKOOGLwjg64oVCrgTUW4YXvdc1OCHFYmv5PXiwMGod+aMI
         SCR583+FncEzmJlZ8/hkKdqqg7/KqaBv/aY1n0NjoWWErc+xTRZWWHallY32Bw6mE3r0
         7lHQbsapA2PKkJnvBEh4tYN5JpOzPfd4/zKc22LzMX/Sg4KhxxIIcH+ag9rII16aqxd3
         4eeuJYqBZPMLGRIS1OHwZNl4XfDNCuOMPACUh5Sf6jl7DgT7JN378xk1Mt6wNDBpzRP+
         Z3dg5f5xMTjTPxab458QvqhIYiLn2/Y/MrX06Xilw9XS7Vnn08XDya7WMwoI+yEe5BOO
         g49Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s8a7YZ8PfwPZmWS58CNXp7O4j5LLlCUiGromruPiT8k=;
        b=selJFp83dS9YPXl6mrr9uJ5iwQ8zyMCwpxbM1Kkp12gIxl5Z71DLQmnP07RwhQilXD
         bIUPKDD8TF0aZxWne6JrWmMNExjgfJxSCqig3Z2PMcHBFO+H4a0EmOI7axrvkgAhPwNr
         /8slWd48hS57rKVusvAazdXCePIAcv9MfcbENKhw73+ThFCRiIVk6pGKEnRWPnZt5CxY
         79ZZ+0nEbG3i86yRppR2RzzqxSZjQuKV/qrGPKHNctNof6DVSnqJmwX/jkmU3lQdJDfc
         CCs8tbLKSjDCmSUNIo4GbeANLDam6d8++3K2JHepuUgwLe78KCEacSUpKH6a5MPUvymx
         nEZw==
X-Gm-Message-State: APjAAAWQNHxAQ0XqAYZJmbqAIE5pyjTk9/67SDbRTC0jJ6AO49/0Un9+
        WL58NznQdfX54cDB7tzMG9WgqDHtwWaa0aUg/cfXsw==
X-Google-Smtp-Source: APXvYqyxWT/l6PP0S4HE8RDGzBw2rG17Wb7nfTgzlSsoVpN+s67BbZufDLbmwYofD8ffgGAiRFsXlzJF4hCvSLQyNyk=
X-Received: by 2002:a92:d2:: with SMTP id 201mr3671140ila.22.1579276417241;
 Fri, 17 Jan 2020 07:53:37 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-2-deepak.ukey@microchip.com> <CAMGffEmP+UfQS+9dUEjQvnJ0HZLRD-X_xJufRK_iQ8JTPQzb5A@mail.gmail.com>
 <MN2PR11MB3550076952E7D79D68385AF8EF310@MN2PR11MB3550.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3550076952E7D79D68385AF8EF310@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 17 Jan 2020 16:53:26 +0100
Message-ID: <CAMGffEnk-Vc-dgv8j-OeKG=jhu6bU8qTPvGm+t5aNuvn1mT2QQ@mail.gmail.com>
Subject: Re: [PATCH V2 01/13] pm80xx : Increase request sg length.
To:     Deepak Ukey <Deepak.Ukey@microchip.com>
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

On Fri, Jan 17, 2020 at 4:50 PM <Deepak.Ukey@microchip.com> wrote:
>
> On Fri, Jan 17, 2020 at 8:10 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
> >
> > From: Peter Chang <dpf@google.com>
> >
> > Increasing the per-request size maximum (max_sectors_kb) runs into the
> > per-device dma scatter gather list limit (max_segments) for users of
> > the io vector system calls (eg, readv and writev). This is because the
> > kernel combines io vectors into dma segments when possible, but it
> > doesn't work for our user because the vectors in the buffer cache get
> > scrambled.
> > This change bumps the advertised max scatter gather length to 528 to
> > cover 2M w/ x86's 4k pages and some extra for the user checksum.
> > It trims the size of some of the tables we don't care about and
> > exposes all of the command slots upstream to the scsi layer
> >
> > Signed-off-by: Peter Chang <dpf@google.com>
> > Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> > Signed-off-by: Viswas G <Viswas.G@microchip.com>
> > Signed-off-by: Radha Ramachandran <radha@google.com>
> > Reported-by: kbuild test robot <lkp@intel.com>
> > ---
> >  drivers/scsi/pm8001/pm8001_defs.h | 5 +++--
> > drivers/scsi/pm8001/pm8001_init.c | 2 +-
> >  2 files changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/pm8001/pm8001_defs.h
> > b/drivers/scsi/pm8001/pm8001_defs.h
> > index 48e0624ecc68..1c7f15fd69ce 100644
> > --- a/drivers/scsi/pm8001/pm8001_defs.h
> > +++ b/drivers/scsi/pm8001/pm8001_defs.h
> > @@ -75,7 +75,7 @@ enum port_type {
> >  };
> >
> >  /* driver compile-time configuration */
> > -#define        PM8001_MAX_CCB           512    /* max ccbs supported */
> > +#define        PM8001_MAX_CCB           256    /* max ccbs supported */
> Hi Deepack,
>
> Why do you reduce PM8001_MAX_CCB?
> --- PM8001 driver has a memory limit in the machine.
which limit, do you see allocation failure from kernel?
Thanks
