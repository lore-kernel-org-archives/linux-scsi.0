Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1C18027
	for <linux-scsi@vger.kernel.org>; Sat, 22 Nov 2025 22:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763849811; cv=none; b=mNqPGOGpWDMOVeeQVwrqP+WKMox3nefr5zgJtiR70ndJoUn+xEqy/YHyKYFiwR09rNFC4eOage5+HBtMM3LMCvVdBMup5F5+nRcjYgdYhbo4UN3N5vgt1i0//EIUYhP/SbjCmvbzaQaHBzhmEle7RrcAhyI685nIXXY2lYUZ/gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763849811; c=relaxed/simple;
	bh=gjaBG0MplaSae752CCvUYaAdJolD9SRmKaylRSOGnCE=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=KxR/s1hOe0nBgBLPFOv/qLCs6CDtYqlAVaW325ePjWOsOgIjnPYFfvDnkmytFFVVyoFSG71OIbUKn23jx2/FDR3d27MlTJVlb7ItodIRLHftQYlSr0+SsIeua1OvXI/VD2MKDjeBQc0tusXZ+10c/h+hhjNt+7mfRQx9BwlOFNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l/1Z7ywu; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/1Z7ywu"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429c8d1be2eso340459f8f.0
        for <linux-scsi@vger.kernel.org>; Sat, 22 Nov 2025 14:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763849808; x=1764454608; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t6xNo2npM4m5mo26rKPUg+CHYT50gC5tXHfH1TpNCCo=;
        b=l/1Z7ywu/Ffv5sBRwSRvzX7ZldcmmlWafGEEgdYoWlGJWDCpArmqJdFoBVv9/8ky9G
         TOtkJY2YM93OnBWnfMsTTrB3tqb+aGOqwpWZv4ADAfZCwBgVj3sSQVP7jJy5tRQjdK/v
         UYWDCVYUDtce9SE7ojqy3FaIHSJZ4bXvNEhYbv126tAeXuEkwbIU//zWZQ7QuQDFERWy
         lGEj2mvC07UkTP/axUk5d98iUdcm3t2yFTGQs7wdCVfqz2FaXH8s1ipZpEx3YULmhMH7
         gvEdjqFPGtPh09Vp0cczrNvjxSDIYCLS0eEmqHsbVHrkcZwB0Y7kFuDkD2Pw+/yR5teo
         2VXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763849808; x=1764454608;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t6xNo2npM4m5mo26rKPUg+CHYT50gC5tXHfH1TpNCCo=;
        b=bOIGcg/ZxkbXa2H2evpVZhKRhX5rbFSF57kINmeSpF8qCgvVlYgFwhx120mfdQsFLc
         qn0wntQgvZ2GborUJkP13sM8q8wleWymOjcNYFXvdJJ+8+tmrxg2L6ll+aOPpA6YQ5XR
         PvASMbiCvGTQevmGQwAqknFrRCEKQA5zSdyPF2b/RxO9oRmRd7xMuzRMDdYCCWCXnzGo
         a/ubdTK2OEqz5K/itbsrG1mI0z3DOz3xjDr/vg65jLMppFXPZrapfg2UzvYxzFlgZz3p
         M6Ve+f13gkFG+XyATntCsnrNo0aCiL7VkRR3+DXwwec7wr0zQuqPGewtNdfrseTip32l
         wPYg==
X-Forwarded-Encrypted: i=1; AJvYcCX208vfNwfq4clQZB5RMLT1e4gvr/tdwF/d3TSrg9wL4KBHIYoe71HlFenblpyKxDBx1xHQnPwo39gz@vger.kernel.org
X-Gm-Message-State: AOJu0YwNIwEULhYed6zp6aoXA8ksQ4/wRrWPs/M/iILdgh8HRHhil0DY
	JEF749v9NO2Sw1LZXCKVg+N0wl+gsz/ALdfvDD/bqj1XWiN16g9CZ9n+GEtmeV7j0w==
X-Gm-Gg: ASbGnct9R2u8BWmQ8azkvZzl5mdJ8gmgtTyti1iCbMXZT4Wtg0HW/BR02WrIcqZB/zR
	Pq9sooUDGXQMwROnzS33WYqOQ7qHztfQ1srgRWius2qbITWawCSmIhUAc8ZQ7Y1xxBn06A80i47
	nOxPsH4ZJMFwbQrgIecXRC2Nt/heRMBHqWlOqnN9lHHlPpd6dDp3Bu7eKGsY47sXtPjCWHFwT1h
	OB+JqpzKKK9bYJHOtnYxU4CZXk9y9dGkKFH3Zrvoqj1jCEFp7LPVrKLrs+H5wLB5adNPv62DCwl
	XxOEmo6C7YCK+BFtW36a0FllIaj4Sc9EpQwEGFNGmnLCJJ0uWZ1nYVXkQHmCDCvhNHZu3tawcuj
	nOgFrUL286Wse/QE18Xrt//gRnaUGtRcuxd7eDthLfOO+sROAw4nGR1zZ9kz3nO+EM3YkEuHmOG
	OOKzPpUAK1tA2lDQZK0at+ULpgCR7UiPavgZG7lDsm0ou4xr7P
X-Google-Smtp-Source: AGHT+IGLzcrUeLpcGrhICOxxZiKPhq4w/rxOpJ1g58E3mhxlEuUNHoN2f9KlOgz21MRuTE18i60jFw==
X-Received: by 2002:a05:600c:1551:b0:477:9f61:8c20 with SMTP id 5b1f17b1804b1-477c311cdd1mr37370245e9.2.1763849808244;
        Sat, 22 Nov 2025 14:16:48 -0800 (PST)
Received: from localhost (98.red-80-39-32.staticip.rima-tde.net. [80.39.32.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf3af0ecsm111697825e9.9.2025.11.22.14.16.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 14:16:47 -0800 (PST)
Message-ID: <924c8c63-904f-4da4-afdb-5ac5de403dca@gmail.com>
Date: Sat, 22 Nov 2025 23:16:47 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] scsi: scsi_devinfo: blacklist HPE/DISK-SUBSYSTEM
Cc: "Ewan D. Milne" <emilne@redhat.com>,
 Anthony Cheung <anthony.cheung@hpe.com>,
 Takahiro Yasui <takahiro.yasui@hitachivantara.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 SCSI-ML <linux-scsi@vger.kernel.org>
References: <20251004145459.58259-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20251004145459.58259-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/25 4:54 PM, Xose Vazquez Perez wrote:

Same here, any problem/drawback?

> DISK-SUBSYSTEM is a special model name returned when LUs are not installed
> in "OPEN-" models. Full info: https://marc.info/?l=linux-scsi&m=125424006417825
> 
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Anthony Cheung <anthony.cheung@hpe.com>
> Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>   drivers/scsi/scsi_devinfo.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 78346b2b69c9..b39019f57db6 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -185,6 +185,7 @@ static struct {
>   	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
>   	{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
>   	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
> +	{"HPE", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
>   	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
>   	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>   	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},

