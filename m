Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730BC4FDE75;
	Fri,  9 Oct 2026 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571181; cv=none; b=XYnN1NUV1Tc97KJPHlBiy5tulRPpsx3RbQuuXCIQT+8uBRySQhaIlRS3HIRJelXPLQvEU83dobr5ALu0Qo7w0qgJnpJascZD4ufefAsgk9FsiRVU1tvpXLekzvWBuxJ3hGwuYN0ZMW4Ds9kDK3IRg04X8U0VHX8YgLHfhenyJT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571181; c=relaxed/simple;
	bh=lnMo3Kn39v/IVV8tPmzh8JgGGAbd4XjAAc46euKx2Oo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=vEspRg3TZ6v2ULJcyLNp9f8J46rSt2OefXvMv4l+jT4Q1+bYJUKNSUbg5XWmAMNjiFOiWzx9HzK7jFU/bHYLATuxGxF1k8ypmgBCx+PNk+XiigJwLSL1ozLbSlCTmFxqwHPdmFgXD1y6n+UJV3+9wsugaX1f6pe1sP5maLiM0jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b3C9IS5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b3C9IS5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1E41F000FF;
	Fri,  9 Oct 2026 18:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571178;
	bh=lnMo3Kn39v/IVV8tPmzh8JgGGAbd4XjAAc46euKx2Oo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b3C9IS5+kdMRuxlgydRVDid8tMgYuqta/oXLMR7oO2BvzlH+RMO9FhPtbMXeYsWWX
	 WPHEx8jM4vdZbmjA3YOl08hEx0V0gLAXPhKZb70kvE8mqagwxko89Bgk+25uJG2aPw
	 ouPNEdURStPMY+7KCdMvO65kWn5ewFzn1BgKdcoQkAU0GZJvgSeU9sLywf8a2dQ6rB
	 jUJEPiNGuVTRceIjKq69wUwTb6hbLDIygaSqZfN13Dgbu0CY80h/8Ni7cP8OTOAffg
	 e46b8U32cVMninybIkoWce9/PVKyAcmzbXgdDaol0dqgl9VjPaFL1pBQsTSDC3cIts
	 nYYAFUGl4Jckw==
Message-ID: <sashiko-outbox-165959@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 19/38] HSI: cmt_speech: convert mmap hook to
 mmap_prepare, refactor
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-usb@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-19-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-19-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:39:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Use the mmap_prepare in favour of the deprecated mmap hook as part of the
> work to convert one to another.
>=20
> Since this is simply a refcounted kernel page that has been allocated, it
> should not be marked VM_IO and should be inserted using the kernel page
> insertion mechanism, so convert it to do this instead.
>=20
> Use the VMA descriptor's private data field as a scratch buffer to store
> the page in - this stays valid throughout the kernel page mapping
> operation.
>=20
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D19

