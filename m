Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818131917F0
	for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 13:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779627731; cv=none; b=BWDr5bQNrbzmF/KC/VD+zxN2HYkFForZHNF+YKB5/ZCWGZmzl0VxdVZREpBcsDqDoQD8QSRmFanywRzrl8krrrIAsT7/8LbFyJlseml8y/UJlTPnNCgsrRrI1JBubZtyNp1i/apLXmirDFVJJ3u7q9CmvTyUbETC4K3IggHTvjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779627731; c=relaxed/simple;
	bh=x54oqezZjzcqR69Lz5+rOi2b/U7qurOfZREJJeWLEJk=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:
	 In-Reply-To:Content-Type; b=LAQuOPXdNA+vH0E9tTxxaODAgd6ckfY+2g2IyAFSAqbz/xvSuRFE0Dlkat9tkyY77CDwFUEm5lhnwDuE8fQYAqMiUiuL9Gg1olRHKG2J19/EjnWUum5GEj1RwPCib6vZmh0NspzrR0dEvC+FcIqHLdshLZWFEZzAEnl6J0FEUhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eER8Ghay; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eER8Ghay"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4462f8d2488so876519f8f.0
        for <linux-scsi@vger.kernel.org>; Sun, 24 May 2026 06:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779627728; x=1780232528; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0BczETa7ybAqefN8EC/kI+m6d88JHlR4SMLprBedDDk=;
        b=eER8GhayK94Gquo3WxO2ZMkS9LzHTVe1h4VjXZXP/LcUKOXX9aaQnh7eCuR9w9wgMy
         FrIS6GAdT5ZzKxWJGA4HQUGGl2niJyIZgOzHRayX40Bv9msPN9faiqySrWNYqgcDldHN
         5Et+EPotklSdlnuh7xh7LdEFQqRPJpei/4kCD83GdeWN0BBzTS4tPASBLMvmNPmfc1gE
         3iEItPJW06knAurHxRBsMgI06iCMDhyfVnvZg4a24DJb60z7dCtEfX599U8jzp64K2GX
         VKt4qKw6U2nnL6RyCJzAmMS9Jdo58OUR9yvrx34Nhi4SFDpbTdkDn+6UA3s6C6xnWpqP
         viZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779627728; x=1780232528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0BczETa7ybAqefN8EC/kI+m6d88JHlR4SMLprBedDDk=;
        b=i+b97T3BrBe2KLvxlvY4+uKRKm3m6WPzFj6Erottq49L2Hz+ZjbOMTfGcKXa42F/RL
         oGd1lknRExPtgz1aRdjbQk45JDKBeweyh6D28Ew45XrROE4CoueLOlkcJAjBJqBAx95g
         Pyu9JoFQSNNvljjR1qhNHv0u3koDrZGvde+oDdKJtQ1LQy92HHeAmu3WeDWYtlKF5Sbc
         4vmq6cEq8EcXmZQ37UeycRbAgNOk03aOagJvHf3lUTDALCQ2x8b4ASrlgWuxswn1crQe
         lecdaRoYQj4lO0lgFoaqnYqeSjMZBHUxhAEi6O+PO86zYjp55S5k4vsyllScmVgjbl1X
         XN4Q==
X-Forwarded-Encrypted: i=1; AFNElJ91vSxCz9h1Vnf/s89icw6iMDDVZzX0VG/TDYqpIcWSWkjtSUDlcP9P9UqmgIZuUbvHhUTz6QLd/IM+@vger.kernel.org
X-Gm-Message-State: AOJu0YzYaKopUhKdLxpAsjFUWIbFgFmPvdxstTkfKgsg/1HaHToj4xfV
	TRdUooEKTxV7pKR7f0LNYYlfdmFdMBs6Kz2vK3Fh808C0ZLxMphs/vs=
X-Gm-Gg: Acq92OHG9E099VldCuwjxM2Mhs3LNFfdnEja66Zjew0E0LbEIatcDHyZL+Wue9Lw+O2
	NR29gNofNXflSQczJTMMX5zNEboS7hDDq8sByGIynqd+urHiOe29egB9soRu0wsSM/U9LHxDHIq
	fL1yTsjE3PQKf4qVrl6cq0nfcdgbZLha3exWDK9Ec8TgJkBJvaS3vJ8qIbQ+aqH+GkCIDNHdTNa
	I1cZTFETBSVsBQBgNofmItvD73yyoRWE3SfNFSoStK4/QcF344Bm4eInCVb4ouriBoA5gIOEucM
	o1k8Wg4wdt3taQq3e+MFCTnH5koVDqN+j37miYxyyVwfJXqr845dBoRE1NwZUd4eAO7DPqpSitd
	PNPpVKGEQ76axJuCc8gf4EESqF0fwomuhhrhYtV+/T2zRhv11eH3acuXrz6WEiwC6xd6bPhhPs+
	fAX1M3LyikkPrOwm0VUgGpDY9JpduRim8apU+qHnheoMjGugi88CWOxw03BNlO8rt3HPOuIDY=
X-Received: by 2002:a05:6000:2213:b0:45e:9520:d73d with SMTP id ffacd0b85a97d-45eb36b2a18mr8835651f8f.6.1779627727461;
        Sun, 24 May 2026 06:02:07 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d47b82sm19348166f8f.19.2026.05.24.06.02.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2026 06:02:06 -0700 (PDT)
Message-ID: <c13ba4ee-a40d-4a16-a0a6-6f223b2617c9@gmail.com>
Date: Sun, 24 May 2026 15:02:06 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH RESEND] scsi: scsi_devinfo: blacklist HPE/DISK-SUBSYSTEM
Cc: "Ewan D. Milne" <emilne@redhat.com>,
 Anthony Cheung <anthony.cheung@hpe.com>,
 Takahiro Yasui <takahiro.yasui@hitachivantara.com>,
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 Christoph Hellwig <hch@lst.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 SCSI-ML <linux-scsi@vger.kernel.org>
References: <20260524090735.152449-1-xose.vazquez@gmail.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260524090735.152449-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/24/26 11:07 AM, Xose Vazquez Perez wrote:

> DISK-SUBSYSTEM is a special model name returned by "OPEN-" arrays when LUs
> are not installed. This requires BLIST_REPORTLUN2 to prevent issues during
> device scanning.
> Full info: https://lore.kernel.org/linux-scsi/4AF9D98B.9030605@redhat.com
> 
> While this entry was originally covered by:
> {"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
> 
> After commit b8018b973c7c (scsi: scsi_devinfo: fixup string compare), vendor
> string matching must be exact. Devices reporting the vendor as "HPE" are no
> longer matched by the "HP" entry.
> 
> Add an explicit entry for "HPE" to restore the intended scanning behavior
> for these devices.
> 
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Anthony Cheung <anthony.cheung@hpe.com>
> Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>   drivers/scsi/scsi_devinfo.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 7a99983854f9..4de9b9dd1833 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -183,6 +183,7 @@ static struct {
>   	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
>   	{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
>   	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
> +	{"HPE", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
>   	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
>   	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
>   	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},

A brief observation: when performing a manual injection via
/proc/scsi/device_info, the kernel automatically pads the entries with
whitespace. This contrasts with how the kernel displays its internal values,

# echo "HPE:DISK-SUBSYSTEM:0x20000" >> /proc/scsi/device_info

# grep DISK-SUBSYSTEM /proc/scsi/device_info
'HPE     ' 'DISK-SUBSYSTEM  ' 0x20000
'HITACHI' 'DISK-SUBSYSTEM' 0x20000
'HP' 'DISK-SUBSYSTEM' 0x20000
