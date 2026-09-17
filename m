Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF6B4DDB5A;
	Thu, 17 Sep 2026 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666733; cv=none; b=DSSmqfebWCH0ecx6OOLDPJ828HAhVHADfqVjxw+36DYWtr+PpUr72WmVkTjKxWXQKmOnY+q/Mvn9IlLwiYUGxh843glFu8SmDQ54vxNBAHmOAe2BY/orkRN17CFCVliAdOth/fbmF9MRj0jsi3Z/bTEQzpVZIgmTVHvFDymgZgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666733; c=relaxed/simple;
	bh=AIgkhydL16FddHyVviB9BoApuP59gwu0nGbav0cWsGM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UpLp7nxsguVAKEmkOCDJu4TGAQquakcuTqzFafLc3V+/dGI4MHVlck95UGdG2YqT5G+1Ge/HFjiQK4nttYzBBlhU8lE7vzjRzmWHumzENopfqp5gW5H2xTim5K3Vi2Pg6eqn0oZUuUpd/Ugept6LwTe2Vga+47DEn/86pc6aGlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HFtL5ier; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HFtL5ier"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7968F1F000FF;
	Thu, 17 Sep 2026 17:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666731;
	bh=AIgkhydL16FddHyVviB9BoApuP59gwu0nGbav0cWsGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HFtL5ierRwZd3Zxu2oCAnwJbcTFeH9D80jmKu88eoUTDygP7ndof3oako268OgWdm
	 3r2wm2p1JwhhxYPoE0iOOaVJMkqNHXx6/DMmI0g7v8j0ej8rdvPatGl5PcsnV5lZ6y
	 gnWd24jEnJZzZPko9fAg+M+uJR0qjWB6lQkBD66l8Rpnsr2hs/QHizGjrGzZ6N2Qy0
	 5hwestThJfO5Gejgu/aegJb9r7vXOdFZGwwTV/j5U+cIvMOs+dKoGJpa+XuveuvRHy
	 CEJRXDJOs/ApI1d4SfxOSu6pQse7v5Mrz7iVOfPCWaYqkDMWRiCFpK/sV9ARc1WMOr
	 lJeyIqLkBUNlg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 32/40] mm/uffd: use predicates for userfaultfd checks
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-rdma@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-32-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:38:50 +0000
Message-Id: <20260917173850.7968F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than directly checking VMA flags, use the newly introduced
> vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
> assessing VMA suitability for userfaultfd and UFFDIO_MOVE.
>=20
> Update vma_move_compatible() so it's expressed in terms of VMA
> characteristics rather than arbitrary flags.
>=20
> Additionally, update the use of the deprecated VMA flag API when checking
> VMA_SHADOW_STACK_BIT.
>=20
> A VMA_IO_BIT check is no longer required but that is fine as a hard
> invariant has been established that only kernel-owned mappings may set
> VMA_IO_BIT so the check is now redundant.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D32

