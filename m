Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2932B86AFA
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720721775; cv=none; b=BKkYqelaVAGe/5E3kstr0sLpnW3WUrERIwtdGZw/c0GCDIyoMhNx8VGHctLGY3Ckgn24YAZYo/je16eIuHozLEOhn4QCenYMc/CiPJr+4nr8FVgVSCAQj8BK+/XbwnpVGhWf7AcX2pstHzFxgdEVe4j0MSZ59Qn7R/EBHDL9IZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720721775; c=relaxed/simple;
	bh=Jeqp4Zx0dByLSHfkuerFmgOZJkYcJ4CyB46Y9M/xqxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cBUAy+2kcNdAwMSHVqKQBe0syv4cFdno/zIM098YdxK1xG3pHN+BIEhRAB9L4nJeJ+P2LFvb92zjnZzE6haP//7EHk35JCN9gvmbwyj+aJJdQgHqryMMn+F0/S0erPFc2R65+MOspwCgdmX91aA4OuzWV6E7dx10Pc6l8ReTwYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=FySlo9fk; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="FySlo9fk"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id RszTsPuaKiA19RyKzs5QEO; Thu, 11 Jul 2024 18:16:13 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id RyKysHWcHFOowRyKysiQ5L; Thu, 11 Jul 2024 18:16:12 +0000
X-Authority-Analysis: v=2.4 cv=Bbfe0Kt2 c=1 sm=1 tr=0 ts=6690216c
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=TAdm9UboAgj19sWw0poA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=Fp8MccfUoT0GBdDC_Lng:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=22/DKjzyxfh2X9BgFK399NFqZY/d5uKtNtbwQqtPnr8=; b=FySlo9fkoJPRCzlYy6yMa5G1/2
	P9h9y43F9NXLVi1AENvFPjeQz/oFrAtmOsSdFllhHJU0yc/vnZzNzPZ5b7RakBsl3FYxHLo2dE9FU
	/TGFNQDl0U9TIBQw81pXIFUGGeU9hinR3wDUABtbK4EF1O9UzRlHgcU4UMscGDi5Md/TL5dC5d6Gg
	gWd5+7rM0pw5FwjjHZNgzyhmmTUcILuJmfBdOex2pcsMwKCXz8Uk6sEghLFPdhqq88/YWreoJs7Sw
	uyeiPnpOPD0zmisRnxjzzWG042XxomRjTfAG0IuUIbpu9kb02RpHh1SwHDEBpxFq/EAss57Iw0Izt
	/HLCMYKg==;
Received: from [201.172.173.139] (port=40950 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRyKx-002I1c-36;
	Thu, 11 Jul 2024 13:16:12 -0500
Message-ID: <666a356a-9af3-437b-9f30-61ec5ebf8784@embeddedor.com>
Date: Thu, 11 Jul 2024 12:16:10 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] scsi: message: fusion: struct
 _CONFIG_PAGE_RAID_PHYS_DISK_1: Replace 1-element array with flexible array
To: Kees Cook <kees@kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240711172432.work.523-kees@kernel.org>
 <20240711172821.123936-3-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711172821.123936-3-kees@kernel.org>
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
X-Exim-ID: 1sRyKx-002I1c-36
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:40950
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 36
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKMhndbbKvXMsviMAWeZZJz3JEVbIRM9BEcuEjEkWV0sctFmigdZIPC9IBvPNMd68aQknHikLQB6pWt2G8siJvhHabW2GJWJZgD8v8L4ZuxKN/bYzzcD
 kEAqUpWhwmvUmiV6U/chkO9sOI9RaqgiaU2/HJ/OpzVVsAu4WImQgdIk576y+hoUeJVtMIFrfoLF7MvM6j1UKWMewFClJ2ugArJyq8hhgp48aLdSC6KKeA17



On 11/07/24 11:28, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct _CONFIG_PAGE_RAID_PHYS_DISK_1 with a modern flexible array.
> 
> Additionally add __counted_by annotation since Path is only ever
> accessed via a loops bounded by NumPhysDiskPaths:
> 
> lsi/mpi_cnfg.h:    RAID_PHYS_DISK1_PATH            Path[] __counted_by(NumPhysDiskPaths);/* 0Ch */
> mptbase.c:      phys_disk->NumPhysDiskPaths = buffer->NumPhysDiskPaths;
> mptbase.c:      for (i = 0; i < phys_disk->NumPhysDiskPaths; i++) {
> mptbase.c:              phys_disk->Path[i].PhysDiskID = buffer->Path[i].PhysDiskID;
> mptbase.c:              phys_disk->Path[i].PhysDiskBus = buffer->Path[i].PhysDiskBus;
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
> index c7997e32e82e..e30132b57ae7 100644
> --- a/drivers/message/fusion/lsi/mpi_cnfg.h
> +++ b/drivers/message/fusion/lsi/mpi_cnfg.h
> @@ -2447,14 +2447,6 @@ typedef struct _RAID_PHYS_DISK1_PATH
>   #define MPI_RAID_PHYSDISK1_FLAG_INVALID         (0x0001)
>   
>   
> -/*
> - * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
> - * one and check Header.PageLength or NumPhysDiskPaths at runtime.
> - */
> -#ifndef MPI_RAID_PHYS_DISK1_PATH_MAX
> -#define MPI_RAID_PHYS_DISK1_PATH_MAX    (1)
> -#endif
> -
>   typedef struct _CONFIG_PAGE_RAID_PHYS_DISK_1
>   {
>       CONFIG_PAGE_HEADER              Header;             /* 00h */
> @@ -2462,7 +2454,7 @@ typedef struct _CONFIG_PAGE_RAID_PHYS_DISK_1
>       U8                              PhysDiskNum;        /* 05h */
>       U16                             Reserved2;          /* 06h */
>       U32                             Reserved1;          /* 08h */
> -    RAID_PHYS_DISK1_PATH            Path[MPI_RAID_PHYS_DISK1_PATH_MAX];/* 0Ch */
> +    RAID_PHYS_DISK1_PATH            Path[] __counted_by(NumPhysDiskPaths);/* 0Ch */
>   } CONFIG_PAGE_RAID_PHYS_DISK_1, MPI_POINTER PTR_CONFIG_PAGE_RAID_PHYS_DISK_1,
>     RaidPhysDiskPage1_t, MPI_POINTER pRaidPhysDiskPage1_t;
>   
