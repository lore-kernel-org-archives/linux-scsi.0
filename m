Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D5A433CB
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717777000; cv=none; b=cD9kv3vuN4+CN+bbrnnBvesdqM+QggOlHRzZPpr12qWJ3XVFRpIawzkyIamDLvA3sYW9KNZ2HCA+Ocm55AKMhDU89au5J4K/vhNfgXJ9T8ZrC9UY+yhEYWyBbZ9PHdUuNHQQorp2CVgtlkST0WM8K4m0NFkbgPLt5FH7TYyQTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717777000; c=relaxed/simple;
	bh=bFhJGefdXHVhDjRWCzsTUH+CcYTwmr93kbU33yW/2jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BKDP1+4KsFxtDOx+w93cKfyDNY91p5ThkwiyDxJXyzIk8JSNQK12IIiIhAeuOmE9s1LhreKhuDqHgLFQ7C6raUYwH8Kh04YTqvdhRfeKOCvl2qZpa6m80bKCNyg1lVHnZtKz/UlPw34Pe7aMMpHBShfHbG1C/L275aJEN9XWuPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bFeQRuWO; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFeQRuWO"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-374b05c4f40so10522705ab.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Jun 2024 09:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717776998; x=1718381798; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5XNfk+KLypQCwCBBs4UHb+/ED2cxM4OqASSQw9tiPs4=;
        b=bFeQRuWOvF4f7yoTCYswLo2f0heBHdZcmL4wttGLT+PBkGX3vPMNE4oEPMfEllG6L0
         6U+etV/qPbfrvRvDyAD0D3NLJB56cqYildrlbzHFJvK8ge6N9zFejo747n0zyOOOo0cV
         b2Ut5IQFuLHiIkRJTTdGwqwcZihJX+VbOHCTZRb1NfV++InfVe38oYISV8tqe3KoNV3n
         mnCndxLTYJcDpjxumhw6+YMa3sNc4fg+1/it7acSeHEI9c7fStSi411FSf8da3Pf+ejP
         R+PE+qXcq+DOLkhM+UeSFi5XbhAt0z1bnjgT1zI1tTU/qZYrWGRoj3HZNCpQN+ByGMA6
         +pLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717776998; x=1718381798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5XNfk+KLypQCwCBBs4UHb+/ED2cxM4OqASSQw9tiPs4=;
        b=PiMFrfddvw2Ga8o2rfjGnEuWf+k+Bc9upBvRvZWqbouyZmhXztVG/dJYEL1YxCw3XA
         qnivY1BohAvPydIXbHy+Mg23X6BWeUAoYhJVjhzs74j0VRvU1kdpWd+hNyMvNIxbM/Kg
         H17SBe9VaROH1n8Qc5HS50t9XVYQr3qKWbP9Y7XmQFvjdmN3SIC+ErgID4lTN+LpadNb
         kzsRZvPoehcHpOg6kw2IBWkvQDz6xHEBuz/0sBtI5Ot1IZDTtzjp/yHRnlXyr3HKXrAp
         4/y4/zl98OsR1EFlkbZT9pocQIbNHeN0utYiRw7SarOIl1wWoLFLI+Qq7hiy/vR4SCdG
         gP7A==
X-Forwarded-Encrypted: i=1; AJvYcCWT4gjqvLKQuZK0VvuKQuGIkVcgeqXRBJkDPmCgVsBS5pbPzcIijR8W5as/BdrPoXaw/KJVvpv34jZfpEOcsDUso9rhfvU0vJXUDA==
X-Gm-Message-State: AOJu0Yyrn/3dGYFrkjX+OU08fFtMyb+G5bqqAjGRCqan3M7iP23u2Pn9
	CgP7/C8rhb6xhCwQlzKWApYaeR94W5pkeGqrMzsYjh3culb2AFQKbkYu2lH4hw==
X-Google-Smtp-Source: AGHT+IH6I4wOb7ZUeor70AwaKwATVUiHhjPz2T+M9MZTEmcbCmCJamS18xSfpbZt4AmOJWMTmlfv+A==
X-Received: by 2002:a05:6e02:18cf:b0:374:a286:7b3f with SMTP id e9e14a558f8ab-37580349278mr36146935ab.14.1717776997786;
        Fri, 07 Jun 2024 09:16:37 -0700 (PDT)
Received: from google.com (166.58.83.34.bc.googleusercontent.com. [34.83.58.166])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6de3f673686sm2449810a12.31.2024.06.07.09.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 09:16:37 -0700 (PDT)
Date: Fri, 7 Jun 2024 16:16:33 +0000
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: core: Disable CDL by default
Message-ID: <ZmMyYb8Up9-p1lUs@google.com>
References: <20240607012507.111488-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607012507.111488-1-dlemoal@kernel.org>

On Fri, Jun 07, 2024 at 10:25:07AM +0900, Damien Le Moal wrote:
> For scsi devices supporting the Command Duration Limits feature set, the
> user can enable/disable this feature use through the sysfs device
> attribute cdl_enable. This attribute modification triggers a call to
> scsi_cdl_enable() to enable and disable the feature for ATA devices and
> set the scsi device cdl_enable field to the user provided bool value.
> For SCSI devices supporting CDL, the feature set is always enabled and
> scsi_cdl_enable() is reduced to setting the cdl_enable field.
> 
> However, for ATA devices, a drive may spin-up with the CDL feature
> enabled by default. But the scsi device cdl_enable field is always
> initialized to false (CDL disabled), regardless of the actual device
> CDL feature state. For ATA devices managed by libata (or libsas),
> libata-core always disables the CDL feature set when the device is
> attached, thus syncing the state of the CDL feature on the device and of
> the scsi device cdl_enable field. However, for ATA devices connected to
> a SAS HBA, the CDL feature is not disabled on scan for ATA devices that
> have this feature enabled by default, leading to an inconsistent state
> of the feature on the device with the scsi device cdl_enable field.
> 
> Avoid this inconsistency by adding a call to scsi_cdl_enable() in
> scsi_cdl_check() to make sure that the device-side state of the CDL
> feature set always matches the scsi device cdl_enable field state.
> This implies that CDL will always be disabled for ATA devices connected
> to SAS HBAs, which is consistent with libata/libsas initialization of
> the device.
> 
> Reported-by: Scott McCoy <scott.mccoy@wdc.com>
> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Thank you!
