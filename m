Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611A2302750
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 16:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768235920; cv=none; b=pN/8yHbpzD6eiblW+nOQ/ld1VnHSCK4G2m9mesbCtqflhOZ17iwHw9x5SuLItfEGLDa5HRgrjDl49kX2hVsdtNyw91AYPoG3KVvNXeku/Jp2o+i03RineDrpoVKQeNV606yiqTN2Pbk3m/eR9QJGqSceBWhYuCR8EbfK9kFVA5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768235920; c=relaxed/simple;
	bh=/Mp3OEvDa4qDhIFub/CNyIJPNOXW9Z8haYqf7nGfMAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRwFePyJIoaUUoQAyJcSeVJ2gJcgy4lEbSkvA6zK5NVdh1z6uQsqBs+pcncQ76ve3fRr62x6hfW5ZWKBUUtk2zXbrD98rUO1wBRE1rLB3qgmNiRnW0Ll/fpGV0XBxz6AnXs+fTQ+avMqr2L4g7nmZp7UKIYQY+/msJYuhS2niho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SRbc+g85; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SRbc+g85"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768235919; x=1799771919;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/Mp3OEvDa4qDhIFub/CNyIJPNOXW9Z8haYqf7nGfMAw=;
  b=SRbc+g854nAlBgFYHOxsNVzP9nLdZSvfziysLL0Q6sp59bOeJTi2plf5
   +zqjCQwA/KaIayv/sCXY0ofdt/Ob9T1zoR+Fyrvp/47kpEeLD/roQ2S9K
   kkGBQt61Poz/9VJReZVJ/jszcJGCuimCzJnvbhXkOR0Uh+w8tulv1RTo/
   dkOhy5B7l2JCEbZbeULtOjsLzoXo+0A/puvTc+6eJy1lErz+DrCPaamfq
   nPi0OFfyknKd2WAmlRCz59iblQnKZCH28MY/EE/4P59Fnynvv4cdQdXoh
   HeQSMireWyKkL03Xfra6WmLYfHIXzkOPdrXXz+B5QaCc1MRQLWovq9TBv
   A==;
X-CSE-ConnectionGUID: bzAjFrkEQQiOdGdomzvvqg==
X-CSE-MsgGUID: Gv6vunWET96vlR/jKPZXFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80234783"
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="80234783"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 08:38:39 -0800
X-CSE-ConnectionGUID: AaUi/sy3QtS0tZbvx+6MjQ==
X-CSE-MsgGUID: mqZMWVqjTGCgTR9Nf6wDYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="204042157"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 12 Jan 2026 08:38:36 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfKw5-00000000DaG-3fvh;
	Mon, 12 Jan 2026 16:38:33 +0000
Date: Tue, 13 Jan 2026 00:38:19 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
	salomondush@google.com, Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v1 4/7] mpi3mr: Use negotiated link rate from DevicePage0
Message-ID: <202601130005.zkxx1m3u-lkp@intel.com>
References: <20260112081037.74376-5-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112081037.74376-5-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.19-rc5 next-20260109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-Add-module-parameter-to-control-threaded-IRQ-polling/20260112-162241
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20260112081037.74376-5-ranjan.kumar%40broadcom.com
patch subject: [PATCH v1 4/7] mpi3mr: Use negotiated link rate from DevicePage0
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260113/202601130005.zkxx1m3u-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601130005.zkxx1m3u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601130005.zkxx1m3u-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_os.c:1220:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
    1220 |         default:
         |         ^
   drivers/scsi/mpi3mr/mpi3mr_os.c:1220:2: note: insert 'break;' to avoid fall-through
    1220 |         default:
         |         ^
         |         break; 
   1 warning generated.


vim +1220 drivers/scsi/mpi3mr/mpi3mr_os.c

  1153	
  1154		if (!(mrioc->logging_level &
  1155		    (MPI3_DEBUG_EVENT | MPI3_DEBUG_EVENT_WORK_TASK)))
  1156			return;
  1157	
  1158		ioc_info(mrioc,
  1159		    "device_pg0: handle(0x%04x), perst_id(%d), wwid(0x%016llx), encl_handle(0x%04x), slot(%d)\n",
  1160		    le16_to_cpu(dev_pg0->dev_handle),
  1161		    le16_to_cpu(dev_pg0->persistent_id),
  1162		    le64_to_cpu(dev_pg0->wwid), le16_to_cpu(dev_pg0->enclosure_handle),
  1163		    le16_to_cpu(dev_pg0->slot));
  1164		ioc_info(mrioc, "device_pg0: access_status(0x%02x), flags(0x%04x), device_form(0x%02x), queue_depth(%d)\n",
  1165		    dev_pg0->access_status, le16_to_cpu(dev_pg0->flags),
  1166		    dev_pg0->device_form, le16_to_cpu(dev_pg0->queue_depth));
  1167		ioc_info(mrioc, "device_pg0: parent_handle(0x%04x), iounit_port(%d)\n",
  1168		    le16_to_cpu(dev_pg0->parent_dev_handle), dev_pg0->io_unit_port);
  1169	
  1170		switch (dev_pg0->device_form) {
  1171		case MPI3_DEVICE_DEVFORM_SAS_SATA:
  1172		{
  1173			struct mpi3_device0_sas_sata_format *sasinf =
  1174			    &dev_pg0->device_specific.sas_sata_format;
  1175			ioc_info(mrioc,
  1176			    "device_pg0: sas_sata: sas_address(0x%016llx),flags(0x%04x),\n"
  1177			    "device_info(0x%04x), phy_num(%d), attached_phy_id(%d),negotiated_link_rate(0x%02x)\n",
  1178			    le64_to_cpu(sasinf->sas_address),
  1179			    le16_to_cpu(sasinf->flags),
  1180			    le16_to_cpu(sasinf->device_info), sasinf->phy_num,
  1181			    sasinf->attached_phy_identifier, sasinf->negotiated_link_rate);
  1182			break;
  1183		}
  1184		case MPI3_DEVICE_DEVFORM_PCIE:
  1185		{
  1186			struct mpi3_device0_pcie_format *pcieinf =
  1187			    &dev_pg0->device_specific.pcie_format;
  1188			ioc_info(mrioc,
  1189			    "device_pg0: pcie: port_num(%d), device_info(0x%04x), mdts(%d), page_sz(0x%02x)\n",
  1190			    pcieinf->port_num, le16_to_cpu(pcieinf->device_info),
  1191			    le32_to_cpu(pcieinf->maximum_data_transfer_size),
  1192			    pcieinf->page_size);
  1193			ioc_info(mrioc,
  1194			    "device_pg0: pcie: abort_timeout(%d), reset_timeout(%d) capabilities (0x%08x)\n",
  1195			    pcieinf->nvme_abort_to, pcieinf->controller_reset_to,
  1196			    le32_to_cpu(pcieinf->capabilities));
  1197			break;
  1198		}
  1199		case MPI3_DEVICE_DEVFORM_VD:
  1200		{
  1201			struct mpi3_device0_vd_format *vdinf =
  1202			    &dev_pg0->device_specific.vd_format;
  1203	
  1204			ioc_info(mrioc,
  1205			    "device_pg0: vd: state(0x%02x), raid_level(%d), flags(0x%04x),\n"
  1206			    "device_info(0x%04x) abort_timeout(%d), reset_timeout(%d)\n",
  1207			    vdinf->vd_state, vdinf->raid_level,
  1208			    le16_to_cpu(vdinf->flags),
  1209			    le16_to_cpu(vdinf->device_info),
  1210			    vdinf->vd_abort_to, vdinf->vd_reset_to);
  1211			ioc_info(mrioc,
  1212			    "device_pg0: vd: tg_id(%d), high(%dMiB), low(%dMiB), qd_reduction_factor(%d)\n",
  1213			    vdinf->io_throttle_group,
  1214			    le16_to_cpu(vdinf->io_throttle_group_high),
  1215			    le16_to_cpu(vdinf->io_throttle_group_low),
  1216			    ((le16_to_cpu(vdinf->flags) &
  1217			       MPI3_DEVICE0_VD_FLAGS_IO_THROTTLE_GROUP_QD_MASK) >> 12));
  1218	
  1219		}
> 1220		default:
  1221			break;
  1222		}
  1223	}
  1224	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
