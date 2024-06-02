Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3874AEE0;
	Sun,  2 Jun 2024 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717342622; cv=none; b=h176x8+1xshC3dIFSnFRRd5r3AaADlJf9+8vEbEdQmqBjrCVzTx85RTWZLdsWTuNy6NGDaN2EEsuk5hae2045wJbXzKsPbnscwwZ9vBjT0dsFqVZJ4k9O5xwS5ldgZ6ftSMyT7a3uerIuYba78/2SkryynyX/NREvqxjcicMXEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717342622; c=relaxed/simple;
	bh=MbibrFPEyNr14BCOBgUFtdjPaDraEEZrCduOjB6eY0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsBNYXFmdYWnJC/t6LeH2WxfJM0S3PYaDMhOvwmFkOy36nilZOd6edHIEkVpsldBW3CQK0sk5sDce5DUsD1acwbJTcXSUgy60vQfZ1kojXW5hYnoF9kc2AzDEgz3xbZEFYSOBRsSZTxLHKSIcOLtOUJ3HBIMKzGaJ5xtZEpdyzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SqlSl7yg; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SqlSl7yg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717342621; x=1748878621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=MbibrFPEyNr14BCOBgUFtdjPaDraEEZrCduOjB6eY0A=;
  b=SqlSl7yghU9Fv5sLvju4yMLVwezndVNhDYniFQeWxXsR+qDydHl8PtgA
   93f6+T+j3V5J1O40obfNicwKATjSgAxk2OJJW5inWMD1ir3f37UexojO6
   aXC8b8kI0CrfowqwsPnomxTYQE96pr6PBWYGgEULfgfYFR4QG3HVi4+CT
   0O/QhGWGprDo2pc2tnKjYWOsn9w6+0HaCcXUN9cQPhiwl5WCHPm0WGh6a
   tQ5UA6WZdAwmistVe8LZbh7OsRQ6NI9xlkuhdyQ7dX7W8SKnJy4gdCFF3
   O0s6J4fDw/sS8CF+3deAvxY/pCeWbuT6sol8HcKit99+vbMwtIdIzKVIf
   w==;
X-CSE-ConnectionGUID: Qnu8F9m4QHCMOJX/Dp/nuA==
X-CSE-MsgGUID: o7GAvxkHTqS+TuqEzTNMuw==
X-IronPort-AV: E=McAfee;i="6600,9927,11091"; a="13684242"
X-IronPort-AV: E=Sophos;i="6.08,209,1712646000"; 
   d="scan'208";a="13684242"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2024 08:37:00 -0700
X-CSE-ConnectionGUID: DM1vF2qPTrajh5DpO0DMCg==
X-CSE-MsgGUID: /Wu4d1s7Q6WyzklO2s6mSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,209,1712646000"; 
   d="scan'208";a="37277691"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2024 08:36:58 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.97)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1sDnGR-0000000D3GL-3RUE;
	Sun, 02 Jun 2024 18:36:55 +0300
Date: Sun, 2 Jun 2024 18:36:55 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 1/1] scsi: mpi3mr: Fix printf() specifier
Message-ID: <ZlyRl3Z_gD6ScHdR@smile.fi.intel.com>
References: <20240602140420.3247493-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240602140420.3247493-1-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Sun, Jun 02, 2024 at 05:04:20PM +0300, Andy Shevchenko wrote:
> Compiler is not happy about format string
> 
>   format ‘%lu’ expects argument of type ‘long unsigned int’, but argument 4 has type ‘unsigned int’ [-Werror=format=]
>   note: in expansion of macro ‘ioc_warn’
>   1367 |       ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
> 
> Fix the specifier to make it possible to build.

Already fixed by 9f365cb8bbd0 ("scsi: mpi3mr: Use proper format specifier in
mpi3mr_sas_port_add()").

-- 
With Best Regards,
Andy Shevchenko


