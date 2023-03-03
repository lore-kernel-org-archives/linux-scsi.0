Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B8CC678D4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 05:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjCCFe4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 00:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjCCFey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 00:34:54 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44C2976B
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 21:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677821692; x=1709357692;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CEL6x9+KerWrUgJYZaOQG6l602KQIaJy3RTvHGd8Xmc=;
  b=mI4GknKFBTzpecZnIlX8UzjzNw89Olj1YAROpWYmGL78d7r48D8o/rX8
   5ViZXKMvTj3srIne461/BHjqdOiEf0vwhXCqVZvAPmTEjgc9+owyIRWuh
   KYhsWwT+6wL5KzAvWVNCHI1p5Ltm/AxTK/oq6RtYDMKpq6o5cffcH4yQ0
   QDo8pixptM6hbEwLhdKpmD+K3k43YDUwkj+Ma+QMJfplpp0aOsE3I6oQm
   qVXeXOhaUidyG1MH21kJuZkxum6CfpABTolvBdZ6dM1tqYMLYy3SMnc56
   k4PaUjxj1IB29tZWa/eTyNvGopvTlUneeL6pAXdc6qAE5Mq6jAbvuVgLU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="362553294"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="362553294"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 21:34:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="818351616"
X-IronPort-AV: E=Sophos;i="5.98,229,1673942400"; 
   d="scan'208";a="818351616"
Received: from lkp-server01.sh.intel.com (HELO 776573491cc5) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 02 Mar 2023 21:34:50 -0800
Received: from kbuild by 776573491cc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pXy4A-0001E6-0q;
        Fri, 03 Mar 2023 05:34:50 +0000
Date:   Fri, 3 Mar 2023 13:34:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     oe-kbuild-all@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Message-ID: <202303031358.dwPeGHeZ-lkp@intel.com>
References: <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Shin'ichiro,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on jejb-scsi/for-next]
[also build test ERROR on mkp-scsi/for-next linus/master v6.2 next-20230303]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shin-ichiro-Kawasaki/scsi-sd-Check-physical-sector-alignment-of-sequential-zone-writes/20230303-094618
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
patch link:    https://lore.kernel.org/r/20230303014422.2466103-2-shinichiro.kawasaki%40wdc.com
patch subject: [PATCH 1/2] scsi: sd: Check physical sector alignment of sequential zone writes
config: arc-randconfig-r031-20230302 (https://download.01.org/0day-ci/archive/20230303/202303031358.dwPeGHeZ-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/60573809bdc58708e29f2f9ecbddb06aeb9e8716
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Shin-ichiro-Kawasaki/scsi-sd-Check-physical-sector-alignment-of-sequential-zone-writes/20230303-094618
        git checkout 60573809bdc58708e29f2f9ecbddb06aeb9e8716
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arc SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303031358.dwPeGHeZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/scsi/sd.c: In function 'sd_setup_read_write_cmnd':
>> drivers/scsi/sd.c:1151:47: error: implicit declaration of function 'blk_rq_zone_is_seq'; did you mean 'bio_zone_is_seq'? [-Werror=implicit-function-declaration]
    1151 |         if (sdkp->device->type == TYPE_ZBC && blk_rq_zone_is_seq(rq) &&
         |                                               ^~~~~~~~~~~~~~~~~~
         |                                               bio_zone_is_seq
   cc1: some warnings being treated as errors


vim +1151 drivers/scsi/sd.c

  1119	
  1120	static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
  1121	{
  1122		struct request *rq = scsi_cmd_to_rq(cmd);
  1123		struct scsi_device *sdp = cmd->device;
  1124		struct scsi_disk *sdkp = scsi_disk(rq->q->disk);
  1125		sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
  1126		sector_t threshold;
  1127		unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
  1128		unsigned int pb_sectors = sdkp->physical_block_size >> SECTOR_SHIFT;
  1129		unsigned int mask = logical_to_sectors(sdp, 1) - 1;
  1130		bool write = rq_data_dir(rq) == WRITE;
  1131		unsigned char protect, fua;
  1132		blk_status_t ret;
  1133		unsigned int dif;
  1134		bool dix;
  1135	
  1136		ret = scsi_alloc_sgtables(cmd);
  1137		if (ret != BLK_STS_OK)
  1138			return ret;
  1139	
  1140		ret = BLK_STS_IOERR;
  1141		if (!scsi_device_online(sdp) || sdp->changed) {
  1142			scmd_printk(KERN_ERR, cmd, "device offline or changed\n");
  1143			goto fail;
  1144		}
  1145	
  1146		if (blk_rq_pos(rq) + blk_rq_sectors(rq) > get_capacity(rq->q->disk)) {
  1147			scmd_printk(KERN_ERR, cmd, "access beyond end of device\n");
  1148			goto fail;
  1149		}
  1150	
> 1151		if (sdkp->device->type == TYPE_ZBC && blk_rq_zone_is_seq(rq) &&
  1152		    (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_ZONE_APPEND) &&
  1153		    (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
  1154		     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors))) {
  1155			scmd_printk(KERN_ERR, cmd,
  1156				    "Sequential write request not aligned to the physical block size\n");
  1157			goto fail;
  1158		}
  1159	
  1160		if ((blk_rq_pos(rq) & mask) || (blk_rq_sectors(rq) & mask)) {
  1161			scmd_printk(KERN_ERR, cmd, "request not aligned to the logical block size\n");
  1162			goto fail;
  1163		}
  1164	
  1165		/*
  1166		 * Some SD card readers can't handle accesses which touch the
  1167		 * last one or two logical blocks. Split accesses as needed.
  1168		 */
  1169		threshold = sdkp->capacity - SD_LAST_BUGGY_SECTORS;
  1170	
  1171		if (unlikely(sdp->last_sector_bug && lba + nr_blocks > threshold)) {
  1172			if (lba < threshold) {
  1173				/* Access up to the threshold but not beyond */
  1174				nr_blocks = threshold - lba;
  1175			} else {
  1176				/* Access only a single logical block */
  1177				nr_blocks = 1;
  1178			}
  1179		}
  1180	
  1181		if (req_op(rq) == REQ_OP_ZONE_APPEND) {
  1182			ret = sd_zbc_prepare_zone_append(cmd, &lba, nr_blocks);
  1183			if (ret)
  1184				goto fail;
  1185		}
  1186	
  1187		fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
  1188		dix = scsi_prot_sg_count(cmd);
  1189		dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
  1190	
  1191		if (dif || dix)
  1192			protect = sd_setup_protect_cmnd(cmd, dix, dif);
  1193		else
  1194			protect = 0;
  1195	
  1196		if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
  1197			ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
  1198						 protect | fua);
  1199		} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
  1200			ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
  1201						 protect | fua);
  1202		} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
  1203			   sdp->use_10_for_rw || protect) {
  1204			ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
  1205						 protect | fua);
  1206		} else {
  1207			ret = sd_setup_rw6_cmnd(cmd, write, lba, nr_blocks,
  1208						protect | fua);
  1209		}
  1210	
  1211		if (unlikely(ret != BLK_STS_OK))
  1212			goto fail;
  1213	
  1214		/*
  1215		 * We shouldn't disconnect in the middle of a sector, so with a dumb
  1216		 * host adapter, it's safe to assume that we can at least transfer
  1217		 * this many bytes between each connect / disconnect.
  1218		 */
  1219		cmd->transfersize = sdp->sector_size;
  1220		cmd->underflow = nr_blocks << 9;
  1221		cmd->allowed = sdkp->max_retries;
  1222		cmd->sdb.length = nr_blocks * sdp->sector_size;
  1223	
  1224		SCSI_LOG_HLQUEUE(1,
  1225				 scmd_printk(KERN_INFO, cmd,
  1226					     "%s: block=%llu, count=%d\n", __func__,
  1227					     (unsigned long long)blk_rq_pos(rq),
  1228					     blk_rq_sectors(rq)));
  1229		SCSI_LOG_HLQUEUE(2,
  1230				 scmd_printk(KERN_INFO, cmd,
  1231					     "%s %d/%u 512 byte blocks.\n",
  1232					     write ? "writing" : "reading", nr_blocks,
  1233					     blk_rq_sectors(rq)));
  1234	
  1235		/*
  1236		 * This indicates that the command is ready from our end to be queued.
  1237		 */
  1238		return BLK_STS_OK;
  1239	fail:
  1240		scsi_free_sgtables(cmd);
  1241		return ret;
  1242	}
  1243	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
