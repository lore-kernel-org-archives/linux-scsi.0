Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D56349B1F
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 17:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778693202; cv=none; b=L2ALv7/TFT8FUYkw1zrwFQh/+xftbQx70Y6iysH6Oi/T4rBkTBpEAa+JwOpYImsLDodIbwKJSTst+8plBZDznyb2Z2UZtVipN+fg2Qp1kLJOpja6ZUhwpm+GiprmgEsbn4aijqJYvCbD07im4bbBCUIxExak4LqPzDRsZKbGKjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778693202; c=relaxed/simple;
	bh=mZ+3IqgVlDYOVDr4xMbrBpT56S0RxalWma33hwp98/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G0b+6D/CZ48h6d7y2W5aFrWMkOo/lIgIHmA/EeJ5ZJQosHdU6WtthmiDUloJJJDhg14aTcWkZ9xxY1AiM9yiiTQsc8fd8TaSKkldl6BoUJQoBOzLanfotx0cwfu9CKCol8x1lP3Eu9WPyCfz0NYbS7TLvcQOzP4vVICiS7NZY4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eHM7WCUv; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eHM7WCUv"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gG0kM5QcYz1XM6JX;
	Wed, 13 May 2026 17:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778693191; x=1781285192; bh=PNIvuXxNovbVz4XABZTQq2iD
	cpbXUYJ37MEM03N31LM=; b=eHM7WCUvP1F+DJdQzoXitKzYJpVPkPPa/gHiH8/C
	HAyA/y2tMX2RBVKXMWu8OPbj4oMg6x2G701ZV6vII86uSHKhVRkInVJASVJ7Ux0c
	g/sdggs6pTb/ybI4L/b6AgK7zX/VBdTYUXEsZ/bQsbaXjB1jy7AFAopWH4NJSwIS
	mLnskQe1PC1taL6jOj9iSy0WvuPsSOQzLZeacxkv4CkR9T5vYjjLgmLDaj8JLIMn
	7WQ/3JqQuOWPNgQwggodVBzSjWk1IhN6lmLNUwvEqNASGP5tSQW6oAPveRrLQtaP
	Z+FxvZY3RsTtab+9m6BMBi7U5bDuqbnV+SfwtWwMVUjTew==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WrOA8mzPFuwz; Wed, 13 May 2026 17:26:31 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gG0kG0CqDz1XM6JP;
	Wed, 13 May 2026 17:26:29 +0000 (UTC)
Message-ID: <8ca0f49a-ae11-452c-987d-d90cce8376dd@acm.org>
Date: Wed, 13 May 2026 10:26:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Convert inquiry information
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Hannes Reinecke <hare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-3-bvanassche@acm.org>
 <292bb057-f10e-4af1-b0fe-ca83d4f49d06@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <292bb057-f10e-4af1-b0fe-ca83d4f49d06@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/26 1:03 AM, Damien Le Moal wrote:
> On 5/13/26 04:46, Bart Van Assche wrote:
>> Currently the vendor, model, and revision members of struct scsi_device
>> are pointers to fixed-length strings that are not NUL-terminated.
> 
> s/NUL/NULL
Really? NUL is the correct spelling according to
https://en.wikipedia.org/wiki/ASCII and also according to any other
ASCII table I have ever seen.

Thanks,

Bart.
