Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839486EB55;
	Tue, 11 Jun 2024 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718128617; cv=none; b=Om3cv2sQSgQGsV6M7/cjLAqG2NnzHSoUvys2p2eK6EGdzT/zWRXPT7JWMwV8uZ/PFTFTyjqHsZwsUah4qJRd4cvNS2tf4P3nNjusOkTp8tO8lC5jbMX12QCN9XDupfy285O2w0FkNjuT5z0s7WhPN+Xz4sLrDtDPINP/RdlBg8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718128617; c=relaxed/simple;
	bh=8TvM/bRqUyTMkSqiC81inFb7tpuM7L3+iH0VcxVDbz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jr7ZH5AYY3b5qxi5Co23Lu1bi1TAZS8/gQ55pO9LQrwWuM/bZ12qe7yhLIKtlCnHBnXoC8qX2/JcUYASRUS3xs1YswU3EGgdbm1mvv3Jl2jDXw2OJHjRZQ9rHT79JctPYY1zjD+VBE+VOcYP9Yc74/t6iZ1UL+uw5sp8gjeSmic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jnhoOvfJ; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jnhoOvfJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718128614; x=1749664614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8TvM/bRqUyTMkSqiC81inFb7tpuM7L3+iH0VcxVDbz8=;
  b=jnhoOvfJL3AkK9Mp6rxNkJMsZABKiAFaSz6s5fpAUlpNSNVJyi1X+swX
   clwdyLCQ8hb2KrvNMiK4AjygvM2siQ6CK+l0yuBg2JuNYoqlCD8m+j+GG
   PnDbCJYSzbtpt1a3UJVkRIIIh/2lwyw/G/1vyyq997YMebYIEsrhQDmmB
   635Qfm0k49dC+/KQcqXBE/iaY+eL/iHgE0oj1BvB0CyapLr49R9P7+iMg
   ueej19DtfkIi67OEgA4fzQXfLwFC3xmSMpR3Vz6Xy0vYbgtlnGnrkz+4u
   oDiIbOaj+EbekNg5q6PD2ebLpzgde877P3yESIj5XkOsaFWUm7oMSuswb
   Q==;
X-CSE-ConnectionGUID: 3wejaKwRQh6N1RxcLSsIwg==
X-CSE-MsgGUID: EWpfw+l3RJug3DePQXNNAQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="32343810"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="32343810"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 10:56:54 -0700
X-CSE-ConnectionGUID: aKk0EH9DSE+dspHKScPDOA==
X-CSE-MsgGUID: 1je4VS79Q4KtZ0FDWUMtrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="39378009"
Received: from lkp-server01.sh.intel.com (HELO 628d7d8b9fc6) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 11 Jun 2024 10:56:51 -0700
Received: from kbuild by 628d7d8b9fc6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sH5jk-0000jm-1K;
	Tue, 11 Jun 2024 17:56:48 +0000
Date: Wed, 12 Jun 2024 01:56:37 +0800
From: kernel test robot <lkp@intel.com>
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, arulponn@cisco.com,
	djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
	satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: Re: [PATCH 04/14] scsi: fnic: Add support for target based solicited
 requests and responses
Message-ID: <202406120146.xchlZbqX-lkp@intel.com>
References: <20240610215100.673158-5-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610215100.673158-5-kartilak@cisco.com>

Hi Karan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.10-rc3 next-20240611]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Karan-Tilak-Kumar/scsi-fnic-Replace-shost_printk-with-pr_info-pr_err/20240611-060227
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240610215100.673158-5-kartilak%40cisco.com
patch subject: [PATCH 04/14] scsi: fnic: Add support for target based solicited requests and responses
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20240612/202406120146.xchlZbqX-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240612/202406120146.xchlZbqX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406120146.xchlZbqX-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/fnic/fdls_disc.c:1926:29: warning: variable 'gpn_ft_tgt_rem' set but not used [-Wunused-but-set-variable]
    1926 |         struct fc_gpn_ft_rsp_iu_s *gpn_ft_tgt_rem;
         |                                    ^
   drivers/scsi/fnic/fdls_disc.c:2208:26: warning: variable 'els_rjt' set but not used [-Wunused-but-set-variable]
    2208 |         struct fc_els_reject_s *els_rjt;
         |                                 ^
   drivers/scsi/fnic/fdls_disc.c:2890:11: warning: variable 's_id' set but not used [-Wunused-but-set-variable]
    2890 |         uint32_t s_id = 0;
         |                  ^
   drivers/scsi/fnic/fdls_disc.c:2891:11: warning: variable 'd_id' set but not used [-Wunused-but-set-variable]
    2891 |         uint32_t d_id = 0;
         |                  ^
   drivers/scsi/fnic/fdls_disc.c:1286:13: warning: unused function 'fnic_fdls_start_flogi' [-Wunused-function]
    1286 | static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
         |             ^~~~~~~~~~~~~~~~~~~~~
   5 warnings generated.


vim +/gpn_ft_tgt_rem +1926 drivers/scsi/fnic/fdls_disc.c

  1920	
  1921	static void
  1922	fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
  1923								 struct fc_hdr_s *fchdr, int len)
  1924	{
  1925		struct fc_gpn_ft_rsp_iu_s *gpn_ft_tgt;
> 1926		struct fc_gpn_ft_rsp_iu_s *gpn_ft_tgt_rem;
  1927		struct fnic_tport_s *tport, *next;
  1928		uint32_t fcid;
  1929		uint64_t wwpn;
  1930		int rem_len = len;
  1931		u32 old_link_down_cnt = iport->fnic->link_down_cnt;
  1932		struct fnic *fnic = iport->fnic;
  1933	
  1934		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1935					 "0x%x: FDLS process GPN_FT tgt list", iport->fcid);
  1936	
  1937		gpn_ft_tgt =
  1938			(struct fc_gpn_ft_rsp_iu_s *) ((uint8_t *) fchdr +
  1939									   sizeof(struct fc_hdr_s)
  1940									   + sizeof(struct fc_ct_hdr_s));
  1941		gpn_ft_tgt_rem = gpn_ft_tgt;
  1942		len -= sizeof(struct fc_hdr_s) + sizeof(struct fc_ct_hdr_s);
  1943	
  1944		while (rem_len > 0) {
  1945	
  1946			fcid = ntoh24(gpn_ft_tgt->fcid);
  1947			wwpn = ntohll(gpn_ft_tgt->wwpn);
  1948	
  1949			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1950					 "tport: 0x%x: ctrl:0x%x", fcid, gpn_ft_tgt->ctrl);
  1951	
  1952			if (fcid == iport->fcid) {
  1953				if (gpn_ft_tgt->ctrl & FNIC_FC_GPN_LAST_ENTRY)
  1954					break;
  1955				gpn_ft_tgt++;
  1956				rem_len -= sizeof(struct fc_gpn_ft_rsp_iu_s);
  1957				continue;
  1958			}
  1959	
  1960			tport = fnic_find_tport_by_wwpn(iport, wwpn);
  1961			if (!tport) {
  1962				/*
  1963				 * New port registered with the switch or first time query
  1964				 */
  1965				tport = fdls_create_tport(iport, fcid, wwpn);
  1966				if (!tport)
  1967					return;
  1968			}
  1969			/*
  1970			 * check if this was an existing tport with same fcid
  1971			 * but whose wwpn has changed now ,then remove it and
  1972			 * create a new one
  1973			 */
  1974			if (tport->fcid != fcid) {
  1975				fdls_delete_tport(iport, tport);
  1976				tport = fdls_create_tport(iport, fcid, wwpn);
  1977				if (!tport)
  1978					return;
  1979			}
  1980	
  1981			/*
  1982			 * If this GPN_FT rsp is after RSCN then mark the tports which
  1983			 * matches with the new GPN_FT list, if some tport is not
  1984			 * found in GPN_FT we went to delete that tport later.
  1985			 */
  1986			if (fdls_get_state((&iport->fabric)) == FDLS_STATE_RSCN_GPN_FT)
  1987				tport->flags |= FNIC_FDLS_TPORT_IN_GPN_FT_LIST;
  1988	
  1989			if (gpn_ft_tgt->ctrl & FNIC_FC_GPN_LAST_ENTRY)
  1990				break;
  1991	
  1992			gpn_ft_tgt++;
  1993			rem_len -= sizeof(struct fc_gpn_ft_rsp_iu_s);
  1994		}
  1995		if (rem_len <= 0) {
  1996			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  1997				 "GPN_FT response: malformed/corrupt frame rxlen: %d remlen: %d",
  1998				 len, rem_len);
  1999		}
  2000	
  2001		/*remove those ports which was not listed in GPN_FT */
  2002		if (fdls_get_state((&iport->fabric)) == FDLS_STATE_RSCN_GPN_FT) {
  2003			list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
  2004	
  2005				if (!(tport->flags & FNIC_FDLS_TPORT_IN_GPN_FT_LIST)) {
  2006					FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
  2007						 "Remove port: 0x%x not found in GPN_FT list",
  2008						 tport->fcid);
  2009					fdls_delete_tport(iport, tport);
  2010				} else {
  2011					tport->flags &= ~FNIC_FDLS_TPORT_IN_GPN_FT_LIST;
  2012				}
  2013				if ((old_link_down_cnt != iport->fnic->link_down_cnt)
  2014					|| (iport->state != FNIC_IPORT_STATE_READY)) {
  2015					return;
  2016				}
  2017			}
  2018		}
  2019	}
  2020	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
