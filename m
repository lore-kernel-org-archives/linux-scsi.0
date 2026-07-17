Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A620175A5
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 17:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784309556; cv=none; b=uxGhh4UipvmoSegrM2+UhToDceYF+K1WxGouEFx4kqpuZpuoiG6V6GVNbWxfM0sMlcT882KMC1RlnzN3V+Qj1Lys44SK17EJQeCWNGjze6viZ1KxFvNVRBhaSziVaRgR02oOyFjGTiug0Knr+7xppN4FSD2Ffi/md6JLf8Sw9uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784309556; c=relaxed/simple;
	bh=l/iqzVV9ZiDNg6fsxIgZRa3JR8gePCpl0o8ow2O/eiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAYHg6EjTqpg18lhVU4R685/e8A3actPDlOw4ZOZWI/OBDvKe/+i7zDisRUCVyhdITkzPV5PSSFtc+3IE+lcd8EiizcqviLsNMR5Go1ZVz6U12V/kAD5zVcPZ6LgQIghU0P+4h+Qbq7ogHg5YtNDJ1QlCF6/X+dXLAJUyerI63Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UA6hSxWP; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UA6hSxWP"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cede6375caso164755ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 10:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784309555; x=1784914355; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bBva/snWMY/9I+o/+Fcl/WbhxHZizWnbFHjWgXP46+c=;
        b=UA6hSxWPo9OvxlPa5iT2/xDVujB9fPwrrgUQVxxnD50wiTD4LVhGkXMw+BdvEP/cMp
         UDny7elwLcuWcwiI9oJcQOytvKrg37WwbP4l0rW2N6K5TCCCrTlnvl+VSt1NVx7iFPkV
         3Y6XjHoMirUWS1xnNzgVwpjk9cBtR35D19GUSJJxE9pdkJnaJLC+TsitGkmm91+KpZ0g
         /FeSJnnXn4bn1yUiX/ebATxQfxfGgFbI7k8MQYnX/w/Ik9s9thW+HlJGyFu8UK+zIRyk
         1PmNDfO/tRkAsUunLw2r/WqSWSdlk3lKKSzwMet/F18nPFLggvletj72MofIxxn6nWD5
         NxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784309555; x=1784914355;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bBva/snWMY/9I+o/+Fcl/WbhxHZizWnbFHjWgXP46+c=;
        b=dS1cl+5b4Ytonnl0KEE+yx5M2/TPtw4yZm9rFuTAWwaJvqLrjQoBof2lWi9cPwroxW
         vU+OrUz2XQ/bBCKKtAkgIa6No0Rv/GfmGoIO4atwSUMPf6n7eybZfgHbAr0nU5bB0p2W
         Yi5DeAytNtXYCZuGlHyReBnnyMK8BhUadyfa9O9r5uxl00mDbhVOUt4OQKXVCJ3md3Pm
         ut9C8YvtPJKHPnMXYXnwVLolz5RW780kSpNCduLY4t/3VYaVQrHOUIq22MdLPjmj3SQc
         KTWo5jcf6UZm/BzikAL4ue1p6sKZRWowZqPkTX2W2aAbQRnbB6iuDrlA8R7tp9yErScQ
         rWJQ==
X-Forwarded-Encrypted: i=1; AHgh+RrOKlKvVTsnrBRbOr7RGcss58fkI2SpQPL3u2sUgxp3vmueZaUNIAD1IK9MpFzh41laFWrLJ2xC1xCg@vger.kernel.org
X-Gm-Message-State: AOJu0YypGLZYWnpkQ1lZ+svPZ3sEyLCGLeIRQossy+Dv6dmftEDsL0zl
	U/GcNi90vIbY9Z7aKOYF+1lyWJYOvAKLqoYvA7ACIn92dGYDLUJeI0cYZy+VTbMG9A==
X-Gm-Gg: AfdE7clstry2ERn72T4FfKiqckXHzqw7tZ5RUHan8KvHoEg9VWhcbHGEm8sogaHE6R9
	7VXpqxoOIOM2T2oh8YEE6FgPrt8uMM4KVyW6FJJgjW3wgNDgesd8qMrAl6ISnfVj5l4ohknRGp4
	++yD680pG4dPY2KJif6NXh0PLQJ6w1e6eNbhlVsHY6tZ7XcMyPiWgH5gMHmC+KnxxIhcb9Se3U2
	taVVyK8VWi/fIbG7i1Lah/REZAncpsiFYoqPV9z0AooTrkoaFG3YbBqz9vVZcrQDZ2Pd6/oO+gh
	1iR3PeLb9hA8697ysL5tLfczmNT27OAE4WOTxg2hiEPMQJkxNhXTTxvbysQ2rFCFfb1SQcW7bdH
	rtFBYIT0fESn3mQxSvGlEQzd7rAkRetoo4bra0HfRYBbrFIgFSL21s6CUqG2S4Ysm/1pRdIcJw9
	LX5zkPpQJrcLoJM4D2uH9gmTagCmn3BGBF/7P4mQ==
X-Received: by 2002:a17:903:240d:b0:2cf:4353:f117 with SMTP id d9443c01a7336-2cf44f77f0cmr298235ad.0.1784309554077;
        Fri, 17 Jul 2026 10:32:34 -0700 (PDT)
Received: from google.com (249.65.83.34.bc.googleusercontent.com. [34.83.65.249])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af9ef6dsm1508824b3a.57.2026.07.17.10.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 10:32:33 -0700 (PDT)
Date: Fri, 17 Jul 2026 10:32:30 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v5 0/2] fixup handling of timeouts with deferred QCs
Message-ID: <alpnLgBhz0pb9wDv@google.com>
References: <20260716083847.926102-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716083847.926102-1-dlemoal@kernel.org>

On Thu, Jul 16, 2026 at 05:38:45PM +0900, Damien Le Moal wrote:
> This patch series fixes libata and libsas to correctly handles deferred
> queued commands in case of a timeout error, to avoid excessive delays in
> waking up the scsi EH task.
> 
> Igor,
> 
> My apologies for the churn, but please retest !
> Also, I added your Signed-off-by on patch 2 since half of it is yours.

Thank you, Damien! Test resuls look good.

I saw you are planning to send v6, I'll wait for it and will retest again.

Tested-by: Igor Pylypiv <ipylypiv@google.com>

> 
> Martin,
> 
> Once reviewed, I or you can take both patches ?
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
>  drivers/ata/libata-eh.c             | 38 ++++++++++++++++----
>  drivers/ata/libata-scsi.c           | 56 +++++++++++++++++------------
>  drivers/ata/libata.h                |  2 +-
>  drivers/scsi/libsas/sas_scsi_host.c | 15 ++++++++
>  include/linux/libata.h              |  3 ++
>  include/scsi/libsas.h               |  2 ++
>  6 files changed, 86 insertions(+), 30 deletions(-)
> 
> -- 
> 2.55.0
> 
