Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7D711184;
	Mon, 20 May 2024 18:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716229032; cv=none; b=o49nKyYWT/xDP412yiuVlr7HF1yDMfQBjVINAaALCkjsUvZQby3qjq8zwgfz6/JecKL7uIuGT0HiGfw8XQ5XlRXcrjV9Sl7Td/4N26f+pn+1BT4faKpuSv+AkmRRKGPTSnq1k9fXyCutgYZhgqtqSU5d/fYTSiTa0yVxr0Z1DwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716229032; c=relaxed/simple;
	bh=W9S3tmYKAVI1vZm6O1FnsaIXgDq769OyLxHGWe+NJQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fySH02EE2iBTAGGI2xZ1YQ3cddAfe6NqRUWzV+SOhHuYBhBdzJz1CPmvNjk0LC4FBOu4J8AJBv/+WLlkQP5YROj+vI0SxDJNUAfU0vamOfIjCnQ07/5LYrqH/fvhsEVKiVNg4XnwPk0+W4boN0JOInqsRfVLnHMNAiJJJP2NwxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ugc2zAsG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ugc2zAsG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vjm4P6Nkbz6Cnk8y;
	Mon, 20 May 2024 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716229027; x=1718821028; bh=UV0Vw/qMOjwWgUro/BzTpPQe
	PzxbzienYDyA4fIgerU=; b=ugc2zAsGCLq8K7mwlrFOthyOI83lgQ1f44aCKIAL
	9jqLiBfd8sLSZWciEOIzNY+70wb5VBZJPMYEs/WEsuEeNtF49L2MTDgnazsq8Lkp
	tJJcmm43com4RC9pty9n27dQhDfDcYNfsZjkftL39L+eo6pFAbXRTb2wWP143rti
	M4WxJJaQUobOK6A74EZ2MShTVqA14cCPQu4RKZ7I2ZGnAd1wQD8l2KxuAGvKUi3a
	kRhuIQl/GAz/nToXgRRF8UjIqeCx+dsEyAJgfp4EN/nAGUT23KswBCDNo1iQr/m0
	8FU3OBhGPcaCQV01wdw3QWdIrfRl26KeMCuTf5U1ZmNEtQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gXAi3W1zJuCL; Mon, 20 May 2024 18:17:07 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vjm4J4cJnz6Cnk8t;
	Mon, 20 May 2024 18:17:04 +0000 (UTC)
Message-ID: <6c66018c-abfa-4306-84e5-d17841e87dec@acm.org>
Date: Mon, 20 May 2024 11:17:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ufs: mcq: Fix missing argument 'hba' in
 MCQ_OPR_OFFSET_n
To: Minwoo Im <minwoo.im@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Granados <j.granados@samsung.com>, gost.dev@samsung.com,
 Asutosh Das <quic_asutoshd@quicinc.com>
References: <20240519221457.772346-1-minwoo.im@samsung.com>
 <CGME20240519222606epcas2p45c250e92bacb3aa0b00f7430ee69884d@epcas2p4.samsung.com>
 <20240519221457.772346-2-minwoo.im@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240519221457.772346-2-minwoo.im@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/19/24 15:14, Minwoo Im wrote:
> The MCQ_OPR_OFFSET_n macro has taken 'hba' on the caller context
> without receiving 'hba' instance as an argument.  To prevent potential
> bugs in future use cases, this patch added an argument 'hba'.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
