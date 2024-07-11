Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F3E16DC14
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 18:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720721536; cv=none; b=nonoRmXRaB83AqpYY1lNSUjEpYGbLxpKAy8mqpBi1dRP2v1sSJ564Im5ahAQRDSm8p5a3SubUCBGURM57hOYQEA1xN9X2YqzETvvR21n72XnyR9lV2XsTd8pR0TaSbbmVVw7/wKUwiFeSw2xdibhM34IUmQMxU0b498DAIipPrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720721536; c=relaxed/simple;
	bh=qjZ95FdfR8fibhKaYFGQ8xUQGhsqJZDQmhdEuQus4R0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IyGLJYH94bWeJiPX2YxQVNOJlnbuyK7QoXMuEH8FPa6LFtKTgpa8TKlBWw6kkiCrCiYXI5ZPY9/ztOxe5iN3uhoVFuQt1IHVC20viMTqsh6sEsXpuo0YnL2Z56vGbYr4SUXLJ7MJyrJnDzpH8tgfNGGDWq6kr3ksOVMe9obNPzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=T9oIzlQu; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="T9oIzlQu"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id Re6Bs54yknNFGRyH8sHyOv; Thu, 11 Jul 2024 18:12:14 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id RyH7srZLmV2ivRyH7scVqv; Thu, 11 Jul 2024 18:12:13 +0000
X-Authority-Analysis: v=2.4 cv=OLns3jaB c=1 sm=1 tr=0 ts=6690207e
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=TAdm9UboAgj19sWw0poA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=Fp8MccfUoT0GBdDC_Lng:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KoZkARx5lnZczAYRCAa+zb47+ShE8UYwk3OAblehdv8=; b=T9oIzlQuDG6LFtao7OafX47RD/
	rku3zaOU+3dgu/SjQIERBdkH3G5kJ6xIRWvKymghT5xghbxmpFZMcx9NOnHiaVNhYOQMK32Ppxc6s
	i3Z/MIUohxb+9IyP3HOQ2BubMR+yzOhDiakYAViNh+v/MVu9h/sDQYxJ2RkXbcjwuK41WgdO9MJNv
	3slaPdPTilSQY2xYgbSmu84whFUb1aJ0AuBQGOzDOZuBjQXCmiy8a3Ex8j7GuqiuNJGqRYOkWomkH
	mcXd3s0uHxQsW3SGfRNLp6JylwibXXJ8vJ1TTwkcrbZD3VlfPYrr10wFKpxWtiSKOEEwMgbCd/1Ir
	vyCNs0pg==;
Received: from [201.172.173.139] (port=53488 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRyH6-002DoA-1p;
	Thu, 11 Jul 2024 13:12:12 -0500
Message-ID: <f1d60f01-5059-4c1a-a00e-c7d523f28784@embeddedor.com>
Date: Thu, 11 Jul 2024 12:12:11 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] scsi: message: fusion: struct _RAID_VOL0_SETTINGS:
 Replace 1-element array with flexible array
To: Kees Cook <kees@kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240711172432.work.523-kees@kernel.org>
 <20240711172821.123936-1-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711172821.123936-1-kees@kernel.org>
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
X-Exim-ID: 1sRyH6-002DoA-1p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:53488
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 18
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFP21NRlQQR27Xosk+97oVLV8rfd3SmNx+gtjsN0geggRlz+pJmPazVofIPClbqXZj9n7vYuTwy4+HWiZeD4Yv3cXyRoVmT/UHkia5QSLh7nVhx+4iG0
 rKDVj2oDTwHuGn8LJ570vPAlFyKooBmglVeVW8mzP6oB76swguxXXRdLrLh1X1kLFhFcZZOuGKvREOk3htMaXTjDhFpMH1tVtYr0+H00693pjnVQEvQa/vGZ



On 11/07/24 11:28, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct _RAID_VOL0_SETTINGS with a modern flexible array.
> 
> Additionally add __counted_by annotation since PhysDisk is only ever
> accessed via a loops bounded by NumPhysDisks:
> 
> lsi/mpi_cnfg.h:    RAID_VOL0_PHYS_DISK     PhysDisk[] __counted_by(NumPhysDisks); /* 28h */
> mptbase.c:	for (i = 0; i < buffer->NumPhysDisks; i++) {
> mptbase.c:		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
> mptsas.c:	for (i = 0; i < buffer->NumPhysDisks; i++) {
> mptsas.c:		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
> mptsas.c:	for (i = 0; i < buffer->NumPhysDisks; i++) {
> mptsas.c:		    buffer->PhysDisk[i].PhysDiskNum, &phys_disk) != 0)
> 
> No binary differences are present after this conversion.
> 
> Link: https://github.com/KSPP/linux/issues/79 [1]
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
-- 
Gustavo

> ---
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: MPT-FusionLinux.pdl@broadcom.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-hardening@vger.kernel.org
> ---
>   drivers/message/fusion/lsi/mpi_cnfg.h | 10 +---------
>   1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
> index 3770cb1cff7d..f59a741ef21c 100644
> --- a/drivers/message/fusion/lsi/mpi_cnfg.h
> +++ b/drivers/message/fusion/lsi/mpi_cnfg.h
> @@ -2295,14 +2295,6 @@ typedef struct _RAID_VOL0_SETTINGS
>   #define MPI_RAID_HOT_SPARE_POOL_6                       (0x40)
>   #define MPI_RAID_HOT_SPARE_POOL_7                       (0x80)
>   
> -/*
> - * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
> - * one and check Header.PageLength at runtime.
> - */
> -#ifndef MPI_RAID_VOL_PAGE_0_PHYSDISK_MAX
> -#define MPI_RAID_VOL_PAGE_0_PHYSDISK_MAX        (1)
> -#endif
> -
>   typedef struct _CONFIG_PAGE_RAID_VOL_0
>   {
>       CONFIG_PAGE_HEADER      Header;         /* 00h */
> @@ -2321,7 +2313,7 @@ typedef struct _CONFIG_PAGE_RAID_VOL_0
>       U8                      DataScrubRate;  /* 25h */
>       U8                      ResyncRate;     /* 26h */
>       U8                      InactiveStatus; /* 27h */
> -    RAID_VOL0_PHYS_DISK     PhysDisk[MPI_RAID_VOL_PAGE_0_PHYSDISK_MAX];/* 28h */
> +    RAID_VOL0_PHYS_DISK     PhysDisk[] __counted_by(NumPhysDisks); /* 28h */
>   } CONFIG_PAGE_RAID_VOL_0, MPI_POINTER PTR_CONFIG_PAGE_RAID_VOL_0,
>     RaidVolumePage0_t, MPI_POINTER pRaidVolumePage0_t;
>   
