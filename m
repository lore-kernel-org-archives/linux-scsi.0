Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC6517BEAB;
	Mon, 19 Aug 2024 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724086461; cv=none; b=saC9B6MGzr5+ZLpUQR7ZVWDFCGb32xs6ISaiovUNliXFMiJ4p1+eWE2uitzQWj7MhQPVIwouWW871yO/ZDC9kdEO/2tPp7m+IBqgt2NUTBzmwdBdaLgm9iG6PK5QSbHRGQxWuyZ7eyOq7twXMVzWaRZVGpVER1gKU6kMZixDLN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724086461; c=relaxed/simple;
	bh=/fSVMu+aj3+s0ExFhJfpl2RJAv7DxAo7zEmOtyTG6Ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=squDzQ4Kz7FFsaYhOBrO9E6IUXBS5mczsBJNG0FJqGlx9Epg1z66I3nw4DaBFc9xXv8wF4dIyOGWFu6KG9zS9dHuer7E02a0wsBQL6ItzdwV5MmcDHeguceuNcc2g76wUW1L5PxoTB6wvkktVtf/b93dbykBA0byeq0HdXH/x+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dFw4dKyT; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dFw4dKyT"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wndwj5QXTzlgVnN;
	Mon, 19 Aug 2024 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724086451; x=1726678452; bh=/fSVMu+aj3+s0ExFhJfpl2RJ
	Av7DxAo7zEmOtyTG6Ik=; b=dFw4dKyTQqKhJuB/lWOJ/HeQNX7FIPYOxm/A0I3U
	MlXrDdCb1nNPPgCxs6Fbldi6nhjbTrlcdNKfhe3OuLuZhD7cRLVErsuJ5ayAF/r8
	Kb6abm32rPpdzugmXVuqOy09LC1UCiTnHTQuyOeSaVIzF8d6yTNZNvBt7tsuonXg
	yZ4xpx8tFrK3If8HSIY4yfM8kuS6d130CtQDtvuRRn+LTjAcpDiS7niEpXhsWdNs
	+FmZLXad+dSdfVfZuOX7f9Gxn1cfKPQpJQ1meDOKDYyy8oNjikbkOpu4Km2NFMUQ
	4s2/k8gKQX4Dcg8uf6vw4pm6xPfftmDq+2I1R7vefmbbQg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Byc-qIFUWr-p; Mon, 19 Aug 2024 16:54:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wndwd2lL2zlgVnK;
	Mon, 19 Aug 2024 16:54:09 +0000 (UTC)
Message-ID: <099752c2-9cc2-43ef-8b97-56d26c148c88@acm.org>
Date: Mon, 19 Aug 2024 09:54:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in
 progress
To: Damien Le Moal <dlemoal@kernel.org>, Yihang Li <liyihang9@huawei.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, prime.zeng@huawei.com, stable@vger.kernel.org
References: <20240819090934.2130592-1-liyihang9@huawei.com>
 <c1552d1f-e147-44d9-8cc6-5ab2110b4703@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c1552d1f-e147-44d9-8cc6-5ab2110b4703@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 3:57 AM, Damien Le Moal wrote:
> The patch changed significantly, so I do not think you can retain Bart's review
> tag...

Agreed, my Reviewed-by definitely should have been removed.

Bart.
