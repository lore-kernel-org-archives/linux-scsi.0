Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jvRocBZ5"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E171A5
	for <linux-scsi@vger.kernel.org>; Fri, 24 Nov 2023 03:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700826457; x=1732362457;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bdMfieBq5NBzi0NCq1F2f/GsfYXoB/Xj3SdrpNpIhw8=;
  b=jvRocBZ5VDN0o/1TszJ56dSnB041+iDKqzIwtpU/YMy/u/q8TVPO0itG
   YsooHR8gVgJO65xMp3EVArmHWTxmCZQx79WyKcPPUGPxPyz/LXtK6bYas
   Dd8bTxRwcqXuTlu/AiPHN9W1Tn1sgl/khr6yliPpaaC+0n3qVXTumRDle
   DMUcQ/JIVaksC9TjE0RdEKD4I3Ogm42oQWDhRce8JYM/97jdmfRSiIpQq
   FP6ny5IjNCAkgDoyctCM3N/L+7q5HbsMkfE6TX8eIeezQ4zpV9PqD7WxM
   rHc6LpKy6tML5YqDond706tYhN9WFAEgs2QnQ/CppwEzs+cOsc5ytCo/V
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="478620579"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="478620579"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2023 03:47:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="802159985"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="802159985"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 24 Nov 2023 03:47:33 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r6Ueh-0002i4-2J;
	Fri, 24 Nov 2023 11:47:31 +0000
Date: Fri, 24 Nov 2023 19:45:54 +0800
From: kernel test robot <lkp@intel.com>
To: Sumit Saxena <sumit.saxena@broadcom.com>, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com, ranjan.kumar@broadcom.com,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH 3/5] mpi3mr: Increase maximum number of PHYs to 64 from 32
Message-ID: <202311241311.O66vDF3e-lkp@intel.com>
References: <20231123160132.4155-4-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231123160132.4155-4-sumit.saxena@broadcom.com>

Hi Sumit,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.7-rc2 next-20231124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sumit-Saxena/mpi3mr-Add-support-for-SAS5116-PCI-IDs/20231124-004432
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20231123160132.4155-4-sumit.saxena%40broadcom.com
patch subject: [PATCH 3/5] mpi3mr: Increase maximum number of PHYs to 64 from 32
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20231124/202311241311.O66vDF3e-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231124/202311241311.O66vDF3e-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311241311.O66vDF3e-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_transport.c:1672:1: warning: stack frame size (1656) exceeds limit (1024) in 'mpi3mr_refresh_sas_ports' [-Wframe-larger-than]
   mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
   ^
   40/1656 (2.42%) spills, 1616/1656 (97.58%) variables
   1 warning generated.


vim +/mpi3mr_refresh_sas_ports +1672 drivers/scsi/mpi3mr/mpi3mr_transport.c

2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1659  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1660  /**
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1661   * mpi3mr_refresh_sas_ports - update host's sas ports during reset
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1662   * @mrioc: Adapter instance reference
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1663   *
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1664   * Update the host's sas ports during reset by checking whether
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1665   * sas ports are still intact or not. Add/remove phys if any hba
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1666   * phys are (moved in)/(moved out) of sas port. Also update
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1667   * io_unit_port if it got changed during reset.
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1668   *
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1669   * Return: Nothing.
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1670   */
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1671  void
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04 @1672  mpi3mr_refresh_sas_ports(struct mpi3mr_ioc *mrioc)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1673  {
6c7de6be82cd88 Sumit Saxena    2023-11-23  1674  	struct host_port h_port[64];
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1675  	int i, j, found, host_port_count = 0, port_idx;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1676  	u16 sz, attached_handle, ioc_status;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1677  	struct mpi3_sas_io_unit_page0 *sas_io_unit_pg0 = NULL;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1678  	struct mpi3_device_page0 dev_pg0;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1679  	struct mpi3_device0_sas_sata_format *sasinf;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1680  	struct mpi3mr_sas_port *mr_sas_port;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1681  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1682  	sz = offsetof(struct mpi3_sas_io_unit_page0, phy_data) +
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1683  		(mrioc->sas_hba.num_phys *
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1684  		 sizeof(struct mpi3_sas_io_unit0_phy_data));
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1685  	sas_io_unit_pg0 = kzalloc(sz, GFP_KERNEL);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1686  	if (!sas_io_unit_pg0)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1687  		return;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1688  	if (mpi3mr_cfg_get_sas_io_unit_pg0(mrioc, sas_io_unit_pg0, sz)) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1689  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1690  		    __FILE__, __LINE__, __func__);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1691  		goto out;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1692  	}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1693  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1694  	/* Create a new expander port table */
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1695  	for (i = 0; i < mrioc->sas_hba.num_phys; i++) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1696  		attached_handle = le16_to_cpu(
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1697  		    sas_io_unit_pg0->phy_data[i].attached_dev_handle);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1698  		if (!attached_handle)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1699  			continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1700  		found = 0;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1701  		for (j = 0; j < host_port_count; j++) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1702  			if (h_port[j].handle == attached_handle) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1703  				h_port[j].phy_mask |= (1 << i);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1704  				found = 1;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1705  				break;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1706  			}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1707  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1708  		if (found)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1709  			continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1710  		if ((mpi3mr_cfg_get_dev_pg0(mrioc, &ioc_status, &dev_pg0,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1711  		    sizeof(dev_pg0), MPI3_DEVICE_PGAD_FORM_HANDLE,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1712  		    attached_handle))) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1713  			dprint_reset(mrioc,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1714  			    "failed to read dev_pg0 for handle(0x%04x) at %s:%d/%s()!\n",
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1715  			    attached_handle, __FILE__, __LINE__, __func__);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1716  			continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1717  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1718  		if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1719  			dprint_reset(mrioc,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1720  			    "ioc_status(0x%x) while reading dev_pg0 for handle(0x%04x) at %s:%d/%s()!\n",
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1721  			    ioc_status, attached_handle,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1722  			    __FILE__, __LINE__, __func__);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1723  			continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1724  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1725  		sasinf = &dev_pg0.device_specific.sas_sata_format;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1726  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1727  		port_idx = host_port_count;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1728  		h_port[port_idx].sas_address = le64_to_cpu(sasinf->sas_address);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1729  		h_port[port_idx].handle = attached_handle;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1730  		h_port[port_idx].phy_mask = (1 << i);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1731  		h_port[port_idx].iounit_port_id = sas_io_unit_pg0->phy_data[i].io_unit_port;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1732  		h_port[port_idx].lowest_phy = sasinf->phy_num;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1733  		h_port[port_idx].used = 0;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1734  		host_port_count++;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1735  	}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1736  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1737  	if (!host_port_count)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1738  		goto out;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1739  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1740  	if (mrioc->logging_level & MPI3_DEBUG_RESET) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1741  		ioc_info(mrioc, "Host port details before reset\n");
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1742  		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1743  		    port_list) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1744  			ioc_info(mrioc,
6c7de6be82cd88 Sumit Saxena    2023-11-23  1745  			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%llx), lowest phy id:%d\n",
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1746  			    mr_sas_port->hba_port->port_id,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1747  			    mr_sas_port->remote_identify.sas_address,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1748  			    mr_sas_port->phy_mask, mr_sas_port->lowest_phy);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1749  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1750  		mr_sas_port = NULL;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1751  		ioc_info(mrioc, "Host port details after reset\n");
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1752  		for (i = 0; i < host_port_count; i++) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1753  			ioc_info(mrioc,
6c7de6be82cd88 Sumit Saxena    2023-11-23  1754  			    "port_id:%d, sas_address:(0x%016llx), phy_mask:(0x%llx), lowest phy id:%d\n",
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1755  			    h_port[i].iounit_port_id, h_port[i].sas_address,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1756  			    h_port[i].phy_mask, h_port[i].lowest_phy);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1757  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1758  	}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1759  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1760  	/* mark all host sas port entries as dirty */
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1761  	list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1762  	    port_list) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1763  		mr_sas_port->marked_responding = 0;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1764  		mr_sas_port->hba_port->flags |= MPI3MR_HBA_PORT_FLAG_DIRTY;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1765  	}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1766  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1767  	/* First check for matching lowest phy */
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1768  	for (i = 0; i < host_port_count; i++) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1769  		mr_sas_port = NULL;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1770  		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1771  		    port_list) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1772  			if (mr_sas_port->marked_responding)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1773  				continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1774  			if (h_port[i].sas_address != mr_sas_port->remote_identify.sas_address)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1775  				continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1776  			if (h_port[i].lowest_phy == mr_sas_port->lowest_phy) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1777  				mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1778  				break;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1779  			}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1780  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1781  	}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1782  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1783  	/* In case if lowest phy is got enabled or disabled during reset */
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1784  	for (i = 0; i < host_port_count; i++) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1785  		if (h_port[i].used)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1786  			continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1787  		mr_sas_port = NULL;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1788  		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1789  		    port_list) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1790  			if (mr_sas_port->marked_responding)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1791  				continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1792  			if (h_port[i].sas_address != mr_sas_port->remote_identify.sas_address)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1793  				continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1794  			if (h_port[i].phy_mask & mr_sas_port->phy_mask) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1795  				mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1796  				break;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1797  			}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1798  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1799  	}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1800  
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1801  	/* In case if expander cable is removed & connected to another HBA port during reset */
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1802  	for (i = 0; i < host_port_count; i++) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1803  		if (h_port[i].used)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1804  			continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1805  		mr_sas_port = NULL;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1806  		list_for_each_entry(mr_sas_port, &mrioc->sas_hba.sas_port_list,
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1807  		    port_list) {
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1808  			if (mr_sas_port->marked_responding)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1809  				continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1810  			if (h_port[i].sas_address != mr_sas_port->remote_identify.sas_address)
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1811  				continue;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1812  			mpi3mr_update_mr_sas_port(mrioc, &h_port[i], mr_sas_port);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1813  			break;
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1814  		}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1815  	}
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1816  out:
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1817  	kfree(sas_io_unit_pg0);
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1818  }
2745ce0e6d30e6 Sreekanth Reddy 2022-08-04  1819  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
