Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A694451981;
	Mon, 14 Sep 2026 22:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789423746; cv=none; b=dSVyy6X8j4wg0KGDGfLGq/jsiqPHs9qv4WfXta6QkCC9D+T8kbsGRRmProNuD05ndo996xsVaPSLFsmpB47tQTiH89jXertYclf6MhnPJe5ei8UCi6PC9CrnTHBWxbbzTb9UgyN1i2Zt8Wh9NWtjBjlgcdrxA0XU/gEIMA27lH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789423746; c=relaxed/simple;
	bh=wmrbbXUbTwIS8+vtF4g6brqrLOVn41/DFfBZFXEVcWU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aQAOyVYaotRfpSTkEPIutqZqpVybkRSuGjt07Zwnk9UTu1u6B9d5eJNP2xR0+sHuI5AIaXNRp3RMeXweqFzDsVSNw0sWnZh3ajmJbFC0BGdWglNWbHY0igrDaro7cjqWPib0wsWCB3dYnBtVn9nTTQocILDHuHeivb3z3JIL9n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yq/XoPYm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yq/XoPYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49DF1F000FF;
	Mon, 14 Sep 2026 22:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789423744;
	bh=wmrbbXUbTwIS8+vtF4g6brqrLOVn41/DFfBZFXEVcWU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yq/XoPYmTucKxhBE8Ye8ynWH6wph+RH85HwtW+8/IPMzP6N8x6quAxYXuaIFgpfIh
	 vEjayndAOpzLaJOR+c/3YwsYfCrGophglw9WkQCRi6OIIiSEhuTAVedUTLKX6G9xv8
	 cmzOOCQEibRxc/+QTuijYM+AjM1MvMSjSdsq82Syt6b0XvgD4fZKAzP6LmaXXufhjF
	 xykXbSkdqnzMKNZlh0i+9up62cSLT4dCI1VpSCf1uCU6sT44o9Vc6D7P77tFQ1GmNt
	 F+qH8bWjZChi/B+GFarON64H3T1miWS9+VaE/kUpIS8x3WWvbTW5Bfr+VgDLkFrMyl
	 9jVX/nneF6IKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 27/40] mm: remove hugetlb_inline.h
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-27-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-27-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:09:03 +0000
Message-Id: <20260914220903.D49DF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> This header really makes little sense - every place it is included mm.h is
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.
>=20
> It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
> VMA_HUGETLB_BIT is unconditionally available, and will never be set if
> hugetlb is not enabled.
>=20
> Simply remove the header, eliminate the odd ifdeffery and place the
> predicates in mm.h.
>=20
> The naming of these predicates is odd, but to keep changes separate, we
> will address this in a separate patch.
>=20
> The file was never put into MAINTAINERS so there's no change required
> there.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D27

