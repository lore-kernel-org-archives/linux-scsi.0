Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7CA4C150B;
	Fri, 25 Sep 2026 17:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790358270; cv=none; b=bIFtG7eYpQQ6uzyGBDTsm7Dz4wMsQT7XdpEMZbuLwiCoY5C135Wpm7r6CqcCGJ5bZmmBuHXDlLq26pmEgA5ouznU+1fzFiuR9DJTUySDgRNjdgtE27b0XiGUi63LkU1mvylPIOIF5fds3cfLtSICAWRIEH4FsStqEuNWvpmu/JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790358270; c=relaxed/simple;
	bh=3YcmZ1BT8br4riowCC9Yq9wm3zVRB4R66oU8gb5Ds2g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kf5lwlFb1lCjQDgd3xg0ysDOdcQYvUz46bh4239n9xxceK+fzw4NoI+LbhhMSp5/olBmoGm+dVL05gL3jobYqCY2diepGxmuEXNivhRl8mlQHFC1QKyC1DmBR3FmpFsHQ9kWKft8pXiic7EHYW26L9GjbjqkE5h0FhbRiNRg1BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Lpbqcf4u; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Lpbqcf4u"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hrykg5ZtPzlfvpK;
	Fri, 25 Sep 2026 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790358262; x=1792950263; bh=3YcmZ1BT8br4riowCC9Yq9wm
	3zVRB4R66oU8gb5Ds2g=; b=Lpbqcf4uDT6rgEcxqyjDAJ4E93CEtMds/20/8zPb
	wOBgKcsQ7B9kpiOqNmV3aI5G454x+JgxaeP9NIT66bhFjl9YXIi9+njMEJwbEMqX
	gPegw+rdh0vQnScvm5dYpgBJ+AqUjKforb+XyEnbRWD3vx0kTAq7HNMym1ceCSv/
	f6vmZeJOnfU3JowC7mwnqy27lgPwM7gU/1xq0gAJ0VWGCtfPASyvaN1IvN2NVgs1
	cNwMhO/zL7r/qZsx+BSStMd22aVg2KRiWK2fok77MTcZbXkmrM4EzaxZXjYxrcR9
	BcNlmOYRv5dlBe3bkKYE7LSNzq0qfA+eKtwwmdRYtia2wA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YS2P9XGf-JZS; Fri, 25 Sep 2026 17:44:22 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hrykW6r8XzlfvpG;
	Fri, 25 Sep 2026 17:44:19 +0000 (UTC)
Message-ID: <759c9980-9044-466a-96a2-25f83b3cf202@acm.org>
Date: Fri, 25 Sep 2026 10:44:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
To: Stanley Jhu <stanleyjhu@google.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Bean Huo <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <mani@kernel.org>, Peter Wang
 <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
 <20260918143809.3034592-3-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260918143809.3034592-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/26 7:38 AM, Stanley Jhu wrote:
> Sweep or poll each hardware queue (hba->uhq[i]) once at the start of
> ufshcd_mcq_compl_pending_transfer(). When force_compl is true, run
> blk_mq_tagset_busy_iter() afterward to complete residual in-flight
> requests with DID_REQUEUE, and remove the now-unused
> ufshcd_mcq_compl_one() callback.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
