Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A93523FC41;
	Tue, 23 Sep 2025 20:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758659334; cv=none; b=K5QWablJVGvnmLnZuukWHVK7anD15aGvTXb+xqaBjN2z9JafYbKh49bZGkIAOBkN7xVKl+gnBYYRtQ2KQxZZV/Cbz70pNK1lqYNsH8FX6LCWFYDsRxs1nSj0u9qCgNcxfTkNXn174OPove2E8kG+2pH5KcT/1F3Us2TBYJJxuHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758659334; c=relaxed/simple;
	bh=yiU63abRGWfLpfyD9YYpbjz/dDx3dhleRdL4nlw520U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Va6zRNfj7YRg0hDXcqCG3orCdyKXzU7eC5GGcgfVEYFCq/7+kwgMltRMx6t1CR0qIJo/Fw3GreqzLW/qLda154W0YD6BUq/ogC7sqNI04lsyWRYynJORRzK15B2FsqUY2YkbMbzLaXoTjcr96971zCQ5yRSeaIN8FFdhwS3E2cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OeZpZFjY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OeZpZFjY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cWWlm1prSzm0yTk;
	Tue, 23 Sep 2025 20:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758659330; x=1761251331; bh=ufOlNyaaTNIiVqgbAZ42UXrc
	fDNI/I8viZfGBTgBA0E=; b=OeZpZFjY7qrsCfCCsm/QdYWhQqrXLV+WQTGZdv3f
	Mb4/2aSnk9RvVesMDGal62TI8yVDojzwcoPOq/g54RscmIDwrAQxhRgY7PjcBMW2
	SE26/OxwFTbNaGYa2eHbiRYUInigicYzYn/CazVp2xV+a/WVENixL9A9pHelwMM0
	Uq6xGrxSXigxTuEdASK94LRcZFCgXMRnyu5MCMDzB8OeFRDVBYSC+25xrCY61VDO
	WhftRmwd0xLaPw0DqUmMmaw1a82OMYJ/btQZICmx815oEeD+iIaSHu334ugRlBUP
	fUAXM3d02Mnyd3CH82F+NuKCJVzMSDdOIkdjuscL7sI0oA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b9k100kL-Z7a; Tue, 23 Sep 2025 20:28:50 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cWWlZ3Fjmzm0yVJ;
	Tue, 23 Sep 2025 20:28:41 +0000 (UTC)
Message-ID: <a41bd12c-37c8-46d0-9fe3-c9ef0ca7cd95@acm.org>
Date: Tue, 23 Sep 2025 13:28:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] rpmb: move rpmb_frame struct and constants to
 common header
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com,
 jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250923153906.1751813-1-beanhuo@iokpp.de>
 <20250923153906.1751813-2-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250923153906.1751813-2-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/25 8:39 AM, Bean Huo wrote:
> +struct rpmb_frame {
> +	u8     stuff[196];
> +	u8     key_mac[32];
> +	u8     data[256];
> +	u8     nonce[16];
> +	__be32 write_counter	__packed;
> +	__be16 addr		__packed;
> +	__be16 block_count	__packed;
> +	__be16 result		__packed;
> +	__be16 req_resp		__packed;
> +};

I think that it is safe to remove __packed from the above structure
members since the size of the first four members is a multiple of four
(196 + 32 + 256 + 16) and that is sufficient not to introduce any gaps
between the __be* members.

Thanks,

Bart.
