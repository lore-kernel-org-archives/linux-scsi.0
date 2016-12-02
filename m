From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 0/2] hpsa: fix rmmod issues
Date: Fri, 2 Dec 2016 15:44:38 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D1941807369@avsrvexchmbx1.microsemi.net>
References: <20161121140429.12788-1-mwilck@suse.de>
         <4993A297653ECB4581FA5C3C31323D194180229D@avsrvexchmbx1.microsemi.net>,<1480669138.3552.23.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0084.outbound.protection.outlook.com ([104.47.36.84]:56301
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1761744AbcLBPoo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 10:44:44 -0500
In-Reply-To: <1480669138.3552.23.camel@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.de>
Cc: dl-esc-Team ESD Storage Dev Support <esc-TeamESDStorageDevSupport@microsemi.com>, "iss_storagedev@hp.com" <iss_storagedev@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "jthumshirn@suse.com" <jthumshirn@suse.com>

________________________________________=0A=
From: Martin Wilck [mwilck@suse.de]=0A=
Sent: Friday, December 02, 2016 12:58 AM=0A=
To: Don Brace=0A=
Cc: dl-esc-Team ESD Storage Dev Support; iss_storagedev@hp.com; linux-scsi@=
vger.kernel.org; James Bottomley; hch@lst.de; hare@suse.de; jthumshirn@suse=
.com=0A=
Subject: Re: [PATCH 0/2] hpsa: fix rmmod issues=0A=
=0A=
EXTERNAL EMAIL=0A=
=0A=
=0A=
On Thu, 2016-12-01 at 23:22 +0000, Don Brace wrote:=0A=
> > -----Original Message-----=0A=
> > From: Martin Wilck [mailto:mwilck@suse.de]=0A=
> > Sent: Monday, November 21, 2016 8:04 AM=0A=
> > To: Don Brace=0A=
> > Cc: dl-esc-Team ESD Storage Dev Support; iss_storagedev@hp.com;=0A=
> > linux-=0A=
> > scsi@vger.kernel.org; JBottomley@odin.com; hch@lst.de; hare@suse.de=0A=
> > ;=0A=
> > Martin Wilck=0A=
> > Subject: [PATCH 0/2] hpsa: fix rmmod issues=0A=
> >=0A=
> > EXTERNAL EMAIL=0A=
> >=0A=
> >=0A=
> > This patch set fixes two issues I encountered when removing the=0A=
> > hpsa modules with rmmod.=0A=
> >=0A=
> > Comments and reviews are welcome.=0A=
> >=0A=
> > Martin Wilck (2):=0A=
> >   hpsa: cleanup sas_phy structures in sysfs when unloading=0A=
> >   hpsa: destroy sas transport properties before scsi_host=0A=
> >=0A=
> >  drivers/scsi/hpsa.c | 4 ++--=0A=
> >  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> >=0A=
> > --=0A=
> > 2.10.1=0A=
>=0A=
> I have both patches applied and I still get stack traces.=0A=
=0A=
Hm,=0A=
=0A=
there must be a difference between 4.9.0 and the SUSE kernel that I=0A=
tested with, then. To be certain, you did NOT see a stack trace at=0A=
rmmod before applying my patches?=0A=
=0A=
I can see that your trace occurs in a different code path=0A=
(bsg_unregister_queue()) than the ones I observed=0A=
(sas_port_delete()/sas_phy_delete()). CC'ing Johannes who alluded to a=0A=
generic problem in the SCSI stack during our internal discussion.=0A=
=0A=
Anyway, I'll have another look.=0A=
=0A=
Regards=0A=
Martin=0A=
=0A=
I do see a stack trace before your patches. You patches have made a differe=
nce.=0A=
I am not yet sure when they started,. Will have to start doing some more in=
vestigation also,=0A=
=0A=
Appreciate the help.=0A=
=0A=
Thanks,=0A=
Don=0A=
=0A=
>=0A=
>=0A=
>=0A=
> [252338.604903] ------------[ cut here ]------------=0A=
> [252338.627899] WARNING: CPU: 69 PID: 23977 at fs/sysfs/group.c:237=0A=
> sysfs_remove_group+0x8e/0x90=0A=
> [252338.668726] sysfs group 'power' not found for kobject '5:0:0:0'=0A=
> [252338.697526] Modules linked in: hpsa(OE-) scsi_transport_sas(OE)=0A=
> ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6=0A=
> nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4=0A=
> nf_defrag_ipv4 xt_conntrack nf_conntrack cfg80211 rfkill ebtable_nat=0A=
> ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_mangle=0A=
> ip6table_security ip6table_raw ip6table_filter ip6_tables=0A=
> iptable_mangle iptable_security iptable_raw iptable_filter ip_tables=0A=
> osst ch st sb_edac edac_core x86_pkg_temp_thermal coretemp=0A=
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel lrw=0A=
> iTCO_wdt gf128mul glue_helper iTCO_vendor_support ablk_helper cryptd=0A=
> pcspkr ioatdma lpc_ich hpwdt hpilo mfd_core dca ipmi_si wmi=0A=
> ipmi_msghandler pcc_cpufreq acpi_cpufreq acpi_power_meter uinput=0A=
> mgag200 i2c_algo_bit drm_kms_helper syscopyarea=0A=
> [252339.038528]=A0=A0sysfillrect sysimgblt fb_sys_fops ttm drm=0A=
> crc32c_intel serio_raw tg3 ptp usb_storage i2c_core pps_core=0A=
> dm_mirror dm_region_hash dm_log dm_mod [last unloaded:=0A=
> scsi_transport_sas]=0A=
> [252339.113923] CPU: 69 PID: 23977 Comm: rmmod Tainted:=0A=
> G        W  OE   4.9.0-rc71+ #24=0A=
> [252339.151296] Hardware name: HP ProLiant DL580 Gen8, BIOS P79=0A=
> 08/18/2016=0A=
> [252339.183354]=A0=A0ffffc9000ff1bbf0 ffffffff815909bd ffffc9000ff1bc40=
=0A=
> 0000000000000000=0A=
> [252339.219046]=A0=A0ffffc9000ff1bc30 ffffffff81090901 000000ed00000246=
=0A=
> 0000000000000000=0A=
> [252339.255044]=A0=A0ffffffff81f71560 ffff88204584dd38 ffff882051e93670=
=0A=
> 0000000000ae1090=0A=
> [252339.290927] Call Trace:=0A=
> [252339.303968]=A0=A0[<ffffffff815909bd>] dump_stack+0x85/0xc8=0A=
> [252339.329624]=A0=A0[<ffffffff81090901>] __warn+0xd1/0xf0=0A=
> [252339.354037]=A0=A0[<ffffffff8109097f>] warn_slowpath_fmt+0x5f/0x80=0A=
> [252339.382084]=A0=A0[<ffffffff8196e5de>] ? mutex_unlock+0xe/0x10=0A=
> [252339.408515]=A0=A0[<ffffffff812f1a6a>] ?=0A=
> kernfs_find_and_get_ns+0x4a/0x60=0A=
> [252339.439571]=A0=A0[<ffffffff812f56ae>] sysfs_remove_group+0x8e/0x90=0A=
> [252339.468069]=A0=A0[<ffffffff816dd1b7>] dpm_sysfs_remove+0x57/0x60=0A=
> [252339.495701]=A0=A0[<ffffffff816cf928>] device_del+0x58/0x270=0A=
> [252339.521474]=A0=A0[<ffffffff816cfb5a>] device_unregister+0x1a/0x60=0A=
> [252339.549796]=A0=A0[<ffffffff8157d470>] bsg_unregister_queue+0x60/0xa0=
=0A=
> [252339.578999]=A0=A0[<ffffffff8170e2ea>] __scsi_remove_device+0xaa/0xd0=
=0A=
> [252339.608230]=A0=A0[<ffffffff8170c369>] scsi_forget_host+0x69/0x70=0A=
> [252339.635723]=A0=A0[<ffffffff816ff292>] scsi_remove_host+0x82/0x130=0A=
> [252339.663738]=A0=A0[<ffffffffa038cfc3>] hpsa_remove_one+0x93/0x190=0A=
> [hpsa]=0A=
> [252339.694960]=A0=A0[<ffffffff815dd8d9>] pci_device_remove+0x39/0xc0=0A=
> [252339.723128]=A0=A0[<ffffffff816d4aca>]=0A=
> __device_release_driver+0x9a/0x150=0A=
> [252339.753539]=A0=A0[<ffffffff816d4ca1>] driver_detach+0xc1/0xd0=0A=
> [252339.779784]=A0=A0[<ffffffff816d3a98>] bus_remove_driver+0x58/0xd0=0A=
> [252339.807519]=A0=A0[<ffffffff816d572c>] driver_unregister+0x2c/0x50=0A=
> [252339.835948]=A0=A0[<ffffffff815dbf3a>] pci_unregister_driver+0x2a/0x80=
=0A=
> [252339.865660]=A0=A0[<ffffffffa0395869>] hpsa_cleanup+0x10/0x7a7 [hpsa]=
=0A=
> [252339.894682]=A0=A0[<ffffffff8113571c>] SyS_delete_module+0x1bc/0x220=
=0A=
> [252339.924020]=A0=A0[<ffffffff81003c0c>] do_syscall_64+0x6c/0x200=0A=
> [252339.950862]=A0=A0[<ffffffff81971d49>]=0A=
> entry_SYSCALL64_slow_path+0x25/0x25=0A=
> [252339.982292] ---[ end trace 03cf2c42f2f658e5 ]---=0A=
=0A=
