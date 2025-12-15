Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D0F31BC9E
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2025 04:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765771856; cv=none; b=G1xy/geYW33U6YP6uhM9IixDG9r1pMv5+JE+ir5hdzjkhThMfbkUd3DXvT7YTPJLVIauEaaOAa2KE5XpGUUbdN7qz26k+viGMAtXL6hhSFB2xu/ow+bselEMxEIjDA3HD8JVcA7h3UmniooMqGrUPVJyf80ovQxaT/Mcs9QycTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765771856; c=relaxed/simple;
	bh=VUYRsUTtVVa8X7hcy3vpjYmK1qxkXMNqKTsWetCPQ9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jq9lQafPOmneeo5rF80GHKaeprdTPqZ6VSj8ZgpYXMGXuocH00jrCADqlimOdofFIvrBKaJo5Iu87/RDnGq5QipP+DiU0c0DZR3Kh/qIN46DrnlcP3TUYKMIMhqV+/xHbc55/13bn3VRe/E0EOtmHX7ts1o9nIssXtdeSVU65gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7aHUQvP; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7aHUQvP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765771855; x=1797307855;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VUYRsUTtVVa8X7hcy3vpjYmK1qxkXMNqKTsWetCPQ9w=;
  b=l7aHUQvPVlJ14HwrDUNRqCmd/mMa9cKg5yL+hcyP2NGU8/OqqPWm9fv+
   EqYX7I669qJzRcmLZZJBeQdRoDZU+Yn7gtnuHCzLyATuFYqifB/1BUJEx
   oaqd/bAh7x3/yuGNPYuNjW0lvmu779bYN2gN8CD3eXCVQmeL3VSkn6ORp
   DxAKq/NZFpjcT3xD4SJd6KfLclO9QZiS/mX+WOTTCO8wByTIrAv8JPhqe
   dS4zCd6halJNTAj6JUJjkiGfoBjR8ABASXDytVmsLzN6C0GiOYPJ01BbG
   mMl+TJsxPJOZ+3hJsMTdwUYYYBnR7HKM6qKToA9a5+HmCYNvxUxFO7e4c
   A==;
X-CSE-ConnectionGUID: ARgz0ndRQ0uvOS8Ewa1q/g==
X-CSE-MsgGUID: O+nDNRHrQg+Ff9HKyDGtng==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="78785146"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="78785146"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2025 20:10:54 -0800
X-CSE-ConnectionGUID: hf4v2ifPThG9k+ZNkdFsAg==
X-CSE-MsgGUID: huj2U/LZSIOWLKFMQhJCAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="221016885"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 14 Dec 2025 20:10:53 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vUzv8-000000002Yq-3cGD;
	Mon, 15 Dec 2025 04:10:50 +0000
Date: Mon, 15 Dec 2025 05:10:18 +0100
From: kernel test robot <lkp@intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc: oe-kbuild-all@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
Message-ID: <202512150543.RnycrOo1-lkp@intel.com>
References: <1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig@baylibre.com>

Hi Uwe,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 7d0a66e4bb9081d75c82ec4957c50034cb0ea449]

url:    https://github.com/intel-lab-lkp/linux/commits/Uwe-Kleine-K-nig/scsi-Pass-a-struct-scsi_driver-to-scsi_-un-register_driver/20251210-044843
base:   7d0a66e4bb9081d75c82ec4957c50034cb0ea449
patch link:    https://lore.kernel.org/r/1931ec5bbe8d0ad82b6fbc77939d43bf5a4f177f.1765312062.git.u.kleine-koenig%40baylibre.com
patch subject: [PATCH 4/8] scsi: sd: Convert to scsi bus methods
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20251215/202512150543.RnycrOo1-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251215/202512150543.RnycrOo1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512150543.RnycrOo1-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: drivers/scsi/sd.c:3912 function parameter 'sdp' not described in 'sd_probe'
>> Warning: drivers/scsi/sd.c:4061 function parameter 'sd' not described in 'sd_remove'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
