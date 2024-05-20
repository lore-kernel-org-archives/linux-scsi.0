Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8788811184;
	Mon, 20 May 2024 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716229082; cv=none; b=ZHZC9gA/sWvB4SmPvQXK6F0IPNwNAshwZb1ypOKoXk03mIr9z4SOARrVAG+Kdh2EcloNiKZIh0UuqvcewFiAOCLPvkCwMz8QQp7zmAwbeuR/wuu6qdYip5howCv2L9xl4Cr1F2dGfAgGUjm6MtqHpIPjcOtdZ0WZJ0Gxx/MdJ1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716229082; c=relaxed/simple;
	bh=WcCO4d4GjlDnujm5kCtE0YKhrxDLCETLwxLDlOuPbqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PhpcLSxUsMMkk5twNIGseo3HZ4ePqq2/tdrFXnLI9Sbu2lxcHoYPBHgOk8ZHUU7+cG378AgkNbaE4YT6ZFFDUm6KpGD1eeVV74QTnVpHhRjS5trVCcKRQFwDda/6Znpv7YLg2eLE3qyVLZMmnd22fffT6tzNHcSSi0/zWh9J2nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cHhZJ4hM; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cHhZJ4hM"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vjm5N5ChXzlgT1M;
	Mon, 20 May 2024 18:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716229078; x=1718821079; bh=WcCO4d4GjlDnujm5kCtE0YKh
	rxDLCETLwxLDlOuPbqg=; b=cHhZJ4hMoUTCe9Qi5Mxc0gbPMrAe6wONUikfFIC3
	pUxlx3uwOmWQ6SZ3uVLMOWOaB71WQC50vnRIGWP8nXBQDNbnPgGIAb/CAhxdjxnp
	SbZ1O/fRW/t5HvJw06H0ftxz5Od3GuxrwNc7rU6ZKTKECCtjhnSxM0HSU+KR+ire
	VI3MG42ApI/t4PaFpDTcQmX0wbcRTUcMSlxwhDei0i80Bn198+TmYUwd5Tql0GVa
	wMHyJyI+ogyGax9Eb6MDVOkh7YfxewrYCECfGrbGG7z+Ldd13vRPK7mVA+8UkrxA
	ZB4tCQQwssqxJMYaqsdH0WB4dQhqlHQ72+uwDyJIfEWPYQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HJPHqkP1405j; Mon, 20 May 2024 18:17:58 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vjm5H6xVtzlgT1K;
	Mon, 20 May 2024 18:17:55 +0000 (UTC)
Message-ID: <84c1e98d-1217-4956-909f-d51fdf2f555e@acm.org>
Date: Mon, 20 May 2024 11:17:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ufs: mcq: Convert MCQ_CFG_n to a inline function
To: Minwoo Im <minwoo.im@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Joel Granados <j.granados@samsung.com>, gost.dev@samsung.com,
 Asutosh Das <quic_asutoshd@quicinc.com>
References: <20240519221457.772346-1-minwoo.im@samsung.com>
 <CGME20240519222607epcas2p1c485b3cc264fdabc2c1e90daf228664d@epcas2p1.samsung.com>
 <20240519221457.772346-3-minwoo.im@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240519221457.772346-3-minwoo.im@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/19/24 15:14, Minwoo Im wrote:
> Unlike the previous patch, this patch does not fix any issues, but,
> inline functions are much more preferred over macros, so this patch
> converted MCQ_CFG_n macro in ufs-mcq to an inline function along with
> the previous patch.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
