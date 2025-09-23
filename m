Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F2329510;
	Tue, 23 Sep 2025 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758646692; cv=none; b=eTl5CkAo6fodLjBX87cKV34SefYOJJbrawv8egmngqsjHCVU6m76JIvnsnOuIOr7p4+U2rH6Y9Nsa1gNPqM+WUV1qqrvRP6vOLTpu+dltiIP1fLKj5m1EBWKxMntpfQaZ6qf/hZH7mDbgTF+E2NhCBLxJkHAhV6Q2lRxKloWnv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758646692; c=relaxed/simple;
	bh=JuBJNdGSRNy+myW/r2wscOprKMlVhdWIjyBH8tEVnwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZiD2KWvhWm0vKNWA5/gB2bhZsW0DonyHqygKjYHXKRK9TEKicNm5Mci2JiVwZzg3WgRHC0V2F3ZLppHMDWFj/t5IcdEy6/HA/laKsl1Zk5CTIbO3YDOqnwKv16OMszahDQaXoj3sU7+KxTkugc+Fm+J3uMTLTFOVblGfS1D++gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WKKoM9g0; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WKKoM9g0"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cWR4d2Qt5zlgqVL;
	Tue, 23 Sep 2025 16:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758646687; x=1761238688; bh=qGMTWMmkPNTFWfgPhJwvLkFh
	aWNkj/2pQAyAO3WIAlc=; b=WKKoM9g0KnKB8GRsb+ZY4F/UYnX7NprEV4V7T2gq
	k9AefZQlCWgr20KB4jmI8uNDORJRiIIwarNEKMTUFtwpls7IAaCfqAXC+6nQKVt7
	5I09dL2pkk1qB12fldU9HDpNBrA+GK53Ky0tz62VTccOQHYQqp4F1rRYVXeF7yk6
	2lcLJtll221gzY0KTE+3i/Sa2gR0IzQDjClqDM7MmOur9ZUkUXK+VLalGtknR4R5
	rrtqZZTNzXEv4GqjZ+TGm7WcUjP9VZcAOlL76PqcsPbn6pkVXJe/JezyUzQIeMFw
	Pn3ivQS02lnTtFQmyauNub4ASiihdQYmGi7en2pPhamtgA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Iy651mq5vBZB; Tue, 23 Sep 2025 16:58:07 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cWR4S3TLfzlgqyp;
	Tue, 23 Sep 2025 16:57:59 +0000 (UTC)
Message-ID: <5bdf63e7-9b57-44a8-8816-c4d0aafc51e1@acm.org>
Date: Tue, 23 Sep 2025 09:57:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] scsi: ufs: core: fix incorrect buffer duplication
 in ufshcd_read_string_desc()
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com,
 jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250923153906.1751813-1-beanhuo@iokpp.de>
 <20250923153906.1751813-3-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250923153906.1751813-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/25 8:39 AM, Bean Huo wrote:
> The function ufshcd_read_string_desc() was duplicating memory starting
> from the beginning of struct uc_string_id, which included the length
> and type fields. As a result, the allocated buffer contained unwanted
> metadata in addition to the string itself.
> 
> The correct behavior is to duplicate only the Unicode character array in
> the structure. Update the code so that only the actual string content is
> copied into the new buffer.

Please add a Fixes: tag. Otherwise this patch looks good to me.

Thanks,

Bart.
