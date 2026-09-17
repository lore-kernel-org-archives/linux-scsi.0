Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5193B6C18;
	Thu, 17 Sep 2026 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666618; cv=none; b=CwaGZoIzjYX236PtEELoRSKw1Yo2RY4+jC9ZU9eElRXMqWBcSl2n0MgzfThcu0c7vmpmRUvtLk0lOlhqQBRwlgBX6CrRHXkcNwNPbKg/937Xi+RtRp4uoG3TgOHU+g5jXmS7fqkWyW8f+ZgEud5S/vW7EhPHMFQFHyyaPsH2GeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666618; c=relaxed/simple;
	bh=TbfPAhp++7ImaEEoNafSDR6Z8m5cRS7+q11IIXOZq+w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=US02cQxmDLt6kNSNng0HL9orE5G5lgkXCprNfMNT6WFmhQ7PrpoSYFwGNLWk4ZpSUlEtOVymi0cMZxf5bZXGM2zdb+gad+z8iDuDhuabGCUPzOEAEEwubkP/m8/DhYxNnqnWDDfPVgAyQDXV5EsLosL40IGBz+acKIWO8bd6S6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oI9MSfPL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oI9MSfPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B411F00898;
	Thu, 17 Sep 2026 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666617;
	bh=TbfPAhp++7ImaEEoNafSDR6Z8m5cRS7+q11IIXOZq+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oI9MSfPL2prL2QETsXaQtBhVmoKZN43uN5fTOMdnQWD5ekghIhR9Ju662WT26q0F4
	 KGC9simFo6Sg2UbHiPKP519AaIhylGwrlJrPsp/4WdfOaeZGnGpeD6npuzYxIedAoa
	 mJ2TXoPnGfmoCWroO/DOykvuCDQyfMX0J3xQEMgQI307EI3zb/pKQZUte+zYl7G61q
	 gUfOMXksRP6w81VCdd4F6sGkC4jYE99nLfRMjjBEYQfYsKjkPTf8WKjmyizut62Scw
	 OH97ah3G7S3W824/yHTiAZuABADiiflD9H1+eXS1l9vajDpre+DbrW4+LffrRIhnBe
	 rPtllfgg5Hmvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 40/40] mm/vma: introduce and use
 vma[_flags]_can_gup()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, bpf@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-40-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:36:55 +0000
Message-Id: <20260917173656.46B411F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> GUP cannot be used for VMAs which set VMA_IO_BIT - because memory-mapped
> I/O must not be accessed on the user's behalf - or VMA_PFNMAP_BIT - becau=
se
> PFN maps have no folios which the kernel is permitted to access.
>=20
> Rather than keeping these checks open-coded, abstract them to
> vma_flags_can_gup() and its VMA wrapper vma_can_gup().
>=20
> A number of other places make the same check to decide whether a mapping
> can be populated or accessed as GUP would, so update those too.
>=20
> While here, drop a reference to 'special' and replace a use of the
> deprecated VMA flags API in vma_dump_size().
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D40

