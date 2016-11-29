From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Tue, 29 Nov 2016 01:52:58 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B0CCCB7@avsrvexchmbx1.microsemi.net>
References: <20161121140429.12788-1-mwilck@suse.de>
 <20161121140429.12788-2-mwilck@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0089.outbound.protection.outlook.com ([104.47.32.89]:1728
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750754AbcK2Bx0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 20:53:26 -0500
In-Reply-To: <20161121140429.12788-2-mwilck@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.de>
Cc: dl-esc-Team ESD Storage Dev Support <esc-TeamESDStorageDevSupport@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

> -----Original Message-----
> From: Martin Wilck [mailto:mwilck@suse.de]
> Sent: Monday, November 21, 2016 8:04 AM
> To: Don Brace
> Cc: dl-esc-Team ESD Storage Dev Support; iss_storagedev@hp.com; linux-
> scsi@vger.kernel.org; JBottomley@odin.com; hch@lst.de; hare@suse.de;
> Martin Wilck
> Subject: [PATCH 1/2] hpsa: cleanup sas_phy structures in sysfs when
> unloading
>=20
> EXTERNAL EMAIL
>=20
>=20
> When the hpsa module is unloaded using rmmod, dangling
> symlinks remain under /sys/class/sas_phy. Fix this by
> calling sas_phy_delete() rather than sas_phy_free (which,
> according to comments, should not be called for PHYs that
> have been set up successfully, anyway).
>=20
> References: bsc#1010946.
> Signed-off-by: Martin Wilck <mwilck@suse.de>
> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index efe2f36..8ec77c3 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -9547,9 +9547,9 @@ static void hpsa_free_sas_phy(struct hpsa_sas_phy
> *hpsa_sas_phy)
>         struct sas_phy *phy =3D hpsa_sas_phy->phy;
>=20
>         sas_port_delete_phy(hpsa_sas_phy->parent_port->port, phy);
> -       sas_phy_free(phy);
>         if (hpsa_sas_phy->added_to_port)
>                 list_del(&hpsa_sas_phy->phy_list_entry);
> +       sas_phy_delete(phy);
>         kfree(hpsa_sas_phy);
>  }
>=20
> --
> 2.10.1

I tried these patches on: 4.9.0-rc7, was this correct?

I got the following stack trace:
[  231.192289] ------------[ cut here ]------------
[  231.214333] WARNING: CPU: 51 PID: 15876 at fs/sysfs/group.c:237 sysfs_re=
move_group+0x8e/0x90
[  231.254371] sysfs group 'power' not found for kobject '4:0:0:0'
[  231.282637] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 =
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv=
4 nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat ebta=
ble_broute bridge stp llc ebtable_filter ebtables ip6table_mangle ip6table_=
security ip6table_raw ip6table_filter ip6_tables iptable_mangle iptable_sec=
urity iptable_raw iptable_filter ip_tables sb_edac edac_core x86_pkg_temp_t=
hermal coretemp crct10dif_pclmul crc32_pclmul iTCO_wdt ghash_clmulni_intel =
iTCO_vendor_support aesni_intel lrw gf128mul glue_helper ablk_helper cryptd=
 osst pcspkr ch st ioatdma lpc_ich hpilo hpwdt mfd_core dca ipmi_si ipmi_ms=
ghandler pcc_cpufreq wmi acpi_cpufreq acpi_power_meter uinput mgag200 i2c_a=
lgo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops
[  231.620046]  ttm drm crc32c_intel tg3 serio_raw ptp usb_storage i2c_core=
 hpsa(-) pps_core scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  231.676364] CPU: 51 PID: 15876 Comm: rmmod Not tainted 4.9.0-rc7+ #22
[  231.706769] Hardware name: HP ProLiant DL580 Gen8, BIOS P79 08/18/2016
[  231.737730]  ffffc9002123bbf0 ffffffff815909bd ffffc9002123bc40 00000000=
00000000
[  231.772474]  ffffc9002123bc30 ffffffff81090901 000000ed00000246 00000000=
00000000
[  231.807897]  ffffffff81f71560 ffff8820529faea8 ffff88205542ea60 00000000=
024b0090
[  231.842671] Call Trace:
[  231.854426]  [<ffffffff815909bd>] dump_stack+0x85/0xc8
[  231.878826]  [<ffffffff81090901>] __warn+0xd1/0xf0
[  231.901476]  [<ffffffff8109097f>] warn_slowpath_fmt+0x5f/0x80
[  231.929515]  [<ffffffff8196e5de>] ? mutex_unlock+0xe/0x10
[  231.955067]  [<ffffffff812f1a6a>] ? kernfs_find_and_get_ns+0x4a/0x60
[  231.985095]  [<ffffffff812f56ae>] sysfs_remove_group+0x8e/0x90
[  232.012416]  [<ffffffff816dd1b7>] dpm_sysfs_remove+0x57/0x60
[  232.038904]  [<ffffffff816cf928>] device_del+0x58/0x270
[  232.064056]  [<ffffffff816cfb5a>] device_unregister+0x1a/0x60
[  232.091138]  [<ffffffff8157d470>] bsg_unregister_queue+0x60/0xa0
[  232.119498]  [<ffffffff8170e2ea>] __scsi_remove_device+0xaa/0xd0
[  232.147745]  [<ffffffff8170c369>] scsi_forget_host+0x69/0x70
[  232.174666]  [<ffffffff816ff292>] scsi_remove_host+0x82/0x130
[  232.201804]  [<ffffffffa007cfc3>] hpsa_remove_one+0x93/0x190 [hpsa]
[  232.231329]  [<ffffffff815dd8d9>] pci_device_remove+0x39/0xc0
[  232.258089]  [<ffffffff816d4aca>] __device_release_driver+0x9a/0x150
[  232.288005]  [<ffffffff816d4ca1>] driver_detach+0xc1/0xd0
[  232.313479]  [<ffffffff816d3a98>] bus_remove_driver+0x58/0xd0
[  232.341280]  [<ffffffff816d572c>] driver_unregister+0x2c/0x50
[  232.369272]  [<ffffffff815dbf3a>] pci_unregister_driver+0x2a/0x80
[  232.398723]  [<ffffffffa0085869>] hpsa_cleanup+0x10/0x7a7 [hpsa]
[  232.428094]  [<ffffffff8113571c>] SyS_delete_module+0x1bc/0x220
[  232.456716]  [<ffffffff81003c0c>] do_syscall_64+0x6c/0x200
[  232.483125]  [<ffffffff81971d49>] entry_SYSCALL64_slow_path+0x25/0x25
[  232.514162] ---[ end trace 3c490662736284eb ]---


Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation
