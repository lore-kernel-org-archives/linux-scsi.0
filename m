Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8632A16D9DE
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jul 2024 18:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720721697; cv=none; b=Hvh8RndqmZ82M51PmhYq8lyQdaO7WrmjHGMs7TyHyUzG4h28vseXul5ylVcBV5UAwYMzfKu6GOGpXID1tuR+PRDVyHFGJc+d5VyrJ8JoRNLM/fYxaKPHvybhathQLUFi9cjFmposkOiFg5ZKBm2Yn0d0iGPsF1j3qKuedDMSR30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720721697; c=relaxed/simple;
	bh=P6LDmK93U1lmcvUtz/g+YEy/JFGbusq/eFbDSErrnOI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g0859SPfhpgoDFA61ZS7QB0cdbfTS5F0X1srNNMi4FAWUBqyfp/hULHDg65vlIju2eDWfrtjSPhgycobSN1l9eXBLWZWYLPn4F/7odHwvHAbFMhNDBgjSEKyFvFd2WVJH7SGXAPQyBOwCs3po34qxMs1eOHkAeLEh6dZXcertyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=fFBdf0tG; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="fFBdf0tG"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id RszVs8a6KnNFGRyJisI0Gc; Thu, 11 Jul 2024 18:14:54 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id RyJhsiCkPuKXMRyJhslxDn; Thu, 11 Jul 2024 18:14:54 +0000
X-Authority-Analysis: v=2.4 cv=ANnGoFku c=1 sm=1 tr=0 ts=6690211e
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=frY+GlAHrI6frpeK1MvySw==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=3O__t03nxoAqBYxMqfAA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=Fp8MccfUoT0GBdDC_Lng:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EtNgFKTf1JRxAljXuM18p8ruKQeqJrRBQr8MDinNaDY=; b=fFBdf0tG94iMfBB1M6WtWLO0nv
	OzfYAZI7Klufm5rMYb+9joOqUfOjIGzmMAEj87nwBKK6/ZxzCDtMMJ08qpyb/LtSQpxinq08fqqlm
	CIkTt1J+kj2UJLj5WNbrUVu0Nk3yVHOHVIH6Cj6eMz0tOPQXGPMVlIAVFdnyLUlN87QC0uY5hI1QE
	VU9lmgji7aqsktWlB/7GgNxP8EUEtPI/zNRi4EMyHkqfXqP48xTomx9O/u2h/tdprO4I2RpsT/EXu
	y5Ul5hzOF2h1iPdaAXLJnYcH8ZVSRmabAU3N4m85Fj9aZwaWJ8wCIIaHI7nW2WnW5f72lXAMIQPyQ
	xEW28uGA==;
Received: from [201.172.173.139] (port=46506 helo=[192.168.15.4])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1sRyJh-002Gk3-03;
	Thu, 11 Jul 2024 13:14:53 -0500
Message-ID: <150c78b4-be2f-496b-be5f-7d2454edd17a@embeddedor.com>
Date: Thu, 11 Jul 2024 12:14:51 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] scsi: message: fusion: struct
 _CONFIG_PAGE_SAS_IO_UNIT_0: Replace 1-element array with flexible array
To: Kees Cook <kees@kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240711172432.work.523-kees@kernel.org>
 <20240711172821.123936-2-kees@kernel.org>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20240711172821.123936-2-kees@kernel.org>
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
X-Exim-ID: 1sRyJh-002Gk3-03
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.15.4]) [201.172.173.139]:46506
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 27
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP5rG/sgsAy2f45920l5+IO7bJsQE6JmcMfSfFn2TJAS3a4/ferBuX0flLr7AEjqyTIqSK8BLfxyP3t9h7FA8rCMt2eVkObZ5JFyMt3+gJaMjCdZK1jP
 q9hYOAjzGn05RkpsCRqK1UucAxrj3SGeYC+OrF8WWU1IIkXRjGcnoqwdd99jmI/3/YUwroPQnQNJFHb0jvbDT1j8GDgD7UD26vfbX54xE1eZbFnc7oOnD3gi



On 11/07/24 11:28, Kees Cook wrote:
> Replace the deprecated[1] use of a 1-element array in
> struct _CONFIG_PAGE_SAS_IO_UNIT_0 with a modern flexible array.
> 
> Additionally add __counted_by annotation since PhyData is only ever
> accessed via a loops bounded by NumPhys:
> 
> lsi/mpi_cnfg.h:    MPI_SAS_IO_UNIT0_PHY_DATA       PhyData[] __counted_by(NumPhys);    /* 10h */
> mptsas.c:       port_info->num_phys = buffer->NumPhys;
> mptsas.c:       for (i = 0; i < port_info->num_phys; i++) {
> mptsas.c:               mptsas_print_phy_data(ioc, &buffer->PhyData[i]);
> mptsas.c:               port_info->phy_info[i].phy_id = i;
> mptsas.c:               port_info->phy_info[i].port_id =
> mptsas.c:                   buffer->PhyData[i].Port;
> mptsas.c:               port_info->phy_info[i].negotiated_link_rate =
> mptsas.c:                   buffer->PhyData[i].NegotiatedLinkRate;
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
> index f59a741ef21c..c7997e32e82e 100644
> --- a/drivers/message/fusion/lsi/mpi_cnfg.h
> +++ b/drivers/message/fusion/lsi/mpi_cnfg.h
> @@ -2547,14 +2547,6 @@ typedef struct _MPI_SAS_IO_UNIT0_PHY_DATA
>   } MPI_SAS_IO_UNIT0_PHY_DATA, MPI_POINTER PTR_MPI_SAS_IO_UNIT0_PHY_DATA,
>     SasIOUnit0PhyData, MPI_POINTER pSasIOUnit0PhyData;
>   
> -/*
> - * Host code (drivers, BIOS, utilities, etc.) should leave this define set to
> - * one and check Header.PageLength at runtime.
> - */
> -#ifndef MPI_SAS_IOUNIT0_PHY_MAX
> -#define MPI_SAS_IOUNIT0_PHY_MAX         (1)
> -#endif
> -
>   typedef struct _CONFIG_PAGE_SAS_IO_UNIT_0
>   {
>       CONFIG_EXTENDED_PAGE_HEADER     Header;                             /* 00h */
> @@ -2563,7 +2555,7 @@ typedef struct _CONFIG_PAGE_SAS_IO_UNIT_0
>       U8                              NumPhys;                            /* 0Ch */
>       U8                              Reserved2;                          /* 0Dh */
>       U16                             Reserved3;                          /* 0Eh */
> -    MPI_SAS_IO_UNIT0_PHY_DATA       PhyData[MPI_SAS_IOUNIT0_PHY_MAX];   /* 10h */
> +    MPI_SAS_IO_UNIT0_PHY_DATA       PhyData[] __counted_by(NumPhys);    /* 10h */
>   } CONFIG_PAGE_SAS_IO_UNIT_0, MPI_POINTER PTR_CONFIG_PAGE_SAS_IO_UNIT_0,
>     SasIOUnitPage0_t, MPI_POINTER pSasIOUnitPage0_t;
>   
