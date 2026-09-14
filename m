Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E5A2E7165;
	Mon, 14 Sep 2026 22:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789423965; cv=none; b=TSF6tKQbmycO/M3UTrjTaxBjFdla0dtwVYGr800x6K1Fiwn4zjjlQlI0S9Aq47r4bOHaNtDyiX9p3JiWSWfzKOkJWIqeLFHzTzF0yNzMUH5jqSPeLShc+uw4uaWaF+snzLQL4xPZYkj4yBzQwj5moO0ifWHB8mtYrJq6g+Mxp/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789423965; c=relaxed/simple;
	bh=EqtoLGLw88FFajVWqs/rzfLrA2MDhzukA4NQOYCEbPk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=th/iMIx6F6pQxagz7/MHKmuJLN+docCUZTyFRsvIfQ4vAhiyWfSIvPAcL47AstsvkigzsCdBrZM9KsHCGuM1EsFbBjSJPm9R4a3ZOftD2bbi0bTeePHBrbP9jnLriGJOui8V/vgnPV1yJiHHClVZn6rfQ4UkqDgYUZSOcDI3dEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sqjj6lfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sqjj6lfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6FB1F000FF;
	Mon, 14 Sep 2026 22:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789423964;
	bh=EqtoLGLw88FFajVWqs/rzfLrA2MDhzukA4NQOYCEbPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sqjj6lfpmaCkN65cA8V6wT0WTZLQcFj8ssq4R0nHe1hmDVny9Tzazr9pFTMtZ60YZ
	 CjqnCNDJY8ccvXZmTbnBEYewdKAKwo8vkkas2oC6SHLofxyHSh4OimaaTzcKfaS0TM
	 M+NSy6lZ7gmVxIf3nPnqEm8mMXPsYOm/qnpoK+pjsvnfGsj1iiTyC23HIUnaQL4JNy
	 O39UoN2Sd8O9+rH2pSexkE8trmIzWnl4LhVR4qbYCFcQI5k8LaaqoWZskpFGe12Poc
	 Yk/1bWvV6dF7T2cPz7BBeAZWmtSWqtqAbkg6PE18Z1Q5kzNjRoICBrblv5IwQ21o0I
	 B7WRBSQd9W6Vg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 31/40] mm/vma: introduce vma[_flags]_is_persistent()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, selinux@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-31-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-31-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:12:42 +0000
Message-Id: <20260914221243.2B6FB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Introduce vma[_flags]_is_persistent() for the purposes of identifying
> mappings that are persistent in the sense that bytes to the mapping stay
> there, and bytes read from the mapping are the same unless changed by
> actions taken by userland.
>=20
> Kernel-owned mappings do not fall into this category, as their owner may
> change the contents without the user having initiated it, and nor of cour=
se
> does memory-mapped I/O.
>=20
> We exclude fixed mappings as these are singled out as being unmergeable a=
nd
> so cannot be guaranteed to persist user data.
>=20
> hugetlb mappings are fixed mappings, but their contents are entirely the
> user's, so they are explicitly carved out as persistent, as the MADV_DODU=
MP
> check already does.
>=20
> It excludes droppable mappings, which by their nature are ephemeral.
>=20
> Use this functionality to update the madvise MADV_DODUMP check to test for
> persistence rather than open-coding this.
>=20
> This replaces the VM_SPECIAL check which means it no longer checks for
> VMA_IO_BIT, however this is safe as we have established the invariant that
> only kernel-owned mappings may set VMA_IO_BIT, so we implicitly include
> these.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D31

