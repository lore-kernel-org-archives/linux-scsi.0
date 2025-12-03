Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A1E2B9A4
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 03:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764733575; cv=none; b=jm/wQscZmFwCd8Ys8NbGmgb4pYQaM+eLLVh71Xjxw9Mxr38IFXnd/bAjLnCJ5McrdG31Oprt6m7C+1mRx5EgiV/6YTBQDir5ezMnnmn0bbYurFxXS+jR0nj0i4TRdckt6BDY8GDGJN+1axvdxEWL09YcWkd+Q7BN//zifLlf5VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764733575; c=relaxed/simple;
	bh=Zw01VMIJSuTBcOHvzK3T3px//j+RS/aHvaVxL3azliA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KHMl8KFOnGQKZ7sXlJIkcefLadK2s19HUSG0aOaP5xKjJeYIm+rHePIj/hOp+nV1enolmeGo2S7/mNmkzT2NaykdPvk6u9ElJT/s+QohlKZPFjdnksKbsaxuR5on+LUL+Xie6ZnRHF+ek2rSN5GwCLgYI1fTAyxuC3d4pfn2oX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQKqXfgE; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQKqXfgE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764733573; x=1796269573;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zw01VMIJSuTBcOHvzK3T3px//j+RS/aHvaVxL3azliA=;
  b=cQKqXfgEimW7OK2rEko+HzGh/Pxe+u3E3yjopiWntTEVm75qL2Wx+7LI
   maqFfVpSsYDQQU40YoRv9Jtq8ro/V7bkIgWtuUhPWis/J3S/HldueQ+L+
   ZVnQO0uEVbfeZQJfCJqqwP6V9mGvNLWmTOTRsl99dYheE08f7JX8P2TYH
   r/4Tdnl/7lY5DpenYOqsRHuYfyX4f4t59aFDzb3YefWj02LFZJQh/cP7Y
   2WoLSPUVA55BTRC/BzlFjw20aPnPZ+Eo+ncRX/CWfpE2lb41jssdlQNBv
   qzWxEIZEzOh8n4DIonXxGD1c3JH1BZ5XKrNnCCy3jphfQqoe9J6K+o9aJ
   g==;
X-CSE-ConnectionGUID: V7eQurA4SvueJo/5eQYy/A==
X-CSE-MsgGUID: /D25ZIVvQLOLGyqBKgIDBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66884909"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="66884909"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 19:46:13 -0800
X-CSE-ConnectionGUID: J8f8GMFXTxCq8y5/TGHTjA==
X-CSE-MsgGUID: q+fo0rYBSdieFER7JNu8cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="193843758"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 02 Dec 2025 19:46:11 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQdoe-00000000AWf-0PZ3;
	Wed, 03 Dec 2025 03:46:08 +0000
Date: Wed, 3 Dec 2025 11:45:26 +0800
From: kernel test robot <lkp@intel.com>
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
	agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
	jmeneghi@redhat.com
Subject: Re: [PATCH 03/12] qla2xxx: Add load flash firmware mailbox support
 for 28xxx
Message-ID: <202512031128.XsuvzBv1-lkp@intel.com>
References: <20251202054444.1711778-4-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202054444.1711778-4-njavali@marvell.com>

Hi Nilesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on e6965188f84a7883e6a0d3448e86b0cf29b24dfc]

url:    https://github.com/intel-lab-lkp/linux/commits/Nilesh-Javali/qla2xxx-Add-Speed-in-SFP-print-information/20251202-140943
base:   e6965188f84a7883e6a0d3448e86b0cf29b24dfc
patch link:    https://lore.kernel.org/r/20251202054444.1711778-4-njavali%40marvell.com
patch subject: [PATCH 03/12] qla2xxx: Add load flash firmware mailbox support for 28xxx
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251203/202512031128.XsuvzBv1-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512031128.XsuvzBv1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512031128.XsuvzBv1-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/scsi/qla2xxx/qla_init.c:8490:28: warning: variable 'fragment' set but not used [-Wunused-but-set-variable]
    8490 |         uint templates, segments, fragment;
         |                                   ^
   In file included from drivers/scsi/qla2xxx/qla_init.c:6:
   In file included from drivers/scsi/qla2xxx/qla_def.h:12:
   In file included from include/linux/module.h:13:
   In file included from include/linux/stat.h:19:
   In file included from include/linux/time.h:60:
   In file included from include/linux/time32.h:13:
   In file included from include/linux/timex.h:67:
   In file included from arch/x86/include/asm/timex.h:6:
   In file included from arch/x86/include/asm/tsc.h:11:
   In file included from arch/x86/include/asm/msr.h:11:
   In file included from arch/x86/include/asm/cpumask.h:5:
   In file included from include/linux/cpumask.h:12:
   In file included from include/linux/bitmap.h:13:
   In file included from include/linux/string.h:382:
   include/linux/fortify-string.h:580:4: warning: call to '__read_overflow2_field' declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
     580 |                         __read_overflow2_field(q_size_field, size);
         |                         ^
   2 warnings generated.


vim +/fragment +8490 drivers/scsi/qla2xxx/qla_init.c

  8482	
  8483	static int
  8484	qla28xx_load_fw_template(scsi_qla_host_t *vha, uint32_t faddr)
  8485	{
  8486		struct qla_hw_data *ha = vha->hw;
  8487		struct fwdt *fwdt = ha->fwdt;
  8488		struct req_que *req = ha->req_q_map[0];
  8489		uint32_t risc_size, risc_attr = 0;
> 8490		uint templates, segments, fragment;
  8491		uint32_t *dcode;
  8492		ulong dlen;
  8493		int rval;
  8494		uint j;
  8495	
  8496		dcode = (uint32_t *)req->ring;
  8497		segments = FA_RISC_CODE_SEGMENTS;
  8498	
  8499		for (j = 0; j < segments; j++) {
  8500			rval = qla24xx_read_flash_data(vha, dcode, faddr, 10);
  8501			if (rval) {
  8502				ql_log(ql_log_fatal, vha, 0x01a1,
  8503				       "-> Failed to read flash addr + size .\n");
  8504				return QLA_FUNCTION_FAILED;
  8505			}
  8506	
  8507			risc_size = be32_to_cpu((__force __be32)dcode[3]);
  8508	
  8509			if (risc_attr == 0)
  8510				risc_attr = be32_to_cpu((__force __be32)dcode[9]);
  8511	
  8512			dlen = ha->fw_transfer_size >> 2;
  8513			for (fragment = 0; risc_size; fragment++) {
  8514				if (dlen > risc_size)
  8515					dlen = risc_size;
  8516	
  8517				faddr += dlen;
  8518				risc_size -= dlen;
  8519			}
  8520		}
  8521	
  8522		templates = (risc_attr & BIT_9) ? 2 : 1;
  8523	
  8524		ql_dbg(ql_dbg_init, vha, 0x01a1, "-> templates = %u\n", templates);
  8525	
  8526		for (j = 0; j < templates; j++, fwdt++) {
  8527			vfree(fwdt->template);
  8528			fwdt->template = NULL;
  8529			fwdt->length = 0;
  8530	
  8531			dcode = (uint32_t *)req->ring;
  8532	
  8533			rval = qla24xx_read_flash_data(vha, dcode, faddr, 7);
  8534			if (rval) {
  8535				ql_log(ql_log_fatal, vha, 0x01a2,
  8536				    "-> Unable to read template size.\n");
  8537				goto failed;
  8538			}
  8539	
  8540			risc_size = be32_to_cpu((__force __be32)dcode[2]);
  8541			ql_dbg(ql_dbg_init, vha, 0x01a3,
  8542			    "-> fwdt%u template array at %#x (%#x dwords)\n",
  8543			    j, faddr, risc_size);
  8544			if (!risc_size || !~risc_size) {
  8545				ql_dbg(ql_dbg_init, vha, 0x01a4,
  8546				    "-> fwdt%u failed to read array\n", j);
  8547				goto failed;
  8548			}
  8549	
  8550			/* skip header and ignore checksum */
  8551			faddr += 7;
  8552			risc_size -= 8;
  8553	
  8554			ql_dbg(ql_dbg_init, vha, 0x01a5,
  8555			    "-> fwdt%u template allocate template %#x words...\n",
  8556			    j, risc_size);
  8557			fwdt->template = vmalloc(risc_size * sizeof(*dcode));
  8558			if (!fwdt->template) {
  8559				ql_log(ql_log_warn, vha, 0x01a6,
  8560				    "-> fwdt%u failed allocate template.\n", j);
  8561				goto failed;
  8562			}
  8563	
  8564			dcode = fwdt->template;
  8565			rval = qla24xx_read_flash_data(vha, dcode, faddr, risc_size);
  8566	
  8567			if (rval || !qla27xx_fwdt_template_valid(dcode)) {
  8568				ql_log(ql_log_warn, vha, 0x01a7,
  8569				    "-> fwdt%u failed template validate (rval %x)\n",
  8570				    j, rval);
  8571				goto failed;
  8572			}
  8573	
  8574			dlen = qla27xx_fwdt_template_size(dcode);
  8575			ql_dbg(ql_dbg_init, vha, 0x01a7,
  8576			    "-> fwdt%u template size %#lx bytes (%#lx words)\n",
  8577			    j, dlen, dlen / sizeof(*dcode));
  8578			if (dlen > risc_size * sizeof(*dcode)) {
  8579				ql_log(ql_log_warn, vha, 0x01a8,
  8580				    "-> fwdt%u template exceeds array (%-lu bytes)\n",
  8581				    j, dlen - risc_size * sizeof(*dcode));
  8582				goto failed;
  8583			}
  8584	
  8585			fwdt->length = dlen;
  8586			ql_dbg(ql_dbg_init, vha, 0x01a9,
  8587			    "-> fwdt%u loaded template ok\n", j);
  8588	
  8589			faddr += risc_size + 1;
  8590		}
  8591	
  8592		return QLA_SUCCESS;
  8593	
  8594	failed:
  8595		vfree(fwdt->template);
  8596		fwdt->template = NULL;
  8597		fwdt->length = 0;
  8598	
  8599		return QLA_SUCCESS;
  8600	}
  8601	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
