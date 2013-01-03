From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [scsi:for-next 11/19] drivers/scsi/ipr.c:8700:16: warning: array
 subscript is above array bounds
Date: Thu, 3 Jan 2013 18:16:36 +0800
Message-ID: <20130103101636.GA13994@localhost>
References: <50cf0007.C4w69iMWfvH9T/3N%fengguang.wu@intel.com>
 <20130102190547.Horde.PyZzqJir309Q5Mtbh-Z1Y7A@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4295 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073Ab3ACKQu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2013 05:16:50 -0500
Content-Disposition: inline
In-Reply-To: <20130102190547.Horde.PyZzqJir309Q5Mtbh-Z1Y7A@imap.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>

Hi Wendy,

On Wed, Jan 02, 2013 at 07:05:47PM -0500, wenxiong@linux.vnet.ibm.com wrote:
> Hi Fengguang,
> 
> We built 32bit kernel for "current jejb for-next tree" on x86
> platform by using your config file. Seems We couldn't reproduce the
> error in our environment. What options you use to make 32bit kernel?
> We used:
> 
> make ARCH=i386 V=1 -Wall.
> 
> Also can you reproduce this with current jejb for-next tree in your
> environment?

Yes I can reproduce the warning at commit
7af0de314b738e26bf4d49a6f30d00ce56343107 as well as
7ff768a5feade4fa51f038d97b7eb9f72152b7c1.

I'm running gcc 4.6.3 and 4.7.2, the reproduce command line is:

        make ARCH=i386 drivers/scsi/ipr.o

Thanks,
Fengguang

> Quoting kbuild test robot <fengguang.wu@intel.com>:
> 
> >tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> >head:   7ff768a5feade4fa51f038d97b7eb9f72152b7c1
> >commit: 7af0de314b738e26bf4d49a6f30d00ce56343107 [11/19] [SCSI]
> >ipr: Add support for MSI-X and distributed completion
> >config: i386-randconfig-x243 (attached as .config)
> >
> >All warnings:
> >
> >drivers/scsi/ipr.c: In function 'ipr_probe':
> >drivers/scsi/ipr.c:8700:16: warning: array subscript is above
> >array bounds [-Warray-bounds]
> >
> >vim +8700 drivers/scsi/ipr.c
> >
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8684
> >				ioa_cfg->hrrq[i].min_cmd_id =
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8685
> >					IPR_NUM_INTERNAL_CMD_BLKS +
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8686  					(i -
> >1) * entries_each_hrrq;
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8687
> >				ioa_cfg->hrrq[i].max_cmd_id =
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8688
> >					(IPR_NUM_INTERNAL_CMD_BLKS +
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8689  					i *
> >entries_each_hrrq - 1);
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8690  			}
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8691  		} else {
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8692
> >			entries_each_hrrq = IPR_NUM_CMD_BLKS;
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8693
> >			ioa_cfg->hrrq[i].min_cmd_id = 0;
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8694
> >			ioa_cfg->hrrq[i].max_cmd_id = (entries_each_hrrq - 1);
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8695  		}
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8696
> >		ioa_cfg->hrrq[i].size = entries_each_hrrq;
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8697  	}
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8698
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8699  	i =
> >IPR_NUM_CMD_BLKS -
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03 @8700
> >		ioa_cfg->hrrq[ioa_cfg->hrrq_num - 1].max_cmd_id - 1;
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8701  	if (i > 0) {
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8702
> >		ioa_cfg->hrrq[ioa_cfg->hrrq_num - 1].size += i;
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8703
> >		ioa_cfg->hrrq[ioa_cfg->hrrq_num - 1].max_cmd_id += i;
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8704  	}
> >7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8705
> >^1da177e Linus Torvalds              2005-04-16  8706  	for (i =
> >0; i < IPR_NUM_CMD_BLKS; i++) {
> >203fa3fe Kleber Sacilotto de Souza   2012-08-22  8707  		ipr_cmd =
> >pci_pool_alloc(ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
> >^1da177e Linus Torvalds              2005-04-16  8708
> >
> >---
> >0-DAY kernel build testing backend         Open Source Technology Center
> >Fengguang Wu, Yuanhan Liu                              Intel Corporation
> 
> 
