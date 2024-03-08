Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE6D5644D
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 11:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709898054; cv=none; b=rgEjZfUUGmYyJo+Ou7Gfa++bMTQIra6d75spefMJ/Iwe1Bvb6yr4qk3DOgIXMA/VjPjbfCZ/TXEZPfx2MavEo8a/rkj9MZkkVqobeaC2CPoG6r6ioyX4Tx4JLrV09i/hSXiHO8QJ8V6Mh+NdH5ijlxTtcM0REPNMN4+LqoTpEsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709898054; c=relaxed/simple;
	bh=NnHNwuUYWXbqCN61qmbmALWDwvvVdIF1A8TcLCaMDTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i00VnFmO58aebuZ+53OGCugdcS2M5jy+87FsaPZ48xmVm6AR2aO7vJ1HV8O9FnukEEki2PLZ1HkUlO9Y+h8CuFngcrXA5GX0vf44w/mM7JX08LdKINYqQpsMsomktK2EZm9VIkXuL4/wVqJFNT7VwozfgGUFm/3YyktNEYCfg7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OC8mm0eZ; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OC8mm0eZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709898053; x=1741434053;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NnHNwuUYWXbqCN61qmbmALWDwvvVdIF1A8TcLCaMDTw=;
  b=OC8mm0eZZKcuXXjgcKoUeoY6plir52ytWviQvhX4eGvXSo6LmNddZXpD
   63FAFp1+gabcCrAJW6QUt9a03EoB9pNQs0QrB0Cb5Hf7uzsOeJxrHuW5b
   jhifblU7HVNhVaMImbdCGwFdBpbRYGW/LNuNcttzZtTxwqgWG/2JwCSGQ
   xpBYJxe7jCIOfzyFoYWubQzH/CMwvDEmt+gzhtQRsfqHJlwH6sDEa6EoT
   u+zdutuYId9woWz3R1qkQ4gpPJ/2ZivdrhIgAQtFFNFQdXOQimcu2Y0Cz
   a/3csekaRz2iTpJlGMpeoFS+Bzq9wQncFza7LUkGw7oqe0u5v5TvBpGEb
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4540962"
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="4540962"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 03:40:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="41363644"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 08 Mar 2024 03:40:49 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1riYak-0006LD-20;
	Fri, 08 Mar 2024 11:40:46 +0000
Date: Fri, 8 Mar 2024 19:40:08 +0800
From: kernel test robot <lkp@intel.com>
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: Re: [PATCH v2 5/7] mpi3mr: Debug ability improvements
Message-ID: <202403081903.q3Dq54zZ-lkp@intel.com>
References: <20240307150825.7613-6-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307150825.7613-6-ranjan.kumar@broadcom.com>

Hi Ranjan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.8-rc7 next-20240308]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ranjan-Kumar/mpi3mr-Block-devices-are-not-removed-from-OS-even-vd-s-are-offlined/20240307-231302
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20240307150825.7613-6-ranjan.kumar%40broadcom.com
patch subject: [PATCH v2 5/7] mpi3mr: Debug ability improvements
config: microblaze-allmodconfig (https://download.01.org/0day-ci/archive/20240308/202403081903.q3Dq54zZ-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240308/202403081903.q3Dq54zZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403081903.q3Dq54zZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/mpi3mr/mpi3mr_fw.c: In function 'mpi3mr_issue_reset':
>> drivers/scsi/mpi3mr/mpi3mr_fw.c:1531:54: warning: variable 'scratch_pad0' set but not used [-Wunused-but-set-variable]
    1531 |         u32 host_diagnostic, ioc_status, ioc_config, scratch_pad0;
         |                                                      ^~~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c: In function 'mpi3mr_setup_isr':
   drivers/scsi/mpi3mr/mpi3mr_fw.c:732:58: warning: '%d' directive output may be truncated writing between 1 and 3 bytes into a region of size between 1 and 32 [-Wformat-truncation=]
     732 |         snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
         |                                                          ^~
   In function 'mpi3mr_request_irq',
       inlined from 'mpi3mr_setup_isr' at drivers/scsi/mpi3mr/mpi3mr_fw.c:857:12:
   drivers/scsi/mpi3mr/mpi3mr_fw.c:732:55: note: directive argument in the range [0, 255]
     732 |         snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
         |                                                       ^~~~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:732:55: note: directive argument in the range [0, 65535]
   drivers/scsi/mpi3mr/mpi3mr_fw.c:732:9: note: 'snprintf' output between 8 and 45 bytes into a destination of size 32
     732 |         snprintf(intr_info->name, MPI3MR_NAME_LENGTH, "%s%d-msix%d",
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     733 |             mrioc->driver_name, mrioc->id, index);
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c: In function 'mpi3mr_start_watchdog':
   drivers/scsi/mpi3mr/mpi3mr_fw.c:2690:60: warning: '%s' directive output may be truncated writing up to 31 bytes into a region of size 11 [-Wformat-truncation=]
    2690 |             sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
         |                                                            ^~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:2690:50: note: directive argument in the range [0, 255]
    2690 |             sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
         |                                                  ^~~~~~~~~~~~~~~
   drivers/scsi/mpi3mr/mpi3mr_fw.c:2689:9: note: 'snprintf' output between 11 and 44 bytes into a destination of size 20
    2689 |         snprintf(mrioc->watchdog_work_q_name,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2690 |             sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
         |             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2691 |             mrioc->id);
         |             ~~~~~~~~~~


vim +/scratch_pad0 +1531 drivers/scsi/mpi3mr/mpi3mr_fw.c

  1512	
  1513	/**
  1514	 * mpi3mr_issue_reset - Issue reset to the controller
  1515	 * @mrioc: Adapter reference
  1516	 * @reset_type: Reset type
  1517	 * @reset_reason: Reset reason code
  1518	 *
  1519	 * Unlock the host diagnostic registers and write the specific
  1520	 * reset type to that, wait for reset acknowledgment from the
  1521	 * controller, if the reset is not successful retry for the
  1522	 * predefined number of times.
  1523	 *
  1524	 * Return: 0 on success, non-zero on failure.
  1525	 */
  1526	static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
  1527		u16 reset_reason)
  1528	{
  1529		int retval = -1;
  1530		u8 unlock_retry_count = 0;
> 1531		u32 host_diagnostic, ioc_status, ioc_config, scratch_pad0;
  1532		u32 timeout = MPI3MR_RESET_ACK_TIMEOUT * 10;
  1533	
  1534		if ((reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) &&
  1535		    (reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT))
  1536			return retval;
  1537		if (mrioc->unrecoverable)
  1538			return retval;
  1539		if (reset_reason == MPI3MR_RESET_FROM_FIRMWARE) {
  1540			retval = 0;
  1541			return retval;
  1542		}
  1543	
  1544		ioc_info(mrioc, "%s reset due to %s(0x%x)\n",
  1545		    mpi3mr_reset_type_name(reset_type),
  1546		    mpi3mr_reset_rc_name(reset_reason), reset_reason);
  1547	
  1548		mpi3mr_clear_reset_history(mrioc);
  1549		do {
  1550			ioc_info(mrioc,
  1551			    "Write magic sequence to unlock host diag register (retry=%d)\n",
  1552			    ++unlock_retry_count);
  1553			if (unlock_retry_count >= MPI3MR_HOSTDIAG_UNLOCK_RETRY_COUNT) {
  1554				ioc_err(mrioc,
  1555				    "%s reset failed due to unlock failure, host_diagnostic(0x%08x)\n",
  1556				    mpi3mr_reset_type_name(reset_type),
  1557				    host_diagnostic);
  1558				mrioc->unrecoverable = 1;
  1559				return retval;
  1560			}
  1561	
  1562			writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_FLUSH,
  1563			    &mrioc->sysif_regs->write_sequence);
  1564			writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_1ST,
  1565			    &mrioc->sysif_regs->write_sequence);
  1566			writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
  1567			    &mrioc->sysif_regs->write_sequence);
  1568			writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_3RD,
  1569			    &mrioc->sysif_regs->write_sequence);
  1570			writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_4TH,
  1571			    &mrioc->sysif_regs->write_sequence);
  1572			writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_5TH,
  1573			    &mrioc->sysif_regs->write_sequence);
  1574			writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_6TH,
  1575			    &mrioc->sysif_regs->write_sequence);
  1576			usleep_range(1000, 1100);
  1577			host_diagnostic = readl(&mrioc->sysif_regs->host_diagnostic);
  1578			ioc_info(mrioc,
  1579			    "wrote magic sequence: retry_count(%d), host_diagnostic(0x%08x)\n",
  1580			    unlock_retry_count, host_diagnostic);
  1581		} while (!(host_diagnostic & MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE));
  1582	
  1583		scratch_pad0 = ((MPI3MR_RESET_REASON_OSTYPE_LINUX <<
  1584		    MPI3MR_RESET_REASON_OSTYPE_SHIFT) | (mrioc->facts.ioc_num <<
  1585		    MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
  1586		writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
  1587		writel(host_diagnostic | reset_type,
  1588		    &mrioc->sysif_regs->host_diagnostic);
  1589		switch (reset_type) {
  1590		case MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET:
  1591			do {
  1592				ioc_status = readl(&mrioc->sysif_regs->ioc_status);
  1593				ioc_config =
  1594				    readl(&mrioc->sysif_regs->ioc_configuration);
  1595				if ((ioc_status & MPI3_SYSIF_IOC_STATUS_RESET_HISTORY)
  1596				    && mpi3mr_soft_reset_success(ioc_status, ioc_config)
  1597				    ) {
  1598					mpi3mr_clear_reset_history(mrioc);
  1599					retval = 0;
  1600					break;
  1601				}
  1602				msleep(100);
  1603			} while (--timeout);
  1604			mpi3mr_print_fault_info(mrioc);
  1605			break;
  1606		case MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT:
  1607			do {
  1608				ioc_status = readl(&mrioc->sysif_regs->ioc_status);
  1609				if (mpi3mr_diagfault_success(mrioc, ioc_status)) {
  1610					retval = 0;
  1611					break;
  1612				}
  1613				msleep(100);
  1614			} while (--timeout);
  1615			break;
  1616		default:
  1617			break;
  1618		}
  1619	
  1620		writel(MPI3_SYSIF_WRITE_SEQUENCE_KEY_VALUE_2ND,
  1621		    &mrioc->sysif_regs->write_sequence);
  1622	
  1623		ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
  1624		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
  1625		ioc_info(mrioc,
  1626		    "ioc_status/ioc_onfig after %s reset is (0x%x)/(0x%x)\n",
  1627		    (!retval)?"successful":"failed", ioc_status,
  1628		    ioc_config);
  1629		if (retval)
  1630			mrioc->unrecoverable = 1;
  1631		return retval;
  1632	}
  1633	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
