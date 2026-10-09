Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3444B4F7CC9;
	Fri,  9 Oct 2026 18:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570009; cv=none; b=QFGq2MLe9g2deVKJ7ET99QjLqBr1spjPp8rpv8KN3SkNJJT+CnC8p8lMORmOcEZhZsXFR+40VLzINrC00i1oXdn0gq/XtxL6XdpcID1UMFr+g6gN5x0WSA95IuWL4/etx6GjGa36r2JeiFYn8TUWyAuH0JQq3fnEoisGL5oJQlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570009; c=relaxed/simple;
	bh=hy6VoHD/xxCyEbgEenGZTvb7QqyFW+hzodVzmqy6agU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ho8FTo4NT48JR9iNKOJoHMHVufLRNqxVVELZuub5xUZ6htKaPEeBlXjrMEJyMSLBjjHQdLFFXACOUjt9YzXSxIg+tj0N8CvAODSt5YzNUuGkTKwfs3ALgUhcg/IvTT1MMMnRUbzhR5ErHPvIUuhFOrYz1fh9L/ICmb2679m4w10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PIYNx48e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PIYNx48e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE131F00893;
	Fri,  9 Oct 2026 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570007;
	bh=hy6VoHD/xxCyEbgEenGZTvb7QqyFW+hzodVzmqy6agU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PIYNx48eb4jbNVRv7eSqRw/45SsIUqup+HlG+h2PkZTLbita6JqOzVS55303xXcdW
	 /7ozqfENX10yWKwfU7SzKbJuPjzNG/0k5tT5BhynNJS+IPnXBSH7ZK5BDhqpNMjZho
	 pjRZUz9BKQiqSSiV0ejg1LnhQufHVDGLu8FVKGdZw0qWxn7snJncuEWgo6eva2Phy1
	 BzW7cXy1JPjxqwvuHAqz0OPu8M69tno7wdR4NfX8H1i66S3UdTmn9IrpG3tx/gw7P1
	 1S+qkvYzKiRFEXjoOR5eOyJyeZVfjiIejnugFYFHEXqPfJRskaJjAW6P1Mh+KKyeJf
	 khLx21ldj+/zg==
Message-ID: <sashiko-outbox-165932@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/38] mm: make map_kernel_pages_[prepare,complete]
 internal and unexported
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-5-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-5-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:20:06 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> There's no reason to export the symbols for these functions which are only
> called from internal mm logic, additionally there's no reason for them to
> be declared in mm.h.
>=20
> This patch therefore removes the exports and moves the declarations to
> mm/internal.h.
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
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D5

