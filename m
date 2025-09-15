Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998A02BF3DB;
	Mon, 15 Sep 2025 21:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973278; cv=none; b=pE3/rbME+wM6efr7TRmkVXZiqf4i3395uupcW/a0j0GNNo9jjhDGOZ+DOGEhIUaD24NpUrR8Y6JqiSO2cMBz1CBR5FQWrauwaNP+Q+8vwVphJCmV+0S4ljP3rDfHF3kynPN5VrqjttQofhrBwDXtGYvxHQqhQZjJVWG2ghGh2eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973278; c=relaxed/simple;
	bh=kbZ7upIDAJD3qhDFaEgG+y8U+O94mlSAKCKPk+PCI1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hj1eMpj3SBxMhfPR6m72+7YS8q5bCV/wp8o9Jf0bSDCb8ZzkgBY/1i0gTxrnyF1lPF0sgS3SgeCfpt6DRvPfpokcSI5pwYegGkzcNeQ2MCJ69SnAtY6hCDI7VwjhzqNfVJsrUFnzT/gh9C8NAYbAsJs1xK5qGPIVAJSHYQ1ZXwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dpL5CMvh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dpL5CMvh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cQf2M2j1qzlmm7r;
	Mon, 15 Sep 2025 21:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757973273; x=1760565274; bh=R+kcM3pLII5mpY9mDrvuj97C
	HKchQZRshdWNWIe+NKk=; b=dpL5CMvhRExQnmNj+emy0+4zsewG0zsQwF3NiNHS
	nClaQSu/7fLJhZGIpzABAXSLJGhtU/c0h135+NTQsI5ia4kilxugSrMd7PeZkaba
	wjzxwT3zFitTEAFix/2k0l4M1OexGxRmyiyBkKngAMWIL0dJ2X0CgRQ7yFTuJFgf
	JYczS5iDRj0gKUspR+RVmq7ZXmJEL89o7sGDVnd5ZKfKXvmgL+qdHNn4ZPHpL+FY
	XYf8iWwPilheblEFi9b+aFzfe+fFYUTZ3xBcQMkojW9Ce8xUImiBnZUk7+MaWPiH
	QxKGeurhUNleoDDku95igrleiHBfe9OE6k/kSJGxDyuWfg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id biPJNzv5wKpO; Mon, 15 Sep 2025 21:54:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cQf272Ct7zlgqxs;
	Mon, 15 Sep 2025 21:54:22 +0000 (UTC)
Message-ID: <eef5d4c5-c2b4-47e4-bd29-3cd6faa39dc9@acm.org>
Date: Mon, 15 Sep 2025 14:54:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/2] rpmb: move rpmb_frame struct and constants to
 common header
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 mikebi@micron.com, lporzio@micron.com, Bean Huo <beanhuo@micron.com>
References: <20250915214614.179313-1-beanhuo@iokpp.de>
 <20250915214614.179313-2-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250915214614.179313-2-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/25 2:46 PM, Bean Huo wrote:
> + * @stuff        : stuff bytes

The above sounds vague to me ...

> +struct rpmb_frame {
> +	u8     stuff[196];
> +	u8     key_mac[32];
> +	u8     data[256];
> +	u8     nonce[16];
> +	__be32 write_counter;
> +	__be16 addr;
> +	__be16 block_count;
> +	__be16 result;
> +	__be16 req_resp;
> +} __packed;

Applying __packed to a data structure in its entirety is a bad practice
because it prevents the compiler from generating optimal code for
accessing multi-byte members on architectures that do not support
unaligned accesses. Please only apply __packed to the members that need
it and consider checking the size of the data structure with
static_assert().

Thanks,

Bart.
