Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AECB1DB95E;
	Mon, 15 Sep 2025 22:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757973989; cv=none; b=pvWnOeZ5pNjEsXDQd1Eos0cj3RFSyGsaAlTNvCQopyhCdxa81DS/2uqI3pzsP8e4LGhhKUxCEOd19MZpjQQgu3+5Cs8USjwkfi9YPnyqKtYl+SSOZm/9hUlFdWQIoFq9yLpAn8kEOZrbSkBiuo8y34d3jKXhPu6Tr5wwZvGnPeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757973989; c=relaxed/simple;
	bh=EoHhQejEr2Vi8c/HthGUOcammiFsAMWn/tq+9NcVbc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RBd/6leI3j4p1zWGvdrLXHngkeFOuD/EgXLaHk7RrALXKLFirms2nc1XcBEFwO++OGbUVGvCbx6qIymhFxUIeHB8T4HSGc3OGXxiuzTlgeUA4U58QYJqB0bMm9Bp9sdt8oB7kE5/4bWxVVEuXCyy5YqiyQK02MKPBOx04F4J9LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dy+frBl1; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dy+frBl1"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cQfJ3134qzlgqTr;
	Mon, 15 Sep 2025 22:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757973984; x=1760565985; bh=L+fUpP1fZAVJuMPr5NKYU1pa
	SSw2yx2U6EKOlOYGkEo=; b=dy+frBl1QroGqgxI/D5HPS8mXkiU2QBwxg2u/SeQ
	+5SJo8ogSetDlYDiydP+0L+hvTuJGJFVtt6y4wzXIawSgcYYiKxceiFBrV9du1+r
	qwpaF1ZX1kpQ40tIf1fDDNaMxnJnHLzyGt8wFeBq2fl1r+GqDFEYZesSUMlttIww
	h2lby4xCTPgO7dp/g+MSezfFeLxFEZ2BXaMDhrmFHfRAvbTbAYqX2W4aSTdcG36N
	Xdj4f03luC95LTYQycJ5CfbXn/VT3Z/wEEpwfoZl2ToZzZ1SnaqbrYjbIFtIr9PS
	AWrySd656e5EfD6nSeiRRxzUb4xP5pHAfXJcoJLpdouQ9w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OpOYypynSxOq; Mon, 15 Sep 2025 22:06:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cQfHn30h2zlgqV0;
	Mon, 15 Sep 2025 22:06:12 +0000 (UTC)
Message-ID: <0f08376b-569a-48d6-a551-e10b72b32354@acm.org>
Date: Mon, 15 Sep 2025 15:06:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/2] scsi: ufs: core: Add OP-TEE based RPMB driver
 for UFS devices
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 mikebi@micron.com, lporzio@micron.com, Bean Huo <beanhuo@micron.com>
References: <20250915214614.179313-1-beanhuo@iokpp.de>
 <20250915214614.179313-3-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250915214614.179313-3-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/25 2:46 PM, Bean Huo wrote:
> + * UFS OPTEE based RPMB Driver

Is the correct spelling OPTEE or OP-TEE?

> +#define UFS_RPMB_SEC_PROTOCOL	0xEC	/* JEDEC UFS application */
> +#define UFS_RPMB_REGION_0	0x01	/* SECURITY PROTOCOL SPECIFIC: RPMB Protocl ID, Region 0 */

Do these constants come from a standard? If so, please mention this.

> +	u8 cdb[12] = { 0, };

Using "{ 0 }" or "{ 0, }" as an initializer is outdated. Please use "{}"
instead.

> +	if (need_result_read) {
> +		struct rpmb_frame *frm_resp = (struct rpmb_frame *)resp;
> +		memset(frm_resp, 0, sizeof(*frm_resp));
> +		frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
> +		ret = ufs_sec_submit(hba, UFS_RPMB_REGION_0, resp, resp_len, true);
> +	}

Please leave a blank line between declarations and statements.

> +	u32 cid[4] = { 0 };

Same comment here about zero-initialization.

> +	/*
> +	 * Use serial number as device ID. Copy ASCII serial number data.
> +	 * This provides a unique device identifier for RPMB operations.
> +	 */
> +	strncpy((char *)cid, sn, sizeof(cid) - 1);

strncpy() into an u32 array? Really? There are multiple alternatives
available in the kernel that are better than strncpy(). Are you sure
that you want to use strncpy()? Additionally, does copying a string into
a u32 array introduce any endianness issues?

> +MODULE_DESCRIPTION("UFS RPMB integration into the RPBM framework using SCSI Secure In/Out");

RPBM or RPMB?

>   	} else {
> -		str = kmemdup(uc_str, uc_str->len, GFP_KERNEL);
> +		str = kmemdup(uc_str->uc, uc_str->len, GFP_KERNEL);

Is the above change perhaps a bug fix that is completely independent of
the rest of this patch?

Thanks,

Bart.
