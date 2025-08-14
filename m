Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA84B27C17E
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207711; cv=none; b=XKE+Qp5/udlo+TOTDGgf2/4KOJdF1pd8cSQkJuTXr2bZTYFhBQCuJreVZc4u01M+OhN6XWe1B8bjLbIVXFOKxVCqyi0xqmh1KNG7xnwjzT8cZfVaIHxxYund6MFDsg5az+6L5SvCR6qHQPGmA3whJUZBtHa6hHbYM0uk2+aWLV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207711; c=relaxed/simple;
	bh=sUrUtrSj/FCbgJB1/5Al0ag/wAU5am9D+gq8ngBMHx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A9xXGGbgX8mVYpzpyoevCtcHc3KVm9TmdqXAnf1M6qZ1EGLZ3TsCmXBlaRuLno4iPI4Ajaee3UKhj7RnFfHfplztYv41HN6v5HUmHYqGEk8/uaeXZEqLCwcxoWVPD3NBBnnMOMH44Wd5uHHwUzIlvpd5KlTRaOBLYQFbUZtsrTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1wOsFS+D; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1wOsFS+D"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2zGP0MqDzm0yVK;
	Thu, 14 Aug 2025 21:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755207707; x=1757799708; bh=sUrUtrSj/FCbgJB1/5Al0ag/
	wAU5am9D+gq8ngBMHx8=; b=1wOsFS+DNmaiCc5LBoeDZ3mRMtnJiZ+thEgbYA2R
	zIUy5eDDS0M+QZp4hWqQrpqml1tJyweFMMVC66e9BfanrDL1rshl+hle9L/BY7j4
	1AT5JhWkGik+Dl0ObUTVvTdzkRcNcNuKJsH+7qF7dxUoxE7n+P4r1ZSGxr3LCH+B
	loQeLxeFQ+OcwBS3dfzXIhsxytHhO8laOHFFWNF3eGGhwHo14GtUaLtf22emULAz
	5rfYI9GMpM65DasYJ58YfixM6H6eYVP3KYyr0/ItI3RCTj+Lm5I/tjuZNKoU86Rt
	lG83IWz8USbw0rqoFIJsG8YHyGbBC+NxPTQAgLHpso2Q5Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id emc1quCnk37L; Thu, 14 Aug 2025 21:41:47 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2zGK0dgSzm0yTf;
	Thu, 14 Aug 2025 21:41:43 +0000 (UTC)
Message-ID: <63dc4976-d5c7-45b2-9056-8500f120156d@acm.org>
Date: Thu, 14 Aug 2025 14:41:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] scsi: scsi_debug: Add option to suppress returned
 data but return good status
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-10-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-10-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> This is used to test the earlier read_capacity_10()/16() retry patch.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

