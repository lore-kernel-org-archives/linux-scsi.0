Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A176F43D4ED;
	Wed,  1 Jul 2026 11:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782904253; cv=none; b=OwgkeAEyRYugBbQvbpiNzbTTkDa7smvAtomDYrDg0BUEtIGFBdzk7wtTiDXc6GUsVeMyQgGzYAwR7qX2hf0vMYfXfsqCHwNmLt/7o3vJFjkSarzcJ2ikWUdRel/xMUclqX7Tpb/0pZGyc7TsifuYT30FqLCrJTd2VqJKEaXF5+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782904253; c=relaxed/simple;
	bh=8j58NSzaBdVS/3GdPoxNe4wUY1K6p+50Vq4owgC13TY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g3YabqpTlPRH7eFZxOzSYG4W54wANN+NWYymq0OvyDMEqhe0hExiZjKCqwcVHjt/VMWFKIZAQD82q7khw7kbkFaG+1zMnwnTeC69lh0ZzZRvKNqZ/QnksskaJT467mCY0ePJJXeoHlK2ckeBs53JWoI+Hw8BwjV4efApNsNBhAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iu77rfBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iu77rfBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA441F000E9;
	Wed,  1 Jul 2026 11:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782904251;
	bh=8j58NSzaBdVS/3GdPoxNe4wUY1K6p+50Vq4owgC13TY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Iu77rfBjq4rPzztRCSKNk/mdmuDDyMmbFPUdxigLLGbvPmjMpyCP5dMzzuvCr6IT1
	 sQPc4+HCmtUh9BWBeiG+0xFEp+MAnCDLSBPf7qG7gZB/m5PQWeyEsycdJ6rLEh/XO+
	 97um4RjhmgiFCLR/VWllo7iFv5Dw3Bia3n8rQqvLKPO5vlu26y/Mezr27Dy/lHCD+Y
	 ETA5QpJkln/2ODRmbWGq9BhdrR0ehV8+/mZk0c1CHLKmS4BtmuJA17OuGwhrxLGWbm
	 VaV+Jg8FCqkdR2YZsdSW6N2MHxhYraSwvyN8cNBNd3aKO2ytBZd18AP4ejt6VV5iCo
	 5eOZGYSMJgqog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/7] pci: fix dyn_id add TOCTOU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org
In-Reply-To: <20260630-pci_id_fix-v2-6-b834a98c0af2@garyguo.net>
References: <20260630-pci_id_fix-v2-0-b834a98c0af2@garyguo.net>
 <20260630-pci_id_fix-v2-6-b834a98c0af2@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 11:10:49 +0000
Message-Id: <20260701111050.2DA441F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630-pci_id_fix=
-v2-0-b834a98c0af2@garyguo.net?part=3D6

