Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E38C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 03:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbiEEDGB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 23:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240356AbiEEDF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 23:05:56 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A072D245A7
        for <linux-scsi@vger.kernel.org>; Wed,  4 May 2022 20:02:13 -0700 (PDT)
X-QQ-mid: bizesmtp91t1651719712tr7ccd8w
Received: from mail-qk1-f173.google.com ( [209.85.222.173])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 05 May 2022 11:01:50 +0800 (CST)
X-QQ-SSF: 01400000008000B0D000B00A0000000
X-QQ-FEAT: k0yT7W7BRd3U1025a3U/i5S/kct1X5tWuD1+2WyfFsa8O6Jz6fKR9nGJd0vfL
        2M1Pp1P7FrFH+fZuAFuTXQRyIdAJIy6WoPDybw5wThQbUDSYy1z/6zCQkZ20tuVne2EfJCH
        mGDwRD2nnUASwqmVJ2zzuUQ3r9OOrTZDywK/mC+AXbatsiECTlCOrnN1W2J5wXnId2PMzMr
        2Y+bdbSd+HCf9l4/KJpZmCtV0SmzYlFV7VHNKUK98OCgykTQKSnamqxZvvOZLXLwFpH0MUS
        YpWmiO2kb/sRa8IwPNI/ToDYbQNBihZwx3D4uJZYIWZ2Jowpv0fXTcQhGMAk1PVryen/H3S
        Rwz7Fcm
X-QQ-GoodBg: 2
Received: by mail-qk1-f173.google.com with SMTP id z126so2358649qkb.2;
        Wed, 04 May 2022 20:01:51 -0700 (PDT)
X-Gm-Message-State: AOAM530HrJKaOxsfMWAzMs5eM3d8InDdZClDx+E+N2/l9PVPf0MTnW7o
        V8pi7AB4FOFlM3PjHl/Agfidn6LapeREhVrBzlY=
X-Google-Smtp-Source: ABdhPJwKL82ySEUa93ww3YD5MCh2DdPRGW79kYFlPEGClcOFe5n5TiO3U8tcBLrn+zgHpvGsuMsJpA1QUfuCUAOx26E=
X-Received: by 2002:a37:54c4:0:b0:67e:9cbf:a984 with SMTP id
 i187-20020a3754c4000000b0067e9cbfa984mr19031192qkb.215.1651719708746; Wed, 04
 May 2022 20:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220427090906.2257940-1-jinxiaobo@uniontech.com> <yq1sfpxkjpo.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1sfpxkjpo.fsf@ca-mkp.ca.oracle.com>
From:   job jin <jinxiaobo@uniontech.com>
Date:   Thu, 5 May 2022 11:01:37 +0800
X-Gmail-Original-Message-ID: <CAEYFbwUBLJg5GEHBxd3xj77XbEwKXWOBV2wBo1AWs0THZCS-+w@mail.gmail.com>+7EADFA0502959A5A
Message-ID: <CAEYFbwUBLJg5GEHBxd3xj77XbEwKXWOBV2wBo1AWs0THZCS-+w@mail.gmail.com>
Subject: Re: [PATCH] scsi: sr: Fix some cdroms automatically ejected when
 booting into the system
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin K. Petersen!

As things stand, we cannot guarantee that all events will be propagated
 to udev. So I think, we don't need to ensure that all events are received
 by udev, we only need to ensure that events after sr probe can be received
 by udev and actively discard events before sr probe.



>
>
> Hi jinxiaobo!
>
> > sr_get_events() has been called before udev starts when SCSI CDROM is
> > built-in and AHCI SATA is bulit-in,so sr events propagated to user
> > space are not handled.  if both is loadable, udev will handle sr
> > events, some cdroms may eject.  We need call sr_get_events() once
> > before device_add_disk() to keep the same result, whether both are
> > built-in or loadable.
>
> I am not sure how calling sr_get_events() and throwing away the result
> ensures that events get propagated to udev. Isn't this just changing
> timing slightly?
>
> --
> Martin K. Petersen      Oracle Linux Engineering
>


