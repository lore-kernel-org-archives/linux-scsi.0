Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB06838BF6A
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 03:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110732; cv=none; b=QAaOcsXbKx9ekqhl22ovpwsg3YYB6JcKgnZK16W4CuWb7gAjST/Gc3tMAmeTCxTPKLOCHtAusSWhFrfI/S+Y5Vmm8zZi1+8mQ2gWNPmcBR4H6j0eVHKWFpl6hwG7g3jbFuGhB7+kM8etb0nTMwIy54Lu0hJ91RwAxRwlTtd0O28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110732; c=relaxed/simple;
	bh=NMxVgwhJW4rjN3A4s9z+20mWCxrQXdNTBC+DeiqIaT8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mphQCNky6ebxvCG3M9gNoFAwrE42KixnwJl9ES8OMxcSD/h7jUj/0sB4+QUjacY5C7KQyuJi2EN6BA0tTZsJG2bqlN7EP7PSmV/6zVKK6nm/GOhfeLi7VVpEXTcSoVXN1npMb0J5Sce9Vb2n8rKu1WbuQfHe0cPbXrnj6Q8wxvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=neKb6mrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="neKb6mrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4746A1F000E9;
	Wed, 19 Aug 2026 03:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787110731;
	bh=tH2UdIQsxCEMi7SkMHRVsU8RuaS+SGs0xd5Y4NMoEss=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=neKb6mrft98UgupH4BRrHsoNEzGa9699hhufL/NER+FrJduuKDvRAMMW5OzciNsa4
	 zA3RXLnuk7NP+WbDdkKciydpAmt/G+RLPmKAbQ8Bv/KTWMIgjVxffoe5f8kLlovkpS
	 kYzjEir+fbOgTeioT5xnkMU85By0qsW/IbSDGTpDjNDnqmAzyhabokV4M7VVH0a/as
	 RvXfEZAdzDxsera5XcqGYcftDbwJRm40ditFdplK6cpn/WIm/YfDyU8vwZuc8cCNB8
	 sQ3Vg4dVgRXfF/I3kYc53bX/Tro2AmvLCQUqrvBWMWNCJ1Uwhh666XUjZsFQ3L1TRP
	 TfgW+oThkU4/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/3] scsi: libsas: Handle errors in
  sas_ex_discover_expander()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eshaan Deshmukh" <eshaan2031@icloud.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819032321.493746-4-eshaan2031@icloud.com>
References: <20260819032321.493746-1-eshaan2031@icloud.com>
 <20260819032321.493746-4-eshaan2031@icloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 03:38:50 +0000
Message-Id: <20260819033851.4746A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unchecked return value from `sas_expander_alloc()` causes a fatal =
out-of-bounds write/kernel panic when accessing `edev->level`.
- [High] Ignoring the return value of `sas_rphy_add(rphy)` leads to driver =
core crashes and invalid subsystem state.
--

--- Patch [3]: [PATCH v4 3/3] scsi: libsas: Handle errors in  sas_ex_discov=
er_expander() ---
(Note: Due to system recitation restrictions, this review uses a free-form =
summary format instead of inline patch quoting.)

commit 44af8b2a020232c7d2be451e3b31502443d8fc4d
Author: Eshaan Deshmukh <eshaan2031@icloud.com>

scsi: libsas: Handle errors in sas_ex_discover_expander()

This commit improves error handling in sas_ex_discover_expander() by checki=
ng
the return values of sas_port_alloc() and sas_port_add(). If either function
fails, it performs proper cleanup and returns NULL.

In drivers/scsi/libsas/sas_expander.c:sas_ex_discover_expander()

[Severity: High]
This is a pre-existing issue, but does this code risk a panic under memory
pressure?

The function calls sas_expander_alloc() to allocate rphy, but does not
check if the return value is NULL. Later, it calls
rphy_to_expander_device(rphy) which uses container_of() and subtracts the
offset of rphy. If rphy is NULL, edev becomes a negative pointer. The
subsequent write to edev->level =3D parent_ex->level + 1 would then
unconditionally panic the kernel.

[Severity: High]
This isn't a bug introduced by this patch, but does ignoring the return
value of sas_rphy_add() lead to a crash during error recovery?

The code calls sas_rphy_add(rphy) without checking its return value. If
sas_rphy_add() fails, the internal device_add() fails, meaning the device
was never actually added to the system.=20

If the subsequent call to sas_discover_expander(child) also fails, the
error handling path calls sas_rphy_delete(rphy). This attempts to call
device_del() on a device that was never successfully added, which will
dereference uninitialized fields and crash the driver core.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819032321.4937=
46-1-eshaan2031@icloud.com?part=3D3
