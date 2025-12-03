Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C812B85C4A;
	Wed,  3 Dec 2025 00:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764720273; cv=none; b=aqzdna9FZuGlhgBNC4TMp8Uqsnv+Y+pEpPjiKocVh428ST9dH8fwtL9kXJVP1fM9Xiu3afeJ/X6Vb85rnzp1CRdPOd5rRGtk1C926Kw+ZD7AQ2SF9ZKJqCsCPQcFPn141vP9I101iFu/VBR3NdOqVTFs9rhtWbSCe5a019UWQJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764720273; c=relaxed/simple;
	bh=wdxe9EoLeTy7TkeRpgjpqb5/WO5fnmBbehoh96CwgMA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qg248D0ztb/9nBMkrKyXIcb9ti1um+x7w7T+qPYcoy0i+qs7bcJwuh54H4yGxY7roB6s0F9Dpg1nyBVuPCu7XNJ6E92gCKLr/X5b7tqXdEsRneQjYmkHtoJaa7+2fy3uj+14cxva9vhQvY9GPMLaXdSH3cKtEDuaRflx5qlYjEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YYCH/k7K; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YYCH/k7K"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dLdD90tH6z1XM6JZ;
	Wed,  3 Dec 2025 00:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764720262; x=1767312263; bh=wdxe9EoLeTy7TkeRpgjpqb5/
	WO5fnmBbehoh96CwgMA=; b=YYCH/k7KEeHST7OveQfSdn8xSwUvaaEAfDWafe5y
	ptId4mj934Nkc4FerSeP8tp2O9og49pN09LWK3QqvOtu7CVV+EfBwKqRymZcILPL
	CaInE+Z7Y4SDSSLXj2eNCbpMO9nXmyvKLOMgNEqISEr5xn5ozxAWX8ZyMPxpGmWi
	rxJqeWTpYIKsRPuzJg2uObOeDfbuwk7Aa4rcGxsLUtgGUBSVJ66124DpVVhrUokE
	dCkpF0+RoZpG5VeaEw5z95IEhq0Nqip9a87XmMH1Acf8Q4yGpvJefGMrMCH4nLPZ
	KG798c8MM1RjzXa1aUoDkI++Qn/2R+HEHv+2K1HvY3HPYg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id crx1881cYJyX; Wed,  3 Dec 2025 00:04:22 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dLdD148Y4z1XM6JX;
	Wed,  3 Dec 2025 00:04:17 +0000 (UTC)
Message-ID: <e5c1974c-32b8-471a-a84b-a3ca7eb0fd3e@acm.org>
Date: Tue, 2 Dec 2025 14:04:15 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] scsi: ufs: Fix RPMB link error by reversing Kconfig
 dependencies
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, can.guo@oss.qualcomm.com,
 ulf.hansson@linaro.org, beanhuo@micron.com, jens.wiklander@linaro.org,
 arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <lkp@intel.com>
References: <20251202155138.2607210-1-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251202155138.2607210-1-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/25 5:51 AM, Bean Huo wrote:
> Fix by reversing the dependency:
> - Remove 'depends on MMC || SCSI_UFSHCD' from RPMB Kconfig
> - Add 'depends on RPMB || !RPMB' to SCSI_UFSHCD Kconfig

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

