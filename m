Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75947345750
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 16:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769445931; cv=none; b=a4YvJbmRjIyblKr2listgOQlXmeSVRaVJnQWRr6mjmMOyH6PQzmxWUX8n7lX/EANiLZsklte2JPIrcuSCXmR99d6LUMvcMRhYaM5Y83zOgkDl/nHVe1IooLDAx8wCxpJgxbwpFv4h8RTDaq7dcFdXTOBkDbQDgsoHUfoXLv7zvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769445931; c=relaxed/simple;
	bh=6YUTtMSK5QpKz1xeaTlIaWeayHYCYeBtZ9F79Z3WDBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PqYDelJhjWlpEooIoQoqoYZKwVw1hYL82uvfvkEu42ZYeMabUdp37dSUjBWMB6F0n3KfEqQbeRJVrpn1DdfC/w6Ofga1kju39QeRgJpFm+99+kQ9q9LmsUDl3tBGNZ4SDaPKtNFOQzAUiptUhLw3xTtax1KX4m5W4tvss6RXt7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zUJ359ZW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zUJ359ZW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4f0DtH2NFJz1XLyjF;
	Mon, 26 Jan 2026 16:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769445925; x=1772037926; bh=6YUTtMSK5QpKz1xeaTlIaWea
	yHYCYeBtZ9F79Z3WDBM=; b=zUJ359ZW0m34aQAXARbJqyczBe7ICutf0sez2WP5
	fSBMSOlrKcdleHmj91wxyQMGbDAt+tRsshHeLPH6yQ0/zVaMNAmDrtep8f95+P4+
	FpdTq5WzcAdqVgf82RnFa5zzXZfbgafu6GjVZcmZwqk0EhIzRe1QvGZ68ikmYyJf
	zeJyyEoMO0s8aMOMvNJMFD+URunX/cgNs3ffRWr5YeFvT0WxjI6VKM00MY5ohr4I
	GdC58NNGtyD8XJjitBEryI3kdRRr9WMZ5/yyU3GC7DIo/Qyoa5O0QxsLInjLxqlm
	l6k5dz+17fnSF8CB9y89PWqKoWAGvunK1K/FWiKMpPXZnw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vCMQJIBzGK93; Mon, 26 Jan 2026 16:45:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4f0DtD36s3z1XM5kt;
	Mon, 26 Jan 2026 16:45:24 +0000 (UTC)
Message-ID: <fd406f30-d5b1-49b7-b387-fad10859f926@acm.org>
Date: Mon, 26 Jan 2026 08:45:23 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: sg: Fix sysctl sg-big-buff register during
 sg_init
To: Yang Erkun <yangerkun@huawei.com>, dgilbert@interlog.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: yangerkun@huaweicloud.com
References: <20260126132745.1830629-1-yangerkun@huawei.com>
 <20260126132745.1830629-2-yangerkun@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260126132745.1830629-2-yangerkun@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/26 5:27 AM, Yang Erkun wrote:
> The sysctl interface sg-big-buff will no longer be available after this
> commit.

This patch restores the sg-big-buff ioctl functionality, isn't it? The
above sentence says something completely different. Please fix.

Thanks,

Bart.
