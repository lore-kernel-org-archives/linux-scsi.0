Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F395CC04A94
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 16:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjGXQ2r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 12:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjGXQ2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 12:28:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8340125
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 09:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690216080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/q1M3frn/kIM/eRSovVFItIpuBu0xQYXg5rsHI5knGY=;
        b=HwXt1CeGJQ/ZSkNnlX3KAfRUKR3iMeuDweoCxnCUOGfqiCQCIPR0VjuGB5mOEb2FSLq+QE
        Dhs8CYbY9XENWByedar6dLm8Ua0PicEATI7/dOoxFywQUZqPUMcxBWUVcavZ//60gxBlyF
        ncNDpDv1QcB67PKhWbZsc6HdyuodTfE=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-RLcboao8NOSEp-pdGU4jgw-1; Mon, 24 Jul 2023 12:27:58 -0400
X-MC-Unique: RLcboao8NOSEp-pdGU4jgw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-583a89cccf6so24187647b3.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 09:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690216078; x=1690820878;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/q1M3frn/kIM/eRSovVFItIpuBu0xQYXg5rsHI5knGY=;
        b=eS3dtvTvP8ki8gyrSAhDX5uSqUxDtjRMhHRYEQBp/zYOJ8psXvXytS0LlO0DM6OHxJ
         nN3cL7JUn/OQYLWhRzBgCKB8y1ffH6xQTCyqeDcTC4GHcaQV73KyGY/CsB9pglpGIybm
         AcLyqp2Smo1R2tHwGHz/lna/jxFiSyWyL+hQgiAgADnjYhyCGd04z+fk/AI7WduQkYQn
         yLv5rCvM9p0tomY3hkn0ugfl8EqKdD05RmOVdxUpvI2pJ7KsVgX1LvaGsp7k/OIY54+u
         0H+43l7SimaeMPFxk4MKgGXFJmUEcDMXSmuLIrn+h2azTfGt7Gxv4lS1D9oeEGoowGnC
         Ov1A==
X-Gm-Message-State: ABy/qLa6hla9Nly53hTJm6LblTrV70ySY3173EfgfIbIDXcam3cbHeLY
        Pc178m0iWNs8K1+grnRUdQ3jvUSSXtPo0XtpIkEwU5DKG6AWChk/ysS97Y1utVUY/Q83wplD8PC
        tr+xNUs91AZ/ZB7LHA9E4yw==
X-Received: by 2002:a0d:ea46:0:b0:583:fa2b:26d2 with SMTP id t67-20020a0dea46000000b00583fa2b26d2mr2714963ywe.7.1690216078144;
        Mon, 24 Jul 2023 09:27:58 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGqhDGqbKivicLOzFznS5VksXqmDbS43FPuhJhY1yE7ZQrqDLYL7qAQEACeSKhL4nMhr4rjzA==
X-Received: by 2002:a0d:ea46:0:b0:583:fa2b:26d2 with SMTP id t67-20020a0dea46000000b00583fa2b26d2mr2714946ywe.7.1690216077876;
        Mon, 24 Jul 2023 09:27:57 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:2613:173:a68a:fce8? ([2600:6c64:4e7f:603b:2613:173:a68a:fce8])
        by smtp.gmail.com with ESMTPSA id a65-20020a0df144000000b0057726fce046sm2879448ywf.26.2023.07.24.09.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 09:27:57 -0700 (PDT)
Message-ID: <4f35b02968a18e636e1689c9d52729ef63a438f9.camel@redhat.com>
Subject: Re: [RFC PATCH 0/3] scsi: qedf: sanitise uaccess
From:   Laurence Oberman <loberman@redhat.com>
To:     Oleksandr Natalenko <oleksandr@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jozef Bacik <jobacik@redhat.com>, Rob Evers <revers@redhat.com>
Date:   Mon, 24 Jul 2023 12:27:55 -0400
In-Reply-To: <dd7c6170def7159b558b79d34520c3d5290e36b9.camel@redhat.com>
References: <20230724120241.40495-1-oleksandr@redhat.com>
         <dd7c6170def7159b558b79d34520c3d5290e36b9.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-07-24 at 09:03 -0400, Laurence Oberman wrote:
> On Mon, 2023-07-24 at 14:02 +0200, Oleksandr Natalenko wrote:
> > qedf driver, debugfs part of it specifically, touches __user
> > pointers
> > directly for printing out info to userspace via sprintf(), which
> > may
> > cause crash like this:
> >=20
> > BUG: unable to handle kernel paging request at 00007ffd1d6b43a0
> > IP: [<ffffffffaa7a882a>] string.isra.7+0x6a/0xf0
> > Oops: 0003 [#1] SMP
> > Call Trace:
> > =C2=A0[<ffffffffaa7a9f31>] vsnprintf+0x201/0x6a0
> > =C2=A0[<ffffffffaa7aa556>] sprintf+0x56/0x80
> > =C2=A0[<ffffffffc04227ed>] qedf_dbg_stop_io_on_error_cmd_read+0x6d/0x90
> > [qedf]
> > =C2=A0[<ffffffffaa65bb2f>] vfs_read+0x9f/0x170
> > =C2=A0[<ffffffffaa65cb82>] SyS_pread64+0x92/0xc0
> >=20
> > Avoid this by preparing the info in a kernel buffer first, either
> > allocated on stack for small printouts, or via vmalloc() for big
> > ones,
> > and then copying it to the userspace properly.
> >=20
> > I'm not sure how big the vmalloc()'ed buffer should be, and also
> > whether
> > vmalloc()'ing it directly in the _read() function is a good idea,
> > hence
> > RFC prefix.
> >=20
> > The qedf_dbg_stop_io_on_error_cmd_read()-related patch is actually
> > tested,
> > the rest is compile-tested only.
> >=20
> > Oleksandr Natalenko (3):
> > =C2=A0 scsi: qedf: do not touch __user pointer in
> > =C2=A0=C2=A0=C2=A0 qedf_dbg_stop_io_on_error_cmd_read() directly
> > =C2=A0 scsi: qedf: do not touch __user pointer in
> > qedf_dbg_debug_cmd_read()
> > =C2=A0=C2=A0=C2=A0 directly
> > =C2=A0 scsi: qedf: do not touch __user pointer in
> > qedf_dbg_fp_int_cmd_read()
> > =C2=A0=C2=A0=C2=A0 directly
> >=20
> > =C2=A0drivers/scsi/qedf/qedf_dbg.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> > =C2=A0drivers/scsi/qedf/qedf_debugfs.c | 35 +++++++++++++++++++--------=
-
> > --
> > --
> > =C2=A02 files changed, 23 insertions(+), 14 deletions(-)
> >=20
> > --
> > 2.41.0
> >=20
>=20
> I will test the series, the one patch was already tested.
> This was reproduced in our LAB
> Will report back after testing
>=20
> Regards
> Laurence

For the series:  Against 6.5.0-rc3
Makes sense to me and tested.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by: Laurence Oberman <loberman@redhat.com>


[root@segstorage5 host2]# ls
clear_stats  debug  driver_stats  fp_int  io_trace  offload_stats=20
stop_io_on_error
[root@segstorage5 host2]# cat stop_io_on_error
false
[root@segstorage5 host2]# cat debug
debug mask =3D 0x2
[root@segstorage5 host2]# cat fp_int

Fastpath I/O completions

#0: 792
#1: 1242
#2: 1151
#3: 978
#4: 775
#5: 855
#6: 899
#7: 643
#8: 801
#9: 1013
#10: 956
#11: 678
#12: 703
#13: 817
#14: 932
#15: 614

