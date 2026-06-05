Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380D523A9BD;
	Fri,  5 Jun 2026 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780674099; cv=none; b=I0iNvNq+ENkbT2eucylPJ5GfzADg9R5v+mf9nYvzMydPMCm9fgh3r0K4/zQJzBMtlosEAyTzrKxR5WqrfjZcarcZzgcbNjc7SP0dgXedTk2YKgBy5P7ALN6eMjqffZiwHOG4Nj1DLrGHVdBO4aoW8q7wk/6FWLDdZiKcC8QKAS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780674099; c=relaxed/simple;
	bh=fC3mWldJ9zHxzN2feLr7pCgiRGPbV20NQ1bEZNatC70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rI9gIkcnrpzKkYY8LdaNvHvGV3+PL0X3jk4LeuP66/RVsN8E18Yj3ZpoHVqOugM9ubzAfzhtBbUYJKZh50Sz99FC6nXTFgfYGMBWJGovgoMLR6Ghh2onW/81oQOLW9I5ytef7nU7S9BJ2/ecf7ueZ9d6IP62BTizPyNdraFmvGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kWTnW280; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kWTnW280"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gX5Jd4H7pz1XM6Jh;
	Fri,  5 Jun 2026 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780674093; x=1783266094; bh=fC3mWldJ9zHxzN2feLr7pCgi
	RGPbV20NQ1bEZNatC70=; b=kWTnW280v2mp8Xy1dUy9kuTipo4RuRIwH+olKwYY
	R3QQ3Q02agRWIgKZk8JmafR1qLjuxTy3O9jZsuASjZTkvbZ84He1P0kXDaV2keJy
	Aic4vuh9r2icPPVor3Ui6eSY/u5W7jt//DVzNhGsNJdjFTb6FL7qrojWa/Nfh6vU
	8HhUvOJi5NdvETyTbToCEHYIYcLIWX4civYFUVN9yOOy/JPkLmlscQLmjLzpklqd
	bJjyc03ZhQqnhjtclP8XO2AQe2fDN7kmPU+T867lWVzptIVc4QogIFpMJ+yMDTD2
	XGGQ4DZFG3r12qeVpUzDIrus/ri3UNMAZ3o9XQQxtP70+g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 26JwbLehYw2Z; Fri,  5 Jun 2026 15:41:33 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gX5JW4V74z1XM31H;
	Fri,  5 Jun 2026 15:41:31 +0000 (UTC)
Message-ID: <25196210-4524-484f-a7e2-52eab85041d6@acm.org>
Date: Fri, 5 Jun 2026 08:41:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: ufs: core: handle PM commands timeout before
 SCSI EH
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/26 4:20 AM, Hongjie Fang wrote:
> A PM START STOP sent from the UFS well-known LU resume path can race with
> SCSI EH.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
