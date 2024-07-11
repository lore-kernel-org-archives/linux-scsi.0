Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167E58F72
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720714584; cv=none; b=BBxTbFXoHAMKTbDzqRF/kXdiqFvdml90DPV4NNBYm3ig+uo3N4ajm1+3bjAg3v+JTeQ6aMS7maXw619FtIWfU3cXgoAB+5x62RTK4hIWAfpkOHHxsu8sAKTWKpFcAIbKppgvIIbWbs6k4Py+XAV+jUemqB/pKBQxxM9nfgZYLLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720714584; c=relaxed/simple;
	bh=YcA+H0UH5himzWlQiVV55SJZ5aod/NYeqs8LnRg02Fk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D75ea5t24meeF8EF02cjWN53q+QZQQd7ZVM4T6XLQ1XZzxcR6b8FpvHasoioaNb3VpL+05R3kd9uUaTCv7122jiMYLvrGigr3h60s7u0pnTuWgeeCsZvEMwGC8t64Zc0bCZI229k5xT28601t73+EtO750+TBfv1yx3vKQ8fSys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=0JUsBAUG; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="0JUsBAUG"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id RvJ2soJ9Ng2lzRwSysK5b9; Thu, 11 Jul 2024 16:16:20 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id RwSxsbXKmO7CrRwSxsyxMS; Thu, 11 Jul 2024 16:16:19 +0000
X-Authority-Analysis: v=2.4 cv=Pco0hThd c=1 sm=1 tr=0 ts=66900553
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
	bh=eQeYix7fsBclpcHIxpnFNByXsSZl5xwa42J/v4FFhmc=; b=0JUsBAUG0QHvvmEIoymFjkBgBt
	F9Sp0DNoKYz8c6svYFTkIBAOlHGODEWnpMHO52iJf6FjWYZ5CFq40WcahCEmv1xsboMnD2XYdSBmU
	AKP+LtQcWfl32Kxi5VOXrJp5uTMAFAyloA6KTCgFMPnzLABRziiSqwYVtCpQShA7TH+nV4yeuV6KV
	N06vXjYAo3JWtFZ5BKx9ws+NpZWRiDctTi3oMKLY8T4TZwDeff30clF0i9hZ8sDsrBCi9b/mATl4Z
	sRofDOWnhB2OrE5nJFnZuS9PXTAEG5v96r6sUYng6pTx5L9h97tbLRA3sY9u7cWM93P44E5nDOir+
	+9Um89Dg==;
Received: from [201.172.173.139] (port=38138 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRwSv-004Hk8-16;
	Thu, 11 Jul 2024 11:16:17 -0500
Message-ID: <15be9ec9-02a1-452d-aee5-d6536eef6796@embeddedor.com>
Date: Thu, 11 Jul 2024 10:16:15 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: mpi3mr: struct
 mpi3_event_data_sas_topology_change_list: Replace 1-element array with
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
 <20240711155637.3757036-1-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711155637.3757036-1-kees@kernel.org>
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
X-Exim-ID: 1sRwSv-004Hk8-16
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:38138
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNAGD3zzt9kKo1qEGaGnichjHglfqxeZ+3/uEadMRSqjh1KLvLBKTpKQCAk8yH7PKkqfuQzAfn4Jwx/0z8ouPRcbXkgDnkjIS19BdtoQgm2hwVx31OhN
 Fjk1TReCCb77pKxBb0seziq0xAojq7gAgo2yF+p74myaRugoHZUYUQJ/bYuT3LXU2DOPo+e8liIMcXpOn5QgUUnPizuoH2ngGny7BYFfNpEolRMrzyHfuNcn



On 11/07/24 09:56, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct mpi3_event_data_sas_topology_change_list with a modern
> flexible array.
> 
> Additionally add __counted_by annotation since phy_entry is only ever
> accessed in loops controlled by num_entries. For example:
> 
>          for (i = 0; i < event_data->num_entries; i++) {
> 		...
>                  handle = le16_to_cpu(event_data->phy_entry[i].attached_dev_handle);
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
> index 028784949873..ae74fccc65b8 100644
> --- a/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
> @@ -453,9 +453,6 @@ struct mpi3_event_data_sas_notify_primitive {
>   #define MPI3_EVENT_NOTIFY_PRIMITIVE_POWER_LOSS_EXPECTED   (0x02)
>   #define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED1             (0x03)
>   #define MPI3_EVENT_NOTIFY_PRIMITIVE_RESERVED2             (0x04)
> -#ifndef MPI3_EVENT_SAS_TOPO_PHY_COUNT
> -#define MPI3_EVENT_SAS_TOPO_PHY_COUNT           (1)
> -#endif
>   struct mpi3_event_sas_topo_phy_entry {
>   	__le16             attached_dev_handle;
>   	u8                 link_rate;
> @@ -496,7 +493,7 @@ struct mpi3_event_data_sas_topology_change_list {
>   	u8                                 start_phy_num;
>   	u8                                 exp_status;
>   	u8                                 io_unit_port;
> -	struct mpi3_event_sas_topo_phy_entry   phy_entry[MPI3_EVENT_SAS_TOPO_PHY_COUNT];
> +	struct mpi3_event_sas_topo_phy_entry   phy_entry[] __counted_by(num_entries);
>   };
>   
>   #define MPI3_EVENT_SAS_TOPO_ES_NO_EXPANDER              (0x00)
