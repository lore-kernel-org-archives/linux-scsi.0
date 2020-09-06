Return-Path: <SRS0=a8U3=CP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0E7C433E2
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDCCB2078D
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Sep 2020 01:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hHiOERmV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgIFBTl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Sep 2020 21:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbgIFBTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Sep 2020 21:19:39 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3021DC061244
        for <linux-scsi@vger.kernel.org>; Sat,  5 Sep 2020 18:19:39 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id i22so13340741eja.5
        for <linux-scsi@vger.kernel.org>; Sat, 05 Sep 2020 18:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DtiH2plxGMa00nhpoF0XIe4LVvDVaWVAkHrDWRd75Lw=;
        b=hHiOERmVBhszFZmGEn6AQ79DiFMNlCpYN52Gt2ufE9zxvRxhJmCo5lyYOaukAikCu/
         OXoIelfyVNbKBOYcljh8D5x28eXN4QzmgPMf3MjJJf9SILfVl9cjTZLr3CjEdSiWzPxC
         rkFcRs9XBpyfZgDsuHNYTfj55alNdyLFM/XEJ3ILNEOGX3QgoBea7rArSwkFT+iFjoP1
         C8KsAFQyJ3BOwRFFA76evDKTw1Z9z9PP6PwJRy/AbUInwu1ZodysPzOFKiIya3TADv3Z
         Vc+HMU8dVzLP+lezVX311YR3TxP76U8SjMP1AFhiGzeX+SJ6jjVZkNXRwhYeciOZ+IN2
         aKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DtiH2plxGMa00nhpoF0XIe4LVvDVaWVAkHrDWRd75Lw=;
        b=hOPgw+LIAw1U2LzxFscA0WmRWlyn0KLjPq4fKVZdkJPN++/PB+f/VXF3R/UdUAS23f
         0acudMehvdu69wqy7Qt10Sfe/tAaVhd7dxGduzhepkO4TBw/fgfHhohzDBx2lL2Im5V0
         KqHUZqe+WeTD0NDUIXFpFIuumBXiLeTcIzR4aezrI9Bl/cMTBik3Viq+xT+C0qqtqibL
         ZsHpBsYY2/SR45y2c+4I4TlVuhAai8hMl4f3HL81RlHLwQ8kDZpUYcn6lfUEqASMNNHT
         b92bIHukeA+Kk7zkerWhik/9BWm9UhvSww6O+yU4nPfRyMrANdeO11uOMdGJBNyjv0lw
         CCQw==
X-Gm-Message-State: AOAM5300HVhOkvVmX0jCG7BABd3NNtTSA2WWSyVWHR8G0W1bOc9+GLKX
        k/TIqYS9AWK4w1+BfIyB1XfFIemkkuM/Pzcst2zleAtt
X-Google-Smtp-Source: ABdhPJz7PQ4KOnDaLU2yed25XJsRKW34oM+WppPawFmikfUx/3OzWc2DEqNm/oKeQCR47O0/O1M8uj/1TTP+RjyeCEU=
X-Received: by 2002:a17:906:2a17:: with SMTP id j23mr3878435eje.146.1599355177495;
 Sat, 05 Sep 2020 18:19:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com> <caf0aa91-3e54-f8bd-d818-587f4318716c@acm.org>
 <868195a0-94f2-f009-bfd4-f206f0da7db8@interlog.com>
In-Reply-To: <868195a0-94f2-f009-bfd4-f206f0da7db8@interlog.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Sep 2020 09:19:26 +0800
Message-ID: <CAGnHSE=bhpL4REG5PXST6dF3gSWeewg1Eqr+sLw_9rtqL-ToFQ@mail.gmail.com>
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

It was my concern as well, that for this sort of
"backwards-incompatible reason", it has been kept broken
intentionally.

I am not sure if queue_max_sectors() or BLKSECTGET has ever been
implemented in the block layer to give out the limit in bytes, but it
certainly isn't the case anymore.

I am not in position to say whether it's "right" or "wrong" to
implement BLKSECTGET/BLKSSZGET in the sg driver, but they is
definitely useful in some cases (as long as the queue_* functions work
for the given underlying device). Is it not okay if they don't
ultimately work on *some* devices, even when they aren't named SG_*?

Perhaps we can consider having them removed as well (and implement
them as e.g. SG_GET_MAX_SECTORS and SG_GET_LBS; but IMHO that only
makes a point if they can be made to work on more than block devices).


On Sun, 6 Sep 2020 at 04:37, Douglas Gilbert <dgilbert@interlog.com> wrote:
>
> On 2020-09-05 3:32 p.m., Bart Van Assche wrote:
> > On 2020-09-04 13:05, Tom Yan wrote:
> >> It should give out the maximum number of sectors per request
> >> instead of maximum number of bytes.
> >>
> >> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> >> ---
> >>   drivers/scsi/sg.c | 6 ++++--
> >>   1 file changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> >> index 20472aaaf630..e57831910228 100644
> >> --- a/drivers/scsi/sg.c
> >> +++ b/drivers/scsi/sg.c
> >> @@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
> >>      int result, val, read_only;
> >>      Sg_request *srp;
> >>      unsigned long iflags;
> >> +    unsigned int max_sectors;
> >>
> >>      SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
> >>                                 "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
> >> @@ -1114,8 +1115,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
> >>              sdp->sgdebug = (char) val;
> >>              return 0;
> >>      case BLKSECTGET:
> >> -            return put_user(max_sectors_bytes(sdp->device->request_queue),
> >> -                            ip);
> >> +            max_sectors = min_t(unsigned int, USHRT_MAX,
> >> +                                queue_max_sectors(sdp->device->request_queue));
> >> +            return put_user(max_sectors, ip);
> >>      case BLKTRACESETUP:
> >>              return blk_trace_setup(sdp->device->request_queue,
> >>                                     sdp->disk->disk_name,
> >
> > Is this perhaps a backwards-incompatible change to the kernel ABI, the
> > kind of change Linus totally disagrees with?
> >
> > Additionally, please Cc linux-api for patches that modify the kernel ABI.
> >>From https://www.kernel.org/doc/man-pages/linux-api-ml.html: "The kernel
> > source file Documentation/SubmitChecklist notes that all Linux kernel
> > patches that change userspace interfaces should be CCed to
> > linux-api@vger.kernel.org, so that the various parties who are interested
> > in API changes are informed. For further information, see
> > https://www.kernel.org/doc/man-pages/linux-api-ml.html"
>
> Hmm,
> The BLK* ioctl()s in the sg driver were an undocumented addition by others.
> Plus it is not clear to me why a char device such as the sg driver should
> be supporting BLK* ioctl(2)s. For example, how should an enclosure react to
> those ioctls or a WLUN?
>
> If they are going to be supported for storage devices and /dev/sdb and
> /dev/sg2 are the same device then if:
>     blockdev --getmaxsect /dev/sg1
>
> gives a different result to:
>     blockdev --getmaxsect /dev/sdb
>
> then I would consider that a bug. So fixing it is making the kernel ABI
> more consistent :-)

That's exactly my point. They should work identically as the ones
implemented in the block layer, because of their names.

With that said, sg_version needs to be bumped once the fix gets in, so
that there's a way to differentiate the "different implementations" in
userspace.

>
> Doug Gilbert
>
>
>

Regards,
Tom
