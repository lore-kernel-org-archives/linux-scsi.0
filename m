Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EA6433CA;
	Thu, 30 May 2024 19:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098639; cv=none; b=qwi6NDGWOxL2LtLf467o1ZtgE5qMJf+ELJDdbVm1T7PgeM/gKSZRznI1sncb9YMSaHlhkXeksweTZAThPb/j8vJU5gZ3kDxvt+/Th8rKF6k4i5TAu0dDycpmcmC+PgOEI4VhDPIji7GAt8c/rPi7NhKsH1+WYSfPJSTl9+BCQXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098639; c=relaxed/simple;
	bh=76oxrfqG7cObI+vvUTa4kuCj/+0KRE/PDK4Diaxupss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCYEP/2sI04GdR2J9cxbIUQAhT8pzqug/qK4AUlHa4+80lGp2xYrudvr92L1nBYpy1KXXSo3B0H4nhSNbt+KLroI02hxEGGn9dX4PJvfrXnzhkB//9mv7Pegw2GgavLJfyWf/e2D2tovRLgKZHiQMLJ64NLz173ULLMB6LfrLDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WUjlX1PD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WUjlX1PD"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vqxgd2Y61z6Cnk9V;
	Thu, 30 May 2024 19:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717098632; x=1719690633; bh=7QFmifQMChBXa8KST+DsqdnF
	Epu7aV4gNbQITRSzRXY=; b=WUjlX1PDIQyMgUb/0/yO+Fvzm6H2r3VbR/ytQbyG
	ja1ZtUlCegyS9BGCsSsID9x1/+kDjEs1NxZDIrjljFC2ZUpQ8nSD6H6RckeDAaV/
	8NybhiHj4Sye5m61h+RgA1L76P3LsN9DZgjtG7WVblDA+TCSZ/ARfrUBW1SRcvIq
	CUnB7FlcYqzV2NUiwaoz3LW53sA83Z9iucHomhpMAkPcCpOBKOEtiyurze8Qo3I0
	N3az9ReZGqTkXsyoXq0i+KzjVMS+igSHckcZ9ZyYDlURgNiKKLrMqPh/lqphOWEQ
	PLQr+L12hPXk4p6dZ8EbtkCXzU85zv+TAPmk7Obq/DjhLg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NvbqtULo1Ahy; Thu, 30 May 2024 19:50:32 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqxgW0TsNz6Cnk9T;
	Thu, 30 May 2024 19:50:30 +0000 (UTC)
Message-ID: <bb168ec3-b3e8-4e40-8f8c-eb0a1dd00f16@acm.org>
Date: Thu, 30 May 2024 12:50:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] sd: add a sd_disable_discard helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-5-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Add helper to disable discard when it is not supported and use it
> instead of sd_config_discard in the I/O completion handler.  This avoids
> touching more fields than required in the I/O completion handler and
> prepares for converting sd to use the atomic queue limits API.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

