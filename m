From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Tue, 22 Mar 2011 08:20:07 +0900
Message-ID: <20110322082013O.fujita.tomonori@lab.ntt.co.jp>
References: <4D87BC8C.5090104@linux.vnet.ibm.com>
	<1300741291.21880.17.camel@haakon2.linux-iscsi.org>
	<4D87C22A.6070301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57125 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932108Ab1CUXUW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 19:20:22 -0400
In-Reply-To: <4D87C22A.6070301@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: nab@linux-iscsi.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Mon, 21 Mar 2011 16:24:58 -0500
Brian King <brking@linux.vnet.ibm.com> wrote:

> > If could send along the original misconfigured configfs layout that is
> > causing the OOPs in handle_crq(), I would be happy to have a quick look.
> 
> Here it is. As you can see, there is no ./target/ibmvscsis directory created. In order

I suspect something like that. The driver can't crash with any
configurations though.


> to get it to work, I did the following. Please let me know if there is a better way
> to do this...

As I said long before, this kinda hardware configuration should
automatically show up when we load the driver module. But the target
core is broken in this regard.

Anyway, I'll fix the driver not to crash with incomplete
configurations.

Thanks,


> cd /sys/kernel/configfs/target
> mkdir -p ibmvscsis/30000003/tpgt_1
> mkdir ibmvscsis/30000003/tpgt_1/lun/lun_0
> ln -s core/fileio_0/testfvd ibmvscsis/30000003/tpgt_1/lun/lun_0/default
> 
> I had previously created a file backed lun via:
> 
> tcm_node --fileio fileio_0/testfvd /vdisks/test 100000000
> 
> Thanks,
> 
> Brian
> 
> 
> ./target
> ./target/core
> ./target/core/fileio_0
> ./target/core/fileio_0/testfvd
> ./target/core/fileio_0/testfvd/alua
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/members
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/tg_pt_gp_id
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/preferred
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/trans_delay_msecs
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/nonop_delay_msecs
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_write_metadata
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_access_type
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_access_status
> ./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_access_state
> ./target/core/fileio_0/testfvd/wwn
> ./target/core/fileio_0/testfvd/wwn/vpd_assoc_scsi_target_device
> ./target/core/fileio_0/testfvd/wwn/vpd_assoc_target_port
> ./target/core/fileio_0/testfvd/wwn/vpd_assoc_logical_unit
> ./target/core/fileio_0/testfvd/wwn/vpd_protocol_identifier
> ./target/core/fileio_0/testfvd/wwn/vpd_unit_serial
> ./target/core/fileio_0/testfvd/pr
> ./target/core/fileio_0/testfvd/pr/res_aptpl_metadata
> ./target/core/fileio_0/testfvd/pr/res_aptpl_active
> ./target/core/fileio_0/testfvd/pr/res_type
> ./target/core/fileio_0/testfvd/pr/res_pr_type
> ./target/core/fileio_0/testfvd/pr/res_pr_registered_i_pts
> ./target/core/fileio_0/testfvd/pr/res_pr_holder_tg_port
> ./target/core/fileio_0/testfvd/pr/res_pr_generation
> ./target/core/fileio_0/testfvd/pr/res_pr_all_tgt_pts
> ./target/core/fileio_0/testfvd/pr/res_holder
> ./target/core/fileio_0/testfvd/attrib
> ./target/core/fileio_0/testfvd/attrib/unmap_granularity_alignment
> ./target/core/fileio_0/testfvd/attrib/unmap_granularity
> ./target/core/fileio_0/testfvd/attrib/max_unmap_block_desc_count
> ./target/core/fileio_0/testfvd/attrib/max_unmap_lba_count
> ./target/core/fileio_0/testfvd/attrib/task_timeout
> ./target/core/fileio_0/testfvd/attrib/queue_depth
> ./target/core/fileio_0/testfvd/attrib/hw_queue_depth
> ./target/core/fileio_0/testfvd/attrib/optimal_sectors
> ./target/core/fileio_0/testfvd/attrib/max_sectors
> ./target/core/fileio_0/testfvd/attrib/hw_max_sectors
> ./target/core/fileio_0/testfvd/attrib/block_size
> ./target/core/fileio_0/testfvd/attrib/hw_block_size
> ./target/core/fileio_0/testfvd/attrib/enforce_pr_isids
> ./target/core/fileio_0/testfvd/attrib/emulate_tpws
> ./target/core/fileio_0/testfvd/attrib/emulate_tpu
> ./target/core/fileio_0/testfvd/attrib/emulate_tas
> ./target/core/fileio_0/testfvd/attrib/emulate_ua_intlck_ctrl
> ./target/core/fileio_0/testfvd/attrib/emulate_write_cache
> ./target/core/fileio_0/testfvd/attrib/emulate_fua_read
> ./target/core/fileio_0/testfvd/attrib/emulate_fua_write
> ./target/core/fileio_0/testfvd/attrib/emulate_dpo
> ./target/core/fileio_0/testfvd/alua_lu_gp
> ./target/core/fileio_0/testfvd/enable
> ./target/core/fileio_0/testfvd/udev_path
> ./target/core/fileio_0/testfvd/alias
> ./target/core/fileio_0/testfvd/control
> ./target/core/fileio_0/testfvd/info
> ./target/core/fileio_0/hba_mode
> ./target/core/fileio_0/hba_info
> ./target/core/alua
> ./target/core/alua/lu_gps
> ./target/core/alua/lu_gps/default_lu_gp
> ./target/core/alua/lu_gps/default_lu_gp/members
> ./target/core/alua/lu_gps/default_lu_gp/lu_gp_id
> ./target/version
> 
> 
> 
> -- 
> Brian King
> Linux on Power Virtualization
> IBM Linux Technology Center
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
