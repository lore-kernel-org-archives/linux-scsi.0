From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: sysfs group not found for kobject on mpt2sas unload
Date: Mon, 25 Nov 2013 11:23:39 -0500
Message-ID: <20131125112339.45e279db@jlaw-desktop.mno.stratus.com>
References: <20131120140840.4d1f23ca@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:60355 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab3KYQXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Nov 2013 11:23:43 -0500
In-Reply-To: <20131120140840.4d1f23ca@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, Mika Westerberg <mika.westerberg@linux.intel.com>

On Wed, 20 Nov 2013 14:08:40 -0500
Joe Lawrence <joe.lawrence@stratus.com> wrote:

> Starting in 3.12, when loading and unloading the mpt2sas driver, I see
> the following warning:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 20 PID: 19096 at fs/sysfs/group.c:214 sysfs_remove_group+0xc6/0xd0()
> sysfs group ffffffff81ca2f40 not found for kobject 'end_device-30:0'
> Modules linked in: mpt2sas(-) stap_edcc1781e2697fc53c3d320bc2530218_19063(OF) ebtable_nat osst nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack bonding ebtable_filter ebtables ip6table_filter ip6_tables ixgbe igb x86_pkg_temp_thermal ptp coretemp pps_core joydev mdio crc32_pclmul crc32c_intel raid_class pcspkr ghash_clmulni_intel scsi_transport_sas ipmi_si dca ipmi_msghandler ntb uinput dm_round_robin sd_mod qla2xxx syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper ttm drm scsi_transport_fc scsi_tgt usb_storage i2c_core dm_multipath [last unloaded: stap_2da929a187c82c607a2323
 7c27bf2d06_18803]
> CPU: 20 PID: 19096 Comm: rmmod Tainted: GF       W  O 3.12.0+ #4
> Hardware name: Stratus ftServer 6400/G7LAZ, BIOS BIOS Version 6.2:52 04/09/2013
>  0000000000000009 ffff88083ad3bb88 ffffffff8165265e ffff88083ad3bbd0
>  ffff88083ad3bbc0 ffffffff8105514d 0000000000000000 ffffffff81ca2f40
>  ffff880851f46ef8 ffff88007a73cf38 ffff88083fb8c6e8 ffff88083ad3bc20
> Call Trace:
>  [<ffffffff8165265e>] dump_stack+0x4d/0x66
>  [<ffffffff8105514d>] warn_slowpath_common+0x7d/0xa0
>  [<ffffffff810551bc>] warn_slowpath_fmt+0x4c/0x50
>  [<ffffffff8121873e>] ? sysfs_get_dirent_ns+0x4e/0x70
>  [<ffffffff81219a46>] sysfs_remove_group+0xc6/0xd0
>  [<ffffffff813edb43>] dpm_sysfs_remove+0x43/0x50
>  [<ffffffff813e38c5>] device_del+0x45/0x1c0
>  [<ffffffff813e3a5e>] device_unregister+0x1e/0x60
>  [<ffffffff812eb9ce>] bsg_unregister_queue+0x5e/0xa0
>  [<ffffffffa00dd0ba>] sas_rphy_free+0x7a/0xb0 [scsi_transport_sas]
>  [<ffffffffa00def95>] sas_port_delete+0x35/0x160 [scsi_transport_sas]
>  [<ffffffff81218c53>] ? sysfs_remove_link+0x23/0x30
>  [<ffffffffa023662a>] mpt2sas_transport_port_remove+0x19a/0x1e0 [mpt2sas]
>  [<ffffffffa0227b10>] _scsih_remove_device+0xb0/0x100 [mpt2sas]
>  [<ffffffffa022f519>] mpt2sas_device_remove_by_sas_address.part.54+0x59/0x80 [mpt2sas]
>  [<ffffffffa02322f9>] _scsih_remove+0xf9/0x210 [mpt2sas]
>  [<ffffffff8133108b>] pci_device_remove+0x3b/0xb0
>  [<ffffffff813e759f>] __device_release_driver+0x7f/0xf0
>  [<ffffffff813e7f20>] driver_detach+0xc0/0xd0
>  [<ffffffff813e71d5>] bus_remove_driver+0x55/0xd0
>  [<ffffffff813e853c>] driver_unregister+0x2c/0x50
>  [<ffffffff8132fbb3>] pci_unregister_driver+0x23/0x80
>  [<ffffffffa023b713>] _scsih_exit+0x25/0x912 [mpt2sas]
>  [<ffffffff810c93ed>] SyS_delete_module+0x16d/0x2d0
>  [<ffffffff8165d81e>] ? do_page_fault+0xe/0x10
>  [<ffffffff81661dd2>] system_call_fastpath+0x16/0x1b
> ---[ end trace b4eef98870c871fd ]---
> 
> Instrumenting the module loading/unloading cycle with systemtap, it
> reports the following sequence of events:
> 
> modprobe
>   device_add(A)
>   device_add(B child of A)
>   device_add(C child of A)
>   device_add(D child of A)
> 
> rmmod
>   device_del(B child of A)
>   device_del(C child of A)
>   device_del(A)
>   device_del(D child of A)             << WARNING
> 
> The same sequence of device_add/del events occur in 3.11, but without
> the warning.  Git bisect shows bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
> "sysfs: make __sysfs_remove_dir() recursive" as the first bad commit.
> 

FWIW, I applied Mika's patch that Tejun posted the other day, "sysfs:
handle duplicate removal attempts in sysfs_remove_group()" [1] and the
warning goes away on mpt2sas unload.

[1] http://git.kernel.org/cgit/linux/kernel/git/tj/misc.git/commit/?h=review-sysfs-fixes&id=a69cc96d8c434c6cb64847f37caa890af705fc5c

-- Joe
