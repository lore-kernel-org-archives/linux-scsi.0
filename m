From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] scsi: kconfig: When possible, compile drivers with
 COMPILE_TEST
Date: Thu, 15 Oct 2015 09:11:13 +0800
Message-ID: <201510150911.LUZUzevd%fengguang.wu@intel.com>
References: <1444857220-26595-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3842 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbbJOBMX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Oct 2015 21:12:23 -0400
Content-Disposition: inline
In-Reply-To: <1444857220-26595-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, linux-scsi@vger.kernel.org, Luis de Bethencourt <luisbg@osg.samsung.com>

Hi Luis,

[auto build test WARNING on scsi/for-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Luis-de-Bethencourt/scsi-kconfig-When-possible-compile-drivers-with-COMPILE_TEST/20151015-051558
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/scsi/NCR5380.c:1751:9: sparse: context imbalance in 'NCR5380_transfer_dma' - unexpected unlock

vim +/NCR5380_transfer_dma +1751 drivers/scsi/NCR5380.c

^1da177e Linus Torvalds 2005-04-16  1735  	NCR5380_setup(instance);
^1da177e Linus Torvalds 2005-04-16  1736  
^1da177e Linus Torvalds 2005-04-16  1737  	if ((tmp = (NCR5380_read(STATUS_REG) & PHASE_MASK)) != p) {
^1da177e Linus Torvalds 2005-04-16  1738  		*phase = tmp;
^1da177e Linus Torvalds 2005-04-16  1739  		return -1;
^1da177e Linus Torvalds 2005-04-16  1740  	}
^1da177e Linus Torvalds 2005-04-16  1741  #if defined(REAL_DMA) || defined(REAL_DMA_POLL)
^1da177e Linus Torvalds 2005-04-16  1742  #ifdef READ_OVERRUNS
^1da177e Linus Torvalds 2005-04-16  1743  	if (p & SR_IO) {
^1da177e Linus Torvalds 2005-04-16  1744  		c -= 2;
^1da177e Linus Torvalds 2005-04-16  1745  	}
^1da177e Linus Torvalds 2005-04-16  1746  #endif
52a6a1cb Finn Thain     2014-03-18  1747  	dprintk(NDEBUG_DMA, "scsi%d : initializing DMA channel %d for %s, %d bytes %s %0x\n", instance->host_no, instance->dma_channel, (p & SR_IO) ? "reading" : "writing", c, (p & SR_IO) ? "to" : "from", (unsigned) d);
^1da177e Linus Torvalds 2005-04-16  1748  	hostdata->dma_len = (p & SR_IO) ? NCR5380_dma_read_setup(instance, d, c) : NCR5380_dma_write_setup(instance, d, c);
^1da177e Linus Torvalds 2005-04-16  1749  #endif
^1da177e Linus Torvalds 2005-04-16  1750  
^1da177e Linus Torvalds 2005-04-16 @1751  	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
^1da177e Linus Torvalds 2005-04-16  1752  
^1da177e Linus Torvalds 2005-04-16  1753  #ifdef REAL_DMA
^1da177e Linus Torvalds 2005-04-16  1754  	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
^1da177e Linus Torvalds 2005-04-16  1755  #elif defined(REAL_DMA_POLL)
^1da177e Linus Torvalds 2005-04-16  1756  	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE);
^1da177e Linus Torvalds 2005-04-16  1757  #else
^1da177e Linus Torvalds 2005-04-16  1758  	/*
^1da177e Linus Torvalds 2005-04-16  1759  	 * Note : on my sample board, watch-dog timeouts occurred when interrupts

:::::: The code at line 1751 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
