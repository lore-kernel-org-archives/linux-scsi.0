Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0963047ECCF;
	Mon, 14 Sep 2026 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789401572; cv=none; b=U7uPkbfmJEiD1QbQ2dV2WBh+pQDG9DDZIfcJzuq8C5rjF/iRC9gRraaF0aGBwfcIV938xcWqJAeR8B2CWV8eNNsM4ClHC2nXiJHMH+KqketNG1+/mAeAQeMHX4qhREYBaioBghBSHw3CE7l1tjNUU6tFORq+Ph1RRYh/1HAgr1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789401572; c=relaxed/simple;
	bh=grad50efz4AqE2o+MlqutHFcoywBEmBOUYINmcBHg8Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mtpzyU24446pYe/X9puxZBZn4N4CTPl/itlPezMu+uMgELAqT+tGVP5jaV+olnyKeHD5Y6eGDStcvb1POwwouXtk8SqIxwgWqVA676rIKZKuS4uXQ2lW651Oi4cajHTCntk5tebu05fmudWlMq6mewb7dE7tSAZ5Af2Q4myjzy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXmRf1Y9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXmRf1Y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDB81F00893;
	Mon, 14 Sep 2026 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789401570;
	bh=grad50efz4AqE2o+MlqutHFcoywBEmBOUYINmcBHg8Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XXmRf1Y9kHfVTlFZ3mIUpb28q4G/uQ3/ahwY1PatkFwdjCZRcp2nuj/NXsQsGOr/Y
	 g9NE2Htaalx2xaI+KPuHo0QfLQQ/pKp8tt0JdK8yQwtr8Ulxj4v+yXH6J4mY61s4hc
	 gEqdxglmZP45C/52Lt+albTOSf7+YCTn5eEH8b3Sad5C3HhyVnv0y6xh8xrNJBG9Uo
	 4Af7YYxk6Hq3QIvVe1Yym6kMTiwcfU8lg7vBU/6OWLWfFBq8LWwPqFFP58P/r+W/EV
	 XajmEEAEfKIGzNSCt0WybSWyKU3mSVWvNZoDkeojCXK4whDupB+6z6MOXOmCCWE4nJ
	 O+Iyaei/zJ7pw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/40] mm/vma: introduce and use
 vma_[flags_]can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, kvm@vger.kernel.org, bpf@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, dri-devel@lists.freedesktop.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-3-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-3-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 15:59:29 +0000
Message-Id: <20260914155929.BBDB81F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D3

