Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270FDC4167B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 14:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD672313F
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 14:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgLFOPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 09:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgLFOPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 09:15:15 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5861C0613D0;
        Sun,  6 Dec 2020 06:14:34 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id dk8so7998310edb.1;
        Sun, 06 Dec 2020 06:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eNOEAWekcaikssB8glzCwEs1qMsl24PtYgQQ8j4uLPA=;
        b=CbZo57z4+74s79nVAmWVNgfudPLp6+nhTYJe96sZlmIRGMmo50jT/v07k2DkbRUSy4
         KIcSuHxNJyOm+IBZ4LSZbgJFvzRs+34nt40gjM4m5msOtu6WYsL5mNO+gieNtBGG4pUY
         U4oromD2SOu3D7hn87g/kzaMEjevNyrDdTqTYpV13hbXSQtDtQtXSSfN3fIKSpWD6p0L
         yqUrkE9Zluz7at03qIFO9dg2AcPzCwwIGWITcanLg+v7Fd6Zov4fFAKQH+r0bN3QE1Tp
         irrhwGrJjEgvgPIilzNlxqYOVyvw9ccMaqn12RjphcrP8mVKxvkFEWeRdiWqH6UXi4pP
         d/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eNOEAWekcaikssB8glzCwEs1qMsl24PtYgQQ8j4uLPA=;
        b=Yz/j/MNguW8P00jydw7fl5bpoBs5VlfgD3ftqf2IgyW5nbkjVeZnq8Vmc8aEWbDNak
         ptksKBgbmM4vIVp0WSfzLws+J6usoBjKhN3jYQGkabT6FRZvhChgYPHRDe1LstStjRF2
         laPO+B48UxWdtlaFfSBfu8q+r9pqJBBVrDWN5ZnvHj6OqQY0ClPx9Sz/sv6YEYjXMhU4
         UZ9EpTVZ0kt3VN9659p2TzqzUOiwewmULWhxVsjT9qmPtF6bNzptgILTruuJhBJXQH0h
         jtMad5GrNicRTpow5i010yG/KSNkphwmJzVh1J1ewcLuHsu3GKj1/bpI6zLPgLqie71A
         hrcQ==
X-Gm-Message-State: AOAM532yw7/cYe0rH6bxoWsNdJjcg1iPUbaT8kNbW6xqHGdWPJgkTmHP
        lIvMSCKJ553LSJd9Lsgh2xcw33gP4S/v1VzavgUThmD5
X-Google-Smtp-Source: ABdhPJwMzwl0myNqVWFT9vOi76GZ9A3LwUs0yivTqa0T15pIy63R3eaLaR0Rm7RLAj3m8WwBQQIMm3Wu4rdRMUTXubE=
X-Received: by 2002:aa7:d545:: with SMTP id u5mr15767814edr.113.1607264073463;
 Sun, 06 Dec 2020 06:14:33 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <20201206055332.3144-3-tom.ty89@gmail.com>
 <2eb8f838-0ec6-3e70-356b-8c04baba2fc4@suse.de> <CAGnHSEk0C6VNQysGiysPS1yEXwu4U8PVCaVB2RR7oEgnr4Xz=w@mail.gmail.com>
 <4304d959-9155-3126-a858-28b338968916@suse.de>
In-Reply-To: <4304d959-9155-3126-a858-28b338968916@suse.de>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Dec 2020 22:14:22 +0800
Message-ID: <CAGnHSEmMB5bfkCqyk=USHnmFr+Z1HA9UQ8whBD08K1hwvM2Scw@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: set REQ_PREFLUSH to the final bio from __blkdev_issue_zero_pages()
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 6 Dec 2020 at 22:05, Hannes Reinecke <hare@suse.de> wrote:
>
> On 12/6/20 2:32 PM, Tom Yan wrote:
> > Why? Did you miss that it is in the condition where
> > __blkdev_issue_zero_pages() is called (i.e. it's not WRITE SAME but
> > WRITE). From what I gathered REQ_PREFLUSH triggers a write back cache
> > (that is on the device; not sure about dirty pages) flush, wouldn't it
> > be a right thing to do after we performed a series of WRITE (which is
> > more or less purposed to get a drive wiped clean).
> >
>
> But what makes 'zero_pages' special as compared to, say, WRITE_SAME?
> One could use WRITE SAME with '0' content, arriving at pretty much the
> same content than usine zeroout without unmapping. And neither of them
> worries about cache flushing.
> Nor should they, IMO.

Because we are writing actual pages (just that they are zero and
"shared memory" in the system) to the device, instead of triggering a
special command (with a specific parameter)?

>
> These are 'native' block layer calls, providing abstract accesses to
> hardware functionality. If an application wants to use them, it would be
> the task of the application to insert a 'flush' if it deems neccessary.
> (There _is_ blkdev_issue_flush(), after all).

Well my argument would be the call has the purpose of "wiping" so it
should try to "atomically" guarantee that the wiping is synced. It's
like a complement to REQ_SYNC in the final submit_bio_wait().

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
