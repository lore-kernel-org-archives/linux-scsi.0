From: Jonathan McDowell <noodles@earth.li>
Subject: Soft lockup in scsi_remove_target under 3.6 (regression from 3.5)
Date: Tue, 2 Oct 2012 17:43:09 -0700
Message-ID: <20121003004309.GA2289@earth.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Upgraded to 3.6 today on my dev box and after seeing an FC attached SAN
go down and come back up (due to an expected reboot) I started getting
the following in my logs. It continues even after the array is back and
functioning - I'm seeing:

 kernel:[109104.348034] BUG: soft lockup - CPU#6 stuck for 23s!
[kworker/6:0:30692]

repeated on logged in sessions and backtraces like the following (this
is the first). I don't see the same problem under 3.5.

[10819.389706] device-mapper: multipath: Failing path 8:240.
[11233.683936] device-mapper: multipath: Failing path 8:240.
[108394.592042]  rport-10:0-4: blocked FC remote port time out: removing target and saving binding
[108394.609594] sd 10:0:1:0: rejecting I/O to offline device
[108394.620457] lpfc 0000:0c:00.0: 2:(0):0203 Devloss timeout on WWPN 21:11:00:02:ac:01:86:06 NPort x030500 Data: x0 x7 x0
[108394.620591] sd 10:0:1:0: alua: Detached
[108394.650159] sd 10:0:1:0: [sdbc] Synchronizing SCSI cache
[108394.661071] sd 10:0:1:0: [sdbc]  
[108394.667877] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[108394.680154] ses 10:0:1:254: alua: Detached
[108420.348032] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/6:0:30692]
[108420.352003] Modules linked in: nfsv4 autofs4 ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables rpcsec_gss_krb5 ipv6 nfsd nfs_acl auth_rpcgss nfs lockd sunrpc dm_round_robin dm_multipath ipmi_devintf ipmi_si ipmi_msghandler sg evdev acpi_cpufreq freq_table serio_raw mperf processor button thermal_sys coretemp kvm_intel kvm lpc_ich ioatdma mfd_core tpm_tis i2c_i801 tpm microcode tpm_bios rng_core i2c_core i5k_amb dca ses enclosure ata_generic lpfc ata_piix scsi_transport_fc scsi_tgt
[108420.352003] CPU 6 
[108420.352003] Pid: 30692, comm: kworker/6:0 Not tainted 3.6.0 #5 Intel S5000PAL./S5000PAL0 
[108420.352003] RIP: 0010:[<ffffffff8134e744>]  [<ffffffff8134e744>] _raw_spin_unlock_irqrestore+0x5/0x6
[108420.352003] RSP: 0018:ffff8802563a7d98  EFLAGS: 00000286
[108420.352003] RAX: ffff88024e975000 RBX: 00000000000000bb RCX: 0000000000000000
[108420.352003] RDX: 0000000000000000 RSI: 0000000000000286 RDI: ffff88024e975050
[108420.352003] RBP: ffff88024e975000 R08: 0000000000000000 R09: ffffffff8166f890
[108420.352003] R10: ffff88024e975000 R11: ffffffffa00d6bf0 R12: 0000000000000000
[108420.352003] R13: ffffffff8166f890 R14: ffff88024e975000 R15: ffffffffa00d6bf0
[108420.352003] FS:  0000000000000000(0000) GS:ffff88025fd80000(0000) knlGS:0000000000000000
[108420.352003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[108420.352003] CR2: 00007f5b5dec6070 CR3: 000000024f0eb000 CR4: 00000000000007e0
[108420.352003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[108420.352003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[108420.352003] Process kworker/6:0 (pid: 30692, threadinfo ffff8802563a6000, task ffff880252f32a10)
[108420.352003] Stack:
[108420.352003]  ffffffff8125a498 ffff88025fd8d080 0000000000000286 ffffffffa0015c28
[108420.352003]  ffff88024d1207c0 ffff88025fd8d080 ffff88025fd98100 ffffffffa0015c28
[108420.352003]  0000000000000000 ffff88024f22abd8 ffffffff81045d07 0000000000012240
[108420.352003] Call Trace:
[108420.352003]  [<ffffffff8125a498>] ? scsi_remove_target+0x138/0x154
[108420.352003]  [<ffffffffa0015c28>] ? store_fc_host_system_hostname+0x66/0x66 [scsi_transport_fc]
[108420.352003]  [<ffffffffa0015c28>] ? store_fc_host_system_hostname+0x66/0x66 [scsi_transport_fc]
[108420.352003]  [<ffffffff81045d07>] ? process_one_work+0x1f8/0x30a
[108420.352003]  [<ffffffff81046034>] ? worker_thread+0x21b/0x314
[108420.352003]  [<ffffffff81045e19>] ? process_one_work+0x30a/0x30a
[108420.352003]  [<ffffffff81045e19>] ? process_one_work+0x30a/0x30a
[108420.352003]  [<ffffffff810496cf>] ? kthread+0x81/0x89
[108420.352003]  [<ffffffff81350174>] ? kernel_thread_helper+0x4/0x10
[108420.352003]  [<ffffffff8104964e>] ? kthread_freezable_should_stop+0x4e/0x4e
[108420.352003]  [<ffffffff81350170>] ? gs_change+0xb/0xb
[108420.352003] Code: 66 39 d0 0f 94 c0 0f b6 c0 c3 fa b8 00 01 00 00 f0 66 0f c1 07 88 c2 66 c1 e8 08 38 c2 74 06 f3 90 8a 17 eb f6 c3 80 07 01 56 9d <c3> 83 ca ff f0 0f c1 17 b8 01 00 00 00 ff ca 79 05 f0 ff 07 30 
[108448.348033] BUG: soft lockup - CPU#6 stuck for 22s! [kworker/6:0:30692]
[108448.352003] Modules linked in: nfsv4 autofs4 ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables rpcsec_gss_krb5 ipv6 nfsd nfs_acl auth_rpcgss nfs lockd sunrpc dm_round_robin dm_multipath ipmi_devintf ipmi_si ipmi_msghandler sg evdev acpi_cpufreq freq_table serio_raw mperf processor button thermal_sys coretemp kvm_intel kvm lpc_ich ioatdma mfd_core tpm_tis i2c_i801 tpm microcode tpm_bios rng_core i2c_core i5k_amb dca ses enclosure ata_generic lpfc ata_piix scsi_transport_fc scsi_tgt
[108448.352003] CPU 6 
[108448.352003] Pid: 30692, comm: kworker/6:0 Not tainted 3.6.0 #5 Intel S5000PAL./S5000PAL0 
[108448.352003] RIP: 0010:[<ffffffff8134e744>]  [<ffffffff8134e744>] _raw_spin_unlock_irqrestore+0x5/0x6
[108448.352003] RSP: 0018:ffff8802563a7d98  EFLAGS: 00000286
[108448.352003] RAX: ffff88024e975000 RBX: 00000000000000a2 RCX: 0000000000000087
[108448.352003] RDX: 0000000000000087 RSI: 0000000000000286 RDI: ffff88024e975050
[108448.352003] RBP: ffff88024e975000 R08: 0000000000000000 R09: ffffffff8166f890
[108448.352003] R10: ffff88024e975000 R11: ffffffffa00d6bf0 R12: 0000000000000000
[108448.352003] R13: ffffffff8166f890 R14: ffff88024e975000 R15: ffffffffa00d6bf0
[108448.352003] FS:  0000000000000000(0000) GS:ffff88025fd80000(0000) knlGS:0000000000000000
[108448.352003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[108448.352003] CR2: 00007f5b5dec6070 CR3: 000000024f0eb000 CR4: 00000000000007e0
[108448.352003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[108448.352003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[108448.352003] Process kworker/6:0 (pid: 30692, threadinfo ffff8802563a6000, task ffff880252f32a10)
[108448.352003] Stack:
[108448.352003]  ffffffff8125a498 ffff88025fd8d080 0000000000000286 ffffffffa0015c28
[108448.352003]  ffff88024d1207c0 ffff88025fd8d080 ffff88025fd98100 ffffffffa0015c28
[108448.352003]  0000000000000000 ffff88024f22abd8 ffffffff81045d07 0000000000012240
[108448.352003] Call Trace:
[108448.352003]  [<ffffffff8125a498>] ? scsi_remove_target+0x138/0x154
[108448.352003]  [<ffffffffa0015c28>] ? store_fc_host_system_hostname+0x66/0x66 [scsi_transport_fc]
[108448.352003]  [<ffffffffa0015c28>] ? store_fc_host_system_hostname+0x66/0x66 [scsi_transport_fc]
[108448.352003]  [<ffffffff81045d07>] ? process_one_work+0x1f8/0x30a
[108448.352003]  [<ffffffff81046034>] ? worker_thread+0x21b/0x314
[108448.352003]  [<ffffffff81045e19>] ? process_one_work+0x30a/0x30a
[108448.352003]  [<ffffffff81045e19>] ? process_one_work+0x30a/0x30a
[108448.352003]  [<ffffffff810496cf>] ? kthread+0x81/0x89
[108448.352003]  [<ffffffff81350174>] ? kernel_thread_helper+0x4/0x10
[108448.352003]  [<ffffffff8104964e>] ? kthread_freezable_should_stop+0x4e/0x4e
[108448.352003]  [<ffffffff81350170>] ? gs_change+0xb/0xb
[108448.352003] Code: 66 39 d0 0f 94 c0 0f b6 c0 c3 fa b8 00 01 00 00 f0 66 0f c1 07 88 c2 66 c1 e8 08 38 c2 74 06 f3 90 8a 17 eb f6 c3 80 07 01 56 9d <c3> 83 ca ff f0 0f c1 17 b8 01 00 00 00 ff ca 79 05 f0 ff 07 30 

J.

-- 
   101 things you can't have too   |  .''`.  Debian GNU/Linux Developer
     much of : 28 - Sunshine.      | : :' :  Happy to accept PGP signed
                                   | `. `'   or encrypted mail - RSA
                                   |   `-    key on the keyservers.
