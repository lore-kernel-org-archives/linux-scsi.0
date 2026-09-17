Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E5E4FD7A9;
	Thu, 17 Sep 2026 17:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666313; cv=none; b=El69veWq2kcoOuLvC+bZVxnTLCG1lkkjYGGqlWK8txWRx7VzPI3rDvw+S8OTpbjPPkekRIZrPYqIC0im/73ahnE8Qp3VwpWS9sdosAP2Bcpy/4Rrf9yrvuS5Q8wKpAm6Lm3o8B3yvK5vdrwrJh2dzgRIzj5iGS2ciJX2NpeYHLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666313; c=relaxed/simple;
	bh=+Ec0BUb2k6aj32bDnhEPV1iOCTJIsMnKCwDRipXlmUM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WPgGzBJhAfnTyEqg8OhUEVJpDM69Dop7LnMHvJpPnLW1HtD9MD42M6mZXOL8q56y0sKVoWeElvwxXddlx5Bs5dNwufIelCeukhDtPMWGVdHVJ/Ys19GBCvkb5aqZMW2dPjmoh6nVjrVAa3V1PufumzTiNQC6Ok2UkMgidJdmq/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SszozQN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SszozQN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811891F00893;
	Thu, 17 Sep 2026 17:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666312;
	bh=+Ec0BUb2k6aj32bDnhEPV1iOCTJIsMnKCwDRipXlmUM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SszozQN5DKg59dq3zPlxk8QzsxOkEKu2kzMyCA5kq1oPDPG7CcVklmxy6LvJN4kZz
	 XAUjIINAAbEu7MPwDgLxKWZTmJEfaAUT0XSdfGe8N3Crz0b0NFe98w+A6HtmeA3/R0
	 zbXu2rs5wQAj28v8Yl9AK69mVV95tAGS24HCJNNYmmooETVOBFDMWajZtXQJ7n7ecn
	 q7XKjrKlampOwXaQVSPQkPQY1jlo5ws/4UjRFMycN6IAHYd0ZfmeCwzZHeLDCZFqt4
	 UnP1JgT2/NM9oLgn0/qJ0CBEpACGayowQ8vi20SHkQE6z1G3loqoZd1hrmXhVG24GF
	 Q+dCE5/zIx6xQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 25/40] mm/vma: enforce that only kernel-owned
 mappings may set VMA_IO_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, bpf@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-25-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-25-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:31:51 +0000
Message-Id: <20260917173151.811891F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
>=20
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as kernel-owned. The check WARNs and fails the
> mmap for any out-of-tree driver that still sets VMA_IO_BIT without a kern=
el
> mapping.
>=20
> No functional change intended for in-tree code.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D25

