Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD53516153;
	Fri,  9 Oct 2026 18:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571230; cv=none; b=OQZtvfdtM6cxhgYbJSapBdWmbET109GjD0EdcMqAq3MiUu4JKwyTVqs9YTCG1bW296wcAsyy+Elb0R6Dd5pXssv55CnYHRS5WrpwZbHKjOshzBSjBsVqO5mreRwzD6+gm0zi8tUP0RRlVUfm+DQFGp5uXRKiLWPvAfxCIZWWncg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571230; c=relaxed/simple;
	bh=U27k8sTfi+MHXeRUlWtLWw96IcybaMLRrGiJ4U+m5kA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=N2eA7mbEWRETTAN1ewpezDIpmO7ST0c1EbEgYtnVMntY/X+HeAGWeCyAx127/hn7IGvWFF79viSChFzRSrt/8e9Irb2HZ7RfENoeT4vdd17yM9ITmehu8dPt0I24HjE14I9tKe1rwq6b4PRa+vvLsBFTGDPdu5aIxXAb1fCLBfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBeBICam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBeBICam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2331F000FF;
	Fri,  9 Oct 2026 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571220;
	bh=U27k8sTfi+MHXeRUlWtLWw96IcybaMLRrGiJ4U+m5kA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lBeBICamTmNtr6V3chNxzXHmj/oSPxBK7MWKA4eSg4lEhCRI5itetpP42AMR/u+Jf
	 a6ywcWRoAEbsIYoDoTMo1ocQl5iHn8RjmXSjwjGAGCOFW3/rb5R2mJMlhC+yUTjO5b
	 Gyw9E1SQOI6WMYUHs5LObkDZsNwAax8kbaHbQGKsz16hslIkkxVm8Gk1YqDJwWJKAX
	 yu2gyT2neJ0FRAnrZJdcYdNne8r0Z17NOazRQXmBO9eHoIT60HezCrmtzEyCiQA0B+
	 xensWe9c1YcWxUDO/tNb/K0t4Z8KuEa3cmJKoLpaNNDW31xZVPnPMhnCqYusFUJZB5
	 gMMmaGoKpBZpQ==
Message-ID: <sashiko-outbox-165960@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 27/38] mm: rename is_vm_hugetlb_page() to
 vma_is_hugetlb()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, linux-scsi@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>, linux-s390@vger.kernel.org, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-27-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-27-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:40:19 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> The is_vm_hugetlb_page() predicate is badly named - the mapping can span
> more than a page and it is inconsistent with other VMA predicates that
> typically are prefixed by vma_.
>=20
> Rename to vma_is_hugetlb() for consistency, and while we're here update
> some VM_BUG_ON_VMA() to VM_WARN_ON_ONCE_VMA() as to avoid unnecessary
> oopses.
>=20
> No functional change intended.
>=20
> Acked-by: Marc Zyngier <maz@kernel.org>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Anup Patel <anup@brainfault.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D27

