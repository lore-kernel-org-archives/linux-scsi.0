Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004DC4778C;
	Wed,  4 Sep 2024 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725470859; cv=none; b=LlcJK1d2sLrvUZmsBcXUZYTZASLUDVTkx4+NDyk4/kxwyujVZCEVGg7u9zvjdexGEBvYrT8DiuUHVv0DQY2gWZVTxEL+FAqQfL6dnmKbjb9wxCOXZZADArkPV2Jb6dvpM67kK98CLzxuJEHojsxKzoTb9Umbw1h4DVflJALU2oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725470859; c=relaxed/simple;
	bh=VQ223ilrFFH7zKvc6PthtoYS7EGrHcAq9Q+MJXwcVVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9JQxRqPJHIgnXKk5a4V4hc8ud7wl0ycSEkuvj4egboSp+fXxD+lvF81TacEkWSyFK/GJPGKmyM4/HZZCIuCDysIBQ/Yl7y8FvUfqaNHUNy2+5XCpbfiacNPSdiX4D6wkjKYUfeNq0xV+VOVO9zJr3bYeAe3jAgC0p48BBCS6AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kOXDNfJR; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kOXDNfJR"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WzTqm1D9tzlgVnF;
	Wed,  4 Sep 2024 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725470642; x=1728062643; bh=VQ223ilrFFH7zKvc6PthtoYS
	7EGrHcAq9Q+MJXwcVVE=; b=kOXDNfJRgEcFWlU2caNsaMAIaP3vG8q/Y51siSCl
	mXxFNMtuZizXHtSC3DlhES+lU9DmoX1vIQjSR5Uoc9sNIKiLm/QJ1Ok26eAlENeB
	WbNjfTzvHmkjAQ8ANn5Ixgds5FrYJVO0niY6l5+90n47KthM+Pqe23qu7//0y64p
	baIBGzx7czTN5mLJcSBv7J+6oC9z2EB51/IVQsxLEcWmuhghKDN3yhzBqu+0uCbS
	lg2a/UTir15qF1UAMFXIjMdHYffrekueG0vzUW2IXsY68Jy4CHMT0X2ZITMvkQSk
	DiWjAUa1X1pFEjOo02moCZzJKctsLaBpCM7+FB/a3YxFMA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SI-Aex0YBMhJ; Wed,  4 Sep 2024 17:24:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WzTqj0TC1zlgTWP;
	Wed,  4 Sep 2024 17:24:00 +0000 (UTC)
Message-ID: <ea4c9e8d-e34f-4488-b3ed-3c78401f0837@acm.org>
Date: Wed, 4 Sep 2024 10:23:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: Fix memory leak in open_getadapter_fib
 function
To: Riyan Dhiman <riyandhiman14@gmail.com>, aacraid@microsemi.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <bf6746d0-d8cc-412e-ac7b-6f17c3e3de9d@acm.org>
 <20240904045820.5510-1-riyandhiman14@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240904045820.5510-1-riyandhiman14@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/24 9:58 PM, Riyan Dhiman wrote:
> If there are any other methods, additional checks, or potential
> issues with this approach that I should consider, please let me know,
> and I'll make the necessary adjustments promptly.
I'm not familiar with the aacraid driver. I will let someone who is
familiar with this driver answer your question.

Thanks,

Bart.
