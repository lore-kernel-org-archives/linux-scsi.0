From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH 0/2] hpsa: fix rmmod issues
Date: Fri, 02 Dec 2016 09:58:58 +0100
Message-ID: <1480669138.3552.23.camel@suse.de>
References: <20161121140429.12788-1-mwilck@suse.de>
         <4993A297653ECB4581FA5C3C31323D194180229D@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38693 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758762AbcLBI7D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 03:59:03 -0500
In-Reply-To: <4993A297653ECB4581FA5C3C31323D194180229D@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: dl-esc-Team ESD Storage Dev Support <esc-TeamESDStorageDevSupport@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, jthumshirn@suse.com

On Thu, 2016-12-01 at 23:22 +0000, Don Brace wrote:
> > -----Original Message-----
> > From: Martin Wilck [mailto:mwilck@suse.de]
> > Sent: Monday, November 21, 2016 8:04 AM
> > To: Don Brace
> > Cc: dl-esc-Team ESD Storage Dev Support; iss_storagedev@hp.com;
> > linux-
> > scsi@vger.kernel.org; JBottomley@odin.com; hch@lst.de; hare@suse.de
> > ;
> > Martin Wilck
> > Subject: [PATCH 0/2] hpsa: fix rmmod issues
> > 
> > EXTERNAL EMAIL
> > 
> > 
> > This patch set fixes two issues I encountered when removing the
> > hpsa modules with rmmod.
> > 
> > Comments and reviews are welcome.
> > 
> > Martin Wilck (2):
> >   hpsa: cleanup sas_phy structures in sysfs when unloading
> >   hpsa: destroy sas transport properties before scsi_host
> > 
> >  drivers/scsi/hpsa.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --
> > 2.10.1
> 
> I have both patches applied and I still get stack traces.

Hm, 

there must be a difference between 4.9.0 and the SUSE kernel that I
tested with, then. To be certain, you did NOT see a stack trace at
rmmod before applying my patches?

I can see that your trace occurs in a different code path
(bsg_unregister_queue()) than the ones I observed
(sas_port_delete()/sas_phy_delete()). CC'ing Johannes who alluded to a
generic problem in the SCSI stack during our internal discussion.

Anyway, I'll have another look.

Regards
Martin


> 
> 
> 
> [252338.604903] ------------[ cut here ]------------
> [252338.627899] WARNING: CPU: 69 PID: 23977 at fs/sysfs/group.c:237
> sysfs_remove_group+0x8e/0x90
> [252338.668726] sysfs group 'power' not found for kobject '5:0:0:0'
> [252338.697526] Modules linked in: hpsa(OE-) scsi_transport_sas(OE)
> ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
> nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4
> nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat
> ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle
> ip6table_security ip6table_raw ip6table_filter ip6_tables
> iptable_mangle iptable_security iptable_raw iptable_filter ip_tables
> osst ch st sb_edac edac_core x86_pkg_temp_thermal coretemp
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw
> iTCO_wdt gf128mul glue_helper iTCO_vendor_support ablk_helper cryptd
> pcspkr ioatdma lpc_ich hpwdt hpilo mfd_core dca ipmi_si wmi
> ipmi_msghandler pcc_cpufreq acpi_cpufreq acpi_power_meter uinput
> mgag200 i2c_algo_bit drm_kms_helper syscopyarea
> [252339.038528]  sysfillrect sysimgblt fb_sys_fops ttm drm
> crc32c_intel serio_raw tg3 ptp usb_storage i2c_core pps_core
> dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
> scsi_transport_sas]
> [252339.113923] CPU: 69 PID: 23977 Comm: rmmod Tainted:
> G        W  OE   4.9.0-rc71+ #24
> [252339.151296] Hardware name: HP ProLiant DL580 Gen8, BIOS P79
> 08/18/2016
> [252339.183354]  ffffc9000ff1bbf0 ffffffff815909bd ffffc9000ff1bc40
> 0000000000000000
> [252339.219046]  ffffc9000ff1bc30 ffffffff81090901 000000ed00000246
> 0000000000000000
> [252339.255044]  ffffffff81f71560 ffff88204584dd38 ffff882051e93670
> 0000000000ae1090
> [252339.290927] Call Trace:
> [252339.303968]  [<ffffffff815909bd>] dump_stack+0x85/0xc8
> [252339.329624]  [<ffffffff81090901>] __warn+0xd1/0xf0
> [252339.354037]  [<ffffffff8109097f>] warn_slowpath_fmt+0x5f/0x80
> [252339.382084]  [<ffffffff8196e5de>] ? mutex_unlock+0xe/0x10
> [252339.408515]  [<ffffffff812f1a6a>] ?
> kernfs_find_and_get_ns+0x4a/0x60
> [252339.439571]  [<ffffffff812f56ae>] sysfs_remove_group+0x8e/0x90
> [252339.468069]  [<ffffffff816dd1b7>] dpm_sysfs_remove+0x57/0x60
> [252339.495701]  [<ffffffff816cf928>] device_del+0x58/0x270
> [252339.521474]  [<ffffffff816cfb5a>] device_unregister+0x1a/0x60
> [252339.549796]  [<ffffffff8157d470>] bsg_unregister_queue+0x60/0xa0
> [252339.578999]  [<ffffffff8170e2ea>] __scsi_remove_device+0xaa/0xd0
> [252339.608230]  [<ffffffff8170c369>] scsi_forget_host+0x69/0x70
> [252339.635723]  [<ffffffff816ff292>] scsi_remove_host+0x82/0x130
> [252339.663738]  [<ffffffffa038cfc3>] hpsa_remove_one+0x93/0x190
> [hpsa]
> [252339.694960]  [<ffffffff815dd8d9>] pci_device_remove+0x39/0xc0
> [252339.723128]  [<ffffffff816d4aca>]
> __device_release_driver+0x9a/0x150
> [252339.753539]  [<ffffffff816d4ca1>] driver_detach+0xc1/0xd0
> [252339.779784]  [<ffffffff816d3a98>] bus_remove_driver+0x58/0xd0
> [252339.807519]  [<ffffffff816d572c>] driver_unregister+0x2c/0x50
> [252339.835948]  [<ffffffff815dbf3a>] pci_unregister_driver+0x2a/0x80
> [252339.865660]  [<ffffffffa0395869>] hpsa_cleanup+0x10/0x7a7 [hpsa]
> [252339.894682]  [<ffffffff8113571c>] SyS_delete_module+0x1bc/0x220
> [252339.924020]  [<ffffffff81003c0c>] do_syscall_64+0x6c/0x200
> [252339.950862]  [<ffffffff81971d49>]
> entry_SYSCALL64_slow_path+0x25/0x25
> [252339.982292] ---[ end trace 03cf2c42f2f658e5 ]---

