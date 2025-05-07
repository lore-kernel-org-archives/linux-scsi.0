Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5416121519F;
	Wed,  7 May 2025 07:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746603111; cv=none; b=kixPVN+CKkk7oCFD7V+Ucdk6fTqhlVFG4gpRidzVChetDl06arzLexRhbnbaHiNbhuxn/JRYGckngcSWWLHTh8DfxqZB86lkDoo7yqBhhJitHus9Lr+8I5Lrwi9eUNmvc4bbdEkXENPas8k/NkXmRBIPJI9GmnKY0bwVdL5y5fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746603111; c=relaxed/simple;
	bh=J8vV48whjFWoJfoLKNP11HaSqljdUTAPOGpdU7CDSwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgPtOjtaZGO0EZyJq6xJPnSTq7Qg5uXJQCPiyWxbAjAK/awZoGIJPtdJL/Xz/sMRaF0uKM8Dmr8HfIEtVhwg5A99v62vpgrlqbLlvfPw//VyPZG6qDpPDPHB5GkHZ/z1PTUkuqqu5vzFYiQFR5k2cSt/hwpEMwa0A1IdP/LyTvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HtlMRhcQ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HtlMRhcQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746603109; x=1778139109;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J8vV48whjFWoJfoLKNP11HaSqljdUTAPOGpdU7CDSwA=;
  b=HtlMRhcQM1syCLlvaKyZcXu0adYGbBBcvDc1O0b9JbxezlTe0LOhq0cx
   B+LG1lsVi17KSDLendGescE8yDabxTxUlsHXh9zK2jpQ+B4u+NB7bJvkv
   O7zuLbGAn49JyIcdZtCsaFsEh46eSjAbVAL+MAOiWL0sgSJV9IBg4/HZe
   I9cHLo/GtjFEXNs8ak0Lcbwoh+OEucqTVMOO+nESDMJjLomHH8LrkNKp6
   xYKUL9jMYkyGelc2fBfHvPx5jc27h6Coa54owuW7zAGL1M0ZWQqMw46mX
   Ngf3iDt3dvIv8SBWxY+zce4rU7n6jCFNtfWuDpwxTpGUFjJzSoxwfHh31
   A==;
X-CSE-ConnectionGUID: g23Lhqp9QmyrdwU6ZBuLWA==
X-CSE-MsgGUID: yfQ9tPSlSZGD0QLphZkCpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47413842"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47413842"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 00:31:43 -0700
X-CSE-ConnectionGUID: RZKoYAW6S7ujDcZSfSTVYg==
X-CSE-MsgGUID: N0vZmk0ySu6yU0VhwUgSwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="140830302"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 07 May 2025 00:31:41 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCZFi-0007JT-1F;
	Wed, 07 May 2025 07:31:38 +0000
Date: Wed, 7 May 2025 15:31:14 +0800
From: kernel test robot <lkp@intel.com>
To: Rand Deeb <rand.sec96@gmail.com>, Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, deeb.rand@confident.ru,
	lvc-project@linuxtesting.org, voskresenski.stanislav@confident.ru,
	Rand Deeb <rand.sec96@gmail.com>
Subject: Re: [PATCH] scsi: NCR5380: Prevent potential out-of-bounds read in
 spi_print_msg()
Message-ID: <202505071504.SVF8vs1h-lkp@intel.com>
References: <20250430115926.6335-1-rand.sec96@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430115926.6335-1-rand.sec96@gmail.com>

Hi Rand,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.15-rc5 next-20250506]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rand-Deeb/scsi-NCR5380-Prevent-potential-out-of-bounds-read-in-spi_print_msg/20250430-200221
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20250430115926.6335-1-rand.sec96%40gmail.com
patch subject: [PATCH] scsi: NCR5380: Prevent potential out-of-bounds read in spi_print_msg()
config: alpha-randconfig-r072-20250501 (https://download.01.org/0day-ci/archive/20250507/202505071504.SVF8vs1h-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250507/202505071504.SVF8vs1h-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505071504.SVF8vs1h-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/scsi/g_NCR5380.c:691:
   drivers/scsi/NCR5380.c: In function 'NCR5380_reselect':
>> drivers/scsi/NCR5380.c:2107:51: error: 'len' undeclared (first use in this function); did you mean 'lun'?
    2107 |                 if (msg[0] == EXTENDED_MESSAGE && len >= 3) {
         |                                                   ^~~
         |                                                   lun
   drivers/scsi/NCR5380.c:2107:51: note: each undeclared identifier is reported only once for each function it appears in


vim +2107 drivers/scsi/NCR5380.c

  2099	
  2100		if (!(msg[0] & 0x80)) {
  2101			shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
  2102	
  2103			/*
  2104			 * Defensive check before calling spi_print_msg():
  2105			 * Avoid buffer overrun if msg claims extended length.
  2106			 */
> 2107			if (msg[0] == EXTENDED_MESSAGE && len >= 3) {
  2108				int expected_len = 2 + msg[1];
  2109	
  2110				if (expected_len == 2)
  2111					expected_len += 256;
  2112	
  2113				if (len >= expected_len)
  2114					spi_print_msg(msg);
  2115				else
  2116					pr_warn("spi_print_msg: skipping malformed extended message (len=%d, expected=%d)\n",
  2117						len, expected_len);
  2118			} else {
  2119				spi_print_msg(msg);
  2120			}
  2121	
  2122			printk("\n");
  2123			do_abort(instance, 0);
  2124			return;
  2125		}
  2126		lun = msg[0] & 0x07;
  2127	
  2128		/*
  2129		 * We need to add code for SCSI-II to track which devices have
  2130		 * I_T_L_Q nexuses established, and which have simple I_T_L
  2131		 * nexuses so we can chose to do additional data transfer.
  2132		 */
  2133	
  2134		/*
  2135		 * Find the command corresponding to the I_T_L or I_T_L_Q  nexus we
  2136		 * just reestablished, and remove it from the disconnected queue.
  2137		 */
  2138	
  2139		tmp = NULL;
  2140		list_for_each_entry(ncmd, &hostdata->disconnected, list) {
  2141			struct scsi_cmnd *cmd = NCR5380_to_scmd(ncmd);
  2142	
  2143			if (target_mask == (1 << scmd_id(cmd)) &&
  2144			    lun == (u8)cmd->device->lun) {
  2145				list_del(&ncmd->list);
  2146				tmp = cmd;
  2147				break;
  2148			}
  2149		}
  2150	
  2151		if (tmp) {
  2152			dsprintk(NDEBUG_RESELECTION | NDEBUG_QUEUES, instance,
  2153			         "reselect: removed %p from disconnected queue\n", tmp);
  2154		} else {
  2155			int target = ffs(target_mask) - 1;
  2156	
  2157			shost_printk(KERN_ERR, instance, "target bitmask 0x%02x lun %d not in disconnected queue.\n",
  2158			             target_mask, lun);
  2159			/*
  2160			 * Since we have an established nexus that we can't do anything
  2161			 * with, we must abort it.
  2162			 */
  2163			if (do_abort(instance, 0) == 0)
  2164				hostdata->busy[target] &= ~(1 << lun);
  2165			return;
  2166		}
  2167	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
