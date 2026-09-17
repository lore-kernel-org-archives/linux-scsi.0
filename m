Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103E64CEE44;
	Thu, 17 Sep 2026 17:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666302; cv=none; b=dybWXzUi8bVGsnPyNtt/y/SjEIA1vdpZZkY15akCW+pl3bpPNsqJld6kMqBvIFd0cBS3j5EyUbBI3yKAtdXEmjepBNhsQK9c3hpHfceD4fyyhb3FSXaQyuAqy9M++6yCni6O4bS/BjwNpDfqK5L3Yxg5eZ+BCwe2Y5ic15wxznc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666302; c=relaxed/simple;
	bh=1ooLm7hrXtQndWS3tT1leP5llkYGwrNxLD1Xfrvgqu8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hvKiYC3hubUgrckrXJCtR0aoPGaPM550GOMYCE6gewjPABmuHXBgHY5G7GJFf3HNFGQIST6gTVMbK/k3bXFqjLyPnGBVUCouAaBQqXVnajHDyUVGISxNaw9J5L9i9FyoPlczBVpIW0+jmyITzVVEEVmgumBZ3oidGkSbG8IVRQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ofBfnCUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ofBfnCUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219641F00893;
	Thu, 17 Sep 2026 17:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666301;
	bh=1ooLm7hrXtQndWS3tT1leP5llkYGwrNxLD1Xfrvgqu8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ofBfnCUhpRln6k+GHy2k0PlXWBDfr111QY+AgFq0gDqOsrrECKsFQ6p0EEnuwhSKt
	 /zYTB0zat6vJ//+8tizwwbuHhUo6PZa2A2mFK6UWbnvNfbkYankAT4fP/O8PoUwJZ9
	 9qA/ZRRyAMYEBcgdLRYCiHrUiTVOQZej8QvJ4AtIwbbM9JqgNMQpFy42nCbGau4CfJ
	 SUug3adp/Xvm1eytP+1Rx7/ujrI7xb/E6TRZ+lgsSU362/Nb0Aff+UWdQkV+YcczgA
	 xtE2h5vkh98nEWQXRjV86gy2D+m2x1Wk8fVK5qMFVCdiwYk9gOpnmvSIA9q4LW/1Ov
	 K6Yp1SWgno+cQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/40] mm: remove hugetlb_inline.h
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:31:39 +0000
Message-Id: <20260917173140.219641F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> This header really makes little sense - every place it is included mm.h is
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.
>=20
> It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
> VMA_HUGETLB_BIT is unconditionally available, and will never be set if
> hugetlb is not enabled.
>=20
> Simply remove the header, eliminate the odd ifdeffery and place the
> predicates in mm.h.
>=20
> The naming of these predicates is odd, but to keep changes separate, we
> will address this in a separate patch.
>=20
> The file was never put into MAINTAINERS so there's no change required
> there.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D27

