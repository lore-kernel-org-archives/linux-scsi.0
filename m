Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0461946C8
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2026 03:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772161797; cv=none; b=h1+dg41B1YPN1g5Rj07NXF9I/zOFJZriWo/fpPch7eBYv29wN0ML2NOVWvljxa5WCU7D7mhJUAd3SvkeCHtwcJ6lNwA103JKMifSAlec/NDnveVNXWwp24A/WPE+EsaCVxVbC+B6/6T2frNSW2COELwWtAY4HLFIE5OFV393Jyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772161797; c=relaxed/simple;
	bh=lLvvMLGsx1BgwJbKWy2wY7z+GA78EcDtB/wttvR3yJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7M1oAJ/FOZX8JzV2ecwO65toehhGguoH335yMJvcAm3wz9QbB0hxNc1/gUD/Ls/x0VdE5qrDUQdykyLai2IBI182K2vjQvk71Pv/sZ4DpA38V+Hw+Bbb8nY6GXPjInBBl08H2G5dqzGfVihj6Nku1CClKkIn29w9bkxrPvN238=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3lmNBTL; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3lmNBTL"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2aaf59c4f7cso7881545ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 19:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772161796; x=1772766596; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TvUpvWMUcg1fEnSZjBZHEX4sGXm3IOMQORMMYCPIljc=;
        b=f3lmNBTLH9CFGRfnjXlu2XnYpp+c/0bjfeNTBhAt00/1deOPoYbVLy2VVitHF7ysFp
         W8Nv1RAuiNCzlbo4wLm7r4TPysJKPewNkOsQxPSenQdvGzIQN5qdflIaexP17vTgtrdf
         kNxp5HBDLMGkECPcO7wJiYSw/7HV6sw7CsimMavYObj9nicB3U0eZ0PeMneUWTVcSYsH
         MBjBtWRnlz+TAT+aaTRKil8u2qQ34I2am63Cu8ANX17Zf6YqrwiAnHdXgaSD/TmjkV7r
         O1nVoYCvQU6gMhCm3CXGWvCeqP/Qd4+VTnGH83TI/nXQIqxnpo8wipM5LLUG/xT4JqSJ
         Vu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772161796; x=1772766596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TvUpvWMUcg1fEnSZjBZHEX4sGXm3IOMQORMMYCPIljc=;
        b=p8QOtnrEKsKWumHZ2Qg6XKUsLfrwavCAc5gTsgUjerkngImZVhhUGW4rFfldoqBSUq
         z0DYGQWP7NmxLhsys8ABe6hBWL7YAmUd/9ERSd/d1sB37lgrCm35UGYC7UhYgam/+dfR
         9nFGEzzIyIPocm0P9tCFEAxXxoHQNSXzXDkHdrYJ8Am4CVRRn//noxf6Btv+wgfyQi/I
         rdF8GQVFli7xDe+YTjgxbrgtgiU6Q5lZDx2nWKEBqhKt3alIk94mDaBPTNs4Cv43nUrf
         0ZTMT9rI+2whzP02HLqTyXGtbMJprGuTRu823se/HqJPEJgQxLO4tOZDTk/G/KnQqJm+
         EQBQ==
X-Forwarded-Encrypted: i=1; AJvYcCU75L6nGig5LtdIC4Euve/XZhLUyeCO4FLVh6Gjwo0ushecSz8erI5NXwETYXetIudR1+Now8ufA4c8@vger.kernel.org
X-Gm-Message-State: AOJu0YyHKbCCJ4nGBZLFlOvOv8dV7hFkBuTAmGADzo+oCweZgkVwZSAN
	zra4SaLZalobhuMEmLK8c/xVJZnJKcOLAiy1wFjqJ7ijdyLbYRU3k68rNLeaYA==
X-Gm-Gg: ATEYQzwWPWAZnFGF0Be3oAjBIs5mxhSaYT9bK8by/pJBkWrfU8WJkPbEtZGBuKF+J91
	gSctYinAULUXwCsUynnkj+cf/73IvROt8gM5X89evdBo3tXOYYxpddYAjBtFMzvoM0fb4Joa8JH
	OPtNsQdRgLApEh2H93wHPoV4FTad1HTyjEeiMXPZk/+3QsSjhR1ni+IsdA8lO7g+7Fh54KqBjuc
	edb/thKB1kAZP20AqNXjdFIMl9wLwRWsjF2Hz3jF90vAfEVWLF0kvpfFaRcYZDIXzFyg+6urzlY
	8u9wKX1TWM+QvQ4pmOJcHXoYwjtYZYxPaMYxEr6R3ltnIWh+5bJwSZ1kuJ9A2DfxjV5bGibnemE
	nkEDDs0ZMCIvkFiENc2xYF9lgKuEf6Ne8tnm6VQVLTeEHHtx7aTEP7wy5iiH7Qje7lgAINwNwwU
	OgJZT34wlbC72AvtTlePlSKHftG/JwENxOqM6fHSepRLsxcvY=
X-Received: by 2002:a17:903:144b:b0:2aa:d671:e613 with SMTP id d9443c01a7336-2ae2e4b54efmr11623845ad.38.1772161795995;
        Thu, 26 Feb 2026 19:09:55 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([103.50.21.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6a041asm39826475ad.57.2026.02.26.19.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 19:09:55 -0800 (PST)
Date: Thu, 26 Feb 2026 19:09:50 -0800
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, mcgrof@kernel.org,
	pankaj.raghav@linux.dev, bvanassche@acm.org, dlemoal@kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/2] enable sector size > PAGE_SIZE for scsi
Message-ID: <aaEK_jtTY5RlCZ9f@5163NRD-SPRABHU.ssi.samsung.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219043741.276729-1-sw.prabhu6@gmail.com>

On Wed, Feb 18, 2026 at 08:37:40PM -0800, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <sw.prabhu6@gmail.com>
> 
> Hi All,
> 
> This is v4 series sent based on the review comments received on v3 [1].
> This patchset enables sector sizes > PAGE_SIZE for
> sd driver and scsi_debug driver since block layer can support block
> size > PAGE_SIZE. There was one issue with write_same16 and write_same10
> command, which is fixed as a part of the series.
> 
> Changes since v2:
>  - Added reviewed by tag for scsi sd driver and scsi_debug patch.
>  - Modified the helper function name used for safe creation and destruction
>    of the large page mempool.
>  - No functional changes.
> 
> Thanks to Damien for review.
> 
> Testing:
> Testing results are same as v3 since no functional changes introduced in v4.
> 
> Link to v3: https://lore.kernel.org/all/20260214011829.508272-1-sw.prabhu6@gmail.com/ [1]
> 
> Swarna Prabhu (2):
>   scsi: sd: enable sector size > PAGE_SIZE in scsi sd driver
>   scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE
> 
>  drivers/scsi/scsi_debug.c |  8 +---
>  drivers/scsi/sd.c         | 80 +++++++++++++++++++++++++++++++++------
>  2 files changed, 69 insertions(+), 19 deletions(-)
> 
> -- 
> 2.39.5
>

Gentle ping. 

Just wanted to make sure it didn't get lost. 

Please let me know if any updates are needed.

Thank you, 
Swarna Prabhu
