Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8861D5160;
	Wed,  8 Jul 2026 02:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783477076; cv=none; b=lIWRocfCP/duPByQgB5E1lSZmjKZMgTUKG64G9Y1eUIMJIigovGpAalp0HpxYJ1RQY2XrsOzSuLKWZ+s5mT5T0hkH0qw+A3/S7SjbeZMxim1CI9YJr3k5mPXlpsnePi8Mm5q9uegBns2xq2QZvlKuMY8L/yBxtWbvkcCkWzksLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783477076; c=relaxed/simple;
	bh=defb1Q3Z6ylClQwKTpft+/Iwhnrnu/ThyTH9/eB1C3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y2P8kFiQ7l2LmQd7vd7jY+baoaqSR+wMyUwMWgOK36Yv6xxpXu4S0JF2A37t+Rm2KlKCCSWxcWajvTYwy7Gn88I2urJhsHFF7138NI92nqklEDgj0s+QLD1zoZuu3zgKYEbfHxLIsHs7S1cKUIJ5nLwsV8UMcrqJQGXKqRrEt00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6UWUk8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6UWUk8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBE81F000E9;
	Wed,  8 Jul 2026 02:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783477074;
	bh=kIHZQkBG4dVsKYZdSJUwIGIZF8zO/xu9yTXMYf0l6VQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y6UWUk8VT6ihOiUv++Oz7SIr67DpWO6YoStjUxH4/PfZiOWTU0OcaZf892wY1UDvP
	 F0MapI4xSAZJ+QFGVi6A50PRDgS1Vujai4RQ6dY6Db+OmxUO7YzwRZnnFSv7nhzYUE
	 ZZUKUSnWUglSMeq9MhoFk8exLwWi8L+7W3IGwZ7xZVZnzuR1FmLSNn1KHbzkkbGPV5
	 QvLMJpf0/pSlOaST9j7bjr6enu+n9J/DAPVLsemdgKhFsBbL+E3n2tf2MtZharPatR
	 6judu/G7/szzJ9gfcZKN0n5pbornbc4f5hVwsbuWJK5YUTGxv3qglsIhW0JzO+0zDo
	 voCxKcQzB/S3A==
Date: Wed, 8 Jul 2026 02:17:52 +0000
From: Yixun Lan <dlan@kernel.org>
To: Jennifer Berringer <jberring@redhat.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] riscv: dts: spacemit: k3: Add UFS support
Message-ID: <20260708021752-GKI35811@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-3-1a64a3ab128f@kernel.org>
 <akkSL1nQ5UieqHNs@rhdev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <akkSL1nQ5UieqHNs@rhdev>

Hi Jennifer,

On 10:01 Sat 04 Jul     , Jennifer Berringer wrote:
> On Thu, Jul 02, 2026 at 02:31:37AM +0000, Yixun Lan wrote:
> > Add UFS Host Controller support for SpacemiT K3 SoC, and enable
> > it both on both Pico-ITX and CoM260-IFX boards.
> > 
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> >  arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts |  4 ++++
> >  arch/riscv/boot/dts/spacemit/k3-pico-itx.dts   |  4 ++++
> >  arch/riscv/boot/dts/spacemit/k3.dtsi           | 13 +++++++++++++
> >  3 files changed, 21 insertions(+)
> > 
> > diff --git a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> > index 238bb03d0e9e..b37e1c7b03e3 100644
> > --- a/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> > +++ b/arch/riscv/boot/dts/spacemit/k3-com260-ifx.dts
> > @@ -19,3 +19,7 @@ chosen {
> >  		stdout-path = "serial0:115200n8";
> >  	};
> >  };
> > +
> > +&ufshc {
> > +	status = "okay";
> > +};
> 
> I believe k3-com260.dtsi would be a more fitting file for this change.
> UFS is soldered on the underside of the compute module and not part of
> the carrier board.
> 
Right, I agree

> Because it is next to the microSD card slot, a picture showing both can
> be seen in section 5.12 (TF-Card Interface) of the PDF version of the K3
> CoM260 User Guide. That picture is notably not visible in the HTML
> version.
> 
> https://www.spacemit.com/community/document/info?lang=en&nodepath=hardware/eco/k3_com260/com260_user_guide.md
> 
> > diff --git a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> > index b89c1521e664..f1560a5a9031 100644
> > --- a/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> > +++ b/arch/riscv/boot/dts/spacemit/k3-pico-itx.dts
> > @@ -221,3 +221,7 @@ hub@1 {
> >  &usb2_phy {
> >  	status = "okay";
> >  };
> > +
> > +&ufshc {
> > +	status = "okay";
> > +};
> 
> Nit: if sorted by label, ufshc would be before usb2_host.
> 
Right, will sort in next version

-- 
Yixun Lan (dlan)
