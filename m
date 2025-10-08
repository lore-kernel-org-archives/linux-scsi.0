Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804A6136358
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 15:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759938166; cv=none; b=dWaIwQLev5SmoRI0bEtJUtXgwquhqLvaWCfdLBNtzipZK+cdEJQI7dwvfKsd46D4iUruUDp2wnMOrhLsYF1JRofst9O39nKLAeBcLrKclrx9S1TRhIvjmi8bKyuSMQ4+BdgIMSgEJvrqnW4zaoWLAO5UDOoYfyU5CILp7tc8zsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759938166; c=relaxed/simple;
	bh=pMPl9S5pwwNTmNUsMQycmL7KSwRyQBS30V6l8Tere94=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dxwERlQQrUU8OYDRJtJMOjiRpycfVK1h0h8fL7Y6kKv0la5+0d6bHJrDOrjXbvj8ZY2U9Hj9JOC+qJ5NKjMNKAjjwxnX4N/Ks54Rps7If+gqrUsbfkpx+y5djN8XASktJBQ++ajC2XR6yrmj+qw+yl8e9cOA8ryhUhnPUJb1Za4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TN0XfrVX; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TN0XfrVX"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4chchg2rmvzlgqW1;
	Wed,  8 Oct 2025 15:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759938161; x=1762530162; bh=HaSLx4uCBpSpmTzUnyCgz638
	x8Bn98ThbWdYNcVRKFM=; b=TN0XfrVXqBybNtAd8mbyRsaINoq9oAY647rnzWdZ
	9d58wlrYJIYxvCjnWFT6vs1HTYU61mgWkvU2/ar90qtP6AHv8JSwR6JLTGm79bki
	DAKgYfjWEV2Q6Bv/1JM3/ysC8SvSgNXY8LOfJymhXzM0A19HF2BSBOS9ZQRRJIlo
	BQzuSf6RxoOhQpDWFtyX6eE2CNag9p/g0A5oVO9KsYdPmYeeuuFIKKMNPEHr634u
	tVdE0y2huOOq6p8+gW9RJRY48nl6ctIfuI3P6YXrz4zDoKxK7WzX+ynZ2jNIxCPN
	8swJX7gdWSCBl4ieEFjvhDvEcpnxl6tDEJD5j/jsrRERTQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c9hBVJ5Dovks; Wed,  8 Oct 2025 15:42:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4chchX6qjKzlgn8k;
	Wed,  8 Oct 2025 15:42:36 +0000 (UTC)
Message-ID: <11de5b13-cc77-4e49-86f8-6bdd2a229148@acm.org>
Date: Wed, 8 Oct 2025 08:42:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <CAFj5m9K1L7n3C9mL0zgNXmzhttD-B-64LBNbcp=HCPYPNvgjMg@mail.gmail.com>
 <aOX7krhcR7DB7T6a@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aOX7krhcR7DB7T6a@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/7/25 10:50 PM, Christoph Hellwig wrote:
> On Wed, Oct 08, 2025 at 11:17:18AM +0800, Ming Lei wrote:
>> Long term, the UFS driver need to be fixed, this or most of scsi core
>> APIs should
>> have been called after the scsi host is initialized.
> 
> Please fix ufs now.  Otherwise we'll be stuck with these hacks forever
> as they never get cleaned up.

Although it is easy to make sure that the UFS driver doesn't call
scsi_host_busy() before the SCSI host is added, this is not just a UFS
driver issue. The advansys driver calls scsi_host_busy() as follows 
before scsi_add_host() is called:

  advansys_board_found()
    ASC_DBG_PRT_SCSI_HOST()
      scsi_host_busy()

Thanks,

Bart.
