Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A803C2356D9
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2025 15:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750952606; cv=none; b=jS5EkNoWdn0dCqFf/db++KjA+1rj7W79rrqSItoA6uyhY4idS4uUedhavHqgSr2CWtwYLNWRJfPKB97/Bq0dnHPwvrm5kkW8NbsGAiR7GYgnoGq54qiK5one9yQa9Ay8ArskaZgcUHTTeLEaW6gK1Mil4hOJouTevKQEGkWVp9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750952606; c=relaxed/simple;
	bh=QsD4VkaD6L24NN/c/4MA6LTdP4mmMb4KhERbTEzxuro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oODr6o0TFPzGrVCirzw4phWC7w51qI+VPtanhzhPlUwPdRd6Fyi0GXeQxzt+qyNYmFR7t8HiRXB8XtRjizImCIfcYZE3dvqjRSSOEwbKby9HPvoWSp8GL82pES1I9kO/AyQ2WlxzOIvKP7TDjMfvlGUvGiJrMGv99bNKKWQRrMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EUWNHOkX; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EUWNHOkX"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bSjdR595jzlstQr;
	Thu, 26 Jun 2025 15:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750952602; x=1753544603; bh=kGHbgwYYE7WtAO5ooHi/gEcC
	oZDu6BK3AYDRxE/O0ZE=; b=EUWNHOkX0wYHryrUv+XNa+oslzUwex8agFDuiEzy
	lzE95UJsiJudtQIpeGL5U7M7GltknvbVnWjhyOJsH5HgeHDA3GeUp4JyxNuIQgZc
	nFsxnWrTFnL0eehVoaZkq7AXbpaq1V5aFvZUOMkMO8Blg5GZQ4E+ABAqOHYo0Nmf
	HcZKWGP2ytpFZjjBKz3vMvuUEF78Q1Am0obfbakwSPeDl2YQAGwg8c0BmJE/Vb2a
	+xvyY52fQ9kccV9UPIhzoo/SLJhBO46HHAVtAGUnRchllhvqRw39bW29N4w1exGX
	2Pgm8rv2DaQl3rzdGXu4QZSq0aNGkja5MhcpYJWiOHuTyw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lz5VuxFlSb2K; Thu, 26 Jun 2025 15:43:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bSjdL0pmvzlv4Vq;
	Thu, 26 Jun 2025 15:43:16 +0000 (UTC)
Message-ID: <32665ed1-928e-4854-ae0d-444182cc2332@acm.org>
Date: Thu, 26 Jun 2025 08:43:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: core: Use scsi_cmd_priv() instead of
 open-coding it
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
 <20250624210541.512910-4-bvanassche@acm.org>
 <f5d1444d-fa71-4b4a-9c58-031f158df4a4@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f5d1444d-fa71-4b4a-9c58-031f158df4a4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/25 1:34 AM, John Garry wrote:
> Do you even need to preceding patch for this change? cmd is not a 
> pointer to const in this function AFAICS

Hi John,

This patch is unrelated to the previous patches. This patch series
includes the cleanup patches from a larger series. I'm splitting up
the larger series to make it easier to review the patches.

Thanks,

Bart.
