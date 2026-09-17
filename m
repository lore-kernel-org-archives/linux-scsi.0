Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3413BB119;
	Thu, 17 Sep 2026 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665469; cv=none; b=BnX0yKNewwfuissskjMu7pRNJ6Zp5juGGqZyUyHDlnOSC+0PF6y1VbB7gfAiIqxHXFvPCq5ppiK+3QgQRrMkG3kmIaoiKaA3jR5brMH9Volkp0iw/YCSCKH87wYkOYMg2USmup2bzVdwxX1prNfkQ4S1yq5QJxeqp6HCFggtRWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665469; c=relaxed/simple;
	bh=GXU1PpBZQU7XTDspOvSDjd7AoHPZBrsRywyurj0JQa0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FoM2r0i6QC+DZLY4Kc0J1LN+ALp3ikmhfafIW4rDZPo+n9+qSxvs8A7wuJh+jlZ1TW8sQ7BxYLKqgM6bq1JCCBstTIgITKppcTsN5jD9KyzjJhQW5UP9fJEUCUuTHTLpjbHO9rLKOZuKQD+fkV1rLg4KGm71CKWJ383qkSOPl1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZJxF3Wz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZJxF3Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A951F00893;
	Thu, 17 Sep 2026 17:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789665468;
	bh=GXU1PpBZQU7XTDspOvSDjd7AoHPZBrsRywyurj0JQa0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MZJxF3WzCdmEKrSNZq6ufHzbYKXFys9mgiz424mlCWhuLbBplBoktOtdqal/mTtZQ
	 S1SAnOKNEhpnQA64qmusKYCQ5ziVEgV11vjNg4iRpg1bO+TKZRBoiZbNUFiIetPi1O
	 h5M348t2IvQk38TQL5rKaQJtWPCo6b11gwQMTGrkp3/6Z0yvJ+hphY0qhV+1JTvy3/
	 CDpWIVUmHRjJ8AyrGFJQYAh61D5y10d5UAiWKSAdtI22k/VRzl7mNkMlotPcppe5NJ
	 GwagQw+/NeeGH+CHlahKniQkYFat1gDIWm0Ozv3F0xLEeVwomFyNuQ9W2RXo5uUxeX
	 959p27pqHefZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/40] mm/vma: tidy up map kernel pages enum values
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvm@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-s390@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-7-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:17:47 +0000
Message-Id: <20260917171747.C0A951F00893@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D7

