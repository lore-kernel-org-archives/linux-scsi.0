Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53340EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 14:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjGLOWA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 10:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjGLOV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 10:21:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA11812E
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 07:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689171671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EczEn/QZT0UNDQndUq23zxvPioEXkz8LDWAC9w3gIag=;
        b=NSOnQOXd5hS4dhxXn42CSwsRlfQPt+Ez0ztfIQ5zBRysd4p8Q62V5pFtAm+K10w998M7Hg
        Z4Vq15gBuBUGPxohC6Aujub5+2u3IZ+/DNoZt3nlfKbDpR8Q2GdrgRhSUqJSWCqxBgs1rh
        QAL/46xppIeAhX/5Ha97scZR06jNlx0=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-yGUOQTbTN0-IBiQCAXPltw-1; Wed, 12 Jul 2023 10:21:10 -0400
X-MC-Unique: yGUOQTbTN0-IBiQCAXPltw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-564fb1018bcso68950197b3.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 07:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689171670; x=1691763670;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EczEn/QZT0UNDQndUq23zxvPioEXkz8LDWAC9w3gIag=;
        b=QcNqWptp1irASQMdhACkvOBdcwWWtlo2UbcH77zN4u7Lcg7ZZ4X0iC2yIWGQ6mBCYc
         BD37IU4nN2RLRFstT4Oi6gJBOZKL8+2Jh3DaKBACdoNdq+0JmPxZFsrWL1l7HH+RSrr6
         8qqPM3ImLbkjD0QHiadOCeyos87UKh7x9V4M2QtwYGdd+mHfrxxDNbtTFaMzGk+AYmRk
         ECj6n528znC7Mpp/hNLOjZn5YeImg4k6YpuA2PThDqmLNVVCTT4W+AbF6M069NweSmEq
         /owA1FDEejr2QTowbUJ5LN6JrjEUS/VFxU/pRDwVq9Ga+z7bywi1NE0zp+vC33hd0AtW
         s6mA==
X-Gm-Message-State: ABy/qLZfkc1z9fw8UvKivzHOhBr2x+hJisk7yi0JneUCRIJIfizZsEcx
        wBlVTsnLK4WsTp5KClom9zj+GixIzIfqw0sweBcpHnLAWCIuoAk3WiAbjry0cTIC09W7pM4SRgj
        rUi5QfJZBuuxRFyHg46U5NKFifM+0JFifMx3y4A==
X-Received: by 2002:a81:688a:0:b0:576:8a5a:87e5 with SMTP id d132-20020a81688a000000b005768a5a87e5mr18516320ywc.26.1689171669946;
        Wed, 12 Jul 2023 07:21:09 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG/D8pzREiR+H7EZ6lhBKgSiC/r5Yy94lIHpQ+bs5TgxVtyzTF/cpY5WTpaJXgp4dTzmrgLF7qtCXzz23NYTk8=
X-Received: by 2002:a81:688a:0:b0:576:8a5a:87e5 with SMTP id
 d132-20020a81688a000000b005768a5a87e5mr18516308ywc.26.1689171669712; Wed, 12
 Jul 2023 07:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230705071523.15496-1-sgarzare@redhat.com> <i3od362o6unuimlqna3aaedliaabauj6g545esg7txidd4s44e@bkx5des6zytx>
 <765f14c5-a938-ebd9-6383-4fe3d5c812ca@oracle.com> <10a3d00f-a3a2-91d1-0f94-9758cdc4b969@redhat.com>
 <bnitgwesvbjdkbrvnykltherzddi3zvms3ckd5yk3w4whdplu3@tv43e42wjl55>
In-Reply-To: <bnitgwesvbjdkbrvnykltherzddi3zvms3ckd5yk3w4whdplu3@tv43e42wjl55>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Wed, 12 Jul 2023 16:20:56 +0200
Message-ID: <CAGxU2F4o4cr6jaHypLs_5ma8ZuNQmx4KQVMjs4GrSYd-nnLcUw@mail.gmail.com>
Subject: Re: [PATCH] Revert "virtio-scsi: Send "REPORTED LUNS CHANGED" sense
 data upon disk hotplug events"
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, Fam Zheng <fam@euphon.net>,
        Thomas Huth <thuth@redhat.com>,
        Mark Kanda <mark.kanda@oracle.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-stable@nongnu.org,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 12, 2023 at 12:14=E2=80=AFPM Stefano Garzarella <sgarzare@redha=
t.com> wrote:
>
> On Wed, Jul 12, 2023 at 10:06:56AM +0200, Paolo Bonzini wrote:
> >On 7/11/23 22:21, Mike Christie wrote:
> >>What was the issue you are seeing?
> >>
> >>Was it something like you get the UA. We retry then on one of the
> >>retries the sense is not setup correctly, so the scsi error handler
> >>runs? That fails and the device goes offline?
> >>
> >>If you turn on scsi debugging you would see:
> >>
> >>
> >>[  335.445922] sd 0:0:0:0: [sda] tag#15 Add. Sense: Reported luns data =
has changed
> >>[  335.445922] sd 0:0:0:0: [sda] tag#16 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.445925] sd 0:0:0:0: [sda] tag#16 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.445929] sd 0:0:0:0: [sda] tag#17 Done: FAILED Result: hostbyte=
=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
> >>[  335.445932] sd 0:0:0:0: [sda] tag#17 CDB: Write(10) 2a 00 00 db 4f c=
0 00 00 20 00
> >>[  335.445934] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.445936] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.445938] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.445940] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.445942] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.445945] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
> >>[  335.451447] scsi host0: scsi_eh_0: waking up 0/2/2
> >>[  335.451453] scsi host0: Total of 2 commands on 1 devices require eh =
work
> >>[  335.451457] sd 0:0:0:0: [sda] tag#16 scsi_eh_0: requesting sense
> >
> >Does this log come from internal discussions within Oracle?
> >
> >>I don't know the qemu scsi code well, but I scanned the code for my co-=
worker
> >>and my guess was commit 8cc5583abe6419e7faaebc9fbd109f34f4c850f2 had a =
race in it.
> >>
> >>How is locking done? when it is a bus level UA but there are multiple d=
evices
> >>on the bus?
> >
> >No locking should be necessary, the code is single threaded.  However,
> >what can happen is that two consecutive calls to
> >virtio_scsi_handle_cmd_req_prepare use the unit attention ReqOps, and
> >then the second virtio_scsi_handle_cmd_req_submit finds no unit
> >attention (see the loop in virtio_scsi_handle_cmd_vq).  That can
> >definitely explain the log above.
>
> Yes, this seems to be the case!
> Thank you both for the help!
>
> Following Paolo's advice, I'm preparing a series for QEMU to solve the
> problem!

Series posted here:
https://lore.kernel.org/qemu-devel/20230712134352.118655-1-sgarzare@redhat.=
com/

Stefano

