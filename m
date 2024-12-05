Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B29B1F5FA
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 00:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733360253; cv=none; b=IAlFFJwtlz201deVaElP75KdpMIrHRCmzRbPRKp32R80A8WmO7LYShsvoiujshwkk0O670Xnoa/EHZZgPRmcO2t1oXSGfoZ8+C6Dq9gu2g4aT8i4sDevcYGIIEXy4zMYzuLdCYA/RI4Wlc2/8ehY2dRs8VWRaF9JapAL6BgB9lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733360253; c=relaxed/simple;
	bh=rbSn1nYH53aXF/087IpQbbHYjVrtP9huSxyDdlVEsU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=csjoPiECEkWGnP+IgHsba2fk8l2G/Q5KaVec8WlKQKfx2X83lrKyor9nq4EmDvbVF8x1ze+/UXCzvqHoJX7ER0FZD2q12xH8GZnBFCTUB2hb/76YylE8Hbv9702WP8WepH6eLK9a+vX7vY5MNY4ZDlrsxK4kuo1VCgIvvWeHkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BWpd7EoS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BWpd7EoS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=qWzPjaD00QTIQ0n6R4LFhFI9r9DCIL+kvwJnvqJbr5I=; b=BWpd7EoSOEO1Wq80tKU1tvtkhp
	HBS8yy1MAXuwesPTI65n2UkQ9p34Futsyhz4joHafI++/PI+gnW+efUN6lITgY2hKPD1OcVM8WdAx
	9fmtmRHiob8v17jUPZNWWcGznS2mCN5Mx7aqdliPil7vkczvBrCTqBjxhcQwgL1Sj/ko6wNZtTlCv
	RmWrVesPbFwKMesyX1z5HF6csF+DsTvY3hyf25MS8PC1iuf9y3nF/mCSix2MI1BJl+28+IG1XVNuJ
	zXTn+gy4oof4PqaYbu8t61HJkUTZtjU7veSPDp61U5crbhFu/keLidInnS7MeSolMGSgZkAbO6MPD
	ZdjISOMA==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tJ0BK-0000000CHKs-2v4O;
	Thu, 05 Dec 2024 00:57:28 +0000
Message-ID: <69d7efec-1f69-419e-a300-84ff347eaa46@infradead.org>
Date: Wed, 4 Dec 2024 16:57:24 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] Replace the "slave_*" function names
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
References: <20241022180839.2712439-1-bvanassche@acm.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20241022180839.2712439-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi--


On 10/22/24 11:07 AM, Bart Van Assche wrote:
> Hi Martin,
> 
> The text "slave_" in multiple function names does not make it clear what
> the purpose of these functions is. Hence this patch series that renames all
> SCSI functions that have the word "slave" in their function name. Please
> consider this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.

for patches 1 & 3: this file has been removed: (using quilt & patch)

--------------------------
|diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
|index 6851a28f5ec6..2ee5d6341b53 100644
|--- a/drivers/staging/rts5208/rtsx.c
|+++ b/drivers/staging/rts5208/rtsx.c
--------------------------
No file to patch.  Skipping patch.


For the documentation changes in all 5 patches:


Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

Can we expect to see this merged for 6.13-rcN soonish?

I am working on some patches that would like to be applied
after this series.


> 
> Changes compared to v3:
>  - Combined two Documentation/scsi/scsi_mid_low_api.rst patches into a single
>    patch.
> 
> Changes compared to v2:
>  - Renamed sdev_prep() into sdev_init().
>  - Dropped the patches again that remove SCSI LLD changelog files.
> 
> Changes compared to v1:
>  - Switch to the names proposed by Matthew Wilcox.
>  - Included a patch that renames .device_configure() into .sdev_configure().
>  - Split off the documentation changes into a separate patch as requested by
>    Damien.
>  - Added 5 patches that remove obsolete SCSI LLD changelog files.
> 
> Bart Van Assche (5):
>   scsi: Rename .slave_alloc() and .slave_destroy()
>   scsi: Rename .device_configure() into .sdev_configure()
>   scsi: Convert SCSI drivers to .sdev_configure()
>   scsi: core: Remove the .slave_configure() method
>   scsi: core: Update API documentation


Thanks.

-- 
~Randy
