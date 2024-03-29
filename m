Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A82413792C;
	Fri, 29 Mar 2024 21:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747747; cv=none; b=OSNMyWNJ54oqwt147ZLessXVRnhzNYFUNIsubXbTzs2Sp1LzGemGavZD2bYLj8UpFd3gggR3XFiT20gBLAjw2iruHoBD7+8NoTvuG18/AMhrITbIb//151HQlakILTa9U/ZASf/Adni9V71XCS7ymdaogGX7VqV/guik8GeOGHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747747; c=relaxed/simple;
	bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JeCt5amumX25AOgE1rpn4jRt2aD5d0/rGDXkTjQMlcINqoT5oFgBVSQi/fPNOlO1dlb5dXZgb/XQzQG6aQH4QzJPkJzfOQF7GGwGkAK5eRXlZEIeVybmrj3iPPUBdRJVj8x8yRFeUDkbKnpJME+KXiZzr+ntLMRsFyH+/WL4B2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=E/kgkNG0; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="E/kgkNG0"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V5tns6Q9nz6Cnk8t;
	Fri, 29 Mar 2024 21:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711747743; x=1714339744; bh=FRIggP1YvWWV3rj+5WU1Cj2n
	MoZrQOSbDSPE/2jMC40=; b=E/kgkNG0x+5P/d68X5ZWkx1sMZ/+dkVeHXcFBISG
	NfiFOrzoUM88jmWW4Mx4BbOHEOTPmS5buscLuGPToZtEfQ0zqLM4K0Y3kMounlSb
	8rUDuUMYXKJoYg4gzERZ2actBSLA12oVcCez/IqMgZY+CYeIjLMDENp5Mpdj3NWD
	gwpa2Y1W/0+WY0XGpcU4OkhFfeTPf3a4vsupurclTA68pUmwRZoffBQjpAHLoFJn
	6TiteiXA73lZ24t2Qt6VtYNvx76sxXoRFbMS0qWVI1Ec98b+ZzKOSMZ3heoyeglB
	Och+J2o5nPk7hskRpPcMhtScxZD/adgll9nRydCUqsOIlg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zfNF8TuIimCw; Fri, 29 Mar 2024 21:29:03 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tnm5gvHz6Cnk8m;
	Fri, 29 Mar 2024 21:29:00 +0000 (UTC)
Message-ID: <427e1f92-d010-43a0-be8d-c103810986db@acm.org>
Date: Fri, 29 Mar 2024 14:28:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/30] ublk_drv: Do not request
 ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-17-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-17-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
