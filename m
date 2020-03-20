Return-Path: <SRS0=SK/U=5F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A279C43332
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 00:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D84120836
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 00:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRxOifUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgCTAiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Mar 2020 20:38:54 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:45643 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCTAiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2020 20:38:54 -0400
Received: by mail-vs1-f67.google.com with SMTP id x82so2963518vsc.12;
        Thu, 19 Mar 2020 17:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KjKMCzgb3n25ugwSO4NZ9wemQx4MIWa/Si1mpse+02Y=;
        b=aRxOifUgBz7sSrExSWn/7aj+00te0fuRTbj4encfSwmrovVxaDfZQL0Y2unZUv/vdq
         HTm5qU8HKwX5dotjpB38Nv9JdQFaYZYE3V8MqaZGieEeYD+Mxb/YHDDzOQbjp9TUvifb
         DLIBuZ+2mFC6VpCQmLJczUD7IBKetOZfn/cWAmDTbAhvcJYIz97OVa1j4iXJ+kyWsnTl
         eYA+b6vZTBFmqHuHqXTqJ2JFFCmcK9x18OQ+fX8SGSdSW+dFae23Ia84f5rixAA4CE5M
         i9NfxQ9wVEwQApFVWQgjFbxhs0mY8W99DvV3u/Ek/KKm74mCQpzJiAeqgDuwVEH83iLS
         RcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KjKMCzgb3n25ugwSO4NZ9wemQx4MIWa/Si1mpse+02Y=;
        b=VRUzoy5LM/UdSjPDSNHlvjCm1TiM2eRL3RmWXVEfH6yAWuck8o20h7V21zDOGpkuh1
         WWohxAwevsY2NLIELNFxTY6rsknmJ6RJU7+ayR+JeKMBnW96xuS12ypzR6Q1fgxcVD1f
         0Pl0MHP60/Mn/uA2bNE+p1srB7RkG0v2LT4HZP6HwaIDejDapn3xiNlaB4ocO5eQX6lc
         i9I/YW1mwmnqszt1v4p+Fnw34Pu/SKEaTQFWttlgbyeRnFGemn5Ds9v8WLK1J1levTbK
         cy3+JodJhWP+YOhJtjN5bOF2LnQqYxAUJoj8GRbDEH5fldROdxbQ9rtgt5YBebTcfvsf
         TVNA==
X-Gm-Message-State: ANhLgQ1ImE4z5Z3f0vZjCI/qKjL6D2P7VP2pRvyKSe5/UYV11tn+WY78
        /uyWxypB/tB22y8hNmXkR0YTSqYw/9sAz4hTzz435q/Z
X-Google-Smtp-Source: ADFU+vsr3j7kwTl9CdWra4NVPQZmfpQw/B4U/SPyUSsCha4bBWZQYAQYhSqelDLP+hK9iWo4rnR7UYF2mmms+UOfdEc=
X-Received: by 2002:a67:b246:: with SMTP id s6mr4550196vsh.127.1584664732224;
 Thu, 19 Mar 2020 17:38:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200319150031.11024-1-alim.akhtar@samsung.com>
 <CGME20200319150703epcas5p2d917898f6f1e0554cb978a70a34ee507@epcas5p2.samsung.com>
 <20200319150031.11024-2-alim.akhtar@samsung.com> <20200320002147.GA11283@bogus>
In-Reply-To: <20200320002147.GA11283@bogus>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 20 Mar 2020 06:08:15 +0530
Message-ID: <CAGOxZ53415QRLW7gfbzHB8jzRxikz3Lyq=ME8d6Te4=DwLuhNg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] dt-bindings: phy: Document Samsung UFS PHY bindings
To:     Rob Herring <robh@kernel.org>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh+dt" <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob

On Fri, Mar 20, 2020 at 5:53 AM Rob Herring <robh@kernel.org> wrote:
>
> On Thu, 19 Mar 2020 20:30:27 +0530, Alim Akhtar wrote:
> > This patch documents Samsung UFS PHY device tree bindings
> >
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> > ---
> >  .../bindings/phy/samsung,ufs-phy.yaml         | 62 +++++++++++++++++++
> >  1 file changed, 62 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/phy/samsung,ufs-p=
hy.yaml
> >
>
> My bot found errors running 'make dt_binding_check' on your patch:
>
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/phy/=
samsung,ufs-phy.example.dt.yaml: example-0: 'ufs-phy@0x15571800' does not m=
atch any of the regexes: '.*-names$', '.*-supply$', '^#.*-cells$', '^#[a-zA=
-Z0-9,+\\-._]{0,63}$', '^[a-zA-Z][a-zA-Z0-9,+\\-._]{0,63}$', '^[a-zA-Z][a-z=
A-Z0-9,+\\-._]{0,63}@[0-9a-fA-F]+(,[0-9a-fA-F]+)*$', '^__.*__$', 'pinctrl-[=
0-9]+'
>
> See https://patchwork.ozlabs.org/patch/1258280
>
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure dt-schema is up to date:
>
Yes, I did ran 'make dt_binding_check' and saw no errors,

---
/work/linux $ make dt_binding_check
DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/phy/samsung,ufs-phy.yam=
l
scripts/kconfig/conf  --syncconfig Kconfig
  HOSTCC  scripts/dtc/dtc.o
  HOSTCC  scripts/dtc/flattree.o
  HOSTCC  scripts/dtc/fstree.o
  HOSTCC  scripts/dtc/data.o
  HOSTCC  scripts/dtc/livetree.o
  HOSTCC  scripts/dtc/treesource.o
  HOSTCC  scripts/dtc/srcpos.o
  HOSTCC  scripts/dtc/checks.o
  HOSTCC  scripts/dtc/util.o
  LEX     scripts/dtc/dtc-lexer.lex.c
  YACC    scripts/dtc/dtc-parser.tab.[ch]
  HOSTCC  scripts/dtc/dtc-lexer.lex.o
  HOSTCC  scripts/dtc/dtc-parser.tab.o
  HOSTCC  scripts/dtc/yamltree.o
  HOSTLD  scripts/dtc/dtc
  CHKDT   Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
  SCHEMA  Documentation/devicetree/bindings/processed-schema.yaml
  DTC     Documentation/devicetree/bindings/phy/samsung,ufs-phy.example.dt.=
yaml
  CHECK   Documentation/devicetree/bindings/phy/samsung,ufs-phy.example.dt.=
yaml
~/work/linux $ dtc --version
Version: DTC 1.5.0-g62cb4ad2
---------------
> pip3 install git+https://github.com/devicetree-org/dt-schema.git@master -=
-upgrade
>
Thanks for pointing this out, I will upgrade and re-run and re-submit.

> Please check and re-submit.



--=20
Regards,
Alim
