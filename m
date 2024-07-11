Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ABE16DED6
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720721082; cv=none; b=TfJo9wT0/r029hHW/CrUmaH1NrUb0o0fEd7YelMV2lvrC91gwGztlPsi2bXCjvp4jjVSIiqMcsHSb7yfSxziGvJtykpOoED4H4NwvBYbxlLUcOWU2xXbwkIdw9TBlQOnDt3aoTo3CLLznQktwOYMWBcxFiOgZKvuWRYiKKHa3No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720721082; c=relaxed/simple;
	bh=hvNPEB+rEKLF5Ml8Lj5DXvHU2eGQGia2o0wsQkix/jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ta1CXsUyVS6Uukt/78G8N7fwLmuT2noDXyNoAUW5xZvqPPevqKQj6dtd1Q2rfTwgaYYZLN7dv14O/zlExp6GcnaediSjXqsuJtye6Rn47m7lEbYUZm1K1E5hXxYkWcucDK1qCVIEcFpehxFLeflymbO78+NcfKxu6u734aKacmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=cvmNE2uF; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="cvmNE2uF"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id RcW4sVI70umtXRy9os4wRH; Thu, 11 Jul 2024 18:04:40 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id Ry9ns8uYErcQSRy9oscEqX; Thu, 11 Jul 2024 18:04:40 +0000
X-Authority-Analysis: v=2.4 cv=T92KTeKQ c=1 sm=1 tr=0 ts=66901eb8
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=uBuKx8GwAAAA:8 a=bLk-5xynAAAA:8 a=yPCof4ZbAAAA:8
 a=Tt-LMVSYixBJkh_1nL0A:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=wZgZ3yaTFkxMEWn-yT5t:22 a=zSyb8xVVt2t83sZkrLMb:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=aTh8KIYPXZBPgzwwAjibUfCQIN6ZaSc1iXtBYCJLcu0=; b=cvmNE2uFMRGLY4oxQYa/5b9svX
	BoAWyXAV+ma1+fjyIDcSMVuljfhTykUqU6e6xF2TkT5FLy2ko2louSkAzstA0herJtCU0Ix/8BFXW
	2szxqF4Rr0c1cSPg8NJLvadN2HK0u78kuzUAMAKwHI4NqFLwUbis2VobTTHFcRVyJNQKI0yYm3wvk
	PTH9IWdZcBj0Lsn1w/p32gqH9usLeb+ZWYyDHlChzLS9kD3EmN2q8w2bjomLE7hlh7sKW5si3m5an
	BHNS6YyhbeGy246z0olbOV5f05IlOsUybA4ks+Wdl/P7ZS3YwSV74Kmvap+7Ky3jlY8Xly1RhUYMD
	fbkmr/BA==;
Received: from [201.172.173.139] (port=59958 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRy9m-0025CJ-2Z;
	Thu, 11 Jul 2024 13:04:39 -0500
Message-ID: <bfcb72d7-bc3b-4398-be45-dabd60b73cf4@embeddedor.com>
Date: Thu, 11 Jul 2024 12:04:32 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: union aac_init: Replace 1-element array
 with flexible array
To: Kees Cook <kees@kernel.org>,
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20240711174815.work.689-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711174815.work.689-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.172.173.139
X-Source-L: No
X-Exim-ID: 1sRy9m-0025CJ-2Z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:59958
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDl2jE1z0p6Pl5BONEkSvw5ZMwGH6zpPObxhaqGnPF9VjqP9WKltB0yndSbYZmnkNKuMi8wYRnXI3FlOnlwzpa5ulGkZ4s3E5v59gkThKXAszb5I7vKA
 PuqeABwMumTNk7QOL3FWNtXNqXOCFbHoBEVefyjzoHv1X+qB1julpvNYIaHXvPmki6FtpCMuaBxELMa3J7m1C/09jPWvzSisZ9C2YMn4eomvYsSujxZaeUAr



On 11/07/24 11:48, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> union aac_init with a modern flexible array.
> 
> Additionally add __counted_by annotation since rrq is only ever accessed
> after rr_queue_count has been set (with the same value used to control
> the loop):
> 
>                  init->r8.rr_queue_count = cpu_to_le32(dev->max_msix);
> 		...
>                  for (i = 0; i < dev->max_msix; i++) {
>                          addr = (u64)dev->host_rrq_pa + dev->vector_cap * i *
>                                          sizeof(u32);
>                          init->r8.rrq[i].host_addr_high = cpu_to_le32(
>                                                  upper_32_bits(addr));
> 
> No binary differences are present after this conversion.
> 
> Link: https://github.com/KSPP/linux/issues/79 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/aacraid/aacraid.h | 2 +-
>   drivers/scsi/aacraid/src.c     | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 7d5a155073c6..659e393c1033 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -873,7 +873,7 @@ union aac_init
>   			__le16	element_count;
>   			__le16	comp_thresh;
>   			__le16	unused;
> -		} rrq[1];		/* up to 64 RRQ addresses */
> +		} rrq[] __counted_by_le(rr_queue_count); /* up to 64 RRQ addresses */
>   	} r8;
>   };
>   
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 11ef58204e96..28115ed637e8 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -410,7 +410,7 @@ static void aac_src_start_adapter(struct aac_dev *dev)
>   			lower_32_bits(dev->init_pa),
>   			upper_32_bits(dev->init_pa),
>   			sizeof(struct _r8) +
> -			(AAC_MAX_HRRQ - 1) * sizeof(struct _rrq),
> +			AAC_MAX_HRRQ * sizeof(struct _rrq),

struct_size_t() can be used here?

In any case:

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

>   			0, 0, 0, NULL, NULL, NULL, NULL, NULL);
>   	} else {
>   		init->r7.host_elapsed_seconds =
