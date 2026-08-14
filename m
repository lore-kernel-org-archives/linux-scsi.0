Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A921A26A0A7
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 01:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786671970; cv=none; b=f5lisscPRzy2PhvkxUKgS7z6J0k4DNcpUZXl4xLQOPo348HvsmvWhxJamqI0sqcEeCLOlPRvG3j2DUYlQrUZyh6f/mYEeFzkQ7CJXNSW5c5O2f0lVq9bODjAUJh5Xy52vhkTIzGQKjFoXjd+nb5xpZ8M/X+ki7jVk6Cmip4cptw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786671970; c=relaxed/simple;
	bh=7lCO0WQCw1wLWGGHrB0TKJuTaioWj+nat+O7QOlo40c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=GhRRZNo1BwzqAUvWrmysyXt1odufNl3YJjxdBJ5ifzfplg+3PeRzfxQGJBYVgbj6cdBZmy3+Ju7LK11HCOdGAs++KL+kjL48r/+KBnGfwEr1syheeL6NKbGc28v/wZul3zFa94VqJtUmy/eoAwf0AoRhQqPs7FGMIndUXBVK4aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jT6kpq7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jT6kpq7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD051F000E9;
	Fri, 14 Aug 2026 01:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786671969;
	bh=suShF0QecovOF18gIBuzRTaFjj7APO8Mi2i/YLrfKuc=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=jT6kpq7dV02MxlNGmtxTuSLK3buQHElBg4m9KdG0veUczabtMOcF73CL2RUemZkPG
	 VunOlS3tTbMlBbMxciL7Q0d3X8veNsggUmkNo5hp/C9r6ZucdhJv3TVIzSdFuQ/p92
	 BQDQ6gXU5MaAa4xz1qR5wSSc02ZmCIWrWszrmuszZMi3a8zpYWvGE82jk9KuP9pVi7
	 aVwDo9dLQCwKXO8GRyS5T1DdglsPg+YYtqw4xl+vEaZ4Pvvx/EhVWWVmZQLPMaVkqp
	 lMtAgHsRAEqlr4DYe/lWmeqtBaa5vK/zsbhgJH0vpFrqVSa7UN9+wYb9ILok/iN7ji
	 kL0oYuez5b9jg==
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org,  Sathya Prakash
 <sathya.prakash@broadcom.com>,  Ranjan Kumar <ranjan.kumar@broadcom.com>,
  Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: mpt3sas: Avoid freeing unallocated PCIe SGL buffers
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260808151010.185603-1-chandrakanth.patil@broadcom.com>
	(Chandrakanth Patil's message of "Sat, 8 Aug 2026 20:40:10 +0530")
Message-ID: <yq1qzk1tqxz.fsf@mail.kernel.org>
References: <20260808151010.185603-1-chandrakanth.patil@broadcom.com>
Date: Thu, 13 Aug 2026 21:46:08 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Chandrakanth,

> _base_release_memory_pools() unconditionally frees every
> ioc->pcie_sg_lookup[] entry, including ones the setup loop never
> allocated after a partial failure, causing a "bad dma" warning on
> debug kernels or a NULL pointer dereference otherwise.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
