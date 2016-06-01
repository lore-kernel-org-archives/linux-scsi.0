From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [target:queue 6/14] drivers/target/target_core_sbc.c:384:19:
 error: assignment from incompatible pointer type
Date: Wed, 01 Jun 2016 13:53:29 -0700
Message-ID: <1464814409.10899.1.camel@haakon3.risingtidesystems.com>
References: <201606011755.TDYVk6T3%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42826 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbcFAUxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 16:53:32 -0400
In-Reply-To: <201606011755.TDYVk6T3%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2016-06-01 at 17:41 +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git queue
> head:   4d13930836b3a61c70603178d8a3c60e633e40f1
> commit: 39a54101d1cc581dbf494b0964537e795466e0d4 [6/14] target: Convert se_cmd->execute_cmd to target_iostate
> config: sh-allyesconfig (attached as .config)
> compiler: sh4-linux-gnu-gcc (Debian 5.3.1-8) 5.3.1 20160205
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 39a54101d1cc581dbf494b0964537e795466e0d4
>         # save the attached .config to linux build tree
>         make.cross ARCH=sh 
> 
> Note: the target/queue HEAD 4d13930836b3a61c70603178d8a3c60e633e40f1 builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/target/target_core_sbc.c: In function 'sbc_setup_write_same':
> >> drivers/target/target_core_sbc.c:384:19: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
>      cmd->execute_cmd = ops->execute_write_same;
>                       ^
>    drivers/target/target_core_sbc.c: In function 'sbc_parse_cdb':
>    drivers/target/target_core_sbc.c:1065:21: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
>        cmd->execute_cmd = ops->execute_sync_cache;
>                         ^
>    cc1: some warnings being treated as errors
> 
> vim +384 drivers/target/target_core_sbc.c
> 
> cd063bef Nicholas Bellinger 2012-11-07  378  		return TCM_UNSUPPORTED_SCSI_OPCODE;
> d6e0175c Christoph Hellwig  2012-05-20  379  
> afd73f1b Nicholas Bellinger 2015-02-14  380  	ret = sbc_check_prot(dev, cmd, &cmd->t_task_cdb[0], sectors, true);
> afd73f1b Nicholas Bellinger 2015-02-14  381  	if (ret)
> afd73f1b Nicholas Bellinger 2015-02-14  382  		return ret;
> afd73f1b Nicholas Bellinger 2015-02-14  383  
> cd063bef Nicholas Bellinger 2012-11-07 @384  	cmd->execute_cmd = ops->execute_write_same;
> d6e0175c Christoph Hellwig  2012-05-20  385  	return 0;
> d6e0175c Christoph Hellwig  2012-05-20  386  }
> d6e0175c Christoph Hellwig  2012-05-20  387  
> 
> :::::: The code at line 384 was first introduced by commit
> :::::: cd063bef414c51d79b9c6ea7a8ef8f9d319529bc target/sbc: Seperate WRITE_SAME based on UNMAP flag in sbc_ops
> 
> :::::: TO: Nicholas Bellinger <nab@linux-iscsi.org>
> :::::: CC: Nicholas Bellinger <nab@linux-iscsi.org>
> 

Fixed.

Thanks Fengguang.

