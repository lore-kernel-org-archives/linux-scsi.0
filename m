Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A81C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 14:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1953B2076D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 14:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZCR/VyA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgGQOXZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 10:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgGQOXZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 10:23:25 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D49C0619D2;
        Fri, 17 Jul 2020 07:23:25 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a6so11364111wrm.4;
        Fri, 17 Jul 2020 07:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lc8p4Vpf/AxGGSchmemrYI/FGyYO3IsS/ingmTKVpbM=;
        b=mZCR/VyAwlBHBp2pgcDVtSkOjwayVV+Ixu6XXhzqW4YXK9Fa76hMT9WfVWC4bfnokg
         MYanEA25jtklYEL1C/peJWj5gtglxnsoVpM+hcUpNt10b8AbgUE0omeiMgBf4gJb4cQ/
         kuUtL2jhNIm55VKtm3e+3MAeXQXCiTYy/2mXT5St8EtUVBICteS2D/+MbLEXDaOYcQ7/
         2aOcMCRdz8AOZ1syT6I2h867XYc9xjPWDQYUq43RcUfxNf2TuhGlnbezv4zhlIT0jNpj
         FozpIhQRH+C8rpaa5GHqpvgUQJyDIT3QWUUx4AtnKb9c/7Agc+ORvYCztQNeTfcCQ4V3
         X0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lc8p4Vpf/AxGGSchmemrYI/FGyYO3IsS/ingmTKVpbM=;
        b=cUQo5yfDUh26Yfbq1VeA3vYFckKNW8jL1PbnqXtZXva/A4dwT+Tf61XzMaDoTrYKzb
         CyknOb7WI/+WMkwyRxXFp+0mesVVNbLAv7G/9t1iLDYSxPuFzBk3UzuFI4pnGLfVyeJP
         V7naklzLGxGEr+aUruM5AXUVvqblFMlmOmLqVjP1V0X4EmKKWoBOZHZ6aZVzJtu60nz9
         MoKjlg1rVeJayVDjuosSiI4HFfjXPFxbdt2Y5QPYsVbpWYgU+vwkHV9eV9rDEkIPQ32v
         CPdOVSZaqpXN9wql6sold3en68/gsH8C3u3NR/AuWD7IhmmNtre2iKmx1P4bh4+MYZAH
         Xj/A==
X-Gm-Message-State: AOAM531oaWXM7Uab6dLRb2BbddQpkmYmzjRocS+O5LNPibqh0FNzATHO
        U8HnWqrAdVR3SQ4gI3ODYv8cWl0bhlyuYFBB5cc=
X-Google-Smtp-Source: ABdhPJy/AFcSvg8oFSKxaziQaCV8GgIrGcRoLGFP/65n8XwDLqeq/BuQtHYlsx7G29iPkE0/9VhbBlYnxR3kS1pDc4I=
X-Received: by 2002:adf:ef89:: with SMTP id d9mr11333747wro.124.1594995803831;
 Fri, 17 Jul 2020 07:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200708131405.3346107-1-ming.lei@redhat.com> <20200714003710.GB308476@T590>
In-Reply-To: <20200714003710.GB308476@T590>
From:   Ming Lei <tom.leiming@gmail.com>
Date:   Fri, 17 Jul 2020 22:23:12 +0800
Message-ID: <CACVXFVNmU5MLO75f5QBpeBtBVqBCJ-oYp9HV_4LBBGZtFS9w_w@mail.gmail.com>
Subject: Re: [PATCH] scsi: core: run queue in case of IO queueing failure
To:     Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 8:38 AM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Wed, Jul 08, 2020 at 09:14:05PM +0800, Ming Lei wrote:
> > IO requests may be held in scheduler queue because of resource contention.
> > However, not like normal completion, when queueing request failed, we don't
> > ask block layer to queue these requests, so IO hang[1] is caused.
> >
> > Fix this issue by run queue when IO request failure happens.
> >
> > [1] IO hang log by running heavy IO with removing scsi device
> >
> > [   39.054963] scsi 13:0:0:0: rejecting I/O to dead device
> > [   39.058700] scsi 13:0:0:0: rejecting I/O to dead device
> > [   39.087855] sd 13:0:0:1: [sdd] Synchronizing SCSI cache
> > [   39.088909] scsi 13:0:0:1: rejecting I/O to dead device
> > [   39.095351] scsi 13:0:0:1: rejecting I/O to dead device
> > [   39.096962] scsi 13:0:0:1: rejecting I/O to dead device
> > [  247.021859] INFO: task scsi-stress-rem:813 blocked for more than 122 seconds.
> > [  247.023258]       Not tainted 5.8.0-rc2 #8
> > [  247.024069] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  247.025331] scsi-stress-rem D    0   813    802 0x00004000
> > [  247.025334] Call Trace:
> > [  247.025354]  __schedule+0x504/0x55f
> > [  247.027987]  schedule+0x72/0xa8
> > [  247.027991]  blk_mq_freeze_queue_wait+0x63/0x8c
> > [  247.027994]  ? do_wait_intr_irq+0x7a/0x7a
> > [  247.027996]  blk_cleanup_queue+0x4b/0xc9
> > [  247.028000]  __scsi_remove_device+0xf6/0x14e
> > [  247.028002]  scsi_remove_device+0x21/0x2b
> > [  247.029037]  sdev_store_delete+0x58/0x7c
> > [  247.029041]  kernfs_fop_write+0x10d/0x14f
> > [  247.031281]  vfs_write+0xa2/0xdf
> > [  247.032670]  ksys_write+0x6b/0xb3
> > [  247.032673]  do_syscall_64+0x56/0x82
> > [  247.034053]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [  247.034059] RIP: 0033:0x7f69f39e9008
> > [  247.036330] Code: Bad RIP value.
> > [  247.036331] RSP: 002b:00007ffdd8116498 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > [  247.037613] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f69f39e9008
> > [  247.039714] RDX: 0000000000000002 RSI: 000055cde92a0ab0 RDI: 0000000000000001
> > [  247.039715] RBP: 000055cde92a0ab0 R08: 000000000000000a R09: 00007f69f3a79e80
> > [  247.039716] R10: 000000000000000a R11: 0000000000000246 R12: 00007f69f3abb780
> > [  247.039717] R13: 0000000000000002 R14: 00007f69f3ab6740 R15: 0000000000000002
> >
> > Cc: linux-block@vger.kernel.org
> > Cc: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/scsi_lib.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 534b85e87c80..4d7fab9e8af9 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1694,6 +1694,16 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
> >                */
> >               if (req->rq_flags & RQF_DONTPREP)
> >                       scsi_mq_uninit_cmd(cmd);
> > +
> > +             /*
> > +              * Requests may be held in block layer queue because of
> > +              * resource contention. We usually run queue in normal
> > +              * completion for queuing these requests again. Block layer
> > +              * will finish this failed request simply, run queue in case
> > +              * of IO queueing failure so that requests can get chance to
> > +              * be finished.
> > +              */
> > +             scsi_run_queue(q);
> >               break;
> >       }
> >       return ret;
>
> Hello Guys,
>
> Ping...

Ping again...


-- 
Ming Lei
