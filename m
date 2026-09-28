Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724183546FE;
	Mon, 28 Sep 2026 17:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617528; cv=none; b=LSw0vIhQgQ9QBK6OxJyKr/Ljf2qBU3d314DcEMe3uYij3KF28bodekhtysOzFRlq88w7AJo7QphoTVURyVG7zeqgJ2oOY3dFBpHr4qO86qcV6aEiFuea+tJp9PzheULTPhBJDiZypZNbNOga7KxQK6baJV50dUZMAPyAxnh+6us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617528; c=relaxed/simple;
	bh=i0vadijh8pdsj/NPWI7O6M2tP3r5fJxljbSxz7lK/OI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=amRfy2L7Kb4CmhgCguhR3dw4fv+pLoWR9vgm5lMMHFoNX3tZLaQIASml/PwkZkK66TAnx4G5xfioDazn9eLJ7cmq9FBaQ6cUx/vOsCodFm6YIP3pTmXWM+QOGBtrCkm0O49HJhDL5jCHcsJMo7yN9r9n1dR8zbSshWJ7Jb16+vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ReLEoOjK; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ReLEoOjK"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4htpcQ6Q9kz1XM4TB;
	Mon, 28 Sep 2026 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790617521; x=1793209522; bh=mjHAcCA2W+dDXMkITJ80ELgI
	nrM81TFTkqS/oMrtYVY=; b=ReLEoOjKlpmRLCJMPTsX/FlBYBJBB+5q6J7uv8+1
	thrYz7iJchL6oU1zlXgQNtqA4Y9xGXK2r4EClw2FI5aj19DXj0L0MfUruZM2kQQC
	xJmMpOgM1VvmXOdBYqhjf+KOIcdFwLxPPkGpEfr8EkwVzkDgyjFkJaxf5sVBY6dt
	AhYv7YoSc1PAvA3KR4nD9kmOi4s1l0oEOIEDyG2H6k0itF7wk7eQKfzV76m2dIkE
	exWDL3NPcegS/ihYCjLi28evQ1x9tFi7gZpyx4R98Memgawh1gmYJumIlK7BCbLo
	zZP0Ft8dWuAMC/bTcwKRfML/OMPjIO8804UYKyEguG9kyg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UyamknUSzgzv; Mon, 28 Sep 2026 17:45:21 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:334e:163d:7b65:8f42] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4htpcG3DSYz1XM4Sx;
	Mon, 28 Sep 2026 17:45:18 +0000 (UTC)
Message-ID: <3da87b3a-4260-4b6b-aae2-b741d524e665@acm.org>
Date: Mon, 28 Sep 2026 10:45:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: Avoid unsafe MMIO reads in
 ufshcd_mcq_compl_all_cqes_lock()
To: Stanley Jhu <stanleyjhu@google.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Bean Huo <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <mani@kernel.org>, Peter Wang
 <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260928035816.1294326-1-stanleyjhu@google.com>
 <20260928035816.1294326-2-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260928035816.1294326-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/27/26 8:58 PM, Stanley Jhu wrote:
> Fix both issues in ufshcd_mcq_compl_all_cqes_lock():
> - Remove the ufshcd_mcq_update_cq_tail_slot() call and the redundant
>    hwq->cq_head_slot = hwq->cq_tail_slot assignment without
>    replacement. The two indices are already equal after the sweep: they
>    are equal when the sweep starts, since ufshcd_mcq_poll_cqe_lock()
>    consumes entries until cq_head_slot reaches cq_tail_slot, and the
>    sweep advances cq_head_slot by exactly one full ring. Both indices
>    are also reinitialized before the queue is reused.
> - Extract ufshcd_mcq_compl_cqe() and invoke it only on non-empty slots
>    during full-ring sweeps, keeping "Abnormal CQ entry!" logging strictly
>    for unexpected empty entries in ufshcd_mcq_poll_cqe_lock().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
