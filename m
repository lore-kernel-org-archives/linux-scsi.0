Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FF61E487
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 02:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749695639; cv=none; b=cStTNIDARC4eGUvyPooOf6dkBkNAqNA+GJMHJh5edUqxV+Xgahm3xDskxhKOKNk73ypK77E0mRvSLM0nJSVdjZrXY6rBoS4qx7LQHD1gWvl3VfrRnNGDn+rJh15NJ3B+H72VZ4IfveZ0v/oRaDzdXqTfvlxcYc9L3uOCsjx3DWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749695639; c=relaxed/simple;
	bh=yfHC5TYakNH13y2ypYROgVBxgexvPTFJI1ITuiJpJX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXLLDbakaxroXTc4T0i9ygxE4YoXVYE1S96wF9d/xZbGs2ZQ3382xeZykn7zabgpZjEHbk0SeD2GPDZvAuE9NtIXFWTvDy4c3+4U3DM60g47kZxgywrGMdfrz6/hO3rB5rsnk/cXBAraHrkqjfWFlmf7lAJ6oI7kwD5WO9n3dFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=immcF/Nz; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="immcF/Nz"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2357c61cda7so48745ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 19:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749695637; x=1750300437; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1IjxDbjLtMOdPdHFEGL3BUD7Vy5YiG2MI96bhZNluCo=;
        b=immcF/Nz+roAKYkst0j7rOzANjcdJMXuCsW+WuWeSfPDiXYdOXc3qnIRNLz4R/GdHK
         sEkz5kNVq9TLimn675mPoINVuNyL2JXVD2ycEHmfMowy5GUjC7Mx14wLmkE6C/3w4NMx
         6PRrECQgvjSdDuIOd5vdyawnUaC2TFEtgLhZXK4gV7hsicynwIVyjrqNfBPuQbYDT1/5
         sHDxyCkPf9fwO6teGzU6KfdZSGtGEbBtdAM5BQC9Yeb627EsofyU5dol5L0allf/IxN4
         QU0JD09yvGJrOLXo7wqQHKHxfWyu3M1IOjQ0TcjsTPPoHf/Tn7dT7qtckEABxRz6XwCP
         K98g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749695637; x=1750300437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IjxDbjLtMOdPdHFEGL3BUD7Vy5YiG2MI96bhZNluCo=;
        b=rj5x9J+9iC1AfpOfBlV+dsFP3Xw1weCucsZJ9/CGgayzcqx677u/pm+pOyZQQ0AEV0
         LCwgNKUQSToS5B/c17gz1IfbHce5gbniL44xdZthH6zMwsWZ+RJhZj0ugAa4ro6BiM2A
         9UUWV/JFlSnQF1I/4cI0YHcEQ5JBdPzsf6uY/sh09K7MOYE3+HNmHCa+6hXQCBpTT+l9
         dmO+fiOUhzmhq7RELqTe3owMEq+Qi4mksaC1xdxx+a+Lb15DZJsrxCDlaZqUggbCiLMW
         XW4L27V1BLAAwtXW2P5iEZf7smpp5056yD5mfbP0CTV+QS32E4B6GAmXi1ulqxGvhQQh
         EnAw==
X-Forwarded-Encrypted: i=1; AJvYcCVCgajdqV5b0u6B9YURF/SFchdoBY6DMsP/ujfelaCLDpCRyfbQE9LEHkUvOhiCg5nba4V0y9XCkP3Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyP928Nc4XLt7kWk9XCbLNKc0xtW+VIY8Vls5Tk8IYywfII2SUu
	tabKG2xoKp9hQasRbaYN4nMEPZWmL9+1mOdiw8/VIBoNcZ8LRm0JsSXBVnDevCbzNA==
X-Gm-Gg: ASbGncuo88nLPSLaMfdgjNsmAMX+eNWa+nVMRHQByxrWVqx+Cp5EeouhG1RBOFXsKtr
	Xg56wvJ/G02Ke68FaSTyIgXoGAAGzl9JTDOTIIBBvp8xxA3R6jBMDjRGoYVdaeH3SAjDnKPkZcN
	i7aOMniNyZqqovKuBXlpR8/SAlSLavxDwRicrf88w4lXno2wstdUo4kgkH2rCGzC+xnHrffZGaa
	1B5XO7hYPUxDKMss0+YfFniV4EIKgNYY9MDqCxkwNGM+8WNtqL5tSylpQusc/B91j9QU4QPTw3Z
	oI2KTpgYY5K5h6AA9EyHpQ7yIktkyJfNEEWdyXgaAx6+g254VWYohRazZSQaXkhcxNsk4qNOvIj
	wDigiUHJ4QLKKKMYx+Cr5vA==
X-Google-Smtp-Source: AGHT+IEVkzzOXGth7ttySUmTijWNGalrPHLZOeogbh3+rU+Rcjxvd1VxNSFJyZQ1SNDruDr31TWwEw==
X-Received: by 2002:a17:902:d2c6:b0:231:d0ef:e8fb with SMTP id d9443c01a7336-2364dc4e3b8mr1429895ad.10.1749695637329;
        Wed, 11 Jun 2025 19:33:57 -0700 (PDT)
Received: from google.com (35.72.105.34.bc.googleusercontent.com. [34.105.72.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1c6a80bsm294289a91.44.2025.06.11.19.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 19:33:56 -0700 (PDT)
Date: Wed, 11 Jun 2025 19:33:51 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: Remember if a device is an ATA device
Message-ID: <aEo8j07xS4caik09@google.com>
References: <20250611093421.2901633-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611093421.2901633-1-dlemoal@kernel.org>

On Wed, Jun 11, 2025 at 06:34:21PM +0900, Damien Le Moal wrote:
> scsi_add_lun() tests the device vendor string of SCSI devices to detect
> if a SCSI device is in fact an ATA device, in order to correctly handle
> SATL power management. The function scsi_cdl_enable() also requires
> knowing if a SCSI device is an ATA device to control the state of the
> device CDL feature but this function does that by testing for the
> presence of the VPD page 89h (ATA INFORMATION page).
> sd_read_write_same() also has a similar test.
> 
> Simplify these different methods by adding the is_ata field to struct
> scsi_device to remember that a SCSI device is in fact an ATA one based
> on the device vendor name test. This filed can also allow low level
> SCSI host adapter drivers to take special actions for ATA devices
> (e.g. to better handle ATA NCQ errors).
> 
> With this, simplify scsi_cdl_enable() and sd_read_write_same().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Thanks,
Igor

