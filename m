Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF201F239F;
	Wed, 11 Dec 2024 23:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733959473; cv=none; b=Ll2AwcT4ATengwtRvwrE0YNIbUxsUyrJ19kvl38KIE5C1/WtQILY1Ran3JjVHmKhEBbAwvd4KwZM9ALo0fJHmrReb6bKBg/PTkFmYmReq1gftXlckBkIyaBgaMXYl7f00L4G0Ur/RHDTtTQBhXsxs1NlPkTMZHsPNVaQnGgm5EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733959473; c=relaxed/simple;
	bh=62eGNKv2jlcOfyJIkzn6DDpCE5ZY2ynMYIthNzGLF2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+L9nk8oVq1yqKu5EYRObIASRe91Opwv7UdTTPKuXYM81V9jBUKsMtNxLnyovptr62eP12oRNQkVOQR3Iw6SzceZamnAeb944n6NPNzAhzQqwfhSh89aAxjwurcZTUvs1k9jmia28foLHS6oXVB4BsW3L2106hZLcHZD60HxWU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hyoJfb3x; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hyoJfb3x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733959471; x=1765495471;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=62eGNKv2jlcOfyJIkzn6DDpCE5ZY2ynMYIthNzGLF2E=;
  b=hyoJfb3xpwbZfBPnxT+xF5UinutXXpvE2kZ8+VC8kKjcovk1U6nC9Vd9
   nm5wx3XWfZI13LKXlbcbKN7lFShqtogT8TTQdqesQUK+vsHR95RGaIdnB
   KW6J7o8nZ2rYNzxXQDOZK0vZcwHprVxLpKhKj0II1HiRMFYS2LXp9mZ9z
   HRa7tZQ9wydZly2aBj4kI/b5Xr0GcMrCpOBRLSKqglwYiF5jdNwaF5TO0
   H0tlP35B2OqZXZfFp+rhBKNGjnHRdNKCFyZIXPKl0sR5yXa9P/o0kRETQ
   +u0aIkCgINNRJfAEt6CRyAnVa0FDO/ee2nZAQoRU0pfO4/aemwC+LUtzM
   g==;
X-CSE-ConnectionGUID: hUAZlC9WRtGAo8T3B7EiKg==
X-CSE-MsgGUID: A6D4Ek9dQjOtUAlcYs6xYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="44973645"
X-IronPort-AV: E=Sophos;i="6.12,226,1728975600"; 
   d="scan'208";a="44973645"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 15:24:31 -0800
X-CSE-ConnectionGUID: 1UA/6KddRz+DuWLMcGse0g==
X-CSE-MsgGUID: X3/2OIgvQPuaqA1El1xOAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="126969147"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 11 Dec 2024 15:24:28 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tLW4A-0007Cf-0u;
	Wed, 11 Dec 2024 23:24:26 +0000
Date: Thu, 12 Dec 2024 07:23:45 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
	linux-scsi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	fbarrat@linux.ibm.com, ukrishn@linux.ibm.com, manoj@linux.ibm.com,
	clombard@linux.ibm.com, vaibhav@linux.ibm.com
Subject: Re: [PATCH 1/2] cxl: Deprecate driver
Message-ID: <202412120701.08jViR9I-lkp@intel.com>
References: <20241210054055.144813-2-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210054055.144813-2-ajd@linux.ibm.com>

Hi Andrew,

kernel test robot noticed the following build warnings:

[auto build test WARNING on char-misc/char-misc-testing]
[also build test WARNING on char-misc/char-misc-next char-misc/char-misc-linus jejb-scsi/for-next mkp-scsi/for-next linus/master v6.13-rc2 next-20241211]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrew-Donnellan/cxl-Deprecate-driver/20241210-134451
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20241210054055.144813-2-ajd%40linux.ibm.com
patch subject: [PATCH 1/2] cxl: Deprecate driver
reproduce: (https://download.01.org/0day-ci/archive/20241212/202412120701.08jViR9I-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412120701.08jViR9I-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: Documentation/arch/powerpc/cxl.rst references a file that doesn't exist: Documentation/ABI/testing/sysfs-class-cxl
   Warning: Documentation/devicetree/bindings/regulator/siliconmitus,sm5703-regulator.yaml references a file that doesn't exist: Documentation/devicetree/bindings/mfd/siliconmitus,sm5703.yaml
   Warning: Documentation/hwmon/g762.rst references a file that doesn't exist: Documentation/devicetree/bindings/hwmon/g762.txt
   Warning: Documentation/hwmon/isl28022.rst references a file that doesn't exist: Documentation/devicetree/bindings/hwmon/isl,isl28022.yaml
   Warning: Documentation/translations/ja_JP/SubmittingPatches references a file that doesn't exist: linux-2.6.12-vanilla/Documentation/dontdiff
   Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
