Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28A420720A;
	Tue, 29 Oct 2024 19:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730229551; cv=none; b=S7mZxw/T4frjIv6NgvSAyFCbLcuTJjydT5pv+QW9ZcOzurgSnXjJgV41pZo2hbM0R4ircYYvo6LPntO2dnI5saIwBpd8+h7/lXfpmbaVuQ4vD6DkidWmqW46Q9O8yqERp0vR9iq3UStydpBD4tC32F7msvEARY+R9JisO6V8uIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730229551; c=relaxed/simple;
	bh=y74Dtll6Z5lxjdty6GrgQzqz9Wb5PHlWQg621DdqIL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GfDyg1VnVn+LTWEkG9iO72D/oyBGLZ91MZ2wZ47q/nCKGimDZ9NXiorb3BhmFtKJvliU+iSsvCE9yl0IyxOZsXdLlmfyVSezrbTzPjFvGyGTKKT808fM8M1dX+u0zW5Tmo+RQWCr5OvBy2BaLSaViyNL6ArB8rHT0MzPeQuHLqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WE/TlG+q; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WE/TlG+q"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XdKn71bfLzlgMVd;
	Tue, 29 Oct 2024 19:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730229546; x=1732821547; bh=y74Dtll6Z5lxjdty6GrgQzqz
	9Wb5PHlWQg621DdqIL8=; b=WE/TlG+qESqXLQBtRJ6eciWjHmxEW+Em4p6ky9oL
	XnnhN/5Qmb0hJ7f0tD0if2tBG9gTHKDQtdeJECP2FsnxzB7b59yXwdPqi8pfeAo/
	jYnwyfhkNWlq71+BYreDrRQ7LqWCLNLCb7LFyeiAH8DNRm+ltLncXYB2h1FpqojU
	aZpM/14B/xQYumK/2j9TkGyn+ikSRXDx0CTtgM9TEz8EYRwpLrE/mnSRMbn0Aal7
	W9qAtN3ZN0BEnvaHvMuUgL0xP4ecKFm2I2ZidawY6kSlxFZBU3KxNIq5XsK5kycI
	Nl+4G+mj2sFlmrIIGXVwA4Du2ExOXJyWPaB7NLecDuoBJA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UCriLDWP1rK8; Tue, 29 Oct 2024 19:19:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XdKn50DcHzlgMVY;
	Tue, 29 Oct 2024 19:19:04 +0000 (UTC)
Message-ID: <8b50f6ea-3588-4529-a1d2-0808f37b30c9@acm.org>
Date: Tue, 29 Oct 2024 12:19:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Introduce a new clock_scaling
 lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241029102938.685835-1-avri.altman@wdc.com>
 <20241029102938.685835-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241029102938.685835-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 3:29 AM, Avri Altman wrote:
> Introduce a new clock scaling lock to serialize access to some of the
> clock scaling members instead of the host_lock. here also, simplify the
> code with the guard() macro and co.

This patch looks fine to me, hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
