Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3323F30C606
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 04:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784780465; cv=none; b=p4GRn7wEc93Er/xfMoq1f3o7buRd0eI3j2QkijbbD7/Z+R93+tcac32Ui6LvZU2opKkdaoG241USMP7Cp9uAmhsaWYRwADVb7F6hRNsS9nfAu/eMKryy81UdzrOHkHbyy4zhj5SW9PtRxyKOaXWyPWeFMDUMwHFFFqO17XsDCI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784780465; c=relaxed/simple;
	bh=35mNg/AyD4v2flAtAyN0ZZj4wEBfAt3e83VUm//qg5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFrennV1eQATNCx7UIMe9sxlRGqW10nXTHVdwEwoBCOByJL7O+tBdFwMpiWNHU/mYeccqWKLT2UsQMSi5I3QHMBqo6PWsJJs1IC41W4TWcTR8uc1J0LnCTKCbG5PcteVx4ATL2cCvqSP/in+A+ULGBVfi74Ckowg88IwKyxoTUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fvi4/RvY; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fvi4/RvY"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cede6375caso55535ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 21:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784780447; x=1785385247; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h0IhZi1OKFPkcst+4yI24dUPIzJuM4pvOmvOBFDuDOw=;
        b=fvi4/RvY3nNf8YGlD5NB3gdpoVgFY86KSbODehp++sw7kiI3ZkOGiIqcSFPt9n+2HW
         bzKrJX+g4+FLeq4uSTieVVvcKDYRJFfxSFr+ZXzlEIUTnY/q6W5FrbQYU3QWMaYzGRLj
         mkawGYSNxtSjH2eUXVdR8JDhedIBXBOkEtjk4a1ixk5AyW26WGneKTsIJ/HbqIo8lQz8
         XqJGgSNJ+kAwt4S9SENIvocmERezD7pnne3+5TZSySpFSeuZZF6Sqx2UHBI6USqNkqCw
         IEMDJSgGEw8u926ODqdvzJqdkcqbHIj42hg6SfjSnmueBwHbtk31AaA4zowsOLrQB1m1
         Q55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784780447; x=1785385247;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h0IhZi1OKFPkcst+4yI24dUPIzJuM4pvOmvOBFDuDOw=;
        b=FVeyMVszaE5UJPrf5mkGgL+Byqh5lEnjIUdSEGO/M8sp00iy+WaIIdyTAjn2mqA48r
         XELIxJQFcJAL8lfHG78uBzmy6/fAXRyDUVhfAvHyOxxTA1p3sLVGJ2PHdXlBqCr+bgBy
         o4Bomni/m1T2brdwwW2SL/7/p8AyP6JvNmp9kuC1cHCDqpleSuYq7P1bxd1cn88PFGld
         v/5Yxnkw885FtEqzwhtteApmUkeME1MDOZDn8KvCoIY6t4k3N2oVrvrjqxvEhsbktD1w
         jWa/UAD6WpfL5cZi16l+f/TJqBLYXBEQXHGVR/Yb9cJ+NpLGVYKkzzs5eByf1H1cEpm5
         MAOQ==
X-Forwarded-Encrypted: i=1; AHgh+RrUQnc9h2DtIGX1mSqezqaH8DRKQAGC7GnJRjSWER5s01KjFtXb3XbtbiIg07S60c/IyGQIhX+opVqX@vger.kernel.org
X-Gm-Message-State: AOJu0YwBv9OrnqU9yeAewrqFM0P/r6Qz+fyqtyjYKiNlufRJ2LVoiAg3
	dZhQQOj1SVnX7M82kdPcBogxL1ydD2s9/iDI5hxRrGTPe1mIrsYsZh9lG6E2Hq9KPQ==
X-Gm-Gg: AR+sD13CRe/n7/mkpYNY95owRh/JJHeB1k3/vexZ2fns9qXVYZ9UojynS5W+ORSyZAm
	M9F5ROfMA/vpoAfvCnrFmXtOY3Kk4DfjYT7uYRIFfXV2z3zIgt55nCBLiyd/Dhnim+BnVjzfVkr
	jMhQBdp7zDL2oKaUtioQaKPCsVs5a9gnnZ4YdgRDnGaZ5eVsUdjaL8QupHSVOWwOAzaCynwfd6p
	nAT1aVX173tuZxLSSGrnWe1zKU5m7uVjix9nE790LKqMUXQoOQISrhQHEyxahBbvAByNiPSopo1
	1rhG5k3wYzL84rJBFeMVXaCWFqOuRBD1j4KTx/JGgPXHFfEx3xe7Noo2sc9m5hc+3JWdiwvNWIF
	ColJwvsCBsewwuE0HnowGGPvodEKUXDXTHwFp8x37dH6ZuKhMO8nS48sSBFTRWxppBikUFQThgu
	vU91jLzZw8RQfe6NUliDUMgpXLatRmACk8A3K/rw==
X-Received: by 2002:a17:902:f60e:b0:2c1:ee6e:4e49 with SMTP id d9443c01a7336-2cfa53828bdmr1036105ad.26.1784780446559;
        Wed, 22 Jul 2026 21:20:46 -0700 (PDT)
Received: from google.com (249.65.83.34.bc.googleusercontent.com. [34.83.65.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17576a80sm2309404b3a.36.2026.07.22.21.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 21:20:45 -0700 (PDT)
Date: Wed, 22 Jul 2026 21:20:41 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v7 0/2] fixup handling of timeouts with deferred QCs
Message-ID: <amGWmbJXLXGxrFso@google.com>
References: <20260721064027.2081195-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721064027.2081195-1-dlemoal@kernel.org>

On Tue, Jul 21, 2026 at 03:40:25PM +0900, Damien Le Moal wrote:
> This patch series fixes libata and libsas to correctly handles deferred
> queued commands in case of a timeout error, to avoid excessive delays in
> waking up the scsi EH task.
> 
> Igor,
> 
> My apologies for the churn, but please retest!

Test results look good! Thank you for all the time and effort that you
spent on this issue. I learned a lot!

Tested-by: Igor Pylypiv <ipylypiv@google.com>

Best,
Igor

> Also, I added your Signed-off-by on patch 2 since half of it is yours.
> 
> Martin,
> 
> Once reviewed, I or you can take both patches ?
> 
> Changes from v6:
>  - In patch 1, go back to using direct command completion for retrying
>    deferred QCs, but adds libata EH trigger to avoid problems with the
>    block layer immediately re-issuing the retried commands. This same
>    method also allows directly handling timed out deferred QCs, which
>    simplifies libata EH.
> 
> Changes from v5:
>  - Reworked patch 1 to have deferred command retries all go through libata
>    EH to ensure that we do not run into issues with the block layer
>    immediately re-issuing retried deffered commands (which would create
>    again the problem we are trying to solve). This change necessitate the
>    introduction of a new QC flag and changes to the completion path for
>    commands to ATAPI devices.
> 
> Changes from v4:
>  - Simplified sas_eh_timed_out() code in patch 2
> 
> Changes from v3:
>  - Reimplement ata_scsi_requeue_deferred_qc() in patch 1 as
>    ata_eh_retry_deferred_qc() so that all requeue pathes use the same
>    function.
> 
> Changes from v2:
>  - Modified patch 1 to avoid the problem reported by Sashiko that requeued
>    deferred QCs may be re-ssued immediately by the block layer, thus
>    potentially keeping the device busy. The modification now relies on
>    libata-EH to perform the requeue instead of immediately doing it from
>    the eh_timed_out operation.
>  - Modified patch 2 to use the new helper function defined in patch 1.
> 
> Changes from v1:
>  - Modified patch 1 to ignore timed out deferred QCs in
>    ata_scsi_requeue_deferred_qc() to let ata_scsi_cmd_error_handler()
>    correctly handle this case.
> 
> Damien Le Moal (2):
>   ata: libata-scsi: terminate deferred commands on time out
>   scsi: libsas: terminate deferred commands on time out
> 
>  drivers/ata/libata-eh.c             |  29 ++------
>  drivers/ata/libata-scsi.c           | 109 +++++++++++++++++++++++++---
>  drivers/ata/libata.h                |   3 +-
>  drivers/scsi/libsas/sas_scsi_host.c |  15 ++++
>  include/linux/libata.h              |   4 +
>  include/scsi/libsas.h               |   2 +
>  6 files changed, 127 insertions(+), 35 deletions(-)
> 
> -- 
> 2.55.0
> 
