Received: from 002.mia.mailroute.net (002.mia.mailroute.net [199.89.3.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F23D1FDA7B;
	Thu, 20 Feb 2025 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740075732; cv=none; b=GSQ6x2lUeGlnKbw4/I3iLI1XdlnPijwACJPWX5115FxX9YtXAVPGYObJZImZWC/gQbVVpJekvmv1EmjbCtq+0zM6RUg6er2JZMiWMpFi4s6AY5mXMOHxAhydnsHPpCjjTajgf7OimjdRe2nDZgxZSie+TrSiV89a2CavRXDRz9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740075732; c=relaxed/simple;
	bh=GZ9DYRJtXmpYNoZ0Zr2wuHSHsXHfWJn5MwuhpvusXZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPL64BFAonm6BjgZQk0ZBFy6nlSmREAZbTMlVgqVcKvQVI7iAdVZJdud3Yqz77uVjBAfDElMT7/vKOxtW7rOZWNlxd7/xop996vwp9slY4wLJjgs8vXV0B1y2x+oipcRjuwFeTq/DfzrOk78Ucoh5ifJOO1oZ6HgVQTOyrGSeNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S+ZXlOJ0; arc=none smtp.client-ip=199.89.3.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S+ZXlOJ0"
Received: from localhost (localhost [127.0.0.1])
	by 002.mia.mailroute.net (Postfix) with ESMTP id 4YzM6n3DYFzlsBHJ;
	Thu, 20 Feb 2025 18:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740075728; x=1742667729; bh=GZ9DYRJtXmpYNoZ0Zr2wuHSH
	sXHfWJn5MwuhpvusXZ4=; b=S+ZXlOJ0gmXY7kAQulKLB72OqaX+ZvcqK44Upkuj
	AozDe2rULJUMJi3Us4tVTd0YJkLXDBUI22nBNiVUE4OVRqb8kzqNZ5XydbPDE7fg
	+NEdakKoqnJfPqgBbgPq9Olv97ekmg8O6vrGKuliRxQz3nzW0mvrDT/NHdRJldZw
	FA48Y1kOiln9j5ZfCcVDBJGiJhMdOPVz7bx7PhKmFmK+mkDHjXSSDdHKlLcuav5m
	brgyCqIcvnw9Rp8waPWvE2LP1xmnOg7h9bFFR1woRac5N/z4IT9uks0grEo+DtlC
	ybj2+9LFsI6uHBjA3px6061Vh/1d5tbP2SpNWPjNqB3B+Q==
X-Virus-Scanned: by MailRoute
Received: from 002.mia.mailroute.net ([127.0.0.1])
 by localhost (002.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s2Cv44KpaZnI; Thu, 20 Feb 2025 18:22:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 002.mia.mailroute.net (Postfix) with ESMTPSA id 4YzM6T6B5XzlsBHH;
	Thu, 20 Feb 2025 18:21:53 +0000 (UTC)
Message-ID: <3d65f52f-6dd8-4a4c-a797-6d999902ec74@acm.org>
Date: Thu, 20 Feb 2025 10:21:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ufs: core: bsg: Fix memory crash in case arpmb command
 failed
To: Arthur Simchaev <arthur.simchaev@sandisk.com>, martin.petersen@oracle.com
Cc: avri.altman@sandisk.com, Avi.Shchislowski@sandisk.com,
 beanhuo@micron.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250220142039.250992-1-arthur.simchaev@sandisk.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250220142039.250992-1-arthur.simchaev@sandisk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/25 6:20 AM, Arthur Simchaev wrote:
> In case the device doesn't support arpmb, the kernel get memory crash
> due to copy user data in bsg_transport_sg_io_fn level. So in case
> ufs_bsg_exec_advanced_rpmb_req returned error, do not set the job's
> reply_len.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
