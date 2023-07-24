Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECA2C001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 13:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjGXNEe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 09:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjGXNEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 09:04:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6978B19BD
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 06:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690203816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EEJ6IysLEVDYiwm532bzJf6jnAfliZIGqES1lq/hZi0=;
        b=JaeMzGlLkzjqrjhFN7MUW6KTdCbAc5nSNXMIbZcZ0O6fz/SmDEpKpQKmCEi+ycyPORtaHE
        nvlxJydZNzHcuyBCoWGeI8GfUOEG5R2FH5WFynO3NY/ZS6z1FJ9vvXtC+Vb4vlZXxWpd2p
        s99q0zB2mwRvRxb36HfU22aQDo2tE1o=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-LoxK9NP4OSm1rHxL_Tf45A-1; Mon, 24 Jul 2023 09:03:35 -0400
X-MC-Unique: LoxK9NP4OSm1rHxL_Tf45A-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-d0737b86c45so2698333276.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 06:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690203814; x=1690808614;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EEJ6IysLEVDYiwm532bzJf6jnAfliZIGqES1lq/hZi0=;
        b=bBT0Dw6iSAKkCZEMUpPV4FY1faKqzWP+0b720TnZS7hlMBk6HSCSgXtfCf2b3oUIYL
         WEHAVXkp+kFxcLvqHBx7V9ryH2ZhSg5nqtvmQE1r80MHgvyMqqMSkMyPnwje97FhOA4A
         twF55A5sC2NmAqNqW5+zf05UO5duR16+zPKPSEgJEDJx3iSpvJ47MW7jSMCzxKt2/ULS
         cF82+ZKWdVTe6nUBr7B6yTrPlRzSOyn/WRiBRQciZsoFfaD1+JYpIw5o55z4lahQYzj9
         eZMZbx0VPsQ0sXh6ml2dWHfgZGGDKyQWgDRQTYROnocPf07gTNI6qf982ES0mKs0/XJd
         TyCA==
X-Gm-Message-State: ABy/qLadp+BIUuqFeYBrnh9lZOgY3t2+AxgzAxLyxn/qVCEpUeoZYXo5
        q+aOMe96ZPjCVQ8G2qydVyOQxxwT87OeyPMkcInokZa6kwNue9UILVetp8stptYfBqsq17pLIvb
        K9D34gKCke+PoDODhQuzATg==
X-Received: by 2002:a25:ae97:0:b0:d07:707c:1106 with SMTP id b23-20020a25ae97000000b00d07707c1106mr5350065ybj.56.1690203814513;
        Mon, 24 Jul 2023 06:03:34 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHkX3XaANJLoQSKhen0rqgYiUyzj6pKZ7KkNfDO6m741yPghbjqd55kIezgH7LpvU9avI+9fQ==
X-Received: by 2002:a25:ae97:0:b0:d07:707c:1106 with SMTP id b23-20020a25ae97000000b00d07707c1106mr5350033ybj.56.1690203814112;
        Mon, 24 Jul 2023 06:03:34 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:2613:173:a68a:fce8? ([2600:6c64:4e7f:603b:2613:173:a68a:fce8])
        by smtp.gmail.com with ESMTPSA id 8-20020a250108000000b00cc567b3a869sm2328751ybb.6.2023.07.24.06.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 06:03:33 -0700 (PDT)
Message-ID: <dd7c6170def7159b558b79d34520c3d5290e36b9.camel@redhat.com>
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
Date:   Mon, 24 Jul 2023 09:03:32 -0400
In-Reply-To: <20230724120241.40495-1-oleksandr@redhat.com>
References: <20230724120241.40495-1-oleksandr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-07-24 at 14:02 +0200, Oleksandr Natalenko wrote:
> qedf driver, debugfs part of it specifically, touches __user pointers
> directly for printing out info to userspace via sprintf(), which may
> cause crash like this:
>=20
> BUG: unable to handle kernel paging request at 00007ffd1d6b43a0
> IP: [<ffffffffaa7a882a>] string.isra.7+0x6a/0xf0
> Oops: 0003 [#1] SMP
> Call Trace:
> =C2=A0[<ffffffffaa7a9f31>] vsnprintf+0x201/0x6a0
> =C2=A0[<ffffffffaa7aa556>] sprintf+0x56/0x80
> =C2=A0[<ffffffffc04227ed>] qedf_dbg_stop_io_on_error_cmd_read+0x6d/0x90
> [qedf]
> =C2=A0[<ffffffffaa65bb2f>] vfs_read+0x9f/0x170
> =C2=A0[<ffffffffaa65cb82>] SyS_pread64+0x92/0xc0
>=20
> Avoid this by preparing the info in a kernel buffer first, either
> allocated on stack for small printouts, or via vmalloc() for big
> ones,
> and then copying it to the userspace properly.
>=20
> I'm not sure how big the vmalloc()'ed buffer should be, and also
> whether
> vmalloc()'ing it directly in the _read() function is a good idea,
> hence
> RFC prefix.
>=20
> The qedf_dbg_stop_io_on_error_cmd_read()-related patch is actually
> tested,
> the rest is compile-tested only.
>=20
> Oleksandr Natalenko (3):
> =C2=A0 scsi: qedf: do not touch __user pointer in
> =C2=A0=C2=A0=C2=A0 qedf_dbg_stop_io_on_error_cmd_read() directly
> =C2=A0 scsi: qedf: do not touch __user pointer in
> qedf_dbg_debug_cmd_read()
> =C2=A0=C2=A0=C2=A0 directly
> =C2=A0 scsi: qedf: do not touch __user pointer in
> qedf_dbg_fp_int_cmd_read()
> =C2=A0=C2=A0=C2=A0 directly
>=20
> =C2=A0drivers/scsi/qedf/qedf_dbg.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> =C2=A0drivers/scsi/qedf/qedf_debugfs.c | 35 +++++++++++++++++++----------=
-
> --
> =C2=A02 files changed, 23 insertions(+), 14 deletions(-)
>=20
> --
> 2.41.0
>=20

I will test the series, the one patch was already tested.
This was reproduced in our LAB
Will report back after testing

Regards
Laurence

