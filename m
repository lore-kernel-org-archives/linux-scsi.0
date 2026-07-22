Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14E043CE52;
	Wed, 22 Jul 2026 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740146; cv=none; b=lVKfaX96tTSRG7FmrJzISXQXif/YbsqkRm1HGU87KvEBBAl9092amaXfZWbGae570K4LNi7S66SdEkgFTRedADhT5OWAumDbhjqsbD0H1NgFMsWi3YsKzxZxMN8Tmo6GgOo0Ky73AWep7gNNT1zgQFWXAq0B6dIy3ct1QuddmQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740146; c=relaxed/simple;
	bh=kn0cCiqXZk4cphAkNHPOPWiA503Bz85BwHwuvt5CSew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p53gD2Q6fY5fkcMkqL4XVN1UTnjsVxboldPwDmY2kXVDOc6EmlKTZiq27C8MnPiV6bbCXp92+kg0WVBRCWLdk3AkdehZWYzGSZCVhEwwcNiLBlbyULZ03Ja/I6eF6/xAi32Dch1YuOqMYL8i5BVpz6RdQFnLKWT1faxUEYPEUyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PAxpYyyk; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PAxpYyyk"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h511n5DJJz1XM6JT;
	Wed, 22 Jul 2026 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784740132; x=1787332133; bh=+Sq2UT+JbJiPQGK8pY313jKd
	4eQlaaTb/UcYR0tu2bg=; b=PAxpYyykwhEUmWx4nLqgt0VmRPU6Pe0WdUEuIpXh
	JG4cdDm5kbc5fvf4RQBMS1yydW54Jq9/XrpwJ+9KgsBugMyFnJBRTj/vHvr8sC38
	DVG0VW32P16FNb0c9z9gd1Oa/4bZD7OlaYKoZuHItADNwOWi6wUYQaqyU/iG9JDh
	JNN7UJCU6t3clGbOWouQgrgj/7kDXNAIS1Gk23ILic21JwdacDgAHYtbu/bkAsqX
	7FaxjxJYMvgh7+LeVQYXXKCeBdxllvOWSvVIIs2RidqB89fVef+wD7uPA1hHDKFL
	S5gAds2cX/ORK6TDnhY6WxYBAwYRtqGPXAOIUlwD9+yxfw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NuF9gTLVDNBU; Wed, 22 Jul 2026 17:08:52 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h511X1QfBz1XM5kD;
	Wed, 22 Jul 2026 17:08:47 +0000 (UTC)
Message-ID: <13d80afa-3d5c-405f-8845-6dccb048bd97@acm.org>
Date: Wed, 22 Jul 2026 10:08:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Add support for the aggregated read query
 opcode
To: hyenc.jeong@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: ALIM AKHTAR <alim.akhtar@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Jinyoung Choi <j-young.choi@samsung.com>,
 Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
 Keoseong Park <keosung.park@samsung.com>,
 Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon Seol
 <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>,
 Yunjae Jo <yunjae00.jo@samsung.com>
References: <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p4>
 <20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/26 1:48 AM, Hyeoncheol Jeong wrote:
> -	/* sizeof(struct utp_transfer_cmd_desc) must be a multiple of 128 */
> +	/* Both UCD types must be a multiple of 128 */

"must be" -> "must have a size that is"

"128" -> "128 bytes"

> -	*desc_len = min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
> +	if (desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ)
> +		*desc_len = min_t(int, QUERY_AGGREGATED_MAX_SIZE, desc_size);
> +	else
> +		*desc_len = min_t(int, QUERY_DESC_MAX_SIZE, desc_size);

Please convert this patch into a series and add a patch before this 
patch that changes the data types of desc_size and desc_len from 'int'
and 'int *' into unsigned types (u16 or unsigned int). The length field
is an unsigned 16-bits number according to the UFS standard. Hence, the
UFS driver should use an unsigned type for the UPIU query length.

This will allow to change "min_t(int, ...)" into "min(...)".

Since 'desc_op' is only used derive the maximum query size, wouldn't it
be better to move the code that limits 'desc_len' into
ufs_bsg_request()? Then 'desc_op' won't have to be passed to
ufs_bsg_get_query_desc_size().

> +	/* The reserved tag uses a dedicated UCD outside the pool. */
> +	if (unlikely(blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))) {
> +		struct utp_devman_cmd_desc *cmd_descp = hba->devman_ucd_base_addr;
> +
> +		cmd_desc_element_addr = hba->devman_ucd_dma_addr;
> +		command_upiu = cmd_descp->command_upiu;
> +		response_upiu = cmd_descp->response_upiu;
> +		prd_table = cmd_descp->prd_table;
> +	} else {
> +		int slot = i - UFSHCD_NUM_RESERVED;
> +		struct utp_transfer_cmd_desc *cmd_descp =
> +			(void *)hba->ucdl_base_addr + slot * ufshcd_get_ucd_size(hba);
> +
> +		cmd_desc_element_addr =
> +			hba->ucdl_dma_addr + slot * ufshcd_get_ucd_size(hba);
> +		command_upiu = cmd_descp->command_upiu;
> +		response_upiu = cmd_descp->response_upiu;
> +		prd_table = cmd_descp->prd_table;
> +	}

The above code is based on the assumption that
!blk_mq_is_reserved_rq(rq) implies that i >= 1. Please add a
WARN_ON_ONCE() statement that makes this assumption explicit, e.g.
WARN_ON_ONCE(slot >= 0).

> +	int tag;

Shouldn't 'tag' have an unsigned type?

> +static inline size_t ufshcd_get_devman_ucd_size(const struct ufs_hba *hba)
> +{
> +	return sizeof(struct utp_devman_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
> +}

Why SG_ALL? The data buffer for device management commands is allocated
with kmalloc() and hence is contiguous so a single segment descriptor
should be sufficient.

Otherwise this patch looks good to me.

Thanks,

Bart.
