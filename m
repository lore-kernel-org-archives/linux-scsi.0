Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D082F3C37;
	Fri, 25 Sep 2026 17:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790357848; cv=none; b=HJWoI798P2KtnRTpWz/XkwK47J1bh4AB8nxZ01SFFn110xQ4D7gtjAN38bhYtWnxplxIFKyVubPZYYEZ89rjv+tV+H59MFaBUOwPPQEqCgJ2ErIdZ+wJd0e7ZAu2ldiSCCCYUidHQY6aIT2giF9FHZmtHUEpPSynP47YpliXw+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790357848; c=relaxed/simple;
	bh=8YDHmZxqaylxaByl56+FZbewy7PATgP4K/9kZXMxfAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gvHZhxoCOFNDalcpYTRpA9Aqn9+UBboSqh4U7dmRAUZ1HCcwOYqWLfk9u2K765hCYkEPSkXlSPaUYZ4HH1YywPd7ka/T3gszA6A1O9UyHfinimTsJ4jnTxhtTmaOVZ+wkpanZ0rPP+LOCJKVBAC0X+8dwKv7EO7YfvXrw9/Ev30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k5ahHOZ7; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k5ahHOZ7"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hryZZ01YMz1XM4Tl;
	Fri, 25 Sep 2026 17:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790357840; x=1792949841; bh=+ydXSBnWK/+8M86bpQ+eR7Wn
	vD/YM0flWAzOAzReNnM=; b=k5ahHOZ7mZSznlN9ySkutsIyDiToXIus2XjEChtK
	gVJRliXHm3gw+/3WrzHANzO/Z6IbwHqsnITDcshpWxIwS04jfV+Pd6YXnlMBCqMr
	m9iDidSk9o8/SkZPPgGpk7IDoOvjMdzi38BTVdnTT+DJ09lyRwV9tajHwX5UQJUV
	32n4VGe7DMiOrBBjUFi4kPO+lcv9Gxw7DfDU/E3qe79yOpcen7PgAxQDooHQMG72
	Jqkkr4dKxtIJcaDMfaP2IBdPIEtangAeSmKiw4Rc0NnD1hkVZTC6TTOIPWKGEEOO
	V8LAzl/+PIWmS7iPQYi3mV3whVLSwL5tAwdDK94iwZQ1ug==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u52u3Cgsz2mj; Fri, 25 Sep 2026 17:37:20 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hryZP6MxWz1XM4Sx;
	Fri, 25 Sep 2026 17:37:17 +0000 (UTC)
Message-ID: <e48b50c2-fa01-4733-bc2b-aca9266212d2@acm.org>
Date: Fri, 25 Sep 2026 10:37:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Avoid unsafe MMIO reads in
 ufshcd_mcq_compl_all_cqes_lock()
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
 <20260918143809.3034592-2-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260918143809.3034592-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/26 7:38 AM, Stanley Jhu wrote:
> +	/* After processed the cqe, mark it empty (invalid) entry */

Please fix the grammar in the above source code comment and use capital
letters for "CQE".

> +	/*
> +	 * All completion entries have been processed and cleared.
> +	 * Synchronize tail to head in software to mark the queue empty,
> +	 * avoiding an MMIO read of CQTPy while the controller is disabled.
> +	 */
> +	hwq->cq_tail_slot = hwq->cq_head_slot;

This assignment can be removed because if the above code is reached
it is guaranteed that hwq->cq_tail_slot == hwq->cq_head_slot and later
code zeroes both slot indexes anyway (ufshcd_host_reset_and_restore()
-> ufshcd_mcq_config_resource()).

Thanks,

Bart.
