Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4F51477E;
	Fri,  9 Oct 2026 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571773; cv=none; b=nXZ05C3clvStqQZuMj4nEFS/XbX2uvF04CrphImQ+LXW0RMHiGC7BtR4WK8DwtZwJbccDCmOZO+fdzw/PozUsdpVn03CWr2h6M50rTabmc2+NlidoTwdbqKIWlyhQ/C4ETfzNiFEAQDipjupnetKQINy/nk4S10kzleRqP5s9Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571773; c=relaxed/simple;
	bh=etbcfEA23+sEbfjKZsbUOXEI+j0f2IL3MOXyO6TN2g4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sOvkDNUJOeMrU+QJ50yA5eoL0hhPK5/Jy0gx/QLAxN/C656XVRI4783XwQAHhe8Wwkn2yb2zEafyHuaave0uE5xJxgiKp7XmED4p3cU4A8E0HilBATBYb3rF4bnviEUjJmq0GSVXcwpKbdsDFFG4SwMSn3A502IE/3e/aYn04Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enaIngfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enaIngfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781FF1F000FF;
	Fri,  9 Oct 2026 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571772;
	bh=etbcfEA23+sEbfjKZsbUOXEI+j0f2IL3MOXyO6TN2g4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=enaIngfW/xAJg0vu0dsb5AtEirTQaNIxmgl452k8JVENb/tngopGcKegOqj3DK/sO
	 jF29Bx/RslZveu3KOj0YHUwoQv/Lchj5C9O5aoNt8ohvChOHQ8fjTwlrFJkvQpNC8v
	 mj05tepGT8BU6qw1gpprfUZUAvMDouxZkhqeADIn1yxXTgCBEls5qJCTdD7v6Yw7UV
	 zVWYep9tYBIPMH5s3dp5TBFm3ckqsWnh/+aGGGmbzFTcHJlRikT09anzqyj98iBUre
	 PjtHDx+Iv7x8QYHmSHwHNsSU9qH5+4ZUvPcA/tbGwakd8NuNgJusXkkM0q6NfGznrG
	 aRBnkBwPgnrhA==
Message-ID: <sashiko-outbox-165980@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 34/38] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-usb@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-34-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-34-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:49:30 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> A fixed or non-mm-managed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop =
as
> mm-managed mappings may not set it.
>=20
> Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
> self-documenting and helps eliminate the confusion around 'special' flags.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D34

