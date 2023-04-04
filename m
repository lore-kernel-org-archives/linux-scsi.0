Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9847C761A6
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 05:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjDDFag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 01:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbjDDFab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 01:30:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F021FEF;
        Mon,  3 Apr 2023 22:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680586228; x=1712122228;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RdDpxGvgQ2tbcB1Q1fxF2Lua+npmQ3o86qaGHUvpBgc=;
  b=jc3PYuEnvwiBb1scsIhzmgKId0CZJCtf6Yp0WSYaF0Wm5jFehnWIB0yl
   jmHy7CuSPCmYwKZkEe3VDWWunyoI5m2DGirYTRcj1xgt+0VjCElxA6jFA
   pjR8IWpFSiX+gcRyJXUTVgpbCsbXE+xzBm7jPEp8PL0GcDRK/v39vlaSQ
   VMr4HHzdu9CMr84p3hFbxtXKi8YebayKdFvnhk7gDyB8VR4Rqep0YYgQB
   RFAqqUX6BUufTX9DolcvPa35KwkjkvCQPTGtjtyiwi+yqI9sJWb3BrdaA
   kVdl4OVSqCA+3Pn2usLAKe4RjNW/MJVFFriPW1SpV90Or5POiQcyqKyDK
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="428377409"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="428377409"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 22:30:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="686242063"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="686242063"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2023 22:30:08 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjZF8-000PEe-10;
        Tue, 04 Apr 2023 05:30:06 +0000
Date:   Tue, 4 Apr 2023 13:29:42 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v5 18/18] scsi: target: Add block PR support to iblock
Message-ID: <202304041322.SEFV29Co-lkp@intel.com>
References: <20230324181741.13908-19-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324181741.13908-19-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next axboe-block/for-next linus/master v6.3-rc5 next-20230403]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/block-Add-PR-callouts-for-read-keys-and-reservation/20230325-022314
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230324181741.13908-19-michael.christie%40oracle.com
patch subject: [PATCH v5 18/18] scsi: target: Add block PR support to iblock
config: ia64-randconfig-s043-20230403 (https://download.01.org/0day-ci/archive/20230404/202304041322.SEFV29Co-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/f3fe3a0cab8498044d99362b81e01f5c48da5f63
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mike-Christie/block-Add-PR-callouts-for-read-keys-and-reservation/20230325-022314
        git checkout f3fe3a0cab8498044d99362b81e01f5c48da5f63
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/target/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304041322.SEFV29Co-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/target/target_core_iblock.c:968:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:968:24: sparse:     expected int
   drivers/target/target_core_iblock.c:968:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:973:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:973:24: sparse:     expected int
   drivers/target/target_core_iblock.c:973:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:985:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:985:24: sparse:     expected int
   drivers/target/target_core_iblock.c:985:24: sparse:     got restricted sense_reason_t
>> drivers/target/target_core_iblock.c:996:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int [assigned] ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:996:21: sparse:     expected int [assigned] ret
   drivers/target/target_core_iblock.c:996:21: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1000:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected int [assigned] ret @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1000:13: sparse:     expected int [assigned] ret
   drivers/target/target_core_iblock.c:1000:13: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1035:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1035:24: sparse:     expected int
   drivers/target/target_core_iblock.c:1035:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1040:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1040:24: sparse:     expected int
   drivers/target/target_core_iblock.c:1040:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1044:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1044:24: sparse:     expected int
   drivers/target/target_core_iblock.c:1044:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1049:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1049:24: sparse:     expected int
   drivers/target/target_core_iblock.c:1049:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1055:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1055:24: sparse:     expected int
   drivers/target/target_core_iblock.c:1055:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1059:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1059:24: sparse:     expected int
   drivers/target/target_core_iblock.c:1059:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_iblock.c:1062:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_iblock.c:1062:16: sparse:     expected int
   drivers/target/target_core_iblock.c:1062:16: sparse:     got restricted sense_reason_t
>> drivers/target/target_core_iblock.c:1075:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted sense_reason_t [usertype] ret @@     got int @@
   drivers/target/target_core_iblock.c:1075:21: sparse:     expected restricted sense_reason_t [usertype] ret
   drivers/target/target_core_iblock.c:1075:21: sparse:     got int
   drivers/target/target_core_iblock.c:1078:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted sense_reason_t [usertype] ret @@     got int @@
   drivers/target/target_core_iblock.c:1078:21: sparse:     expected restricted sense_reason_t [usertype] ret
   drivers/target/target_core_iblock.c:1078:21: sparse:     got int

vim +968 drivers/target/target_core_iblock.c

   956	
   957	static int iblock_pr_read_keys(struct se_cmd *cmd, unsigned char *param_data)
   958	{
   959		struct se_device *dev = cmd->se_dev;
   960		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
   961		struct block_device *bdev = ib_dev->ibd_bd;
   962		const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
   963		int i, ret, len, paths, data_offset;
   964		struct pr_keys *keys;
   965	
   966		if (!ops) {
   967			pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
 > 968			return TCM_UNSUPPORTED_SCSI_OPCODE;
   969		}
   970	
   971		if (!ops->pr_read_keys) {
   972			pr_err("Block device does not support read_keys.\n");
   973			return TCM_UNSUPPORTED_SCSI_OPCODE;
   974		}
   975	
   976		/*
   977		 * We don't know what's under us, but dm-multipath will register every
   978		 * path with the same key, so start off with enough space for 16 paths.
   979		 */
   980		paths = 16;
   981	retry:
   982		len = 8 * paths;
   983		keys = kzalloc(sizeof(*keys) + len, GFP_KERNEL);
   984		if (!keys)
   985			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
   986	
   987		keys->num_keys = paths;
   988		ret = ops->pr_read_keys(bdev, keys);
   989		if (!ret) {
   990			if (keys->num_keys > paths) {
   991				kfree(keys);
   992				paths *= 2;
   993				goto retry;
   994			}
   995		} else if (ret) {
 > 996			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
   997			goto free_keys;
   998		}
   999	
  1000		ret = TCM_NO_SENSE;
  1001	
  1002		put_unaligned_be32(keys->generation, &param_data[0]);
  1003		if (!keys->num_keys) {
  1004			put_unaligned_be32(0, &param_data[4]);
  1005			goto free_keys;
  1006		}
  1007	
  1008		put_unaligned_be32(8 * keys->num_keys, &param_data[4]);
  1009	
  1010		data_offset = 8;
  1011		for (i = 0; i < keys->num_keys; i++) {
  1012			if (data_offset + 8 > cmd->data_length)
  1013				break;
  1014	
  1015			put_unaligned_be64(keys->keys[i], &param_data[data_offset]);
  1016			data_offset += 8;
  1017		}
  1018	
  1019	free_keys:
  1020		kfree(keys);
  1021		return ret;
  1022	}
  1023	
  1024	static int iblock_pr_read_reservation(struct se_cmd *cmd,
  1025					      unsigned char *param_data)
  1026	{
  1027		struct se_device *dev = cmd->se_dev;
  1028		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
  1029		struct block_device *bdev = ib_dev->ibd_bd;
  1030		const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
  1031		struct pr_held_reservation rsv = { };
  1032	
  1033		if (!ops) {
  1034			pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
  1035			return TCM_UNSUPPORTED_SCSI_OPCODE;
  1036		}
  1037	
  1038		if (!ops->pr_read_reservation) {
  1039			pr_err("Block device does not support read_keys.\n");
  1040			return TCM_UNSUPPORTED_SCSI_OPCODE;
  1041		}
  1042	
  1043		if (ops->pr_read_reservation(bdev, &rsv))
  1044			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
  1045	
  1046		put_unaligned_be32(rsv.generation, &param_data[0]);
  1047		if (!block_pr_type_to_scsi(rsv.type)) {
  1048			put_unaligned_be32(0, &param_data[4]);
  1049			return TCM_NO_SENSE;
  1050		}
  1051	
  1052		put_unaligned_be32(16, &param_data[4]);
  1053	
  1054		if (cmd->data_length < 16)
> 1055			return TCM_NO_SENSE;
  1056		put_unaligned_be64(rsv.key, &param_data[8]);
  1057	
  1058		if (cmd->data_length < 22)
  1059			return TCM_NO_SENSE;
  1060		param_data[21] = block_pr_type_to_scsi(rsv.type);
  1061	
  1062		return TCM_NO_SENSE;
  1063	}
  1064	
  1065	static sense_reason_t iblock_execute_pr_in(struct se_cmd *cmd, u8 sa,
  1066						   unsigned char *param_data)
  1067	{
  1068		sense_reason_t ret = TCM_NO_SENSE;
  1069	
  1070		switch (sa) {
  1071		case PRI_REPORT_CAPABILITIES:
  1072			iblock_pr_report_caps(param_data);
  1073			break;
  1074		case PRI_READ_KEYS:
> 1075			ret = iblock_pr_read_keys(cmd, param_data);
  1076			break;
  1077		case PRI_READ_RESERVATION:
  1078			ret = iblock_pr_read_reservation(cmd, param_data);
  1079			break;
  1080		default:
  1081			pr_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
  1082			return TCM_UNSUPPORTED_SCSI_OPCODE;
  1083		}
  1084	
  1085		return ret;
  1086	}
  1087	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
