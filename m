Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23B7C43461
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 07:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D85120759
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 07:16:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oJxgTTBG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbgIFHQ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Sep 2020 03:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgIFHQ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Sep 2020 03:16:58 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054F6C061573
        for <linux-scsi@vger.kernel.org>; Sun,  6 Sep 2020 00:16:56 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id j11so13868215ejk.0
        for <linux-scsi@vger.kernel.org>; Sun, 06 Sep 2020 00:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zlO3C38KMphQ0pR1b7DrJ2xZ63j3Ud7h7vYlXJFjQ1U=;
        b=oJxgTTBG/BN1NnEKm8FFMtrp1F9Zh/xXN1IF8Z8KwUUToVOwJqr5NBcYtx80yvz4KZ
         /ZDtMvl7OgewDBO2zmnZy5SzqC5dlizrD+iArl8uB/bLM9CdimJVDtVRVT6MM/eUZi5J
         niHrwknBSQ3juuGseWdkkiKBUPhwpP2ZZvHp9hHHsBgb/0/I1zn+CEIPFmDzRh00gOgG
         rxe+aUtOicscU2ZblEtIcSAboAg9ggd8SpvhXO/qyjs6WxQga8fFBTMdgqWNuzbfo0gb
         9kjsyvuGzAA2Y2ZKNroE1eIv5YO7AxLn+iBKRb3nyqjXEZY1OhcVH7N9AtfstbsGmues
         pdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zlO3C38KMphQ0pR1b7DrJ2xZ63j3Ud7h7vYlXJFjQ1U=;
        b=SxLhtPBd1KNw74CG0S/eBcfQn0OAwQXvS/D1yzggOOCxll7FUYs4FrljLdILmy0hw5
         0d8BH5egVDTcx7lZhvIwzlcjcy3rj08ev9ITkX1ntS3mRIRsqJP6I/ingoee6vqW9EKT
         SXAHQfJfDz+QxFKa4niDnTKqTvTSFJQ6PNvrCsWD/McWmITD//0JJzvzdpQ5HMv8z6us
         6deKiillDs/lSVGAyGgNDvqkNYyx1+LbFAMqDZns3V3UxqYhnK7UYL+ArrN58EsJFhg0
         thMm8UyJdK0fDjTvwdsAzYZNhc94e1EMsArvb3psTMuZ79TlAhEbTUZk7/yT+t+Z34oN
         nQUg==
X-Gm-Message-State: AOAM533H2ryuhhaWMI45hSzb/g2CRiIl9m5fL5skPpr5XSbAkP6LvhC2
        Dzon00FlLasrCbqaAwVxznbN3vSqfq1mCKNhkqojZ7c9FR4=
X-Google-Smtp-Source: ABdhPJyx0xj0VoTgezhrBoH/3e+5roWgH9tjhdqem+7D6HUiQDRwHEj+49yvNp7ylZzkj+hjX5IsSg9sQZPWeR3ykZg=
X-Received: by 2002:a17:906:5488:: with SMTP id r8mr15122829ejo.483.1599376613061;
 Sun, 06 Sep 2020 00:16:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com> <caf0aa91-3e54-f8bd-d818-587f4318716c@acm.org>
 <868195a0-94f2-f009-bfd4-f206f0da7db8@interlog.com> <CAGnHSE=bhpL4REG5PXST6dF3gSWeewg1Eqr+sLw_9rtqL-ToFQ@mail.gmail.com>
 <1a0b8035-8072-6de0-5e4f-b6c2848d3a1c@interlog.com>
In-Reply-To: <1a0b8035-8072-6de0-5e4f-b6c2848d3a1c@interlog.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Sep 2020 15:16:41 +0800
Message-ID: <CAGnHSEmyVhNa40WkFRpzMXCgtG4ts6FW7KT0A=tsOjU6r1DTAg@mail.gmail.com>
Subject: Re: [PATCH 1/4] scsi: sg: fix BLKSECTGET ioctl
To:     dgilbert@interlog.com
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, akinobu.mita@gmail.com,
        hch@lst.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 6 Sep 2020 at 13:09, Douglas Gilbert <dgilbert@interlog.com> wrote:
>
> On 2020-09-05 9:19 p.m., Tom Yan wrote:
> > It was my concern as well, that for this sort of
> > "backwards-incompatible reason", it has been kept broken
> > intentionally.
>
> Bumping the sg driver version number is simple:
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 20472aaaf630..c9763b85961f 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -11,8 +11,8 @@
>    *        Copyright (C) 1998 - 2014 Douglas Gilbert
>    */
>
> -static int sg_version_num = 30536;     /* 2 digits for each component */
> -#define SG_VERSION_STR "3.5.36"
> +static int sg_version_num = 30537;     /* 2 digits for each component */
> +#define SG_VERSION_STR "3.5.37"
>
>   /*
>    *  D. P. Gilbert (dgilbert@interlog.com), notes:
>
>
> And bumping the version number is appropriate for an interface
> tweak/correction.

I wasn't (and still isn't) sure how much I should bump.  Maybe 36000 /
3.6.0 will do? (Seems to deserve the bigger bump)

>
> I'm rewriting the sg driver currently (12 months and counting) and am up
> to version 11 of the _first_ half. So far I'm using a sg_version_num of
>  > 40000 for the rewritten code. Please keep away from version numbers
> 40000 and above.
>
> The rewritten driver is documented here:
>      https://doug-gilbert.github.io/sg_v40.html
>
> and its ioctls are listed in Table 8, including the BLK* ones. Perhaps you
> could suggest some corrections. Obviously BLKSSZGET needs to be added
> when your patches are accepted.

"this ioctl value replicates what a block layer device file (e.g.
/dev/sda) will do with the same value. It calls the
queue_max_sectors() helper on the owning device's command queue. The
resulting number represents the maximum number of logical sectors of a
single request that the block layer will accept."? and for BLKSSZGET
"the resulting number represents the logical sector size"?

>
> Doug Gilbert
>
> > I am not sure if queue_max_sectors() or BLKSECTGET has ever been
> > implemented in the block layer to give out the limit in bytes, but it
> > certainly isn't the case anymore.
> >
> > I am not in position to say whether it's "right" or "wrong" to
> > implement BLKSECTGET/BLKSSZGET in the sg driver, but they is
> > definitely useful in some cases (as long as the queue_* functions work
> > for the given underlying device). Is it not okay if they don't
> > ultimately work on *some* devices, even when they aren't named SG_*?
> >
> > Perhaps we can consider having them removed as well (and implement
> > them as e.g. SG_GET_MAX_SECTORS and SG_GET_LBS; but IMHO that only
> > makes a point if they can be made to work on more than block devices).
> >
> >
> > On Sun, 6 Sep 2020 at 04:37, Douglas Gilbert <dgilbert@interlog.com> wrote:
> >>
> >> On 2020-09-05 3:32 p.m., Bart Van Assche wrote:
> >>> On 2020-09-04 13:05, Tom Yan wrote:
> >>>> It should give out the maximum number of sectors per request
> >>>> instead of maximum number of bytes.
> >>>>
> >>>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> >>>> ---
> >>>>    drivers/scsi/sg.c | 6 ++++--
> >>>>    1 file changed, 4 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> >>>> index 20472aaaf630..e57831910228 100644
> >>>> --- a/drivers/scsi/sg.c
> >>>> +++ b/drivers/scsi/sg.c
> >>>> @@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
> >>>>       int result, val, read_only;
> >>>>       Sg_request *srp;
> >>>>       unsigned long iflags;
> >>>> +    unsigned int max_sectors;
> >>>>
> >>>>       SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
> >>>>                                  "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
> >>>> @@ -1114,8 +1115,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
> >>>>               sdp->sgdebug = (char) val;
> >>>>               return 0;
> >>>>       case BLKSECTGET:
> >>>> -            return put_user(max_sectors_bytes(sdp->device->request_queue),
> >>>> -                            ip);
> >>>> +            max_sectors = min_t(unsigned int, USHRT_MAX,
> >>>> +                                queue_max_sectors(sdp->device->request_queue));
> >>>> +            return put_user(max_sectors, ip);
> >>>>       case BLKTRACESETUP:
> >>>>               return blk_trace_setup(sdp->device->request_queue,
> >>>>                                      sdp->disk->disk_name,
> >>>
> >>> Is this perhaps a backwards-incompatible change to the kernel ABI, the
> >>> kind of change Linus totally disagrees with?
> >>>
> >>> Additionally, please Cc linux-api for patches that modify the kernel ABI.
> >>> >From https://www.kernel.org/doc/man-pages/linux-api-ml.html: "The kernel
> >>> source file Documentation/SubmitChecklist notes that all Linux kernel
> >>> patches that change userspace interfaces should be CCed to
> >>> linux-api@vger.kernel.org, so that the various parties who are interested
> >>> in API changes are informed. For further information, see
> >>> https://www.kernel.org/doc/man-pages/linux-api-ml.html"
> >>
> >> Hmm,
> >> The BLK* ioctl()s in the sg driver were an undocumented addition by others.
> >> Plus it is not clear to me why a char device such as the sg driver should
> >> be supporting BLK* ioctl(2)s. For example, how should an enclosure react to
> >> those ioctls or a WLUN?
> >>
> >> If they are going to be supported for storage devices and /dev/sdb and
> >> /dev/sg2 are the same device then if:
> >>      blockdev --getmaxsect /dev/sg1
> >>
> >> gives a different result to:
> >>      blockdev --getmaxsect /dev/sdb
> >>
> >> then I would consider that a bug. So fixing it is making the kernel ABI
> >> more consistent :-)
> >
> > That's exactly my point. They should work identically as the ones
> > implemented in the block layer, because of their names.
> >
> > With that said, sg_version needs to be bumped once the fix gets in, so
> > that there's a way to differentiate the "different implementations" in
> > userspace.
> >
> >>
> >> Doug Gilbert
> >>
> >>
> >>
> >
> > Regards,
> > Tom
> >
>
