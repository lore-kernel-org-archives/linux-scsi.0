Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8002396D2E
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127236; cv=none; b=d3NmaPXFxiugZIOUsEWsO11xCbcgv29Qhs3ZFNqQsinX3W3usI8o9weWZGzM/lSrgNj02fKtIpjOYyaL7GIYAD9TzQH9OK7gOzRJbTb9zHvb4HJHo4beMgKeoP4lDmh176wlxYCg34eKaqtpSjDaI42ZA9EjIe5waTGPbkuDatw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127236; c=relaxed/simple;
	bh=wK1N3Ek/Umu6hAvVBzkW0ur8Dsi4Au1ddW6kRmTzyAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDv23+K/vm6MhihkTdhOh4taccnosP9jLJ1F6gHLuJRLOp+6Omm6kthrl7NJohpuz0YIDi16bqxzlql9A19dJfiVHGQ8H6Dvf9PNTw25XCIFwm1cDsVNLD6iMuW95zOaPEHTH+7YrQQjX3aHE+b870119cGpd/ZZLLiJL2X0xaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQMfXcmr; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQMfXcmr"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-46019edc13dso1900696f8f.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2026 04:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782127234; x=1782732034; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MWBJUw80EqHPNIfVo4oEFK0a4DYrQHdWXY4Zdqpw31s=;
        b=GQMfXcmr6+7q3PqRoDdGKluRwHFUNCGH1MgnEWdwwR5a1k65eIye2qeDmaRFtnLFu1
         6BC3srf886Xe37BUHWB70LK8GDSPv6RL0gU9maVvsCyb/5I9w4qKM1s0RIuuLpYsOoO8
         2IVq5QxxgI9aYbWkO/8DcSDQbyvbaQtRc2kjFmmYbokm/Yj0oRicLhUKnioHSQ0Q4DM1
         SNZBGoCvd9iik+dLW8zibC5pC1Tn2AdikPT1wxK2ZC+ZswswEm4ZVg9h+E/YglTEgicF
         e9nGlEMWg+TAoQ2Qe9jg7UoBjZ3bb0gaD46aqV+cn/ujQr2sXdjoWNLFGHKiqcXxgOKB
         rpPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782127234; x=1782732034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MWBJUw80EqHPNIfVo4oEFK0a4DYrQHdWXY4Zdqpw31s=;
        b=j/7J5TLm0mV75IHJp+vCN68m1l6DdkM4hQBUDaS2DEUKhMGteVjdioEgUmYwphgGeZ
         //d58kQZmxoCqGFzeUnl5UXSLT6Pp6vx3BSj2rWt382eP/WzRIwsSjmBPtNO/kqSoZtx
         w5iuvl5sQA4qe5hrUHATmMr94cbWsBmw2QTNeXRfRMNHmv6YrtrgZuoSTufUI1YjUhu6
         xoDSHxvfI8fo9/CUIF1Fm0Z6jozfoRWxV6dbU8sNwgMX0RyjhCNrhNkcaoAfKUBjiVun
         21Av7NSHLUWu+sOF9u1apmR1unk6grmSBXLNZoeEzFRyguAUzTvmBxXbQinwOrCrNNXB
         nxqA==
X-Forwarded-Encrypted: i=1; AHgh+RqroNxM7kEUUIkqjDTaj+ocgxpxD3MW/TopfJjTR2eKThzfT+8c7BFNuTHOmgzVuIC3jcmTvCATp7E0@vger.kernel.org
X-Gm-Message-State: AOJu0YxWrz/qlAp0bMR0QjJsGBe38u0Yag2/HRCebjbg4vg+wgr3nA2k
	XaJ7FsJlmbVFZHuxc3+7VgiSx7EuUseoaBW4XwKq7IjDahCgPUTNoIL5
X-Gm-Gg: AfdE7cmmHpM+xLgEnLGqfDwTBsDCi3xW25g+UwhMeaNAMn3Wl950dKKQ84Iaa1hpWYH
	Pw3iEKYI/CyoiHq1kk1Fm72jqAy0Oe25uAPhPDOabPWSXWluqOF/FkHRPHcfjtgNBIQdeR9c/eR
	qXRMzAcO8kHGAZajOCUrMGFvEtvwujOFqLXSUyhE1cgxG3QVdBfxHwAgreGzgGUS6JcH1z7Ua89
	/bVQM3ab1h2G0XAzGzGmet94SqX6ZThdZDOTurxr3gJX+GrOddPyxFgqE3j7E40/ofO9as1tz9m
	hpTBxxTFHDZTqYSw4aPmkoHZkRBT7QPPad7KUj/dAMvlsltBR+dJOzYsm8QgUOAnZTvi3td3HVi
	c4PX9gqsN2TIsOic3fwK9zn8gBsaq0rEkhVopCQWfsn/sCjqcMI1/qrrnLAbb1UAlutFVBiLH
X-Received: by 2002:a05:6000:2c12:b0:461:d2ee:2fcc with SMTP id ffacd0b85a97d-4656f0866d7mr18752466f8f.43.1782127233942;
        Mon, 22 Jun 2026 04:20:33 -0700 (PDT)
Received: from localhost ([2603:c027:c000:3cde::f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466648c5413sm26520531f8f.11.2026.06.22.04.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 04:20:32 -0700 (PDT)
Date: Mon, 22 Jun 2026 13:20:31 +0200
From: Louis Sautier <sautier.louis@gmail.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
Message-ID: <ajkaf0aa0TWXdRZW@localhost>
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-3-sautier.louis@gmail.com>
 <93542109-2101-4d62-aae4-bbf058029663@kernel.org>
 <airk3Os03wPV0rvW@localhost>
 <fdea1a8b-d631-43d8-bcf0-1c79e635782c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdea1a8b-d631-43d8-bcf0-1c79e635782c@kernel.org>

On Fri, 12 Jun 2026 08:34:13 +0900, Damien Le Moal wrote:
> > If I dropped SCSI_MPT3SAS_HWMON, I would use
> > "#if IS_REACHABLE(CONFIG_HWMON)" to match what i915_hwmon.h and
> > xe_hwmon.h do and properly handle the SCSI_MPT3SAS=y and HWMON=m case.
> > What do you think?
> 
> That seems appropriate. If there is a clean way to avoid adding the new config
> option, we should use that method.

Hi Damien,

I did this in v4. Could you please review it?

https://lore.kernel.org/linux-hwmon/20260613023833.3163507-1-sautier.louis@gmail.com/
