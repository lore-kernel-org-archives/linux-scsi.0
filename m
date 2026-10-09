Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1CB4F4740;
	Fri,  9 Oct 2026 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570413; cv=none; b=Z4oDmK61VMxZ/Mdb8wzZS3tsTrADPMZtGZTPlzK2ovUdxWf/yedxj2I7yz1Mz7vtPbQLXwuR3DvO7IFt+16wUDhPCvkrhR6ra+axekyVA/wlz6HkU7wVEABdgPQnCoIfN5wiEIXZvyshXyoNMRBoApkzcm7BDfeI1SuelJvFNJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570413; c=relaxed/simple;
	bh=hCYG4mb6Y3+WHTuTX+96FEwLU/wi/dMPvdqqRXrtajA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=i+zz6k1Z3+9kBVib7Ht2CCnjoCJndcuMaaF8uCoCfvjnLhUNyzwxq9bt5zxQ809EmL/F+KpghjUeUMX+pSQBtpntSFwwEngVZLSW+th3AuhYSBsKEDtqyNRUi0QqyyMGH9rXFXIViT4oi9GDlOORZ82U2fzoLn4aqzPXb8tSBOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAQlCbpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAQlCbpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4421F000FF;
	Fri,  9 Oct 2026 18:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570411;
	bh=hCYG4mb6Y3+WHTuTX+96FEwLU/wi/dMPvdqqRXrtajA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eAQlCbpAS96MLx70Tc9gifLpJ5iahGMxgYJh0/bJ0pS63IADsDEnPq08vLVgceN7Q
	 o9yN87ptROgczUv2QkI5s4xXnMLel6q3WkGRlF4nOflAQvE1YxUzixs5Y657eC53km
	 Tg/sapcML71/94YFP3oYNnbU8cuCD0rflyPoxGcNdbcN9QJWYNTl7kVG4gvkHdIOJ3
	 QV8tfjm2kH/Id98OADQPdImQSdpjAKFj20c6ppcmWjlHynqdK00ix1ERAu6MeyZPLU
	 V9vAG6OOJoBUd/iq6r3SOLKCZbD+E1zb+9b1gCvKqRwVANvSJqF1yo1nlZscL2V70A
	 58qv+8XpuYRiw==
Message-ID: <sashiko-outbox-165944@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 11/38] selinux: reject writable opens of policy file,
 drop mmap shared/write check
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-11-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-11-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:26:50 +0000
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
> Acked-by: Paul Moore <paul@paul-moore.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D11

