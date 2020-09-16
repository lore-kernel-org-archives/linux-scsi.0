Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14B5C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 07:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7471C2078D
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 07:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cC/1fnUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgIPHt3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 03:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIPHt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2020 03:49:27 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998BFC06174A
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2020 00:49:27 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id j2so7217520ioj.7
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2020 00:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DLOTeWBFnCm2PlwaPzC1zi1amM7JjB5HOCihfaodC9Y=;
        b=cC/1fnUgW/w9gJ3r6kam6nz73nE5ZxpfGs9XgaDMVkwrTIRxT6K5mLMUOjaPuKfNHD
         bDpRqrCploPjlipX7ElgR9Xxgm1Idu1xydlA9VrcPfLH6JVmzDJe6tPeXP8fNNCFrfoS
         +YcXcHdgxWRQd7Ra1S3hWN0hnTodfBpcYNyErwEVIUjYB3C9kh8WvcZUOPWLYjYP84gy
         Oqfwe1m2DSjHCmd/EWsBIVH1Itg/WY31+f+R8eCc1zF4bSdBQXE5MyTcDMzNoINbsjYr
         rUURm55ksbO9UEyqg1qXqeyUmpZsHROsAFCCc+LptszRIZ/cjTdnvfvDhpD6Ef314yZh
         IDig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DLOTeWBFnCm2PlwaPzC1zi1amM7JjB5HOCihfaodC9Y=;
        b=ZBDjgnTZlyJSXKyHV1oyIUUchm4DmxODyBJqz2qQgwom7KMUOeyO4zqOKBxjk5GngQ
         a4y/Yoo+vz4f0B80Tj5FGjw/EMsWP+CiXo2ppRGTz6e1mUESWuAD7Ekk/FGNIwGnKkr9
         x0mJDJP+h6mODpNwVj1o4fmwmbiNwjWBF5+pws8DKcOJtOP9ejSGVcV/a0RTKndM1Tv6
         G7VJL5dKyvuTrNtBQZsGU6Xvrlhx6yONfBZ35sEM+JuhFiLdaHR4Wp3sE/Tlq5dTKSlk
         m6CbLhPkw7XLZZrL9My7w0RGRpqgWZi31a7IV9wjCNpF1pOo8pNKrTZfjA8q+lQ0xNv9
         7e+g==
X-Gm-Message-State: AOAM533uSYgZepTjxvaRIIo2Szyq641Q8zCcR9kqdGTMB58cAbAfukCw
        1J7qrgcu2ihJt56OAOOxwEeNxXSuPFe9LHbi/PIa/+5KHnmpig==
X-Google-Smtp-Source: ABdhPJwaIfZRgigfgblZySG7ElSAQV1rxHoi4xIa6xag6dtMyyf68vRNBF398VBvyK/i3tw5UWurNWMt3no/E0+hfV4=
X-Received: by 2002:a02:cbda:: with SMTP id u26mr21173968jaq.71.1600242566668;
 Wed, 16 Sep 2020 00:49:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAOOPZo448A7-qg6gpJqMF6TmnUWVXL3=A4nEo2pKVRt3iEkGrA@mail.gmail.com>
 <2420F4B8-5DAE-4A8D-B519-70F3665C41E8@oracle.com> <CAOOPZo5y8XHXKTgyG3nsguOeipL62uKJxKx0HSC8t7uS5hxH=A@mail.gmail.com>
 <D01377DD-2E86-427B-BA0C-8D7649E37870@oracle.com>
In-Reply-To: <D01377DD-2E86-427B-BA0C-8D7649E37870@oracle.com>
From:   Zhengyuan Liu <liuzhengyuang521@gmail.com>
Date:   Wed, 16 Sep 2020 15:49:15 +0800
Message-ID: <CAOOPZo473qY3WHphi=4N730kyGPzMG1nw7S+HVU9Fu1pKHUGOQ@mail.gmail.com>
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

On Tue, Sep 15, 2020 at 11:16 PM Himanshu Madhani
<himanshu.madhani@oracle.com> wrote:
>
>
>
> > On Sep 13, 2020, at 9:36 PM, Zhengyuan Liu <liuzhengyuang521@gmail.com>=
 wrote:
> >
> > On Sat, Sep 12, 2020 at 1:37 AM Himanshu Madhani
> > <himanshu.madhani@oracle.com> wrote:
> >>
> >> Hi,
> >>
> >>> On Sep 10, 2020, at 9:26 PM, Zhengyuan Liu <liuzhengyuang521@gmail.co=
m> wrote:
> >>>
> >>> Hi,
> >>>
> >>> There is a panic of NULL pointer dereference on my arm64 server when
> >>> boot  with the fabric line  plugged into the HBA of QLE2692. After
> >>> binary-search with git bisect I found this panic is introduced by
> >>> commit 4984a06bf094 ("scsi: qla2xxx: Remove all rports if fabric scan
> >>> retry fails"). The upstream and 4.19-stable both had the same problem
> >>> when reset to this point. but the upstream had fix this
> >>> unintentionally after commit da61ef053bcf ("scsi: qla2xxx: Reduce
> >>> holding sess_lock to prevent CPU") while the latest 4.19-stable still
> >>> has this issue. the panic showed as following:
> >>>
> >>> [   13.380405][  0] Unable to handle kernel NULL pointer dereference
> >>> at virtual address 0000000000000000
> >>> [   13.390947][  0] Mem abort info:
> >>> [   13.395535][  0]   ESR =3D 0x96000045
> >>> [   13.400390][  0]   Exception class =3D DABT (current EL), IL =3D 3=
2 bits
> >>> [   13.408089][  0]   SET =3D 0, FnV =3D 0
> >>> .
> >>> [   13.412941][  0]   EA =3D 0, S1PTW =3D 0
> >>> [   13.416747][  0] Data abort info:
> >>> [   13.420048][  0]   ISV =3D 0, ISS =3D 0x00000045
> >>> [   13.424293][  0]   CM =3D 0, WnR =3D 1
> >>> [   13.427676][  0] user pgtable: 64k pages, 48-bit VAs, pgdp =3D (__=
__ptrval____)
> >>> [   13.434778][  0] [0000000000000000] pgd=3D0000000000000000,
> >>> pud=3D0000000000000000
> >>> [   13.441968][  0] Internal error: Oops: 96000045 [#1] SMP
> >>> [   13.447250][  0] Modules linked in: qla2xxx nvme_fc nvme_fabrics
> >>> scsi_transport_fc igb megaraid_sas dm_snapshot iscsi_tcp libiscsi_tcp
> >>> libs
> >>> [   13.472588][  0] Process kworker/0:2 (pid: 343, stack limit =3D
> >>> 0x(____ptrval____))
> >>> [   13.472675][  5] audit: type=3D1130 audit(1599118767.260:14): pid=
=3D1
> >>> uid=3D0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dinitrd-parse=
-etc
> >>> comm=3D"sy'
> >>> [   13.480032][  0] CPU: 0 PID: 343 Comm: kworker/0:2 Tainted: G
> >>> W         4.19.90-19.ky10.aarch64 #1
> >>> [   13.480033][  5] Hardware name: GreatWall, BIOS 601FBE28 2020/04/2=
0
> >>> [   13.480045][  0] Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2x=
xx]
> >>> [   13.499248][  0] audit: type=3D1131 audit(1599118767.260:15): pid=
=3D1
> >>> uid=3D0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dinitrd-parse=
-etc
> >>> comm=3D"sy'
> >>> [   13.508759][  0] pstate: 40000005 (nZcv daif -PAN -UAO)
> >>> [   13.547687][ 24] pc : __memset+0x16c/0x188
> >>> [   13.547697][  0] lr : qla24xx_async_gpnft+0x194/0x950 [qla2xxx]
> >>> [   13.547701][  0] sp : ffffb2158236bc60
> >>> [   13.561388][  0] x29: ffffb2158236bc60 x28: 0000000000000000
> >>> [   13.567104][  0] x27: ffff3be824ac0148 x26: ffff3be824ac00b8
> >>> [   13.572820][  0] x25: ffff3be824b031e0 x24: 0000000000000028
> >>> [   13.578535][  0] x23: ffffb2158600d188 x22: ffffb21586d3ea38
> >>> [   13.584251][  0] x21: 0000000000008010 x20: ffffb21586d3ea08
> >>> [   13.589968][  0] x19: ffffb2158600d040 x18: 0000000000000400
> >>> [   13.595683][  0] x17: 0000000000000000 x16: ffff3be83f9a9500
> >>> [   13.601398][  0] x15: 0000000000000400 x14: 0000000000000400
> >>> [   13.607114][  0] x13: 0000000000000189 x12: 0000000000000001
> >>> [   13.612829][  0] x11: 0000000000000000 x10: 0000000000000b40
> >>> [   13.618544][  0] x9 : 0000000000000000 x8 : 0000000000000000
> >>> [   13.624259][  0] x7 : 0000000000000000 x6 : 000000000000003f
> >>> [   13.629974][  0] x5 : 0000000000000040 x4 : 0000000000000000
> >>> [   13.635689][  0] x3 : 0000000000000004 x2 : 0000000000007fd0
> >>> [   13.641404][  0] x1 : 0000000000000000 x0 : 0000000000000000
> >>> [   13.647119][  0] Call trace:
> >>> [   13.649983][  0]  __memset+0x16c/0x188
> >>> [   13.653718][  0]  qla2x00_do_work+0x398/0x440 [qla2xxx]
> >>> [   13.658920][  0]  qla2x00_iocb_work_fn+0x50/0xe8 [qla2xxx]
> >>> [   13.664378][  0]  process_one_work+0x1f0/0x3c8
> >>> [   13.668797][  0]  worker_thread+0x48/0x4d0
> >>> [   13.672871][  0]  kthread+0x128/0x130
> >>> [   13.676514][  0]  ret_from_fork+0x10/0x18
> >>> [   13.680503][  0] Code: 91010108 54ffff4a 8b040108 cb050042 (d50b74=
28)
> >>> [   13.687027][  0] ---[ end trace 258cdcdd74a25238 ]---
> >>> [   13.692051][  0] Kernel panic - not syncing: Fatal exception
> >>
> >> Have you tried applying commit da61ef053bcf ("scsi: qla2xxx: Reduce ho=
lding sess_lock to prevent CPU=E2=80=9D) to confirm if it resolves your pan=
ic. It does look like the panic should resolve with the changes in that pat=
ch.
> >>
> >> If you are able to verify then we can request for sable back port with=
 your reported-by and tested-by tags.
> >
> > Yes, it did resolve my panic after backporting that commit to
> > 4.19-stable. But I cannot apply that commit directly, in order to
> > resolve the conflict I also backported commit:
> > 3b1e23aacf80 ("scsi: qla2xxx: Update rscn_rcvd field to more meaningful=
").
> > a4863b16c31e ("scsi: qla2xxx: Move rport registration out of internal")=
.
> >
>
> These patches looks good for the 4.19-stable back port.
>
> Please post it to stable with Reported-by and Tested-by tag.

I had posted those patches to stable@vger.kernel.org and cc to you but
I have no idea why the mail server denied my address.
Please help me forward the email to stable list, thanks.

>
> Thanks.
>
> >>
> >> --
> >> Himanshu Madhani         Oracle Linux Engineering
>
> --
> Himanshu Madhani         Oracle Linux Engineering
>
