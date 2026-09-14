Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22A91F4176;
	Mon, 14 Sep 2026 22:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424291; cv=none; b=H9efU0dQr7SWsrnW6Z3fjoBKsT9GB+w6rMwC/7jkkZDKK9H/GUs2JYe5i2ivM4JQlMWxVvhsWNv6AhmgFx+jia6NDOKTPFIzj4feDTC7bTdCILAct1E6M2FGl4e3kNZVrvKPtEaH2M/P3ATqgSLMOfO+fZqKO85GVE3HHKKnsv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424291; c=relaxed/simple;
	bh=PBWZLje+EORDwYwarmdW9X/dW/jhJnmDYRf+A9Aw42o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OusOS20xN5zCP1WmnDiXAEcR7Xvsuw61YPrBIdMb9fOFJhYMiJXnF9wRBrjfujz1LkXuSOvrY7oiy88KaRLrooEDONpvo2B3dsFPL3IaTYoFZyJTaMnHsKWXp9ukuJEvtdptkbXRJkz6YIdTEeQUq6waFIMEt0CXWCDoeYtSLEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gw/HuIB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gw/HuIB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D10C1F000FF;
	Mon, 14 Sep 2026 22:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424289;
	bh=PBWZLje+EORDwYwarmdW9X/dW/jhJnmDYRf+A9Aw42o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gw/HuIB2124mJePNmCxr6OmGBWn8lOVcq8aYG+E3PBPBjy6+FZbkDn1Cw4N5AvD9c
	 mNxvsww/0ZKIqPFy8/+I/HORpU5TB483GBv1INMk0g2ei3VsLnWPMYlPxrgDLR7NGg
	 EP+qUP4mn00J9dPxrebqDONQxmsJKtPwKlJp1VhM40uol3Yj/K7Q92obZ/HRCyUyGz
	 uqEz+yVYeKq4uUS6m2QoC+8khl2zgs1SiiGdA40PniclG1Ch8KucucPjFZ5tJHpij6
	 jooW57260512gOftkN2mMgVPaA4v7JoSnA+HY+7OlQd+OUXY783QMqmSa51TddGHgt
	 hlO/8kEPaoxpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 33/40] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, linux-s390@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-perf-users@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-33-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-33-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:18:08 +0000
Message-Id: <20260914221809.1D10C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Make it clear what we're blocking in MADV_DOFORK. Previously we simply
> disallowed VM_SPECIAL i.e. kernel-owned mappings, fixed mappings and
> VMA_IO_BIT.
>=20
> Now the invariant is established that only kernel-owned mappings can set
> VMA_IO_BIT, the VMA_IO_BIT check is redundant.
>=20
> The rest is equivalent to testing for a kernel-owned or fixed mapping,
> i.e. exactly the same check as whether the VMA is permitted to be merged.
>=20
> This was established by commit 0b2758f48f22 ("Require (reasonably) normal
> mappings for MADV_DOFORK") containing my hands-down favourite call out of
> all time.
>=20
> Express the same thing differently - if we wouldn't be allowed to merge i=
t,
> then we aren't allowed to manipulate CoW behaviour on fork.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D33

