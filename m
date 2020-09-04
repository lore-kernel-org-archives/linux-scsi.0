Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1619C433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 19:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D0A920829
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 19:21:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tWfn7GOd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgIDTVg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 15:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbgIDTVf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 15:21:35 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68247C061244
        for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2020 12:21:35 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gr14so8901128ejb.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2020 12:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OkCUpTIqBF8lt7Y1XjC2vvgXD16+0bWK2tlO3nNLIDM=;
        b=tWfn7GOdLcmLA3v+pi0NUAa9UVI9BMwopF2GKX11qnq+Z+wjrJ7PvC7eYYQmALG3xr
         6doauwJz3EnrjsbB+UfjfmAO0q9UwtK3kqBM56APX/Gl57zSq6YAcL1PP8tUctA/DAKq
         rdWtZyTQUT2Y0t5Qormdd5UNiT482pLfkQiuo1CmJEAk3DUjsZPbaURdrgaQSbQEj4i7
         0aFWPgup/TUUrLf0b1zN9DEOy0wHJazEf+ulHf2DtO5Wua8Xkv8JpKiyxFrkTjYYELR/
         dlW9T727m0B5R5PaI4qqZc6G4TF8Jw+KBqqGbJxn4xAqzvI6SCiKB23Rv4MeEwARRY0l
         fpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OkCUpTIqBF8lt7Y1XjC2vvgXD16+0bWK2tlO3nNLIDM=;
        b=Z6SmsCDEZsdIlNWqfBd8Dlg99+CpZrY1uPaHeYAQ1nf6+LGIkNTypPSzASasYakvJe
         05qJNFfEmThEKb3BommxbVsJMMW9s/YwKiyRLxQ0X4AUwLHGMjv8lqanHQwsFXDIoOS2
         lqSMt9n5/GIMDSe8KLJEv0SsKn9liAQEhHBCIzk5roCzlF5RxpYXqaln6YJZuJJ05OVS
         6Qqt8R5ik7Q3hacT0WhB6ohR+i5pJQR3Uu30+U/lcqPdbcFCGwNwh4BI0FNIsmRyhToO
         1cpauWdDCr+xjhx+3Ej0FwRoMv6LBTn0tPhVaUsJV6SsWm+bNVY8vgpkG6ImS4nEZ5zr
         oujg==
X-Gm-Message-State: AOAM5326q2pN4Jxowl8XEsCa9+Kpa+OBFQNU4CHDcHowY9g3cKz3mESy
        uaGhWTyOL1JGQiYcCUIQp0yrgkK8pABusYdHVdhJ637MNJ8=
X-Google-Smtp-Source: ABdhPJykcHTlrkOFjPytqwsBxakaeB1WQWB9WSVklNRQjfxCyKJN/iEAGNSnB5WAqDakfDMW+7OvJXVTymHnN0il8A4=
X-Received: by 2002:a17:906:e24f:: with SMTP id gq15mr9179819ejb.395.1599247293898;
 Fri, 04 Sep 2020 12:21:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSEnhpaqcF8gWG9udrq_vwYWh2vOGL1VgN3=E=1OVjenVUQ@mail.gmail.com>
 <bfd72561-08e9-88fc-8325-a9986d69d2fd@interlog.com>
In-Reply-To: <bfd72561-08e9-88fc-8325-a9986d69d2fd@interlog.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sat, 5 Sep 2020 03:21:22 +0800
Message-ID: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
Subject: Re: About BLKSECTGET in sg
To:     dgilbert@interlog.com
Cc:     linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Doug,

On Sat, 5 Sep 2020 at 00:28, Douglas Gilbert <dgilbert@interlog.com> wrote:
>
> On 2020-09-04 12:42 a.m., Tom Yan wrote:
> > Hi,
> >
> > Is BLKSECTGET in sg intentionally kept "broken" (i.e. it gives out
> > max_sectors in bytes) or is it just a miss? I'm just wondering if I
> > should send a patch to fix it (and implement BLKSSZGET).
> >
> > Also, shouldn't max_sectors_bytes() in both drivers/scsi/sg.c and
> > block/scsi_ioctl.c use queue_logical_block_size() instead?
>
> Tom,
> I have no idea! One of the great things about maintaining a driver in
> Linux is that virtually anyone can send patches and get them accepted
> without and Ack from the maintainer. And when bugs are found in those
> patches, the culprits can't be found or have no inclination to fix them.
>
> 'git blame' will show you that I had nothing to do with the BLK*
> ioctl()s added to the sg driver. That said, if they are broken, they
> should be fixed. I would be interested in getting some test code as

You can test them easily with `blockdev` (--getmaxsect and --getss) in
util-linux.

max_sectors_bytes() are used in sg_add_sfp() and the
SG_{GET,SET}_RESERVED_SIZE ioctls. I am not familiar with those but I
don't see why they shouldn't use the queue_logical_sector_size() (when
they use queue_max_sectors()).

For the BLKSECTGET fix, I think the sg version needs to be bumped (so
that userspace programs like qemu can work as properly as possible
with different versions). Can you point me to some guidance on how
exactly it should be bumped (e.g. which component(s), the "step
size"...)? Or would you do that after the patches are accepted?

> I'm not familiar with using those ioctl()s.
>
> Would you like to send some patches?

They are on the way.

>
> Doug Gilbert
>
>

Regards,
Tom
