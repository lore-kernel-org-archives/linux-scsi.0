Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D40C33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 08:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AF55207FF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 08:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="WXlijKvd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgATIr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 03:47:56 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43061 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgATIr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jan 2020 03:47:56 -0500
Received: by mail-io1-f65.google.com with SMTP id n21so32789512ioo.10
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2020 00:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=45OjGudlWaXok/cdD/HwtnRxT8v+59RQgWY57OUSY6k=;
        b=WXlijKvdwcsjT9M+ymEz1I3X4FSTjggUSgD0iQelB2TOGA+IJFJww0fEGqoh7JLGTp
         RtFTvr6yivajL6BQQGBSWDgHHLiJv1KvSYKgoGvk1ZxXaUFdke5ANYQEXUc0EfWbfzBf
         BzlMdbXgvvsSMxf2A112S3CPMnvA7MU8voAd2vXLR1JLXAFdgB3GAoSf4mhFNQkCiMzv
         X/YX7/XAtfIZSa3+WBRZY5jdbYz01EkGv5RTieQeL/29P+VDIENza5GiFOtir4N+mFjn
         QEAWk6YckotnkKTSE6HK12sSu+Bs22mwoXbxqmW0dFHDn61hAjBX8UEgiZpcBAjc17eB
         XOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=45OjGudlWaXok/cdD/HwtnRxT8v+59RQgWY57OUSY6k=;
        b=G111K2KNjfzpFtWSBTNiD4/86vOUxZ6aifH0tzSLkTnpPHN7Qc5glqXA48bkW4KEEE
         u4mwRLFUeqPgXNROowGnavK3lNs2nz6wWdkGKBmMoGBABRn3ZC8dlTeBM69nIQ4UKFTV
         fQX28Ay4Bw6OLQPmOWF6AaZC45g3uDbQPJOlJHT5MidlUwgvOeThR20OP7oK5Kbfc79+
         Gd8hCyUJOeiPpF3DNAtB/6qlQF83SazxB2U1BuGjoLXZawrfEjazcRCblVQ58WVi8eFi
         veZuMse6InDuFki3GW+vpd5VabVDe5LGfIaJpfZVjYyD+O8Y0w/6jPSuHff2d8MXzmpw
         J02Q==
X-Gm-Message-State: APjAAAWctaaV8e+jr9kiF+5avV+0EshkH2gHIhF57CtiOlhlsucutNfj
        fzLgjD6nbw8iYuRI3xY+D9iknmGZBOzkH4AqgvHIKQ==
X-Google-Smtp-Source: APXvYqxX8Z8+RjrJWPCQoJlhucj0ACIE1G/ePNndPoKtLStBArxLjV6IzTfAx+U2yG0Z2zTNciq/8Y3qAnQ9qvDIJVw=
X-Received: by 2002:a02:a610:: with SMTP id c16mr42406406jam.13.1579510075245;
 Mon, 20 Jan 2020 00:47:55 -0800 (PST)
MIME-Version: 1.0
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
 <20200117071923.7445-2-deepak.ukey@microchip.com> <CAMGffEmP+UfQS+9dUEjQvnJ0HZLRD-X_xJufRK_iQ8JTPQzb5A@mail.gmail.com>
 <MN2PR11MB3550076952E7D79D68385AF8EF310@MN2PR11MB3550.namprd11.prod.outlook.com>
 <CAMGffEnk-Vc-dgv8j-OeKG=jhu6bU8qTPvGm+t5aNuvn1mT2QQ@mail.gmail.com> <MN2PR11MB3550731E829140B5EC3F0E93EF320@MN2PR11MB3550.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3550731E829140B5EC3F0E93EF320@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 20 Jan 2020 09:47:46 +0100
Message-ID: <CAMGffEnF-ZUz95kYOqZU5kfmRY8oBZnfvi0=+G9PNA032+x_oA@mail.gmail.com>
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

On Mon, Jan 20, 2020 at 5:20 AM <Deepak.Ukey@microchip.com> wrote:
>
>
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
> On Fri, Jan 17, 2020 at 4:50 PM <Deepak.Ukey@microchip.com> wrote:
> >
> > On Fri, Jan 17, 2020 at 8:10 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
> > >
> > > From: Peter Chang <dpf@google.com>
> > >
> > > Increasing the per-request size maximum (max_sectors_kb) runs into
> > > the per-device dma scatter gather list limit (max_segments) for
> > > users of the io vector system calls (eg, readv and writev). This is
> > > because the kernel combines io vectors into dma segments when
> > > possible, but it doesn't work for our user because the vectors in
> > > the buffer cache get scrambled.
> > > This change bumps the advertised max scatter gather length to 528 to
> > > cover 2M w/ x86's 4k pages and some extra for the user checksum.
> > > It trims the size of some of the tables we don't care about and
> > > exposes all of the command slots upstream to the scsi layer
> > >
> > > Signed-off-by: Peter Chang <dpf@google.com>
> > > Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> > > Signed-off-by: Viswas G <Viswas.G@microchip.com>
> > > Signed-off-by: Radha Ramachandran <radha@google.com>
> > > Reported-by: kbuild test robot <lkp@intel.com>
> > > ---
> > >  drivers/scsi/pm8001/pm8001_defs.h | 5 +++--
> > > drivers/scsi/pm8001/pm8001_init.c | 2 +-
> > >  2 files changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/scsi/pm8001/pm8001_defs.h
> > > b/drivers/scsi/pm8001/pm8001_defs.h
> > > index 48e0624ecc68..1c7f15fd69ce 100644
> > > --- a/drivers/scsi/pm8001/pm8001_defs.h
> > > +++ b/drivers/scsi/pm8001/pm8001_defs.h
> > > @@ -75,7 +75,7 @@ enum port_type {
> > >  };
> > >
> > >  /* driver compile-time configuration */
> > > -#define        PM8001_MAX_CCB           512    /* max ccbs supported */
> > > +#define        PM8001_MAX_CCB           256    /* max ccbs supported */
> > Hi Deepack,
> >
> > Why do you reduce PM8001_MAX_CCB?
> > --- PM8001 driver has a memory limit in the machine.
> which limit, do you see allocation failure from kernel?
> -- I think it depends on machine's capability. For our machines, PM8001_MAX_CCB = 512 caused kernel installation failure. I saw it when I was debugging ncq feature
> Thanks
Ok, would be helpful to put this info to commit message.

Thanks
