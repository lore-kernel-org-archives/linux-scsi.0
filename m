Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611993A0B05;
	Fri, 18 Sep 2026 22:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789769759; cv=none; b=hkKx23NDuwOYucPtgUokIIrmKZh7df5aITnHGHRvOVB9eOJ8gXDK/ugqmA2g9V0s3+cbZjH09mxJ9zktePXxbM8qOfvYWaa3DIVTetj/bzIhfPQ7Gey4h6hYp+dhCgiKbLFpqQ1GsvoqsQI35XEaEhxTKtDU/hYBsy1w/Do7IPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789769759; c=relaxed/simple;
	bh=5foki/XYV189Kf7qz7dkHG9w6iFh6xmsCVzGsuKjtzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ApUnEf7szXdKmY5U0y9q8llIUhtZi4Zq7QOpY42KV0QfReQIrezl5qJTkbf6AH+CDPkYJYzkdHHlTGAPXaOWRm9bpqEmdKY2oykYfPrLjSnL9cvSnjVNZdRX7cjBAEhPuZbqj1bFvwDGruv0lqrju+iomK9ZzH+fahOrsYAKGLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lFfwN+8y; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lFfwN+8y"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hmn543Cm9z1XM30j;
	Fri, 18 Sep 2026 22:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789769746; x=1792361747; bh=iiWcXe29gr+gY3eSpaSJyKwx
	I4pdmiQMt1dYNcHZqmw=; b=lFfwN+8yP8PxueuXKWqEhWpPqle/MxbZrXPnA53x
	1yEPje6ydoF8FXls151BZ2RJTI+Sz13XBkTazCoZ40Lp8+OJVySqDI5a4NNrWT2X
	IeijnUU6o5DLkSiZr5rHFGkJfcIWgoylFHsQVvM8V7diU1Ynn++M8TcVNbj/UChZ
	PwChVByMrNn6OQFGjG6cWM58zXRPhIkvnwhtZyoR5yETi9CH8DLs5FCUUayzIOi8
	T5U9dfIAME8GQF5rh0Qluitw555gxXt5pxTgP+h39JwPCcVMFxcvQ/dcyUhaNH7T
	VINOuNzZmFnI4tF+CJlyWkpAEGHBzsMN4SM1lbivkWnK3g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id I2N7AOeBEDtD; Fri, 18 Sep 2026 22:15:46 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:9130:c9d9:dd94:6232] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hmn4v5LlYz1XM5kD;
	Fri, 18 Sep 2026 22:15:43 +0000 (UTC)
Message-ID: <eacb6c2a-9219-4e9b-8726-8d38b641f543@acm.org>
Date: Fri, 18 Sep 2026 15:15:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Avoid unsafe MMIO reads in
 ufshcd_mcq_compl_all_cqes_lock()
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K . Petersen"
 <mkp@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>,
 quic_cang@quicinc.com, quic_nguyenb@quicinc.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 5:23 AM, Stanley Jhu wrote:
> Reading host controller registers (such as CQTP) is unsafe when the
> host controller is disabled (HCE = 0), as accessing registers in an
> unclocked or reset state can cause bus stalls and system hangs.
> 
> In ufshcd_mcq_compl_all_cqes_lock(), all completion queue entries have
> already been inspected, processed, and cleared in memory, so the
> software queue is logically empty.
> 
> Avoid the unsafe MMIO read of CQTP by synchronizing hwq->cq_tail_slot
> directly to hwq->cq_head_slot in software. Upon subsequent controller
> re-initialization, ufshcd_mcq_make_queues_operational() will
> reconfigure and re-zero all queue pointers.
ufshcd_mcq_compl_all_cqes_lock() is only used to forcibly complete UFS
commands. The UFS driver should not forcibly complete UFS commands from
inside its error handler. Please remove the
ufshcd_mcq_compl_all_cqes_lock() function.

Thanks,

Bart.
