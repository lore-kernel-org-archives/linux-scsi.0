Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655321487E9;
	Tue, 25 Nov 2025 16:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764088598; cv=none; b=L+r2ikYcfpX9achsqtDDVM9ciQy3RpfDlE0WlbUe/3WvEbIRjOvnLBOt6zMy1RuNbveS5JvtGoV+adk526+TgtcFrf1YsvFp+peNx8CPLFwt17aGPd8VDQ0pdIezBwxpPscTnqKt8x1uBKzqp/mUrJ9ModLJ9hwIWJek29OGeTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764088598; c=relaxed/simple;
	bh=a+exvYMEpiNZIq588QaZ/Pg31TEQVkbWGgx52knTkNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SncHv1gkKPRR7Se47uV1BXUIXYokBQ1mMUiMF8wXJhnGuCaSkiOiWtlgJJLCoQG5sH3oJZdvFDdiZqcPoVkB/bwVcxy3udKCMVXAbeGpC7C/URx6gLWwT8jQjdw1mm6dhDLbDR5/9WtlXJM8nQKEz2TgHsmsmOy2b89JTqWRzKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gLTnr/23; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gLTnr/23"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dG7cg1LCGzm1DHG;
	Tue, 25 Nov 2025 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764088593; x=1766680594; bh=mcJYWEo9NSJGl7apryGooFLw
	m379j6aRDhmKno12Nwg=; b=gLTnr/234/5sxLmAl0H63vdbfc4RZu7Ad9mDjJjX
	u7qk6t8OTpZq5OKPB7G1Qf6zP9fW3XBbDOKck67/q100clJOllVtOV2TtNmPatlg
	UU9oh0dB9Bg0jVOXundjLzw/SeuCxUvE/N7Wqgs4es9yE5wX6qpwJEuBMLd0FpUO
	/TNrNO8sKR84S9w9FP+o6xefx8vaiCjN2rX3R72gSjnfqspPFvMnBxNj9+vcVc6u
	1w6N7I9KjEuOvLDZ8QZo91pvxdFVY+31z9ER5jdIaV4bMYEmOnq4lCvqynfJP7RU
	idjXp4VJqFryNU3ry8xapYFS4wEPxEmcyiNDugXUa0z9Tw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OPpmgplAEwnS; Tue, 25 Nov 2025 16:36:33 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dG7cS5Mzwzm1DHc;
	Tue, 25 Nov 2025 16:36:23 +0000 (UTC)
Message-ID: <b62930b3-9b80-4b06-b922-c38c7e309048@acm.org>
Date: Tue, 25 Nov 2025 08:36:22 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_error: the Error Handler base on SCSI Device
To: JiangJianJun <jiangjianjun3@huawei.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: hare@suse.de, dlemoal@kernel.org, yangxingui@huawei.com,
 hewenliang4@huawei.com, yangyun50@huawei.com, wuyifeng10@huawei.com,
 wubo40@huawei.com
References: <20251125124843.1613400-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251125124843.1613400-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/25/25 5:48 AM, JiangJianJun wrote:
> When a SCSI device fails, SCSI locks the host and enters an error handler,
> which causes all I/O operations on the host to be locked. This performance
> impact is even more pronounced when a large number of devices are connected
> to the same host. So I believe it's necessary to downgrade the large lock.
> 
> This commit binds an Error Handler to the device, so that when a device
> failure occurs, only the current device is locked. If the device fails to
> recover, the default Error Handler will still be activated.

The current behavior should be retained as the default and the new
behavior should only be enabled if a SCSI LLD requests the new behavior
because many SCSI LLD .eh_host_reset_handler implementations are based
on the assumption that no I/O is in progress if they are called.

Bart.
