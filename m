Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B117C299A81
	for <linux-scsi@vger.kernel.org>; Mon, 22 Dec 2025 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766408174; cv=none; b=MP/SnwLATqEoJNZEDO2mzK6mo+vLfq1c7Archw1VJTC8t+cBID8qABRfN9J0++tQBxNZ0EsYEHTVDNvQELvA7vpHjW1pVxi1WIBF92cHJfxRUc0yBNSpzDJF6hlYZ7622qRhfaxgjaBkvDkoIYrq4hNP7T78M2iDMlxqF/lbdi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766408174; c=relaxed/simple;
	bh=f9/rHqocjeh8OLWiRaOSMgsTVjDVoD3FEm6rv46rYHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZpARsVa2Xl2xweV8/ou0AaFy213/BhKrte3jOc9hp2XB4fL0sK1XT6G+bTcg/wfgMCxx+wpcjPSlO8M4d9ivKpLBoYV5Wh24jKijrt+bwqLshBmU5/ubfbUrl2TSXftNndJIXjm8N3UtUzoe8pjFrDDHXUed7Yek+VyDr1nBdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RYGElxe5; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RYGElxe5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766408173; x=1797944173;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f9/rHqocjeh8OLWiRaOSMgsTVjDVoD3FEm6rv46rYHo=;
  b=RYGElxe5xDgYZ1yRpsgGeYhf/aIqomLjc6P+zDNXld8khwqTDG2sKZ7n
   gHhgpvDfWWmJdZYbxO+YhApDw3rm3geoxa+rbsQAc6VojOx6ya0G9FdB0
   Lj312IdWMtVxJuJ+VzC3WJ6sI6QqSEWTCv39Ai/RuHZsBYEQeY8cH/twZ
   soupQBq1UfN7n4xJFWpbtNJsns/pCvSg3kI/sE5XMhWmq3Br6F6izhUQ/
   NGaQ6dleoksUZTWvsmY0FDCJ39x6hEoOAKmWOFwX5H7PVkv4KoE/AxStO
   kjhO+lrdZ9cS3wXtrwDK5cFxraKY7Vz4YCrtMVuz6f9kfWoHNElqcavzU
   g==;
X-CSE-ConnectionGUID: yzMHOfv1T9iLW5BXbO+qyw==
X-CSE-MsgGUID: RtkF72ZzQBmjOfqgCX/Xvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="78581747"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="78581747"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 04:56:13 -0800
X-CSE-ConnectionGUID: RvRhnf/JSI2BjYBJfqxONA==
X-CSE-MsgGUID: cTbyVSTRSxiA86NRvXV90w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="200023312"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 22 Dec 2025 04:56:10 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXfRy-000000000af-48Wu;
	Mon, 22 Dec 2025 12:55:55 +0000
Date: Mon, 22 Dec 2025 20:55:12 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>, linux-scsi@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>
Subject: Re: [PATCH 5/5] scsi: qla1280: remove function tracing macros
Message-ID: <202512222058.wa5qcdm2-lkp@intel.com>
References: <20251220051602.28029-5-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220051602.28029-5-enelsonmoore@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on linus/master v6.19-rc2 next-20251219]
[cannot apply to jejb-scsi/for-next powerpc/next powerpc/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Nelson-Moore/scsi-ibmvfc-remove-function-tracing-macros/20251220-131816
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20251220051602.28029-5-enelsonmoore%40gmail.com
patch subject: [PATCH 5/5] scsi: qla1280: remove function tracing macros
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20251222/202512222058.wa5qcdm2-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512222058.wa5qcdm2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512222058.wa5qcdm2-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/scsi/qla1280.c:1688:15: warning: variable 'num' set but not used [-Wunused-but-set-variable]
           int err = 0, num, i;
                        ^
>> drivers/scsi/qla1280.c:3482:1: warning: label at end of compound statement is a C2x extension [-Wc2x-extensions]
   }
   ^
   drivers/scsi/qla1280.c:3604:1: warning: label at end of compound statement is a C2x extension [-Wc2x-extensions]
   }
   ^
   3 warnings generated.


vim +3482 drivers/scsi/qla1280.c

^1da177e4c3f41 Linus Torvalds 2005-04-16  3265  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3266  /****************************************************************************
^1da177e4c3f41 Linus Torvalds 2005-04-16  3267   *  qla1280_isr
^1da177e4c3f41 Linus Torvalds 2005-04-16  3268   *      Calls I/O done on command completion.
^1da177e4c3f41 Linus Torvalds 2005-04-16  3269   *
^1da177e4c3f41 Linus Torvalds 2005-04-16  3270   * Input:
^1da177e4c3f41 Linus Torvalds 2005-04-16  3271   *      ha           = adapter block pointer.
^1da177e4c3f41 Linus Torvalds 2005-04-16  3272   *      done_q       = done queue.
^1da177e4c3f41 Linus Torvalds 2005-04-16  3273   ****************************************************************************/
^1da177e4c3f41 Linus Torvalds 2005-04-16  3274  static void
^1da177e4c3f41 Linus Torvalds 2005-04-16  3275  qla1280_isr(struct scsi_qla_host *ha, struct list_head *done_q)
^1da177e4c3f41 Linus Torvalds 2005-04-16  3276  {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3277  	struct device_reg __iomem *reg = ha->iobase;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3278  	struct response *pkt;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3279  	struct srb *sp = NULL;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3280  	uint16_t mailbox[MAILBOX_REGISTER_COUNT];
^1da177e4c3f41 Linus Torvalds 2005-04-16  3281  	uint16_t *wptr;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3282  	uint32_t index;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3283  	u16 istatus;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3284  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3285  	istatus = RD_REG_WORD(&reg->istatus);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3286  	if (!(istatus & (RISC_INT | PCI_INT)))
^1da177e4c3f41 Linus Torvalds 2005-04-16  3287  		return;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3288  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3289  	/* Save mailbox register 5 */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3290  	mailbox[5] = RD_REG_WORD(&reg->mailbox5);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3291  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3292  	/* Check for mailbox interrupt. */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3293  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3294  	mailbox[0] = RD_REG_WORD_dmasync(&reg->semaphore);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3295  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3296  	if (mailbox[0] & BIT_0) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3297  		/* Get mailbox data. */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3298  		/* dprintk(1, "qla1280_isr: In Get mailbox data \n"); */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3299  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3300  		wptr = &mailbox[0];
^1da177e4c3f41 Linus Torvalds 2005-04-16  3301  		*wptr++ = RD_REG_WORD(&reg->mailbox0);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3302  		*wptr++ = RD_REG_WORD(&reg->mailbox1);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3303  		*wptr = RD_REG_WORD(&reg->mailbox2);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3304  		if (mailbox[0] != MBA_SCSI_COMPLETION) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3305  			wptr++;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3306  			*wptr++ = RD_REG_WORD(&reg->mailbox3);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3307  			*wptr++ = RD_REG_WORD(&reg->mailbox4);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3308  			wptr++;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3309  			*wptr++ = RD_REG_WORD(&reg->mailbox6);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3310  			*wptr = RD_REG_WORD(&reg->mailbox7);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3311  		}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3312  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3313  		/* Release mailbox registers. */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3314  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3315  		WRT_REG_WORD(&reg->semaphore, 0);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3316  		WRT_REG_WORD(&reg->host_cmd, HC_CLR_RISC_INT);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3317  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3318  		dprintk(5, "qla1280_isr: mailbox interrupt mailbox[0] = 0x%x",
^1da177e4c3f41 Linus Torvalds 2005-04-16  3319  			mailbox[0]);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3320  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3321  		/* Handle asynchronous event */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3322  		switch (mailbox[0]) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3323  		case MBA_SCSI_COMPLETION:	/* Response completion */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3324  			dprintk(5, "qla1280_isr: mailbox SCSI response "
^1da177e4c3f41 Linus Torvalds 2005-04-16  3325  				"completion\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3326  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3327  			if (ha->flags.online) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3328  				/* Get outstanding command index. */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3329  				index = mailbox[2] << 16 | mailbox[1];
^1da177e4c3f41 Linus Torvalds 2005-04-16  3330  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3331  				/* Validate handle. */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3332  				if (index < MAX_OUTSTANDING_COMMANDS)
^1da177e4c3f41 Linus Torvalds 2005-04-16  3333  					sp = ha->outstanding_cmds[index];
^1da177e4c3f41 Linus Torvalds 2005-04-16  3334  				else
^1da177e4c3f41 Linus Torvalds 2005-04-16  3335  					sp = NULL;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3336  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3337  				if (sp) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3338  					/* Free outstanding command slot. */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3339  					ha->outstanding_cmds[index] = NULL;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3340  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3341  					/* Save ISP completion status */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3342  					CMD_RESULT(sp->cmd) = 0;
413e6e18b483de Michael Reed   2009-04-08  3343  					CMD_HANDLE(sp->cmd) = COMPLETED_HANDLE;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3344  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3345  					/* Place block on done queue */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3346  					list_add_tail(&sp->list, done_q);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3347  				} else {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3348  					/*
^1da177e4c3f41 Linus Torvalds 2005-04-16  3349  					 * If we get here we have a real problem!
^1da177e4c3f41 Linus Torvalds 2005-04-16  3350  					 */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3351  					printk(KERN_WARNING
fd65e5e93cbd9d Michael Reed   2009-04-08  3352  					       "qla1280: ISP invalid handle\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3353  				}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3354  			}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3355  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3356  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3357  		case MBA_BUS_RESET:	/* SCSI Bus Reset */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3358  			ha->flags.reset_marker = 1;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3359  			index = mailbox[6] & BIT_0;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3360  			ha->bus_settings[index].reset_marker = 1;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3361  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3362  			printk(KERN_DEBUG "qla1280_isr(): index %i "
^1da177e4c3f41 Linus Torvalds 2005-04-16  3363  			       "asynchronous BUS_RESET\n", index);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3364  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3365  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3366  		case MBA_SYSTEM_ERR:	/* System Error */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3367  			printk(KERN_WARNING
^1da177e4c3f41 Linus Torvalds 2005-04-16  3368  			       "qla1280: ISP System Error - mbx1=%xh, mbx2="
^1da177e4c3f41 Linus Torvalds 2005-04-16  3369  			       "%xh, mbx3=%xh\n", mailbox[1], mailbox[2],
^1da177e4c3f41 Linus Torvalds 2005-04-16  3370  			       mailbox[3]);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3371  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3372  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3373  		case MBA_REQ_TRANSFER_ERR:	/* Request Transfer Error */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3374  			printk(KERN_WARNING
^1da177e4c3f41 Linus Torvalds 2005-04-16  3375  			       "qla1280: ISP Request Transfer Error\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3376  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3377  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3378  		case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3379  			printk(KERN_WARNING
^1da177e4c3f41 Linus Torvalds 2005-04-16  3380  			       "qla1280: ISP Response Transfer Error\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3381  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3382  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3383  		case MBA_WAKEUP_THRES:	/* Request Queue Wake-up */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3384  			dprintk(2, "qla1280_isr: asynchronous WAKEUP_THRES\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3385  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3386  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3387  		case MBA_TIMEOUT_RESET:	/* Execution Timeout Reset */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3388  			dprintk(2,
^1da177e4c3f41 Linus Torvalds 2005-04-16  3389  				"qla1280_isr: asynchronous TIMEOUT_RESET\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3390  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3391  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3392  		case MBA_DEVICE_RESET:	/* Bus Device Reset */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3393  			printk(KERN_INFO "qla1280_isr(): asynchronous "
^1da177e4c3f41 Linus Torvalds 2005-04-16  3394  			       "BUS_DEVICE_RESET\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3395  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3396  			ha->flags.reset_marker = 1;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3397  			index = mailbox[6] & BIT_0;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3398  			ha->bus_settings[index].reset_marker = 1;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3399  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3400  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3401  		case MBA_BUS_MODE_CHANGE:
^1da177e4c3f41 Linus Torvalds 2005-04-16  3402  			dprintk(2,
^1da177e4c3f41 Linus Torvalds 2005-04-16  3403  				"qla1280_isr: asynchronous BUS_MODE_CHANGE\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3404  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3405  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3406  		default:
^1da177e4c3f41 Linus Torvalds 2005-04-16  3407  			/* dprintk(1, "qla1280_isr: default case of switch MB \n"); */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3408  			if (mailbox[0] < MBA_ASYNC_EVENT) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3409  				wptr = &mailbox[0];
^1da177e4c3f41 Linus Torvalds 2005-04-16  3410  				memcpy((uint16_t *) ha->mailbox_out, wptr,
^1da177e4c3f41 Linus Torvalds 2005-04-16  3411  				       MAILBOX_REGISTER_COUNT *
^1da177e4c3f41 Linus Torvalds 2005-04-16  3412  				       sizeof(uint16_t));
^1da177e4c3f41 Linus Torvalds 2005-04-16  3413  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3414  				if(ha->mailbox_wait != NULL)
^1da177e4c3f41 Linus Torvalds 2005-04-16  3415  					complete(ha->mailbox_wait);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3416  			}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3417  			break;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3418  		}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3419  	} else {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3420  		WRT_REG_WORD(&reg->host_cmd, HC_CLR_RISC_INT);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3421  	}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3422  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3423  	/*
^1da177e4c3f41 Linus Torvalds 2005-04-16  3424  	 * We will receive interrupts during mailbox testing prior to
^1da177e4c3f41 Linus Torvalds 2005-04-16  3425  	 * the card being marked online, hence the double check.
^1da177e4c3f41 Linus Torvalds 2005-04-16  3426  	 */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3427  	if (!(ha->flags.online && !ha->mailbox_wait)) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3428  		dprintk(2, "qla1280_isr: Response pointer Error\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3429  		goto out;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3430  	}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3431  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3432  	if (mailbox[5] >= RESPONSE_ENTRY_CNT)
^1da177e4c3f41 Linus Torvalds 2005-04-16  3433  		goto out;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3434  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3435  	while (ha->rsp_ring_index != mailbox[5]) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3436  		pkt = ha->response_ring_ptr;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3437  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3438  		dprintk(5, "qla1280_isr: ha->rsp_ring_index = 0x%x, mailbox[5]"
^1da177e4c3f41 Linus Torvalds 2005-04-16  3439  			" = 0x%x\n", ha->rsp_ring_index, mailbox[5]);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3440  		dprintk(5,"qla1280_isr: response packet data\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3441  		qla1280_dump_buffer(5, (char *)pkt, RESPONSE_ENTRY_SIZE);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3442  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3443  		if (pkt->entry_type == STATUS_TYPE) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3444  			if ((le16_to_cpu(pkt->scsi_status) & 0xff)
^1da177e4c3f41 Linus Torvalds 2005-04-16  3445  			    || pkt->comp_status || pkt->entry_status) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3446  				dprintk(2, "qla1280_isr: ha->rsp_ring_index = "
^1da177e4c3f41 Linus Torvalds 2005-04-16  3447  					"0x%x mailbox[5] = 0x%x, comp_status "
^1da177e4c3f41 Linus Torvalds 2005-04-16  3448  					"= 0x%x, scsi_status = 0x%x\n",
^1da177e4c3f41 Linus Torvalds 2005-04-16  3449  					ha->rsp_ring_index, mailbox[5],
^1da177e4c3f41 Linus Torvalds 2005-04-16  3450  					le16_to_cpu(pkt->comp_status),
^1da177e4c3f41 Linus Torvalds 2005-04-16  3451  					le16_to_cpu(pkt->scsi_status));
^1da177e4c3f41 Linus Torvalds 2005-04-16  3452  			}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3453  		} else {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3454  			dprintk(2, "qla1280_isr: ha->rsp_ring_index = "
^1da177e4c3f41 Linus Torvalds 2005-04-16  3455  				"0x%x, mailbox[5] = 0x%x\n",
^1da177e4c3f41 Linus Torvalds 2005-04-16  3456  				ha->rsp_ring_index, mailbox[5]);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3457  			dprintk(2, "qla1280_isr: response packet data\n");
^1da177e4c3f41 Linus Torvalds 2005-04-16  3458  			qla1280_dump_buffer(2, (char *)pkt,
^1da177e4c3f41 Linus Torvalds 2005-04-16  3459  					    RESPONSE_ENTRY_SIZE);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3460  		}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3461  
^1da177e4c3f41 Linus Torvalds 2005-04-16  3462  		if (pkt->entry_type == STATUS_TYPE || pkt->entry_status) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3463  			dprintk(2, "status: Cmd %p, handle %i\n",
^1da177e4c3f41 Linus Torvalds 2005-04-16  3464  				ha->outstanding_cmds[pkt->handle]->cmd,
^1da177e4c3f41 Linus Torvalds 2005-04-16  3465  				pkt->handle);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3466  			if (pkt->entry_type == STATUS_TYPE)
^1da177e4c3f41 Linus Torvalds 2005-04-16  3467  				qla1280_status_entry(ha, pkt, done_q);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3468  			else
^1da177e4c3f41 Linus Torvalds 2005-04-16  3469  				qla1280_error_entry(ha, pkt, done_q);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3470  			/* Adjust ring index. */
^1da177e4c3f41 Linus Torvalds 2005-04-16  3471  			ha->rsp_ring_index++;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3472  			if (ha->rsp_ring_index == RESPONSE_ENTRY_CNT) {
^1da177e4c3f41 Linus Torvalds 2005-04-16  3473  				ha->rsp_ring_index = 0;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3474  				ha->response_ring_ptr =	ha->response_ring;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3475  			} else
^1da177e4c3f41 Linus Torvalds 2005-04-16  3476  				ha->response_ring_ptr++;
^1da177e4c3f41 Linus Torvalds 2005-04-16  3477  			WRT_REG_WORD(&reg->mailbox5, ha->rsp_ring_index);
^1da177e4c3f41 Linus Torvalds 2005-04-16  3478  		}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3479  	}
^1da177e4c3f41 Linus Torvalds 2005-04-16  3480  	
^1da177e4c3f41 Linus Torvalds 2005-04-16  3481   out:
^1da177e4c3f41 Linus Torvalds 2005-04-16 @3482  }
^1da177e4c3f41 Linus Torvalds 2005-04-16  3483  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
