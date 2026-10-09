Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A51E33BBD9;
	Fri,  9 Oct 2026 20:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791577766; cv=none; b=ivBa5lhjA7uxURQG/JyCAGbO7TKDbLgSXV0z6eOJfsQUqi943LfAAiiw4C7GXi1DWKx4VxTid3VdJZ41pl34JBZD0wgCmNsT58mNHW9izMGEUNC9qEK7+X0P+CAKhJUwcSrI6TuZksxoIH0ggeBRekq3ffcrjLN8t0ZH9AH/5lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791577766; c=relaxed/simple;
	bh=N6GWgE6fmvtl3ic4OGMSelBMSe140c+Yw//7o6UYAaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fS7o3UliPiKnUl90Yw265KhVekTrPS3FePh9ZUUHahOS13e2TtPEA/6NlN1lRzLE9ZRnVQ1Q0ZLAmEQ1pDXpOyaOdLy4GtZeQmrhDIL+hU3R7TaGfBeVd0S3FzdfgcLa3PxQc6e/Lkrtik6SaNq//alYZGUDyfYLGYU3mCAX1+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+y+lKml; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+y+lKml"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791577765; x=1823113765;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N6GWgE6fmvtl3ic4OGMSelBMSe140c+Yw//7o6UYAaE=;
  b=d+y+lKmla3tqVFo09AkeEMPXo+cJa074guva35ssP+fOCkQLWTBIZXte
   kE5XQ6uoURJDENqJAoglUZBjkfJjj7BdypqtXSaVV4pBP9Llp3wz4WqNa
   6BY+LDGIWi3esjkr/mXl9F+zm3yGjltQenLAifMdPC8qloaXR6xJPDoTx
   ripfXL1I4Ki69JM1Dn1p7G1fRPSipOX0mSGnimhqt7LQObeNixyP8eBGs
   klZzpTw2XdGBWfNwbxa4Q6fWaB41ZLRaE+zNW+B6N/2EsDT6UJLBUNva1
   VuoW/Cy486woRMnRI3IHZErJtpLEXTHEKQMsJA2B8TcWh/Lr/FIVlBPNq
   g==;
X-CSE-ConnectionGUID: hb3A2bWyRPe6lb2D4dX6/Q==
X-CSE-MsgGUID: pw8i1K7PSz280lEnX10k5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="377339"
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="377339"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 13:29:24 -0700
X-CSE-ConnectionGUID: dcbKz97PR2KL6gNmUxWfzw==
X-CSE-MsgGUID: 1lMqbYAlQqKHnURBp6y0/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,149,1787036400"; 
   d="scan'208";a="846926"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 09 Oct 2026 13:29:20 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xFHDS-000000006Ae-098j;
	Fri, 09 Oct 2026 20:29:18 +0000
Date: Sat, 10 Oct 2026 04:29:11 +0800
From: kernel test robot <lkp@intel.com>
To: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	Dave Marquardt <davemarq@linux.ibm.com>
Subject: Re: [PATCH v13 11/11] scsi: ibmvfc: handle extended FPIN events
Message-ID: <202610100443.UCrGdTXp-lkp@intel.com>
References: <20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc@linux.ibm.com>

Hi Dave,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c3cff7fac01638ab58e85fe7df41a04fa25c5bae]

url:    https://github.com/intel-lab-lkp/linux/commits/Dave-Marquardt-via-B4-Relay/scsi-ibmvfc-fix-IRQ-leak-and-guard-deregister-on-channel-reg-failure/20261007-142545
base:   c3cff7fac01638ab58e85fe7df41a04fa25c5bae
patch link:    https://lore.kernel.org/r/20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc%40linux.ibm.com
patch subject: [PATCH v13 11/11] scsi: ibmvfc: handle extended FPIN events
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20261010/202610100443.UCrGdTXp-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261010/202610100443.UCrGdTXp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610100443.UCrGdTXp-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:1914 expecting prototype for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'severity' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3449 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3488 function parameter 'wwpn' not described in 'ibmvfc_ext_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5505 function parameter 'protocol' not described in 'ibmvfc_alloc_target'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'fpin_status' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'wwpn' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'type' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'modifier' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'threshold' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'event_count' not described in 'ibmvfc_common_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3328 function parameter 'severity' not described in 'ibmvfc_common_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'crq' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 function parameter 'wwpn' not described in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3410 Excess function parameter 'ibmvfc_fpin' description in 'ibmvfc_basic_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3449 function parameter 'wwpn' not described in 'ibmvfc_full_fpin_to_desc'
>> Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:3488 function parameter 'wwpn' not described in 'ibmvfc_ext_fpin_to_desc'
   Warning: drivers/scsi/ibmvscsi/ibmvfc-core.c:5505 function parameter 'protocol' not described in 'ibmvfc_alloc_target'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
