Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25B642640E;
	Tue,  7 Jul 2026 14:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783433543; cv=none; b=kNLjV10Aw5O4L2Fxa1YXH3fHbrxQPCpLlWZScKpx8XNTyPTA4mTNywVBHvnB2DKapm4IvR8gXsfjpudXZ6v/bdhmE2/97LGuaVUDTVknI346h6SmkXUjiWGeASozsOwqbW7hsOfvI4PY8lV8Ac8WJC8WOm/4CJOwrWeS9RNODYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783433543; c=relaxed/simple;
	bh=jA9Ju4PIhu1ffgguky4STt6TzXMN7ues9/+gqUty3/0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PpudfKdDs85AQRWmS3sv/E2kkAtDGL8HdkXgW1b8TQqqHQJgE0pxc5NFhZWv3EWKgMMOF1XXqZLn1BKC0vkgftZJHZCPeKP7xymenEmRifKN6D5KXR8gnI2sfLvrW3GMvAjJsDvIdU3hyhiGzSq/chO2OiZ4UL1b8xRiD+om160=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEozfLmb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEozfLmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024481F00A3D;
	Tue,  7 Jul 2026 14:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783433541;
	bh=jA9Ju4PIhu1ffgguky4STt6TzXMN7ues9/+gqUty3/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PEozfLmbcNcu9IQcd+7U97REqOs0CUoZKiHeyGMuYGdHwII8G7PriyYvg0bD5wZ1d
	 a4zWQJw5K8fx+cMWk+zfoxjtE6dfa4Xeny0vRi5DOotxtsTd16zFJ2H7YLpwQpDST7
	 8vDAPtwDm7H5Ed0TrssWGZf5PCgpHlkCbVqKIRh+U6Z5sTvRupupvh8IWcf7T4+/80
	 2smlsH/8woTT/s1dcNe4R+3quoqmOU66NN+ufgVUCz489buY6QqtLzK4Mo0MnDwcKv
	 YpsNP6yjEhxsBG+aB4a099ybTyqnr9UBhlPfQj6rXboHmd4H1Hpj53SNG9on9d/5jE
	 1TRnVU6RTjygQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 9/9] pci: fix UAF when probe runs concurrent to dyn
 ID removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260706-pci_id_fix-v3-9-2d48fc025acc@garyguo.net>
References: <20260706-pci_id_fix-v3-0-2d48fc025acc@garyguo.net>
 <20260706-pci_id_fix-v3-9-2d48fc025acc@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 14:12:20 +0000
Message-Id: <20260707141221.024481F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
> as remove_id_store can free the node. Thus, make a copy in
> pci_match_device. Also, clarify that the id parameter is only valid during
> probe.
>=20
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel=
.org/
> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706-pci_id_fix=
-v3-0-2d48fc025acc@garyguo.net?part=3D9

