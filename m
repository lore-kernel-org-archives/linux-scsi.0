Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952C83CF21F;
	Thu, 23 Jul 2026 19:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784834131; cv=none; b=PJA6Ro23q56eyLIalDsCHiR7Mav2sTp4+JaDPMj/zpbw2kF0EHdRvKEwxxcgUGKzhvqTU4aYTu5aXrN9pSRbGEqsZQjjGjWjC5fPYs945SdMsUZViBXRIe/i7LQEDJDNeRjfS+QaSRgqxXijwPIYbqh7vNEuFj3pC04MgwRazV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784834131; c=relaxed/simple;
	bh=5fwAC923aVadsCLa7mLwCQXnqI6anFzdQdANQnENIkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DFyvOBA5GO0bGLzh7zc3APkWvU6B3uIz4iMgwoiTeLq7wcU1s7JpfWYC2r3uxZ47nTgDHE5ImKqfDGFghCoW9AiUZd9zMXhnVxUfd1t25mB9B0qdV0D12C7af5SuGmoGUy9ubIVHuVnKY75o3Z6puHLmnT87237LKfWrVxRUqRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IGTZ9gP2; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IGTZ9gP2"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h5gn3624Vzlfq9R;
	Thu, 23 Jul 2026 19:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784834116; x=1787426117; bh=5fwAC923aVadsCLa7mLwCQXn
	qI6anFzdQdANQnENIkc=; b=IGTZ9gP26Fa15YE2F9v3HnUnzzspL6evTpWmfMMf
	ZM+BKtYbTK+2UthgdOqpYtrnx3PD7Hve5ZtLGWMLOumBuPANMW6m1ubsc80kQMtW
	1DnIGRnjlxO8HmsX265N8o02V8CFsTHWQqweMPwpJvFCmv6/oKizNiJhktkpOkOb
	qmaGMq3Z3dF10DuZoJsSYChnByFZ8g4OZoTtcP6giiksqxIRPNVey7F8VrY18Ccx
	+BUteDKYRvPzm6GZZFZnT2Zzs2uTl6MswcdOLHr71Jj/p25Gputve/bNw6oLATDY
	+XxmXoedwkNUFPxLni8AY50Gd1IJZ/u1h6xZBWhax/Ey8A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yS7F9pibC341; Thu, 23 Jul 2026 19:15:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h5gmx4JHZzlfvqQ;
	Thu, 23 Jul 2026 19:15:13 +0000 (UTC)
Message-ID: <6a4937bf-61ed-471a-8a9b-fd8b0d79f7e7@acm.org>
Date: Thu, 23 Jul 2026 12:15:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
 alim.akhtar@samsung.com, avri.altman@sandisk.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 Shawn Guo <shengchao.guo@oss.qualcomm.com>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 5:47 AM, Manivannan Sadhasivam wrote:
> This reverts commit 85b2b966285498e1b551ac85f02c79cd06c0cff0.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

