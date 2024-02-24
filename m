Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F8DDF6C
	for <linux-scsi@vger.kernel.org>; Sat, 24 Feb 2024 02:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708740187; cv=none; b=HNCcjxw6pVaktBcsO+tJFGUeBKvvIdSwhYSENE6IsSs5hvcXKWi6Mmt0aGyHJ13iRdJ24nxa1hwUm4e4l8dkfSPIujSShSd2/0dBt7Mk4eE/HBexdYsP0oNaoNAdNHrqQ0lzCHNPUbE40G/rrCJKQRWSw8H+C8+Lfuk21RAfsz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708740187; c=relaxed/simple;
	bh=PVcJD/080UG9t+/QtPvHXPFBLE1rt+Iv49dtKmvGCCE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITF+E451i/GitwH9OU7Wrv6F13ZBIMeCz9UcZvTnUIV3LSylkr/VmFb9RkHcRAPL1xjZUXrPL34u7VdUAzO/zxGhzsid6lArH0Dk8/NAMACC1TS3rVmrdsJlf/Jx01ho1PzQuGvJhQ0pQiAUlR0icb7lN1ZkJn2swPZT/ZS981g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mO7e49o1; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mO7e49o1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708740185; x=1740276185;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PVcJD/080UG9t+/QtPvHXPFBLE1rt+Iv49dtKmvGCCE=;
  b=mO7e49o1HEURl99qsNCqfXz2gY+G2jfBFTiyxvuD4ZBqWTmczpyF8ycK
   HyV9/S1ex6aOVlsVhYCQd1ZcBao/BeQ5TfuBm88EcTJUOAlTPNv7BNDLB
   YXUNo6H8imyacsbJs8cpLMMMUMWGFVtMSCR8Xl1LJh4k+cW/CN3CHdqiE
   NPAo2ZjGzAB8YSzIGG7nryfb/Atc6iHwntHYF2bN4SO3mjjxL+AJWY7jB
   L3KpKBnQ1/TgCjoFKPEzLz7Hr6YcNSk9Ug25uxo2/aMAvj+whrxHoeRtN
   DMYRceDyyVG5RePHeW0YQxDFzxdhb0vBE5dWk71VVjpNgkV5IwKL7COtC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10993"; a="2958087"
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="2958087"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2024 18:03:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,180,1705392000"; 
   d="scan'208";a="5973195"
Received: from lkp-server02.sh.intel.com (HELO 3c78fa4d504c) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 23 Feb 2024 18:03:00 -0800
Received: from kbuild by 3c78fa4d504c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rdhNS-00086Y-0y;
	Sat, 24 Feb 2024 02:02:58 +0000
Date: Sat, 24 Feb 2024 10:02:41 +0800
From: kernel test robot <lkp@intel.com>
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
	sdeodhar@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
Subject: Re: [PATCH 03/11] qla2xxx: Split FCE|EFT trace control
Message-ID: <202402240913.dFLbIVfU-lkp@intel.com>
References: <20240223074514.8472-4-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223074514.8472-4-njavali@marvell.com>

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f4469f3858352ad1197434557150b1f7086762a0]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-Prevent-command-send-on-chip-reset/20240223-154651
base:   f4469f3858352ad1197434557150b1f7086762a0
patch link:    https://lore.kernel.org/r/20240223074514.8472-4-njavali%40marvell.com
patch subject: [PATCH 03/11] qla2xxx: Split FCE|EFT trace control
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20240224/202402240913.dFLbIVfU-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240224/202402240913.dFLbIVfU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202402240913.dFLbIVfU-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/qla2xxx/qla_init.c: In function 'qla2x00_setup_chip':
>> drivers/scsi/qla2xxx/qla_init.c:4268:18: warning: variable 'fw_major_version' set but not used [-Wunused-but-set-variable]
    4268 |         uint16_t fw_major_version;
         |                  ^~~~~~~~~~~~~~~~


vim +/fw_major_version +4268 drivers/scsi/qla2xxx/qla_init.c

efa74a62aaa242 Quinn Tran          2023-07-14  4253  
^1da177e4c3f41 Linus Torvalds      2005-04-16  4254  /**
^1da177e4c3f41 Linus Torvalds      2005-04-16  4255   * qla2x00_setup_chip() - Load and start RISC firmware.
2db6228d9cd13b Bart Van Assche     2018-01-23  4256   * @vha: HA context
^1da177e4c3f41 Linus Torvalds      2005-04-16  4257   *
^1da177e4c3f41 Linus Torvalds      2005-04-16  4258   * Returns 0 on success.
^1da177e4c3f41 Linus Torvalds      2005-04-16  4259   */
^1da177e4c3f41 Linus Torvalds      2005-04-16  4260  static int
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  4261  qla2x00_setup_chip(scsi_qla_host_t *vha)
^1da177e4c3f41 Linus Torvalds      2005-04-16  4262  {
^1da177e4c3f41 Linus Torvalds      2005-04-16  4263  	int rval;
0107109ed69c9e Andrew Vasquez      2005-07-06  4264  	uint32_t srisc_address = 0;
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  4265  	struct qla_hw_data *ha = vha->hw;
3db0652ef986f3 Andrew Vasquez      2008-01-31  4266  	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
3db0652ef986f3 Andrew Vasquez      2008-01-31  4267  	unsigned long flags;
dda772e8e3b983 Andrew Vasquez      2009-03-24 @4268  	uint16_t fw_major_version;
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4269  	int done_once = 0;
3db0652ef986f3 Andrew Vasquez      2008-01-31  4270  
7ec0effd30bb4b Atul Deshmukh       2013-08-27  4271  	if (IS_P3P_TYPE(ha)) {
a9083016a5314b Giridhar Malavali   2010-04-12  4272  		rval = ha->isp_ops->load_risc(vha, &srisc_address);
14e303d98bcfe4 Andrew Vasquez      2010-07-23  4273  		if (rval == QLA_SUCCESS) {
14e303d98bcfe4 Andrew Vasquez      2010-07-23  4274  			qla2x00_stop_firmware(vha);
a9083016a5314b Giridhar Malavali   2010-04-12  4275  			goto enable_82xx_npiv;
14e303d98bcfe4 Andrew Vasquez      2010-07-23  4276  		} else
b963752f47c54a Giridhar Malavali   2010-05-28  4277  			goto failed;
a9083016a5314b Giridhar Malavali   2010-04-12  4278  	}
a9083016a5314b Giridhar Malavali   2010-04-12  4279  
3db0652ef986f3 Andrew Vasquez      2008-01-31  4280  	if (!IS_FWI2_CAPABLE(ha) && !IS_QLA2100(ha) && !IS_QLA2200(ha)) {
3db0652ef986f3 Andrew Vasquez      2008-01-31  4281  		/* Disable SRAM, Instruction RAM and GP RAM parity.  */
3db0652ef986f3 Andrew Vasquez      2008-01-31  4282  		spin_lock_irqsave(&ha->hardware_lock, flags);
04474d3a1c9681 Bart Van Assche     2020-05-18  4283  		wrt_reg_word(&reg->hccr, (HCCR_ENABLE_PARITY + 0x0));
04474d3a1c9681 Bart Van Assche     2020-05-18  4284  		rd_reg_word(&reg->hccr);
3db0652ef986f3 Andrew Vasquez      2008-01-31  4285  		spin_unlock_irqrestore(&ha->hardware_lock, flags);
3db0652ef986f3 Andrew Vasquez      2008-01-31  4286  	}
^1da177e4c3f41 Linus Torvalds      2005-04-16  4287  
18e7555a38eaad Andrew Vasquez      2009-06-03  4288  	qla81xx_mpi_sync(vha);
18e7555a38eaad Andrew Vasquez      2009-06-03  4289  
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4290  execute_fw_with_lr:
^1da177e4c3f41 Linus Torvalds      2005-04-16  4291  	/* Load firmware sequences */
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  4292  	rval = ha->isp_ops->load_risc(vha, &srisc_address);
0107109ed69c9e Andrew Vasquez      2005-07-06  4293  	if (rval == QLA_SUCCESS) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4294  		ql_dbg(ql_dbg_init, vha, 0x00c9,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4295  		    "Verifying Checksum of loaded RISC code.\n");
^1da177e4c3f41 Linus Torvalds      2005-04-16  4296  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  4297  		rval = qla2x00_verify_checksum(vha, srisc_address);
^1da177e4c3f41 Linus Torvalds      2005-04-16  4298  		if (rval == QLA_SUCCESS) {
^1da177e4c3f41 Linus Torvalds      2005-04-16  4299  			/* Start firmware execution. */
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4300  			ql_dbg(ql_dbg_init, vha, 0x00ca,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4301  			    "Starting firmware.\n");
^1da177e4c3f41 Linus Torvalds      2005-04-16  4302  
b0d6cabd355ae9 Himanshu Madhani    2015-12-17  4303  			if (ql2xexlogins)
b0d6cabd355ae9 Himanshu Madhani    2015-12-17  4304  				ha->flags.exlogins_enabled = 1;
b0d6cabd355ae9 Himanshu Madhani    2015-12-17  4305  
99e1b683c4be3f Quinn Tran          2017-06-02  4306  			if (qla_is_exch_offld_enabled(vha))
2f56a7f1b5d8cf Himanshu Madhani    2015-12-17  4307  				ha->flags.exchoffld_enabled = 1;
2f56a7f1b5d8cf Himanshu Madhani    2015-12-17  4308  
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  4309  			rval = qla2x00_execute_fw(vha, srisc_address);
^1da177e4c3f41 Linus Torvalds      2005-04-16  4310  			/* Retrieve firmware information. */
dda772e8e3b983 Andrew Vasquez      2009-03-24  4311  			if (rval == QLA_SUCCESS) {
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4312  				/* Enable BPM support? */
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4313  				if (!done_once++ && qla24xx_detect_sfp(vha)) {
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4314  					ql_dbg(ql_dbg_init, vha, 0x00ca,
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4315  					    "Re-starting firmware -- BPM.\n");
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4316  					/* Best-effort - re-init. */
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4317  					ha->isp_ops->reset_chip(vha);
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4318  					ha->isp_ops->chip_diag(vha);
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4319  					goto execute_fw_with_lr;
b0f18eee6fc1ee Andrew Vasquez      2020-02-26  4320  				}
e4e3a2ce9556cc Quinn Tran          2017-08-23  4321  
49db4d4e02aabc Quinn Tran          2020-09-03  4322  				if (IS_ZIO_THRESHOLD_CAPABLE(ha))
8b4673ba3a1b99 Quinn Tran          2018-09-04  4323  					qla27xx_set_zio_threshold(vha,
8b4673ba3a1b99 Quinn Tran          2018-09-04  4324  					    ha->last_zio_threshold);
8b4673ba3a1b99 Quinn Tran          2018-09-04  4325  
b0d6cabd355ae9 Himanshu Madhani    2015-12-17  4326  				rval = qla2x00_set_exlogins_buffer(vha);
b0d6cabd355ae9 Himanshu Madhani    2015-12-17  4327  				if (rval != QLA_SUCCESS)
b0d6cabd355ae9 Himanshu Madhani    2015-12-17  4328  					goto failed;
b0d6cabd355ae9 Himanshu Madhani    2015-12-17  4329  
2f56a7f1b5d8cf Himanshu Madhani    2015-12-17  4330  				rval = qla2x00_set_exchoffld_buffer(vha);
2f56a7f1b5d8cf Himanshu Madhani    2015-12-17  4331  				if (rval != QLA_SUCCESS)
2f56a7f1b5d8cf Himanshu Madhani    2015-12-17  4332  					goto failed;
2f56a7f1b5d8cf Himanshu Madhani    2015-12-17  4333  
a9083016a5314b Giridhar Malavali   2010-04-12  4334  enable_82xx_npiv:
dda772e8e3b983 Andrew Vasquez      2009-03-24  4335  				fw_major_version = ha->fw_major_version;
7ec0effd30bb4b Atul Deshmukh       2013-08-27  4336  				if (IS_P3P_TYPE(ha))
3173167f015b77 Giridhar Malavali   2011-08-16  4337  					qla82xx_check_md_needed(vha);
6246b8a1d26c7c Giridhar Malavali   2012-02-09  4338  				else
6246b8a1d26c7c Giridhar Malavali   2012-02-09  4339  					rval = qla2x00_get_fw_version(vha);
ca9e9c3eb118d0 Andrew Vasquez      2009-06-03  4340  				if (rval != QLA_SUCCESS)
ca9e9c3eb118d0 Andrew Vasquez      2009-06-03  4341  					goto failed;
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  4342  				ha->flags.npiv_supported = 0;
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  4343  				if (IS_QLA2XXX_MIDTYPE(ha) &&
4d0ea24769c815 Seokmann Ju         2007-09-20  4344  					 (ha->fw_attributes & BIT_2)) {
2c3dfe3f6ad8da Seokmann Ju         2007-07-05  4345  					ha->flags.npiv_supported = 1;
4d0ea24769c815 Seokmann Ju         2007-09-20  4346  					if ((!ha->max_npiv_vports) ||
4d0ea24769c815 Seokmann Ju         2007-09-20  4347  					    ((ha->max_npiv_vports + 1) %
eb66dc60be5a72 Andrew Vasquez      2007-11-12  4348  					    MIN_MULTI_ID_FABRIC))
4d0ea24769c815 Seokmann Ju         2007-09-20  4349  						ha->max_npiv_vports =
eb66dc60be5a72 Andrew Vasquez      2007-11-12  4350  						    MIN_MULTI_ID_FABRIC - 1;
4d0ea24769c815 Seokmann Ju         2007-09-20  4351  				}
03e8c680d9b3b6 Quinn Tran          2015-12-17  4352  				qla2x00_get_resource_cnts(vha);
89c72f4245a851 Quinn Tran          2020-09-03  4353  				qla_init_iocb_limit(vha);
d743de66754a66 Andrew Vasquez      2009-03-24  4354  
8d93f5502221cc Chad Dupuis         2013-01-30  4355  				/*
8d93f5502221cc Chad Dupuis         2013-01-30  4356  				 * Allocate the array of outstanding commands
8d93f5502221cc Chad Dupuis         2013-01-30  4357  				 * now that we know the firmware resources.
8d93f5502221cc Chad Dupuis         2013-01-30  4358  				 */
8d93f5502221cc Chad Dupuis         2013-01-30  4359  				rval = qla2x00_alloc_outstanding_cmds(ha,
8d93f5502221cc Chad Dupuis         2013-01-30  4360  				    vha->req);
8d93f5502221cc Chad Dupuis         2013-01-30  4361  				if (rval != QLA_SUCCESS)
8d93f5502221cc Chad Dupuis         2013-01-30  4362  					goto failed;
8d93f5502221cc Chad Dupuis         2013-01-30  4363  
ad0a0b01f088f6 Quinn Tran          2017-12-28  4364  				if (ql2xallocfwdump && !(IS_P3P_TYPE(ha)))
e315cd28b9ef0d Anirban Chakraborty 2008-11-06  4365  					qla2x00_alloc_fw_dump(vha);
ad0a0b01f088f6 Quinn Tran          2017-12-28  4366  
cb06b8fc6fe492 Quinn Tran          2024-02-23  4367  				qla_enable_fce_trace(vha);
cb06b8fc6fe492 Quinn Tran          2024-02-23  4368  				qla_enable_eft_trace(vha);
3b6e5b9d5f4001 Chad Dupuis         2013-10-30  4369  			} else {
3b6e5b9d5f4001 Chad Dupuis         2013-10-30  4370  				goto failed;
^1da177e4c3f41 Linus Torvalds      2005-04-16  4371  			}
^1da177e4c3f41 Linus Torvalds      2005-04-16  4372  		} else {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4373  			ql_log(ql_log_fatal, vha, 0x00cd,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4374  			    "ISP Firmware failed checksum.\n");
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4375  			goto failed;
^1da177e4c3f41 Linus Torvalds      2005-04-16  4376  		}
d83a80ee57f0cb Joe Carnuccio       2020-02-12  4377  
d83a80ee57f0cb Joe Carnuccio       2020-02-12  4378  		/* Enable PUREX PASSTHRU */
44d018577f1793 Quinn Tran          2021-06-23  4379  		if (ql2xrdpenable || ha->flags.scm_supported_f ||
44d018577f1793 Quinn Tran          2021-06-23  4380  		    ha->flags.edif_enabled)
d83a80ee57f0cb Joe Carnuccio       2020-02-12  4381  			qla25xx_set_els_cmds_supported(vha);
c74d88a46865a9 Andrew Vasquez      2012-08-22  4382  	} else
c74d88a46865a9 Andrew Vasquez      2012-08-22  4383  		goto failed;
^1da177e4c3f41 Linus Torvalds      2005-04-16  4384  
3db0652ef986f3 Andrew Vasquez      2008-01-31  4385  	if (!IS_FWI2_CAPABLE(ha) && !IS_QLA2100(ha) && !IS_QLA2200(ha)) {
3db0652ef986f3 Andrew Vasquez      2008-01-31  4386  		/* Enable proper parity. */
3db0652ef986f3 Andrew Vasquez      2008-01-31  4387  		spin_lock_irqsave(&ha->hardware_lock, flags);
3db0652ef986f3 Andrew Vasquez      2008-01-31  4388  		if (IS_QLA2300(ha))
3db0652ef986f3 Andrew Vasquez      2008-01-31  4389  			/* SRAM parity */
04474d3a1c9681 Bart Van Assche     2020-05-18  4390  			wrt_reg_word(&reg->hccr, HCCR_ENABLE_PARITY + 0x1);
3db0652ef986f3 Andrew Vasquez      2008-01-31  4391  		else
3db0652ef986f3 Andrew Vasquez      2008-01-31  4392  			/* SRAM, Instruction RAM and GP RAM parity */
04474d3a1c9681 Bart Van Assche     2020-05-18  4393  			wrt_reg_word(&reg->hccr, HCCR_ENABLE_PARITY + 0x7);
04474d3a1c9681 Bart Van Assche     2020-05-18  4394  		rd_reg_word(&reg->hccr);
3db0652ef986f3 Andrew Vasquez      2008-01-31  4395  		spin_unlock_irqrestore(&ha->hardware_lock, flags);
3db0652ef986f3 Andrew Vasquez      2008-01-31  4396  	}
3db0652ef986f3 Andrew Vasquez      2008-01-31  4397  
ecc89f25e225fa Joe Carnuccio       2019-03-12  4398  	if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
f3982d89317797 Chad Dupuis         2014-09-25  4399  		ha->flags.fac_supported = 1;
f3982d89317797 Chad Dupuis         2014-09-25  4400  	else if (rval == QLA_SUCCESS && IS_FAC_REQUIRED(ha)) {
1d2874de809a14 Joe Carnuccio       2009-03-24  4401  		uint32_t size;
1d2874de809a14 Joe Carnuccio       2009-03-24  4402  
1d2874de809a14 Joe Carnuccio       2009-03-24  4403  		rval = qla81xx_fac_get_sector_size(vha, &size);
1d2874de809a14 Joe Carnuccio       2009-03-24  4404  		if (rval == QLA_SUCCESS) {
1d2874de809a14 Joe Carnuccio       2009-03-24  4405  			ha->flags.fac_supported = 1;
1d2874de809a14 Joe Carnuccio       2009-03-24  4406  			ha->fdt_block_size = size << 2;
1d2874de809a14 Joe Carnuccio       2009-03-24  4407  		} else {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4408  			ql_log(ql_log_warn, vha, 0x00ce,
1d2874de809a14 Joe Carnuccio       2009-03-24  4409  			    "Unsupported FAC firmware (%d.%02d.%02d).\n",
1d2874de809a14 Joe Carnuccio       2009-03-24  4410  			    ha->fw_major_version, ha->fw_minor_version,
1d2874de809a14 Joe Carnuccio       2009-03-24  4411  			    ha->fw_subminor_version);
1ca60e3b0dcbf1 Joe Carnuccio       2014-02-26  4412  
0d6a536cb1fcab Joe Carnuccio       2022-01-09  4413  			if (IS_QLA83XX(ha)) {
6246b8a1d26c7c Giridhar Malavali   2012-02-09  4414  				ha->flags.fac_supported = 0;
6246b8a1d26c7c Giridhar Malavali   2012-02-09  4415  				rval = QLA_SUCCESS;
6246b8a1d26c7c Giridhar Malavali   2012-02-09  4416  			}
1d2874de809a14 Joe Carnuccio       2009-03-24  4417  		}
1d2874de809a14 Joe Carnuccio       2009-03-24  4418  	}
ca9e9c3eb118d0 Andrew Vasquez      2009-06-03  4419  failed:
^1da177e4c3f41 Linus Torvalds      2005-04-16  4420  	if (rval) {
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4421  		ql_log(ql_log_fatal, vha, 0x00cf,
7c3df1320e5e87 Saurav Kashyap      2011-07-14  4422  		    "Setup chip ****FAILED****.\n");
^1da177e4c3f41 Linus Torvalds      2005-04-16  4423  	}
^1da177e4c3f41 Linus Torvalds      2005-04-16  4424  
^1da177e4c3f41 Linus Torvalds      2005-04-16  4425  	return (rval);
^1da177e4c3f41 Linus Torvalds      2005-04-16  4426  }
^1da177e4c3f41 Linus Torvalds      2005-04-16  4427  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
