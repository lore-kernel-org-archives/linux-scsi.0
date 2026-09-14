Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7551B379C5C;
	Mon, 14 Sep 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789408632; cv=none; b=oellXi5bmzo0K0SLXVtUPCHWRUlp4PLUugBLEPE9t6lfiHII5sTXpHd6I645WSkwVPJ9HuTbc788h3uJViU2opJhVXv9WGnLbTq3/3KPF+UT00CGTmmLPZiY+apCNnVmZMKvDdLlburo2pHBSvpZ2X1lRSD0CCKNkly60aOLZoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789408632; c=relaxed/simple;
	bh=WHAxO356QeI65K8FMrnonWX56V/LH6e9elTcvnVoWlk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D4ELBkVesrcBqTZuYpEkOrpSyeijMpO0HndetAYm3xHLxE9yGI6ThX014yoTnCreRkSLsis5JR+WYzdD+Zu6oC/L7xhN3ND5gH4nI/K8aUcKHx3i5T3c79LL6rLLd2k9nYU7VHHpUb6P0athZ/SCTJyQpXoUh4cZYclMy0pz6yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKrMGe5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKrMGe5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AD51F000FF;
	Mon, 14 Sep 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789408631;
	bh=WHAxO356QeI65K8FMrnonWX56V/LH6e9elTcvnVoWlk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YKrMGe5ZrWmP2IYG3Jun3Vjv9FUR6gAckPZkcC30ml3mPYXnemCGJsVKf8Rj7xUCt
	 z4HCL01q2Sfc71umZWC9p2shEG3xynK6qLlUh6CKbWOG66pOX8aXmAUsU4vOBhiRZt
	 BIi0VKSvMtbAgUoX2/QIzysb9RwzR4VD8nK0XSfGxN1JGBW9VhUQhuBuXQbTuirMmI
	 8S4QA52ZZvArZd802IgOlbMjNd27ZilDOXu3ch4olD2riPGArhTDLQZyfeNpPPx/5q
	 NkDUJlXLMSo+Gfj4AIYvEquiv0K/WoBuM9/B5gUHhW3hLuDRvAWftvUI1ZCBf02mQD
	 G2o1wLs4yXxOg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/40] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, "Alexander Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, selinux@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-12-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 17:57:09 +0000
Message-Id: <20260914175710.39AD51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The policy file has no write method and is exposed read-only (S_IRUGO in
> selinux_files[]), yet sel_open_policy() performs no open mode check, so a
> CAP_DAC_OVERRIDE caller can open it O_RDWR. Reject FMODE_WRITE at open, as
> kernfs does.
>=20
> The file can then never be mapped with FMODE_WRITE, so do_mmap() always
> clears VM_MAYWRITE and VM_SHARED for MAP_SHARED mappings and the VM_SHARED
> check in sel_mmap_policy() cannot be reached. Remove it.
>=20
> This also stops sel_mmap_policy() clearing VM_MAYWRITE on a mapping that =
is
> neither a PFN map nor a mixed map, ahead of the core enforcing that only
> such mappings may do so.
>=20
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D12

