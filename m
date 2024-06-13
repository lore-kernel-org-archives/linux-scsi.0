Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1A814A4C1
	for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2024 19:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718307260; cv=none; b=Vch7e4ggAUzmT3C/Zp3JOIbRbzdg/O67kujUY0vp/A7vi2badY1uTN4rT1wizmN8f5H1dFE2d7U22WRAAei5uYhO2Z/bhT0K8R7bdaKqMrk7B5c8O7yGJ+IYsXZHlXH7rls/Xq5W+66uUiDkPS1a+NZtql/W4ATOKNQsm7FC7Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718307260; c=relaxed/simple;
	bh=7aG7kDyVxZ+xKhQ+yxWUmVgAOGSJ6gommzR9sbbVuMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DGSQ2iqgMDsTlZOce7asJoZQAX9n5L/3bzPmAa+HIVcimyTASka4lUK9a0OBMX+K8HvMBU3ygyXk4MHTdyr5brDbUyr2CYtQBQKwnZ9QIaD2NdUyzRZYPfwE0fwSDInr+TLhOCUqZJsX7jNr3CLzXkvX1/ECdBr3zjRfjNCzwM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i5D/PYSo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i5D/PYSo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718307258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IsYvLqgq+E3FY1k2F2Fg9bKLYI4WtRPTLB94zlxiIg=;
	b=i5D/PYSoyQUp5NVLqoHwabGk/Ey8k2FUVS8W1HDsQXJVw2Ih1B8gijofV5Uvuj2V/ygBYN
	UoXPCiGWvnmR2E1qQIsF4EQc9+GhTfaidMwNtSMualw+OoFiYWJGTkCNYxX75n5BusRqwD
	iaiRK9M5KScAONsHL/8oFOiLpeZT9Sw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-bOFe1CrhOg2ol2wOuq_vPA-1; Thu, 13 Jun 2024 15:34:17 -0400
X-MC-Unique: bOFe1CrhOg2ol2wOuq_vPA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-62f4a731ad4so27420147b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jun 2024 12:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718307255; x=1718912055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/IsYvLqgq+E3FY1k2F2Fg9bKLYI4WtRPTLB94zlxiIg=;
        b=XeNheVv9SDjRrUVvQqeFMW/VN7+98CBkwCvqtXelzLnqN8C1MFwu8c3TLiyPUz6TWs
         zWBUT8c+p84slO0qPkK36dSksSP3QL07k4YHcMB5R/xME/JicWnmgN/PqiUONzB6K5Yf
         cp2aICb5k7p/U2/ho6ddM+RrfjklVQFro+rPCJqefTboJIZrx7nn19Dtu28KePWHRE1o
         fmDpK4z7hrlpsQi9JmL53nB8qQ3vqIvqYjrONw/roDJFvhSNV4u5BPvFpQGTkeG4XiN+
         Ben24Wdjo2rCJQu3ZD+hxEhWWeGY4hHfPTJ2vw3Tp6z55ec1emggXxiR05qcZjm4r3Wp
         0XqQ==
X-Gm-Message-State: AOJu0YzjSBxVi/P6frRq/SGUPrG6IQ+oaq2aBNruSO2VsnGRppUq61U4
	NGer/K+C2yefAwH8YkKyDv4bWl6mavR2ZCcSliAC54eyacbK9EcejQFvxg/ks1fWvoLwrAgRkek
	MEVqwuPKF1LFF6Ex3Oi4ThcTe0XANqj+p94dC9YSYOVlBKR9f8RI8oSE5k5o=
X-Received: by 2002:a25:d041:0:b0:dfb:96e:1f15 with SMTP id 3f1490d57ef6-dff1549168cmr469708276.42.1718307255313;
        Thu, 13 Jun 2024 12:34:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGr91FD/R6YxAjrE+liHylnQVNjnoxStaUZFpGCZ5A09J3aRTJXCfWk80vcxy79HA4dylVI2Q==
X-Received: by 2002:a25:d041:0:b0:dfb:96e:1f15 with SMTP id 3f1490d57ef6-dff1549168cmr469682276.42.1718307254907;
        Thu, 13 Jun 2024 12:34:14 -0700 (PDT)
Received: from x1gen2nano ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a5c27786sm9995666d6.55.2024.06.13.12.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 12:34:14 -0700 (PDT)
Date: Thu, 13 Jun 2024 14:34:12 -0500
From: Andrew Halaney <ahalaney@redhat.com>
To: Joel Slebodnick <jslebodn@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, peter.wang@mediatek.com, 
	manivannan.sadhasivam@linaro.org, beanhuo@micron.com
Subject: Re: [PATCH] scsi: ufs: core: Free memory allocated for model before
 reinit
Message-ID: <6krasewc6bps43ivmk6eez2v7clnpoxczpctnp7jhgthpjpaqz@hk2yip3wknsc>
References: <20240613182728.2521951-1-jslebodn@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613182728.2521951-1-jslebodn@redhat.com>

On Thu, Jun 13, 2024 at 02:27:28PM GMT, Joel Slebodnick wrote:
> Under the conditions that a device is to be reinitialized within
> ufshcd_probe_hba, the device must first be fully reset.
> 
> Resetting the device should include freeing U8 model (member of
> dev_info)  but does not, and this causes a memory leak.
> ufs_put_device_desc is responsible for freeing model.
> 
> unreferenced object 0xffff3f63008bee60 (size 32):
>   comm "kworker/u33:1", pid 60, jiffies 4294892642
>   hex dump (first 32 bytes):
>     54 48 47 4a 46 47 54 30 54 32 35 42 41 5a 5a 41  THGJFGT0T25BAZZA
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace (crc ed7ff1a9):
>     [<ffffb86705f1243c>] kmemleak_alloc+0x34/0x40
>     [<ffffb8670511cee4>] __kmalloc_noprof+0x1e4/0x2fc
>     [<ffffb86705c247fc>] ufshcd_read_string_desc+0x94/0x190
>     [<ffffb86705c26854>] ufshcd_device_init+0x480/0xdf8
>     [<ffffb86705c27b68>] ufshcd_probe_hba+0x3c/0x404
>     [<ffffb86705c29264>] ufshcd_async_scan+0x40/0x370
>     [<ffffb86704f43e9c>] async_run_entry_fn+0x34/0xe0
>     [<ffffb86704f34638>] process_one_work+0x154/0x298
>     [<ffffb86704f34a74>] worker_thread+0x2f8/0x408
>     [<ffffb86704f3cfa4>] kthread+0x114/0x118
>     [<ffffb86704e955a0>] ret_from_fork+0x10/0x20
> 

With the following in place:

    Fixes: 96a7141da332 ("scsi: ufs: core: Add support for reinitializing the UFS device")
    Cc: stable@vger.kernel.org

feel free to add:

    Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> Signed-off-by: Joel Slebodnick <jslebodn@redhat.com>
> ---
>  drivers/ufs/core/ufshcd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0cf07194bbe8..a0407b9213ca 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8787,6 +8787,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
>  	    (hba->quirks & UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH)) {
>  		/* Reset the device and controller before doing reinit */
>  		ufshcd_device_reset(hba);
> +		ufs_put_device_desc(hba);
>  		ufshcd_hba_stop(hba);
>  		ufshcd_vops_reinit_notify(hba);
>  		ret = ufshcd_hba_enable(hba);
> -- 
> 2.40.1
> 

