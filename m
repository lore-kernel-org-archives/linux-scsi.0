Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3005B79DF;
	Fri, 29 Mar 2024 21:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748656; cv=none; b=igrrWLhpXTJqg8FJ4kdF3Jnuj7GJoYFezB8zHQRbILqSeTozlkBa7ku+DwCCPl74IyP3m7RG8r7+cAYxlQzu9tUoVxsOdQ2VBMkg7QWwtBpOrwnOt9Siupa8LBHBxvojqBbOx45asm9s01eSon/DGNRqvcLLYcX3rAiPEDLt9cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748656; c=relaxed/simple;
	bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HRvkcPbg4Mh1sl4g5OUWyc7xIaeWgO36UCfVSBjQUNUbTdTrFIrBBh8uFERYIsVup4VhLQ5SMMCvav6NEL66x/4OM4AbMe2/ilqjJMj2Fk2hApEB/XH71sShWlchRuwewxB7si2QOBUMhWjZlqvZBC8wgur7/gjvqHfo28tOmJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UZMRJxfh; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UZMRJxfh"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5v7L5tl0zlgVnN;
	Fri, 29 Mar 2024 21:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711748652; x=1714340653; bh=FRIggP1YvWWV3rj+5WU1Cj2n
	MoZrQOSbDSPE/2jMC40=; b=UZMRJxfhGcT0T96Sh8fG6r5sCE2UPPs7nlNwfM+q
	gfq1l5pwuLd42lx2YEmN5DO0wQS1M+xkYB8MrWOMjOVXT4rLWpkCv9SX+CBHnEZi
	3iM5iU7JqTbsQfHaFY0Yl2QYqSG/lQT4igNv9BfZWCsvCOGWOSso5twewHuMNzi1
	J42ZLqDhYc+/BcbMtn1li4F7G68kDvoBYA+dULjaj7InK3mM5iFnJooQ6J6yPFfR
	n9pI8MveqdiPsAUyeJeX0GzK/XpXm8h8J7eFFwYVhlc/3k0MUdzPgHiuWZLykzpy
	RWUE2z2TA3zzxIa6q6LvkIx6NJdyB99Gjd/SFAUZH/oNig==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LnAUL5f3l_Qg; Fri, 29 Mar 2024 21:44:12 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5v7G00xrzlgTGW;
	Fri, 29 Mar 2024 21:44:09 +0000 (UTC)
Message-ID: <1a3c1a00-e6f0-4886-9fe3-2f065556ada2@acm.org>
Date: Fri, 29 Mar 2024 14:44:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 24/30] block: Remove elevator required features
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-25-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-25-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
