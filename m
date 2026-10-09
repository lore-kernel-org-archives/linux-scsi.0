Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB5C4F3EA9;
	Fri,  9 Oct 2026 18:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570007; cv=none; b=bVrXAI1EabkBVAd/wZBbRtvh5IzXvr6maRD00U7oyu2jQoIdS6sUFgbgZMQR8vnr4inZLDt1cQswjXNwiH8qUCxKotM5smcnk0s2DC+Pfb49CA9+Y86pYHEwtKnL+dgacvyI9TEujtScCz4bRc0sK3M2PNRqjrfSqVG2D7R3ykA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570007; c=relaxed/simple;
	bh=XVlb3mYoSbmXQy7keQ5SiIkIOFjittedAmc93PfV57I=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=OgJU43DvnMNXAmKXxPzIEdcGBIlj5tx6L556KSY2cV6g55HPPesXvbRdQPGOSWab/9h4wSp0HXdUuWtHtYdYmcKSzjDRhiKUi5YJZqdgKAc1LQQXg6TRV+ksVsTp3E7C7KpaaQWzYblgcx6j6Zh9BqO754UlZGda9bhqgJtc46k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFbw4/T4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFbw4/T4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBB81F000FF;
	Fri,  9 Oct 2026 18:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570006;
	bh=XVlb3mYoSbmXQy7keQ5SiIkIOFjittedAmc93PfV57I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NFbw4/T4oBz3H+UYivcp1/4PPhbobaj22UkJxFy3ezuYVOpT8ZItiiQgOlWNNz40N
	 aX7V+GyqusVzLW8QeoIinJdUh9+0g+5kRmASKS1ORhICy4YyCEUvORTH4vOy9IdPd3
	 pQiwL36/jmyB2vfVknRA+dvy3wA1Plw1c85P6TES+TZeCD8fuMNtTI0wyO4p5NQQ2r
	 dfrmAhVpM4SEgjVBkFpFdBLO10sh6Q3RTCcYvwb4T39PJ0EsuKqgs9nKCxSOm33vhV
	 4ikqrWiQ0zInfjTL+f/hyJZTSRnAs0j0G3uLNsKFFoz4GSHuvsQ0oSbUuzGqOTCDAG
	 k7vzboCLWqfpQ==
Message-ID: <sashiko-outbox-165931@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/38] mm/vma: tidy up map kernel pages enum values
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, bpf@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-usb@vger.kernel.org, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-6-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-6-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:20:05 +0000
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
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D6

