Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E01C136672;
	Sat,  6 Dec 2025 04:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764995622; cv=none; b=bFhlwYWMrbhTTK+FhdhWj5ilZUI9dz0qh/NyK9bNEVxNo6fkSNrtKvymtQeFWZWFZSo/tuD78Z4zh+8jDxkTEGoMtNwuFtVv7LhZdPwj7GViHPgxZrsVYHcB0EC4VZ6ueuCicEEf0j6JsDYHYU2jOa13KioBAkzzSBDRwVFlMZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764995622; c=relaxed/simple;
	bh=Md1SimGq5qnPuzKYZFxrSrGEZZ5QoV/uvOvuaT2CN4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQVYFxSt3i0SKj7drZafgm7qxs9gyHsQiWAZDCmWE446+Ys2coJKcfn2Fnm1SLJiwOJaZ1UvTbyWvAxxn1kuz5S5MHRNqWSwJZZyKT7zuDBPoozgsG6F/nGjIhTgJq1byhjtHFQBdTpswGd6LQ+Lqvd1IEKA9msQd9KPaXx5rm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eicj5rAY; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eicj5rAY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764995621; x=1796531621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Md1SimGq5qnPuzKYZFxrSrGEZZ5QoV/uvOvuaT2CN4Y=;
  b=Eicj5rAY2UBKefOImhNKHhj753a5aSIZeRmtZ0S7M1Vhkybc2I6KqZiE
   D9gK5GghHsMhgsxa3FCze6FdGyJP2B0+lhYigqBvLIABcHUlRHW+mldpU
   bOGAOh6g3z4MVcVj9V2FySrcE/ThZfPta0+aKd+U+k43H+45OfLvk2fvs
   Vz1k326QIahBUnO+y1Xr2oLJOX4m5/oLZdsfMQE0VzbcsWVun0B49sp0c
   c6ARuZu1H31tQqTWkTEWM01ASRZ4gyZgyLzxmqm0gqUajLeVeo3/M71pe
   cz2KUU8TOCWyLkdjVX/YAbzH9/0rWkdEcIvWR1kK/9/y+QJ5YlrBXcqP5
   Q==;
X-CSE-ConnectionGUID: BrxJ9mwuSySsPtpeOruCog==
X-CSE-MsgGUID: 0taT/KU1Rgaa3NPxjH/LNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11633"; a="77714539"
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="77714539"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 20:33:41 -0800
X-CSE-ConnectionGUID: p5V+HnW/Tl2WBR8sooaekw==
X-CSE-MsgGUID: 5wM3NbwSTVaroHT4W+MZiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="199938010"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 05 Dec 2025 20:33:38 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRjzD-00000000Fql-3JAC;
	Sat, 06 Dec 2025 04:33:35 +0000
Date: Sat, 6 Dec 2025 12:32:59 +0800
From: kernel test robot <lkp@intel.com>
To: Chaohai Chen <wdhh6@aliyun.com>, john.g.garry@oracle.com,
	yanaijie@huawei.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, dlemoal@kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Add error handling in the
 sas_register_phys()
Message-ID: <202512061205.azqGXDZt-lkp@intel.com>
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
config: parisc-randconfig-002-20251206 (https://download.01.org/0day-ci/archive/20251206/202512061205.azqGXDZt-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251206/202512061205.azqGXDZt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512061205.azqGXDZt-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/libsas/sas_phy.c: In function 'sas_register_phys':
>> drivers/scsi/libsas/sas_phy.c:165:30: error: passing argument 1 of 'sas_phy_free' from incompatible pointer type [-Wincompatible-pointer-types]
     165 |                 sas_phy_free(phy);
         |                              ^~~
         |                              |
         |                              struct asd_sas_phy *
   In file included from drivers/scsi/libsas/sas_internal.h:14,
                    from drivers/scsi/libsas/sas_phy.c:9:
   include/scsi/scsi_transport_sas.h:192:26: note: expected 'struct sas_phy *' but argument is of type 'struct asd_sas_phy *'
     192 | extern void sas_phy_free(struct sas_phy *);
         |                          ^~~~~~~~~~~~~~~~


vim +/sas_phy_free +165 drivers/scsi/libsas/sas_phy.c

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
