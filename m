Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D224E5218A2;
	Thu, 17 Sep 2026 17:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665905; cv=none; b=Xxohswwh1BOvWDTFuThDGcXQZh4IYfbRy3jvVLzd8J9iSEpe9vwrQTLvtp7ZCL5foVoLYVrssmYLVlX/z8X/FdZCWHagfgAle0fHihPUWl8XeeIykfAxjLc5DEIQQL2eQAuzBI6pR7WwkPabVLrlhECawzb7z9wpumpA3CHN6DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665905; c=relaxed/simple;
	bh=AurwT6A5xm0dKU9pNkiiFmaxKIywM3FD3DUjlKxgr2M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EwaIf7hNgCwonvY9W2dmVEiao0vby90KH8596/4r10VzQUgNbYAokCNZZOkrwpGmZZRpw5LI9EZvdpRc0NaTEf2Zd+OuPIOWyU0+hszY9y4lIgPsmvK9Gk0aGuV9zMPgl4WhTm0xQBAUyCEHWAyysUxB5QJHYYowE3vE10oBnmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joI7Th56; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joI7Th56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B981F00893;
	Thu, 17 Sep 2026 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789665903;
	bh=AurwT6A5xm0dKU9pNkiiFmaxKIywM3FD3DUjlKxgr2M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=joI7Th56uu5orRQmPqqaVfCsA0b6ZZEixJtMRj+Op+HIe4OA+n7+/ERPUNZKEGEb3
	 JrG1GFXlvIwZyaJcSwEzPh3wzFRQMdi7Y4twnKQ0oPbpZnSuGm03q4rnO+jXIjTbTK
	 kPGDNTadyX/YUO/h3045sUG140w/YCqK0eh3NB7ZCbTJL1CPMNy0NRxk/M2cokG7De
	 qmeA1vofGQtMt064p4lXmkwkbnXINxqWS3d/6556gvXWKP9yY/Y1sm82fJfhe8W++4
	 gohoe1tUWFGwY23mKmdeG3FokhNfvqel4qVJ/q2ZyZ85BVTwewoxteHoj3K+juzuSS
	 yTW2eIjdwRr/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/40] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-14-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-14-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:25:02 +0000
Message-Id: <20260917172502.93B981F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The bpf_map->ops->map_mmap callback invoked by bpf_map_mmap() can be set =
to
> one of ringbuf_map_mmap_kern(), ringbuf_map_mmap_user(), array_map_mmap()
> or arena_map_mmap().
>=20
> It is convention in mm to mark mappings whose pages the kernel manages
> itself with VM_MIXEDMAP, so the core mm knows not to treat them as ordina=
ry
> page cache or anonymous memory.
>=20
> The map_mmap callbacks ringbuf_map_mmap_kern() and ringbuf_map_mmap_user()
> use remap_vmalloc_range(), which ultimately invokes vm_insert_page() and =
so
> marks the ranges VM_MIXEDMAP, and array_map_mmap() sets VM_MIXEDMAP
> explicitly.
>=20
> However, the exception to this is arena_map_mmap(), which doesn't set the
> flag.
>=20
> This patch corrects this and updates the comment to reflect it.
>=20
> The pages are refcounted and vm_normal_page() finds them regardless of the
> flag, and VM_DONTEXPAND remains set (marking the memory as VM_SPECIAL and
> thus unmergeable). The one effect is that NUMA balancing now skips these
> VMAs, as it already does for the other bpf map mappings, which is the
> reason array_map_mmap() gives for setting the flag.
>=20
> The intent of this patch is to be able to establish the invariant that on=
ly
> PFN-mapped or mixed map ranges may clear the VM_MAYWRITE flag, as is done
> in bpf_map_mmap().
>=20
> Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D14

