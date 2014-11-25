From: Laurence Oberman <loberman@redhat.com>
Subject: [PATCH qla2xxx] Race in handling rport deletion in Qlogic driver
 during recovery causes panic
Date: Tue, 25 Nov 2014 09:16:42 -0500 (EST)
Message-ID: <827904999.3215615.1416925002571.JavaMail.zimbra@redhat.com>
References: <66112100.3203938.1416924145624.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:59743 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaKYOQn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Nov 2014 09:16:43 -0500
In-Reply-To: <66112100.3203938.1416924145624.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Chad Dupuis <cdupuis@redhat.com>

When we have an rport disconnect we race during rport deletion and re-connection resulting in a panic.
When we do this, we call fc_remote_port_del() just before we do the calls to re-establish the session with 
the FC transport with fc_remote_port_add() and then fc_remote_port_rolechg().

If we remove the call to fc_remote_port_del() before re-establishing the connection this prevents the race.
This patch has resolved this for multiple customers via test kernels.

Suggested by Chad Dupuis, implemented and tested by Laurence Oberman.

Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff -Nur a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2014-10-14 18:07:48.313648535 -0400
+++ b/drivers/scsi/qla2xxx/qla_init.c	2014-11-25 09:08:17.108814261 -0500
@@ -3237,8 +3237,6 @@
 	struct fc_rport *rport;
 	unsigned long flags;
 
-	qla2x00_rport_del(fcport);
-
 	rport_ids.node_name = wwn_to_u64(fcport->node_name);
 	rport_ids.port_name = wwn_to_u64(fcport->port_name);
 	rport_ids.port_id = fcport->d_id.b.domain << 16 |


Supporting traces
----------------
qla2xxx 0000:06:00.1: scsi(1:4:0): Abort command issued -- 1 2002.
qla2xxx 0000:06:00.1: scsi(1:4:0): BUS RESET ISSUED.
qla2xxx 0000:06:00.1: qla2xxx_eh_bus_reset: reset succeded
qla2xxx 0000:06:00.1: scsi(1:4:0): Abort command issued -- 1 2002.
qla2xxx 0000:06:00.1: scsi(1:4:0): ADAPTER RESET ISSUED.
qla2xxx 0000:06:00.1: Performing ISP error recovery - ha= ffff880bd5b55000.
qla2xxx 0000:06:00.1: FW: Loading via request-firmware...
qla2xxx 0000:06:00.1: LOOP UP detected (4 Gbps).
qla2xxx 0000:06:00.1: qla2xxx_eh_host_reset: reset succeded
qla2xxx 0000:09:00.1: scsi(3:3:0): Abort command issued -- 1 2002.
qla2xxx 0000:09:00.1: scsi(3:3:0): Abort command issued -- 1 2002.
qla2xxx 0000:09:00.1: scsi(3:3:0): DEVICE RESET ISSUED.
qla2xxx 0000:09:00.1: scsi(3:3:0): DEVICE RESET SUCCEEDED.
qla2xxx 0000:06:00.1: scsi(1:4:0): Abort command issued -- 1 2002.
scsi 1:0:4:0: Device offlined - not ready after error recovery
..
..
scsi 3:0:2:0: Device offlined - not ready after error recovery
qla2xxx 0000:06:00.1: scsi(1:8:0): Abort command issued -- 1 2002.
qla2xxx 0000:06:00.1: scsi(1:8:0): Abort command issued -- 1 2002.
qla2xxx 0000:06:00.1: scsi(1:8:0): DEVICE RESET ISSUED.
qla2xxx 0000:06:00.1: scsi(1:8:0): DEVICE RESET SUCCEEDED.
qla2xxx 0000:06:00.1: scsi(1:8:0): Abort command issued -- 1 2002.
qla2xxx 0000:06:00.1: scsi(1:8:0): TARGET RESET ISSUED.
qla2xxx 0000:06:00.1: scsi(1:8:0): TARGET RESET SUCCEEDED.
qla2xxx 0000:09:00.1: scsi(3:3:0): Abort command issued -- 1 2002.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
IP: [<ffffffff8134fa1b>] scsi_is_host_device+0xb/0x20
PGD b80681067 PUD b833ca067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/system/cpu/cpu2/cpufreq/scaling_setspeed
CPU 9 
Modules linked in: nfs fscache xfs ext3 jbd ext2 iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables mptctl mptbase vxodm(P)(U) amf(P)(U) vxfen(P)(U) gab(P)(U) llt(P)(U) nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc dmpjbod(P)(U) dmpap(P)(U) dmpaa(P)(U) vxspec(P)(U) vxio(P)(U) vxdmp(P)(U) pcc_cpufreq bonding ipv6 vxportal(P)(U) fdd(P)(U) vxfs(P)(U) exportfs emcpvlumd(P)(U) emcpxcrypt(P)(U) emcpdm(P)(U) emcpgpx(P)(U) emcpmpx(P)(U) emcp(P)(U) dm_mirror dm_region_hash dm_log hpilo hpwdt microcode serio_raw iTCO_wdt iTCO_vendor_support i7core_edac edac_core ses enclosure sg power_meter hwmon be2net shpchp ext4 mbcache jbd2 sd_mod crc_t10dif hpsa(U) qla2xxx scsi_transport_fc scsi_tgt dm_mod [last unloaded: emcpioc]

Modules linked in: nfs fscache xfs ext3 jbd ext2 iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables mptctl mptbase vxodm(P)(U) amf(P)(U) vxfen(P)(U) gab(P)(U) llt(P)(U) nfsd lockd nfs_acl auth_rpcgss autofs4 sunrpc dmpjbod(P)(U) dmpap(P)(U) dmpaa(P)(U) vxspec(P)(U) vxio(P)(U) vxdmp(P)(U) pcc_cpufreq bonding ipv6 vxportal(P)(U) fdd(P)(U) vxfs(P)(U) exportfs emcpvlumd(P)(U) emcpxcrypt(P)(U) emcpdm(P)(U) emcpgpx(P)(U) emcpmpx(P)(U) emcp(P)(U) dm_mirror dm_region_hash dm_log hpilo hpwdt microcode serio_raw iTCO_wdt iTCO_vendor_support i7core_edac edac_core ses enclosure sg power_meter hwmon be2net shpchp ext4 mbcache jbd2 sd_mod crc_t10dif hpsa(U) qla2xxx scsi_transport_fc scsi_tgt dm_mod [last unloaded: emcpioc]
Pid: 641, comm: qla2xxx_3_dpc Tainted: P   M       ----------------   2.6.32-131.26.1.el6.x86_64 #1 ProLiant BL460c G7
RIP: 0010:[<ffffffff8134fa1b>]  [<ffffffff8134fa1b>] scsi_is_host_device+0xb/0x20
RSP: 0018:ffff8817d15d5c80  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff880bcf094000 RCX: 0000000000005ee0
RDX: ffff880bd5b37850 RSI: 0000000000000297 RDI: 0000000000000000
RBP: ffff8817d15d5c80 R08: 0000000000000006 R09: ffff880bd5b39210
R10: ffff8817d15d5d18 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8817d15d5d60 R14: ffff880bd5b39000 R15: ffff8817d15d5e10
FS:  0000000000000000(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000058 CR3: 0000000baa52e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process qla2xxx_3_dpc (pid: 641, threadinfo ffff8817d15d4000, task ffff8817d15d3500)
Stack:
 ffff8817d15d5cb0 ffffffffa002d701 ffff880bd18a0300 ffff880afcdcc0c0
<0> ffff880bcf094000 ffff8817d15d5d60 ffff8817d15d5cd0 ffffffffa0044e1d
<0> ffff880afcdcc0c0 ffff880bd5b37de0 ffff8817d15d5db0 ffffffffa0046f6a
Call Trace:
 [<ffffffffa002d701>] fc_remote_port_delete+0x31/0x100 [scsi_transport_fc]
 [<ffffffffa0044e1d>] qla2x00_rport_del+0x4d/0x90 [qla2xxx]
 [<ffffffffa0046f6a>] qla2x00_update_fcport+0x6a/0x470 [qla2xxx]
 [<ffffffff8105d985>] ? wake_up_process+0x15/0x20
 [<ffffffffa003f49b>] ? qla2xxx_wake_dpc+0x2b/0x30 [qla2xxx]
 [<ffffffffa004979b>] qla2x00_async_login_done+0x13b/0x140 [qla2xxx]
 [<ffffffffa003f990>] qla2x00_do_work+0x160/0x250 [qla2xxx]
 [<ffffffffa0040378>] qla2x00_do_dpc+0xf8/0x570 [qla2xxx]
 [<ffffffffa0040280>] ? qla2x00_do_dpc+0x0/0x570 [qla2xxx]
 [<ffffffff8108dc46>] kthread+0x96/0xa0
 [<ffffffff8100c1ca>] child_rip+0xa/0x20
 [<ffffffff8108dbb0>] ? kthread+0x0/0xa0
 [<ffffffff8100c1c0>] ? child_rip+0x0/0x20
Code: 55 48 89 e5 0f 1f 44 00 00 0f b7 06 39 87 3c fd ff ff c9 0f 94 c0 0f b6 c0 c3 66 0f 1f 44 00 00 55 48 89 e5 0f 1f 44 00 00 31 c0 <48> 81 7f 58 00 0e b0 81 c9 0f 94 c0 c3 0f 1f 84 00 00 00 00 00 
RIP  [<ffffffff8134fa1b>] scsi_is_host_device+0xb/0x20
 RSP <ffff8817d15d5c80>
CR2: 0000000000000058

