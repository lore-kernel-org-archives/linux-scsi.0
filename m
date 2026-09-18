Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493C34E50DA;
	Fri, 18 Sep 2026 16:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789747578; cv=none; b=dz5FNSSu4tKrJRpJpukOIIPb71ENcrgYsg20fQV/UmaEdEo9lYm//9GfBGeTXY8RZFzSJAoqP55ZsmqEEjNJDzVBbcnOS6LC2Rk6DtrF598v8C+NPlTuVdiGXBmAtIjvLKvipG8S9jq1xPyMTn/HK/+pfhpIAWDZnZ2zZm70isA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789747578; c=relaxed/simple;
	bh=DtRxiNCsFLQWcS+gNBg0UEsVy/nFi9uPGmGGpQ3qQG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dEQmToZrqFq9U0JGAypfMkTRJg5maWG0wQKzQYMxzgHJXyoXOv0dFye6eg6KNejhpQmi6JO3l4wbpwT2MpVjcFsSwaKWMCQ/lt8aZ1ucV3Gy7G8xvNDNFuQHrNWSrJRbUvdkx3g0wqEhwOi70CC2OMNWtYzqwDqDfOi+nFZogpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V3U/6ml5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V3U/6ml5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hmctc42hCzlfvpd;
	Fri, 18 Sep 2026 16:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789747570; x=1792339571; bh=g22YdFd18HrAra8XnJnITid7
	9Lyg8I2qKQy/Um1nggU=; b=V3U/6ml5ilNiVaNfdTA97xlJ7kHSduz35SzsAL4g
	EAe2gr6UbkBwyFZOGxEa0wUTIck7gpcsIQb9TO6bfoIg1ui66tvGzj72R3bjwpOb
	BM8UVIL8PrZ9pl2qJqbqBEZm3s5nxNOqiyakhP/IlUD1OMDvbzUFhr8NPKDHKho0
	29DvMsMM6AyvEW6s7EmVQFskaQI4NFMdWRhKCPgFavWPcq+Rq70fg4pIrC5vzVKO
	j+wTEd3fVyvqiZqPaq+sBPd00xlBkl3xEEeoA1H/Wd6cpGvympKW25sWkuX9h8b6
	4RgJpY6BGhlWYAkZiIwSxET3xGi7vbN/qDER/noxkIFF9g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mOBrM7M96SoE; Fri, 18 Sep 2026 16:06:10 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hmctP70DJzlfvpc;
	Fri, 18 Sep 2026 16:06:05 +0000 (UTC)
Message-ID: <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
Date: Fri, 18 Sep 2026 09:06:04 -0700
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
> In MCQ mode, ufshcd_mcq_compl_pending_transfer() uses
> blk_mq_tagset_busy_iter() to iterate over busy requests during error
> recovery and host reset. However, both iterator callbacks perform
> whole-queue operations redundantly for each visited request:
> 
> - force_compl == true: ufshcd_mcq_force_compl_one() calls
>    ufshcd_mcq_compl_all_cqes_lock() on every busy request, sweeping the
>    entire completion ring (hwq->max_entries slots) once per active
>    request under spin_lock_irqsave even though the first sweep already
>    cleared all completion entries.
> - force_compl == false: ufshcd_mcq_compl_one() acquires cq_lock and
>    polls CQTPy over MMIO via ufshcd_mcq_poll_cqe_lock() for every busy
>    request without doing any per-request work.
> 
> Sweep or poll each hardware queue (hba->uhq[i]) once at the start of
> ufshcd_mcq_compl_pending_transfer(). When force_compl is true, run
> blk_mq_tagset_busy_iter() afterward to complete residual in-flight
> requests with DID_REQUEUE, and remove the now-unused
> ufshcd_mcq_compl_one() callback.

Forcibly completing SCSI commands from inside the UFS SCSI host reset
error handling callback is incompatible with the SCSI core error
handler. The "force_compl" behavior should be removed instead of
reworking it. If you take a look at the SDB (single doorbell) code you
will see that forcibly completing requests doesn't happen for SDB mode.

Bart.
