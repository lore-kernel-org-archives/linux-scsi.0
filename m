Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CB4C2BA4C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 10:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbiAZK02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 05:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiAZK00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2022 05:26:26 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4AAC061748
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jan 2022 02:26:25 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w14so15328398edd.10
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jan 2022 02:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f9JqH8AZZinALRuEISUabkHodTqttzOm1XJvE7gVRxo=;
        b=BfNnO0hSTxlRxFgfGfLV6gLjhZTuq1bZtjMd/1SCKR6BcTwvX3yq+RQp8GLLkSrwW5
         ROvbllFgyqnTW27O8DRlDtzAXsQjiQKVKrgwvUPFI2m/FW7FQHOUQCTn+j4ER6eQzwwa
         7LVsPMBXCg0W37c0R+nNLe6ieO8REXBdyy60HXBQWPFZcRwVX1B0ymbBwljARGo2mWR5
         mTc/PejLJjdYJFjOiKsvKDAuGvnkrtZRs/1GcXgqSAx9lJp79Cjhe6pMAasZZ8VE/P21
         pPc/s2B9zKkILqH7KNVb++bop0qqhUR9xGUHlUVpIUwaUI4KbGV4WpoSjAflGkfzbQSQ
         7bUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9JqH8AZZinALRuEISUabkHodTqttzOm1XJvE7gVRxo=;
        b=vF6IVFbPTQphVRkkzptQZQCuc5gZ9Q0JNnv3UQDJN2TI7o5+RwjweQEDjGt5mfwNEV
         SKBOM0AncIxlg7IB406dUcZHYEkTrQkPxTaQuuOVb7s6+C3SR0+l5zVrSriMQPAf3hJc
         sb00vDoXHFmUX82YEoac8ZorrAWZdUOTBYNDZyUEVH4MjiIyDvQI0IUVEUaPDGxbQeSZ
         DlbEA2g8ISU9l/5M7/w606Thv1DDGFU1yvDQI96c+z5TluNorkGLx1cSRbayfsLDrB8k
         AUH5SBMszLBql88YMDOtQUJi01hVBnCB8/6ZwZb2BzIuDiTXj0KAjiCXnfmTlrhRTKao
         a/bw==
X-Gm-Message-State: AOAM532fy1B/Y3oXAU+JNnvsuykyBJsjUs7SMy1otwXXrSp8pkYkxyPB
        lISFMIGdl75TEcNvd1WLBpExWqElWF1ECpN0XEsyyg==
X-Google-Smtp-Source: ABdhPJxG/TdY2jxnSuYemQF1kd5K9TMQVmG6T3QiGd27cKUEFLxMI04LsvF/gcMyQIy9uGvpVskaiN0z5nue33FcDP4=
X-Received: by 2002:a05:6402:3d2:: with SMTP id t18mr17270292edw.161.1643192784066;
 Wed, 26 Jan 2022 02:26:24 -0800 (PST)
MIME-Version: 1.0
References: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
 <CAMGffEnD0+X2pYXZ2==DUMt7uYFBRTJTNm7KsyKMd1JyfTr2pg@mail.gmail.com> <PH0PR11MB5112675EFFD42B96E559D034EC5F9@PH0PR11MB5112.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB5112675EFFD42B96E559D034EC5F9@PH0PR11MB5112.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 26 Jan 2022 11:26:13 +0100
Message-ID: <CAMGffEk3oyDfdJnK3ruv5hKTXY40zsk8xDoAOyQwRj2D-mYmDg@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
To:     Ajish.Koshy@microchip.com
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 11:58 AM <Ajish.Koshy@microchip.com> wrote:
>
> > >
> > > For SATA devices, correct the double
> > > completion issue.
> > >
> > > Current code handles completions for sata devices in
> > > mpi_sata_completion() and mpi_sata_event().
> > >
> > > But at the time when any sata event happens, for almost all the event
> > > types, the command is still in the target. It is wrong to complete the
> > > task in sata_event().
> >
> > Is it also an issue for SSP? what is the side effect, the current code will lead to
> > (w/o this patch)?
> > why SATA is different?
> >
> > Thanks!
>
> Thanks Jinpu.
>
> Yes, same issue with the SSP event path too. We need
> similar changes there also.
>
If that's the case, probably it should fix in same patch.

> My understanding here on side effects without this patch-
> Here is the expectation of the firmware.
> The controller sends a sata_event notification to indicate
> that the I/O is not finished (may be pending in the controller
> or in the remote target) and that the host must take
> additional action. The host action required depends on the
> event received.
>
> There are cases, where commands need special handling mentioned
> as per the spec.
>
> But for most of the event types, the host must reset the SATA
> drive and abort the pending I/O in the controller by sending abort
> command
>
> Till here inside the firmware all the resource are intact, tag,
> memory, etc.
>
> Now in the host side, once we receive the event, host will free
> its own resources, tag, dma memory, etc. by calling its own
> completion.
>
> So at this point firmware has not freed its own the resources and
> host freed its resources corresponding to the given command/tag.
>
> For example, in the case of IO_XFER_ERROR_NAK_RECEIVED
> sata event.
> Here firmware will keep retrying the command. There are
> chances the corresponding command may get successful and
> firmware may give response through sata completion.
>
> Since we received the sata_event, we will complete the command.
> Host will free its own resouces, tags, dma memory, etc. At this
> point when we received this event, command was still pending in
> the target.
>
> In this case since we freed the DMA memory, while firmware
> completes the command, it will generate
> IO_XFER_READ_COMPL_ERR event (pcie error based) for the same tag/
> command since we already freed the DMA memory/resources.
My impression was the FW should either generate SATA_EVENT or SATA_COPMLETION,
but not both, was this behavior changed?

Thanks!

>
> That's one side effect right now.
>
> Another instance I can see is during I/O, host will free the tag
> once we receive an event, same tag/command is still pending in the
> firmware and post this event
> host re-allocates this tag to some other new request. This may lead
> to some un-expected situation.
>
> That is what I can visualize right now as side effects without this
> patch.
>
> Thanks,
> Ajish
>
