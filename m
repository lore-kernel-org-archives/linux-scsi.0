Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD1AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 06:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbiA1GOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbiA1GOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 01:14:45 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7283C061714
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:14:44 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id s5so12569711ejx.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vNl4BIwI7UBgWDm/1MkkDaERLsUaMx5rLvNnn+NORzQ=;
        b=WpcqNyyKw9yrL0dICa6ZJ7M88ATAq7+z9aB7yXmXCTCLPq+O6HPH6g0oaSQOhste55
         f9dt7eB+a+Z/CwTMZOf/HwujUAR46lUNRwFSm9LBIx7/AIJzorMvW0h6x+uRZ2S87xtz
         D2TnP93zUZczuxQfr2oBaa5PEgQM1ftRbLaFnHoEyvUfwiAdypMZKC22KXqncX6vuA5G
         E/ipkHOuQb1eKhBo9rbmI1Eb2W4jA6WuTsNrH8iqafP5hMkvPIRtkFmWhJS8TVbyMebw
         cKL/jgNRARqFJYMKjXVqRATOubKJYT2ZnoO10YCFiBoTL4SoEbxs8zq0D/Op5SpKzCT9
         S6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vNl4BIwI7UBgWDm/1MkkDaERLsUaMx5rLvNnn+NORzQ=;
        b=3z2wsFSuSwCUuBXgfdzhTCr633AZqh9e5Jg15QBSou1j28SLTkbQgWgUPtvWt+Qlw3
         JbhS60gH3L3xL6xyRCWadUkADXdzrNdxFA15wYAimpI3Y249AdxNQeBlo6Yi3B1PgfCC
         JNumQZkwZNu12FTfTnCT4/aqv6doI3IVcQosrtF+s3L20+IuKEskNLWc1CewNNesLUyu
         f4/1EeXoqo0yGFbrjSI/TIADxigBj2Jl75s3kJab29I31MQmP/kznbKviFU+KI894EJ7
         KFYjRcM938bK9c2ajtb2Hp2KizX9whSDEjq1y4/mJrEht/sFqT3d29Fym5MHUySEK1ll
         4vxg==
X-Gm-Message-State: AOAM532lIc2q2h2VV/Hotym/VglAUBF0YDHhGCwb2FX5FvBgmC6JDREh
        EPzAtdiyDHiT8QR1zaBhEvzer45R2DYzG/NAw4WN5z+imTI=
X-Google-Smtp-Source: ABdhPJyUnq1HKeHS6mLYBRbdTWiCHvnC8HH5VGiJNSXgYsltiO+1I73ksRYY3qWGx4OXaamyLNBBKpT0IQncku8Q+Ak=
X-Received: by 2002:a17:907:9603:: with SMTP id gb3mr5722084ejc.416.1643350483355;
 Thu, 27 Jan 2022 22:14:43 -0800 (PST)
MIME-Version: 1.0
References: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
 <CAMGffEnD0+X2pYXZ2==DUMt7uYFBRTJTNm7KsyKMd1JyfTr2pg@mail.gmail.com>
 <PH0PR11MB5112675EFFD42B96E559D034EC5F9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <CAMGffEk3oyDfdJnK3ruv5hKTXY40zsk8xDoAOyQwRj2D-mYmDg@mail.gmail.com> <PH0PR11MB5112A9B6001061AB902D589BEC219@PH0PR11MB5112.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB5112A9B6001061AB902D589BEC219@PH0PR11MB5112.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Fri, 28 Jan 2022 07:14:32 +0100
Message-ID: <CAMGffEkAgBW4ONK0vDwey4aj0aE5xitv3t4La72Bm6K4dOhLcQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
To:     Ajish.Koshy@microchip.com
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 27, 2022 at 1:08 PM <Ajish.Koshy@microchip.com> wrote:
>
> Hi Jinpu,
>
> > > > >
> > > > > For SATA devices, correct the double completion issue.
> > > > >
> > > > > Current code handles completions for sata devices in
> > > > > mpi_sata_completion() and mpi_sata_event().
> > > > >
> > > > > But at the time when any sata event happens, for almost all the
> > > > > event types, the command is still in the target. It is wrong to
> > > > > complete the task in sata_event().
> > > >
> > > > Is it also an issue for SSP? what is the side effect, the current
> > > > code will lead to (w/o this patch)?
> > > > why SATA is different?
> > > >
> > > > Thanks!
> > >
> > > Thanks Jinpu.
> > >
> > > Yes, same issue with the SSP event path too. We need similar changes
> > > there also.
> > >
> > If that's the case, probably it should fix in same patch.
>
> We do have plans to post the changes for
> ssp event path too. Will be handled
> in a separate patch.
>
> This event/completion issue came to light only
> recently when firmware for one of the SATA
> device generated IO_XFER_ERROR_NAK_RECEIVED
> event and later firmware attempted to the
> complete the same command.
>
> >
> > > My understanding here on side effects without this patch- Here is the
> > > expectation of the firmware.
> > > The controller sends a sata_event notification to indicate that the
> > > I/O is not finished (may be pending in the controller or in the remote
> > > target) and that the host must take additional action. The host action
> > > required depends on the event received.
> > >
> > > There are cases, where commands need special handling mentioned as per
> > > the spec.
> > >
> > > But for most of the event types, the host must reset the SATA drive
> > > and abort the pending I/O in the controller by sending abort command
> > >
> > > Till here inside the firmware all the resource are intact, tag,
> > > memory, etc.
> > >
> > > Now in the host side, once we receive the event, host will free its
> > > own resources, tag, dma memory, etc. by calling its own completion.
> > >
> > > So at this point firmware has not freed its own the resources and host
> > > freed its resources corresponding to the given command/tag.
> > >
> > > For example, in the case of IO_XFER_ERROR_NAK_RECEIVED sata event.
> > > Here firmware will keep retrying the command. There are chances the
> > > corresponding command may get successful and firmware may give
> > > response through sata completion.
> > >
> > > Since we received the sata_event, we will complete the command.
> > > Host will free its own resouces, tags, dma memory, etc. At this point
> > > when we received this event, command was still pending in the target.
> > >
> > > In this case since we freed the DMA memory, while firmware completes
> > > the command, it will generate IO_XFER_READ_COMPL_ERR event (pcie
> > error
> > > based) for the same tag/ command since we already freed the DMA
> > > memory/resources.
> > My impression was the FW should either generate SATA_EVENT or
> > SATA_COPMLETION, but not both, was this behavior changed?
>
> I too had same impression when started to look into
> pm80xx code. But that is not the case after going
> through the firmware spec. 'During events the command
> is still with the firmware.'
>
> In some cases we may get SATA_EVENT as well as
> SATA_COMPLETION for the same command
> i.e. event() first and then completion().
>
> Thanks,
> Ajish
Ok, if the firmware spec states that, then I think it's the right change.
Please check and fix SSP case too.

Thanks

Acked-by: Jack Wang <jinpu.wang@ionos.com>
>
> >
> > Thanks!
> >
> > >
> > > That's one side effect right now.
> > >
> > > Another instance I can see is during I/O, host will free the tag once
> > > we receive an event, same tag/command is still pending in the firmware
> > > and post this event host re-allocates this tag to some other new
> > > request. This may lead to some un-expected situation.
> > >
> > > That is what I can visualize right now as side effects without this
> > > patch.
> > >
> > > Thanks,
> > > Ajish
> > >
>
