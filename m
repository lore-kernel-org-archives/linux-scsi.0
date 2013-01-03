From: wenxiong@linux.vnet.ibm.com
Subject: Re: [scsi:for-next 11/19] drivers/scsi/ipr.c:8700:16: warning:
 array subscript is above array bounds
Date: Wed, 02 Jan 2013 19:05:47 -0500
Message-ID: <20130102190547.Horde.PyZzqJir309Q5Mtbh-Z1Y7A@imap.linux.ibm.com>
References: <50cf0007.C4w69iMWfvH9T/3N%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:34465 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab3ACAKY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2013 19:10:24 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Wed, 2 Jan 2013 17:10:24 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 658903E4003D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Jan 2013 17:06:29 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r03063sm164828
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 17:06:18 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r0305m6n022545
	for <linux-scsi@vger.kernel.org>; Wed, 2 Jan 2013 17:05:48 -0700
In-Reply-To: <50cf0007.C4w69iMWfvH9T/3N%fengguang.wu@intel.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>

Hi Fengguang,

We built 32bit kernel for "current jejb for-next tree" on x86 platform  
by using your config file. Seems We couldn't reproduce the error in  
our environment. What options you use to make 32bit kernel? We used:

make ARCH=i386 V=1 -Wall.

Also can you reproduce this with current jejb for-next tree in your  
environment?

Thanks,
Wendy

Quoting kbuild test robot <fengguang.wu@intel.com>:

> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> head:   7ff768a5feade4fa51f038d97b7eb9f72152b7c1
> commit: 7af0de314b738e26bf4d49a6f30d00ce56343107 [11/19] [SCSI] ipr:  
> Add support for MSI-X and distributed completion
> config: i386-randconfig-x243 (attached as .config)
>
> All warnings:
>
> drivers/scsi/ipr.c: In function 'ipr_probe':
> drivers/scsi/ipr.c:8700:16: warning: array subscript is above array  
> bounds [-Warray-bounds]
>
> vim +8700 drivers/scsi/ipr.c
>
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8684   
> 				ioa_cfg->hrrq[i].min_cmd_id =
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8685   
> 					IPR_NUM_INTERNAL_CMD_BLKS +
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8686  					(i - 1)  
> * entries_each_hrrq;
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8687   
> 				ioa_cfg->hrrq[i].max_cmd_id =
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8688   
> 					(IPR_NUM_INTERNAL_CMD_BLKS +
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8689  					i *  
> entries_each_hrrq - 1);
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8690  			}
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8691  		} else {
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8692   
> 			entries_each_hrrq = IPR_NUM_CMD_BLKS;
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8693   
> 			ioa_cfg->hrrq[i].min_cmd_id = 0;
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8694   
> 			ioa_cfg->hrrq[i].max_cmd_id = (entries_each_hrrq - 1);
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8695  		}
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8696   
> 		ioa_cfg->hrrq[i].size = entries_each_hrrq;
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8697  	}
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8698
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8699  	i =  
> IPR_NUM_CMD_BLKS -
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03 @8700   
> 		ioa_cfg->hrrq[ioa_cfg->hrrq_num - 1].max_cmd_id - 1;
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8701  	if (i > 0) {
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8702   
> 		ioa_cfg->hrrq[ioa_cfg->hrrq_num - 1].size += i;
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8703   
> 		ioa_cfg->hrrq[ioa_cfg->hrrq_num - 1].max_cmd_id += i;
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8704  	}
> 7af0de31 wenxiong@linux.vnet.ibm.com 2012-12-03  8705
> ^1da177e Linus Torvalds              2005-04-16  8706  	for (i = 0;  
> i < IPR_NUM_CMD_BLKS; i++) {
> 203fa3fe Kleber Sacilotto de Souza   2012-08-22  8707  		ipr_cmd =  
> pci_pool_alloc(ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
> ^1da177e Linus Torvalds              2005-04-16  8708
>
> ---
> 0-DAY kernel build testing backend         Open Source Technology Center
> Fengguang Wu, Yuanhan Liu                              Intel Corporation



