Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E50F472F82
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453315; cv=none; b=ggkWHatNGe84E3gI13fiT0LuY6Grv3xwQNlN6/h6VLiaWFTMoc0lcmQaL43JhUc4tXtWW/sCc7+BSXmEXyPBp1s66WL42iU54SuchdSIwrBW7ysx5fJsKGHpoDQ6m31zrOyNSyLThTcbO00M6o4SfWXx2RykyXAztIG0IaQGeNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453315; c=relaxed/simple;
	bh=CfO+gP6Qg87Okl0P73+dJU8ip2WSxfJUtGCa/MRTLZs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cmd0xTj+pc1y+WfUlWp4739hinxFVrQ+b9rfO0hNmWjSR736rdZuevaXd/m9T7R9Y3zG+V3G4rGoXqaonNFw44bkVOac2TwCFRklzowGcJoEgN06E5mtn4YUjJeRZZ7Wa30fnFFx9h9Us7hAxtJ13ep+1WjCM7AR0RIKcWovfIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxaDgW6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxaDgW6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9490A1F000E9;
	Thu, 30 Jul 2026 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453313;
	bh=hjFWmJb65VspSZaqz6Mtp8r2W8YUbHd7PTe0vE2ToL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lxaDgW6xaDQwb/6NUTYN/Yfnd9X1MD/0JpH2l5iSZjWCK2+1W1C1PTK+Img2uYZ0E
	 SKLC//ynpjwHymYCvWORUJH32pgqJ832brsA6LLF2z5yVyQzEnT6HrmKlc4wCol1ad
	 8TnOIoujpd5ymGLqBrGwyxhviHU15w+Sw9qXNvDy4ziq86PfYbUu3ouUjWxgKK55iW
	 3+Ya0LcEffl+1iRydYlZ1/x+OBzzHTZ0dZqowyZF4KTQx5f91c3lJFH3jAovYEajkm
	 fOR096SfTPY9dhcSdWBXfmDFWv9Cv3LvVtKqqEjqUfMDszy8AROTFSuKWQunbQ0SQm
	 F5C0lPAFTMwvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 40/57] scsi: megaraid: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <78e04b1886820daa15ab84e1b322cc19eaa36cca.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <78e04b1886820daa15ab84e1b322cc19eaa36cca.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:15:13 +0000
Message-Id: <20260730231513.9490A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Incorrect `__must_hold` annotations hide lockless execution path=
s for `reset_mutex` and defeat lock context analysis.
--

--- Patch [40]: [PATCH v3 40/57] scsi: megaraid: Enable lock context analys=
is ---
commit 40d3b019568a4b229e7033f10c3257b3f094d748
Author: Bart Van Assche <bvanassche@acm.org>

scsi: megaraid: Enable lock context analysis

This commit enables lock context analysis for the megaraid driver by
setting CONTEXT_ANALYSIS to y in the Makefile.

> diff --git a/drivers/scsi/megaraid/Makefile b/drivers/scsi/megaraid/Makef=
ile
> index 12177e4cae653..9a6976a4dc22b 100644
> --- a/drivers/scsi/megaraid/Makefile
> +++ b/drivers/scsi/megaraid/Makefile
> @@ -1,4 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
> +
> +CONTEXT_ANALYSIS :=3D y
> +

[Severity: Medium]
Will enabling context analysis here be effective given the current
annotations on the driver's lifecycle functions?

The megasas_resume() function is annotated as holding the lock:

drivers/scsi/megaraid/megaraid_sas_base.c:
    static int __maybe_unused
    megasas_resume(struct device *dev)
        __must_hold(&((struct megasas_instance *)dev_get_drvdata(dev))->res=
et_mutex)

However, the PM core invokes this resume callback without holding
reset_mutex.

Similarly, during driver probe, megasas_init_adapter_mfi() and
megasas_init_adapter_fusion() are called via the init_adapter function
pointer without reset_mutex held, but they are also annotated as
requiring it:

drivers/scsi/megaraid/megaraid_sas_fusion.c:
    static u32
    megasas_init_adapter_fusion(struct megasas_instance *instance)
        __must_hold(&instance->reset_mutex)

Could these __must_hold annotations suppress valid static analysis
warnings for these execution paths, defeating the lock context analysis
being enabled here?

>  obj-$(CONFIG_MEGARAID_MM)	+=3D megaraid_mm.o
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D40
