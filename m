Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE57128812;
	Fri, 21 Jun 2024 17:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718991110; cv=none; b=VMEC5pOBnB884v1oLrgNtfMr6EogY+LhZ0UBskSB47UMO/Qc+s8i3H5VqFPWgLeBJnxXEnNS7NY7yzAS9X8AgHUbjrdBBm2FLSe7f0vOTBY7C7UPillcWV31ilhsmdhseE6H0UMD0mfu3Bo0PgB2gy10bhU6EJddR9El0bMaGrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718991110; c=relaxed/simple;
	bh=GjVvMBQ0mKBg/LBxfRiDy4U/fIMOVVjXc1b3lBeyoi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ifll/bITNJL2ch6Z4XyfSRMDuFi8UkPe+hrT0HvZOSO9zeDpzjzlWPHNSQTJClhLkZHWufub969RomICslgs9Hl3K+LMQ5+KIdUM15r+NqOAP5jYqq4JmxOEBvbKtm2Vl2Id7WbfXA8nLijNoyAYH7mPyxKGecThU9ySctb7cW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nF7GUEmG; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nF7GUEmG"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W5PYJ3Hxlzlmb1R;
	Fri, 21 Jun 2024 17:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718991107; x=1721583108; bh=GjVvMBQ0mKBg/LBxfRiDy4U/
	fIMOVVjXc1b3lBeyoi8=; b=nF7GUEmGzBGXz3ah//o/b8CHO5xzMG6AaYFEdCN7
	YxXveECSTy0hDUoYfLW7Vd75J5Xz2sb/GhGQmIWQX2U56DshMwrcEcBhJDb8mXt4
	tfhcmQjY+e6cGT1dW7PSk/tNeBsguIMHTZCTwcof7DSv12jUDUzM6DSRsjhhjYaT
	u5RqA7p4SIOXYbVv+jozxuDjGzzCh12uztjyW8vXnIn89qjtTLJC1rv9Z24FAKt2
	zFCoPwQV1IkGZRd/qkVHVr/xbdpqoJDq1u4TfVPRzc69jeb3vcY/EvsEv0ZdGcku
	IJu5Om0a39R9vohHaKNeaZwJxRF/M29ryvja6h+JfBgPGQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3oaUnIcEt3NX; Fri, 21 Jun 2024 17:31:47 +0000 (UTC)
Received: from [192.168.137.167] (29.sub-174-194-195.myvzw.com [174.194.195.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W5PYG6GcHzlgBY5;
	Fri, 21 Jun 2024 17:31:46 +0000 (UTC)
Message-ID: <67d88fa3-984e-43b6-83b0-a7a5251a96f3@acm.org>
Date: Fri, 21 Jun 2024 10:31:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: 6.6 kernel block: blk_mq_freeze_queue_wait in suspend path but
 userspace task held the queue->q_usage_counter in 'TASK_FROZEN' state
To: Kassey Li <quic_yingangl@quicinc.com>, linux-block@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <6fb677a4-b655-4395-9dd1-450217fec69d@quicinc.com>
 <4c98300f-bc0d-4267-acd4-6365de65713e@acm.org>
 <c6fa7134-c99e-464d-9d5d-a9480aaf59fc@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c6fa7134-c99e-464d-9d5d-a9480aaf59fc@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/24 6:39 PM, Kassey Li wrote:
> do you have some suggest on break this ?

Since I do not have access to a test setup on which I can reproduce this
issue, please work with your colleagues on root-causing this issue. Can
Guo should be able to help you or find a person who can help you.

Thanks,

Bart.

