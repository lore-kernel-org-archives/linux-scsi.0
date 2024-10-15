Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBD1149E16;
	Tue, 15 Oct 2024 14:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729002142; cv=none; b=PbpbetDM7cQ79EPoCWIcAP/4Tgg59bzpiwb0OGbpQ/cUCO7r5nwv+4SeDWXD/+ohqTh32nCnkqChaPTHeUiRVcRLCaxduJr4CeZZciea3MKYB91DQScFbbUh3gxP2LpzAqTqPxR+ViamRWj34AeUlQKt2/0ZL1CyYx2ocDOnOyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729002142; c=relaxed/simple;
	bh=HuBuDOBZlDKw1ie6EnYoUFOaBmu0FKJjOB0iKFgplMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/x6FjJoaKqKAXQqDvYwk9WgJxy84m7rr9bgF3hY+FerOHbTaWqZoYT7/ylZf4MMk9sY0W2ntXTVlEqpqy0uLUPABHaM4fJFO/R4cp7+OkXwjsb+QVT6gsJQ7Gim/ZVhB4CXb9dojQIX0U0fs3DkPwyCwdhXYcmmIxTDgto80iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=gCic02pT; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="gCic02pT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=iHTADtA8mgjzVQYD/9veROrNM7yCfLo9AznQ5JsLVWQ=; b=gCic02pT/tp9oZ32
	SbCzvIMdV0eQ11uBzRL3c/YvlVimF1CV1r1gLADu3QymVcSCRe/QLm6GubwyzCgjOhdHsYBgSHwWt
	5zEvvsfQqk+DJAidhRVRx0yJNG9GSrZeKVUoLX14lK764Pt13ZWrXRF5xDrFeMGQfZy7E1k4iPfoO
	yxsOEjbZ5p4Jg9MWsiwNsbiGLe0J9i39mE3L0sAkUsouMlOTvVzp0G9L6Iy1uTbuVHkxoxywEvnUq
	Vc4XoNgUycbktSSOFXdJr39vMN7JPNLSc8KygnQk9h0lcEJWloYMgRKlYgT5ZtJoK85Pa74xbP1oO
	ImarhTuuAXpZvlHViQ==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t0iR1-00BD5J-2x;
	Tue, 15 Oct 2024 14:22:03 +0000
Date: Tue, 15 Oct 2024 14:22:03 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] scsi: bfa: Remove deadcode
Message-ID: <Zw56i3SiL6oSAZvi@gallifrey>
References: <20240915125633.25036-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20240915125633.25036-1-linux@treblig.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 14:21:44 up 160 days,  1:35,  1 user,  load average: 0.04, 0.06,
 0.01
User-Agent: Mutt/2.2.12 (2023-09-09)

* linux@treblig.org (linux@treblig.org) wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Hi,
>   This removes a pile of dead functions in the SCSI bfa driver.
> These were spotted by hunting for unused symbols in a unmodular
> kernel build, and then double checking by grepping for the function
> name.
> 
>   It's been build tested only, I don't have the hardware, but
> it's strictly full function (and the occasional struct) deletion,
> so there should be no change in functionality.
> 
>   Thanks to David Hildenbrand for the suggestion of hunting
> for unused symbols.
> 
> Dave
> 

Ping; thanks!

> Dr. David Alan Gilbert (5):
>   scsi: bfa: Remove unused bfa_core code
>   scsi: bfa: Remove unused bfa_svc code
>   scsi: bfa: Remove unused bfa_ioc code
>   scsi: bfa: Remove unused bfa_fcs code
>   scsi: bfa: Remove unused misc code
> 
>  drivers/scsi/bfa/bfa.h           |  10 ---
>  drivers/scsi/bfa/bfa_core.c      |  35 --------
>  drivers/scsi/bfa/bfa_defs_fcs.h  |  22 -----
>  drivers/scsi/bfa/bfa_fcpim.c     |   9 --
>  drivers/scsi/bfa/bfa_fcpim.h     |   1 -
>  drivers/scsi/bfa/bfa_fcs.h       |  12 ---
>  drivers/scsi/bfa/bfa_fcs_lport.c | 142 -------------------------------
>  drivers/scsi/bfa/bfa_fcs_rport.c |  36 --------
>  drivers/scsi/bfa/bfa_ioc.c       |  21 -----
>  drivers/scsi/bfa/bfa_ioc.h       |   2 -
>  drivers/scsi/bfa/bfa_modules.h   |   1 -
>  drivers/scsi/bfa/bfa_svc.c       |  72 ----------------
>  drivers/scsi/bfa/bfa_svc.h       |   5 --
>  drivers/scsi/bfa/bfad.c          |  20 -----
>  drivers/scsi/bfa/bfad_drv.h      |   1 -
>  15 files changed, 389 deletions(-)
> 
> -- 
> 2.46.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
