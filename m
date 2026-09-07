Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28751D523;
	Mon,  7 Sep 2026 20:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811440; cv=none; b=LT9g9H0XNMAVOMJQnAOW/PZHs/eOqzZB14ExU5kXXkO0ECAh7zeVwk5uv03AtuxlEUF+Z8+l+CdJCyqrUkdjKpuWyCDoSdkjZ2u9BCqq7RTlagSbB32y1hhhyoSYXwU02PKmOm4H3GETFYwXKHMWShpJW39zXOlh1VBg5C4WUyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811440; c=relaxed/simple;
	bh=fa/uFCGg9WD3wEqa4is50H7cw1gf9/EMDZBI5P+4Wsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QBzlrUMlluySRn6ILtzMziJV/q3FK/EgJQfmWvRQSDFSM164h1aUZwVNZ0cBeRux1UQCAlhnEtqvboe/aRgzIeLgrTWO3LU75uRM7BMFIiOsN9k9rXiyZqEOQXHycmiF0nAZsXvZmh7yyKRGc3I2pUTLFySjY7VS/+UDIJux1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N1L/9zbF; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N1L/9zbF"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hdygx63W2zlfvpS;
	Mon,  7 Sep 2026 20:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788811433; x=1791403434; bh=fa/uFCGg9WD3wEqa4is50H7c
	w1gf9/EMDZBI5P+4Wsc=; b=N1L/9zbFc41XzLPOa+RAREu0pH5UsKbtychFh2oI
	qV9MQP5+G6w/NIVjtnDAVN23+E5SNhijGUKKjInVe6377yvk7Zg0Otxsf79+hQTp
	4J3K7/1nCnFjNaa8z5AniiWs+mtrJSy+jFs5bGSamF+ePQ20mnCscMSN6H0pCScv
	m+sA6MIGr9dpqmTaVVBC3t10iTcnSEzMdge046RcVpqfxmexAqQzWXiiDGtWLBr4
	rs8dsxeXO89Jv/+yQz76rqp9hMiEJzSDfYGGMmEP3s5LzePfMU0MrEDmtJE/HTh+
	UNQ8kgg3L/sy7eqXIBF+le9LDHWce1eEguMbLc4+KqhIgQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id moJEXPxlfjl8; Mon,  7 Sep 2026 20:03:53 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hdygn3gKRzlfvpK;
	Mon,  7 Sep 2026 20:03:48 +0000 (UTC)
Message-ID: <83caa7a0-27bc-4b10-8578-ed7afbd36030@acm.org>
Date: Mon, 7 Sep 2026 13:03:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/40] scsi: core: use 16-bits defined sense codes
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-8-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260907024343.1046387-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/26 7:43 PM, Damien Le Moal wrote:
> No functional change intended, with the exception of a correction of the
> array any_sense_failure_defs in scsi_lib_test_any_sense() which
> erroenously sets result to SCMD_FAILURE_RESULT_ANY instead of
> SAM_STAT_CHECK_CONDITION and does not sets sense_key to
> SCMD_FAILURE_SENSE_KEY_ANY.
Is this perhaps a fix for patch 4 that should be squashed into patch 4?

Thanks,

Bart.
