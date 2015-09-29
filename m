From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH] hpsa update
Date: Tue, 29 Sep 2015 17:21:48 -0500
Message-ID: <20150929221748.6433.53593.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54672 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbbI2WZH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 18:25:07 -0400
Received: from bby1mta03.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id 54EBF10707DB
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:25:06 -0700 (PDT)
Received: from bby1uinfra02-temp.pmc-sierra.bc.ca (bby1uinfra02-temp.pmc-sierra.bc.ca [216.241.226.204])
	by bby1mta03.pmc-sierra.bc.ca (Postfix) with ESMTP id 37C2610707BE
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:25:06 -0700 (PDT)
Received: from [127.0.1.1] (kirk.hou.lab.pmc-sierra.bc.ca [10.238.32.34])
	by bby1uinfra02-temp.pmc-sierra.bc.ca (Postfix) with ESMTP id 0DE5BE06DF
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2015 15:25:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is based on Linus's tree

I could use some help with this patch.

We are adding in the sas transport layer for our HBA devices. 
I am having issues removing the sas transport entries during driver
unload. The entries are removed in what appears to be the proper order
but I am getting a bunch of warnings that look like what is shown below.

I do not see these warnings with 3.10 kernels but I do see them with
4.3-rc2+.

I have searched the lkml mailing list for resolution and found a 
fix for a similar issue:
http://marc.info/?l=linux-scsi&m=143743743518987&w=2

But this did not resolve my problem.

I am attaching the patch and the console logs. Can anyone give me some
advice with this issue?

Typical warning message: (Seen for both port and end_device objects)

[  247.567655] WARNING: CPU: 52 PID: 14975 at fs/sysfs/group.c:224 sysfs_remove_group+0x8d/0x90()
[  247.611154] sysfs group ffffffff81a73000 not found for kobject 'port-5:0'
[  247.645110] Modules linked in: hpsa(OE-) scsi_transport_sas ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack cfg80211 nf_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_security iptable_raw iptable_filter ip_tables sg x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul nfsd crc32c_intel ghash_clmulni_intel aesni_intel lrw gf128mul auth_rpcgss ipmi_devintf hpilo hpwdt glue_helper sb_edac nfs_acl iTCO_wdt ablk_helper lockd cryptd iTCO_vendor_support edac_core serio_raw ioatdma shpchp pcspkr ipmi_si lpc_ich wmi mfd_core dca ipmi_msghandler gra
 ce pcc_cpufreq
[  248.001829]  acpi_power_meter acpi_cpufreq sunrpc uinput xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm usb_storage tg3 ptp i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
[  248.102395] CPU: 52 PID: 14975 Comm: rmmod Tainted: G           OE   4.3.0-rc2+ #1
[  248.140420] Hardware name: HP ProLiant DL580 Gen8, BIOS P79 05/06/2015
[  248.172430]  0000000000000000 00000000dce8a349 ffff8808582afb78 ffffffff81312230
[  248.209532]  ffff8808582afbc0 ffff8808582afbb0 ffffffff8107ae26 0000000000000000
[  248.246473]  ffffffff81a73000 ffff881858a55838 ffff881858a50c00 ffff881858a50f10
[  248.283094] Call Trace:
[  248.295019]  [<ffffffff81312230>] dump_stack+0x44/0x64
[  248.320346]  [<ffffffff8107ae26>] warn_slowpath_common+0x86/0xc0
[  248.351167]  [<ffffffff8107aebc>] warn_slowpath_fmt+0x5c/0x80
[  248.379273]  [<ffffffff8126b508>] ? kernfs_find_and_get_ns+0x48/0x60
[  248.410729]  [<ffffffff8126ea5d>] sysfs_remove_group+0x8d/0x90
[  248.439875]  [<ffffffff81440877>] dpm_sysfs_remove+0x57/0x60
[  248.468564]  [<ffffffff81434378>] device_del+0x58/0x260
[  248.494859]  [<ffffffff814339a9>] ? device_remove_file+0x19/0x20
[  248.524099]  [<ffffffff8143d8da>] attribute_container_class_device_del+0x1a/0x20
[  248.560407]  [<ffffffff8143dade>] transport_remove_classdev+0x4e/0x60
[  248.591673]  [<ffffffff8143da90>] ? transport_add_class_device+0x40/0x40
[  248.626510]  [<ffffffff8143d4be>] attribute_container_device_trigger+0xce/0xe0
[  248.661392]  [<ffffffff8143da45>] transport_remove_device+0x15/0x20
[  248.692653]  [<ffffffffa03eaec3>] sas_port_delete+0x123/0x150 [scsi_transport_sas]
[  248.732777]  [<ffffffffa03f4c72>] hpsa_free_sas_port+0x42/0xc0 [hpsa]
[  248.769411]  [<ffffffffa03f6e4c>] hpsa_free_sas_node.part.58+0x7c/0xb0 [hpsa]
[  248.805243]  [<ffffffffa03fc10a>] hpsa_remove_one+0x1aa/0x1f0 [hpsa]
[  248.836752]  [<ffffffff813505b9>] pci_device_remove+0x39/0xc0
[  248.864460]  [<ffffffff81439216>] __device_release_driver+0x96/0x130
[  248.894875]  [<ffffffff814393b5>] driver_detach+0xb5/0xc0
[  248.920994]  [<ffffffff81438395>] bus_remove_driver+0x55/0xd0
[  248.949451]  [<ffffffff81439b1c>] driver_unregister+0x2c/0x50
[  248.977606]  [<ffffffff8134ecfa>] pci_unregister_driver+0x2a/0x80
[  249.007758]  [<ffffffffa0402df7>] hpsa_cleanup+0x10/0x219 [hpsa]
[  249.037334]  [<ffffffff810fbebd>] SyS_delete_module+0x18d/0x220
[  249.066208]  [<ffffffff81003cd5>] ? syscall_return_slowpath+0x55/0x150
[  249.098215]  [<ffffffff8166b0ee>] entry_SYSCALL_64_fastpath+0x12/0x71
[  249.130809] ---[ end trace da8892bb8b64bbf0 ]---

---

Kevin Barnett (1):
      hpsa: add in sas transport


 drivers/scsi/hpsa.c     |  704 ++++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/hpsa.h     |   37 ++
 drivers/scsi/hpsa_cmd.h |   14 +
 3 files changed, 677 insertions(+), 78 deletions(-)

--
Signature
