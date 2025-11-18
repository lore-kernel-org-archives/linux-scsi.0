Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3302A30100F
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2025 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473116; cv=none; b=OOr/nISV7VcL06rie7O/yPh7Y3aOkSBRofCa2sEP0ZTfbfKoDlmd3PTSSEvY1Nnvd89Qo3fmrrYK/YyfhstlaaKhceGeXibrwWr0SQetv7+k+QbjLRqdOEQoHysNC5u+ipuYPtgD8rQIHO+0gKzYw7Ts/LFSCtQoX0kTrEjNlZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473116; c=relaxed/simple;
	bh=CSMN+2raUsI5Lk8o1UR3ipHcrxlw73UK/VcudD3rddk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcZEGj2JNb05b5oi1YILPUEHE6S+vAQSKdj9B0WaIYBaN/jwTw5vC7RAlu0ZIm3fAzTFzB4bO0WVedlL3f/I+y2LMnm4uLZqQaBrWRNvq4ymA7lTdtFTsneSWE7e0xr6qyH6gYfguiLpEzkE8RbU+eC5JM8xXxjZJ6tINnuDV5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wx2S8lYa; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wx2S8lYa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763473115; x=1795009115;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CSMN+2raUsI5Lk8o1UR3ipHcrxlw73UK/VcudD3rddk=;
  b=Wx2S8lYaFeWHXYVYaVsa1Ocb/dnFpT3DrFKkwV5LnXzc7iYb2f99ZCvX
   CWiKGSCnsYcJEfmy3vsq12CKSgjKrTm5jDLcmdWAtkFHO+FA0cMKVUWjF
   viI75Wqa+lj0yhjctkX3IQvCZBPe7hiQ4Yt0VcUqjIoE4hbPVB1LnuRSt
   B/afW/FppNwMObPXuWxX/GpgZsFZN66KNd61Y4P+P1g1uOvIZcM5OH+xu
   EnGeg5wkXFIuR5WoRSfOKXwELVgbYJICnlZk6B4k6ricEmFGtWnK6vXx4
   5IP2lZ/BmKLaVcDzH2y+V69bExNxbEOoI5+Bfv+O6hyLjZKQ7Z01a6dft
   g==;
X-CSE-ConnectionGUID: G1tsIdUlSgiA2TUzfg3uPA==
X-CSE-MsgGUID: CMcyRGGITYSTG4lnHA/T1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="75818267"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="75818267"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 05:38:35 -0800
X-CSE-ConnectionGUID: 89oTEYqAT2axniNjTW3Rew==
X-CSE-MsgGUID: NC+Xl2XhRAeZOqVb1hZFFg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 18 Nov 2025 05:38:33 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vLLug-0001md-1Z;
	Tue, 18 Nov 2025 13:38:30 +0000
Date: Tue, 18 Nov 2025 21:38:27 +0800
From: kernel test robot <lkp@intel.com>
To: Hao Dongdong <doubled@leap-io-kernel.com>,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com
Subject: Re: [PATCH v4] scsi: leapraid: Add new scsi driver
Message-ID: <202511182038.XDtPzsLQ-lkp@intel.com>
References: <20251116112803.28078-1-doubled@leap-io-kernel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116112803.28078-1-doubled@leap-io-kernel.com>

Hi Hao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on jejb-scsi/for-next]
[also build test WARNING on mkp-scsi/for-next linus/master v6.18-rc6 next-20251117]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hao-Dongdong/scsi-leapraid-Add-new-scsi-driver/20251116-192921
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251116112803.28078-1-doubled%40leap-io-kernel.com
patch subject: [PATCH v4] scsi: leapraid: Add new scsi driver
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20251118/202511182038.XDtPzsLQ-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251118/202511182038.XDtPzsLQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511182038.XDtPzsLQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/leapraid/leapraid_func.c:4794:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
    4794 |         default:
         |         ^
   drivers/scsi/leapraid/leapraid_func.c:4794:2: note: insert 'break;' to avoid fall-through
    4794 |         default:
         |         ^
         |         break; 
   1 warning generated.


vim +4794 drivers/scsi/leapraid/leapraid_func.c

  4741	
  4742	static void leapraid_fw_work(struct leapraid_adapter *adapter,
  4743				     struct leapraid_fw_evt_work *fw_evt)
  4744	{
  4745		struct leapraid_sas_dev *sas_dev;
  4746	
  4747		adapter->fw_evt_s.cur_evt = fw_evt;
  4748		leapraid_del_fw_evt_from_list(adapter, fw_evt);
  4749		if (adapter->access_ctrl.host_removing ||
  4750		    adapter->access_ctrl.pcie_recovering) {
  4751			leapraid_fw_evt_put(fw_evt);
  4752			adapter->fw_evt_s.cur_evt = NULL;
  4753			return;
  4754		}
  4755		switch (fw_evt->evt_type) {
  4756		case LEAPRAID_EVT_SAS_DISCOVERY:
  4757		{
  4758			struct leapraid_evt_data_sas_disc *evt_data;
  4759	
  4760			evt_data = fw_evt->evt_data;
  4761			if (evt_data->reason_code ==
  4762			    LEAPRAID_EVT_SAS_DISC_RC_STARTED &&
  4763			    !adapter->dev_topo.card.phys_num)
  4764				leapraid_sas_host_add(adapter, 0);
  4765			break;
  4766		}
  4767		case LEAPRAID_EVT_SAS_TOPO_CHANGE_LIST:
  4768			leapraid_sas_topo_chg_evt(adapter, fw_evt);
  4769			break;
  4770		case LEAPRAID_EVT_IR_CHANGE:
  4771			leapraid_sas_ir_chg_evt(adapter, fw_evt);
  4772			break;
  4773		case LEAPRAID_EVT_SAS_ENCL_DEV_STATUS_CHANGE:
  4774			leapraid_sas_enc_dev_stat_chg_evt(adapter, fw_evt);
  4775			break;
  4776		case LEAPRAID_EVT_REMOVE_DEAD_DEV:
  4777			while (scsi_host_in_recovery(adapter->shost) ||
  4778			       adapter->access_ctrl.shost_recovering) {
  4779				if (adapter->access_ctrl.host_removing ||
  4780				    adapter->fw_evt_s.fw_evt_cleanup)
  4781					goto out;
  4782	
  4783				ssleep(1);
  4784			}
  4785			leapraid_hardreset_async_logic(adapter);
  4786			break;
  4787		case LEAPRAID_EVT_TURN_ON_PFA_LED:
  4788			sas_dev = leapraid_get_sas_dev_by_hdl(adapter,
  4789							      fw_evt->dev_handle);
  4790			leapraid_set_led(adapter, sas_dev, true);
  4791			break;
  4792		case LEAPRAID_EVT_SCAN_DEV_DONE:
  4793			adapter->scan_dev_desc.scan_start = false;
> 4794		default:
  4795			break;
  4796		}
  4797	out:
  4798		leapraid_fw_evt_put(fw_evt);
  4799		adapter->fw_evt_s.cur_evt = NULL;
  4800	}
  4801	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
