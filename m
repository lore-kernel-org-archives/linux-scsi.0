Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F70BC32772
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 09:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiHUJQa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 05:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiHUJQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 05:16:28 -0400
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FCF19013
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 02:16:27 -0700 (PDT)
Received: by mail-qv1-f43.google.com with SMTP id n14so2982267qvq.10
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 02:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=bXjBtIWrZyx5tH4PYK+BL6KL6cBCMeqyV176TyuPT2c=;
        b=MAFpCfy4iuv/SZyc325AEPqJXBkVqKPToq7oxo4OFFgKDPbTbixRWztkOB3JLzAtMN
         zL0OkxeMKYGBH+e+SBDnikffndp7gXk1EX0h8Ffi48Q/MV8Dh1SY+0qv3/bqvzrzI8v0
         5oOmqFHTsZEZ/OIFsqoVz2ZitHJwKtnmgGiLzuenPLd9FkjEoc37RL8czU2/WWXhLGYd
         /XFQyLyTu2tww31bkaU4gehRoFQyqlkSjTFHzWocFukA0Y5hpeAH1nQvk38L6oDhoEiq
         xSqqcFyC3PZ2sgOvcxcmFGCtTIrFRng1FvOVLmVnKtYXgYBLm0F1sJ9m0WMhxugUItsE
         p7VA==
X-Gm-Message-State: ACgBeo0N64KjZ9JnDkF8k36qsVSLfhkiwwgve3BIhC11HmOAjbCafAZv
        wFKN+0V+RAzOjVoBfJkVbV20+SazzzTqn59g
X-Google-Smtp-Source: AA6agR7ycCVkfmdGCON/B+2DSLiwWH1Jp0VDW+SOVUMDItKfs47arQzQFmSSyv7Zxx1FvcFoe140Sg==
X-Received: by 2002:a05:6214:2606:b0:496:c5d7:dbd0 with SMTP id gu6-20020a056214260600b00496c5d7dbd0mr7838531qvb.86.1661073386199;
        Sun, 21 Aug 2022 02:16:26 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id n1-20020ac86741000000b0031eebfcb369sm6417030qtp.97.2022.08.21.02.16.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Aug 2022 02:16:25 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-32a09b909f6so222337907b3.0
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 02:16:25 -0700 (PDT)
X-Received: by 2002:a5b:6c1:0:b0:669:a7c3:4c33 with SMTP id
 r1-20020a5b06c1000000b00669a7c34c33mr13983208ybq.543.1661073384988; Sun, 21
 Aug 2022 02:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220816172638.538734-1-bvanassche@acm.org> <decc1ef4-ec85-d947-ec81-ebeaa982f53f@redhat.com>
In-Reply-To: <decc1ef4-ec85-d947-ec81-ebeaa982f53f@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 21 Aug 2022 11:16:13 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVDWrLs_KusG8vXA_1z8ORdPnpfxzNqw4jCG_G0D-fn+A@mail.gmail.com>
Message-ID: <CAMuHMdVDWrLs_KusG8vXA_1z8ORdPnpfxzNqw4jCG_G0D-fn+A@mail.gmail.com>
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hans,

On Sat, Aug 20, 2022 at 5:37 PM Hans de Goede <hdegoede@redhat.com> wrote:
> On 8/16/22 19:26, Bart Van Assche wrote:
> > Although patch "Rework asynchronous resume support" eliminates the delay
> > for some ATA disks after resume, it causes resume of ATA disks to fail
> > on other setups. See also:
> > * "Resume process hangs for 5-6 seconds starting sometime in 5.16"
> >   (https://bugzilla.kernel.org/show_bug.cgi?id=215880).
> > * Geert's regression report
> >   (https://lore.kernel.org/linux-scsi/alpine.DEB.2.22.394.2207191125130.1006766@ramsan.of.borg/).
> >
> > This is what I understand about this issue:
> > * During resume, ata_port_pm_resume() starts the SCSI error handler.
> >   This changes the SCSI host state into SHOST_RECOVERY and causes
> >   scsi_queue_rq() to return BLK_STS_RESOURCE.
> > * sd_resume() calls sd_start_stop_device() for ATA devices. That
> >   function in turn calls sd_submit_start() which tries to submit a START
> >   STOP UNIT command. That command can only be submitted after the SCSI
> >   error handler has changed the SCSI host state back to SHOST_RUNNING.
> > * The SCSI error handler runs on its own thread and calls
> >   schedule_work(&(ap->scsi_rescan_task)). That causes
> >   ata_scsi_dev_rescan() to be called from the context of a kernel
> >   workqueue. That call hangs in blk_mq_get_tag(). I'm not sure why -
> >   maybe because all available tags have been allocated by
> >   sd_submit_start() calls (this is a guess).
> >
> > Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: gzhqyz@gmail.com
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Reported-by: gzhqyz@gmail.com
> > Fixes: 88f1669019bd ("scsi: sd: Rework asynchronous resume support"; v6.0-rc1~114^2~68)
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>
> As reported here I've been seeing tasks block/hang on IO
> to a sata disk on a system with / on a NVME (which keeps
> the system alive except for the SATA disk acccessing tasks):
>
> https://lore.kernel.org/regressions/dd6844e7-f338-a4e9-2dad-0960e25b2ca1@redhat.com/
>
> I'm running 6.0-rc1 with this patch added now and so far
> I've not seen the problem re-occur.
>
> I was also seeing 6.0 suspend/resume issues on 2 laptops with
> sata disks (rather then NVME) which I did not yet get around
> to collecting logs from / reporting. I'm happy to report that
> those suspend/resume issues are also fixed by this:

It looks like there is a (different) regression in v6.1-rc1 related
to s2idle and s2ram, which is not fixed by this patch.  In fact it
also happens on boards where SATA is not used, it is just less likely
to happen on the non-SATA boards.
I still have to bisect it, which may take some time, as the issue is
not 100% reproducible.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
