Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F1D258EC3
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2025 22:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765579942; cv=none; b=h07Z9iEj4cjb2lTEvZ5/9FcyXyPkwmjDVb4j0KqoZ1IbHRqqCIm4ijrwDLM8Gj4QOAXQKh0pbVnHPwtv78QZUguKAlWuImYGPn9t0/p4VbM/txHlEJk5FbURynFxKo/P7FRwD9HqQiCw6aVdmDfwZapgfApzK3uY79N/4tMUlW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765579942; c=relaxed/simple;
	bh=3AshKAkRhBAx/oPP5UqSu2r/+jGJ8uDGL+8Uyfwsv9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YI/rtxQCv2mkTNWLMVXunSmTSnm68NbOMKu1m/Zc18VtXPP5fH9kNWUUEtD2Jfp4NsZuKdrKsWlrKiahXsaDkcNsXdC7MPdvi9pRVmBpBjliN2facI9iHCeEOuC+ow0NZY/R14m3h+AXQv5NT1GqFD0O2LUaDVfgnUEyqQxYK/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=At8pXC5w; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="At8pXC5w"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dSl8D57m8zllCm5;
	Fri, 12 Dec 2025 22:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765579931; x=1768171932; bh=3AshKAkRhBAx/oPP5UqSu2r/
	+jGJ8uDGL+8Uyfwsv9U=; b=At8pXC5w8C29XOqW2rwxBojC6xsR4bvwUMyuSgW8
	T+Mf+o0iXqWqkPBuWEefP2hvEHj6fh2hFzxtmGottcR2a5pJ5xDa9UL+z1wNq6Pg
	XuE0lPy9Wgiv1HWTFMV5mrQ7hAJOZcP2so19MVE0AXt0vn34uorMCoJPt9aUQuQz
	6y1p9eQsYZl+4k31ePA+LUIfLo12L9dOFZNtBVStREKXvVpKK524ABUajmOslPPY
	uzOg5esgIhyfETnYjlIanhhKd28qeUAqNGyPO4A0QlEKE4R6G8cqQJKZjExz7mDe
	FhfuYY5xvimhFmJ+wzJuQg0gymvYswnCvuhEnDzfil3MDA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IzXn6IGdJzkQ; Fri, 12 Dec 2025 22:52:11 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dSl8B3j4Xzlfdds;
	Fri, 12 Dec 2025 22:52:10 +0000 (UTC)
Message-ID: <48e65a14-c56a-49c3-bff8-2d68eb23ffa2@acm.org>
Date: Fri, 12 Dec 2025 14:52:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Remove the alignment check in
 ufshcd_memory_alloc()
To: Shawn Lin <shawn.lin@rock-chips.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Bjorn Andersson <andersson@kernel.org>
Cc: linux-scsi@vger.kernel.org
References: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/25 6:08 PM, Shawn Lin wrote:
> The dmam_alloc_coherent() function guarantees page-aligned memory on
> successful allocation. The current alignment checks using WARN_ON() for
> buffers smaller than PAGE_SIZE are therefore redundant and can be safely
> removed to simplify the code.
(+Bjorn as author of commit 339aa1221872 ("scsi: ufs: core: Limit DMA
alignment check"))

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

