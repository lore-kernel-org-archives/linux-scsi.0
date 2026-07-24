Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7756541378A;
	Fri, 24 Jul 2026 22:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930531; cv=none; b=ri4M4NAQnTlgBprRG8bcwQLGZDwrlZQmyWEpRrkZq4k2m9DNRC9T3YzKTDpLuJT8a5YtbP6kPmm7uMmm1zNDAfvYk+zdfqFbQjVqdlSei1c26aUCLkCHEVSmThdoLkBGdvY/g82i5Gc29Gjx05Y1pwf+8TrTCh5MrW/HDGco47Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930531; c=relaxed/simple;
	bh=PW/i8776VBu7rM4sFwAMjM1fk1tVadh1I+vuIH3wxmM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R7DxUzCdeHi9rjCVSo/TVMXK1892RjwLFIDlvmFV3VT5+vJiFeBz40UmY8Sl+lV4rRk0nJW8FHpfGbHHfxJVaJvVSsRHgwJNg3e49rrcMFAORr5dnQ2gZ2SESHtaaNsIWALRYXC9jN4SiNcNRufExDL87tHXDN4BpP1C0JL3sMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jaEYENRN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaEYENRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069551F00A3D;
	Fri, 24 Jul 2026 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784930530;
	bh=PW/i8776VBu7rM4sFwAMjM1fk1tVadh1I+vuIH3wxmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jaEYENRNaGuZNM/sMbcIhckyT0UP81he8l8MZHXItkMu9skVYeXwnzY86Be6t/2AS
	 6bDziAbrN8uIJXjuYfXsl4TrWaxlzg5gp8n6brUZy/HSnx2Z9wscyDrFP23rKVrgjI
	 prs6+eA2o1t9l+cfA9Wkl13LOJsVXGC0TpkMVqzlayy1h/B8XBe6iYIjG1guk3CDa4
	 8dMAr4Xamrp8NfPRf4APl+4aKUOsQFESCXDMJ3LzbNDSatI71/r+QolDjQPrKAO16/
	 npFJWwFqzJ5L6YUeKO1nYEKCJEgmRjcTyxUYTS9/dI8vRWC5/cse0pON8vOkEqPr4c
	 oAuCLc2JADsTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 9/9] PCI: Fix UAF when probe runs concurrent to dyn
 ID removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gary Guo" <gary@garyguo.net>
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260723-pci_id_fix-v4-9-3580726844e1@garyguo.net>
References: <20260723-pci_id_fix-v4-0-3580726844e1@garyguo.net>
 <20260723-pci_id_fix-v4-9-3580726844e1@garyguo.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 22:02:09 +0000
Message-Id: <20260724220210.069551F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Dynamic IDs are only guaranteed to be valid when dynids.lock is held,
> as remove_id_store() can free the node. Thus, make a copy in
> pci_match_device(). Also, clarify that the id parameter is only valid
> during probe.
>=20
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/20260619170503.518F61F00A3A@smtp.kernel=
.org/
> Fixes: 0994375e9614 ("PCI: add remove_id sysfs entry")
> Reviewed-by: Danilo Krummrich <dakr@kernel.org>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723-pci_id_fix=
-v4-0-3580726844e1@garyguo.net?part=3D9

