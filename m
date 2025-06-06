Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A3D236421
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 21:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749245446; cv=none; b=k1p3hl0PpwoQpaDKgYuoA3evqIcFcW1c4fsqPFwVoIagi+GTuAKIxjjtQyDefbY/2g5DjRA7X881McrRsh+H9IfGiNgkAo6N56dNmIChDMRMQelA2E02BGaEGtRH0LS6L7RSG1E2QLvFJkIFnBUmbgZLzoWY3IozeVFG4VCF9/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749245446; c=relaxed/simple;
	bh=pgsAaWQr5yK7g+BHIDpFB33NzlP+J7IAFnhl5CCFd0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fjwusNhhNxoLhMbaNfEwiY/B/rRf73qE5E/Vjg2U88+BYzvBL6M1eOLrU6FZqokothdvoADBEaJSiGxGJewdc0SrJu/aLatwKlGckuEIuIICM7tv4005DwPZ+ivcc2iZNeA+VY7XY0ovOt77O6ndj1S/YGlVYO0rq0uJgn+Z3Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YqLfTGh4; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YqLfTGh4"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235e389599fso73975ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2025 14:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749245444; x=1749850244; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dr1xmgXLjjoQTbzmmd1f0MDQgk8nHjlCfm0TABgSBYg=;
        b=YqLfTGh4ke4yoFmtFalY5FDfUA6AjXIdb4WoS6Cgsd/XIFuVxOAMkZBzLYgPrF+12z
         a6dfYkQBbWgD8ev0l2UnQYtrlhN1Vpj57iLXl8wVjHDg8TDuPNMev2U3C55sbNEVGRFp
         YqBQwDX7C0kaCWC6GnTJLEZR/8/uhVSlXu8cf6fIucqynHk+Y+UKH7Yup2zYjuUJAbpc
         CvtYLhuBjuFRyCsABPEqdaBXPTVZgwRMlolB/asilsPTCLt6KkdtOMqc5Pk8GOsw5HiM
         9GC/Wm6UMtPHTnR5nUGyqHfzjJDXm1FtXMqHJEcSKx03kC50xK+bg/y6XpCltF3yQE3f
         4LRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749245444; x=1749850244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dr1xmgXLjjoQTbzmmd1f0MDQgk8nHjlCfm0TABgSBYg=;
        b=P2x5drDWV2HROreTSqgRWiQxfykDQCLVPii9XORXKZU2i6iDN3mKficnn7382y3pAS
         bYphiZhna613vcf9J3MezynreHdYFbzeuLQ45KI4BVUIZs2zwPDDJGY905ERk5klS+Fm
         PlLRxmLDtL1oEURNVrw8F5dj/3inG1ITxgq73KiFK51dyRSzzyeebdq3jsw/qtZMn4F9
         o7naN5UpTFA2FM43dhBWXGHBG0mxkN58zHPfeRht3p6MDHYCRs6U8iRbRdfFT3piKg8f
         uhpZvgzB+5OT661VUY6PaPTPAPRTzZseCJFrTk1YYRRCkCxct15KMrEgCa4T8EjVKaF3
         Wmhw==
X-Forwarded-Encrypted: i=1; AJvYcCXcIpbzJWZ/k9ma5uWMeybqe6CBNAjvXqZZuOAopUEbqJ37D7cHyDCZGzIOaF8Hj24qzbJam1MV2EcP@vger.kernel.org
X-Gm-Message-State: AOJu0YwhIGex/vETY82OA30SDt8qgh6XssRfZdc+ZIZ4YBB30AurVXRy
	kzu9adHsD9VVrqFhtF1CAMBSeVjOvA+8dFA84EGuzfRgnf+pmNS0otrckYPTaXgcrLpu5Yxjppv
	iCe8P0w==
X-Gm-Gg: ASbGnctn/+/3gwKAvS9JjgJWm23k4Oab8e2/a1QQg+XwXInnqkwf91V8/zCFkOU+Rc3
	3jWdVDVwBSHORbAzsHInsY/YCfo75V1NeF5W+qQKgUePVoO4oXFxHMVY4dgFTaTvlJ1GyB7e3S/
	Y6IPxG94luiYIPHgFfN2YaaCbQEQJXIL372MgXaC5Gq7i14Wd4zHdGa5lumDJvbFtWq98XKN77I
	ou5Q4DHGPmScQ5hOBAfi8fAWKFBhaROOJrM8RMxT8Synx59u5oAmndJG85XiJTsSkhC4N5sabnq
	jLiLUV2OJE452U2DwGou/0ZVOk1eoJMFt8Wmd2EAq5S8UwGLTs5zuVWpdx1sUNYu1w2NScKFFB7
	OZBj+6wVrjRdqkY+uAMlhwA==
X-Google-Smtp-Source: AGHT+IGsoFR47rITI70whyP8pDCYl1FZOtGXnIsNV6nTsaH2lwJxHSmr6y3x02nFktT5jbH3DMPs+Q==
X-Received: by 2002:a17:902:e541:b0:216:4d90:47af with SMTP id d9443c01a7336-23613deda37mr145225ad.29.1749245444044;
        Fri, 06 Jun 2025 14:30:44 -0700 (PDT)
Received: from google.com (35.72.105.34.bc.googleusercontent.com. [34.105.72.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-236032ff216sm16849455ad.111.2025.06.06.14.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 14:30:43 -0700 (PDT)
Date: Fri, 6 Jun 2025 14:30:38 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Remember if a device is an ATA device
Message-ID: <aENd_k2m9RN23VOE@google.com>
References: <20250606052844.746754-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250606052844.746754-1-dlemoal@kernel.org>

On Fri, Jun 06, 2025 at 02:28:44PM +0900, Damien Le Moal wrote:
> scsi_add_lun() tests the device vendor string of SCSI devices to detect
> if a SCSI device is in fact an ATA device, in order to correctly handle
> SATL power management. The function scsi_cdl_enable() also requires
> knowing if a SCSI device is an ATA device to control the state of the
> device CDL feature but this function does that by testing for the
> presence of the VPD page 89h (ATA INFORMATION page).
> 
> Simplify these different methods by adding the is_ata field to struct
> scsi_device to remember that a SCSI device is in fact an ATA one based
> on the device vendor name test. This filed can also allow low level
> SCSI host adapter drivers to take special actions for ATA devices
> (e.g. to better handle ATA NCQ errors).

It looks like we can also simplify the WRITE SAME disablement logic?

https://github.com/torvalds/linux/blob/master/drivers/scsi/sd.c#L3466-L3474

Thanks,
Igor
