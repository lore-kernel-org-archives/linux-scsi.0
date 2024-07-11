Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7489977119
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720722799; cv=none; b=XaH/guFC8khSiJcMuuVNZG9PZdxod6utLfZfpF6/Fo/dIfwx4Rp4bJ6tH1TfNjd6X4QCkr1l8u6u11bwFwxv0sq0OTsEMXGalkasStTTkFDJ0qvL+o8kXl2Okjhrx7ZdS49Rg58uQaM402EbTlIU7xqWPiklKkaA0aHwbCKPQOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720722799; c=relaxed/simple;
	bh=uoSp7HwQPPddEe4ukEsoYAbmuPS0/sWn1j/Os5CXpA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFzG/hKf1ctM4u7prYryvthZaBQQ1M9CD3vNULHi6yVTRNVloec3P8dggU5WfWCaZikmi9XPHjlUcT4RT1TdpthllfhY03Wd5Whk/2HjEero0ExBAwlD79IsoEnVeL5qq1DxdWueWFJT/b+RblHNXwUNYFvHFOH/K5JNiwQMnZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=IGUMm1Se; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="IGUMm1Se"
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id Rvtus9A0OVpzpRybVsayvT; Thu, 11 Jul 2024 18:33:17 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id RybUsKfNWRn6WRybUsS59C; Thu, 11 Jul 2024 18:33:17 +0000
X-Authority-Analysis: v=2.4 cv=KbTUsxYD c=1 sm=1 tr=0 ts=6690256d
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=bLk-5xynAAAA:8 a=yPCof4ZbAAAA:8
 a=zJSSyJOi6mIm-xllxbkA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=zSyb8xVVt2t83sZkrLMb:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=twUKEBl3y2YgGscgihakwZI6P5VsW6SwwxcpHuO6Nao=; b=IGUMm1SeHcNMx+Gw7ZlyQre8Ec
	iuzrIRvLT92hhyKg9/gweWla6tzJ0dMdj4S/shWKGQXm4KkdVshSnCEmWGMpYdf+kVMrKPtUDduW4
	Fnz3nMKa1dOedYeN6ut9IhgAn/OHCFTZYKjqXYqtvlC+xPjW2k7Q4xD3U6qfGhlO+WrIfnyTxZWK7
	rsHt/v35QLIQQZYV2dhNiQaOM7mqATgWYsHWt0LtIElI+aJBo/JVlBG/1pEWsq1aZZJZZVmapAMME
	80XPXNCHYyffT0uI1OBuknzqSoxi1Q7mLX4po5sgf8LNjGfbNLqKKflA834nF9kCXH47V7W/t4/x4
	O2/wjfxg==;
Received: from [201.172.173.139] (port=53174 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRybU-002c1E-0c;
	Thu, 11 Jul 2024 13:33:16 -0500
Message-ID: <28c303f1-facd-4d81-9255-6a57fa330a4e@embeddedor.com>
Date: Thu, 11 Jul 2024 12:33:14 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ipr: Replace 1-element arrays with flexible arrays
To: Kees Cook <kees@kernel.org>, Brian King <brking@us.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20240711180702.work.536-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711180702.work.536-kees@kernel.org>
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
X-Exim-ID: 1sRybU-002c1E-0c
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:53174
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 72
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIN8Nr06E1DYdceWOEgvNtVy2waVG4huxhOda+NePGvSMoZNNyG1iQakLxgmQTPWBj25/mxunKjuBJXcIIH8A/WBoADZ9Rt/AVsEWEjng4/xw5FU0zR8
 9LgTnCrH4pm59M7RyxM6opEeZIYv3bDuc8vRLBO/OMYI3v7SDT5hQVzOo6sbRUDb+u8Okj7XS41JHMGLGOx5D71h8Z+f/c2/4ENr0Fa7lfuVCYTURSMQthpT



On 11/07/24 12:07, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element arrays in
> struct ipr_hostrcb_fabric_desc and struct ipr_hostrcb64_fabric_desc
> with modern flexible arrays.
> 
> No binary differences are present after this conversion.
> 
> Link: https://github.com/KSPP/linux/issues/79 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

> ---
> Cc: Brian King <brking@us.ibm.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/ipr.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
> index c77d6ca1a210..b2b643c6dbbe 100644
> --- a/drivers/scsi/ipr.h
> +++ b/drivers/scsi/ipr.h
> @@ -1030,7 +1030,7 @@ struct ipr_hostrcb_fabric_desc {
>   #define IPR_PATH_FAILED			0x03
>   
>   	__be16 num_entries;
> -	struct ipr_hostrcb_config_element elem[1];
> +	struct ipr_hostrcb_config_element elem[];
>   }__attribute__((packed, aligned (4)));
>   
>   struct ipr_hostrcb64_fabric_desc {
> @@ -1044,7 +1044,7 @@ struct ipr_hostrcb64_fabric_desc {
>   	u8 res_path[8];
>   	u8 reserved3[6];
>   	__be16 num_entries;
> -	struct ipr_hostrcb64_config_element elem[1];
> +	struct ipr_hostrcb64_config_element elem[];
>   }__attribute__((packed, aligned (8)));
>   
>   #define for_each_hrrq(hrrq, ioa_cfg) \
