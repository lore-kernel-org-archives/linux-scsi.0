Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C94155741
	for <linux-scsi@vger.kernel.org>; Sat,  2 Nov 2024 10:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730542880; cv=none; b=YOlUpxXnUSkFFbjwE0mZo9w/mronoh9fwQKQixj5/f2N0WU+TyTyNn7rAhfsWfv4llXX6fHiYfpZfIPOPKtgk3eJ4zpNNq7hP9r6rFZuu4B7ggG0h9iscWmo/E2Ae1lfev2o6OewWRgFh6aVvmwRiiPa7e9J/muQPjO4c08OpIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730542880; c=relaxed/simple;
	bh=ZOodgR/d4O54xFowCK3n036fWi1j1ukK7pPlAioRzzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uuOhTbqzgEdTEeytl8HE0yv/GBf16Yhf0fTmc/eMEBzLv5fTzx6WaEP7fKOwVqJSbB67LHhFoUd2haxjpgJw2kuRzD1kReIXem7oSwIQLDj44BYWilSZZhiyzgefe9RYb/ybkuxcZ/yzY2jF9URq2yQTiA9o9s+GTvBBBlZFP2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ARQiyEPy; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ARQiyEPy"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2e59746062fso2287419a91.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 Nov 2024 03:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730542877; x=1731147677; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w9mwOpHSxODzjR4q2gkwlcsshDXVuzZCm5e0SLSUeV4=;
        b=ARQiyEPyvwzojAVH24SJ2o5MUQz8s4xkChTHwPyQcRZKEYeenwcbcBT24Gxg6LHSHZ
         eNfoObhZ5mWGxYZ5i5ns5pTqOkxCi73Ph6sQEoM5C4uVt1yW0JCI4j/TEuck6TW5Edp8
         ExvCmdb+ljHINH320ROUan6C2MNo/DNW2K9HlsvSRQUKiPoUse9RBTqhEyiL9dopi4Pc
         vMrNFWD09EqIYlWDz4eji9BhO461dND2WzLNw69t0wykw0PyM3tC9GW8xu7//0Qe+FFm
         bwpqDGg2AVxmvwCABEp/U8TLysOoxUIPdW+54kug2LCR8ZaZ6Yr6pTYo8b8DflFUmWMA
         bZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730542877; x=1731147677;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w9mwOpHSxODzjR4q2gkwlcsshDXVuzZCm5e0SLSUeV4=;
        b=eOtFdH3cojfxdwJiMBns7Zxd2gGawrwBb0c4UWMxsdosFtfF2RxXv5qpkJbZjhlWkE
         c9O8xDcz6Sj+2BpujqF0pH9WO1SUBrsZz3YcB5XB0IXEi26JtRK664kZrl3+Cv3+wAyP
         Uf6oheHsUa/z8B7qT8atNWZi82jSwiUPA1et2q1ybSwomJf8XpddLmMr9sIoPHV9JSPc
         9J3AgcFGa5BOlrKB5I0JMCCti0DOOVfR+XuaH7GUbiCfaWSIDKOUQZkCwABfRuMhwLbD
         Y3s99IS3qKYVufXL6jt6/nv8D1oD19y40vmnApl/eZy7Om/WjpDOaxDOS0W55HRmiEqM
         XEYA==
X-Forwarded-Encrypted: i=1; AJvYcCUVJh4Hk59v0+DJEOr5JsxfJM3+bG27yOmR9CV7Pq9jpNpD+ld9EuThgdEwtPc6gRrBkS3j4EsDbkEn@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf1n/CmLD444s3dsvKna0HyLVdqUZBcYBhSczQWoO0bFybmNUd
	z+uNwfJrZ3N0a1XoSCRHwPpWE6r0+SI35J7hnKjh57v4zuufEfkGKqlfy55xxg==
X-Google-Smtp-Source: AGHT+IFQCMS+POsjhJnQMJVJG/NE/hbjOr+SRMbBRpwX75NFlHjZyZ5RYkHfcl7EplG04iGXXvnk5w==
X-Received: by 2002:a17:90b:1bc8:b0:2e2:bd72:543d with SMTP id 98e67ed59e1d1-2e93c31ef6cmr11561510a91.41.1730542877009;
        Sat, 02 Nov 2024 03:21:17 -0700 (PDT)
Received: from thinkpad ([220.158.156.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e93dac0150sm4036470a91.25.2024.11.02.03.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2024 03:21:16 -0700 (PDT)
Date: Sat, 2 Nov 2024 15:51:08 +0530
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
Message-ID: <20241102102108.zmoj7rq53ffr3gnj@thinkpad>
References: <20241031212632.2799127-1-bvanassche@acm.org>
 <20241101075309.wvfv2fcjeuimcihj@thinkpad>
 <116df065-ab9a-46e2-90eb-9ae5f5f01b70@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <116df065-ab9a-46e2-90eb-9ae5f5f01b70@acm.org>

On Fri, Nov 01, 2024 at 09:31:27AM -0700, Bart Van Assche wrote:
> On 11/1/24 12:53 AM, Manivannan Sadhasivam wrote:
> > On Thu, Oct 31, 2024 at 02:26:24PM -0700, Bart Van Assche wrote:
> > > The RTC update work involves runtime resuming the UFS controller. Hence,
> > > only start the RTC update work after runtime power management in the UFS
> > > driver has been fully initialized. This patch fixes the following kernel
> > > crash:
> > > 
> > > Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
> > > Workqueue: events ufshcd_rtc_work
> > > Call trace:
> > >   _raw_spin_lock_irqsave+0x34/0x8c (P)
> > >   pm_runtime_get_if_active+0x24/0x9c (L)
> > >   pm_runtime_get_if_active+0x24/0x9c
> > >   ufshcd_rtc_work+0x138/0x1b4
> > >   process_one_work+0x148/0x288
> > >   worker_thread+0x2cc/0x3d4
> > >   kthread+0x110/0x114
> > >   ret_from_fork+0x10/0x20
> > > 
> > > Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
> > > Closes: https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org/
> > > Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> > > Cc: Bean Huo <beanhuo@micron.com>
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > 
> > Bart, Thanks for the fix! While looking into this patch, I also found the
> > weirdness of the ufshcd_rpm_*() helpers in ufshcd-priv.h. Their naming doesn't
> > seem to indicate whether those helpers are for WLUN or for HBA. Also, I don't
> > see the benefit of these helpers since they just wrap generic pm_runtime*
> > calls. Then there are other open coding instances in the ufshcd.c. Like
> > 
> > pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)
> > pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev)
> > 
> > Moreover, we do check for the presence of hba->ufs_device_wlun before calling
> > ufshcd_rpm_get_sync() in ufshcd_remove(). This could be one other way to fix
> > this null ptr dereference even though I wouldn't recommend doing so as calling
> > rtc_work early is pointless.
> > 
> > So I think we should remove these helpers to avoid having these discrepancies.
> > WDYT?
> 
> Hi Manivannan,
> 
> In the context of the Linux kernel, in general, one-line helper
> functions are considered questionable. In this case I prefer to keep the
> helper functions since these encapsulate an implementation detail,
> namely that the WLUN sdev_gendev member is used to control runtime power
> management of the UFS host controller.
> 

IMO this encapsulation is causing confusion since we have a separate PM handling
for the UFS controller itself.

> Checking whether or not the hba->ufs_device_wlun pointer is NULL from
> the ufshcd_rtc_work() function would be racy since that pointer is modified
> from another thread. So I prefer the patch at the start of this
> thread instead of adding a hba->ufs_device_wlun pointer check.
> 

Absolutely! I just pointed out it as a bad example which one could think of due
to these helpers.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
