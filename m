Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5367D2DFA31;
	Sat,  6 Dec 2025 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765006854; cv=none; b=BlofsVM7hcvQAucmjNVaZ3SzlfxX1iIYeMNavZfGqxc2A2nUXace28fkOFFi37DIiNGvaGm9q0+ivEEnqkSHaJNk2+nyU4u1D4aUR9tkKMOOSG8hvJq5H96PrSg2YiT3ZMXRqDcFznHLnZCwp5LDQP2ewDnHhYRo+7kS96PBQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765006854; c=relaxed/simple;
	bh=vuJcU/QDZy21Pw7e9vdX7d3CPQfyDtrzRf05uOUFEH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXwtjqSpjbFGScSfrkDyQmkTVkQ+OT1a/zLHWEfxF4hSZmqWZbpmvVKg3aM4uPbvcvpd2AHa5Atb6eqKzqkK5tLh56o2FcNxX9v//9vdY/kTZPdjzU3g1bbD0VJQ2x4JvBUeu4+D7n/ABGnAPZ5MWqHC2roOrR1WkhfxsLRQUCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eWrSsA1S; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eWrSsA1S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765006852; x=1796542852;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vuJcU/QDZy21Pw7e9vdX7d3CPQfyDtrzRf05uOUFEH8=;
  b=eWrSsA1S8DzUkjmXQpRxyONfM1160gCPZdEzG/Us+Y5zDegmZ4Q48DQg
   TtkhQzltkLIRxT+spzcfo1xRoW13JVEzwaQ4Dq/pqcc7+Z6xUJD2i0Tf6
   wrXfMEBLHPevrEH6rNCsAl4M0RnZ/QCUexrwppIWaUWsV3A9AD1Hyqulk
   0fFZpgWQChZjcqnLi/ejYolWotwqBp2FGuS2FgV6eaPiyScTbND89ki+4
   MjVxuvwNseBWwmUlhKX5qBniF8VVf7kPAXUAnvFU+d6xKFeQ2QzkhsJ5j
   kwbzXYhwbZm+qylW7xaQDVzMJKZbXncIDkPg7HE0QpzUsPWeFGnJhUICJ
   Q==;
X-CSE-ConnectionGUID: TCKtniLyTDGAMHltTufNXA==
X-CSE-MsgGUID: JqfHdV8WT2Wu1QJmz6KqjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11633"; a="67195261"
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="67195261"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 23:40:51 -0800
X-CSE-ConnectionGUID: Dq/jTVuBRPCL7q2Q+Ozx+g==
X-CSE-MsgGUID: EXXUmSxHS1OyX0zkHwb0fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="199928735"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 05 Dec 2025 23:40:48 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRmuM-00000000Fzt-06pu;
	Sat, 06 Dec 2025 07:40:46 +0000
Date: Sat, 6 Dec 2025 15:39:59 +0800
From: kernel test robot <lkp@intel.com>
To: Chaohai Chen <wdhh6@aliyun.com>, john.g.garry@oracle.com,
	yanaijie@huawei.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, dlemoal@kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Add error handling in the
 sas_register_phys()
Message-ID: <202512061547.zszMg0HR-lkp@intel.com>
References: <20251205080252.1020028-1-wdhh6@aliyun.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205080252.1020028-1-wdhh6@aliyun.com>

Hi Chaohai,

kernel test robot noticed the following build errors:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.18 next-20251205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chaohai-Chen/scsi-libsas-Add-error-handling-in-the-sas_register_phys/20251205-174712
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251205080252.1020028-1-wdhh6%40aliyun.com
patch subject: [PATCH] scsi: libsas: Add error handling in the sas_register_phys()
config: hexagon-randconfig-001-20251206 (https://download.01.org/0day-ci/archive/20251206/202512061547.zszMg0HR-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251206/202512061547.zszMg0HR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512061547.zszMg0HR-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/scsi/libsas/sas_phy.c:165:16: error: incompatible pointer types passing 'struct asd_sas_phy *' to parameter of type 'struct sas_phy *' [-Werror,-Wincompatible-pointer-types]
                   sas_phy_free(phy);
                                ^~~
   include/scsi/scsi_transport_sas.h:192:42: note: passing argument to parameter here
   extern void sas_phy_free(struct sas_phy *);
                                            ^
   1 error generated.


vim +165 drivers/scsi/libsas/sas_phy.c

   115	
   116	int sas_register_phys(struct sas_ha_struct *sas_ha)
   117	{
   118		int i;
   119		int ret = 0;
   120	
   121		/* Now register the phys. */
   122		for (i = 0; i < sas_ha->num_phys; i++) {
   123			struct asd_sas_phy *phy = sas_ha->sas_phy[i];
   124	
   125			phy->error = 0;
   126			atomic_set(&phy->event_nr, 0);
   127			INIT_LIST_HEAD(&phy->port_phy_el);
   128	
   129			phy->port = NULL;
   130			phy->ha = sas_ha;
   131			spin_lock_init(&phy->frame_rcvd_lock);
   132			spin_lock_init(&phy->sas_prim_lock);
   133			phy->frame_rcvd_size = 0;
   134	
   135			phy->phy = sas_phy_alloc(&sas_ha->shost->shost_gendev, i);
   136			if (!phy->phy) {
   137				ret = -ENOMEM;
   138				goto fail;
   139			}
   140	
   141			phy->phy->identify.initiator_port_protocols =
   142				phy->iproto;
   143			phy->phy->identify.target_port_protocols = phy->tproto;
   144			phy->phy->identify.sas_address = SAS_ADDR(sas_ha->sas_addr);
   145			phy->phy->identify.phy_identifier = i;
   146			phy->phy->minimum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
   147			phy->phy->maximum_linkrate_hw = SAS_LINK_RATE_UNKNOWN;
   148			phy->phy->minimum_linkrate = SAS_LINK_RATE_UNKNOWN;
   149			phy->phy->maximum_linkrate = SAS_LINK_RATE_UNKNOWN;
   150			phy->phy->negotiated_linkrate = SAS_LINK_RATE_UNKNOWN;
   151	
   152			ret = sas_phy_add(phy->phy);
   153			if (ret) {
   154				sas_phy_free(phy->phy);
   155				goto fail;
   156			}
   157		}
   158	
   159		return 0;
   160	fail:
   161		for (i--; i >= 0; i--) {
   162			struct asd_sas_phy *phy = sas_ha->sas_phy[i];
   163	
   164			sas_phy_delete(phy->phy);
 > 165			sas_phy_free(phy);
   166		}
   167		return ret;
   168	}
   169	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
