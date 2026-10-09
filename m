Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF76C396B70;
	Fri,  9 Oct 2026 18:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570655; cv=none; b=DxHFjM2fEvn+mIHPoQdk9EPPfnZP/MnjOKf8TnbP0RjTBPR1e1nWCzv09JXoOhqub2+A0gHScSWyLGroDzxuXBPObYPg/OvxT9xzUOYLWoqgAmBua5D81F6SZRqlh6SvntaQ7S2xbvJ6wBQyl7Edws8K+S34Me0SM9vAvy2XIjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570655; c=relaxed/simple;
	bh=ragqmZy1lTdfRRXyYL4oyabZhQWrFuqNRc66/eF209w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=bPK45pY5KaS/hV04i1CvbO8clGmwucISXhJ+yIOSCcgWcjpcTARWpVHQN9YJxkOEiZY0pZ8qse9/ArSwAsKPyI9pvIuqh8R/aE6utluctque8VbqskHDZZxZIpIgPyiD7kRJ8tyXzblrgrJRs0zQpUzi/A+1WnA1MmLirfopf6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f2/FWM0x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2/FWM0x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB331F000FF;
	Fri,  9 Oct 2026 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570650;
	bh=ragqmZy1lTdfRRXyYL4oyabZhQWrFuqNRc66/eF209w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f2/FWM0xQpYl/078U73bA1nv4M+lo+SUnBFC9mpDB/lgDQnRAJFifjNJ5X8zsV4QX
	 6MnZZCi1SIt/RuCJpZLDdbL/8E8mIGiLf2weDmHZ4m9KusO27AR5lNbsj5QGBOJBHu
	 ezRuaY04ZzA1Y3tU1pT8IWYSrPLSg359EfgGhNRqLXBkMaxhkuqnv1U0MZ6WcyF1+7
	 9jFGwxe7EWAOAAvCJen+IcX8MuX/m/AfRQjKshMQX8oW0applhb/e6fCNSMs4+a3Z4
	 3UEzk7ZodUCYb8w+yidhCppZFevfAMRf9ipuuL0QUdMsBrFdaaxc00KIr+iC7M5XJl
	 7KjdLrxaqae3Q==
Message-ID: <sashiko-outbox-165949@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 13/38] bpf: arena: mark arena_map_mmap() mappings
 VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, selinux@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, linux-usb@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-13-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:30:49 +0000
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
> itself with VM_MIXEDMAP, so core mm knows not to treat them as ordinary
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
> [ ... ]
> in bpf_map_mmap().
>=20
> Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D13

