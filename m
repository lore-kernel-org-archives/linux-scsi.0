Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB3A4FD26A;
	Thu, 17 Sep 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666091; cv=none; b=M63DxKwTlJY6qppwOvBt7gDH9d5n3MePG5Nh0/6CzDcHxDoLP/wi6THFI9cSvsMHubQks9rgErmyNuDVYnYOHQllirNlhYTw/FcQ6FarlZeoYLJMSGWYvrYo8qe1ZxjVdyjGyEinoykjWE6M8D5GgXXDgGoI0LmZVfY1LJpTiis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666091; c=relaxed/simple;
	bh=vDU87ipAS5UAxV5m8p4D391an8rHhmbZDcohTZwCtlQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oLDi7knTEZLTe/LlaJqgi3M3o/C9KxAZzv3py1G9Ks9S/mqY+POteiB+jfaDf84pPap3yZN+u7NGLEExb9Vm/oVgPj0OpDVqoYplDsyEJlu2GfiIzCvHK+C0iTCAckM99iaE0saXXM9+Z+KjwnGCRuWm3ZDWofCDyU4W99hbVkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cNoC0wXF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cNoC0wXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D311F00893;
	Thu, 17 Sep 2026 17:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666090;
	bh=vDU87ipAS5UAxV5m8p4D391an8rHhmbZDcohTZwCtlQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cNoC0wXFRE2kaPEMouFuZbfJN84B328Hab508HJ8d8Gg230OqkTWxLCWo4aPVqEDq
	 FsoQNjDNPX2/YldNel6eh91Uytq2nG5A3jk/aCkqONVuAVXilU9kMB5Dty3RKPrtem
	 4AwantuY2/x+BAcPgHY4Z9rIhpk9ofteT3m+0+Q16oBsULLPFP9l0J5PUWe4zQ0iSp
	 Ktq/u8AYahY6D7aGBanfrZMwuXXVPVRmhwBixRw4qlurh8b9Jomcam5FHnln/ldcb8
	 mBES0hrpXu6PGOl2zy1J+m/rXPbDKoDP64aTuEE4J7W9mko6FnivoFBrdMeDELdsaS
	 fQg/Lxa9ibm/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/40] mm/vma: only allow mmap to clear
 VMA_MAYWRITE_BIT if kernel-owned
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-perf-users@vger.kernel.org, dri-devel@lists.freedesktop.org, "Marc
 Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-16-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:28:09 +0000
Message-Id: <20260917172809.74D311F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> For ordinary files the only way the VMA_MAYWRITE_BIT flag is cleared is if
> the underlying file is itself read-only.
>=20
> This means that mprotect() cannot mark a shared mapping of a read-only fi=
le
> as read/write, as doing so would violate the read only attribute, and
> permit writes.
>=20
> In general, we do not want file systems to be able to do this for
> read/write files.
>=20
> Doing so would violate fundamental user expectation of file attributes and
> likely break userspace.
>=20
> However, drivers pose a tricky problem here - the /dev/xxx file may be
> read/write but provide access to a resource which is fundamentally
> [ ... ]
>=20
> As all drivers which clear VMA_MAYWRITE_BIT establish kernel-owned
> mappings, no functional change is intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D16

