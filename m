Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A880219F13B;
	Thu,  6 Feb 2025 18:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738868253; cv=none; b=IhngL7zPM0pZ88g5ZIaI+IBMO2NequwQ3yarQZDKLIBNyUo/nZrDWWj/2pm5Q2GSIoqTRUdfIa9Xrzhk40OQNv/2EmLCrRdKRJxGIypAQHVP4+haW6J634/lpuB6x4FXfdktUxU2V0KJBwKS/2d6knKn05IkI79kDP8Dz87kMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738868253; c=relaxed/simple;
	bh=TAmjX8PAsGAtciV6BI/t/prkf5BEpJkD0CfbH/IQE/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmyA2C2RdK65zmdjFcWAdT/9MDv1Mm8w/xiz/SB1VQS+eFoagOoy50szy787Im/aRD5rms320DBWPFFTkalCh269AsFDmdHS91wlK1Eh4eBZDogGF6xubyScY8I1C2lyH4/9JbkJ1Jv+wbM/C9Ad220OIRFeiQpNzHhj6z3NAbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YyA1L68V; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YyA1L68V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738868251; x=1770404251;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=TAmjX8PAsGAtciV6BI/t/prkf5BEpJkD0CfbH/IQE/M=;
  b=YyA1L68VMuatVbskTGvXG9WUTY7cQhLCIKVnpjfZql+4f4XkVlU8zTsb
   CYBASK/QKBdAZWdvL57F3Z4p9ohbj2mNCque2k1GaUZu5nkUsMkBR46Hj
   wqNSiZTNnn/X2MhEXbnPsS1xflGL3+UMMiB0G5DiuZg41n1V1YCl6ucGl
   HWbPhqvs+6NWxdCQrozLE58q0AHyKdOkiInFsMtFerbVqLFsmAhJmgngS
   E8gdBSDZnBYxlVmgG+e3IGwEgQCU6B7Sj+4SDXNvFyizAaHByNVv24S/A
   duJYjR4eyFcE0DuIH2FQc8fRnwaK68QIXlbNQItdRXjQ6jxdzXtKC7274
   w==;
X-CSE-ConnectionGUID: 3omd/ZxYT9qY5KUXaA1TNg==
X-CSE-MsgGUID: fAuUKiarTmy2XW8WAZO5RA==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="50476822"
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="50476822"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 10:57:31 -0800
X-CSE-ConnectionGUID: 8F1wNKrQSr+K6G6/dSox4g==
X-CSE-MsgGUID: tq73ziQzQHmn6my/0tTz3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="111270515"
Received: from smile.fi.intel.com ([10.237.72.58])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 10:57:29 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.98)
	(envelope-from <andriy.shevchenko@linux.intel.com>)
	id 1tg742-00000008ozj-1tDw;
	Thu, 06 Feb 2025 20:57:26 +0200
Date: Thu, 6 Feb 2025 20:57:26 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Justin Tee <justin.tee@broadcom.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH v1 1/1] scsi: lpfc: Switch to use %ptTs
Message-ID: <Z6UGFoJbAGjI5VJW@smile.fi.intel.com>
References: <20250206155822.1126056-1-andriy.shevchenko@linux.intel.com>
 <20250206174537-a38cd6ae-e0fe-4344-8655-2593e20fd394@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250206174537-a38cd6ae-e0fe-4344-8655-2593e20fd394@linutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Thu, Feb 06, 2025 at 05:52:16PM +0100, Thomas Weißschuh wrote:
> On Thu, Feb 06, 2025 at 05:58:22PM +0200, Andy Shevchenko wrote:

...

> >  	lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
> > -			"2646 Updated CMF timestamp : "
> > -			"%u/%u/%u %u:%u:%u\n",
> > -			ts->day, ts->month,
> > -			ts->year, ts->hour,
> > -			ts->minute, ts->second);
> > +			"2646 Updated CMF timestamp : %ptTs\n", cur_time);
> 
> All %p<FOO> arguments need to be addresses.
> Also %ptT wants a time64_t, not a 'struct timespec64'.
> It would work by chance because tv_sec is the first member and time64_t.
> 
> Correct: "&cur_time.tv_sec".

Indeed, thanks!

-- 
With Best Regards,
Andy Shevchenko


