Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5260D17559;
	Wed,  5 Jun 2024 17:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717607072; cv=none; b=qUoOH0UwABSd6IHHaBQnpP0tICMbqODiDy4jNH0nAwGgRqGxH8ixK9Rzh9N2fRYCsHoKtajWy6QusG8D4h6pCnVr0dATZODq8XlxV1Ew67qUney3EeQf2C1e/G7rWxLCdMuxWoAqmUpsHt2yLt/qRWtenNzagfszhBIvYLHIuaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717607072; c=relaxed/simple;
	bh=nhFWFsp+9ExjOIXbu0vBmHM9s9CAsaCAVQQ7E358h9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r2E5snRV8u7tRQ3KcR7YjCNoZVPB2C2FhMzIn8p324IQhJRNpv3UMrf7Fe8AbyZ63QQyz8mo+CRcG/0AHOWj3eASp2yMHZgvDXu2okkFZG4g2k9nKOYRnZ9GSg/b4UaQ82SjrAILDqYOgC3qBpoVjE5mvGsEshcYf7AmelzbJIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fa1YcfXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fa1YcfXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B7AC2BD11;
	Wed,  5 Jun 2024 17:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717607072;
	bh=nhFWFsp+9ExjOIXbu0vBmHM9s9CAsaCAVQQ7E358h9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fa1YcfXGmjcOXmffGBJge6qX26nr1zo/kXEqmVo1su2WdAIlSKFcpEiDDS2DDH2Fx
	 HpaQiGe7X51iLeB+wcUeUGyRuenIfOBL59LWtA6H+MaVPZyNyYdcIV3LphhusJWYzz
	 l1VnWcAL95uFrkuPXeK3r4PhzYPOERC8x2bcAoo1m5LLKKRqDpP2fHvHaldLPsrwtq
	 rgFQE7CGpMotRiVYDgSEGAgmhai9hhAUNSsg+WUE+1P/WYNaOpU4RmLWSX61ew/mJm
	 558DLmWiXztnaPcho+7DEHIHLR6trO3Yw80kOi8ZLgda3ENjPjgPdjyxxuCT6RMmQy
	 d+YcPETCnTAdg==
Date: Wed, 5 Jun 2024 11:04:28 -0600
From: Keith Busch <kbusch@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chaitra P B <chaitra.basappa@broadcom.com>, leit@meta.com,
	stable@vger.kernel.org,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <MPT-FusionLinux.pdl@broadcom.com>,
	"open list:LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)" <linux-scsi@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mpt3sas: Avoid test/set_bit() operating in
 non-allocated memory
Message-ID: <ZmCanHvLTo_RjZsA@kbusch-mbp.dhcp.thefacebook.com>
References: <20240605085530.499432-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605085530.499432-1-leitao@debian.org>

On Wed, Jun 05, 2024 at 01:55:29AM -0700, Breno Leitao wrote:
> There is a potential out-of-bounds access when using test_bit() on a
> single word. The test_bit() and set_bit() functions operate on long
> values, and when testing or setting a single word, they can exceed the
> word boundary. KASAN detects this issue and produces a dump:
> 
> 	 BUG: KASAN: slab-out-of-bounds in _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas
> 
> 	 Write of size 8 at addr ffff8881d26e3c60 by task kworker/u1536:2/2965
> 
> For full log, please look at [1].
> 
> Make the allocation at least the size of sizeof(unsigned long) so that
> set_bit() and test_bit() have sufficient room for read/write operations
> without overwriting unallocated memory.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
