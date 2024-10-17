Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAFA1D040B;
	Thu, 17 Oct 2024 21:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729201869; cv=none; b=eJT/RcHL3c+dwo5xoQJI5gjhYsNjWriZueX/HMuOO+VVL+wETE1DO5WEEUIBMMxj0/yFePJcT6NYGSkOmHtIheUkMDq8rNfrVLca5DGk8qKBYGK7JMUOKpLXUjQ7rYLselm2YxNBq3AVEhvd04RTy9W+h/O3/Dq/ITAYEkPoVB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729201869; c=relaxed/simple;
	bh=OAXu+GDRBdQndCs0MSmYnE2vsgK7WxoumBkQ7nSqxF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JOihZanZo6v031o6LVSN0x0x2YPf5eRIPVYaO0qnxbQMOLXUqEF8KfK9M3uS720T2OUlwx6ItfZjZ7EiE9DbIMD8BoqtFwnuUeRzlirl1OqC216SSQE3a6NsXCwFVHYDFgTTuEShVHWbUMRteBkRiQt2sRw5EuK7+A2t+2Upw2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XZ5pgce7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XZ5pgce7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XV1k02mgNz6ClSqL;
	Thu, 17 Oct 2024 21:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729201862; x=1731793863; bh=OAXu+GDRBdQndCs0MSmYnE2v
	sgK7WxoumBkQ7nSqxF0=; b=XZ5pgce7jib6xpii8q45QUZwQGKG7dDEgOot+Va4
	Zy37KCikvkjSeuuczRqcgVsvdVM4lPxdrD1izycwCJzRfsHz5yp2553/IUElW4ri
	qoVSnj1k9nK+YKENDxgGvnjkWUqGcZuvsypygonoqy/RWkL70urZrHivSZPnS6R7
	5M3cL7lUkWMlQxRdD1YbHYNIGWDFzCRDBJkSjWTyzz5mGE2kwxXFNBIwBZj1vNll
	CPIm2FH8FEsJIGnGZYdc6txXGHwQ7zwZEctbGEmjK7lg7BCUFCkZMzsKJ3g3upZi
	FeTY7/zmkuI9aPKu8Yk98amcQ2DTYVMmTyqeXKnbHTmPsQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yv4EaZ-Or9kn; Thu, 17 Oct 2024 21:51:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XV1jx5P18z6ClSqG;
	Thu, 17 Oct 2024 21:51:01 +0000 (UTC)
Message-ID: <8dac373a-95ce-46d3-b63a-72187da50d3c@acm.org>
Date: Thu, 17 Oct 2024 14:50:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v2] scsi: ufs: Use wait-for-reg in HCE init
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241016102141.441382-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241016102141.441382-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/24 3:21 AM, Avri Altman wrote:
> The current so called "inner loop" in ufshcd_hba_execute_hce() is open
> coding ufshcd_wait_for_register. Replace it by ufshcd_wait_for_register.
> This is a code simplification - no functional change.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
