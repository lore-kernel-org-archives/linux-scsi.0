Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E27490C0C;
	Sat,  3 Oct 2026 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050217; cv=none; b=snaFmR0N7MQM0J9KJluQsaq9EO4ntJvpw/pZo9uMEB56zVMJVfNuNRuxaBKF25nhIxti1qtHBePPzdUs1E3ihLlwK21xcakZZwsHvekbvcYxIkXQeM/QRrlyul2O8UNHGOkRf1yeKPULeiVoQhxX8KPLj83x/HK355l5aSrCQVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050217; c=relaxed/simple;
	bh=xZeSacpFvuoxtACYfDAMbNx6dn6Xo2hSDFgMYcvRIe8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=k0ZBlQzT41JC5j8qscyNEbnZ9lBE+Dg4m7qXKKb5s/pd+LfLOdnOYUXDNqK0raGkUs2dTUNVjMfDj5V+RI5p6V3EhtJFpwSjkzaB6GTr9w3FdwVgr9XlLMX/o56ZkpDnoQdAH+ylHaF318P9ohCrCGc0ioX8JzyXa4FrcwS7YtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRa7JBbv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRa7JBbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A911F0089D;
	Sat,  3 Oct 2026 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050216;
	bh=xZeSacpFvuoxtACYfDAMbNx6dn6Xo2hSDFgMYcvRIe8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hRa7JBbvzW2K9kmHBHvislYSaomh9ADFd1watbyWUpE7lAu5ESpTTDucBS91OpuWi
	 gUCmhfSTG2Qo7QyuxzOzaMQFzM7b/wXx5oS13O3gUFzktcnljaihkaNAy9MGJ2+P7J
	 wY+xMFPeq5MTHgdBFrNOHxP3J9MpUgl7cgpy5jYtyyG3iokmaR+sHbSLoehTUEnplj
	 Mw0hrAOUCKSBa4wwRZ7krg/R/caun59mFaCSCzH0u1VBHv38N7BtFiVUvCEzB+14i5
	 gtAY8kuAc3GoL2jtl+lN3R8QzhP8cxIBGEarvV1W5wdjrfXpXm4HhB6REdsot0vadp
	 r+DFXVmc809PA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 24/38] mm/vma: enforce that mm-managed mappings may
 not set VMA_IO_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-s390@vger.kernel.org, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-24-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-24-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:54 +0000
Message-Id: <20261003175655.52A911F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
>=20
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as not being mm-managed. The check WARNs and
> fails the mmap for any out-of-tree driver that still sets VMA_IO_BIT
> without a kernel mapping.
>=20
> No functional change intended for in-tree code.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D24

