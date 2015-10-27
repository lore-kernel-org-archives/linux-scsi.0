From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_dh: Use module_request_nowait
Date: Wed, 28 Oct 2015 06:52:47 +0900
Message-ID: <1445982767.2300.151.camel@HansenPartnership.com>
References: <1445982323-1162-1-git-send-email-labbott@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39202 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981AbbJ0Vwv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Oct 2015 17:52:51 -0400
In-Reply-To: <1445982323-1162-1-git-send-email-labbott@fedoraproject.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>

On Tue, 2015-10-27 at 14:45 -0700, Laura Abbott wrote:
> We recevied a bugzilla report:
> 
> Additional info:
> reporter: libreport-2.6.3
> WARNING: CPU: 3 PID: 10195 at kernel/kmod.c:140
> __request_module+0x214/0x330()
> Modules linked in: uas usb_storage xfs libcrc32c vhost_net vhost macvtap
> macvlan bnep bluetooth pppoe pppox ppp_generic slhc xt_CHECKSUM
> ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT
> nf_reject_ipv6 xt_conntrack ebtable_nat ebtable_filter ebtable_broute
> bridge ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
> nf_nat_ipv6 ip6table_raw ip6table_security ip6table_mangle
> ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_security
> iptable_mangle vfat fat joydev snd_hda_codec_realtek
> snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel btrfs
> snd_hda_codec snd_hda_core snd_hwdep xor snd_seq raid6_pq intel_rapl
> iosf_mbi eeepc_wmi x86_pkg_temp_thermal coretemp iTCO_wdt
> iTCO_vendor_support kvm_intel
> snd_seq_device asus_wmi sparse_keymap snd_pcm rfkill mxm_wmi kvm
> crct10dif_pclmul snd_timer crc32_pclmul crc32c_intel snd mei_me mei
> i2c_i801 lpc_ich soundcore shpchp soc_button_array tpm_infineon tpm_tis
> tpm wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc 8021q garp stp llc
> mrp i915 i2c_algo_bit serio_raw drm_kms_helper e1000e drm ptp pps_core
> fjes video
> CPU: 3 PID: 10195 Comm: kworker/u16:2 Not tainted
> 4.3.0-0.rc6.git2.1.fc24.x86_64 #1
> Hardware name: ASUS All Series/Z87-PLUS, BIOS 1207 07/01/2013
> Workqueue: events_unbound async_run_entry_fn
> 0000000000000000 0000000059576eea ffff880227a67b58 ffffffff81419a49
> 0000000000000000 ffff880227a67b90 ffffffff810a9c12 ffffffff81ce2ee5
> 0000000000000001 ffff88003f587000 0000000000000000 0000000000000000
> Call Trace:
> [<ffffffff81419a49>] dump_stack+0x4b/0x72
> [<ffffffff810a9c12>] warn_slowpath_common+0x82/0xc0
> [<ffffffff810a9d5a>] warn_slowpath_null+0x1a/0x20
> [<ffffffff810c3f64>] __request_module+0x214/0x330
> [<ffffffff81123a8d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [<ffffffff815bb32e>] scsi_dh_lookup+0x2e/0x40
> [<ffffffff815bb870>] scsi_dh_add_device+0xd0/0x100
> [<ffffffff815b766e>] scsi_sysfs_add_sdev+0xbe/0x2a0
> [<ffffffff815a82e6>] ? __scsi_iterate_devices+0x66/0xd0
> [<ffffffff815b5e5e>] do_scan_async+0x12e/0x170
> [<ffffffff810d355a>] async_run_entry_fn+0x4a/0x140
> [<ffffffff810c8470>] process_one_work+0x230/0x6a0
> [<ffffffff810c83d9>] ? process_one_work+0x199/0x6a0
> [<ffffffff810c892e>] worker_thread+0x4e/0x450
> [<ffffffff810c88e0>] ? process_one_work+0x6a0/0x6a0
> [<ffffffff810c88e0>] ? process_one_work+0x6a0/0x6a0
> [<ffffffff810cf981>] kthread+0x101/0x120
> [<ffffffff81104fb9>] ? trace_hardirqs_on_caller+0x129/0x1b0
> [<ffffffff810cf880>] ? kthread_create_on_node+0x250/0x250
> [<ffffffff81862a6f>] ret_from_fork+0x3f/0x70
> [<ffffffff810cf880>] ? kthread_create_on_node+0x250/0x250
> 
> The warning that is tripped is
> 
> WARN_ON_ONCE(wait && current_is_async());

Should be fixed by:

http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?h=fixes&id=d6a32b98099fb6b257e9b4f7b3febb5aae6f7408

Which is scheduled to go into the final -rc7

James


