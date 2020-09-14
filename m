Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC05CC43461
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 02:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66C792177B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 02:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bbVUdl02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgINCgy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 22:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgINCgw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 22:36:52 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A447C06174A
        for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2020 19:36:52 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y2so15237039ilp.7
        for <linux-scsi@vger.kernel.org>; Sun, 13 Sep 2020 19:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MfHzs0r2ylWNpmavjjgh2o5orMeYgirxLm86tom16C4=;
        b=bbVUdl02dJm5TMrlo3gOv1K7TDppV2sT8Mmi3aOIlxfdxxEWBloUpLxv9wZouN8gEQ
         EEKQREK4TZnzz14+I/5NpJFWElAQUmcx+B9wcBRWkE5bbvJQRMSEKmXot2aWne+HkWs9
         f+tqFvZF+qSJ1MMLDVo5d0NGEz6hMKLSF1WMqrj+MxKFECtqYFE7yxtMtB862ii5h/Yc
         mtMfwkk4ydo18dKnoq/CehRBy+3JxjAKK/nBxSBu7mQb/zZJjdHMfLtf69ugVYzkowva
         9c/vj3K97FAEWlouZatUJAa1ED92KD+slOMckGqcg1C8Cgy6+OnLh0WsRk2XMEqjvseG
         KICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MfHzs0r2ylWNpmavjjgh2o5orMeYgirxLm86tom16C4=;
        b=P0L75r7wven9BxUuyCwvuxvsOrB8Tfr0MEXt4c+HY12eZAl/2HID8MUix9MGrLxt59
         1E7agzT6Wc11XbYeC6XQum+UTos9G+Vwql5ejV+ABsJ+OzaxWBQRug+u1ekHX9/fAfZc
         SSSb5BJBN5Kg7Ij/GaN9Zanr4dSvxHGBdPykvGOI4Ul7+I3vU7hs6t61DtnEobqpzoP8
         EYZ8B6/qxmnoCaDUOPNs2uytFfLl7Zu/a/3Yt2Q61gMOUaYfK2tMPZ9iBf4K+s9RawGz
         7TW5mx9D4HLICpSI3yq08bmEGI4V9dMvuMbSw6XN/jWZOptnjnBfgjhNkhznPuYUfntU
         g6rA==
X-Gm-Message-State: AOAM533dv5ehTVGGu2Lc2nyc5oTeagrurVfyVCgTV6Fn6SChUUsqmZjU
        5FUpwuxRonvBdJK2UJFo1y5TsSH4GKGaYb7U3ik=
X-Google-Smtp-Source: ABdhPJxhdYW59axXiC4E+QSbF32wjp2gwoiEbpuzmw3OHXUjnS+3PqudUOvgxhrKRoUdVZVZGhBlnQWLpCt3cuckbQA=
X-Received: by 2002:a92:3007:: with SMTP id x7mr10494794ile.48.1600051010723;
 Sun, 13 Sep 2020 19:36:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAOOPZo448A7-qg6gpJqMF6TmnUWVXL3=A4nEo2pKVRt3iEkGrA@mail.gmail.com>
 <2420F4B8-5DAE-4A8D-B519-70F3665C41E8@oracle.com>
In-Reply-To: <2420F4B8-5DAE-4A8D-B519-70F3665C41E8@oracle.com>
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Mon, 14 Sep 2020 10:36:39 +0800
Message-ID: <CAOOPZo5y8XHXKTgyG3nsguOeipL62uKJxKx0HSC8t7uS5hxH=A@mail.gmail.com>
Subject: Re: qla2xxx panic with 4.19-stable
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org,
        liuzhengyuan@tj.kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 12, 2020 at 1:37 AM Himanshu Madhani
<himanshu.madhani@oracle.com> wrote:
>
> Hi,
>
> > On Sep 10, 2020, at 9:26 PM, Zhengyuan Liu <liuzhengyuang521@gmail.com>=
 wrote:
> >
> > Hi,
> >
> > There is a panic of NULL pointer dereference on my arm64 server when
> > boot  with the fabric line  plugged into the HBA of QLE2692. After
> > binary-search with git bisect I found this panic is introduced by
> > commit 4984a06bf094 ("scsi: qla2xxx: Remove all rports if fabric scan
> > retry fails"). The upstream and 4.19-stable both had the same problem
> > when reset to this point. but the upstream had fix this
> > unintentionally after commit da61ef053bcf ("scsi: qla2xxx: Reduce
> > holding sess_lock to prevent CPU") while the latest 4.19-stable still
> > has this issue. the panic showed as following:
> >
> > [   13.380405][  0] Unable to handle kernel NULL pointer dereference
> > at virtual address 0000000000000000
> > [   13.390947][  0] Mem abort info:
> > [   13.395535][  0]   ESR =3D 0x96000045
> > [   13.400390][  0]   Exception class =3D DABT (current EL), IL =3D 32 =
bits
> > [   13.408089][  0]   SET =3D 0, FnV =3D 0
> > .
> > [   13.412941][  0]   EA =3D 0, S1PTW =3D 0
> > [   13.416747][  0] Data abort info:
> > [   13.420048][  0]   ISV =3D 0, ISS =3D 0x00000045
> > [   13.424293][  0]   CM =3D 0, WnR =3D 1
> > [   13.427676][  0] user pgtable: 64k pages, 48-bit VAs, pgdp =3D (____=
ptrval____)
> > [   13.434778][  0] [0000000000000000] pgd=3D0000000000000000,
> > pud=3D0000000000000000
> > [   13.441968][  0] Internal error: Oops: 96000045 [#1] SMP
> > [   13.447250][  0] Modules linked in: qla2xxx nvme_fc nvme_fabrics
> > scsi_transport_fc igb megaraid_sas dm_snapshot iscsi_tcp libiscsi_tcp
> > libs
> > [   13.472588][  0] Process kworker/0:2 (pid: 343, stack limit =3D
> > 0x(____ptrval____))
> > [   13.472675][  5] audit: type=3D1130 audit(1599118767.260:14): pid=3D=
1
> > uid=3D0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dinitrd-parse-e=
tc
> > comm=3D"sy'
> > [   13.480032][  0] CPU: 0 PID: 343 Comm: kworker/0:2 Tainted: G
> > W         4.19.90-19.ky10.aarch64 #1
> > [   13.480033][  5] Hardware name: GreatWall, BIOS 601FBE28 2020/04/20
> > [   13.480045][  0] Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2xxx=
]
> > [   13.499248][  0] audit: type=3D1131 audit(1599118767.260:15): pid=3D=
1
> > uid=3D0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dinitrd-parse-e=
tc
> > comm=3D"sy'
> > [   13.508759][  0] pstate: 40000005 (nZcv daif -PAN -UAO)
> > [   13.547687][ 24] pc : __memset+0x16c/0x188
> > [   13.547697][  0] lr : qla24xx_async_gpnft+0x194/0x950 [qla2xxx]
> > [   13.547701][  0] sp : ffffb2158236bc60
> > [   13.561388][  0] x29: ffffb2158236bc60 x28: 0000000000000000
> > [   13.567104][  0] x27: ffff3be824ac0148 x26: ffff3be824ac00b8
> > [   13.572820][  0] x25: ffff3be824b031e0 x24: 0000000000000028
> > [   13.578535][  0] x23: ffffb2158600d188 x22: ffffb21586d3ea38
> > [   13.584251][  0] x21: 0000000000008010 x20: ffffb21586d3ea08
> > [   13.589968][  0] x19: ffffb2158600d040 x18: 0000000000000400
> > [   13.595683][  0] x17: 0000000000000000 x16: ffff3be83f9a9500
> > [   13.601398][  0] x15: 0000000000000400 x14: 0000000000000400
> > [   13.607114][  0] x13: 0000000000000189 x12: 0000000000000001
> > [   13.612829][  0] x11: 0000000000000000 x10: 0000000000000b40
> > [   13.618544][  0] x9 : 0000000000000000 x8 : 0000000000000000
> > [   13.624259][  0] x7 : 0000000000000000 x6 : 000000000000003f
> > [   13.629974][  0] x5 : 0000000000000040 x4 : 0000000000000000
> > [   13.635689][  0] x3 : 0000000000000004 x2 : 0000000000007fd0
> > [   13.641404][  0] x1 : 0000000000000000 x0 : 0000000000000000
> > [   13.647119][  0] Call trace:
> > [   13.649983][  0]  __memset+0x16c/0x188
> > [   13.653718][  0]  qla2x00_do_work+0x398/0x440 [qla2xxx]
> > [   13.658920][  0]  qla2x00_iocb_work_fn+0x50/0xe8 [qla2xxx]
> > [   13.664378][  0]  process_one_work+0x1f0/0x3c8
> > [   13.668797][  0]  worker_thread+0x48/0x4d0
> > [   13.672871][  0]  kthread+0x128/0x130
> > [   13.676514][  0]  ret_from_fork+0x10/0x18
> > [   13.680503][  0] Code: 91010108 54ffff4a 8b040108 cb050042 (d50b7428=
)
> > [   13.687027][  0] ---[ end trace 258cdcdd74a25238 ]---
> > [   13.692051][  0] Kernel panic - not syncing: Fatal exception
>
> Have you tried applying commit da61ef053bcf ("scsi: qla2xxx: Reduce holdi=
ng sess_lock to prevent CPU=E2=80=9D) to confirm if it resolves your panic.=
 It does look like the panic should resolve with the changes in that patch.
>
> If you are able to verify then we can request for sable back port with yo=
ur reported-by and tested-by tags.

Yes, it did resolve my panic after backporting that commit to
4.19-stable. But I cannot apply that commit directly, in order to
resolve the conflict I also backported commit:
 3b1e23aacf80 ("scsi: qla2xxx: Update rscn_rcvd field to more meaningful").
 a4863b16c31e ("scsi: qla2xxx: Move rport registration out of internal").

>
> --
> Himanshu Madhani         Oracle Linux Engineering
>
