Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1333636E496;
	Fri,  5 Jun 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780674786; cv=none; b=SqbfSI25i2LWvyk2ypk4Kjxb1lqVUNnaHHmD1mpGhLuVvzUmTIdpH931yLke2uahy5BbykE4J0lp4qoqXhVRAoPHr6NTErlT6F96SB2XLA9LSszrL/GCEuOmHDPCCJjpKTH7aC9kM+NKWC3na41ECtTbxfyQdWo+YSzZbbumryw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780674786; c=relaxed/simple;
	bh=GTb6c67AF4oCZZrF9Q1DL/gwJNcvjrIq+POfUH/zVxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ckn30Jraz6PoPt/NP/BvAZ4mTd+Jo9Ymkl/W+UvxIKhulfzOxqEuh4NHyR1KYbdKfNtDBIMVLhnmD7JRQaVfUVEg30DfnIuiMiZWtF1aknpbflUhVgXse6mC9p8hMz9R1zbCUZxXWumnfOtOvvlWJUs51xBUG+0rjuuXzxkyl1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jeQV7qwt; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jeQV7qwt"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gX5WG2Pqvz1XM6Jh;
	Fri,  5 Jun 2026 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780674645; x=1783266646; bh=Is8ak3A4P4itipqjcd35kcHK
	4KFis2JEU8EsBpqCNU0=; b=jeQV7qwtem72qdRiJbknyBQ+2lr8CFcQETaOZwK0
	kvzWgMnfVRzbKCZDgqAtjMBUHi/55C1VnVT0p4y6PU9U/Ev2YNRaxL3yXEiVCSqg
	lgnaMzH0NvqNB658w0VAHI5x03ckPoreBZlyKPtiaQ2uREYHCPfgieUStcfgHEai
	h7npJWxc9EDSdWbnRgzfVJ1qmH97x3ufnksiDgojJN4fwuLqwKdK20Rmrm71FmDD
	ZdhMKPjEZ12My0GVNaRPdTjAve957ywEGL703ytE7xww/KVNVQSl1SRBTBx0puWJ
	PU4kp03D754ievA9cRZygil6+oTILjGSpcsCFSaREreUCQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QEvqukvQHpgu; Fri,  5 Jun 2026 15:50:45 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gX5W72DDHz1XM31H;
	Fri,  5 Jun 2026 15:50:42 +0000 (UTC)
Message-ID: <6eedb86d-2e4d-4814-aed7-aedb5170df8d@acm.org>
Date: Fri, 5 Jun 2026 08:50:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: sysfs: Add WB partial flush mode support
To: Daniel Lee <chullee@google.com>, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, tanghuan@vivo.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260605093111.2530863-1-chullee@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260605093111.2530863-1-chullee@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/26 2:31 AM, Daniel Lee wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_partial_flush_mode
> +What:		/sys/bus/platform/devices/*.ufs/attributes/wb_partial_flush_mode
> +Date:		June 2026
> +Contact:	Daniel Lee <chullee@google.com>
> +Description:	This entry controls Extended WriteBooster partial flush modes.
> +
> +		======   ==============================
> +		0        No partial flush
> +		1        FIFO (first-in-first-out) mode
> +		2        Pinned mode
> +		Others   Reserved
> +		======   ==============================
> +
> +		The attribute is read-write.

Please change this attribute such that it accepts and reports strings
instead of numbers. This is more user-friendly and also will make shell
scripts that read from or write into this sysfs attribute much easier to
read. This will make this attribute follow the design philosophy of
self-documenting interfaces.

> +static ssize_t ufs_sysfs_flag_show(struct device *dev,
> +	struct device_attribute *attr, char *buf, enum flag_idn idn)
> +{
> +	bool flag;
> +	u8 index = 0;
> +	int ret;
> +	struct ufs_hba *hba = dev_get_drvdata(dev);

In new code, please order declarations from longest to shortest.

> +static ssize_t ufs_sysfs_flag_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t count,
> +	enum flag_idn idn)
> +{
> +	bool value;
> +	u8 index = 0;
> +	int ret;
> +	struct ufs_hba *hba = dev_get_drvdata(dev);

Also here, please order declarations from longest to shortest.

Thanks,

Bart.
