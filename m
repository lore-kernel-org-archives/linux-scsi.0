Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066EB30F948
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 15:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757346066; cv=none; b=UB2ZreM5tL6CsHGCU7iaAF3C2i4lNJasi+1DSIJnzOmVE5ylIjljraDrWrVgZhZJzoUXhpXIHKFgCBqUsBDnEK+kCXAD7R6CFXD7Hq/EhjMRbnrW8PCPu/5Z+49C35PUzAQMIBnY9ikkV7W4KRXhv7vBhUpObQFIpjgvX9ycOh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757346066; c=relaxed/simple;
	bh=sCWITeCY5AM7v6U2WhcAMYV7SZcJSNCPmse61KxQhIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IgKFcnUYCx2cjWfd2DAVZbYaGJJ2AjVhsQKwoCgpQnUtBtc9NDVWNqQxzhunka4iy+AHrbeuKd22V/YEO04pYybGdWO8IxOogh0dWF0UHZ0OF/Tll8Nv+QdEp2gfp74SrISDSn0Lsfhd2H5HAH58yaDrjeD3N9ZK8/YEC2aOr6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TKUdNjFh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TKUdNjFh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cLB4S0zflzlgqVn;
	Mon,  8 Sep 2025 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757346054; x=1759938055; bh=TUkNIdXoMVm7/qFGXJ3gTPZ8
	74N1VlddfsARDjmduyc=; b=TKUdNjFhIiLQbzq0BXdFAaR5oGOLiXtD/RLKBi3J
	Hh6TkOCH7ntECEayUomiqYSK3P/cJ37wEyQNzfGmTuQkvNFOtpx9KxSEtRrIp3xI
	AhPshARSkcyz5QNGQQM2Dl451jlCduaHFmLATGf3mpXr02gVTSx2EZbIUZG1tQV+
	Suv98hp04eFW55Qq6kN4JtNqAe5bWaqGhFtWhIoB09SQRv5u7X1eRk/kZzxQfXjO
	xmEFO+/HSh/th/iaNxNJaQNVTqj/lS1yeQmJ0XvoLRo4/BJ6uS/PogHl37LsAGyM
	6fsiQ7q/Mtvnn25sMsDnl/JhdXlJn1OywNDVBUQZyAPENw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pouj8AeqS-TJ; Mon,  8 Sep 2025 15:40:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cLB4L3McgzlgqTt;
	Mon,  8 Sep 2025 15:40:49 +0000 (UTC)
Message-ID: <e7708546-c001-4f31-b895-69720755c3ac@acm.org>
Date: Mon, 8 Sep 2025 08:40:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: ensure sdev queue_depth does not exceed that of
 cmd_per_lun
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, ming.lei@redhat.com, hare@suse.com
References: <20250908151222.964621-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250908151222.964621-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 8:12 AM, John Garry wrote:
> +	if (!shost->cmd_per_lun)
> +		shost->cmd_per_lun = shost->can_queue;
> +	else
> +		shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
> +					   shost->can_queue);

Is this perhaps an open-coded version of min_not_zero()?

Thanks,

Bart.
