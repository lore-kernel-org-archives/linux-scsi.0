Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F06F2C159A
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 18:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773166882; cv=none; b=ffq1EY4TQPOVM2QghnxIZxFyta2KyIWNLpl6rDRtMj8Fnpw2pcOvWeqD+NSiQY3X+FvvTugm/RLtXsXTGJOdX7hnOM7+kcMAmUUpLbgjSTykMJDKlR/s6eUgRN0cYvrUS/zf6C3H2X3e5GPElPrriI8hfooH9OSV24xuxiN547M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773166882; c=relaxed/simple;
	bh=RYHwf92flHnUfSHhGWu39REnpB8D3KhXnDbPehoNQKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hqWFZ3pbKa9lvFgz66x3XWIJ08Df3esEz52gB1XF/Y3eYIE9lkCQovL0xnsRFOmYLvtkdMuzKNKTjFHR/614UsErr1Uok+Ny/cI0K90c5t9pY7v0qLTkVhmd4jvirdhUKnLHEcY+mecxMzaZaNvq+nDz9JkGjIfCAVurySyu3kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLp7+7J9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLp7+7J9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AC7C19425
	for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 18:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773166882;
	bh=RYHwf92flHnUfSHhGWu39REnpB8D3KhXnDbPehoNQKQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VLp7+7J9llrwvCmETGQRw3htvlndh6m1nt/RRmA9Uxn1bhz+K/B+q6H0nosrrJG24
	 ualDb+AMHRYw11phgtZL8RQve4Fni7wZOk59ZLka5e+KPtlbhUxjNSzE/u7nYiB2MG
	 4bV3VcillBEcNpXDxDtrt3iOrWD9Xz8KTLy0tBBoJR7VPRwrGT4Bipusr7CoKRL2ml
	 l7zOALrl2J90A/S7t+sxsILHs96E/Odocww2PrRZOWkgKyzHu0R0BCxGsyhR7v+CIf
	 Ky6UMX9xuNxOpFUg5ny0u2vMeWHrFW3AaDx6+eRfY/UL0WbUJETU9XHUwMA1DbqaxY
	 zFxqVd4KpzOUg==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-662bf05f7a4so1964915a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 11:21:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWuEuHkH+HwrPI5IuV/1wkjlE71sc4WwncTTDvszg9+cBKc24XLRjr44Vd67rsKB3swm5o34TtFAedp@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0pfNgzcgFxjtK92s1ZDgqAIyuPGxWoOSPGPcee7gmKyZvjBLM
	xfHqOjxaTGxxeHQ8NHWKpEuviHQQZigcMINT4gr3l44U2XtrNMPIBBuwwn3+tfysQfyFcwZlNRr
	stbsP9kRLceYLbNpV1AnOfzETM0OchQ==
X-Received: by 2002:a05:6402:a290:20b0:662:aa89:2ffd with SMTP id
 4fb4d7f45d1cf-662aa89325dmr2220648a12.18.1773166880808; Tue, 10 Mar 2026
 11:21:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306-mt8196-ufs-v9-0-55b073f7a830@collabora.com>
 <4089450.ElGaqSPkdT@workhorse> <yq14imrwp3z.fsf@ca-mkp.ca.oracle.com> <5973984.DvuYhMxLoT@workhorse>
In-Reply-To: <5973984.DvuYhMxLoT@workhorse>
From: Rob Herring <robh@kernel.org>
Date: Tue, 10 Mar 2026 13:21:09 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKGxrNuaTb9+n3ZYjAdY=UHC6z-neXK-aieTXeROCN5og@mail.gmail.com>
X-Gm-Features: AaiRm53EXEYwn_27B-gILkkR9Yt_6ubl80Y5DTYqzcMmOl6Xp1DwezMjgTnFj3c
Message-ID: <CAL_JsqKGxrNuaTb9+n3ZYjAdY=UHC6z-neXK-aieTXeROCN5og@mail.gmail.com>
Subject: Re: [PATCH v9 03/23] dt-bindings: ufs: mediatek,ufs: Add mt8196 variant
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
	Kishon Vijay Abraham I <kishon@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Stanley Jhu <chu.stanley@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
	Mark Brown <broonie@kernel.org>, Chaotian Jing <Chaotian.Jing@mediatek.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, 
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, kernel@collabora.com, 
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
	Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 9, 2026 at 5:04=E2=80=AFAM Nicolas Frattaroli
<nicolas.frattaroli@collabora.com> wrote:
>
> On Saturday, 7 March 2026 19:01:17 Central European Standard Time Martin =
K. Petersen wrote:
> >
> > Nicolas,
> >
> > >> "ufs" is redundant as all the clocks are for UFS. Same comment on pr=
ior
> > >> patch.
> > >
> > > Is this naming a big enough concern to block this series with two
> > > explicit acks on this patch that fixes a wholly broken and useless
> > > binding?
> >
> > It is if it comes from one of the DT maintainers.
> >
> > > I am trying to put out this dumpster fire of a downstream turd that
> > > made its way into mainline as the review process has been completely
> > > subverted, and is only getting worse with each passing month
> >
> > This has to stop. Please read Documentation/process/code-of-conduct.rst=
.

I have little doubt that that is an accurate description of
downstream. And if properties are getting added without bindings, then
that is certainly a problem that should be complained about.

> >
> >
>
> I apologise for my tone, it's my frustration getting the better of me.
>
> I'll be handing off this series to someone else, so you won't have to
> deal with me anymore.
>
> I do ask however that you don't apply patches from MediaTek blindly;
> if there's code to read an OF property, and that OF property is not
> in the binding, then the patch should be rejected, even if there's an
> Ack from the MediaTek maintainer.

There's functionality to find undocumented compatibles in kernel code
(make dt_compatible_check), but not properties. Sounds like I need to
add that.

Rob
