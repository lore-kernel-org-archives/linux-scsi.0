Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85830324B0A;
	Tue, 25 Nov 2025 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764089909; cv=none; b=ucBw6FuWn7rFX5D0/VBhciFGkwvTx3rveAAEJ35eGLkzrJgYJ3yeX589VaNoQ9Wf5iYHZeVOaG9O0XL5NDd4OxEsoSkk9Z6m05z6u5NjjkNghYZoJc1M+FgG2aHHMY4Ct+OufzlBW6CvHbjaANHf4vo9vBsQ7ouUdyivd9m3SRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764089909; c=relaxed/simple;
	bh=wdi8GexS++QWSDMToto4ELug7X7Yb+bkEBZkl5T971Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FVQIdhE8NVngoWOOuJN80KHKiMmaE1zwSOoe/LLrg3ieRvkzEx8zwJBGRu29jYFz5hm3dDlK8uBUlDk29k5/AHcEs6WpFTLoHA3vJAVRJzylB7iYlSwdIqrxVBUoKcpdYmjWKILxNLbgmoGHvIbgihZ9GvKuPJ6LMK6h6MbnoiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=me1dhq5T; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="me1dhq5T"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dG85t3Qv1zm1Hc8;
	Tue, 25 Nov 2025 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764089904; x=1766681905; bh=wdi8GexS++QWSDMToto4ELug
	7X7Yb+bkEBZkl5T971Q=; b=me1dhq5TNZIr6L2TC1wsfM9DEc50V1puN+uRzr/j
	9vOri9DIYRG6ESl9AN67GdZ4rf4Egm5J9ZkHUpBPX3eBMbADy5AbSVL7693xzHSE
	aXe0vimTk3owwezOTTBJdcJSgfd+5ysnwtp4KQpfFAb/9A6oY18GRVM+yoN+J02A
	cGziqTtIULZ86C471E/4JNai3wbCVuKBOjMJplO/JBr9fQhkfqKZA5WeBSRr5WaP
	xoxiDW+ItbONU5HZW6SgZWo6If36cM49u6X4WPTYfAMmKn2UrulyUrWPxX5Ribe+
	CBLtW4UkS8gWT/7YczUWycfh1Wmy7woZXMmc10tADtFAhw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mEs10PCEJsJX; Tue, 25 Nov 2025 16:58:24 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dG85k5Ghgzm0fLN;
	Tue, 25 Nov 2025 16:58:17 +0000 (UTC)
Message-ID: <cf02e14e-15ac-44eb-ba51-53fd96b48919@acm.org>
Date: Tue, 25 Nov 2025 08:58:16 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] block: Introduce __blk_mq_tagset_iter()
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
References: <20251124182201.737160-1-bvanassche@acm.org>
 <20251124182201.737160-2-bvanassche@acm.org> <aSVNaLyqg08-GAzN@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aSVNaLyqg08-GAzN@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/24/25 11:32 PM, Christoph Hellwig wrote:
> Why are you Ccing me on what appears 4 out of 5 patches, missing one
> and the cover letter?
Hi Christoph,

This patch series will have to be resent. When I resend it I will Cc you
on the entire patch series including the cover letter. If you would like
to take a look now at the cover letter and the other patches in this
series, these are available here:
https://lore.kernel.org/linux-scsi/20251124182201.737160-1-bvanassche@acm.org/

Thanks,

Bart.
