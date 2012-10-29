From: richard -rw- weinberger <richard.weinberger@gmail.com>
Subject: Re: WARNING: at fs/sysfs/inode.c:324 sysfs_hash_and_remove+0xa9/0xb0()
Date: Mon, 29 Oct 2012 18:08:22 +0100
Message-ID: <CAFLxGvxB0yH2qjOv9DfrAj9+ScCbHaY_gCCJ4HWadJHWKa4pLw@mail.gmail.com>
References: <5082D8AD.8060100@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5082D8AD.8060100@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, JBottomley@parallels.com, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 20, 2012 at 7:00 PM, Richard Weinberger <richard@nod.at> wrote:
> Hi!
>
> I can reliably trigger the following warning by physically detaching my disk
> array after
> stopping md1.
>
> ---cut---
> [  149.780554] md: md1 stopped.
> [  149.780559] md: unbind<sdh1>
> [  149.782025] md: export_rdev(sdh1)
> [  149.782039] md: unbind<sdg1>
> [  149.786026] md: export_rdev(sdg1)
> [  149.786038] md: unbind<sdf1>
> [  149.786122] md: export_rdev(sdf1)
> [  149.786135] md: unbind<sde1>
> [  149.786220] md: export_rdev(sde1)
> [  149.786232] md: unbind<sdd1>
> [  149.786320] md: export_rdev(sdd1)
> [  149.786332] md: unbind<sdc1>
> [  149.786414] md: export_rdev(sdc1)
> [  162.884735] sd 6:0:1:0: [sdc] Synchronizing SCSI cache
> [  162.884778] sd 6:0:1:0: [sdc]
> [  162.884781] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  162.885424] mpt2sas0: removing handle(0x000b),
> sas_addr(0x5003048001804ded)
> [  162.887671] sd 6:0:2:0: [sdd] Synchronizing SCSI cache
> [  162.887715] sd 6:0:2:0: [sdd]
> [  162.887719] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  162.888733] mpt2sas0: removing handle(0x000c),
> sas_addr(0x5003048001804dee)
> [  162.890003] sd 6:0:3:0: [sde] Synchronizing SCSI cache
> [  162.890041] sd 6:0:3:0: [sde]
> [  162.890044] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  162.890676] mpt2sas0: removing handle(0x000d),
> sas_addr(0x5003048001804df0)
> [  162.891345] sd 6:0:4:0: [sdf] Synchronizing SCSI cache
> [  162.891383] sd 6:0:4:0: [sdf]
> [  162.891385] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  162.892590] mpt2sas0: removing handle(0x000e),
> sas_addr(0x5003048001804df1)
> [  162.896152] sd 6:0:5:0: [sdg] Synchronizing SCSI cache
> [  162.896197] sd 6:0:5:0: [sdg]
> [  162.896201] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  162.896891] mpt2sas0: removing handle(0x000f),
> sas_addr(0x5003048001804df4)
> [  162.896896] mpt2sas0: removing handle(0x000a),
> sas_addr(0x5003048001804dfd)
> [  162.896899] mpt2sas0: removing handle(0x0010),
> sas_addr(0x5003048001804df7)
> [  162.898097] ------------[ cut here ]------------
> [  162.898105] WARNING: at
> /home/abuild/rpmbuild/BUILD/kernel-vanilla-3.6.2/linux-3.6/fs/sysfs/inode.c:324
> sysfs_hash_and_remove+0xa9/0xb0()
> [  162.898107] Hardware name: X9SCL/X9SCM
> [  162.898108] sysfs: can not remove 'device', no directory
> [  162.898110] Modules linked in: ses enclosure cpufreq_conservative
> cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf coretemp crc32c_intel
> ghash_clmulni_intel i2c_i801 iTCO_wdt kvm_intel sg iTCO_vendor_support
> e1000e lpc_ich mfd_core serio_raw joydev sr_mod kvm aesni_intel button cdrom
> ablk_helper cryptd video aes_x86_64 pcspkr microcode autofs4 raid456
> async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
> raid10 raid1 hid_generic usbhid raid0 mgag200 ttm drm_kms_helper drm
> ehci_hcd i2c_algo_bit sysimgblt sysfillrect syscopyarea usbcore usb_common
> thermal fan processor thermal_sys scsi_dh_emc scsi_dh_rdac scsi_dh_alua
> scsi_dh_hp_sw scsi_dh mpt2sas scsi_transport_sas raid_class
> [  162.898159] Pid: 84, comm: kworker/u:7 Not tainted 3.6.2-7-vanilla #1
> [  162.898161] Call Trace:
> [  162.898166]  [<ffffffff811c9600>] ? sysfs_hash_and_remove+0xa0/0xb0
> [  162.898172]  [<ffffffff8104095a>] warn_slowpath_common+0x7a/0xb0
> [  162.898176]  [<ffffffff81040a31>] warn_slowpath_fmt+0x41/0x50
> [  162.898180]  [<ffffffff811c9609>] sysfs_hash_and_remove+0xa9/0xb0
> [  162.898184]  [<ffffffff811cb911>] sysfs_remove_link+0x21/0x30
> [  162.898189]  [<ffffffffa027e8a8>] enclosure_remove_links+0x68/0x80
> [enclosure]
> [  162.898192]  [<ffffffff811cb1ae>] ? remove_dir+0x2e/0x40
> [  162.898196]  [<ffffffffa027e9af>] enclosure_component_release+0x1f/0x40
> [enclosure]
> [  162.898200]  [<ffffffff81398172>] device_release+0x22/0x90
> [  162.898205]  [<ffffffff812cd282>] kobject_cleanup+0x82/0x1b0
> [  162.898209]  [<ffffffff812cd10b>] kobject_put+0x2b/0x60
> [  162.898212]  [<ffffffff81397ee2>] put_device+0x12/0x20
> [  162.898215]  [<ffffffff81399105>] device_unregister+0x25/0x60
> [  162.898218]  [<ffffffffa027e5a2>] enclosure_unregister+0x82/0xb0
> [enclosure]
> [  162.898222]  [<ffffffffa028708d>] ses_intf_remove+0x7d/0xe0 [ses]
> [  162.898226]  [<ffffffff81398ff9>] device_del+0xc9/0x1b0
> [  162.898230]  [<ffffffff813990fd>] device_unregister+0x1d/0x60
> [  162.898236]  [<ffffffff813c1e15>] __scsi_remove_device+0xa5/0xc0
> [  162.898241]  [<ffffffff813c1e5a>] scsi_remove_device+0x2a/0x40
> [  162.898246]  [<ffffffff813c1fd8>] scsi_remove_target+0x148/0x200
> [  162.898256]  [<ffffffffa0008e75>] sas_rphy_remove+0x55/0x60
> [scsi_transport_sas]
> [  162.898264]  [<ffffffffa000b0d1>] sas_rphy_delete+0x11/0x20
> [scsi_transport_sas]
> [  162.898273]  [<ffffffffa000b105>] sas_port_delete+0x25/0x130
> [scsi_transport_sas]
> [  162.898281]  [<ffffffffa000b210>] ? sas_port_delete+0x130/0x130
> [scsi_transport_sas]
> [  162.898290]  [<ffffffffa000b255>] do_sas_phy_delete+0x45/0x50
> [scsi_transport_sas]
> [  162.898294]  [<ffffffff81398216>] device_for_each_child+0x36/0x70
> [  162.898302]  [<ffffffffa0008dfa>] sas_remove_children+0x1a/0x40
> [scsi_transport_sas]
> [  162.898310]  [<ffffffffa0008e6a>] sas_rphy_remove+0x4a/0x60
> [scsi_transport_sas]
> [  162.898318]  [<ffffffffa000b0d1>] sas_rphy_delete+0x11/0x20
> [scsi_transport_sas]
> [  162.898325]  [<ffffffffa000b105>] sas_port_delete+0x25/0x130
> [scsi_transport_sas]
> [  162.898337]  [<ffffffffa0030199>]
> mpt2sas_transport_port_remove+0x1b9/0x1d0 [mpt2sas]
> [  162.898348]  [<ffffffffa002adf0>] _scsih_expander_node_remove+0x80/0xc0
> [mpt2sas]
> [  162.898357]  [<ffffffffa002aefc>] mpt2sas_expander_remove+0xcc/0xe0
> [mpt2sas]
> [  162.898367]  [<ffffffffa002c0f7>] _firmware_event_work+0x11e7/0x14b0
> [mpt2sas]
> [  162.898372]  [<ffffffff8105b968>] ? cwq_activate_delayed_work+0x38/0x80
> [  162.898376]  [<ffffffff8105bb81>] process_one_work+0x131/0x4d0
> [  162.898385]  [<ffffffffa002af10>] ? mpt2sas_expander_remove+0xe0/0xe0
> [mpt2sas]
> [  162.898414]  [<ffffffff8105c80e>] worker_thread+0x15e/0x470
> [  162.898418]  [<ffffffff8105c6b0>] ? manage_workers+0x2f0/0x2f0
> [  162.898424]  [<ffffffff8106277e>] kthread+0x8e/0xa0
> [  162.898431]  [<ffffffff81565d24>] kernel_thread_helper+0x4/0x10
> [  162.898436]  [<ffffffff810626f0>] ?
> kthread_freezable_should_stop+0x60/0x60
> [  162.898441]  [<ffffffff81565d20>] ? gs_change+0xb/0xb
> [  162.898443] ---[ end trace 79e761c96dd48155 ]---
> [  162.900031] sd 6:0:6:0: [sdh] Synchronizing SCSI cache
> [  162.900075] sd 6:0:6:0: [sdh]
> [  162.900077] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> [  162.910855] mpt2sas0: expander_remove: handle(0x0009),
> sas_addr(0x5003048001804dff)
> ---cut---

*ping*

-- 
Thanks,
//richard
