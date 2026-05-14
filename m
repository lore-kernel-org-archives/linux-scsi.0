Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF3282F3A
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 16:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778775790; cv=none; b=DAQTEboatkm2x2nxozvNFN7J7BoSP6trfgcUblMwFE7G6LZuzyzCzxcz0OgOHtv7FtTgts7e+xQwIpTQk4NY5gqk39N7xDvWoxquB9ORaoC/w6dZ9TTr+EMwLCDedDya36aHRulQ6/FLucmitEDvrOvBn8KZoAiPiqW76Y9Gkbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778775790; c=relaxed/simple;
	bh=RAUmrHg0Y1L3PBuTDoVsJvtHBZTneKNe6YaH0hHH8SE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qA8ffblXVClDFi54RFUYlZGrqWky2ZPy3ztBXvh9X+hQI4Jq0RDxLsK1d9zHW2z8A9Id+Xv5qTZwbEizNkcjJ0hooy4jcop+izzKYx48gTFQSOK0iTDxVdMr8fAya12AAo4t0Tr+FIeJyOnkiPtWVRMyKrX7FYS99H7WneB8a8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V86cVgdp; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V86cVgdp"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gGbGh3sdPzlgy27;
	Thu, 14 May 2026 16:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778775781; x=1781367782; bh=swS16nnIbpByZs7OpRIN4lF8
	yu7slWPN+Qu1EPsvXms=; b=V86cVgdpdUjmZfuK5xfIZaWfL/D0YtlbkLAV+lO3
	eM10N88ARsPt9rSnVRTWMWr2gSFy6RIa+BOpOYQ/PudepMAbdDyB4dvsYZNeEGqV
	emehd18P3wsK32w2M+c+R3bkfNOyTuwj2R+NOQsf6OnSiX3MW0J1YhXje6LAvBS6
	x0pGNR2+KzGXUQmexoT5ALnrQVVJavHxSWV08YIvafl1FAgs4AtaUld0fYZCjeJt
	8XsUTaRXK9As5bpye6ugKEZjZdUzBL+khGirqRLyNTTE/p4xMXNlkKVsW5/Uw9lV
	sLPVgjAaFjOUMHskGc5OstDi+8WMNkCVvfsgZqZRujAQKw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NEgB9YlGvc2u; Thu, 14 May 2026 16:23:01 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gGbGR50XTzlgy4t;
	Thu, 14 May 2026 16:22:55 +0000 (UTC)
Message-ID: <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
Date: Thu, 14 May 2026 09:22:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@sandisk.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_cang@guicinc.com, quic_asutoshd@guicinc.com, light.hsieh@mediatek.com
References: <20260514082906.58593-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260514082906.58593-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/26 1:26 AM, peter.wang@mediatek.com wrote:
> 4. In both ufshcd_mcq_compl_all_cqes_lock() and
>     ufshcd_mcq_poll_cqe_lock(), snapshot the starting CQE pointer before
>     advancing the head slot under the spinlock, then process the collected
>     CQEs after releasing the lock using the new helper.

This can't work reliably. ufshcd_mcq_poll_cqe_lock() may be called
concurrently from different CPU cores, e.g. from a UFS completion
interrupt and from ufshcd_poll(). Processing CQEs without holding
hwq->cq_lock may lead to overwriting of CQEs before these have been
processed.

Thanks,

Bart.
