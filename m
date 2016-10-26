From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Crash in TCM-LIO
Date: Tue, 25 Oct 2016 23:18:48 -0700
Message-ID: <1477462728.19735.95.camel@haakon3.risingtidesystems.com>
References: <BN6PR11MB197044D930C8512F099143A494A90@BN6PR11MB1970.namprd11.prod.outlook.com>
         <1477292393.19735.40.camel@haakon3.risingtidesystems.com>
          <BY1PR0701MB164496C3C3E05D7B686D7CEA8EA80@BY1PR0701MB1644.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53197 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbcJZGSv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 02:18:51 -0400
In-Reply-To: <BY1PR0701MB164496C3C3E05D7B686D7CEA8EA80@BY1PR0701MB1644.namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>
Cc: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "Tran, Quinn" <Quinn.Tran@cavium.com>, TomK <tk@mdevsys.com>

Hello Anil & Co,

On Tue, 2016-10-25 at 05:33 +0000, Gurumurthy, Anil wrote:
> On Mon, 2016-10-24 at 06:36 +0000, Anil Gurumurthy wrote:

<SNIP>

> > 
> > [71884.588748] BUG: unable to handle kernel NULL pointer dereference 
> > at 00000000000000e0
> > 
> > [71884.588881] IP: [<ffffffff811ff52a>] kmem_cache_free+0x11a/0x200
> > 
> > [71884.588981] PGD 0
> > 
> > [71884.589017] Oops: 0000 [#1] SMP
> > 
> > [71884.589041] ------------[ cut here ]------------
> > 
> > [71884.589048] WARNING: CPU: 2 PID: 20783 at lib/list_debug.c:62
> > __list_del_entry+0x86/0xd0
> > 
> > [71884.589049] list_del corruption. next->prev should be 
> > ffff8806f8daeb68, but was ffff8806f8db79e8
> > 
> > [71884.589075] Modules linked in: target_core_pscsi tcm_qla2xxx(OE)
> > qla2xxx(OE) iscsi_target_mod target_core_file target_core_iblock 
> > target_core_mod netconsole ebtable_nat ebtables ipt_MASQUERADE
> > nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM 
> > iptable_mangle bridge 8021q mrp garp stp llc ipt_REJECT nf_reject_ipv4
> > nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT
> > nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack 
> > ip6table_filter ip6_tables binfmt_misc vhost_net macvtap macvlan vhost 
> > tun uinput sg serio_raw iTCO_wdt iTCO_vendor_support ipmi_ssif ipmi_si 
> > ipmi_msghandler hpilo hpwdt bnx2 intel_powerclamp coretemp kvm_intel 
> > kvm irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel 
> > ghash_clmulni_intel pcspkr acpi_power_meter lpc_ich mfd_core 
> > i7core_edac edac_core shpchp ext4(E) mbcache(E) jbd2(E) sd_mod(E)
> > sr_mod(E) cdrom(E) scsi_transport_fc(E) hpsa(E) scsi_transport_sas(E)
> > aesni_intel(E) ablk_helper(E) cryptd(E) lrw(E) gf128mul(E)
> > glue_helper(E) pata_acpi(E) ata_generic(E) ata_piix(E) libata(E)
> > radeon(E) ttm(E) drm_kms_helper(E) drm(E) fb_sys_fops(E) sysimgblt(E)
> > sysfillrect(E) syscopyarea(E) i2c_algo_bit(E) i2c_core(E) dm_mirror(E)
> > dm_region_hash(E) dm_log(E) dm_mod(E) [last unloaded: qla2xxx]
> > 
> > [71884.589091] CPU: 2 PID: 20783 Comm: kworker/2:0 Tainted: G        W
> > IOE   4.7.0-rc1+ #2
> > 
> > [71884.589092] Hardware name: HP ProLiant DL380 G7, BIOS P67
> > 05/05/2011
> > 
> > [71884.589107] Workqueue: target_completion target_complete_ok_work 
> > [target_core_mod]
> > 
> > [71884.589109]  0000000000000000 ffff880408d1fae8 ffffffff81352197
> > ffffffff81370ef6
> > 
> > [71884.589110]  ffff880408d1fb48 ffff880408d1fb48 0000000000000000
> > ffff880408d1fb38
> > 
> > [71884.589111]  ffffffff8108a12d 00000000000007c3 0000003e00000246
> > 0000000000000246
> > 
> > [71884.589112] Call Trace:
> > 
> > [71884.589115]  [<ffffffff81352197>] dump_stack+0x67/0x90
> > 
> > [71884.589117]  [<ffffffff81370ef6>] ? __list_del_entry+0x86/0xd0
> > 
> > [71884.589119]  [<ffffffff8108a12d>] __warn+0xfd/0x120
> > 
> > [71884.589120]  [<ffffffff8108a209>] warn_slowpath_fmt+0x49/0x50
> > 
> > [71884.589122]  [<ffffffff81370ef6>] __list_del_entry+0x86/0xd0
> > 
> > [71884.589123]  [<ffffffff81370f51>] list_del+0x11/0x40
> > 
> > [71884.589132]  [<ffffffffa0799d1e>] target_remove_from_state_list
> > +0x6e/0x80 [target_core_mod]
> > 
> > [71884.589140]  [<ffffffffa0799e14>] transport_cmd_check_stop
> > +0xe4/0x120 [target_core_mod]
> > 
> > [71884.589151]  [<ffffffffa0799e65>]
> > transport_cmd_check_stop_to_fabric+0x15/0x20 [target_core_mod]
> > 
> > [71884.589160]  [<ffffffffa079dbfe>] target_complete_ok_work
> > +0x14e/0x280 [target_core_mod]
> > 
> > [71884.589162]  [<ffffffff810a39c0>] ? pwq_dec_nr_in_flight+0x50/0xa0
> > 
> > [71884.589164]  [<ffffffff810a4703>] process_one_work+0x183/0x4d0
> > 
> > [71884.589166]  [<ffffffff816d913f>] ? __schedule+0x1ff/0x5c0
> > 
> > [71884.589167]  [<ffffffff816d9600>] ? schedule+0x40/0xb0
> > 
> > [71884.589169]  [<ffffffff810a53bd>] worker_thread+0x16d/0x530
> > 
> > [71884.589171]  [<ffffffff8102eb1d>] ? __switch_to+0x1cd/0x5e0
> > 
> > [71884.589173]  [<ffffffff816d913f>] ? __schedule+0x1ff/0x5c0
> > 
> > [71884.589175]  [<ffffffff810cc586>] ? __wake_up_common+0x56/0x90
> > 
> > [71884.589177]  [<ffffffff810a5250>] ? maybe_create_worker+0x120/0x120
> > 
> > [71884.589178]  [<ffffffff816d9600>] ? schedule+0x40/0xb0
> > 
> > [71884.589179]  [<ffffffff810a5250>] ? maybe_create_worker+0x120/0x120
> > 
> > [71884.589180]  [<ffffffff810a9fcc>] kthread+0xcc/0xf0
> > 
> > [71884.589183]  [<ffffffff81003f08>] ? do_syscall_64+0x78/0x1d0
> > 
> > [71884.589185]  [<ffffffff810b49ee>] ? schedule_tail+0x1e/0xc0
> > 
> > [71884.589188]  [<ffffffff816dd47f>] ret_from_fork+0x1f/0x40
> > 
> > [71884.589189]  [<ffffffff810a9f00>] ? kthread_freezable_should_stop
> > +0x70/0x70
> > 
> > [71884.589190] ---[ end trace 7f24d6c863b6e35b ]---
> > 
> > [71884.589204] ------------[ cut here ]------------
> > 
> > [71884.589206] WARNING: CPU: 2 PID: 20783 at lib/list_debug.c:59
> > __list_del_entry+0xa5/0xd0
> > 
> >  
> 
> Was list corruption preceded by hung kernel task warnings..?
> 
> No. The only messages prior to them were similar to this:
> [ 3345.864359] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 1219168 [ 3345.864378] qla2xxx [0000:0b:00.1]-e900:4: RESET-TMR online/active/old-count/new-count = 1/0/0/1.
> [ 3345.864418] BUG: unable to handle kernel NULL pointer dereference at 00000000000000e0 [ 3345.864549] IP: [<ffffffff811ff52a>] kmem_cache_free+0x11a/0x200
> 

Thanks for confirming.  The ABORT_TASK TMR_TASK_DOES_NOT_EXIST
exceptions here do not depend on the missing SCF_ACK_KREF bit
assignment.

The earlier SCF_ACK_KREF reference leak fix is specific to TMR that
reference active se_cmd->cmd_kref tags, when I/O is still outstanding to
associated target-core se_cmd->se_dev backends.

> > 
> > On this particular kernel version (4.7), I am unable to get a crash 
> > dump, so cannot really fathom whats going on.
> > 
> 
> Note there is a v4.1+ reference leak regression for ABORT_TASK + session shutdown here:
> 
> https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c6d6afdb1e3e
> 
> > Have you seen or have been notified of this behaviour?
> 
> TomK (CC') reported something similar using v4.8.4 with ESX hosts ABORT_TASK + tcm/qla2xxx ports.
> 
> >   Any ideas/thoughts on how to proceed?
> > 
> >  
> 
> Currently unsure if this list corruption is related to the above regression, or not.
> 
> Please verify using the patch on v4.7.y code during tcm/qla2xxx session shutdown -> restart, once ABORT_TASK has occurred.
> [Anil] I see the issue even when I apply this patch to my kernel.
> 

>From above + TomK's list corruption logs, it looks like a
se_cmd->cmd_kref is prematurely reaching zero + freeing memory while
se_cmd memory is still outstanding to target-core backend.

The se_cmd->state_list is not used by TMR, so AFAICT list corruption
here is specific to qla_tgt_cmd->se_cmd dispatched into target-core,
released while se_cmd is still outstanding.

To confirm verify the theory, please change the list_debug warn above
into BUG_ON with LKCD logic in place, and let's have a look.

