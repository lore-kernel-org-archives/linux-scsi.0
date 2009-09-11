From: Sergey Temerkhanov <temerkhanov@yandex.ru>
Subject: BUG: bnx2i: scheduling while atomic while modprobing bnx2i module
Date: Fri, 11 Sep 2009 07:12:51 +0400
Message-ID: <10381252638771@webmail104.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from forward14.yandex.ru ([95.108.130.92]:40856 "EHLO
	forward14.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbZIKDTS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2009 23:19:18 -0400
Received: from webmail104.yandex.ru (webmail104.yandex.ru [95.108.130.7])
	by forward14.yandex.ru (Yandex) with ESMTP id 9AF362680AA6
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2009 07:12:51 +0400 (MSD)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by webmail104.yandex.ru (Yandex) with ESMTP id 8D0CD36E8001
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2009 07:12:51 +0400 (MSD)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I'm getting the scheduling while atomic bug while modprobing bnx2i module on 2.6.31. Here's the report from kernel:

Broadcom NetXtreme II iSCSI Driver bnx2i v2.0.1d (Mar 25, 2009)
iscsi: registered transport (bnx2i)
BUG: scheduling while atomic: modprobe/9170/0x00000002
Modules linked in: bnx2i(+) libiscsi scsi_transport_iscsi nfsd bnep rfcomm l2cap bluetooth snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ip6table_filter ip6_tables ipt_LOG xt_recent xt_state xt_tcpudp iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables cpufreq_powersave cnic uio ipv6 snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec bnx2 shpchp snd_hwdep psmouse snd_pcm pci_hotplug snd_timer pcspkr wmi snd firewire_ohci firewire_core soundcore rtc thermal snd_page_alloc asus_atk0110 processor button tg3 libphy fuse nfs auth_rpcgss nfs_acl lockd sunrpc raid10 raid1 raid0 md_mod dm_bbr dm_snapshot dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sl811_hcd usbhid ohci_hcd uhci_hcd usb_s
 torage usb_libusual ehci_hcd usbcore scsi_transport_fc sx8 cciss sata_mv ahci sata_nv sata_sil24 sata_sil pata_jmicron pata_atiixp pata_amd
Pid: 9170, comm: modprobe Not tainted 2.6.31-gentoo #4
Call Trace:
 [<ffffffff8146d5b8>] ? thread_return+0x1cc/0x6c4
 [<ffffffff8146e035>] ? schedule_timeout+0x1c5/0x200
 [<ffffffff8104374b>] ? enqueue_task_fair+0x4b/0xe0
 [<ffffffff8146ce6c>] ? wait_for_common+0x17c/0x1b0
 [<ffffffff8104c5a0>] ? default_wake_function+0x0/0x40
 [<ffffffff8106db88>] ? kthread_create+0xa8/0x160
 [<ffffffff8135c590>] ? scsi_error_handler+0x0/0x640
 [<ffffffff81073626>] ? up+0x26/0x80
 [<ffffffff8134527d>] ? dev_set_name+0x5d/0x80
 [<ffffffff8115b6bd>] ? sysfs_find_dirent+0x3d/0x70
 [<ffffffff8129828c>] ? kobject_init+0x3c/0xd0
 [<ffffffff810e7b0a>] ? __kmalloc+0xca/0x140
 [<ffffffff81345b03>] ? device_initialize+0x33/0xb0
 [<ffffffff81357efd>] ? scsi_host_alloc+0x29d/0x330
 [<ffffffffa057ae50>] ? iscsi_host_alloc+0x30/0x100 [libiscsi]
 [<ffffffffa058dc46>] ? bnx2i_alloc_hba+0x36/0x6e0 [bnx2i]
 [<ffffffffa0587180>] ? bnx2i_ulp_init+0x30/0x170 [bnx2i]
 [<ffffffffa043a141>] ? cnic_register_driver+0x111/0x184 [cnic]
 [<ffffffffa0595000>] ? bnx2i_mod_init+0x0/0xe4 [bnx2i]
 [<ffffffffa0595077>] ? bnx2i_mod_init+0x77/0xe4 [bnx2i]
 [<ffffffffa0595000>] ? bnx2i_mod_init+0x0/0xe4 [bnx2i]
 [<ffffffff81009075>] ? do_one_initcall+0x45/0x1c0
 [<ffffffff810891c7>] ? sys_init_module+0x107/0x260
 [<ffffffff8100c1ab>] ? system_call_fastpath+0x16/0x1b
scsi8 : Broadcom Offload iSCSI Initiator
BUG: scheduling while atomic: modprobe/9170/0x00000002
Modules linked in: bnx2i(+) libiscsi scsi_transport_iscsi nfsd bnep rfcomm l2cap bluetooth snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ip6table_filter ip6_tables ipt_LOG xt_recent xt_state xt_tcpudp iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables cpufreq_powersave cnic uio ipv6 snd_hda_codec_atihdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec bnx2 shpchp snd_hwdep psmouse snd_pcm pci_hotplug snd_timer pcspkr wmi snd firewire_ohci firewire_core soundcore rtc thermal snd_page_alloc asus_atk0110 processor button tg3 libphy fuse nfs auth_rpcgss nfs_acl lockd sunrpc raid10 raid1 raid0 md_mod dm_bbr dm_snapshot dm_mirror dm_region_hash dm_log dm_mod scsi_wait_scan sl811_hcd usbhid ohci_hcd uhci_hcd usb_s
 torage usb_libusual ehci_hcd usbcore scsi_transport_fc sx8 cciss sata_mv ahci sata_nv sata_sil24 sata_sil pata_jmicron pata_atiixp pata_amd
Pid: 9170, comm: modprobe Not tainted 2.6.31-gentoo #4
Call Trace:
 [<ffffffff8146d5b8>] ? thread_return+0x1cc/0x6c4
 [<ffffffff81074eff>] ? sched_clock_cpu+0x7f/0x290
 [<ffffffff81042037>] ? task_rq_lock+0x57/0xb0
 [<ffffffff81074eff>] ? sched_clock_cpu+0x7f/0x290
 [<ffffffff8146e035>] ? schedule_timeout+0x1c5/0x200
 [<ffffffff8104374b>] ? enqueue_task_fair+0x4b/0xe0
 [<ffffffff8146ce6c>] ? wait_for_common+0x17c/0x1b0
 [<ffffffff8104c5a0>] ? default_wake_function+0x0/0x40
 [<ffffffff8106db88>] ? kthread_create+0xa8/0x160
 [<ffffffff81067fd0>] ? worker_thread+0x0/0x260
 [<ffffffff810e9b9a>] ? pcpu_alloc_area+0x2aa/0x330
 [<ffffffff810ea268>] ? pcpu_alloc+0x478/0x4c0
 [<ffffffff81067f83>] ? create_workqueue_thread+0x53/0xa0
 [<ffffffff81068a46>] ? __create_workqueue_key+0x1b6/0x220
 [<ffffffff810e7b0a>] ? __kmalloc+0xca/0x140
 [<ffffffff813582f4>] ? scsi_add_host+0x134/0x260
 [<ffffffffa058e012>] ? bnx2i_alloc_hba+0x402/0x6e0 [bnx2i]
 [<ffffffffa0587180>] ? bnx2i_ulp_init+0x30/0x170 [bnx2i]
 [<ffffffffa043a141>] ? cnic_register_driver+0x111/0x184 [cnic]
 [<ffffffffa0595000>] ? bnx2i_mod_init+0x0/0xe4 [bnx2i]
 [<ffffffffa0595077>] ? bnx2i_mod_init+0x77/0xe4 [bnx2i]
 [<ffffffffa0595000>] ? bnx2i_mod_init+0x0/0xe4 [bnx2i]
 [<ffffffff81009075>] ? do_one_initcall+0x45/0x1c0
 [<ffffffff810891c7>] ? sys_init_module+0x107/0x260
 [<ffffffff8100c1ab>] ? system_call_fastpath+0x16/0x1b

Regards, Sergey Temerkhanov
