Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10017C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 10:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiGSKIw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 06:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiGSKIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 06:08:51 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F081646E;
        Tue, 19 Jul 2022 03:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658225330; x=1689761330;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QTy3XoJRQtIWmsDOMRAiAy4AuqtsDCsrx7wMgsI5PWQ=;
  b=RAxJitNKW9Y1jeFQx4XbSX9IyIiq5BuxchauvtfLQknWZ9yGz0d4fOcf
   UhgLtswi5rI21rNqdF9NKeLo62aH14n9Tqesrb72gi7YfcJzeXtd/DBi8
   zHblavnITrTPNNppGw+ZUVidyr3e8t4WjGStzJNb/kDVZWT7ec1yJkMME
   j0+9R7ewtSiJVa1Unnx6pZVDPdNEZTmfQ2dbaetJjUDD6XnOqedyAhGlP
   jQGmlTydSeZQBRl3NenU0h/U1vCdyIE4q1EcMIZoWo9QQAblWd8Pj6T4E
   gjO9DKf+aRmrPCKzWcoVO/OMxFlzMKhotCqYU8jOOTAM66ewVvc7PqCIJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="287196741"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="287196741"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 03:08:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="724207084"
Received: from lkp-server02.sh.intel.com (HELO ff137eb26ff1) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 19 Jul 2022 03:08:48 -0700
Received: from kbuild by ff137eb26ff1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1oDk9n-0005We-3d;
        Tue, 19 Jul 2022 10:08:47 +0000
Date:   Tue, 19 Jul 2022 18:08:34 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 1/6] scsi: target: core: add support of RSOC command
Message-ID: <202207191727.tSUku1lU-lkp@intel.com>
References: <20220718120117.4435-2-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718120117.4435-2-d.bogdanov@yadro.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dmitry,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v5.19-rc7 next-20220718]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Bogdanov/add-support-of-RSOC-command/20220718-200622
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: nios2-randconfig-s042-20220718 (https://download.01.org/0day-ci/archive/20220719/202207191727.tSUku1lU-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/dd5367ced3f2a2d631776343184cca65d8cfbed8
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Dmitry-Bogdanov/add-support-of-RSOC-command/20220718-200622
        git checkout dd5367ced3f2a2d631776343184cca65d8cfbed8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=nios2 SHELL=/bin/bash drivers/target/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> drivers/target/target_core_spc.c:1459:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_spc.c:1459:21: sparse:     expected int ret
   drivers/target/target_core_spc.c:1459:21: sparse:     got restricted sense_reason_t
   drivers/target/target_core_spc.c:1466:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_spc.c:1466:21: sparse:     expected int ret
   drivers/target/target_core_spc.c:1466:21: sparse:     got restricted sense_reason_t
   drivers/target/target_core_spc.c:1478:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_spc.c:1478:21: sparse:     expected int ret
   drivers/target/target_core_spc.c:1478:21: sparse:     got restricted sense_reason_t
>> drivers/target/target_core_spc.c:1504:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted sense_reason_t @@     got int ret @@
   drivers/target/target_core_spc.c:1504:16: sparse:     expected restricted sense_reason_t
   drivers/target/target_core_spc.c:1504:16: sparse:     got int ret

vim +1459 drivers/target/target_core_spc.c

  1442	
  1443	static sense_reason_t
  1444	spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
  1445	{
  1446		int descr_num = ARRAY_SIZE(tcm_supported_opcodes);
  1447		struct target_opcode_descriptor *descr = NULL;
  1448		unsigned char *cdb = cmd->t_task_cdb;
  1449		u8 rctd = (cdb[2] >> 7) & 0x1;
  1450		unsigned char *buf = NULL;
  1451		int response_length = 0;
  1452		u8 opts = cdb[2] & 0x3;
  1453		unsigned char *rbuf;
  1454		int ret = 0;
  1455		int i;
  1456	
  1457		rbuf = transport_kmap_data_sg(cmd);
  1458		if (cmd->data_length && !rbuf) {
> 1459			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
  1460			goto out;
  1461		}
  1462	
  1463		if (opts == 0)
  1464			response_length = 4 + (8 + rctd * 12) * descr_num;
  1465		else {
  1466			ret = spc_rsoc_get_descr(cmd, &descr);
  1467			if (ret)
  1468				goto out;
  1469	
  1470			if (descr)
  1471				response_length = 4 + descr->cdb_size + rctd * 12;
  1472			else
  1473				response_length = 2;
  1474		}
  1475	
  1476		buf = kzalloc(response_length, GFP_KERNEL);
  1477		if (!buf) {
  1478			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
  1479			goto out;
  1480		}
  1481		response_length = 0;
  1482	
  1483		if (opts == 0) {
  1484			response_length += 4;
  1485	
  1486			for (i = 0; i < ARRAY_SIZE(tcm_supported_opcodes); i++) {
  1487				descr = tcm_supported_opcodes[i];
  1488				response_length += spc_rsoc_encode_command_descriptor(
  1489						&buf[response_length], rctd, descr);
  1490			}
  1491			put_unaligned_be32(response_length - 3, buf);
  1492		} else {
  1493			response_length = spc_rsoc_encode_one_command_descriptor(
  1494					&buf[response_length], rctd, descr);
  1495		}
  1496	
  1497		memcpy(rbuf, buf, min_t(u32, response_length, cmd->data_length));
  1498	out:
  1499		kfree(buf);
  1500		transport_kunmap_data_sg(cmd);
  1501	
  1502		if (!ret)
  1503			target_complete_cmd_with_length(cmd, SAM_STAT_GOOD, response_length);
> 1504		return ret;
  1505	}
  1506	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
