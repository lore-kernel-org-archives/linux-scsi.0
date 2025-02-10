Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C841F55E0;
	Mon, 10 Feb 2025 11:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739188443; cv=none; b=VNJvNwu6r9u65VlRsVmYss8GUk5Mx5gYpXY4WRzjJPKTh2P8pv+QJG+eq6TrJ2Lis3XKiEBEpjRRob54lzGyWYDYnbONZn2UfjMtebXZnVoPtqXiSYRdqVeoh7Xpq0yLJMPZDvd5OZRG94yU2a5vmfmiz3pPB/Ibl3LsGyLJUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739188443; c=relaxed/simple;
	bh=loxoA323gRWBeaQUvoZMWbW5ojYtcSo6KsEv28mcQj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LoYr1YjykAD2Xj4tenj2Ius+2v1DgwaZIKBUdo+pU5dLURNihYNsrXO/Q7uQ1LSvMAM2GQnKmkzcC/+FIt8pnFUR48p7+pFqzumAR+v+XucIq0he81dl7qO3OmFpcMu9rDv4WSl2XJo9YlGTT2rtBNOSOTdUP8MGlPG2e/D4pco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OmpfbarN; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OmpfbarN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739188441; x=1770724441;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=loxoA323gRWBeaQUvoZMWbW5ojYtcSo6KsEv28mcQj8=;
  b=OmpfbarNhY8FCk8K/8wsEhffez5A43Tpz/5X5oSyCG9FWyqNDCCH+kU0
   x85xvARUh7zFJZ6OVHfiPRRhISmsCHNgC3JpWaXgy57Ak5OO9ELp7NSaS
   QZGKDbFFeD7f6w0d4d+BwyZxscUNuI1rn1tfXuCXtrOB7u17+IF697s8x
   9uRDhebRLGO0s4cLTFNS6iHgaz9Opp1rqL6wV1P4hArxWMKGsqlRlXIKB
   p+hwIn8Onyj8/Oa3yoKR3FkHWCBujbbdlm7xlj6ochxsXkl5DzwLlNtzy
   vOr2+rieCvxSfh5zVp65m5l3NS1lPPnVlf3N3Y3IJSU26Q6jf4XaAXCNF
   w==;
X-CSE-ConnectionGUID: HWu7h9CVTyi50/lV/5tZvQ==
X-CSE-MsgGUID: BN95nTWMSfK7mhBKF+Tzjw==
X-IronPort-AV: E=McAfee;i="6700,10204,11340"; a="39452931"
X-IronPort-AV: E=Sophos;i="6.13,274,1732608000"; 
   d="scan'208";a="39452931"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 03:54:01 -0800
X-CSE-ConnectionGUID: 4yBIGGmTTJKeFkTSu2aGfg==
X-CSE-MsgGUID: YlQ0Osd7TNamNRpU7CxyBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,274,1732608000"; 
   d="scan'208";a="112122342"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa006.jf.intel.com with ESMTP; 10 Feb 2025 03:53:52 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 965CB2F2; Mon, 10 Feb 2025 13:53:50 +0200 (EET)
Date: Mon, 10 Feb 2025 13:53:50 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Kees Cook <kees@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Shevchenko <andy@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-coco@lists.linux.dev, 
	Sathya Prakash <sathya.prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, 
	Sumit Saxena <sumit.saxena@broadcom.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, 
	Sven Eckelmann <sven@narfation.org>, Tadeusz Struk <tadeusz.struk@linaro.org>, 
	kernel test robot <lkp@intel.com>, Erick Archer <erick.archer@outlook.com>, 
	Dmitry Antipov <dmantipov@yandex.ru>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, 
	linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com, 
	GR-QLogic-Storage-Upstream@marvell.com, linux-hardening@vger.kernel.org, linux-nilfs@vger.kernel.org
Subject: Re: [PATCH 06/10] x86/tdx: Mark message.str as nonstring
Message-ID: <75r5wrrxaxlw4ksb4gxpt2njusmr4cyohdut4iyxqxkziv6r54@uf22so3ics4c>
References: <20250207005832.work.324-kees@kernel.org>
 <20250207010022.749952-6-kees@kernel.org>
 <b4f08d43-c421-4e8d-9bbb-c954c4472f8a@intel.com>
 <202502061835.F57547B@keescook>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202502061835.F57547B@keescook>

On Thu, Feb 06, 2025 at 06:37:27PM -0800, Kees Cook wrote:
> On Thu, Feb 06, 2025 at 05:12:11PM -0800, Dave Hansen wrote:
> > On 2/6/25 17:00, Kees Cook wrote:
> > > +++ b/arch/x86/coco/tdx/tdx.c
> > > @@ -170,7 +170,7 @@ static void __noreturn tdx_panic(const char *msg)
> > >  		/* Define register order according to the GHCI */
> > >  		struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };
> > >  
> > > -		char str[64];
> > > +		char str[64] __nonstring;
> > >  	} message;
> > 
> > So, the patch itself makes sense. But it does end up looking kinda
> > funky. We call it a "str"ing and then annotate it as not a string.
> 
> Yeah, this is true all over the place. It's a string, just not a
> NUL-terminated string: *sob*
> 
> > It doesn't have to be done in this patch, but it does seem like we
> > should probably not be using 'char' and also shouldn't call it anything
> > close to "string". Maybe:
> > 
> >	 	u8 message[64] __nonstring;
> > 	} message;
> 
> message.message ;)
> 
> message.chars?
> message.bytes?

.bytes sounds good to me.

Anyway:

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
