Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF26A28C5D9
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 15:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760456678; cv=none; b=mNp3SG9A+s9MdbzwNch944aw3vuG/uLrrk1cdGWvYL1uXRhzZBGsdp9fQeYIvykfNWGHijRqh5hbow0xJ2iu6DkINJcKdG5VcMVcN/GXwE3J7cuSpNg9a4ukF+4QETdiX3koL1keH1cQLgh7gPc1xv/Y69CYI3w8qznJPBYcpRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760456678; c=relaxed/simple;
	bh=n8E6/MSFkCXNTfuKduLLbJTX6u4Me6kIcJAGmDjcbZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jmBUb9Sj3DUQUI4cQq7fZReRiRrNDV2DRcG618qc4xV/mPKIf9VqhO9LAS23rXjYID8up51/W49yjqHYLiIKtBcvzxNbwlkODoOGbVvILbJ/mM3chMr8GqSPILREir3DaZ0Ulf+Ctr94LQuktpAjJBtJkf07MMD+K2Bk8t7xqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MwaFPdIT; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MwaFPdIT"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmJRy4x4vzlgqVQ;
	Tue, 14 Oct 2025 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760456668; x=1763048669; bh=0Tox6MpU56E4xIhuSJ4vcLZJ
	h0J1bS1miy44nAOIuEQ=; b=MwaFPdITk9vqDQOYnTmj+I0E2Sb5xHNRN6BTGvo6
	Xs3k4d4StyuHD4z6VXCgVS/LRVpEPBXPoe/M/YnaKTEmEk3qCL1p9aV+eLGazYqx
	Kf3V5pWT1afEM3O4yRYpBQR+4jYEPQ6LiLrqEN5s0KHE0seHkIsbfebEbVmLM5la
	oCXzNkbZA/2XwPg0ENus5oEXVBYYyfiC8J1Jsu4lj2A1iP6fthe+03fiyzZnp8bO
	UjAKtvmj8VoDc/eSfbNs4z33tBUra9n9nGyxEJPoZIJ8ImCaUyba1BYwCjxf4i94
	jvHJymVbiEsDxERwjG064HdcED7romvvcVi1+TU4ihkVKQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 760Exn8CY8uq; Tue, 14 Oct 2025 15:44:28 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmJRh1Gz7zlgqyn;
	Tue, 14 Oct 2025 15:44:15 +0000 (UTC)
Message-ID: <ef1ede40-3ff9-4ff3-9752-1037a55cc516@acm.org>
Date: Tue, 14 Oct 2025 08:44:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] ufs: core: update CQ Entry to UFS 4.1 format
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, qilin.tan@mediatek.com,
 lin.gui@mediatek.com, tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
 naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20251014131758.270324-1-peter.wang@mediatek.com>
 <20251014131758.270324-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251014131758.270324-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/14/25 6:15 AM, peter.wang@mediatek.com wrote:
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 612500a7088f..8b14f6e5e6f5 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -567,10 +567,19 @@ struct cq_entry {
>   	__le16  prd_table_offset;
>   
>   	/* DW 4 */
> -	__le32 status;
> -
> -	/* DW 5-7 */
> -	__le32 reserved[3];
> +	u8 overall_status;
> +	u8 extended_error_code;
> +	__le16 reserved_1;
> +
> +	/* DW 5 */
> +	u8 task_tag;
> +	u8 lun;
> +	u8 iid:4;
> +	u8 ext_iid:4;
> +	u8 reserved_2;
> +
> +	/* DW 6-7 */
> +	__le32 reserved_3[2];
>   };

The above definition is only correct for little endian CPUs. If you 
really want to use bitfields, please take a look at struct
request_desc_header for making bitfield definitions work for both little
and big endian CPUs.

Bart.
