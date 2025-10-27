Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB77D2D7DDA
	for <linux-scsi@vger.kernel.org>; Mon, 27 Oct 2025 21:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761601956; cv=none; b=lHn4UkHLWDivY6n9U5ntdSflt1WFMMPyS3BrvJlOAIhvdNxCS5qbC4eqUfv4YdpwrG6t3dCJghIh2VqzjAoh9nw61JmXaA1Wr1NoZBix5Hl5raWiqxoLJPOIoOP2MWY+NfTFT2F0e8SEy3r3Y+bTAMd0djMgi4Ytn4PXuG19KoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761601956; c=relaxed/simple;
	bh=yBGs8A7nKDxEp/ISey5KXq9Q4Aw54kdhhkREobKLJz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kzn5gCjMfKKOvPtx32mb/mgl7v4wUlzPLQFNEZahPRmTKXTS4Iz/FgN5qes/+2tzcbLLVlbzoj3MDNJpWx/cuZnhWAa9Z2g3RtVey4U74xH1vl2ZG38TQXCGCP6x0TOFblJD8dbHGl0AQDjSfyuBXeos4BjRu+1OuDrb4Ic+Rvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XrojugKy; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XrojugKy"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cwS0d5JjJzlvX7x;
	Mon, 27 Oct 2025 21:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761601952; x=1764193953; bh=yBGs8A7nKDxEp/ISey5KXq9Q
	4Aw54kdhhkREobKLJz0=; b=XrojugKyCIz7hZCylFTnRYiIZcHH+dYc/xJYHnlL
	DNxlbnP+dSb28fQvIAHY36GlUpaOMubW/tNwkU8338E1Y3Cgfr/uIUeG3VNyFR9S
	D+8DfC2IGfzy113Rnb84J7C+nra8Z7PktARollldYZ2tX9fNw5d6ZgPjl2v3jQXf
	f8Sjve64mXdtQImIasMwqyxSA7DSnFvyXvuNiWwooHE3I5QnDP9j187Xr/MrRdVg
	zs+nCmVwIXJvp+G+Ad0haa3lH8PXvV9GfIYFA4glEZ+ojXBcyeX/K9hqngbdmFpr
	YvvvN50QUxcbPpX8V+Z8+Zoq+FG6ysho+7rx6su7MrTaLA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i8qv3MPxql6g; Mon, 27 Oct 2025 21:52:32 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cwS0W30fzzlgqVf;
	Mon, 27 Oct 2025 21:52:26 +0000 (UTC)
Message-ID: <ff49b522-273b-464a-99cd-34fed378f4e6@acm.org>
Date: Mon, 27 Oct 2025 14:52:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/4] scsi: ufs: PM fixes Intel host controllers
To: Adrian Hunter <adrian.hunter@intel.com>,
 Martin K Petersen <martin.petersen@oracle.com>
Cc: James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 linux-scsi@vger.kernel.org
References: <20251024085918.31825-1-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251024085918.31825-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/25 1:59 AM, Adrian Hunter wrote:
> Here are fixes related to power management on Intel host controllers,
> primarily ones based on Intel Alder Lake.

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
