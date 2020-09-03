Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A550C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F929208B3
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 16:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Mu8Pt7qw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgICQoy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728210AbgICQox (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 12:44:53 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C242C061244
        for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2020 09:44:52 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id b14so3683911qkn.4
        for <linux-scsi@vger.kernel.org>; Thu, 03 Sep 2020 09:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=sSJKppw1ttMJmSsOKGk1iuKCuyzrebeXWfo6P44pxUc=;
        b=Mu8Pt7qwgNMzDRweZj/aYixzNHXpVWDvMhetHeWYEYCi6x1r3FmhLB/xFzzxFYNBKA
         ztpg7JIoF66+WbfSU5cVdYSVFyqxa5FDpxq+oSj5VJGRFTj9Y1YSwTNNoTiOjJCCeBXk
         gCRbfLrASGtvYY1JAqzFTjwIcmnACWS39MQmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=sSJKppw1ttMJmSsOKGk1iuKCuyzrebeXWfo6P44pxUc=;
        b=LA5mP6dTNCPgZnlugGLPsXZvovvchWFQG5Bcke47rj1aPYUZfaSgPFv4VMwvZTgbCE
         S9CCmDWS4olRkjpME5UoeE7FQqw5Kuuhy2HLxUnur/Ht+miaMsTlS6i9wl+4e6q8viHI
         NrAixJ93GqETjruAHOq6Jx/Gx6lIPP/oYBIsI4ZnQ8wJFcxyxZ7VKCMpuL0Ae9MLDexv
         E4GDPsWZi2BY0CbfLZ8M8GwgAuNrUZklyQ/TYfK07ktKx9sqr77Jjuwc+oDrom//Uuse
         2L8gn5uvuG6vVMKE4xPo8HEb6V14hxM1hI7LEOuL6jtcNboiw+ZSJmCsyrrm916wkfjU
         DXlQ==
X-Gm-Message-State: AOAM530YuqsF1cZeX2sTWbiTBnvQVPP0RZnY42KGYEHRrMbFxcE8U5KX
        nCXF0kOHu3V16ProoKCq14pcB8AsH7evSReo+Zo66A==
X-Google-Smtp-Source: ABdhPJygY0bM8+vAUq2ucdUItsMboX5vH+kFb3Qv7MLLo9IVAegPzRJLmo92amam0+NY8I2ELtnoPTxbcW7JKW8kjWU=
X-Received: by 2002:a37:4a94:: with SMTP id x142mr3818589qka.27.1599151490836;
 Thu, 03 Sep 2020 09:44:50 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com>
 <d8d14575-30e4-5d1f-cd97-266f8ba36493@kernel.dk>
In-Reply-To: <d8d14575-30e4-5d1f-cd97-266f8ba36493@kernel.dk>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFXkOchWQrPHD3VTz81ROsL+5VbowDhDeJvqk31p2A=
Date:   Thu, 3 Sep 2020 22:14:35 +0530
Message-ID: <497f13db2048a0c20cda72863acbce60@mail.gmail.com>
Subject: RE: [RFC] add io_uring support in scsi layer
To:     Jens Axboe <axboe@kernel.dk>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Philip Wong <philip.wong@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 9/3/20 10:14 AM, Kashyap Desai wrote:
> > Currently io_uring support is only available in the block layer.
> > This RFC is to extend support of mq_poll in the scsi layer.
>
> I think this needs to clarify that io_uring with IOPOLL is not currently
> supported, outside of that everything else should work and no extra
> support
> in the driver is needed.
>
> The summary and title makes it sound like it currently doesn't work at
> all,
> which obviously isn't true!

I actually mean io_uring with IOPOLL support. I will fix this.

>
> > megaraid_sas and mpt3sas driver will be immediate users of this
> > interface.
> > Both the drivers can use mq_poll only if it has exposed more than one
> > nr_hw_queues.
> > Waiting for below changes to enable shared host tag support.
>
> Just a quick question, do these low level drivers support non-irq mode for
> requests? That's a requirement for IOPOLL support to work well, and I
> don't
> think it'd be worthwhile to plumb anything up that _doesn't_ support pure
> non-IRQ mode. That's identical to the NVMe support, we will not allow
> IOPOLL if you don't have explicit non-IRQ support.

I guess you mean non-IRQ mode = There will not be any msix vector associated
for poll_queues and h/w can still work in this mode.
If above is correct, yes both the controller can support non-IRQ mode, but
we need support of shared host tag as well for completeness of this feature
in driver.
Both the h/w are single submission queue and multiple reply queue, but using
shared host tagset support we will enable simulated multiple hw queue.

I have megaraid_sas driver patch available and it does identical to what
NVME driver does.  Driver allocates some extra  reply queues and it will be
marked as poll_queue.
This poll_queue will not have associated msix vectors. All the IO completion
on this queue will be done from IOPOLL interface.

I tested megaraid_sas driver having 8 poll_queues and using io_uring
hiprio=1 settings. It can reach 3.2M IOPs and there is *zero* interrupt.
This is what NVME does so I assume this is what you wanted to confirm here.

>
> Outside of that, no comments on this enablement patch, looks pretty
> straight
> forward and fine to me.

Thanks for review.

>
> --
> Jens Axboe
