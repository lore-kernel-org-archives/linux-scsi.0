Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E2C13BACC;
	Wed,  7 Aug 2024 20:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063723; cv=none; b=orEgkyU+EjurRb02Be9uJdVOcRdmuM9FqOWWEPc2rgYkRR7ZSRV6D3bEZ9sl1n9Si4AYSAEN6p0dcUXvr2rqFU2u5yn8FTs2MawYTEtR8aEr8Ugay0oBgAEBF8hTw2lmRj6nXH4RFBQnV8OYc0qy+U6riZpij0VdQa8hytxL2DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063723; c=relaxed/simple;
	bh=6RLZhYyVze7Qf2dpV9zJ9RB9FVEijxyr7/i9fW3b1bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SwzeYsWKXKLcmuF/ZpJLFKx9D43s4VWyxzkITO7uDUx3v7T/K6pw9V4YF7i64LrTm6bUQykQ5OpnFQbSFEm6+fv9JXPJp2mqrDq2nBsj6HsjhEFTS2kYZBaUDcNkUIN1RfL0oEGAD0mSInaytD257gtT3iy5353dFrdm+BziAO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Az5T4qvP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Az5T4qvP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WfMhn4GWpzlgVnF;
	Wed,  7 Aug 2024 20:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723063720; x=1725655721; bh=6RLZhYyVze7Qf2dpV9zJ9RB9
	FVEijxyr7/i9fW3b1bg=; b=Az5T4qvPE0ZT1iRRAyrAXWsSavkMRPyCA3KGXMmv
	780DU0HuxwUxwcsSNwkCrT03jcrL9klGoCtiBwNt3ESCi4Po/DZVFy8BifdkIivG
	hIwyhe/AWyVeZ3vZk7CEfPHpM28l5skIo5+qbHmr2E3jo6n1BjnG4QNkilyYs2us
	dxTU0Kx7mF8471IPFMB6zMAUzJPUNPG2up/0pVSWuCHUdtWZD+g3gCHIPkzmpRAo
	oaB26wRfRMZihl1CquhNNWqpGrn4goAMOAn2g4AgADJRkQ5iklP3eNHN0RdJslwL
	06pDjQl6BlCvmV9FOQqZF42SfuZTYIoVkmySPnanIYi3bw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RIj3ivleSjip; Wed,  7 Aug 2024 20:48:40 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WfMhl29qSzlgTGW;
	Wed,  7 Aug 2024 20:48:38 +0000 (UTC)
Message-ID: <9e71721f-9154-4c52-a87a-55a60d1db16e@acm.org>
Date: Wed, 7 Aug 2024 13:48:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: Prepare to add HCI capabilities sysfs
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240804072109.2330880-1-avri.altman@wdc.com>
 <20240804072109.2330880-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240804072109.2330880-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/4/24 12:21 AM, Avri Altman wrote:
> Prepare so we'll be able to read various other HCI registers.
> While at it, fix the HCPID & HCMID register names to stand for what they
> really are. Also replace the pm_runtime_{get/put}_sync() calls in
> auto_hibern8_show to ufshcd_rpm_{get/put}_sync() as any host controller
> register reads should.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
