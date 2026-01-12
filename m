Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB87626561E
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768255334; cv=none; b=EKXAl7FIPcE8hI84VIZD1WZCXziJoaKBv12qoIYZx+1vVCSIa69idVwgi7ovXJ570nW4TQ25gKe3Ps1U4Tc0+Z5viW0MfzGJ/SLdTjVYaO1ClPLpyWconILSfLbXsVgbLtwZikzDH4RGdb5c9lV/2GRbqPQkVXPHQwNtzaADHyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768255334; c=relaxed/simple;
	bh=uNPEhooWM7nMuk8BxxGPe54nAPEwblBc6LywLIxFkiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L8FWByaQcoiaM2lEdZ8S6OsNf1pBtGsFKR2q6PJAGl85xNdkl1Khlh2uxdmDgXsKkmYKIEEgUj228xImhwbE8p8PWWpol7EzERA9o+p49W0iljHe4L9tSxFYf1EEepPwwtruLMXfZomlS6O4khW0dNOLEiEBTHefAJVaBykFlQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cavAcKXr; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cavAcKXr"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-11f42e97340so1839557c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 14:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768255332; x=1768860132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Mgr+mizZlg6mGy3rYGsy0TuYZ7s7SAHVl0VF2n3R/X0=;
        b=cavAcKXr4RhENP4+kcXi3QNDon5jrwKbuQYM7MojD17SiovowdUh4Ii3CMA0rQlZwH
         F/MbD159R/Li/jG9pMSAt/axy4CYLm/Xygk1QmAUw5aXSJZiXVgBfneY9Th3loyvFB57
         Q7O6AobZKqccHUXc80/D8zPj6Qy28VDKov4HxD633xakwk4WEbctwMcsOnkCvJH5+4Ib
         eOkN2yz7zIfxQhsBtx5G29HhU13Ls3LIdOuUFfrGFR0rf9rzHnrZ2iwEZGNIdZW7kV/I
         sBS3EkY0KQS6NOGSd0LfFy7Zb5tKM+tAM0g+6uMsImulwMrVntddVUuMC4gMSxTyxYw+
         zh4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768255332; x=1768860132;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mgr+mizZlg6mGy3rYGsy0TuYZ7s7SAHVl0VF2n3R/X0=;
        b=ifjJMblgWFyuLX9F5g0Qia+LYj1mZK6xDcc5QbRmi9AVY7mMsMiGmMUMvD5z6suB6l
         zBGq/gNlQ6ZJVdVeboWCW2U26fNnL+e70FGrzdlGqQn20p7bACkqiqFTY7igFTdVT5sV
         Lks79pa6bxUUN2yR4ktI1jKB1/qSUsPHY/Lm9+1Qn3O/CYxT/rkfqWLC3g/b2Jn/ZnAh
         DPMy5kB9tGGDYz+1/bUh11aaNw6OME3OmNm3p/4oqS82CSLs6TSTtz5IOE3skAJVk0PL
         xyN0T3rmrPZ6AF2lrs8h4/jZ1Vm+f0sAD4rfutgLNJHS1dbdLK5/NaSw4tp4kJmhZtga
         Iscg==
X-Forwarded-Encrypted: i=1; AJvYcCW8vymkbvl++q+ZKgz0WWJ2TbPLb2/eqts9SU202+otoYlXtkwwYK3cPWMFONhGzL18d/rCILd2Ln2i@vger.kernel.org
X-Gm-Message-State: AOJu0YyKIvuWSUuGpFbGQNb9HzfBdUvDR/2G8poRA3KI59N+Dv76bWzY
	WzAxbth7yGUi+rrXoeQH4H+gj0nsXW2YbqeN6UX7z6JWkmlpJmHd4QGn
X-Gm-Gg: AY/fxX53P9Z+YLjboro1RTll1/QdTxXKA0PmK0cCIbEWucZ/VWKdkMuOXwYgpnZFMWu
	RZU724MllIiUiVCdzyyyi46TRicgEdnnvwSeXF+X4demKUfbwVV/TEKccSHdX6OoDrItvitW4UR
	8PX4LtQXBlgEp+iL+TqMb90jBGzjYUQzz4wBsFtmqHBiazKNYIpRIEma86l3RWjrp13iQVaCVuB
	c7VTim3StcuQpJ9Ufdps+cGB2YMa8/+JmkEz8Euoq5i2skxuEUP09X779FaTG0awwSfZ2MinKGN
	3LsZ0uM6P4RJLBXj/80j6Xsmw1aBQxcWC9/M78KhMR20oPVx2PrhT4AOhhHzICK4Qpld6qkNBpy
	0SW+WFtGXzAwv8MuJs/mj2Zn0brrwpL/mVPD2h1VlSg52cMEuI17fP0OMSeC0ubrih6D/33V27f
	zeAR1FoGLqNwAIvneJvhBkIJWvA0tpsRkK8f7hD09Tpcqw3Of8de860NcLL25u2VLjUQ==
X-Google-Smtp-Source: AGHT+IHP8nj7tEMqqDVdfJUkFuriKZ8eZm2ukt0pxr6RnIKOuuV3l2nrlktNGSDsjdH2YL6e4MamXw==
X-Received: by 2002:a05:7022:41a0:b0:11b:7970:ea3f with SMTP id a92af1059eb24-121f8b4e293mr21232191c88.25.1768255331762;
        Mon, 12 Jan 2026 14:02:11 -0800 (PST)
Received: from [192.168.1.59] (c-24-5-244-16.hsd1.ca.comcast.net. [24.5.244.16])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b17078dd84sm16268238eec.17.2026.01.12.14.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 14:02:11 -0800 (PST)
Message-ID: <f0d97bec-3eb9-4a80-b179-fb29353f471c@gmail.com>
Date: Mon, 12 Jan 2026 14:02:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qla2xxx: sanitize payload size to prevent member
 overflow
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>,
 Manish Rangankar <mrangankar@marvell.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260106205344.18031-1-jiashengjiangcool@gmail.com>
Content-Language: en-US
From: Himanshu Madhani <hmadhani2024@gmail.com>
Organization: Upstream Kernel
In-Reply-To: <20260106205344.18031-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/26 12:53 PM, Jiasheng Jiang wrote:
> In qla27xx_copy_fpin_pkt() and qla27xx_copy_multiple_pkt(), the
> frame_size reported by firmware is used to calculate the copy length
> into item->iocb. However, the iocb member is defined as a fixed-size
> 64-byte array within struct purex_item.
> 
> If the reported frame_size exceeds 64 bytes, subsequent memcpy calls
> will overflow the iocb member boundary. While extra memory might be
> allocated, this cross-member write is unsafe and triggers warnings
> under CONFIG_FORTIFY_SOURCE.
> 
> Fix this by capping total_bytes to the size of the iocb member (64 bytes)
> before allocation and copying. This ensures all copies remain within
> the bounds of the destination structure member.
> 
> Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
> Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index a3971afc2dd1..a04a5aa0d005 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -878,6 +878,9 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
>   		payload_size = sizeof(purex->els_frame_payload);
>   	}
>   
> +	if (total_bytes > sizeof(item->iocb.iocb))
> +		total_bytes = sizeof(item->iocb.iocb);
> +
>   	pending_bytes = total_bytes;
>   	no_bytes = (pending_bytes > payload_size) ? payload_size :
>   		   pending_bytes;
> @@ -1163,6 +1166,10 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
>   
>   	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
>   	    - PURX_ELS_HEADER_SIZE;
> +
> +	if (total_bytes > sizeof(item->iocb.iocb))
> +		total_bytes = sizeof(item->iocb.iocb);
> +
>   	pending_bytes = total_bytes;
>   	entry_count = entry_count_remaining = purex->entry_count;
>   	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?


This looks fine.

Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>

---
Himanshu Madhani
