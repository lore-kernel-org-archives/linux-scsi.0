Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF42D17A906
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 18:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720720867; cv=none; b=Cq48FWiKr1emwifVp9UqYxq9etb4/00uwG1uhNQTNjzx/JPh+tLLrLulpwDivGCJQ7xZZWYpkeWEj5DwK8HOsXVnMTj9JCurW70hv0oVKIbEmNLyy/kZtHTPWG1QGUry5z+bmC4A2T9Lu4wX3YkVdIXIjksetCsI9S/eIkTppQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720720867; c=relaxed/simple;
	bh=YDVcdvG6ChIs2831SkpN8McPGcBVyntfj7BjjGAYi+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6vKUIcl9o3227U4DIgrmYjui7S4cGo0cbweRBQv9RMHP1vYhvMJN/yIzM7V/RI5LWwALld1cLK+j5qYBbNhof+PVkxaVz/8TUoeptBq1XLV+fBO+UiYJxoLd06UHZcUz11RNuhnGygQgjWYc4QYGX4+g8mQdTFUrZWYW8Fvyk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=uqj7poB1; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="uqj7poB1"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id Rs5vsnEdcg2lzRy6KsL7nW; Thu, 11 Jul 2024 18:01:05 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id Ry6KsvSG4ks1PRy6KsoBRb; Thu, 11 Jul 2024 18:01:04 +0000
X-Authority-Analysis: v=2.4 cv=Ud+aS7SN c=1 sm=1 tr=0 ts=66901de0
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=uBuKx8GwAAAA:8 a=bLk-5xynAAAA:8 a=yPCof4ZbAAAA:8
 a=fcpcPwWQRFHHgP9w-NMA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=wZgZ3yaTFkxMEWn-yT5t:22 a=zSyb8xVVt2t83sZkrLMb:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=myjNqVgpn2sMEdwJcp2nHGFR3UaVBht1oH1YmtP4GAM=; b=uqj7poB1AnsvJpffZWj/KCJqcd
	p8NSRuzOmCAISR7YU4eDYmnapmkhrOkHuSwJHpb5OniCEWq8bNWeMlVW7fzxkq/oUNjgU2Vzh7GPG
	q3aqhm+dZZlFHMb5Q6scfsqtJnZBV1CpSiPFZ4LMkkL/hp9CRvfW7Au7I9PgWYjDibEb3ZYvUk3Fz
	U5LyabOO6pqbHdodqPzu2U2RPEW0UOnU8AQlRTyNGUjgHYUDV2I4IRvsMTBdy7mUG/fgVJkQoVsnW
	PLxOX2bnd7+rIO/S/1dfmkJ8b2XcC0ugCK2pwjxG6y5TZq++ZEyUnu8JB7S8wg1HOl/hb8M/P5ay/
	9J21LOtQ==;
Received: from [201.172.173.139] (port=37552 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRy6J-001zKO-1V;
	Thu, 11 Jul 2024 13:01:03 -0500
Message-ID: <4e94bc51-f699-406b-9522-1386d1b8f58f@embeddedor.com>
Date: Thu, 11 Jul 2024 12:01:02 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: aacraid: struct aac_ciss_phys_luns_resp: Replace
 1-element array with flexible array
To: Kees Cook <kees@kernel.org>,
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20240711175055.work.928-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711175055.work.928-kees@kernel.org>
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
X-Exim-ID: 1sRy6J-001zKO-1V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:37552
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAjSO/70Y9w8vDxwJkfqMT8QMCMJF4p4YTnno9XNJ//Howw2gWeiJG2fSSq4wgl/8tDSP7AX7k3I6dxgTkq7sH461zoRQIgOdZz17CxlJiYZ7ozqoIAK
 /S+oOHVTQBIt1qTZ04Z4No+erx0io08ZJFzfSMqJ0s2FYlAuWxTaKzMPp/LuMXlVa0zc5uwgNJpEkxIuiWuN//Q32KKiYzJ7APTi0/F/CHLeCakFIAz/8lGw



On 11/07/24 11:50, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct aac_ciss_phys_luns_resp with a modern flexible array.
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
>   drivers/scsi/aacraid/aachba.c  | 2 +-
>   drivers/scsi/aacraid/aacraid.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index b22857c6f3f4..497c6dd5df91 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1833,7 +1833,7 @@ static int aac_get_safw_ciss_luns(struct aac_dev *dev)
>   	struct aac_ciss_phys_luns_resp *phys_luns;
>   
>   	datasize = sizeof(struct aac_ciss_phys_luns_resp) +
> -		(AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
> +		AAC_MAX_TARGETS * sizeof(struct _ciss_lun);

I think this is a good candidate for struct_size().

In any case:

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

>   	phys_luns = kmalloc(datasize, GFP_KERNEL);
>   	if (phys_luns == NULL)
>   		goto out;
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 659e393c1033..6f0417f6f8a1 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -322,7 +322,7 @@ struct aac_ciss_phys_luns_resp {
>   		u8	level3[2];
>   		u8	level2[2];
>   		u8	node_ident[16];	/* phys. node identifier */
> -	} lun[1];			/* List of phys. devices */
> +	} lun[];			/* List of phys. devices */
>   };
>   
>   /*
