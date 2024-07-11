Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F788BFD
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720714664; cv=none; b=JcFOjdi2+AocOtnK8jyrWvJTcZtLak9Ugaw1LSZobWC6F2Lo5IULVyBcLMpouJeoUT4H3LAKbbzLoP/R2g8c8upnAa5GPrusMYGQqYUubWWgLkj4BbKtHMsn6nQ3/Vikm9ElBdJWdMrHXxOQSeU+pqu9Qy7q8u6gMbb51xT8h/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720714664; c=relaxed/simple;
	bh=icmjqQVU09TQsUQ4NSbJkvLGbPtBAoNUWY+Hh+IPwAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tqs5iiQeRXT2ANm2lon17J0kW5sRJHYy+3FA0rT1wpXl3np5d9NUS1CBWPXZfz88MWJC0fqVYIkYLilftDdeIkGckbnashByHFApq+CTGvdwxaVLIhjYwoG0Z8crJxghNDkgUorpL/gHSuFrm1cXn929MXfQAuYrp6F3VK1WC/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=V/GStYAB; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="V/GStYAB"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id RtP4slhoPjnP5RwUHsXC0m; Thu, 11 Jul 2024 16:17:41 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id RwUGsjpq36MrpRwUGs0yJ4; Thu, 11 Jul 2024 16:17:41 +0000
X-Authority-Analysis: v=2.4 cv=SJGJV/vH c=1 sm=1 tr=0 ts=669005a5
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=bLk-5xynAAAA:8 a=yPCof4ZbAAAA:8
 a=rOUgymgbAAAA:8 a=Gf48L2LQQ7vtOYgXLocA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=Fp8MccfUoT0GBdDC_Lng:22 a=zSyb8xVVt2t83sZkrLMb:22
 a=MP9ZtiD8KjrkvI0BhSjB:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QFayY9OLIsbCjng76Xlt7fbWEqnvChhgZ71hG8FAC/U=; b=V/GStYAB19o5YMk7XKHDAAu+1X
	Wy94kL5iwT13UmhXrVm8RbDLKrtjyfFYZh2nb8QTIzl6oZ5mcWBRDDAlEaNohZ7u9yEpXZtaDZB7/
	aDeBp3gfE1gp615+qxhnIrKJynKRhYFdGhIkdvNhm3UuDtsLgvHCDEoqxvgTlBfOjyhedww9FrINo
	bs+f9HxckPxl0OJviOSmY+gJryfoDv0hr+sWHLBgZl78ant8ePyHT6oR7spK0aRt7irzUD3om5Vfk
	GDc6MF96qN8kwFrR6lvNC1wOD+03mLKGTb7paGlrf0btj4e+aJ8JzjrN0YKFnMDKEirTAvbWn0TLX
	UmciDfRA==;
Received: from [201.172.173.139] (port=56410 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRwUF-004Ium-0A;
	Thu, 11 Jul 2024 11:17:39 -0500
Message-ID: <bd2f6ce6-f6c9-4aac-b34f-d9c55cefd17d@embeddedor.com>
Date: Thu, 11 Jul 2024 10:17:37 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: mpi3mr: struct
 mpi3_event_data_pcie_topology_change_list: Replace 1-element array with
 flexible array
To: Kees Cook <kees@kernel.org>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 Stephen Rothwell <sfr@canb.auug.org.au>, mpi3mr-linuxdrv.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240711155446.work.681-kees@kernel.org>
 <20240711155637.3757036-2-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711155637.3757036-2-kees@kernel.org>
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
X-Exim-ID: 1sRwUF-004Ium-0A
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:56410
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 17
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMq5aLU57g0F/0j3JApIfiLF6QW1Rwa88fPzv/NvN3p+xzU1AaBZh/vvBQ91oB4XhBiW9cT+U7UZ4JzJvs/e5BdmWB68oqdyRsyws0R9FevdeWgS6nZ1
 uyNHXj16kjjtGq2vM1HjR8bMC1vtiUNhh/o0w/wWv+pcJnPwZLY4QxHPpXOyvVI0nANZokHpxFZgj3TM9d6S3tAPS/LB+bpBzr77izom8UOUrq2dIiIzmqfi



On 11/07/24 09:56, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct mpi3_event_data_pcie_topology_change_list with a modern
> flexible array.
> 
> Additionally add __counted_by annotation since port_entry is only ever
> accessed in loops controlled by num_entries. For example:
> 
>          for (i = 0; i < event_data->num_entries; i++) {
>                  handle =
>                      le16_to_cpu(event_data->port_entry[i].attached_dev_handle);
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
> Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: mpi3mr-linuxdrv.pdl@broadcom.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-hardening@vger.kernel.org
> ---
>   drivers/scsi/mpi3mr/mpi/mpi30_ioc.h | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> index ae74fccc65b8..c9fa0d69b75f 100644
> --- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> @@ -542,9 +542,6 @@ struct mpi3_event_data_pcie_enumeration {
>   #define MPI3_EVENT_PCIE_ENUM_ES_MAX_SWITCHES_EXCEED         (0x40000000)
>   #define MPI3_EVENT_PCIE_ENUM_ES_MAX_DEVICES_EXCEED          (0x20000000)
>   #define MPI3_EVENT_PCIE_ENUM_ES_RESOURCES_EXHAUSTED         (0x10000000)
> -#ifndef MPI3_EVENT_PCIE_TOPO_PORT_COUNT
> -#define MPI3_EVENT_PCIE_TOPO_PORT_COUNT         (1)
> -#endif
>   struct mpi3_event_pcie_topo_port_entry {
>   	__le16             attached_dev_handle;
>   	u8                 port_status;
> @@ -585,7 +582,7 @@ struct mpi3_event_data_pcie_topology_change_list {
>   	u8                                     switch_status;
>   	u8                                     io_unit_port;
>   	__le32                                 reserved0c;
> -	struct mpi3_event_pcie_topo_port_entry     port_entry[MPI3_EVENT_PCIE_TOPO_PORT_COUNT];
> +	struct mpi3_event_pcie_topo_port_entry     port_entry[] __counted_by(num_entries);
>   };
>   
>   #define MPI3_EVENT_PCIE_TOPO_SS_NO_PCIE_SWITCH          (0x00)
