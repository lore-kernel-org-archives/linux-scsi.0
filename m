Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4823647C0EA;
	Tue,  8 Sep 2026 20:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899264; cv=none; b=S8YL4o1O8UMiDtKDv0RZUuS2vYt60OCQvAA9gTVm05Vp50AfxKbEhmeyq1PM7Mb6sfBfVyZfONWv6i6dnnliF3ke3PIYf8XkY5gTzgRXpXznOvr9WFOMcrK6HpoqltxBxez3VW6w05DzCq/sH4NQnDIFq+VXf51wFso/5V0NYqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899264; c=relaxed/simple;
	bh=CxPktu2krGXA9dJay4P9gAzjPmp2OPwopEPgxLzhj6g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jwhLEkNW+HgC7GtLFb8QAG+oAcLG2kJe7q8bliGQBq03cEF4K/q5bkN0fCsPHAWaLdQZ3e2kFy6tA+jZnr5WpnCprgqy7PShqGW20WWKedPTeq6Coj0/jqRg4VlLtWE0wgTAo0Mq0DzgIqjysdD2Tzu7vFp1b5WWKKCQ3NGzYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9l4KWQi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9l4KWQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B851F00A3A;
	Tue,  8 Sep 2026 20:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899262;
	bh=CxPktu2krGXA9dJay4P9gAzjPmp2OPwopEPgxLzhj6g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V9l4KWQi/hWnsKQxnrfWXYfwWRJXMuc3X1bRjOb3LwXCOvBj7fkONDhelivIpbvRF
	 LrTomwYRxBBZGEY43jkzVKhIzz32iM7DwT6E0nxJEs18c5nxpl9Qh5gM8HDC/FENDs
	 oM8WTcIX07QPB1jl3lWPoed5uQTy4cXScQwS6kJwZq6JpsRQp5FSuCupAyR8M+9FWf
	 ypsbd8EMyGkrSU8Mqz3N9qIwNvGcKmXMDxgQx3lNarAF8tdEQ+iG5mhjkbld+vwkEy
	 WccWvU7bNmYoaegiBIAhSQqywybdblNnXTsZFMbopU5iDnBtX1AlasbOZY/q1ggiDY
	 1o7omylrIf4gg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/39] mm/vma: tidy up map kernel pages enum values
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-6-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-6-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:27:41 +0000
Message-Id: <20260908202742.12B851F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> MMAP_MAP_KERNEL_PAGES is a mouthful, discard the MAP_ as that's implied by
> MMAP.
>=20
> Also while we're here delete useless comments for mmap actions whose names
> clearly indicate what they are for.
>=20
> Also update the userland VMA tests to reflect this change.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D6

