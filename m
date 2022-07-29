Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D825C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jul 2022 17:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbiG2RdR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jul 2022 13:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiG2RdQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2022 13:33:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492AA88752
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2022 10:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659115995; x=1690651995;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P7m+gEvov0nLYQ6dYmm2CiFzt7+/NYw5MRKoEWSQ4Hg=;
  b=H50wmUU4ZypVKTwiZoqo5f4znYV60BazKZIsSVmjcisppfMPzkbf1uyr
   1NDzwoLwKK+amOl59Mz+PApBKMeITCnDsTGUfWi9+2SuB9D6UuNs5mfda
   gUw836BG/GoECie/LSWsswFMBXCoVH0sT6JTr+soQl7BpBiFaDYQxv+JM
   izbJc4tgNg9QeIx7wkhSTLpxXskEG85GhaZ1k9BpF2LLbz3yK66YFOog0
   EHaKMyDdjufJrPxnNknCu72YHcNTWqRo5MYDPb+m6bqb+P4bGs4W/Q2Lq
   pdxdUET5JZ2Gdh96qlqR/ckm2uDtOXA1/JcgryEibAgEvYOyBmLELJmAf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="290015302"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="290015302"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 10:33:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="551806219"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 29 Jul 2022 10:33:13 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oHTrM-000BvL-1c;
        Fri, 29 Jul 2022 17:33:12 +0000
Date:   Sat, 30 Jul 2022 01:32:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 11/15] mpi3mr: Add SAS SATA end devices to STL
Message-ID: <202207300127.y29B3Vbe-lkp@intel.com>
References: <20220729131627.15019-12-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729131627.15019-12-sreekanth.reddy@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sreekanth,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on next-20220728]
[cannot apply to jejb-scsi/for-next linus/master v5.19-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sreekanth-Reddy/mpi3mr-Added-Support-for-SAS-Transport/20220729-210902
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: i386-randconfig-a013 (https://download.01.org/0day-ci/archive/20220730/202207300127.y29B3Vbe-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 8dfaecc4c24494337933aff9d9166486ca0949f1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/e4b268bf60cc339de06db43ad3da7450cf59e9c2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sreekanth-Reddy/mpi3mr-Added-Support-for-SAS-Transport/20220729-210902
        git checkout e4b268bf60cc339de06db43ad3da7450cf59e9c2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/scsi/mpi3mr/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/scsi/mpi3mr/mpi3mr_os.c:1573:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
                   default:
                   ^
   drivers/scsi/mpi3mr/mpi3mr_os.c:1573:3: note: insert 'break;' to avoid fall-through
                   default:
                   ^
                   break; 
   1 warning generated.


vim +1573 drivers/scsi/mpi3mr/mpi3mr_os.c

9fc4abfe5a5fc9f Kashyap Desai   2021-05-20  1491  
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1492  /**
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1493   * mpi3mr_sastopochg_evt_bh - SASTopologyChange evt bottomhalf
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1494   * @mrioc: Adapter instance reference
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1495   * @fwevt: Firmware event reference
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1496   *
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1497   * Prints information about the SAS topology change event and
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1498   * for "not responding" event code, removes the device from the
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1499   * upper layers.
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1500   *
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1501   * Return: Nothing.
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1502   */
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1503  static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1504  	struct mpi3mr_fwevt *fwevt)
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1505  {
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1506  	struct mpi3_event_data_sas_topology_change_list *event_data =
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1507  	    (struct mpi3_event_data_sas_topology_change_list *)fwevt->event_data;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1508  	int i;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1509  	u16 handle;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1510  	u8 reason_code;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1511  	u64 exp_sas_address = 0, parent_sas_address = 0;
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1512  	struct mpi3mr_hba_port *hba_port = NULL;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1513  	struct mpi3mr_tgt_dev *tgtdev = NULL;
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1514  	struct mpi3mr_sas_node *sas_expander = NULL;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1515  	unsigned long flags;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1516  	u8 link_rate, prev_link_rate, parent_phy_number;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1517  
9fc4abfe5a5fc9f Kashyap Desai   2021-05-20  1518  	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1519  	if (mrioc->sas_transport_enabled) {
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1520  		hba_port = mpi3mr_get_hba_port_by_id(mrioc,
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1521  		    event_data->io_unit_port);
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1522  		if (le16_to_cpu(event_data->expander_dev_handle)) {
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1523  			spin_lock_irqsave(&mrioc->sas_node_lock, flags);
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1524  			sas_expander = __mpi3mr_expander_find_by_handle(mrioc,
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1525  			    le16_to_cpu(event_data->expander_dev_handle));
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1526  			if (sas_expander) {
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1527  				exp_sas_address = sas_expander->sas_address;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1528  				hba_port = sas_expander->hba_port;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1529  			}
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1530  			spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1531  			parent_sas_address = exp_sas_address;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1532  		} else
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1533  			parent_sas_address = mrioc->sas_hba.sas_address;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1534  	}
9fc4abfe5a5fc9f Kashyap Desai   2021-05-20  1535  
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1536  	for (i = 0; i < event_data->num_entries; i++) {
580e6742205efe6 Sreekanth Reddy 2022-02-10  1537  		if (fwevt->discard)
580e6742205efe6 Sreekanth Reddy 2022-02-10  1538  			return;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1539  		handle = le16_to_cpu(event_data->phy_entry[i].attached_dev_handle);
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1540  		if (!handle)
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1541  			continue;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1542  		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, handle);
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1543  		if (!tgtdev)
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1544  			continue;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1545  
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1546  		reason_code = event_data->phy_entry[i].status &
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1547  		    MPI3_EVENT_SAS_TOPO_PHY_RC_MASK;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1548  
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1549  		switch (reason_code) {
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1550  		case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1551  			if (tgtdev->host_exposed)
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1552  				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1553  			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1554  			mpi3mr_tgtdev_put(tgtdev);
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1555  			break;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1556  		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1557  		case MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED:
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1558  		case MPI3_EVENT_SAS_TOPO_PHY_RC_NO_CHANGE:
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1559  		{
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1560  			if (!mrioc->sas_transport_enabled || tgtdev->non_stl
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1561  			    || tgtdev->is_hidden)
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1562  				break;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1563  			link_rate = event_data->phy_entry[i].link_rate >> 4;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1564  			prev_link_rate = event_data->phy_entry[i].link_rate & 0xF;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1565  			if (link_rate == prev_link_rate)
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1566  				break;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1567  			if (!parent_sas_address)
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1568  				break;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1569  			parent_phy_number = event_data->start_phy_num + i;
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1570  			mpi3mr_update_links(mrioc, parent_sas_address, handle,
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1571  			    parent_phy_number, link_rate, hba_port);
e4b268bf60cc339 Sreekanth Reddy 2022-07-29  1572  		}
13ef29ea4aa0655 Kashyap Desai   2021-05-20 @1573  		default:
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1574  			break;
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1575  		}
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1576  		if (tgtdev)
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1577  			mpi3mr_tgtdev_put(tgtdev);
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1578  	}
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1579  
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1580  	if (mrioc->sas_transport_enabled && (event_data->exp_status ==
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1581  	    MPI3_EVENT_SAS_TOPO_ES_NOT_RESPONDING)) {
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1582  		if (sas_expander)
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1583  			mpi3mr_expander_remove(mrioc, exp_sas_address,
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1584  			    hba_port);
eaf398d9cf51b23 Sreekanth Reddy 2022-07-29  1585  	}
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1586  }
13ef29ea4aa0655 Kashyap Desai   2021-05-20  1587  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
