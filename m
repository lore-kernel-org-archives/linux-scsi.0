Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 372851AC435
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 21:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730757160; cv=none; b=JAkTWCRvtup5Q+LCv9O4MMSKKgiICLpVEAABV++DJC2BA/NzIsngZDdRsPSM3ikDf2s2HzHBZmMbpPBY/2LfNN82HjR+dX2ByQtte9qzWODAGGLhp7Fvi3eZtf7uTuDqfXo5fVc7gQaXFRET1bal0hLGmuNfcwHm3kJqMH9mY98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730757160; c=relaxed/simple;
	bh=UR8a8rnFFRw8Ahu3TY2udljYZ8j28mKduj6qZ/U7hRw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jt1/SxFKcIq/NTMDqjlOPHiwa4QQ9JBI41M0BIikZR9mZtCJ7MtYACNMAgnh84y9JYtePORobLHQpKWxOTSWM9l/OfISJk4yrBUL7uXBsAcXUBHefMntmM3ooNX07fHZzvLMCNU8Rdz1k6wd69x6zWWp2v1xpJF5Y6U7HAqbDws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id A469492009C; Mon,  4 Nov 2024 22:52:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id A0DD792009B;
	Mon,  4 Nov 2024 21:52:36 +0000 (GMT)
Date: Mon, 4 Nov 2024 21:52:36 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Magnus Lindholm <linmag7@gmail.com>
cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, 
    martin.petersen@oracle.com
Subject: Re: [PATCH v3] scsi: qla1280.c 
In-Reply-To: <20241104204845.1785-1-linmag7@gmail.com>
Message-ID: <alpine.DEB.2.21.2411042134240.9262@angie.orcam.me.uk>
References: <20241104204845.1785-1-linmag7@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 4 Nov 2024, Magnus Lindholm wrote:

>  Use dma_get_required_mask() to determine an acceptable DMA_BIT_MASK 
>  since on some platforms, qla1040 cards do not work with a 64-bit
>  mask. For example, on alpha systems with more than 2GB ram a 64-bit DMA mask
>  will result in filesystem corruption, but a 64-bit mask is required on
>  IP30/MIPS.

 This is missing the point, you get filesystem corruption because *your 
card* does not support 64-bit DMA addressing and not because your Alpha 
system has an issue with it.

  Maciej
