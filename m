Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1FF3F4123;
	Tue,  7 Jul 2026 14:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433542; cv=none; b=JEm5T2xPIUb1ZN2vzLfx/eetNss2E8Qwpj+gAUywNnhM5tB1jZdScsnQCcdFyNOle2bZKlEgGTS7uxvbouTze1ESH9tPu4THdad+vAXAgaiUC3XICEiohF8eQ9NMIl3/HIjb53o++QkwJebniqnfkwr/ep9NwLC+8PU/XNx69S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433542; c=relaxed/simple;
	bh=UfmXVhSM5Umjns2A9HvBx2SkFQe8VPlW+QWf63BmQAk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CQ3huJSl4ZJ2LfReX1GSDBMzvKOoi8LS2b4GpC1a5PvJ8i/RpuWaPZ1OLMytrddZOWTB5qrm0nWouyDLU3K4+tHbb9MySi/saYv1gZ5AY8a2OLqSZ35oMIBRvti7ofVsraOdROa/HzwedBwcKdDeh9TO3tgx5VPVeFtkNCsI6tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gBG3ZsPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gBG3ZsPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BE61F000E9;
	Tue,  7 Jul 2026 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433540;
	bh=UfmXVhSM5Umjns2A9HvBx2SkFQe8VPlW+QWf63BmQAk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gBG3ZsPEWjvZExJhMn5eRA+6Oj2wVar8453d1Ihc58vUeC6K1REcnEX1b0GRkajrr
	 4pk98SRWjIkzI0Ut7XnTI9Evd+3AshYw7APhC601CmAn7xVDkr0wgmzt7RJwivIVjj
	 x1wSeulDOE3mlrOmJB+LNeD5y4MUxckboK/JsMRmwvSKa3OUVJiPdAF1m95zYelD1B
	 DgpmEaCok3QPESmRKAy8GyuCyV4GzdcxGaRzvWInTCSpEGkFO9iplD3jPb/pdq8h3t
	 yjA+/6+iDQs55osPHVqW6LW8LWn9GhSQw4/3mCAX2SkvImnXnobrTKKYQt27Rv9bm2
	 GImWhNFWg194A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 8/9] pci: fix dyn_id add TOCTOU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org
In-Reply-To: <20260706-pci_id_fix-v3-8-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-8-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:19 +0000
Message-Id: <20260707141220.10BE61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently there is a TOCTOU issue in new_id_store as the dyn ID insertion
> in pci_add_dynid and the pci_match_device are in separate critical
> sections.
>=20
> Fix this by moving the existing ID check to inside pci_add_dynid and only
> check against the static ID table outside the critical section.
>=20
> Fixes: 3853f9123c18 ("PCI: Avoid duplicate IDs in driver dynamic IDs list=
")
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D8

