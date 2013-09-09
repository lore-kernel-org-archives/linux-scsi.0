From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] [scsi] enclosure: remove all possible sysfs entries before
 add device
Date: Mon, 09 Sep 2013 09:49:23 -0500
Message-ID: <522DDFF3.8040203@linux.vnet.ibm.com>
References: <522D685D.5060201@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38495 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3IIOuG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 10:50:06 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 9 Sep 2013 08:50:05 -0600
In-Reply-To: <522D685D.5060201@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Jin <joe.jin@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>

On 09/09/2013 01:19 AM, Joe Jin wrote:
> When do disk pull/insert test we encountered below:
> 
> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0xbc/0xe0()
> Hardware name: SUN FIRE X4370 M2 SERVER
> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:03.0/0000:0d:00.0/host6/port-6:1/expander-6:1/port-6:1:14/end_device-6:1:14/target6:0:27/6:0:27:0/enclosure_device:HDD10'
> Modules linked in: oracleacfs(P)(U) oracleadvm(P)(U) oracleoks(P)(U) mptctl mptbase autofs4 hidp bluetooth rfkill lockd sunrpc bonding be2iscsi iscsi_boot_sysfs ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp bnx2i cnic uio ipv6 cxgb3i libcxgbi cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi dm_round_robin dm_multipath video sbs sbshc acpi_pad acpi_memhotplug acpi_ipmi parport_pc lp parport ipmi_si ipmi_devintf ipmi_msghandler sg ses enclosure ixgbe e1000e hwmon igb snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd soundcore snd_page_alloc iTCO_wdt pcspkr i2c_i801 ioatdma ghes iTCO_vendor_support hed dca i2c_core i7core_edac edac_core dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod usb_s
 torage shpchp mpt2sas scsi_transport_sas raid_class ahci libahci sd_mod crc_t10dif raid1 ext3 jbd mbcache
> Pid: 23302, comm: kworker/u:2 Tainted: P            2.6.39-400.124.1.el5uek #1
> Call Trace:
>  [<ffffffff811daf8c>] ? sysfs_add_one+0xbc/0xe0
>  [<ffffffff8106f030>] warn_slowpath_common+0x90/0xc0
>  [<ffffffff8106f15e>] warn_slowpath_fmt+0x6e/0x70
>  [<ffffffff81258bd4>] ? strlcat+0x54/0x70
>  [<ffffffff811daf8c>] sysfs_add_one+0xbc/0xe0
>  [<ffffffff811dbec8>] sysfs_do_create_link+0x148/0x1d0
>  [<ffffffff811dbf83>] sysfs_create_link+0x13/0x20
>  [<ffffffffa00de307>] enclosure_add_links+0xe7/0x110 [enclosure]
>  [<ffffffff8125325d>] ? kobject_release+0xd/0x10
>  [<ffffffff812549e7>] ? kref_put+0x37/0x70
>  [<ffffffffa00de3c3>] enclosure_add_device+0x93/0xa0 [enclosure]
>  [<ffffffffa00c8666>] ses_enclosure_find_by_addr+0x76/0xc0 [ses]
>  [<ffffffffa00c85f0>] ? ses_get_fault+0x40/0x40 [ses]
>  [<ffffffffa00de433>] enclosure_for_each_device+0x63/0x90 [enclosure]
>  [<ffffffffa00c8a8a>] ses_match_to_enclosure+0x11a/0x1d0 [ses]
>  [<ffffffffa00c8e08>] ses_intf_add+0x2c8/0x5c0 [ses]
>  [<ffffffff8125327a>] ? kobject_get+0x1a/0x30
>  [<ffffffff814e8b56>] ? add_tail+0x36/0x50
>  [<ffffffff81345ae4>] device_add+0x2d4/0x380
>  [<ffffffff8136b096>] scsi_sysfs_add_sdev+0xe6/0x2a0
>  [<ffffffff813682cc>] scsi_add_lun+0x41c/0x560
>  [<ffffffff81368a80>] scsi_probe_and_add_lun+0x1e0/0x3e0
>  [<ffffffff81041009>] ? default_spin_lock_flags+0x9/0x10
>  [<ffffffff813696e7>] __scsi_scan_target+0xe7/0x120
>  [<ffffffff81369b8d>] scsi_scan_target+0xcd/0xf0
>  [<ffffffffa003faab>] sas_rphy_add+0x11b/0x170 [scsi_transport_sas]
>  [<ffffffffa009a74f>] mpt2sas_transport_port_add+0x2cf/0x430 [mpt2sas]
>  [<ffffffffa008d437>] _scsih_sas_device_add+0x87/0x110 [mpt2sas]
>  [<ffffffffa0094eb8>] _scsih_add_device+0x248/0x340 [mpt2sas]
>  [<ffffffffa0098cb1>] ? mpt2sas_transport_update_links+0xf1/0x190 [mpt2sas]
>  [<ffffffffa00977b6>] _scsih_sas_topology_change_event+0x3c6/0x490 [mpt2sas]
>  [<ffffffff81080698>] ? add_timer+0x18/0x20
>  [<ffffffff8108a405>] ? queue_delayed_work_on+0xc5/0x170
>  [<ffffffffa0097a85>] _mpt2sas_fw_work+0x205/0x240 [mpt2sas]
>  [<ffffffffa0097ad9>] _firmware_event_work_delayed+0x19/0x20 [mpt2sas]
>  [<ffffffff8108c0d9>] process_one_work+0xf9/0x370
>  [<ffffffffa0097ac0>] ? _mpt2sas_fw_work+0x240/0x240 [mpt2sas]
>  [<ffffffff8108ca1a>] worker_thread+0xca/0x240
>  [<ffffffff8108c950>] ? manage_workers+0x90/0x90
>  [<ffffffff81090ff7>] kthread+0x97/0xa0
>  [<ffffffff8150fdc4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff81090f60>] ? kthread_bind+0x80/0x80
>  [<ffffffff8150fdc0>] ? gs_change+0x13/0x13
> ---[ end trace 89a1351702ab360f ]---
> 
> During our test, multipath used, each LUN has 2 paths. when adding second
> path enclousure did not check if will adding device's symlink existed or no.
> 
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> ---
>  drivers/misc/enclosure.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 0e8df41..efc0e86 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -325,6 +325,13 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
>  	if (cdev->dev)
>  		enclosure_remove_links(cdev);
> 
> +	if (dev) {
> +		char name[ENCLOSURE_NAME_SIZE];
> +
> +		enclosure_link_name(cdev, name);
> +		sysfs_remove_link(&dev->kobj, name);
> +	}
> +
>  	put_device(cdev->dev);
>  	cdev->dev = get_device(dev);
>  	return enclosure_add_links(cdev);
> 

We've been looking at a similar issue with SAS multipath using the ipr driver.

Wendy, does this patch fix the issue you are seeing as well or is this a different
issue?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


