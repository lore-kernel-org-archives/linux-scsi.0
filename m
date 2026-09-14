Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAF441228D;
	Mon, 14 Sep 2026 22:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424317; cv=none; b=fSNtcRMdfQ6p4nCO85oTwFdi7sMCjgtiuVFFfZfJsX7n4KKabjj72cVglX5aHOwtA8YiHPM/a+CD3rvjCx5omc7ktvKRbGIqoJVcbHvDnk17OaBLoiHMaNsdj2ti6rXM9J0FMcoeVm0nYYH/ZAgaSUseQ3nYKq1VMJIgLXK0Q5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424317; c=relaxed/simple;
	bh=+zEca/XAs29lC1ZfUNKoIoVzuS+RxeoqsW0hSIQYQS0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Z/71XJ90carfwTRXD6RdNcMmpx/tGyHkHA/ruwf7rRpBHeCCSHKi1jeWkHD7CUSreJEiez6qvcvYkN1sO/uinYQ2vcsPNE0sVmCuiRYrFIDnZ+U3hnJmaeCnLOS4zS1uBJs+VKNVAAKpC2uK+eF+U2s/actaY+l1N/LjLMN1DMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bggv7pdH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bggv7pdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790E71F000FF;
	Mon, 14 Sep 2026 22:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424316;
	bh=+zEca/XAs29lC1ZfUNKoIoVzuS+RxeoqsW0hSIQYQS0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bggv7pdHTu+0gwWWovqi9bVQa42ua4VkvGaqWAgeijsIbhOGlhYwge364zyx12gpe
	 h30x6dxI6tG+VhSJTgxAbOFXyBkYx7+fa7awRyAedX1KIENefWt99nZi2PWDlG0UW5
	 MqEuolBDlGdgcgBZnS38wfkMkQwL0qx9IqETKJvTz8Hc5OOInlJC7lvrmCqXHjiJ/l
	 AJM0sa61B94dd8ipNUFuQcPGn2C8x/VSTsk8pK2y7wtzlIvOsmM+S4mzMoaMZDD5XL
	 FVrtJsIxjwSr3iU1JLyeUcVKWCdfdVJIa59dqjtPbMIQ9Sp2YxFoeTeiwkxTHWMVuq
	 XDT/PG3aoszeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 25/40] mm/vma: enforce that only kernel-owned
 mappings may set VMA_IO_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, kvm@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-25-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-25-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:18:35 +0000
Message-Id: <20260914221835.790E71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It makes no sense for a mapping whose contents the kernel does not own to
> specify that the range is MMIO.
>=20
> Prior to this patch, all in-tree drivers which did so have been updated
> such that they are marked as kernel-owned. The check WARNs and fails the
> mmap for any out-of-tree driver that still sets VMA_IO_BIT without a kern=
el
> mapping.
>=20
> No functional change intended for in-tree code.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D25

