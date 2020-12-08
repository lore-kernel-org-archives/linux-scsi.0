Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AE3C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:52:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5D0823A22
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbgLHMwW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729628AbgLHMwW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 07:52:22 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70FCC0613D6;
        Tue,  8 Dec 2020 04:51:41 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id w3so15047085otp.13;
        Tue, 08 Dec 2020 04:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fe2ylER8h1cw68YtAMio0l7iwwpZ3eJfPjG2Lzvgtbw=;
        b=ZsmLP/dE4ndxSVy2aGCTiIFyyFFXjG42tmWus5mQMQSRKN1OGQ0FfA5H/V8NCm1C4M
         fFf2VEP9d0CUFlrWd/vF6mqPeUXVglDwqZT+mOYmP6Yi9g6KrOvAUzeBOvmHwK54vljW
         X4FGdHtgW6b5f9rksATj94OTScdCNYh9htRoI6jhi3o7hS7cxwmMk6UDUwJ7jO7O9vzL
         AKK7vsVceKF8wju2JGow2Az2oGGeKohJwpKz/RF3AkgRcQAY4RdG0Q5S54Po4y6XWvxN
         60LazJWcGGxAYJTb0sG5Qcsez9smZkPmz5KXNFHuVccRzuUlao+9RhoaqljpQQxGM1rw
         EhDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fe2ylER8h1cw68YtAMio0l7iwwpZ3eJfPjG2Lzvgtbw=;
        b=qNyR49fcwdvZ+ELww6yMlbd2tleMuH+rg983z4SBrJj8Kvqa/irRU+95zB60Nc1sct
         rFe/1GQpn3PdhT2olt63p1zSXBT/QNAUJTcwfDAG7sacGAfu2hNOKlhQ7KX2DvurknAA
         5trjU9VLEnZkGgDCdcu1Fb4C8unh6OiHbEar0VPIJ86pA1SD5xI4v1Krv55dAlB11mea
         Q9MtdCysCPcdNGcI/HPPHHZlZRzh2r5KpTb49H+zXWvYX/qWiEIwizCShPb5qLl8CvWG
         4Sr1gHxeLUkFeedjgn5ppFc47Rdaq5tGE8a7XijixsUSxpq5bTBefkA6AHF6+zOsPjJA
         bdrQ==
X-Gm-Message-State: AOAM531GcDsyos4YC7hz2AE9JeJYc13MTtoANq8BR7Pj20Q+EEmU2mEo
        rTTqiF+AGur9GB2sxzVmismVVl3xSfarlpR6P2tmF4Ht
X-Google-Smtp-Source: ABdhPJwhuhkWWT+E3H0LAfQJb0n/kKHiMqVU6t3lNfugxONFVVvMDu1aJByybREXFcvRUzyQjlvKYNfpK1m5qHRCmyc=
X-Received: by 2002:a05:6830:22eb:: with SMTP id t11mr17238570otc.114.1607431901402;
 Tue, 08 Dec 2020 04:51:41 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <20201206055332.3144-3-tom.ty89@gmail.com>
 <2eb8f838-0ec6-3e70-356b-8c04baba2fc4@suse.de> <CAGnHSEk0C6VNQysGiysPS1yEXwu4U8PVCaVB2RR7oEgnr4Xz=w@mail.gmail.com>
 <4304d959-9155-3126-a858-28b338968916@suse.de> <CAGnHSEmMB5bfkCqyk=USHnmFr+Z1HA9UQ8whBD08K1hwvM2Scw@mail.gmail.com>
 <b18fa5df-2a18-e29c-911b-483dcb451f06@suse.de>
In-Reply-To: <b18fa5df-2a18-e29c-911b-483dcb451f06@suse.de>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 8 Dec 2020 20:51:30 +0800
Message-ID: <CAGnHSE=EXK9H_OzNdBEwQQuQgamCpSSQW76jTLb1ZCzq8ksLnA@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: set REQ_PREFLUSH to the final bio from __blkdev_issue_zero_pages()
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 7 Dec 2020 at 00:05, Hannes Reinecke <hare@suse.de> wrote:
>
> On 12/6/20 3:14 PM, Tom Yan wrote:
> > On Sun, 6 Dec 2020 at 22:05, Hannes Reinecke <hare@suse.de> wrote:
> >>
> >> On 12/6/20 2:32 PM, Tom Yan wrote:
> >>> Why? Did you miss that it is in the condition where
> >>> __blkdev_issue_zero_pages() is called (i.e. it's not WRITE SAME but
> >>> WRITE). From what I gathered REQ_PREFLUSH triggers a write back cache
> >>> (that is on the device; not sure about dirty pages) flush, wouldn't i=
t
> >>> be a right thing to do after we performed a series of WRITE (which is
> >>> more or less purposed to get a drive wiped clean).
> >>>
> >>
> >> But what makes 'zero_pages' special as compared to, say, WRITE_SAME?
> >> One could use WRITE SAME with '0' content, arriving at pretty much the
> >> same content than usine zeroout without unmapping. And neither of them
> >> worries about cache flushing.
> >> Nor should they, IMO.
> >
> > Because we are writing actual pages (just that they are zero and
> > "shared memory" in the system) to the device, instead of triggering a
> > special command (with a specific parameter)?
> >
>
> But these pages are ephemeral, and never visible to the user.

What do you mean by the "user"? What I meant was, since it's no
different than "normal" write operation, the zero pages will go to the
volatile write cache of the device.

>
> >>
> >> These are 'native' block layer calls, providing abstract accesses to
> >> hardware functionality. If an application wants to use them, it would =
be
> >> the task of the application to insert a 'flush' if it deems neccessary=
.
> >> (There _is_ blkdev_issue_flush(), after all).
> >
> > Well my argument would be the call has the purpose of "wiping" so it
> > should try to "atomically" guarantee that the wiping is synced. It's
> > like a complement to REQ_SYNC in the final submit_bio_wait().
> >
> That's an assumption.
>
> It would be valid if blkdev_issue_zeroout() would only allow to wipe the
> entire disk. As it stands, it doesn't, and so we shouldn't presume what
> users might want to do with it.

Whether it's an entire disk doesn't matter. It still stands when it's
only a certain range of blocks.

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
