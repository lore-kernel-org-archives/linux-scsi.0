Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0C830AAB3
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 17:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763055949; cv=none; b=uUlqMplQfMpqZFEWLFW4+pXO8kzchupcfHc4m6VLpl1M7CAx/glnT9UsFyf4YH6KsNQjBnVkWrqJk8YW3KjkX9ZLryeRBfxYyBS455qpOBWqpNkLi5bbLfLpABfhe0nxNstdLBVbACkiSWsAiGJO+Jv9q6D81mGIA+nIxa/qR2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763055949; c=relaxed/simple;
	bh=6fI2k41xKxBIPSY5azaq9MQ7xspT7BS+WpI3dMDEvPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PRqpYgq57jmnF5wO0/rBG0MDOubcR93R0p/Lbtts8i+nebCLGDgwsI3RNx5DvcsdrZvUlF2bi/LMQ5Rn6sMkSGeb6x566C9RZ4dokjsUk3IPgBpNzOajtEYlONpQgDugBRRriuHBI3ZAZzq17bMjEWJh4kloFJxbpZ71YWN2WYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MXruvp9x; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MXruvp9x"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d6njw2DZLzlsxDC;
	Thu, 13 Nov 2025 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763055939; x=1765647940; bh=0yzJTMavQZtCcGaUEGESmqwv
	oPpeWjtPmHuehSDTFMs=; b=MXruvp9xJZqORhZmRpeVRQcvTIsy/UyCwu3vQ7Hd
	c2Qk7yvCWKz7B86zOATn7qEt24hLmR1I4AGhLGMGUAjOCXq3msddlIsjEM1ZTkx0
	nl8h2Td4lpahCsENGLE2emzEbA+X6tyK6PjAWToRxAwQOsEY7dTQBOa+8GC5JfcN
	aL6/MHrXM0/Q64S5rAgVwof9WvT1zx6ykQ+BHFq4CfEqyD0knGFJGTpAaJjL0iJJ
	2Z3gLKSNPhr4UvIfUGzMAO7FIb3MnTi65PXl+3mSjM6heoUTXzWhIMQmYUjjp/Qs
	A0Y88fjUKRRRLBlcNeq6M032YKN5NK91tOqcW2R4Mu7TIg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2VTSMj_b2LXt; Thu, 13 Nov 2025 17:45:39 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d6njq4jgmzlv5kL;
	Thu, 13 Nov 2025 17:45:33 +0000 (UTC)
Message-ID: <0108b7fd-77c5-4aa5-a761-2a7640d2a024@acm.org>
Date: Thu, 13 Nov 2025 09:45:32 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] scsi: scsi_debug: Stop using READ/WRITE_ONCE() when
 accessing sdebug_defer.defer_t
To: John Garry <john.g.garry@oracle.com>, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, jiangjianjun3@huawei.com
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
 <20251113133645.2898748-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251113133645.2898748-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/13/25 5:36 AM, John Garry wrote:
> Using READ/WRITE_ONCE() means that the read or write is not torn by the
> compiler.
> 
> READ/WRITE_ONCE() is always used when accessing sdebug_defer.defer_t.
> 
> However, we also guard the access in a spinlock when accessing that member,
> and spinlock already guarantees no tearing, so stop using
> READ/WRITE_ONCE().

According to the Linux kernel memory model, if a variable is accessed
outside a critical section then READ_ONCE() and WRITE_ONCE() must be
used when accessing that variable inside a critical section.

Thanks,

Bart.
