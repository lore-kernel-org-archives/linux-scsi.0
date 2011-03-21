From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 16:24:58 -0500
Message-ID: <4D87C22A.6070301@linux.vnet.ibm.com>
References: <20110307134033K.fujita.tomonori@lab.ntt.co.jp> <1299508803.12730.1.camel@mulgrave.site> <4D83C78D.5040908@linux.vnet.ibm.com> <20110321100909E.fujita.tomonori@lab.ntt.co.jp> <4D87BC8C.5090104@linux.vnet.ibm.com> <1300741291.21880.17.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60782 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab1CUVZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 17:25:00 -0400
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2LL5SPb027770
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 17:05:28 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 9168638C8039
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 17:24:54 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2LLOxAm396424
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 17:24:59 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2LLOwQH017123
	for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2011 17:24:59 -0400
In-Reply-To: <1300741291.21880.17.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On 03/21/2011 04:01 PM, Nicholas A. Bellinger wrote:
> On Mon, 2011-03-21 at 16:01 -0500, Brian King wrote:
>> On 03/20/2011 08:09 PM, FUJITA Tomonori wrote:
>>> Thanks for the testings,
>>>
>>> On Fri, 18 Mar 2011 15:58:53 -0500
>>> Brian King <brking@linux.vnet.ibm.com> wrote:
>>>
>>>> On 03/07/2011 08:40 AM, James Bottomley wrote:
>>>>> On Mon, 2011-03-07 at 13:41 +0900, FUJITA Tomonori wrote:
>>>>>> On Sat, 12 Feb 2011 14:27:26 -0600
>>>>>> James Bottomley <James.Bottomley@suse.de> wrote:
>>>>>>
>>>>>>>> Disregard my previous comment. It looks like current client should handle reservations
>>>>>>>> just fine without any further changes.
>>>>>>>
>>>>>>> So is that an ack for putting this in scsi-misc ... or did you want to
>>>>>>> do more testing first?
>>>>>>
>>>>>> Ping,
>>>>>>
>>>>>> Brian, James, can we merge this during the next merge window?
>>>>>
>>>>> I'm still waiting for an ack from Brian.
>>>>
>>>> Sorry for the delay... I've got this loaded in the lab and have managed to oops
>>>> a couple times. The first one was during shutdown, which I wasn't able to collect
>>>> any data for. The most recent occurred when a client was trying to login for the
>>>> first time:
>>>
>>> You mean that the kernel crashes every time when a client logs in?
>>
>> I think the crash I was seeing when the client logs in was just due to the fact that
>> I had things misconfigured. It took me a bit to figure out the configfs stuff. Didn't
>> realize at first I had to go off and manually create a lot of the configfs layout
>> described in the wiki page. Once I did that, I was able to get a LUN to successfully
>> report in on the client side. I'll start pounding on this a bit and see how things
>> hold up.
>>
> 
> Hi Brian,
> 
> If could send along the original misconfigured configfs layout that is
> causing the OOPs in handle_crq(), I would be happy to have a quick look.

Here it is. As you can see, there is no ./target/ibmvscsis directory created. In order
to get it to work, I did the following. Please let me know if there is a better way
to do this...

cd /sys/kernel/configfs/target
mkdir -p ibmvscsis/30000003/tpgt_1
mkdir ibmvscsis/30000003/tpgt_1/lun/lun_0
ln -s core/fileio_0/testfvd ibmvscsis/30000003/tpgt_1/lun/lun_0/default

I had previously created a file backed lun via:

tcm_node --fileio fileio_0/testfvd /vdisks/test 100000000

Thanks,

Brian


./target
./target/core
./target/core/fileio_0
./target/core/fileio_0/testfvd
./target/core/fileio_0/testfvd/alua
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/members
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/tg_pt_gp_id
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/preferred
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/trans_delay_msecs
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/nonop_delay_msecs
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_write_metadata
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_access_type
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_access_status
./target/core/fileio_0/testfvd/alua/default_tg_pt_gp/alua_access_state
./target/core/fileio_0/testfvd/wwn
./target/core/fileio_0/testfvd/wwn/vpd_assoc_scsi_target_device
./target/core/fileio_0/testfvd/wwn/vpd_assoc_target_port
./target/core/fileio_0/testfvd/wwn/vpd_assoc_logical_unit
./target/core/fileio_0/testfvd/wwn/vpd_protocol_identifier
./target/core/fileio_0/testfvd/wwn/vpd_unit_serial
./target/core/fileio_0/testfvd/pr
./target/core/fileio_0/testfvd/pr/res_aptpl_metadata
./target/core/fileio_0/testfvd/pr/res_aptpl_active
./target/core/fileio_0/testfvd/pr/res_type
./target/core/fileio_0/testfvd/pr/res_pr_type
./target/core/fileio_0/testfvd/pr/res_pr_registered_i_pts
./target/core/fileio_0/testfvd/pr/res_pr_holder_tg_port
./target/core/fileio_0/testfvd/pr/res_pr_generation
./target/core/fileio_0/testfvd/pr/res_pr_all_tgt_pts
./target/core/fileio_0/testfvd/pr/res_holder
./target/core/fileio_0/testfvd/attrib
./target/core/fileio_0/testfvd/attrib/unmap_granularity_alignment
./target/core/fileio_0/testfvd/attrib/unmap_granularity
./target/core/fileio_0/testfvd/attrib/max_unmap_block_desc_count
./target/core/fileio_0/testfvd/attrib/max_unmap_lba_count
./target/core/fileio_0/testfvd/attrib/task_timeout
./target/core/fileio_0/testfvd/attrib/queue_depth
./target/core/fileio_0/testfvd/attrib/hw_queue_depth
./target/core/fileio_0/testfvd/attrib/optimal_sectors
./target/core/fileio_0/testfvd/attrib/max_sectors
./target/core/fileio_0/testfvd/attrib/hw_max_sectors
./target/core/fileio_0/testfvd/attrib/block_size
./target/core/fileio_0/testfvd/attrib/hw_block_size
./target/core/fileio_0/testfvd/attrib/enforce_pr_isids
./target/core/fileio_0/testfvd/attrib/emulate_tpws
./target/core/fileio_0/testfvd/attrib/emulate_tpu
./target/core/fileio_0/testfvd/attrib/emulate_tas
./target/core/fileio_0/testfvd/attrib/emulate_ua_intlck_ctrl
./target/core/fileio_0/testfvd/attrib/emulate_write_cache
./target/core/fileio_0/testfvd/attrib/emulate_fua_read
./target/core/fileio_0/testfvd/attrib/emulate_fua_write
./target/core/fileio_0/testfvd/attrib/emulate_dpo
./target/core/fileio_0/testfvd/alua_lu_gp
./target/core/fileio_0/testfvd/enable
./target/core/fileio_0/testfvd/udev_path
./target/core/fileio_0/testfvd/alias
./target/core/fileio_0/testfvd/control
./target/core/fileio_0/testfvd/info
./target/core/fileio_0/hba_mode
./target/core/fileio_0/hba_info
./target/core/alua
./target/core/alua/lu_gps
./target/core/alua/lu_gps/default_lu_gp
./target/core/alua/lu_gps/default_lu_gp/members
./target/core/alua/lu_gps/default_lu_gp/lu_gp_id
./target/version



-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


