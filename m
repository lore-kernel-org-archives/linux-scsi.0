Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6B53CFF7A
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773166228; cv=none; b=XIH8e53j/GLjPlb5rnQy9g3RN3KB0sBYYLjQiR0vyHbkl3dcOvaIiDC7iOBLblDA1nFDKvPzS869nnJSrck2Kpb5mV3lwRDM+Qt9Avnv5VFfw/OyRRYpodz4eIQsnQ8JofhCog3+kF7K7bVouhg2x4kgB45VFvtZAwNqGUHV2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773166228; c=relaxed/simple;
	bh=+BkbeGlWZU3HoPWqSJ4ZGWH/mYA1R9F66ZxBmJ6EvZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GSaChtAWtiDsk35/4B7EP/UWv1Vkc84zSkNsMcj+D9cLs16GJfD1ExuNJhebQdK/uFhO9IEENbaTz9vZPnadFJu+vTC8rxIB1KC4xaoYd9j42msOUZzvGiUd60qUZFr8E2/aTTyzWE25fjxM8eQH2syqoyWy/na01OMW8IWUdA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D20QBuJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D20QBuJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4572EC2BCC7
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773166228;
	bh=+BkbeGlWZU3HoPWqSJ4ZGWH/mYA1R9F66ZxBmJ6EvZk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=D20QBuJz20JGK1KlKAqOqZ98LZe96xXmFEvoFFgDEI0OK2C81PB7DoxY0y7AcHg/o
	 HEm7rQUPs9UaCUxzf/mfFjK7/pA8NpZmHCtAlWAIjFQK4yGD83W/Zzc1JtkYAp7HFr
	 YiTr+T+aGCNFnwhndRNOQg7x8Mn3oX0+YfX3CTWznLdEQiSnPnzf5xJfHwpaKo/ZTK
	 7TQ/FaHFs7+jOTrIyA4C/C++F+435/pK/LJXLLoMxHqmyRCgyYV1hLVPbdU9e0z0tp
	 XcHNxYA/Y6J5EhLiD21CNSpij8ernXpwojze9/tK04JR30/4OHbnKon/mwhECJ1tWr
	 6z2WzYHLie1ag==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b936331786dso1466142566b.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 11:10:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXO8t1x/P6tKZAgdyDupDS16Pn4EzqRHC7ixX5ziaoG4nXnRQzunAO5dOlnxHoKiIQ7yei7H5X4NnYq@vger.kernel.org
X-Gm-Message-State: AOJu0YzM2IemoRO+Mi/nuFp5AOh+6C4jTt02nxd3HGrCubS+uW2/l94u
	4ElHN8DlouVagBTFzwG/xwZRvLTc1dQhb9qF8AU8fip8OO0yDeywwvaws8m+SV0s+NEgIisv+4u
	LJcR09QC+G4RpwjACneNEyiGATi8I3A==
X-Received: by 2002:a17:906:2091:b0:b97:1d24:c015 with SMTP id
 a640c23a62f3a-b971d24fa35mr124911866b.40.1773166226421; Tue, 10 Mar 2026
 11:10:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
 <20260306-mt8196-ufs-v9-3-55b073f7a830@collabora.com> <20260306163305.GA2680515-robh@kernel.org>
 <4089450.ElGaqSPkdT@workhorse>
In-Reply-To: <4089450.ElGaqSPkdT@workhorse>
From: Rob Herring <robh@kernel.org>
Date: Tue, 10 Mar 2026 13:10:14 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+mF_Q7Ld8__ZTc5yDvWAT6uK5wxfBJM-YdFjOvdiDc-w@mail.gmail.com>
X-Gm-Features: AaiRm53tDdS80GaVjUeFGPThiibYh4p5Q5y90_XYQtN7oN_0_RN9C3azVe77kTU
Message-ID: <CAL_Jsq+mF_Q7Ld8__ZTc5yDvWAT6uK5wxfBJM-YdFjOvdiDc-w@mail.gmail.com>
Subject: Re: [PATCH v9 03/23] dt-bindings: ufs: mediatek,ufs: Add mt8196 variant
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
	Kishon Vijay Abraham I <kishon@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Stanley Jhu <chu.stanley@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Philipp Zabel <p.zabel@pengutronix.de>, 
	Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, 
	Chaotian Jing <Chaotian.Jing@mediatek.com>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, kernel@collabora.com, 
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
	Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 12:37=E2=80=AFPM Nicolas Frattaroli
<nicolas.frattaroli@collabora.com> wrote:
>
> On Friday, 6 March 2026 17:33:05 Central European Standard Time Rob Herri=
ng wrote:
> > On Fri, Mar 06, 2026 at 02:24:44PM +0100, Nicolas Frattaroli wrote:
> > > The MediaTek MT8196 SoC's UFS controller uses three additional clocks
> > > compared to the MT8195, and a different set of supplies. It is theref=
ore
> > > not compatible with the MT8195.
> > >
> > > While it does have a AVDD09_UFS_1 pin in addition to the AVDD09_UFS p=
in,
> > > it appears that these two pins are commoned together, as the board
> > > schematic I have access to uses the same supply for both, and the
> > > downstream driver does not distinguish between the two supplies eithe=
r.
> > >
> > > Add a compatible for it, and modify the binding correspondingly.
> > >
> > > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > > Acked-by: Vinod Koul <vkoul@kernel.org>
> > > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > > Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@co=
llabora.com>
> > > Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> > > ---
> > >  .../devicetree/bindings/ufs/mediatek,ufs.yaml      | 58 ++++++++++++=
+++++++++-
> > >  1 file changed, 57 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml =
b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > index e0aef3e5f56b..a82119ecbfe8 100644
> > > --- a/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > +++ b/Documentation/devicetree/bindings/ufs/mediatek,ufs.yaml
> > > @@ -16,10 +16,11 @@ properties:
> > >        - mediatek,mt8183-ufshci
> > >        - mediatek,mt8192-ufshci
> > >        - mediatek,mt8195-ufshci
> > > +      - mediatek,mt8196-ufshci
> > >
> > >    clocks:
> > >      minItems: 1
> > > -    maxItems: 13
> > > +    maxItems: 16
> > >
> > >    clock-names:
> > >      minItems: 1
> > > @@ -37,6 +38,9 @@ properties:
> > >        - const: crypt_perf
> > >        - const: ufs_rx_symbol0
> > >        - const: ufs_rx_symbol1
> > > +      - const: ufs_sel
> >
> > "ufs" is redundant as all the clocks are for UFS. Same comment on prior
> > patch.
>
> Is this naming a big enough concern to block this series with two
> explicit acks on this patch that fixes a wholly broken and useless
> binding?

Shrug... Is changing it really that hard?

> > > +      - const: ufs_sel_min_src
> > > +      - const: ufs_sel_max_src
> >
> > "src" sounds like a parent clock? If so, probably shouldn't be in the
> > clocks list. 'assigned-clocks' is for dealing with parent clocks.
> >
>
> I don't know what it is, and I have no way to consult any documentation
> that would tell me what it is. I am trying to put out this dumpster fire
> of a downstream turd that made its way into mainline as the review proces=
s
> has been completely subverted, and is only getting worse with each passin=
g
> month that MediaTek is allowed to block this series from progressing whil=
e
> sneaking further changes through.

It's good Mediatek is active, then they can tell us what the clocks
are for. I would think the driver would give some clue.

I don't see how accepting sub-par bindings or not fixes the issues here.

Rob
