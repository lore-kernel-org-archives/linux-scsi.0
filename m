Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31982C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 06:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiKUGnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 01:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKUGnq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 01:43:46 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA75917892;
        Sun, 20 Nov 2022 22:43:44 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id i10so26227231ejg.6;
        Sun, 20 Nov 2022 22:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8wNXBRmarHNAcLIByCKKPj/LanlRtwsGtrhezJEOSw=;
        b=Gatp50fjydykXjhub0LNhfe/lfVnDryij/v+t8D/4G5AEGl7FJsWPfK4w0mPul9eQY
         PZIX1MrAtRnY5NwoeuLrsRm367pA9fQd7Mb34R23Qx2WSCaYkf8puI8Wtw+f5HIHRrvQ
         WDqi/XHhtf7lzEgMNq8bnEGjsFChWd6GFK1cnCs3Kk/F3D+MfZWB/nqcs0aWapuS3CTH
         eHi0mE7KU8QvrRPBswXPz1gzzVi7WfiDEi1ZdO+lHb1U0VmM9gg9nZ8PA05Ry2yAb0Br
         w3PfxPCFgNYfkpRdpTxQ+/BtXBbSLE7zOe+vxiu6suatpRszWKAByCQLvFBKx5WCEFqI
         Gjeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t8wNXBRmarHNAcLIByCKKPj/LanlRtwsGtrhezJEOSw=;
        b=17qt/H6iIb7NUeU5NPyl0p2ILv/Obf2DlQ/9rAbLshVTvv5q7MNb6JSICzgRGRgnsr
         v79mGiyLoN9y3vg77aRQkIjCuvondVG11fC1qGWLS4SU4uW94ERHd/y2YgNpGYl9UbHs
         yBN35G4pzbrd5PuGHScvh1EeCf1+E0HknI2ujYWvMWwa2F6MaUfxVqK5DR5vcWnOcCEn
         9+NYDAZ1ptLe5hXjGQ4QHrNBw7oTMzqel9h3koaINSeeNjqNtzpAy/zgd91JSfjx4DhX
         3oAsWeM/qK2hi7g8Joh8vRpJ+6eXZKf16pbA3HhTlHaZTeZrqIEXnXpsfmuFA6UpbHAi
         UT7Q==
X-Gm-Message-State: ANoB5plHjcTxoy5G9EY2uKizctD/ZpGWrIf35QJxWmx22rPDOnARElZ2
        6xgI0Y9qvi5yhbSDfzRK9II4PFyZq9aclfGwF3o=
X-Google-Smtp-Source: AA0mqf4Of5Pt29Tp3S6p1t/qCJ1rl3NGexGDDhenKsDTUJwdEUMYBaxzrgFKp6bfE54i5N4HXxQjKJ60uVNt5EyHRbY=
X-Received: by 2002:a17:907:d08c:b0:7b6:62c:dd57 with SMTP id
 vc12-20020a170907d08c00b007b6062cdd57mr3272660ejc.207.1669013023198; Sun, 20
 Nov 2022 22:43:43 -0800 (PST)
MIME-Version: 1.0
References: <20221116133131.6809-1-zhe.wang1@unisoc.com> <20221116133131.6809-2-zhe.wang1@unisoc.com>
 <20221120164907.GA3183451-robh@kernel.org>
In-Reply-To: <20221120164907.GA3183451-robh@kernel.org>
From:   Zhe Wang <zhewang116@gmail.com>
Date:   Mon, 21 Nov 2022 14:43:31 +0800
Message-ID: <CAJxzgGo6YLw2nCp4SdmMg_dHRBxQY3jFCg94U1BpbDupOtorTg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: ufs: Add document for Unisoc UFS host controller
To:     Rob Herring <robh@kernel.org>
Cc:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hi Rob=EF=BC=8C

On Mon, Nov 21, 2022 at 12:54 AM Rob Herring <robh@kernel.org> wrote:
>
> On Wed, Nov 16, 2022 at 09:31:30PM +0800, Zhe Wang wrote:
> > Add Unisoc ums9620 ufs host controller devicetree document.
> >
> > Signed-off-by: Zhe Wang <zhe.wang1@unisoc.com>
> > ---
> >  .../bindings/ufs/sprd,ums9620-ufs.yaml        | 78 +++++++++++++++++++
> >  1 file changed, 78 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/ufs/sprd,ums9620-=
ufs.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yam=
l b/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
> > new file mode 100644
> > index 000000000000..ce9d05be1a6b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/ufs/sprd,ums9620-ufs.yaml
> > @@ -0,0 +1,78 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/ufs/sprd,ums9620-ufs.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Unisoc Universal Flash Storage (UFS) Controller
> > +
> > +maintainers:
> > +  - Zhe Wang <zhe.wang1@unisoc.com>
> > +
> > +allOf:
> > +  - $ref: ufs-common.yaml
> > +
> > +properties:
> > +  compatible:
> > +    const: sprd,ums9620-ufs
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    maxItems: 4
> > +
> > +  clock-names:
> > +    items:
> > +      - const: ufs_eb
> > +      - const: ufs_cfg_eb
> > +      - const: ufsh
> > +      - const: ufsh_source
>
> Sounds like a parent clock to 'ufsh'? If so, it doesn't belong in
> 'clocks'. Use the clock API to get the parent or use
> 'assigned-clock-parents'.
>
> Rob

It would be more appropriate to use 'assigned-clock-parents', I'll fix
this, thanks.

Best regards,
zhe
