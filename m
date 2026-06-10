Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEDE42EEB8;
	Wed, 10 Jun 2026 16:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781107545; cv=none; b=bT+7M9dJqAAlpb4gqWTi7EYK+okEN3Jc+J2BwXdkvP1U9sto4J4ag4MCNgqeT8rLGM0NCADkrswciyKM30z6A63fzh1URK4vkrtQaCHoSwwtgQ0qT+dLNLSQhP0y+H87ZWneKAF8Z/P7Or2u6Ii0q05/It8l4H/MfxQfLPpzZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781107545; c=relaxed/simple;
	bh=4g06kR2RckvBV7kCGKvXj9C1F/7q+DmeXmWHnyrFlTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ByGje9GIGqsA9d6f1ZtgKnggWsbsdKN4A+UQ9glIvrMZt0iyC3N/pCXMn8dm28v+lTfIbfMR70FyxBBj1t+QNzBV13HFB82M1Au+aXJe/PtKIjVbvzgIBg89B/wDESjk6KZy/moCVqy7BFDppjO3dgLoZ5UtPczcNOgfdDqJ83k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fkbj5R4t; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fkbj5R4t"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gb9c56Zp1z1XLyhV;
	Wed, 10 Jun 2026 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781107538; x=1783699539; bh=4g06kR2RckvBV7kCGKvXj9C1
	F/7q+DmeXmWHnyrFlTA=; b=fkbj5R4tOI5lubOPFat6/GZdWo+ycb3oJo7xk1fr
	b658P0CtpayqRMiKyXjB2QQ1dmvJ71GfYwEZHQPnG1vwmyImHMdQtR0S0A/GjkH9
	mLGI5dkr9OIOjx4fLhZ+WKys3xMHs07JAPPLvMk/ma53H6NY5Boaw8r/QJcnqF8t
	pVlWTlZKRhbSmzX+1LyFWsXgV34EIahLS4Sz8mTBOduLQVXdHK0HCzgPSulGTGrk
	Qh18HyjMZxxtcK+uay2jL0KE7v9FbF7VUSagPaidN+ZpJqtrPh/DZGz7cZyK7OJO
	g55/ILtj2t4FZCYWAXdhoyn+E77thZyhI/WpdnAoC5FC2A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zdm7l2cw2X3o; Wed, 10 Jun 2026 16:05:38 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gb9bz5MFLz1XLyhT;
	Wed, 10 Jun 2026 16:05:35 +0000 (UTC)
Message-ID: <3086f8a4-1f0b-4261-a19f-1ec0f4d2af80@acm.org>
Date: Wed, 10 Jun 2026 09:05:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] block: drop shared-tag fairness throttling
To: open-iscsi@googlegroups.com, Hannes Reinecke <hare@suse.de>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-4-sumit.saxena@broadcom.com>
 <93a82831-608d-4462-a019-26b3adc7089c@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <93a82831-608d-4462-a019-26b3adc7089c@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/9/26 11:18 PM, Hannes Reinecke wrote:
> The whole point of this was to increase fairness between drives, so
> of course removing it will make an individual drive going faster ...
Data that shows that fairness is preserved even with this patch applied
is available here:
https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanassche@acm.org/

Thanks,

Bart.
