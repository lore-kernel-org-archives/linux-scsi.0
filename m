Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E923FC41;
	Tue, 23 Sep 2025 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758659281; cv=none; b=ZcLuF7h5UgLy8hiu3uXjQ5mlCfX7lGwFet2ClEVhh9vqUB9E9kpLBjMcohJZ2XwErZOy71XTvg2gl6H5lFA8yUl+l+06JkauMje2ncTl0tZtqFtNKL0E1hp6vf7xNpjIZYL9g1lQffibr+NyKscCQMfH+E+HrbR5ILWUEXPmgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758659281; c=relaxed/simple;
	bh=PbSITlPaXx5Y8UlgR9GOOZrKlTQWOq6hJ8JkmNTj5uQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=luZEKv4p+J6Ezi6PjRjdCJmW+/zpzN6a70UQRma690popZg4GXbbMwL1NvgfGC/3RE73phtwhX5xjoeboV8AKWclGgI7miuXNh96N+roqGxkHgtqwht0j0VcPu+QD4AaY+Gdi3rjlb0F9Gfg2bH7AGbA/CjTNwoPqnuEWCz/is8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VomX3a6X; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VomX3a6X"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cWWkk13dBzlgqVr;
	Tue, 23 Sep 2025 20:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758659276; x=1761251277; bh=uaYIEPiqRFtw2MIEF/8uNfV6
	VPl6EZC7+8v+F7docdE=; b=VomX3a6XaRm0yw7g4rxFFylz2RsmQj1fbcsCSQMB
	3VJrq58maHA0VtNtQNFJZjC99JmvTHr4wNFerHI1Jl9uCbl6rOHK4mDnMdyZOrTq
	pZLWB8DUwKFzGuEBNgx7AWXBEjb0IkoqKVblrWtPuLvvQUYs8Zm9UTU3exiFVf9C
	QvVogKhGnCFKe+rHKQbXmu8m2nrmYQWKYBaJ8gGDNaYN62LkL1McH5O0dOTwhcsj
	sdFP7R6SQrBe6Taz2SqMXflUWrOfEWXM3UWaGcxskVYk0IGerqGbspmWnsqzgP9u
	NkpdpNKYyvmqw7MGMpXTCX1Yeh94Ih8+0BgkfVIvW0RjMw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id v2df5XKNZCPz; Tue, 23 Sep 2025 20:27:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cWWkX2tp0zlgqVh;
	Tue, 23 Sep 2025 20:27:46 +0000 (UTC)
Message-ID: <b2ed97b4-bfef-4e4b-83ed-a172214e46e8@acm.org>
Date: Tue, 23 Sep 2025 13:27:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/3] scsi: ufs: core: Add OP-TEE based RPMB driver for
 UFS devices
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 can.guo@oss.qualcomm.com, ulf.hansson@linaro.org, beanhuo@micron.com,
 jens.wiklander@linaro.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250923153906.1751813-1-beanhuo@iokpp.de>
 <20250923153906.1751813-4-beanhuo@iokpp.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250923153906.1751813-4-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/25 8:39 AM, Bean Huo wrote:
> +	ret = scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
> +	                       buffer, len,  /*timeout=*/30 * HZ, 0, NULL);
> +	return ret <= 0 ? ret : -EIO;

scsi_execute_cmd() can return a negative value, zero, or a positive
value. Both negative and positive values should be considered as an
error.

> +MODULE_DESCRIPTION("UFS RPMB integration into the RPMB framework using SCSI Secure In/Out");

That's a very long module description ... Can this description be made
shorter without reducing clarity?

> +	u8 rpmb_region0_size;
> +	u8 rpmb_region1_size;
> +	u8 rpmb_region2_size;
> +	u8 rpmb_region3_size;

Why four separate members instead of an array?

Thanks,

Bart.
