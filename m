Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC90D2DF155
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 19:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763147516; cv=none; b=p+7RJz+UlcJShDhsLRqSy/cSpw3vr4GD3XbtHQg5GvCjN0C2EfKvblZiYKZ39DEmc8R9zvRPwUgUemKxpyndpHbwCcHBXpze9aG6zj9DdxVH/NXNhmrn07JJj+WIFSehlBPkljJXw2uigEvGyc7KAOSummIkIiz+mAF53KE+oAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763147516; c=relaxed/simple;
	bh=43HMaRLm2iGTi0djrBUd1fGfuf1R0nmLq8HKzuNRDis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=RMHdPW8BuMjL4w4Fc9say68zWzVSsS12ByDrghiMUXw5R9FqpbHEUovaL2zP0AjkFzTTkCV5WYhFCZYYSfMBINtZy+zcoUexPXANp7Yjf8GJue+5MxzcF+eLzhYdg+KP/ufoySrpcq6BZRALYVS5Z1A4LIski2HgREcrbJ+fFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KufRJhz0; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KufRJhz0"
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20251114191146euoutp023a3841629f02997aaa5267d2d5aeb067~39VDE0zla1320813208euoutp02t
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 19:11:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20251114191146euoutp023a3841629f02997aaa5267d2d5aeb067~39VDE0zla1320813208euoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763147506;
	bh=TUIpLsx2jxsmv4MdZstjPdkRNw8PP0zBeh7Qiw6jsJk=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=KufRJhz07U3L3rfCBC9sHGGPnZauPltaTNYjXMMUoMtyo0r67cx92F4U+xxbwmhLA
	 ww55cl1mrCyWVYqCMg9Pa65btOuEdCDNQuIee+vc6eklvTaaf0dDa6xd5yRfhpSlWP
	 /aLz6kW5SsNceKiPm6YKg7rm0cPJPp79J0jBKI/4=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251114191146eucas1p2de421a3cea023e1e3dd4c4d92f4a7f9d~39VC1qpCP0758607586eucas1p2w;
	Fri, 14 Nov 2025 19:11:46 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251114191145eusmtip130272265fa67e510170f67f788cb8c4f~39VCF3y_K0905209052eusmtip1G;
	Fri, 14 Nov 2025 19:11:45 +0000 (GMT)
Message-ID: <6c833bb5-85f6-4fda-9563-179c7e7c24a2@samsung.com>
Date: Fri, 14 Nov 2025 20:11:44 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Bart Van Assche <bvanassche@acm.org>, =?UTF-8?Q?Andr=C3=A9_Draszik?=
	<andre.draszik@linaro.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Adrian
	Hunter <adrian.hunter@intel.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <2a2aef4e-288f-4dec-8ab1-fbc95bc1f880@acm.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251114191146eucas1p2de421a3cea023e1e3dd4c4d92f4a7f9d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5
X-EPHeader: CA
X-CMS-RootMailID: 20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5
References: <20251031204029.2883185-1-bvanassche@acm.org>
	<20251031204029.2883185-22-bvanassche@acm.org>
	<CGME20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5@eucas1p1.samsung.com>
	<c988a6dd-588d-4dbc-ab83-bbee17f2a686@samsung.com>
	<83ffbceb9e66b2a3b6096231551d969034ed8a74.camel@linaro.org>
	<2a2aef4e-288f-4dec-8ab1-fbc95bc1f880@acm.org>

Hi,

On 14.11.2025 19:39, Bart Van Assche wrote:
> On 11/14/25 9:32 AM, André Draszik wrote:
>> The commit that makes it crash is:
>>
>>    08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
>>
>> the ones leading to it just fail probe.
> Marek and André, thanks for having reported this issue.
>
> The series is not bisectable, which is unfortunate.
>
> Please help with testing the patch below on top of the entire patch
> series, e.g. on top of linux-next:
>
> diff --git a/drivers/ufs/core/ufshcd-priv.h 
> b/drivers/ufs/core/ufshcd-priv.h
> index 681426fde603..f385d85d3f95 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -380,7 +380,12 @@ static inline bool 
> ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info, u8
>   */
>  static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba 
> *hba, u32 tag)
>  {
> -    struct blk_mq_tags *tags = hba->host->tag_set.shared_tags;
> +    /*
> +     * Host-wide tags are enabled in MCQ mode only. See also the
> +     * host->host_tagset assignment in ufs-mcq.c.
> +     */
> +    struct blk_mq_tags *tags = hba->host->tag_set.shared_tags ? :
> +        hba->host->tag_set.tags[0];
>      struct request *rq = blk_mq_tag_to_rq(tags, tag);
>
>      if (WARN_ON_ONCE(!rq))
>
Yes, that's it! This fixes the observed issue. Thanks! Feel free to add:

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

