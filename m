Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994079474;
	Fri, 24 Jan 2025 17:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737740861; cv=none; b=pRCmK73VBsSkK5tsxX1wutlY9LySVRlOnVa6k0TUAzj0/4b6bS5Ud5n/VBJ3SoVvvNkcxwWUzFTILec9JLQUJVkV/4PUN9QEVMh8byBrqEoVyA2q5xAPTBeO5jHZaA2C2aBocyWKcZ2x9epEeIl42e9dGQNeugvMjadtcVOvd08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737740861; c=relaxed/simple;
	bh=tpCIcYJTaUk+0L8O5ArB9k1NAWcvl/RKS12uOYUCAWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UM/22ljRqtLay+dLzfUuLXi1G8gxaKZTJFLCVig8nl1ug5Pv+kEEvIjuKvqKNbqQ9MclkHZglTzBYDZDxK0/gsqfbCyuasos6D+/MLXyxbevBujAGwti086Rrn7UtvJkd7u3PQziyOgkOYUa+MYPiKeXFFQwrDhDQXbvytccEl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lPnT8H/l; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lPnT8H/l"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YfldQ6RT0zlfw6Y;
	Fri, 24 Jan 2025 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1737740856; x=1740332857; bh=Ld5kHpG2gBgJLSM33vlzXDoI
	jgQrRN7+yd07klLIZgY=; b=lPnT8H/l1+EJ5JmuktzpJeg84TdDiLccJU9fX1qT
	Hdi9PZX9YsOHMggeWUp//t0YYJNByJAyQwQPl3nZt77o3CfIGz/wbtbaSEZcX1xC
	4gTDfTlPobpibRQBji+dRMyVjIm9j62/toykxNP40WKm06sTftoB6sfB7uMZnOdC
	NFiBtDQ7B8vbMACtHKzKlYDudsaWE+uhWs1mMdL+NIcyxgz3VTxOvYZQWyqOPzA0
	uYlIRKgnNgaJXbfHZcpTrL5T/7eY+/Y9xkU/b6MjgOGccjLunXao+UA9cRM+q9KF
	iJfOYUBlvcW9OYg0SQ7g21y79A8WE3J/VeZiwTkrquMVQw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XPMGmh6kyU6a; Fri, 24 Jan 2025 17:47:36 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YfldL71wKzlfw6L;
	Fri, 24 Jan 2025 17:47:34 +0000 (UTC)
Message-ID: <4bd2757e-ecc9-481c-b8c7-12fb68e0f526@acm.org>
Date: Fri, 24 Jan 2025 09:47:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Ensure clk_gating.lock is used only
 after initialization
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
References: <20250124073354.3814674-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250124073354.3814674-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/25 11:33 PM, Avri Altman wrote:
> +	/*
> +	 * Initialize clk_gating.lock early since it is being used in
> +	 * ufshcd_setup_clocks()
> +	 */
> +	if (ufshcd_is_clkgating_allowed(hba))
> +		spin_lock_init(&hba->clk_gating.lock);

Initializing a spinlock is a very fast operation so please do this
unconditionally.

Thanks,

Bart.

