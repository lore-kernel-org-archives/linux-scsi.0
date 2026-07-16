Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACD125F98A;
	Thu, 16 Jul 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784224735; cv=none; b=ndjEwthG0++Q/om5VDsyr+k0CvEuNsQF6Hj3gUAEeAetnU3XYmzcnwbmcBIqw+mJg/55rVithAw6do6LvfP7jhcsT0DUx7df+cdSuu/13ebc96GlDI8AlSs/zNhK90dqBkO/gVAedsu+vn+6L0fnmZHz1AFRWUtI3QFL166xJrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784224735; c=relaxed/simple;
	bh=RhQvsNfCC2uRYc5fS5n0mPAawFw210eUXHh6FTUUWCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4a2K/fS/+oSQKEczBIrVahZGkcXv8230QyPwrL9ae9qbohWBew65XqAR6EqS1t/mjoAYchVRaLkgCpqYwOgRXJWRa3b0fefiAOe2tpq2cjLE8plHlK7eNYUhbhazqcEHL4NN0ty6S9/uqcFwJyfuFmebiEc2OZm+wVRLUqyXp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QX8Q9ars; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QX8Q9ars"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h1LQ609Khzlgqw5;
	Thu, 16 Jul 2026 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784224727; x=1786816728; bh=304gjy1chirwT7BK+/J7hAyO
	XocBHlNQHNbhY7k5fko=; b=QX8Q9arscugrGdnUkcDteXpctoKGr35L7t3ro7Mn
	rSBimVOLKhs2AsNVYZlLZ1Ly5qBmW8seSKWUpZJNjHsOnR9KwS+lrAmwvkhohNdE
	ciiWUtrelooDTSwuooca7kHMrRDxImzJ/bbE9CTpApbvPAD0rE6Wj0+1ARxuRqmY
	uULYccCnIUm3qU2jxidSfOskKi6ePcEnnI2JmjfvL2AgDLJVO8vac+/nq7CKSQAi
	OvTYO4YTxekVNZLulLf8VOF8O/GFw6c5CecjYDItg1T/ilz9TJvHwEyabsCSqBWx
	zwM2BCQdKcwbheOAg0j1s0feN3vTo7WoIgnUY8eN83I1LQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Irtw3B4ROUpX; Thu, 16 Jul 2026 17:58:47 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h1LPw0m9kzlfl5n;
	Thu, 16 Jul 2026 17:58:43 +0000 (UTC)
Message-ID: <0b7ba9ca-baac-46d7-a0e8-a1e049b6372b@acm.org>
Date: Thu, 16 Jul 2026 10:58:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] scsi: ufs: rpmb: Validate frame before parsing
To: liqiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <70412f5cb24714052127ada81a7aac0f9d86000e.1784182493.git.liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <70412f5cb24714052127ada81a7aac0f9d86000e.1784182493.git.liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 11:19 PM, liqiang wrote:
> From: Li Qiang <liqiang01@kylinos.cn>
> 
> The RPMB core only verifies that request and response buffers are
> nonempty. This callback reads req_resp at the end of the first request
> frame before validating the request length.
> 
> Require a complete frame before that access. Use unaligned accessors
> because RPMB buffers are passed as u8 pointers and do not have an
> alignment guarantee.
> 
> Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
> ---
>   drivers/ufs/core/ufs-rpmb.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index ffad049872b9..53f66b274aca 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
> @@ -69,7 +69,11 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
>   
>   	hba = ufs_rpmb->hba;
>   
> -	req_type = be16_to_cpu(frm_out->req_resp);
> +	/* req_resp is at the end of an RPMB frame. */
> +	if (req_len < sizeof(*frm_out))
> +		return -EINVAL;
> +
> +	req_type = get_unaligned_be16(&frm_out->req_resp);
>   
>   	switch (req_type) {
>   	case RPMB_PROGRAM_KEY:
> @@ -107,7 +111,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
>   		struct rpmb_frame *frm_resp = (struct rpmb_frame *)resp;
>   
>   		memset(frm_resp, 0, sizeof(*frm_resp));
> -		frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
> +		put_unaligned_be16(RPMB_RESULT_READ, &frm_resp->req_resp);
>   		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
>   		if (ret) {
>   			dev_err(dev, "Result read request failed with ret=%d\n", ret);

Please split this patch into two patches because the two above changes 
are independent of each other.

Thanks,

Bart.
