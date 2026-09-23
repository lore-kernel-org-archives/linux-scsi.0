Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F167D30D3E0
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 02:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129519; cv=none; b=R9Sjq0ewGjyV5FjKZM3BXElXlAvljAUvQ0iU3LasFXjZ7DU9izEiH0y7TNakJ6p1rDiiuyEAJCA4I3QfAgE23K0wIhkPPscv+113IJ6NzPIvPIGC4nkHvwnHeYFuSlmhBrjiZNr8YfZC4mfLP5Xl9yFTpv+HYxaXS1E+IUDBgZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129519; c=relaxed/simple;
	bh=wp4FljpgqztwSYMqcv6kDgqvb2x1qW0liW7VlKlVq7c=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=kbjHbO8wIS12LefkAmTQjffYKlUwyc6uTQk6in1LKYaSgFjEr6Id0r7MCKjFTIi4BUM+AaDTZbgONRyzeoXsFU/IUthH2o85hUJiRdNCGvSd2cE0isulYtf6tSldAhOYjPnCqjOYEv+/hXg6fjqvWKomSjF3HtD+mGGgGmHRHQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSNBegek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSNBegek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5791F000FF;
	Wed, 23 Sep 2026 02:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790129518;
	bh=ILMRcNKpaVNfcahfstMqa8t7vxrKhqHujRbUVG1vfdA=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=lSNBegekQ+a85VwClrgoCgQzF04Ss3rqNd66Q3T2CyWqrDSQoRP5RRzboIV5Q4jFx
	 KpalH5Eo1VGltYaubinWFa0clEOImFk2m0f0h0WPAC+PFrCwOiSUHWtYeUP07V4AOn
	 d0vta/iA6n1zlRUpcK3nTjogx31oyd43htRh4B7FUdWln5gkinov+u2XCV2QXkn5N8
	 5/o9NmhmigFvLrW6PArqZIXCt22uv2kif8TIiUFK5Z0TcfGwZUPxN+HFXb7Bv2pEfv
	 mNxLR+NH/DP6MxntlGX+BMi/B0ZiyiR9rSVwipPQjHTTpz39FDFG/HwyVH2egl5R8d
	 uQ95Jsk2P8Q4A==
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: fix additional sense code definition
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260918062959.2245533-1-dlemoal@kernel.org>
Message-ID: <yq15wzwsom5.fsf@mail.kernel.org>
References: <20260918062959.2245533-1-dlemoal@kernel.org>
Date: Tue, 22 Sep 2026 22:11:57 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Damien,

> The ASC() macro used to define an additional sense code with no
> additional sense code qualifier conflicts with the ASC macro
> definition of the file arch/sparc/include/asm/ns87303.h, leading to
> compilation errors. Avoid this conflict by renaming the macro as
> SCSI_ASC() and the ASC_DEF() macro to SCSI_ASC_DEF() to be consistant.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
