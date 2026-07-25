Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB60330B529;
	Sat, 25 Jul 2026 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784986066; cv=none; b=QGVe6r9Sr/X6rpcohSSNoZrqCtq2s9PAWYxE+uX49LvHHTkunHz6wGYVivArmImbh0fTARhP7New8ucyRt25/r5HY6BFKD552efSJVbk6YKsxZdtk0hNJXF/RAqQGTEAixByW8hmsU3DyXGzCn5R8RxSndBrTdM+JWOgUlE+emE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784986066; c=relaxed/simple;
	bh=9WAUYmGdYHeNw4c8/Qc1K8kSlawGxPNaRVBmKIGiUII=;
	h=Date:Content-Type:MIME-Version:From:Cc:To:In-Reply-To:References:
	 Message-Id:Subject; b=N2lvNyYJSMo/XD6XF1YWFho6CpYRCJ3pVqDhJQJjCGolAnmZwTP6nVaFLEODR4lnZxfPGdodg/FeKAHUx8Fcr17abqW3kNnAe6XDm0T5anETmi6cjopjlZHe9LQBXHha+nydgIumi4oxA0Doz7DkviKfB/f8tKhxX00HR86WfMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGThAtup; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGThAtup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3C11F000E9;
	Sat, 25 Jul 2026 13:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784986064;
	bh=DsJhSTaLOqEFyvKvQH1QRB+ENNlkLh84i18wRSEe3Fo=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject;
	b=BGThAtup56cMrZOpHQ3HrO1XCzugN8xYb+nlsrR59wMwLo95nvMiyMj1j1P1U0tMl
	 36B7d663p9g0Mzd8SLpeThazz4+fWhykbjf2aym9VGzslsosVFXnunmLudx5s8PH63
	 0Ix+aKMuSvIdNXr5nZl9yb7XFPn/tZwb/mAjcKQ4ERNnG+H1UMD7h93e40NOwnqINb
	 V0di6zDAkIH9OXVcd3hw7v12RAKQlkOPvyCXtrAKrXXgyTHjjhHEAVBJ0xa/xK5sqj
	 T9vh+GwPX318xX/JuaFlxK5GOQYpT6PvrJqyxjVUj9T8LN4xNNJBuvUX8NcLDL9REr
	 1IqOae2wEI8Aw==
Date: Sat, 25 Jul 2026 08:27:43 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Alexandre Ghiti <alex@ghiti.fr>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org, 
 spacemit@lists.linux.dev, Aurelien Jarno <aurelien@aurel32.net>, 
 Paul Walmsley <pjw@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Jennifer Berringer <jberring@redhat.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, devicetree@vger.kernel.org, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 linux-riscv@lists.infradead.org, Avri Altman <avri.altman@sandisk.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, linux-scsi@vger.kernel.org, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Yixun Lan <dlan@kernel.org>
In-Reply-To: <20260725-08-k3-ufs-support-v2-1-45036a2a2418@kernel.org>
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
 <20260725-08-k3-ufs-support-v2-1-45036a2a2418@kernel.org>
Message-Id: <178498606385.3230542.8227126824689788827.robh@kernel.org>
Subject: Re: [PATCH v2 1/3] scsi: ufs: spacemit: dt-bindings: Add UFS
 controller for K3 SoC


On Sat, 25 Jul 2026 10:37:44 +0000, Yixun Lan wrote:
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
Lexical error: Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.example.dts:31.27-46 Unexpected 'CLK_APMU_UFS_REFCLK'
FATAL ERROR: Syntax error parsing input tree
make[2]: *** [scripts/Makefile.dtbs:140: Documentation/devicetree/bindings/ufs/spacemit,k3-ufshc.example.dtb] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [/builds/robherring/dt-review-ci/linux/Makefile:1669: dt_binding_check] Error 2
make: *** [Makefile:248: __sub-make] Error 2

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260725-08-k3-ufs-support-v2-1-45036a2a2418@kernel.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

