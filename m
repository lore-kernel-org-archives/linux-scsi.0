Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBC9382F15;
	Thu,  6 Aug 2026 04:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785991151; cv=none; b=H3Sd20WqXiPqmaYsvnVtVtth5ARgzLbzIvxnTLNxGheOpWt85kz0bPrSxzG9sg465iObjj3TiDKXM3tSzLOaZoUZi1Fkd0mJvQ9NP4h2UQ/rTlh6jbJQLaNt/2wiRZYrSabNNVTA/RzLrU5LvRTNmsODt7WwioR8WtEkB1FZFjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785991151; c=relaxed/simple;
	bh=DbWC5oTvQzH86ZVRTJAAZy7ZxiNZbfKbHnsmXFcfD88=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=kCnsZgxtK9rynrnWVt074oGzZU0L+qXzbhK4zoyYWOVylhkRC+PzVM4B8feBqgKbiwv21kGiysrBwAGW6Az2gS8wJeQZu79LGDkH0Rz8010z6xibNWQh2e0vrYcp2xurz2PeoZBYbxjgMmqVHmwQxON1TK+YNpNd4oAR0RrqZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELIcMt+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELIcMt+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E041F000E9;
	Thu,  6 Aug 2026 04:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785991150;
	bh=85i0AXt6sCXn1q2thPdJFckEuCv/5TVwacAUp/k4SQk=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject;
	b=ELIcMt+iX8oyqWp+t39x854MB2hi65pUKoR+arELehyykuMEkum1EfaSUFjYebixB
	 RN8ohC0Bhi2umkm/8xFyXWEZfD707UaguyTpqM7OKfM5FayVRasqI2bevwcYHDS/MM
	 dQ14jur+wDUDlcxYhkSnCeINh+Y1buspDbPQ9Pd040NzH1U0yVeOzgKC2IkT+W3/v8
	 HWMuzO1/Uir63zS6C5qgd6FhA9kzFsG3Jk3M4utXPLouK1wR/yOleXRW+LA7oAmt7L
	 gNB5qf9x2yFbtGTR++WQuYECHYyE+CoBfhuAIU4BCRoAHHiUTUJcdzTvnTsm3ToqhG
	 aPVz2LYdUmTNA==
Date: Wed, 05 Aug 2026 23:39:09 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 linux-scsi@vger.kernel.org, Avri Altman <avri.altman@sandisk.com>, 
 spacemit@lists.linux.dev, Palmer Dabbelt <palmer@dabbelt.com>, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Paul Walmsley <pjw@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>, 
 Albert Ou <aou@eecs.berkeley.edu>, Bart Van Assche <bvanassche@acm.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Jennifer Berringer <jberring@redhat.com>, devicetree@vger.kernel.org, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>
To: Yixun Lan <dlan@kernel.org>
In-Reply-To: <20260806-08-k3-ufs-support-v3-1-037fb322acdb@kernel.org>
References: <20260806-08-k3-ufs-support-v3-0-037fb322acdb@kernel.org>
 <20260806-08-k3-ufs-support-v3-1-037fb322acdb@kernel.org>
Message-Id: <178599114910.179339.15914924366340132471.robh@kernel.org>
Subject: Re: [PATCH v3 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC


On Thu, 06 Aug 2026 02:56:18 +0000, Yixun Lan wrote:
> Document the compatible for UFS (Universal Flash Storage) Host Controller
> which found in SpacemiT K3 SoC chip. Its features are listed below:
> 
> - Compliant with MIPI UniPro v1.61 specification.
> - Compliant with M-PHY v3.0 specification.
> - Compliant with UFS HCI v2.1 specification.
> - Supports up to 2 Tx and 2 Rx lanes, up to HS-GEAR3 5.8 Gbps per lane.
> - Supports standard low-power hibernate to reduce power consumption.
> 
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  .../devicetree/bindings/ufs/spacemit,k3-ufshc.yaml | 56 ++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
Lexical error: Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.example.dts:31.36-55 Unexpected 'CLK_APMU_UFS_REFCLK'
FATAL ERROR: Syntax error parsing input tree
make[2]: *** [scripts/Makefile.dtbs:140: Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.example.dtb] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1669: dt_binding_check] Error 2
make: *** [Makefile:248: __sub-make] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260806-08-k3-ufs-support-v3-1-037fb322acdb@kernel.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

