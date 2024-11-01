Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3658614A0BC
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2024 07:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730447598; cv=none; b=B69BlWwh1Ti0GkfcBtrnQenpsbPMGUwRArnu147ILn81BhP6tv8hcHCnYH+LSej1ulN7Di3nlPlKujnQ+ijRZZ7yanuepnO0/2O/dP0l4zkcFV74ldgj/X9bfGdPtKnHeaYBjMkIK3Fz4GdyznFf9o0zlsOi+Y46BLIXyr0IpnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730447598; c=relaxed/simple;
	bh=OnxwKjBXcxw/5vZfONag4e67h9X3MmggKzbRjpYrwrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4opKvZ0WyzTaBnaAEStRqNAVXEmCqMlcexTJ/XFO0icd7LXWCUmuzOodq6ZDucesoEkzOVK45blQwgp62eL9Htkg+BIMXh4M1t32Ixc//gXFSBDVYjJJwbSR28fz5kF9gpBhJom2zTxECkYt/NA9HgmjzLqq1UroWF+exeCkgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sIAC5t35; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sIAC5t35"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-210e5369b7dso17671035ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2024 00:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730447595; x=1731052395; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ztVxJEe/jOSJ9Ml4ROlvkUWalRiacha0D31LgOc8Uxw=;
        b=sIAC5t357g3tx1fmHA+rNp2KJCXQL9Jeihd4jdb/htVNv2iWAQMHQ2O7HTDmttv4mf
         L4nEErcsKayc3e+NQ9EooCRPEQWY2+J7i9QvG6dfFN5p7wsi5cTItU0Nvyrmb4rR8COX
         QYxqN9cOataOouX2XYiDz23gvRawtzrcyXhCjG/9aOCKWODKq1aIMJrXRQWz2+ARldQG
         bm2GAGDiG+Fziz1YWBD5O8IsCU+TVpJBFXT9DueCR57ZNsQ4yji6l2S6LEvEVB/oBeiy
         iHWLSwiK52pOrIqM0BTrE+e6bvpVmoExIBeQzh/3DbGT/kVHoE5e/7MOC1E/HwLNqbKC
         WieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730447595; x=1731052395;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ztVxJEe/jOSJ9Ml4ROlvkUWalRiacha0D31LgOc8Uxw=;
        b=nzDnxR55LltrsZVYmSwHe2DbCqXOMYSRULBdiZbHK7X3+pqFYblzIzyfNvAGdbsrrN
         F0NsT7/gq3WIxKI8gVGSj7sxMkoIM67JbK8hJquJ6kzDaMAlFWTXsJdU1+/trZeiiFb3
         ENv8NK+Wzpu0mCvRV/CbPKZPTcyZ3DYxkCmuGaQ3nEvwhHF7tQ12jiPjxiTm2KAWFadE
         6adWLuhGRrIcUgd+Dld/S1s1u9E8ew2TgoVq4xR4Nm+csxKLhcbciH/rrdlG4JyUKM7T
         H8KMRp1Bq1ao3zeI46RW0kTSOmW1wXas/loAazTJElUSHn46QkuxmUiHZ/nBcxe1tN6+
         pq6w==
X-Forwarded-Encrypted: i=1; AJvYcCV417di8ZQ3p1SKaa9kEEZNwYFEtM2DtKDolG2DYcRAalvpl0SB/wtrCaiFGFLbmb9+Div6Iv4Jsi2U@vger.kernel.org
X-Gm-Message-State: AOJu0YxZmUS8IvNpiIVjdBxKZ58OuoX9s8dEDME8h2dwzCn6Pz/0rx/L
	joHDVCaVjB3W4hqM35xHvXcjg41scCcbvksooFYJzQ9+Fyi31eGKHb7zHuCnj9KIKOggRj0gl1I
	=
X-Google-Smtp-Source: AGHT+IEPnjTALvsjz+OVsD/g0Dvq9dRh2UFhREHvFbKpLbNZ/w7fN9nfPF1Pb8sLlfnqttEc4WO/+A==
X-Received: by 2002:a17:902:e5cf:b0:20c:6392:1a7b with SMTP id d9443c01a7336-2111af16efcmr33190905ad.2.1730447595558;
        Fri, 01 Nov 2024 00:53:15 -0700 (PDT)
Received: from thinkpad ([120.60.51.213])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057d472asm17551735ad.262.2024.11.01.00.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 00:53:15 -0700 (PDT)
Date: Fri, 1 Nov 2024 13:23:09 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bean Huo <beanhuo@micron.com>, stable@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Mike Bi <mikebi@micron.com>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Luca Porzio <lporzio@micron.com>
Subject: Re: [PATCH] scsi: ufs: Start the RTC update work later
Message-ID: <20241101075309.wvfv2fcjeuimcihj@thinkpad>
References: <20241031212632.2799127-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241031212632.2799127-1-bvanassche@acm.org>

On Thu, Oct 31, 2024 at 02:26:24PM -0700, Bart Van Assche wrote:
> The RTC update work involves runtime resuming the UFS controller. Hence,
> only start the RTC update work after runtime power management in the UFS
> driver has been fully initialized. This patch fixes the following kernel
> crash:
> 
> Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
> Workqueue: events ufshcd_rtc_work
> Call trace:
>  _raw_spin_lock_irqsave+0x34/0x8c (P)
>  pm_runtime_get_if_active+0x24/0x9c (L)
>  pm_runtime_get_if_active+0x24/0x9c
>  ufshcd_rtc_work+0x138/0x1b4
>  process_one_work+0x148/0x288
>  worker_thread+0x2cc/0x3d4
>  kthread+0x110/0x114
>  ret_from_fork+0x10/0x20
> 
> Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
> Closes: https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org/
> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Bart, Thanks for the fix! While looking into this patch, I also found the
weirdness of the ufshcd_rpm_*() helpers in ufshcd-priv.h. Their naming doesn't
seem to indicate whether those helpers are for WLUN or for HBA. Also, I don't
see the benefit of these helpers since they just wrap generic pm_runtime*
calls. Then there are other open coding instances in the ufshcd.c. Like

pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)
pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev)

Moreover, we do check for the presence of hba->ufs_device_wlun before calling
ufshcd_rpm_get_sync() in ufshcd_remove(). This could be one other way to fix
this null ptr dereference even though I wouldn't recommend doing so as calling
rtc_work early is pointless.

So I think we should remove these helpers to avoid having these discrepancies.
WDYT?

- Mani

-- 
மணிவண்ணன் சதாசிவம்
