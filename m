Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D54E13B59B;
	Wed,  9 Oct 2024 06:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728454296; cv=none; b=gvEQxjlOwqrLFTHxe9xGYY654VZa1FgA7spiqTTyK+3sJUTfqDhjdMjJ+HyKstB2WADQ2vmL/fXeEI8yE3CMGZ2F1HzrNtjusmnkzeqKEqquNJKbCdAmx0SdDi/DFUExVfwWR/fkqiJifTwD/6q4atHkHFxU4/C1RXyT4wLw+aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728454296; c=relaxed/simple;
	bh=a1u+9o6SwxeB9ddfv6aEUKvQpbUqt6hbz0WKp25pqQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8gIxBi7IVcst3n8cOgrfovPpVv3MAMv71CR5bGy8NGYgAhhX9qiVh9K4yIwfQoTRqfLfCyctJ4pOHaXT+V+O2jUYKt6XrDlmM7ASnGlAyhS5QXjJpOi6jAUALGbBQdCegHkIql4na1KCMrLG8/5caD42OzcFd7tDoMvXP8BGOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BtfUk2Ju; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BtfUk2Ju"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728454294; x=1759990294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a1u+9o6SwxeB9ddfv6aEUKvQpbUqt6hbz0WKp25pqQc=;
  b=BtfUk2Ju90WSbFWx0F9pGfsRzizKhiHw6NonffJtjbOaCH2SYRKZl1S9
   aSE3MWAbjxas1e6C5FEzZO1pT591SSLnA1YuimyKv42OClJMYddNLwH13
   lwypYib3APoKu2KrrVpvpktqSfgeV53LEVFSiG0RcoEoHzn/CIAgeBN0l
   iIZVdeVaKhcwj0SRjo0cCtalBZdkVZ48VJXkD6I8R31fLqEyOSB3QxWZO
   hqaH3JKqT9Mrtg75qllM0m043o4wexifd5W8VrYzEUcMcXpUchOcOWj8s
   mLC3gv4jSDRf1GcJrvsFfcz3AbE5h58UiJHx9hgKNqNdAYNcgIfzgano9
   Q==;
X-CSE-ConnectionGUID: KF5uvdkiTi+Udaj3yQBXCQ==
X-CSE-MsgGUID: TfFxIdb0RJ+wDwA5XavrUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="53135093"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="53135093"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 23:11:33 -0700
X-CSE-ConnectionGUID: td8Sae2ET4OgQ3Ajdvl7EA==
X-CSE-MsgGUID: rbPqvxTkQmGC3meRu4/ezg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76369954"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 08 Oct 2024 23:11:32 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1syPuy-0008pY-3B;
	Wed, 09 Oct 2024 06:11:28 +0000
Date: Wed, 9 Oct 2024 14:10:59 +0800
From: kernel test robot <lkp@intel.com>
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH 4/7] scsi: target: Add WRITE_ATOMIC_16 handler
Message-ID: <202410091340.dQ10fC3u-lkp@intel.com>
References: <20241008020437.78788-5-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008020437.78788-5-michael.christie@oracle.com>

Hi Mike,

kernel test robot noticed the following build warnings:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next linus/master v6.12-rc2 next-20241008]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Christie/scsi-target-Rename-target_configure_unmap_from_queue/20241008-101218
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
patch link:    https://lore.kernel.org/r/20241008020437.78788-5-michael.christie%40oracle.com
patch subject: [PATCH 4/7] scsi: target: Add WRITE_ATOMIC_16 handler
config: x86_64-randconfig-123-20241009 (https://download.01.org/0day-ci/archive/20241009/202410091340.dQ10fC3u-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241009/202410091340.dQ10fC3u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410091340.dQ10fC3u-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/target/target_core_sbc.c:775:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_sbc.c:775:24: sparse:     expected int
   drivers/target/target_core_sbc.c:775:24: sparse:     got restricted sense_reason_t
   drivers/target/target_core_sbc.c:783:32: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_sbc.c:783:32: sparse:     expected int
   drivers/target/target_core_sbc.c:783:32: sparse:     got restricted sense_reason_t
   drivers/target/target_core_sbc.c:786:32: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_sbc.c:786:32: sparse:     expected int
   drivers/target/target_core_sbc.c:786:32: sparse:     got restricted sense_reason_t
   drivers/target/target_core_sbc.c:789:32: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_sbc.c:789:32: sparse:     expected int
   drivers/target/target_core_sbc.c:789:32: sparse:     got restricted sense_reason_t
   drivers/target/target_core_sbc.c:794:32: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_sbc.c:794:32: sparse:     expected int
   drivers/target/target_core_sbc.c:794:32: sparse:     got restricted sense_reason_t
   drivers/target/target_core_sbc.c:797:32: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_sbc.c:797:32: sparse:     expected int
   drivers/target/target_core_sbc.c:797:32: sparse:     got restricted sense_reason_t
   drivers/target/target_core_sbc.c:802:24: sparse: sparse: incorrect type in return expression (different base types) @@     expected int @@     got restricted sense_reason_t @@
   drivers/target/target_core_sbc.c:802:24: sparse:     expected int
   drivers/target/target_core_sbc.c:802:24: sparse:     got restricted sense_reason_t
>> drivers/target/target_core_sbc.c:919:29: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted sense_reason_t [assigned] [usertype] ret @@     got int @@
   drivers/target/target_core_sbc.c:919:29: sparse:     expected restricted sense_reason_t [assigned] [usertype] ret
   drivers/target/target_core_sbc.c:919:29: sparse:     got int

vim +775 drivers/target/target_core_sbc.c

   766	
   767	static int
   768	sbc_check_atomic(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
   769	{
   770		struct se_dev_attrib *attrib = &dev->dev_attrib;
   771		u16 boundary, transfer_len;
   772		u32 lba;
   773	
   774		if (!attrib->atomic_supported)
 > 775			return TCM_UNSUPPORTED_SCSI_OPCODE;
   776	
   777		lba = transport_lba_32(cdb);
   778		boundary = get_unaligned_be16(&cdb[10]);
   779		transfer_len = get_unaligned_be16(&cdb[12]);
   780	
   781		if (!boundary) {
   782			if (transfer_len > attrib->atomic_max_len)
   783				return TCM_INVALID_CDB_FIELD;
   784		} else {
   785			if (transfer_len > attrib->atomic_max_with_boundary)
   786				return TCM_INVALID_CDB_FIELD;
   787	
   788			if (boundary > attrib->atomic_max_boundary)
   789				return TCM_INVALID_CDB_FIELD;
   790		}
   791	
   792		if (attrib->atomic_granularity) {
   793			if (transfer_len % attrib->atomic_granularity)
   794				return TCM_INVALID_CDB_FIELD;
   795	
   796			if (boundary && boundary % attrib->atomic_granularity)
   797				return TCM_INVALID_CDB_FIELD;
   798		}
   799	
   800		if (dev->dev_attrib.atomic_alignment &&
   801		    lba % dev->dev_attrib.atomic_alignment)
   802			return TCM_INVALID_CDB_FIELD;
   803	
   804		return 0;
   805	}
   806	
   807	sense_reason_t
   808	sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
   809	{
   810		struct se_device *dev = cmd->se_dev;
   811		unsigned char *cdb = cmd->t_task_cdb;
   812		unsigned int size;
   813		u32 sectors = 0;
   814		sense_reason_t ret;
   815	
   816		cmd->protocol_data = ops;
   817	
   818		switch (cdb[0]) {
   819		case READ_6:
   820			sectors = transport_get_sectors_6(cdb);
   821			cmd->t_task_lba = transport_lba_21(cdb);
   822			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   823			cmd->execute_cmd = sbc_execute_rw;
   824			break;
   825		case READ_10:
   826			sectors = transport_get_sectors_10(cdb);
   827			cmd->t_task_lba = transport_lba_32(cdb);
   828	
   829			if (sbc_check_dpofua(dev, cmd, cdb))
   830				return TCM_INVALID_CDB_FIELD;
   831	
   832			ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
   833			if (ret)
   834				return ret;
   835	
   836			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   837			cmd->execute_cmd = sbc_execute_rw;
   838			break;
   839		case READ_12:
   840			sectors = transport_get_sectors_12(cdb);
   841			cmd->t_task_lba = transport_lba_32(cdb);
   842	
   843			if (sbc_check_dpofua(dev, cmd, cdb))
   844				return TCM_INVALID_CDB_FIELD;
   845	
   846			ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
   847			if (ret)
   848				return ret;
   849	
   850			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   851			cmd->execute_cmd = sbc_execute_rw;
   852			break;
   853		case READ_16:
   854			sectors = transport_get_sectors_16(cdb);
   855			cmd->t_task_lba = transport_lba_64(cdb);
   856	
   857			if (sbc_check_dpofua(dev, cmd, cdb))
   858				return TCM_INVALID_CDB_FIELD;
   859	
   860			ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, false);
   861			if (ret)
   862				return ret;
   863	
   864			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   865			cmd->execute_cmd = sbc_execute_rw;
   866			break;
   867		case WRITE_6:
   868			sectors = transport_get_sectors_6(cdb);
   869			cmd->t_task_lba = transport_lba_21(cdb);
   870			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   871			cmd->execute_cmd = sbc_execute_rw;
   872			break;
   873		case WRITE_10:
   874		case WRITE_VERIFY:
   875			sectors = transport_get_sectors_10(cdb);
   876			cmd->t_task_lba = transport_lba_32(cdb);
   877	
   878			if (sbc_check_dpofua(dev, cmd, cdb))
   879				return TCM_INVALID_CDB_FIELD;
   880	
   881			ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
   882			if (ret)
   883				return ret;
   884	
   885			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   886			cmd->execute_cmd = sbc_execute_rw;
   887			break;
   888		case WRITE_12:
   889			sectors = transport_get_sectors_12(cdb);
   890			cmd->t_task_lba = transport_lba_32(cdb);
   891	
   892			if (sbc_check_dpofua(dev, cmd, cdb))
   893				return TCM_INVALID_CDB_FIELD;
   894	
   895			ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
   896			if (ret)
   897				return ret;
   898	
   899			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   900			cmd->execute_cmd = sbc_execute_rw;
   901			break;
   902		case WRITE_16:
   903		case WRITE_VERIFY_16:
   904		case WRITE_ATOMIC_16:
   905			sectors = transport_get_sectors_16(cdb);
   906			cmd->t_task_lba = transport_lba_64(cdb);
   907	
   908			if (sbc_check_dpofua(dev, cmd, cdb))
   909				return TCM_INVALID_CDB_FIELD;
   910	
   911			ret = sbc_check_prot(dev, cmd, cdb[1] >> 5, sectors, true);
   912			if (ret)
   913				return ret;
   914	
   915			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
   916			if (cdb[0] == WRITE_ATOMIC_16) {
   917				cmd->se_cmd_flags |= SCF_ATOMIC;
   918	
 > 919				ret = sbc_check_atomic(dev, cmd, cdb);
   920				if (ret)
   921					return ret;
   922			}
   923			cmd->execute_cmd = sbc_execute_rw;
   924			break;
   925		case VARIABLE_LENGTH_CMD:
   926		{
   927			u16 service_action = get_unaligned_be16(&cdb[8]);
   928			switch (service_action) {
   929			case WRITE_SAME_32:
   930				sectors = transport_get_sectors_32(cdb);
   931				if (!sectors) {
   932					pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not"
   933					       " supported\n");
   934					return TCM_INVALID_CDB_FIELD;
   935				}
   936	
   937				size = sbc_get_size(cmd, 1);
   938				cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
   939	
   940				ret = sbc_setup_write_same(cmd, cdb[10], ops);
   941				if (ret)
   942					return ret;
   943				break;
   944			default:
   945				pr_err("VARIABLE_LENGTH_CMD service action"
   946					" 0x%04x not supported\n", service_action);
   947				return TCM_UNSUPPORTED_SCSI_OPCODE;
   948			}
   949			break;
   950		}
   951		case COMPARE_AND_WRITE:
   952			if (!dev->dev_attrib.emulate_caw) {
   953				pr_err_ratelimited("se_device %s/%s (vpd_unit_serial %s) reject COMPARE_AND_WRITE\n",
   954						   dev->se_hba->backend->ops->name,
   955						   config_item_name(&dev->dev_group.cg_item),
   956						   dev->t10_wwn.unit_serial);
   957				return TCM_UNSUPPORTED_SCSI_OPCODE;
   958			}
   959			sectors = cdb[13];
   960			/*
   961			 * Currently enforce COMPARE_AND_WRITE for a single sector
   962			 */
   963			if (sectors > 1) {
   964				pr_err("COMPARE_AND_WRITE contains NoLB: %u greater"
   965				       " than 1\n", sectors);
   966				return TCM_INVALID_CDB_FIELD;
   967			}
   968			if (sbc_check_dpofua(dev, cmd, cdb))
   969				return TCM_INVALID_CDB_FIELD;
   970	
   971			/*
   972			 * Double size because we have two buffers, note that
   973			 * zero is not an error..
   974			 */
   975			size = 2 * sbc_get_size(cmd, sectors);
   976			cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
   977			cmd->t_task_nolb = sectors;
   978			cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB | SCF_COMPARE_AND_WRITE;
   979			cmd->execute_cmd = sbc_compare_and_write;
   980			cmd->transport_complete_callback = compare_and_write_callback;
   981			break;
   982		case READ_CAPACITY:
   983			size = READ_CAP_LEN;
   984			cmd->execute_cmd = sbc_emulate_readcapacity;
   985			break;
   986		case SERVICE_ACTION_IN_16:
   987			switch (cmd->t_task_cdb[1] & 0x1f) {
   988			case SAI_READ_CAPACITY_16:
   989				cmd->execute_cmd = sbc_emulate_readcapacity_16;
   990				break;
   991			case SAI_REPORT_REFERRALS:
   992				cmd->execute_cmd = target_emulate_report_referrals;
   993				break;
   994			default:
   995				pr_err("Unsupported SA: 0x%02x\n",
   996					cmd->t_task_cdb[1] & 0x1f);
   997				return TCM_INVALID_CDB_FIELD;
   998			}
   999			size = get_unaligned_be32(&cdb[10]);
  1000			break;
  1001		case SYNCHRONIZE_CACHE:
  1002		case SYNCHRONIZE_CACHE_16:
  1003			if (cdb[0] == SYNCHRONIZE_CACHE) {
  1004				sectors = transport_get_sectors_10(cdb);
  1005				cmd->t_task_lba = transport_lba_32(cdb);
  1006			} else {
  1007				sectors = transport_get_sectors_16(cdb);
  1008				cmd->t_task_lba = transport_lba_64(cdb);
  1009			}
  1010			if (ops->execute_sync_cache) {
  1011				cmd->execute_cmd = ops->execute_sync_cache;
  1012				goto check_lba;
  1013			}
  1014			size = 0;
  1015			cmd->execute_cmd = sbc_emulate_noop;
  1016			break;
  1017		case UNMAP:
  1018			if (!ops->execute_unmap)
  1019				return TCM_UNSUPPORTED_SCSI_OPCODE;
  1020	
  1021			if (!dev->dev_attrib.emulate_tpu) {
  1022				pr_err("Got UNMAP, but backend device has"
  1023				       " emulate_tpu disabled\n");
  1024				return TCM_UNSUPPORTED_SCSI_OPCODE;
  1025			}
  1026			size = get_unaligned_be16(&cdb[7]);
  1027			cmd->execute_cmd = sbc_execute_unmap;
  1028			break;
  1029		case WRITE_SAME_16:
  1030			sectors = transport_get_sectors_16(cdb);
  1031			if (!sectors) {
  1032				pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
  1033				return TCM_INVALID_CDB_FIELD;
  1034			}
  1035	
  1036			size = sbc_get_size(cmd, 1);
  1037			cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
  1038	
  1039			ret = sbc_setup_write_same(cmd, cdb[1], ops);
  1040			if (ret)
  1041				return ret;
  1042			break;
  1043		case WRITE_SAME:
  1044			sectors = transport_get_sectors_10(cdb);
  1045			if (!sectors) {
  1046				pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
  1047				return TCM_INVALID_CDB_FIELD;
  1048			}
  1049	
  1050			size = sbc_get_size(cmd, 1);
  1051			cmd->t_task_lba = get_unaligned_be32(&cdb[2]);
  1052	
  1053			/*
  1054			 * Follow sbcr26 with WRITE_SAME (10) and check for the existence
  1055			 * of byte 1 bit 3 UNMAP instead of original reserved field
  1056			 */
  1057			ret = sbc_setup_write_same(cmd, cdb[1], ops);
  1058			if (ret)
  1059				return ret;
  1060			break;
  1061		case VERIFY:
  1062		case VERIFY_16:
  1063			size = 0;
  1064			if (cdb[0] == VERIFY) {
  1065				sectors = transport_get_sectors_10(cdb);
  1066				cmd->t_task_lba = transport_lba_32(cdb);
  1067			} else {
  1068				sectors = transport_get_sectors_16(cdb);
  1069				cmd->t_task_lba = transport_lba_64(cdb);
  1070			}
  1071			cmd->execute_cmd = sbc_emulate_noop;
  1072			goto check_lba;
  1073		case REZERO_UNIT:
  1074		case SEEK_6:
  1075		case SEEK_10:
  1076			/*
  1077			 * There are still clients out there which use these old SCSI-2
  1078			 * commands. This mainly happens when running VMs with legacy
  1079			 * guest systems, connected via SCSI command pass-through to
  1080			 * iSCSI targets. Make them happy and return status GOOD.
  1081			 */
  1082			size = 0;
  1083			cmd->execute_cmd = sbc_emulate_noop;
  1084			break;
  1085		case START_STOP:
  1086			size = 0;
  1087			cmd->execute_cmd = sbc_emulate_startstop;
  1088			break;
  1089		default:
  1090			ret = spc_parse_cdb(cmd, &size);
  1091			if (ret)
  1092				return ret;
  1093		}
  1094	
  1095		/* reject any command that we don't have a handler for */
  1096		if (!cmd->execute_cmd)
  1097			return TCM_UNSUPPORTED_SCSI_OPCODE;
  1098	
  1099		if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
  1100			unsigned long long end_lba;
  1101	check_lba:
  1102			end_lba = dev->transport->get_blocks(dev) + 1;
  1103			if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
  1104			    ((cmd->t_task_lba + sectors) > end_lba)) {
  1105				pr_err("cmd exceeds last lba %llu "
  1106					"(lba %llu, sectors %u)\n",
  1107					end_lba, cmd->t_task_lba, sectors);
  1108				return TCM_ADDRESS_OUT_OF_RANGE;
  1109			}
  1110	
  1111			if (!(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE))
  1112				size = sbc_get_size(cmd, sectors);
  1113		}
  1114	
  1115		return target_cmd_size_check(cmd, size);
  1116	}
  1117	EXPORT_SYMBOL(sbc_parse_cdb);
  1118	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
