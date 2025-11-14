Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D854F36C0B6;
	Tue, 18 Nov 2025 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763490286; cv=none; b=dnSDtUaywiY5BKzlgYKmr5k2E8V/zwqUSmGGF38S59sjNI/fRO0AfHBqU4SlyF9Elk0084YN2xzQKu2WTMkL5qe8rCKQAVG4F8t4sHaZSb8nG2sJgVRe9pUyEC+kI35ENnJu41zdTm3h7hIjhw+PXEsplOUfCb13CGqnIJG3w2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763490286; c=relaxed/simple;
	bh=smBt9xKgv+8Ljt0jn1EWKPyE4mn1srC3xH4nd3DxsXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwA5fdgn0X0Scfz7gCCfp+aaQlgfRDLPf/Kwjt2cywNo+4DFmMGoo2TH0QvnmmIHsXu9ygSTyc2i7BU95A5Mx+bzzopdzgHbWpcv8CY6yKh7oeDsev36Di3sZLFQsfqitK6psBgU350RL73Ub2cXMr98ajYX1a7GN0wqbdsf43M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hks9GPqA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hks9GPqA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763490285; x=1795026285;
  h=resent-from:resent-date:resent-message-id:resent-to:date:
   from:to:cc:subject:message-id:references:mime-version:
   in-reply-to;
  bh=smBt9xKgv+8Ljt0jn1EWKPyE4mn1srC3xH4nd3DxsXs=;
  b=Hks9GPqAwKL998V3CF77QbuHnlRDua/37KFTgdDRhMIdlEafFqpUdej4
   XTYx/u7IZRwTtHlEc7/vAWpnF5HqMz7EjGbh+K6yLJoYlyLDQo9Ecxz/4
   7snMhM9tAysw9Wnh+HL0dd/khF6kEm6vLTTVvW5j3S/S8NmmrVm8wPLBU
   15BR1RtPVwsSeztqIjx4fCpOacPlw7fXJhz8kH6VNH727JIkojfUm4/cF
   8J6pAYMfzsnNZxZdEUqN3u733BS1NmLcJnY67rSuMizDIO4bgeKaNNsm2
   arCVVpXSfFIT5jOzySalxEBXFF3bG5KsIkny49MIfKgZd4jFtkvNjpfum
   g==;
X-CSE-ConnectionGUID: BbK6HVhVRF6SIgVcwcVe7A==
X-CSE-MsgGUID: b0Tj24eGTLSfpUOX2epduA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="69138618"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69138618"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 10:24:44 -0800
X-CSE-ConnectionGUID: m8/zAGudTWqB5NwtJBfmhQ==
X-CSE-MsgGUID: hp4xmospQhuC0rftwX98Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="221735733"
Received: from dalessan-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.97])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 10:24:42 -0800
Resent-From: Andy Shevchenko <andriy.shevchenko@intel.com>
Resent-Date: Tue, 18 Nov 2025 20:24:40 +0200
Resent-Message-ID: <aRy56C2gVMC2PoT-@ashevche-desk.local>
Resent-To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux@rasmusvillemoes.dk, senozhatsky@chromium.org,
	James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
	pmladek@suse.com
Date: Fri, 14 Nov 2025 10:42:34 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"openipmi-developer@lists.sourceforge.net" <openipmi-developer@lists.sourceforge.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"freedreno@lists.freedesktop.org" <freedreno@lists.freedesktop.org>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Satish Kharat (satishkh)" <satishkh@cisco.com>,
	"Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 19/21] scsi: fnic: Switch to use %ptSp
Message-ID: <aRbreoKzashQcEne@smile.fi.intel.com>
References: <20251113150217.3030010-1-andriy.shevchenko@linux.intel.com>
 <20251113150217.3030010-20-andriy.shevchenko@linux.intel.com>
 <SJ0PR11MB5896D2F9DAC35FF8ADB29087C3CDA@SJ0PR11MB5896.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR11MB5896D2F9DAC35FF8ADB29087C3CDA@SJ0PR11MB5896.namprd11.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, Nov 13, 2025 at 10:34:36PM +0000, Karan Tilak Kumar (kartilak) wrote:
> On Thursday, November 13, 2025 6:33 AM, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

...

> Can you please advise how I can compile test this change?

I have added the following to my x86_64_defconfig

CONFIG_SCSI_FC_ATTRS=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE_FNIC=m

You can always add the just a one (last) line to a configuration stanza that
can be merged to the .config with help of merge_config tool. It will take care
of all needed dependencies.

-- 
With Best Regards,
Andy Shevchenko


