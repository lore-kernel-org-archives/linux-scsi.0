Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CBCC5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 16:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6012087E
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 16:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MrFnY+1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390137AbfKEQSb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 11:18:31 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:36673 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390104AbfKEQSb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 11:18:31 -0500
Received: by mail-il1-f196.google.com with SMTP id s75so18750557ilc.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 Nov 2019 08:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rZbXs0ks5q9thpmkAf+NXg03w86YAdIB+dgzaOSSYBY=;
        b=MrFnY+1l063Skn6mdAg7BTDZ8Av963tSd2sbyFt/wrxN4Ehmv1lT6vwMgowDu5Nzss
         W4/SFApmxABt7WJ3jcrys10Zz5/EAELDS9yoGVJbUv8B80/PYPERuqD6uQYzHivIrroA
         b1KECbhMz1j2N2+SPi1GxET9Hr6S5qEwOlN3B8Ofs5Q80WN7WBIgs+Q0GnshZN1Buto6
         txJaFpHdBNUa33AUsI0tbQOCX2ociXeDzge+nIU1Ut+kXitxlawODkwVsuKBAbRnrKMt
         ezvD6EAdbnfrlk6Xx1AcXmU7L4vkiOBYcHd36XDjsiRBqns6WGHcRhteXZXvRxcbXQ74
         yOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZbXs0ks5q9thpmkAf+NXg03w86YAdIB+dgzaOSSYBY=;
        b=S9uWnOlOhNxtlW/QajlKESW2h4HAJ91CneThm6KQ/ZUfmYYUpRk/A3pNi0PWK3Ufkv
         8cEuKinXvD7IaLD2XG1sJO3lm6j1jyyaZtb0Z4eNVfXkoRFKlKFR43ItT+QPv76QnN5o
         PRqqiUieGkUKQ9SzVi33T7BQMw4VmJNA+VWPN5Qdjn2j5WKmKn8732aKCw3NhAZdCJZO
         XLByXqUNbTIyxVs9kVDmCMrtdILCGQamYHdZRBvJbdgCtJtSYbfpBf6LooECjXvdsycx
         nyuGxRqSdqPnyVJnHvR2DAGFz+dqzM7JQgQIwUCVLieh+h2SS7QZ6JKIE6cjrylvJ9K6
         Mmrw==
X-Gm-Message-State: APjAAAVilG0+1zwEmPs85q/nSv2i4kH1DTja8jiAqEMHlyGu0w7KqLzv
        AT28O5RVKFKXe6MHAoNP9iiO5ENSQML3QNoqcvE=
X-Google-Smtp-Source: APXvYqxKJ/5LrU3AOe0WjPlMGnmP93xUmkmRkAg2aZOVDNIKEUIbk2nvTCKHNyb3CssmgBXJF3scVA+wG9iGWAd2og8=
X-Received: by 2002:a92:ca8d:: with SMTP id t13mr7171235ilo.58.1572970709845;
 Tue, 05 Nov 2019 08:18:29 -0800 (PST)
MIME-Version: 1.0
References: <20191029230710.211926-1-bvanassche@acm.org> <20191029230710.211926-4-bvanassche@acm.org>
 <MN2PR04MB69914B9FA252E1B0A05493BAFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
 <MN2PR04MB6991FD5665C0C1E7DEF7854BFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB6991FD5665C0C1E7DEF7854BFC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Tue, 5 Nov 2019 21:47:53 +0530
Message-ID: <CAGOxZ51AHByBFsMiKG_-pGjVe4=1ijQnUipS=Gjq1pYPsCKQGA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ufs: Remove .setup_xfer_req()
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

On Mon, Nov 4, 2019 at 6:29 PM Avri Altman <Avri.Altman@wdc.com> wrote:
>
> As no response from Kiwoong Kim:
>
> >
> >
> > + Kiwoong Kim
Looks like he is not active here.
> >
> > >
> > > Since the function ufshcd_vops_setup_xfer_req() is the only user of
> > > the setup_xfer_req function pointer and since that function pointer is
> > > always zero, remove both this function and the function pointer. This
> > > patch does not change any functionality.
> > >
> > > Cc: Yaniv Gardi <ygardi@codeaurora.org>
> > > Cc: Subhash Jadavani <subhashj@codeaurora.org>
> > > Cc: Stanley Chu <stanley.chu@mediatek.com>
> > > Cc: Avri Altman <avri.altman@wdc.com>
> > > Cc: Tomas Winkler <tomas.winkler@intel.com>
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > Since this was introduced only a couple of years ago, Maybe better to CC the
> > author Kiwoong Kim <kwmad.kim@samsung.com> Before removing this
> > altogether.
> Reviewed-by: Avri Altman <avri.altman@wdc.com>

Let me check and reconfirm this, give a day or two.
It will be good if am copied to the ufs patch (I hope
get_maintainer.pl still pointout my email)
thanks

-- 
Regards,
Alim
