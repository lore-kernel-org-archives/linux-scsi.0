Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7651B6CF6;
	Mon, 25 Nov 2024 17:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732554637; cv=none; b=pIf7fIiJumidRPB7gqS6H2JyHpRmpKxM62byVhrNg4tlGOGIp2EE8C2yd9JGG946CU/CJ005ygLTJ6dfP3cojnAvsRk85e//p9Vn+ApDf8SnwqVBjZrsZjJb6AwgeZB/GT8c2vs4U5HoDEGwOCcE5332JV0ozyd4w+KMddW/4MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732554637; c=relaxed/simple;
	bh=cj+HMKcxAo6ea9PsR1ldtbVsh0QtUHnZA3wJCOQGVYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=COXzB9u+9ZMn5fd1Aj5BMmM6kAeKXqsy2CZPptCoJeOvmX5mvm9skAtg7CNE0OeX5QnvMU4FBXrOizocs9CjkN3Js1QEFYQYAFEvxiCylxDxsB1OA2o1+ziG9kjawZqXlcv6fJEMov/28DA99F1SNzb22bmUZWLsQFP/WSeSU/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xaiIaFMs; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xaiIaFMs"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XxsfD11Ktz6CmQwN;
	Mon, 25 Nov 2024 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732554625; x=1735146626; bh=1xXYfeHDmQD7lN+JEXoHpAdw
	TMBc6OzR6oQxDn6iVU0=; b=xaiIaFMsftYhybqnaBBi0qPlPk57G59pTM/Imrwg
	huvGO6ZirzkFF4LaqXkCnBmSm4n15EmoTW0XQF1gA4J8XpvIxnuuwO5joR8TNMcO
	ZGWmQA8LPfkqZXa8uNmPXb6Ed25uIUJd/e7pwq3DpWk4xYzAC9w2j1DP55kk0YL0
	6kXGLlfvNhZ5CVvutiEIW/W6Xnnzhur5Fr/E4HEagny1+w3H9sldjm8RXIY7DCbm
	RvW0u9++WCr8q2Ca8KypCVfwExAbHo9isCJW1mmTcqhHv92/ccebXYNoQne70tn7
	oEaxATCrvf9HGLhHtv/oj22cYEkObU5khsLlaTOPnHBQ6g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TIc9B_qgRoFI; Mon, 25 Nov 2024 17:10:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xxsf66nFfz6CmR09;
	Mon, 25 Nov 2024 17:10:22 +0000 (UTC)
Message-ID: <b0917952-c5ab-4774-b232-8b626a7a3b97@acm.org>
Date: Mon, 25 Nov 2024 09:10:20 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix link_startup_again on success
To: Vamshi Gajjela <vamshigajjela@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241125125338.905146-1-vamshigajjela@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241125125338.905146-1-vamshigajjela@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 4:53 AM, Vamshi Gajjela wrote:
> Set link_startup_again to false after a successful
> ufshcd_dme_link_startup operation and confirmation of device presence.
> Prevents unnecessary link startup attempts when the previous operation
> has succeeded.
> 
> Signed-off-by: Vamshi Gajjela <vamshigajjela@google.com>
> Fixes: 7caf489b99a4 ("scsi: ufs: issue link starup 2 times if device isn't active")
> Cc: stable@vger.kernel.org

Shouldn't your Signed-off-by come after the Fixes: and Cc: stable tags? 
Anyway, since this patch looks good to me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
