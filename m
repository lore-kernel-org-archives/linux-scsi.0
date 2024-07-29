Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913B6158D63
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2024 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722271537; cv=none; b=hys8rqv20RG93nKHj0bT4LH1tKNy38woKtUBvDl/m37sPXkZ16CQrCN+SFHpG0B1T/ZKJdjZ8eBzzf/EZ7c0CzFC0Vw/S2aoqSFFtV5f2+VT/IMc/RlBNlL5TqnNrf8F53uPWdA+vYTAitLdXtsxGdPUoDl9zWhGFnU1fMFtdV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722271537; c=relaxed/simple;
	bh=3T+UomoGL4R7GUTlPjkQTVWMKL7ioTgyWlnbNPlif/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEqsDj1Tep7HiSPe+KNcKe60udIfw00k86tm0ZsmeMFGuplJba3MRRRWTblEsnRj7ivRlVBrMte6m5lKuT+8dca0Uqg2qPXZF4z+vBA7t9UB+RTK7F+BxHa0JjyUaI8+Uw1WY+jG+Xf5rEUuXW6xgFNrmrir28FADp7WqbPztRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=X0vxK3q8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="X0vxK3q8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WXkkJ6m7BzlgVnW;
	Mon, 29 Jul 2024 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722271527; x=1724863528; bh=3T+UomoGL4R7GUTlPjkQTVWM
	KL7ioTgyWlnbNPlif/o=; b=X0vxK3q8LGoAhL6rDx/z6jZMqwDxW4a8EO5qRyC4
	ilOHU6mci6JT1HITpYyFVWEmfNSH6alQFVCX4+DLWn99K/eb3q+0x2qMD62H95dN
	cUE02FV10AwzVWcgr3B6Fp+zVL0tuKtiUCXlUxKmgYraEb1LWG5OgvSj+DRTXrXk
	kZ1/KNU57fW0VFgO74UyxoCvwhClXECXnDoUM8fnRkEqLKxvEEC/esYuMmx8aeZ8
	maM7ZmBl4hEu08/5B01NSxRxkvMLajF+emg4ExMbs8cgxPNIZ8F0eGQm7e0ldJnD
	Eb2kYCRUNjBktaLmdhjJihVyqIFeI+JgBHvUYxIoVNvJTw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IimXsb8xRY8Z; Mon, 29 Jul 2024 16:45:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WXkkH0McBzlgVnK;
	Mon, 29 Jul 2024 16:45:26 +0000 (UTC)
Message-ID: <47ddc280-f262-455c-bfa5-252e8eb2b654@acm.org>
Date: Mon, 29 Jul 2024 09:45:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug:Use min_t to replace min
To: xiaopeitux@foxmail.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, xiaopei01@kylinos.cn
References: <cbece1b3-08ff-4fcf-8ed3-71dab06aafaf@acm.org>
 <tencent_8B6286FB808A0A72D3ABF0E4796ECB152505@qq.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <tencent_8B6286FB808A0A72D3ABF0E4796ECB152505@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/24 7:56 PM, xiaopeitux@foxmail.com wrote:
> I am referring to this commit for my modifications: eb3b214c37ed.

All min_t() / max_t() introduced by that commit remove a cast. Your
patch does not remove any casts.

Bart.
