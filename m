Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD96C38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 07:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiJYHsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 03:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiJYHsp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 03:48:45 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0D915DB05
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 00:48:43 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x3so54246qtj.12
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 00:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IRtShTQFXnZKBeiyqT/wXuyAkjNFDOcQJvNMzW4Psxk=;
        b=aQMIYFP2H7QRAL4k/6Ss/P0F+PjkLQ0U9xBdZf+06Tl0dUaBgeJIagYzMyo33nMCRN
         52cmFFllcMTl33jB1X0WDD8lkrP0lXyc8Tl0WWWfYrxDwJivskcI2rywztlbTxrmbqdv
         YGIka9yhzSyFppQhX1FrEO+sHYXLwrH2oldmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IRtShTQFXnZKBeiyqT/wXuyAkjNFDOcQJvNMzW4Psxk=;
        b=bkYniLsJyU7RSJHhenwhZd02xs5CAqlmoK9QPuOEho5Wh1c319ngPvLaSX+UfQfDGa
         Lmw1TlvgsWllZn53jwvgQ/tzCIuvrkDRpMirhHiiCXO2A8ByexIF/SvJrB/F/EMyZrwC
         oK87ITLT9h8GygtASJmyJlxOBll6a/b+g2xg4iseG1tWVNedqvNWA3em/GZ6suDD1Y0x
         LmKj7+x8VTIRpzwtLnix5ndqHGNZhk4Cdg9kOgJZbfNpMm1VuHtEPfs8Lljwt4lPDQ2u
         NXVDWfzWoy1sP7GX+PkqQi83YueLwq6w1XlVwbFqfYLbYEHwVmyDw0SAfb/Gtvob9aql
         VLfQ==
X-Gm-Message-State: ACrzQf3Qzq8QQHlwNQItlrGoELMX2UlcSDf7gij7RTZ7z0F8g57t6+Dd
        OO8ejFS8j4A8yzCHZh0GspTvJ8tVtmfdmQ==
X-Google-Smtp-Source: AMsMyM54ijShHQSZZfvtaWoxyvjTmMvWUVZ12dCL0mcZL5WqWrtE0sZbsvGQzy236WbA3DwsJ5tUBg==
X-Received: by 2002:ac8:57d0:0:b0:39c:f3a8:7c78 with SMTP id w16-20020ac857d0000000b0039cf3a87c78mr30812420qta.470.1666684122133;
        Tue, 25 Oct 2022 00:48:42 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id u4-20020a05620a454400b006ce2c3c48ebsm1563188qkp.77.2022.10.25.00.48.41
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 00:48:41 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id j7so13607406ybb.8
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 00:48:41 -0700 (PDT)
X-Received: by 2002:a25:bb44:0:b0:6bb:a336:7762 with SMTP id
 b4-20020a25bb44000000b006bba3367762mr31671491ybk.501.1666684120706; Tue, 25
 Oct 2022 00:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <4a450f81-b7e0-31e8-e8bb-03a1c87e829a@suse.com>
In-Reply-To: <4a450f81-b7e0-31e8-e8bb-03a1c87e829a@suse.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 25 Oct 2022 00:48:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com>
Message-ID: <CAHk-=wjaK-TxrNaGtFDpL9qNHL1MVkWXO1TT6vObD5tXMSC4Zg@mail.gmail.com>
Subject: Re: Inconsistency in torvalds/linux.git?
To:     Juergen Gross <jgross@suse.com>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 24, 2022 at 10:42 PM Juergen Gross <jgross@suse.com> wrote:
>
> I'm seeing a strange inconsistency in torvalds/linux.git:

Not really an inconsistency, just an artifact of how git works.
Admittedly surprising once you internalize what's going on.

But you have most definitely found a merge mistake of mine, which is
why you see that behavior.

Let me explain:

> Commit e0e0747de0ea3dd can be found in "git log" output,

Right, the commit is very much there, as you can see when you just do
a full "git log" and look for it. No question about that.

So then the question becomes "why don't I see it when I do xyz":

> but according to the source it is not applied. It isn't found either when looking at
> "git log drivers/scsi/mpt3sas/mpt3sas_base.c", in spite of this being
> the source modified by said patch.

So this is a pretty fundamental git thing: when you do something like

   git log drivers/scsi/mpt3sas/mpt3sas_base.c

what you are actually telling git is "show my the _simplified_ history
as it pertains to that path".

That's basically how all the git log commands work - it always starts
out with the *full* history, but then you can simplify that history
different ways.

Those simplifications range from the trivial, like using --grep to
only show commits that match a certain pattern, or being based on
dates, or obviously commit ranges.

And one of the more subtle one is very much using a pathname limiter
to only show commits that are relevant for a certain directories or
pathnames.

And it's subtle because that simplification is *very* aggressive, and
will literally prune away any history that is not relevant to that
pathname.

And it turns out that in the current -git tree, commit e0e0747de0ea3dd
is indeed no longer relevant to the history of that file, and as a
result gets simplified away.

Now the "Why?" is the meat of it.

Here's the details:

 - I merged that fix Sept 22 in commit bf682942cd26 ("Merge tag
'scsi-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")

so when you do git log of *that* state, using

       git log bf682942cd26 drivers/scsi/mpt3sas/mpt3sas_base.c

you can see that commit in the log, and you can also see the effect of
it in that tree if you do something like

    git show bf682942cd26:drivers/scsi/mpt3sas/mpt3sas_base.c

but as you go through the history, you 'll have seen that

 - my next SCSI merge is Oct 7, commit 62e6e5940c0c ("Merge tag
'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi")

and if you then for *that* commit do that

    git log 62e6e5940c0c drivers/scsi/mpt3sas/mpt3sas_base.c

the commit you were looking for is no longer there!

Why?

It's because through that pull, I got commit 9df650963bf6 ("scsi:
mpt3sas: Don't change DMA mask while reallocating pools"), and it
conflicts with the other fix.

And I mis-merged that conflict, taking the new version of the file
entirely from the new SCSI pull. As a resulkt, when you look at my
merge, you don't see any conflict at all, because my merge was
basically "take the version from the SCSI tree".

Which was obviously wrong. The merge resolution *should* have looked
something like this:

-       if (ioc->is_mcpu_endpoint ||
-           sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-           dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
+       if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
 -          dma_get_required_mask(&pdev->dev) <= 32) {
++          dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32)) {
                ioc->dma_mask = 32;

but I messed up, and took the version directly from the SCSI tree, not
realizing that the *new* SCSI pull didn't have the *old* fix that I
had already gotten two weeks earlier.

So this then had two effects:

 (a) the tree obviously lost the one-liner fix

 (b) git now sees that all the contents for that file comes entirely
from that side of the SCSI merge, which is why it simplified away all
those other commits that had no effect on the end result.

So this is not a git inconsistency, it's just a merge error on my part.

Thanks for noticing, and I'll also Cc this reply to the linux-scsi
mailing list so that I can link to this longer explanation in my fix
commit message.

                      Linus
