Return-Path: <SRS0=SK/U=5F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF77AC4332B
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 03:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7473320714
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 03:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KfWj2JdK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgCTD3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 23:29:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45332 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCTD3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 23:29:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id z8so3833319qto.12
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2020 20:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mx8CSjfM3QzDiWt+Bd9el4LsSLYXCJr0Hxa/QhlW4Y4=;
        b=KfWj2JdKX/TQ8e2Gf3T6gxsVJoqufM3KPgdYof1sPqC+VnhPH6lv4cjxgg8Yob0796
         fQWUV4f0f3hGsNjr9Y7GVvUigApKwHcdc1GlaVh1W0FIEWiyjlCoAbzNe7+TvkW5rOrH
         FOOyAcBUNiePHj3WYZh7NQ++eiL20EIvAf3fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mx8CSjfM3QzDiWt+Bd9el4LsSLYXCJr0Hxa/QhlW4Y4=;
        b=eSqDtpBJ8j+4HAeHPe1sgbKYCz1c6YknOPXt1AZLlQf1XV2ht/2WoLm3Ez2r1KB7QW
         jOy7UJqVt1yijDdTNcOponyCbP4/0/M7kTjI2NiOpNDX+69qU+32oBdr5USUNZM4D6TU
         CRBkoqCUyEhyk9vN3azXk7DJG+gV3eHilOyc7fIJpSXzsFUWNCzwitzYPnR/qnDrO7nv
         jPzJnjFJXPMR0PUfuyuWL2fxxDPrMGxopm2nGVg9wz17aXIDsQ8fxYHVLmziyzLM6NSc
         6j31OuEGnJ0xezNE88lrpHhaJ8c8HiW0iBwwQtTVpmNEKBQ7Syww4YBpYFiqkjr9QH1g
         AXsA==
X-Gm-Message-State: ANhLgQ0Xs2pVkn8gK7v2qXgJCnV18kC1321qZb9dcWESFZ0hwXiBtA7h
        6yD83ejDcnRDcApeEI9iTjOq1oN89G4zw2HJw7nWdpFmGAw=
X-Google-Smtp-Source: ADFU+vtdz1d3WIURIHr0u/0r9cLJW9LlRGVj3F5IR5gmdyOO8WU4hvdbNEnA+RfV9g7UO92Y4F6fWU+sVKNp06nLOg8=
X-Received: by 2002:ac8:7a9a:: with SMTP id x26mr6354001qtr.137.1584674969802;
 Thu, 19 Mar 2020 20:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1581416293-41610-5-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20200225184202.GC6261@infradead.org> <CAK=zhgoR0k+eoEMNznMGCF21eQMKT2UJ5vufCho4dXfHNFFV3g@mail.gmail.com>
 <CAK=zhgpXF=qcwhwpzsx44GDEJxFXLcZFSgO9cAXL8p2GjU0KoQ@mail.gmail.com>
 <CA+RiK67RquZitjQrh=yGcdunAOZaOhS90xGk3Mco2rm-ZHrEYA@mail.gmail.com> <20200319130923.GA26476@infradead.org>
In-Reply-To: <20200319130923.GA26476@infradead.org>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Fri, 20 Mar 2020 09:00:23 +0530
Message-ID: <CA+RiK66N_9wMXLwUTu1NK=u2JaFJmqTmYEymvugFgmjVGZ-=YA@mail.gmail.com>
Subject: Re: [PATCH 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4g region
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thank you,
We will post the patches in couple of days.


On Thu, Mar 19, 2020 at 6:39 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Mar 18, 2020 at 12:21:11PM +0530, Suganath Prabu Subramani wrote:
> > Hi Christoph,
> >
> > We will simplify the logic as below, let us know your comments.
> >
> > #use one dma pool for RDPQ's, thus removes the logic of using second dma
> > pool with align.
> > The requirement is, RDPQ memory blocks starting & end address should have
> > the same
> > higher 32 bit address.
> >
> > 1) At driver load, set DMA Mask to 64 and allocate memory for RDPQ's.
> >
> > 2) Check if allocated resources are in the same 4GB range.
> >
> > 3) If #2 is true, continue with 64 bit DMA and go to #6
> >
> > 4) If #2 is false, then free all the resources from #1.
> >
> > 5) Set DMA mask to 32 and allocate RDPQ's.
> >
> > 6) Proceed with driver loading and other allocations.
>
> Yes, please do.
