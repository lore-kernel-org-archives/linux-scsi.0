Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C492214A9B
	for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 20:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112420; cv=none; b=DotF1qtApGzcXa6A46Qyd+B6JuRm05IZzo/DUN7gMaDadIEfqZqsQnIsFPZV2+qVn1kL+SBTE/QXUIKHGAExlTeDkjrE6hQ0P+twSfV7Njr58aMNm67n2yDx/V5O7Ok5KHF3S9qeK2AoDeb5ZpXSl4apn4WLTaV10Caf6rwNdQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112420; c=relaxed/simple;
	bh=wCqaI7WVpGD8I/LJUMoulVK455m9fusXv6dkUgKAC9M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtcbr3mw94h7seITqipniiVtkC10Mj2DqRYDZuUFnpjs2yutBM92wK4iW2dlQcuiL/kwpUnh+fcecGuZvF+rcyuo3JRbMqkKooxUvIYXdMW6EY2JYUse0W6kZZIxHkyy7Hy6UAideYHe4+guqtnq6hAUrV23QcsrwIvWnNQtsDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlRkrghO; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlRkrghO"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso46384615e9.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2026 13:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776112417; x=1776717217; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPkPEzfI7VUAH2K97iljvYM+ya7M355aVFHm/wT39nw=;
        b=DlRkrghO8S9EA5bIcigTBdgRXUPpW0eGzEROQZ8ZeSLBbazSMwVzLxjm77mE8zNQCs
         Jr/TKc3uQhgqcFR6AeF7IUlzPm1tRINyJe34do4WxDVqvfidvTScpL2m+BNpOdokfwPk
         AmvpoXKtgwPFyG5AMcAVVj/1XV84rjbhjPXdErYKMdkDFc27WKIEwckKvhgQFq77Y37C
         +zgQZprMLWcxlUhPG3YErmvGMGLvEaMonNGm681Aad6X5wLsZyK0QREdka/aZa4hgoRF
         /mNicJvhqjnk3bFKYYRVvjL+Jwl0V2/WUVzcr++Cd7fiT7844I2nMF7rymoGNVqYcTE1
         dbtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776112417; x=1776717217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bPkPEzfI7VUAH2K97iljvYM+ya7M355aVFHm/wT39nw=;
        b=LprH+ZAhS5hIIjVn6PJv21AduQEh4j9DKrIUzOkCb7hZeKf3u166HCohZdQaYoaTm6
         tEI25vOHPYZ2NmrGyS/NhWnx5kiKt8DgpEUim5MettW4IVM+msnWzPKlwOF/HfVx8oEv
         9biEJI7aWlkRpLAAiMoSamKJqL1cnymfUVfWIhlL1SNHYcXowzoEmjP5jYKchWnYYvYZ
         XuCG1h1+tV0f9mJdUHB3cySbaQpZmzM24OkJJI0yUkoBU8PjftUdOaxd/NxIEft/P2Eg
         1811GYD7xKim5sRFSfoYkIM8arSXuPYv9iiM6YZsxAC7Fpr0agJ8MzdMY4THLK8ACDyi
         50YA==
X-Gm-Message-State: AOJu0YxShZCbv/zTNH6nNJcRew5K9QRdH2p5HL0Ko3bjHwskz7AIznd+
	xf5RYEfh0+yhbArrGgEvuBcjnYZU+8IaD7yczwpNTJ4K5oCfsQsWhP4r
X-Gm-Gg: AeBDieurfXMkgrhqPlKPhbdUwCB3BzUt42Iq8zNw+HPMX4sbWOfQdhMgrdqKDsAVXee
	RXfRnR22A4Ov66hoC5K8K5ddAOWwp9UVND9OQ32249yA72V1xMv97/E9dP6RyiaTDhDNe5cba9k
	vwmfqiS3Sz2edN/ZNxg9dNl718Hzu7UyuE/oFztZMjk+d7jOpdptvKkiR9XDXvqorrFM6Yt0eXy
	tz+ss6rBVzh1mO9gV1lKC7rYYbyA9SCDYYIeUzm6/KoKZywlt47dJTsceUICJH1sj0cysfgCAwk
	rPCDkLDpGqN0xIHGZAkSca/DJxFqNAO9WkeoCcuSh2GlgpfAkU8eVyy1R1CuehaOw/2szL4yIIJ
	iWj/mclIhP/wXjDJ9wQEnA07MKgs3EjVcE8UBtnoMoO8gH7Zx6l6udr7+p9Ke7gA0uz950lSiPn
	49Ayc1QvjSim0M0eBmyWXNMSoVQQeLR7WhvscCIWdxWwPqX/K6WDGO1eN84TfaHLEQ
X-Received: by 2002:a5d:5d83:0:b0:43d:30af:a173 with SMTP id ffacd0b85a97d-43d64259b7emr21409425f8f.5.1776112416875;
        Mon, 13 Apr 2026 13:33:36 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e5062fsm34336337f8f.31.2026.04.13.13.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 13:33:36 -0700 (PDT)
Date: Mon, 13 Apr 2026 21:33:35 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 sathya.prakash@broadcom.com, chandrakanth.patil@broadcom.com,
 dlemoal@kernel.org, stable@vger.kernel.org, Mira Limbeck
 <m.limbeck@proxmox.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3] mpt3sas: Limit NVMe request size to 2 MiB
Message-ID: <20260413213335.4010d8f2@pumpkin>
In-Reply-To: <20260413180003.76489-1-ranjan.kumar@broadcom.com>
References: <20260413180003.76489-1-ranjan.kumar@broadcom.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 Apr 2026 23:30:03 +0530
Ranjan Kumar <ranjan.kumar@broadcom.com> wrote:

> The HBA firmware reports NVMe MDTS values based on the underlying drive
> capability. However, due to the 4K PRP page size and a limit of
> 512 entries, the driver supports a maximum I/O transfer size of 2 MiB.
> 
> Limit max_hw_sectors to the smaller of the reported MDTS and the
> 2 MiB driver limit to prevent issuing oversized I/O that may lead
> to a kernel oops.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")
> Reported-by: Mira Limbeck <m.limbeck@proxmox.com>
> Closes: https://lore.kernel.org/r/291f78bf-4b4a-40dd-867d-053b36c564b3@proxmox.com
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9b8b84879d4a
> Suggested-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 6ff788557294..44dd439e6f17 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
>  				pcie_device->enclosure_level,
>  				pcie_device->connector_name);
>  
> +		/*
> +		 * The HBA firmware passes the NVMe drive's MDTS
> +		 * (Maximum Data Transfer Size) up to the driver. However,
> +		 * the driver hardcodes a 4K page size for the PRP list,
                                             ^ buffer ? 
> +		 * accommodating at most 512 entries. This strictly limits
> +		 * the maximum supported NVMe I/O transfer to 2 MiB.

Doesn't that make max_fw_entries 4096/8.
Assuming 4096 byte sectors the longest transfer is then 4096/8*4096.
So none of this has anything to to with SECTOR_SHIFT.

> +		 *
> +		 * Cap max_hw_sectors to the smaller of the drive's reported
> +		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
> +		 */
> +		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
>  		if (pcie_device->nvme_mdts)
> -			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
> +			lim->max_hw_sectors = min_t(u32, lim->max_hw_sectors,
> +					pcie_device->nvme_mdts >> SECTOR_SHIFT);

Why min_t() ?

David

>  
>  		pcie_device_put(pcie_device);
>  		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);

