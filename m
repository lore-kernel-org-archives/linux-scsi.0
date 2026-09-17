Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93A3AB48F;
	Thu, 17 Sep 2026 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665073; cv=none; b=ClkeARKJPxXUup25gS52ctAgvO7ihEHNI6esoMlXOfdzTTcjpA3U3J5NykWFTwQbx79bj50IE+T8KgqIm6mShzDAc7Aw8MNwJ0u8IaneawEMO8y/9iG2lQ0OZ19iBcpnmjvkWqkH/AOaVMHyB4gAl8oRFFQapmKAl4uIgGLdLDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665073; c=relaxed/simple;
	bh=dUVTlcdT8aM+caf/oZ2Aapvv5WbGeHyh5slkxf4lhg4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NCRtGeQNTEgIt4cl4rSUOf0b2yRn3ziULxXYcRjN5m51fBX1/lII7YnvWC6volkdUHyJtc7nWIS+mw6U9Bzagbjtsr7/pIwW8zswnde42x6n1RLIeg6t8l/p+lHtmw9gE0Q4kVOY0rEUrZnaN3uWlzBZFtArKFf7uHsBSl8D9Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ew1yxHMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ew1yxHMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5DC1F000FF;
	Thu, 17 Sep 2026 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789665070;
	bh=dUVTlcdT8aM+caf/oZ2Aapvv5WbGeHyh5slkxf4lhg4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ew1yxHMtH056/lzL7meOqpy5eqtMBrXZmNCNZhIm6Aoxqdd01awgXWLBv1PLLYuvP
	 79oxBIWNZqTicpG1am+T+HJJUXm4umkVWOdZG7ulySslVKl5fWthELadfxctLCBCYJ
	 c91T/sFP9ROZNgN8WzWXdeXDFfjW3eQyO6R8okxZmDwKbSHHr/GITTOPO31RRSNemY
	 frK+ycOu1JoBLnl3UjyeEwDAG3BBG7hpwN73RZrCtslBdMqTuAb2/0tBIuHouEkXQR
	 oVooa4yVaB+w1N+iWEl31/qRkpt9vw43dpuqT6tL1XZR5hUva90o7ksJiwWDSnsVuR
	 LUlZI3J2eGNsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 03/40] mm/vma: introduce and use
 vma_[flags_]can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:11:09 +0000
Message-Id: <20260917171109.BA5DC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
>=20
> This abstracts the check and expresses it in terms of the desired behavio=
ur
> rather than an arbitrary and confusing VMA flag.
>=20
> This also lays the groundwork for making further improvements in VMA flag
> usage.
>=20
> Also update the userland VMA tests to reflect the change.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D3

