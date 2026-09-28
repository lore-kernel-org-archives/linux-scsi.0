Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D04C4EA38E;
	Mon, 28 Sep 2026 17:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617099; cv=none; b=TkCdut8v552xt0/xZJVscN2wCsBSXCX7D4mPoKGtBsbtPIZ/p27dvLeLanO2ESF5tc8sEgwqVKlcMQnMAn/xVF+DJpOZ5xy7H9/SNJpmht79P1JYHzfSCmQjQfojMMadhLYK3UvIXxGAnxrSgh+1ikItvpUC7nMzBaau40DlGaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617099; c=relaxed/simple;
	bh=RoY3sVu1iaMZ7FFa0mBmfaqnVI3ZmvCuhrlmt9Pb/rE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VYuxA5/ZX+hTXxGKufmG9PFMPIBG/BA/B2YxRJPljpbNxfDEG09McgC1c3ODEB88k84EUe7jqF1QsDTVBWF8/Yf5uqtOKIC+WfCg6X9AgLgGerxEY2RvGmSeybW6N24Iyv+2ZiCjdDFoI5cy5jBayvdPLwZd1rUrKrKZL0+HFFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZIGI1Ifw; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZIGI1Ifw"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4htpS84KYwzlfddw;
	Mon, 28 Sep 2026 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790617091; x=1793209092; bh=RoY3sVu1iaMZ7FFa0mBmfaqn
	VI3ZmvCuhrlmt9Pb/rE=; b=ZIGI1IfwVJNEy1OaGTg6rmYx15UtCPY8K34ADaxq
	WWQ+iMxVvEIzKytvEfNWMpnhx2vlQWGQMz67TzMfyTO94Qxd4Q3477g1mz7ycCBo
	SnBYH866aDKKg+qkw3xcTI31u4VHM5A+vyU+nQkRMQCeZrJjKeekjkeJfqIeyFM+
	7xeHpAeE56UtQShuhdOn1PpXm01idFOzTC0YTvAFrb748MHZsqeML06tQEI81HUa
	9BMWqg21HdiCpKmoWqiPsa3gJYzbs0BpnH8/esElJiGgGMuonQsXSGRIiraHqf9L
	WGodHtNfBEfUhswle7xhdCEc3DhBjDMiiKEdKVHdzC5eAQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gCw2IyoVWOvc; Mon, 28 Sep 2026 17:38:11 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4htpS05S5xzlfddd;
	Mon, 28 Sep 2026 17:38:08 +0000 (UTC)
Message-ID: <3ad7eab3-b884-4daa-88cf-358b752be93d@acm.org>
Date: Mon, 28 Sep 2026 10:38:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: bfa: Use snprintf() in
 bfa_fcs_fabric_psymb_init()
To: Mariia Nikitash <nikitash.mariiaw@gmail.com>, anil.gurumurthy@qlogic.com,
 sudarsana.kalluru@qlogic.com, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org, morbo@google.com, kees@kernel.org,
 justinstitt@google.com, codemender-patching+linux@google.com
References: <20260928090031.712418-1-nikitash.mariiaw@gmail.com>
 <20260928090031.712418-3-nikitash.mariiaw@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260928090031.712418-3-nikitash.mariiaw@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/26 2:00 AM, Mariia Nikitash wrote:
> In preparation for removing the deprecated strlcat() API[1], replace the
> chained strscpy() and strlcat() calls with a single snprintf() call.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
