Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15658C54EED
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 10:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbjA3K2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 05:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjA3K2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 05:28:32 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937244687
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 02:28:31 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id v10so10439896edi.8
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jan 2023 02:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyT6ubtiTbtcys2GsgacZ/5hEM4auH4fnNxrq/JEFg0=;
        b=XPEBaEmwF2s0uPcW5wglxrSvtLFphIU3jsc5682pDO3pt/DMxbwZvdXsm4HhflP/eS
         /NWQaYkCh34L1NEmGSEQFgOvWvVZZWSimDRX9Jgr9VkJAZYuN/7TyaltUTsAlAYIvr1c
         vHwjX5JFo3F+wgNek8QqKz1Vj+Cz0Td3s+6BlKpVPwAbGW/7V5rwY3gzX+mulRqRcv1s
         +PclQJ9B4plafxnsv/WDn/AHj4NUYTwNZVXcNM62PufV+KH8CWAJfIhbdhDd/mJYVKtr
         yU5GB9qiX9fxmK5aRL7AzDkIisGtxfBPnzmFswnPvDGs+uvLHy3CTKTY5r8N2KrVgBSy
         KACA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xyT6ubtiTbtcys2GsgacZ/5hEM4auH4fnNxrq/JEFg0=;
        b=MwKvymles3x2jZIyg4OLBKhjXWk702kuCelo3cDiBNPUTDNM3VgJBD+oFISdg+C06K
         7vrZ8WHJHLC0Wpl8ZnnRAMlDCByk1Y18w1PC/KQoYBKCSkAjtWZ0eneBwJadq45/p94U
         vnOTAZlly8F4KLmNlAdUDPbwle+BlzMbXf8g1Nvtj9mQt71iuMeYRSkKJngKYqlgrT2t
         t0Dk5ZpgM9ceeAWYhxrQR0501T1kcy0kyeIr3htnnToEE+H0N7ftQlDqtDYKNuyCyMMu
         Cb5py1cEO1lOihL4OCYdnV0awVFGldDPW8Y+zRdfK1o4974jHRza5UjceTQHw3o0up6W
         /srg==
X-Gm-Message-State: AO0yUKWaMpxj1p3fOWCuCW5JDmrqWH0tzNLCKfwwsc1k2zBV1hwYhekx
        /NTDttRofVNC5gtqjIBz7Ko=
X-Google-Smtp-Source: AK7set9VB5CbZ/Hcg47QJGMF1pq3G9GMdTzseI4vEVa++N1aR+A1TuUqdvT/tqjKJ/xJiPMNZPz4Lg==
X-Received: by 2002:a50:9e6a:0:b0:4a2:3d3d:a3f1 with SMTP id z97-20020a509e6a000000b004a23d3da3f1mr4936551ede.19.1675074510175;
        Mon, 30 Jan 2023 02:28:30 -0800 (PST)
Received: from touko.myxoz.lan (90-224-45-44-no2390.tbcn.telia.com. [90.224.45.44])
        by smtp.gmail.com with ESMTPSA id w11-20020a50fa8b000000b0049e09105705sm6544233edr.62.2023.01.30.02.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 02:28:29 -0800 (PST)
Message-ID: <1109bf338f2e7b4a61504110bbd5bc40b3c3a836.camel@gmail.com>
Subject: Re: [PATCH 0/4] ses: prevent from out of bounds accesses
From:   Miko Larsson <mikoxyzzz@gmail.com>
To:     Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Date:   Mon, 30 Jan 2023 11:28:28 +0100
In-Reply-To: <20230130101317.4862-1-thenzl@redhat.com>
References: <20230130101317.4862-1-thenzl@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.module_f37+15877+cf3308f9) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-01-30 at 11:13 +0100, Tomas Henzl wrote:
> First patch fixes a KASAN reported problem
> Second patch fixes other possible places in
> ses_enclosure_data_process
> where the max_desc_len might access memory out of bounds.
> 3/4 does the same for desc_ptr in ses_enclosure_data_process.
> The last patch fixes another KASAN report in ses_intf_remove.
>=20
>=20
> Tomas Henzl (4):
> =C2=A0 ses: fix slab-out-of-bounds reported by KASAN in
> ses_enclosure_data_process
> =C2=A0 ses: fix possible addl_desc_ptr out-of-bounds accesses in
> ses_enclosure_data_process
> =C2=A0 ses: fix possible desc_ptr out-of-bounds accesses in
> ses_enclosure_data_process
> =C2=A0 ses: fix slab-out-of-bounds reported by KASAN in ses_intf_remove=
=20
>=20
> =C2=A0drivers/scsi/ses.c | 58 ++++++++++++++++++++++++++++++++-----------=
-
> --
> =C2=A01 file changed, 41 insertions(+), 17 deletions(-)
>=20

This series should probably be Cc'ed to the stable mailing list.
--                                                                    =20
~miko
