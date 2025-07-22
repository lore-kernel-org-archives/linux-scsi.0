Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE7261594
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753197669; cv=none; b=PkCycDouJDjBBRYs/bYqcVKE/N8ZPYcGGAwD2ff7IVijEBfjZ7i+SyYUnko2B29JCFQNs/SMGjSBasqFzxfNs5CkyVYmE+b6NqJAZfVqnd1pztBTyrgS2Fc85lmH3JCFJKpH6qiFECGCenBACkqVz2HXikM27NWWpaBx+htQjDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753197669; c=relaxed/simple;
	bh=CWPYowACzSmZkACvrxxXdCIydoW5w/5NyqbsrdSEgn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CoXeNK0ZW/3+2oLIahPnRq/1pg8ZPjiOVflhbwGjnTYH9nCPsSsTSB+7UKZV8/S+zsisQeie7F6ftouEQrMt+r6poka5qH9zoM0bVccCgIi673cHvJYnQjudF8midC/nEeWmNYQxpeJmrie5nHnfjyGPdrxoXGzx9bbxAPzIlgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yGIi+zqO; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yGIi+zqO"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bmgvd1Lb7zm0yQX;
	Tue, 22 Jul 2025 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753197659; x=1755789660; bh=CWPYowACzSmZkACvrxxXdCIy
	doW5w/5NyqbsrdSEgn4=; b=yGIi+zqO30Y1fVDRjrdxtK2ezRlbV6nv6MePZVnM
	Sf4/iATkhNQidxM/Q94c0RLhgE9esrUwLmU8coDElGmHgFewaGi1UTIJNkhAnJXK
	lT9Wpp620oSrUlAjlk0Ydru/GFLFiIL55jCG7uHG7wSciOy0U6h1bb7D8J35EqZ6
	qRKqxRK29lHSK7vL5HGzcUVuhhX8Xrzh/BfD4CQUZBe1XsZkoreWcZbJrMrBglJk
	Py/ew4nJ3ssGuLeXQ9Dr+SB6IVnAUZSePJTL9jGDtG4yp4K2bAThwR29iWQ82fpW
	BJFlo6nBe3nCNbzsFFqaMiOI3ui+BWv+AJbGGuJ/b9BsXA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AU12FYhuhHi6; Tue, 22 Jul 2025 15:20:59 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bmgvV69n2zm1HbT;
	Tue, 22 Jul 2025 15:20:53 +0000 (UTC)
Message-ID: <344068d1-118f-4ad3-8c99-95ad3258a4ef@acm.org>
Date: Tue, 22 Jul 2025 08:20:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: ufs: ufs-pci: Fix hibernate state transition
 for Intel MTL-like host controllers
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@sandisk.com>,
 Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
References: <20250703064322.46679-1-adrian.hunter@intel.com>
 <20250703064322.46679-2-adrian.hunter@intel.com>
 <4e28a401-6316-429f-b6b7-d682280190f1@acm.org>
 <cefcc0cc-f7d0-4286-a2cb-c9d5b339d6a2@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cefcc0cc-f7d0-4286-a2cb-c9d5b339d6a2@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 2:27 AM, Adrian Hunter wrote:
> I would suggest sticking with the current patch for stable, and
> considering improving UFS code going forward, for example setting
> and clearing the interrupt as needed, instead of leaving it set
> always: [ ... ]

Although the patch below looks good to me, another possibility is to
add an argument to __ufshcd_send_uic_cmd() that indicates whether or
not the UIC command completion interrupt should be enabled.

Thanks,

Bart.
