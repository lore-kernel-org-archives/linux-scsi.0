From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] iscsi: Fix OOPs in crypto_free_hash() exception path
Date: Sun, 16 Jan 2011 00:06:38 -0800
Message-ID: <1295165199-28464-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ac4.yahoo.com ([98.139.52.204]:23807 "HELO
	nm7.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751017Ab1APIHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Jan 2011 03:07:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes the following NULL pointer dereference OOPs in
iscsi_target_login_thread() exception path for crypto_destroy_tfm().
This can happen when crc32c.ko is not available and iscsi_login_setup_crypto()
-> crypto_alloc_hash() fails, causing the iSCSI login negotiation to be aborted.
It adds the necessary inverted IS_ERR() checks to ensure that crypto_free_hash()
is only ever called for valid conn->conn_[r,t]x_hash.tfm pointers.

[26468.905905] crypto_alloc_hash() failed for conn_rx_tfm
[26468.905905] iscsi_login_setup_crypto() failed
[26468.905905] iSCSI Login negotiation failed.
[26468.905905] iSCSI Login negotiation failed.
[26468.905905] BUG: unable to handle kernel NULL pointer dereference at 000000000000004e
[26468.905905] IP: [<ffffffff811cca7c>] crypto_destroy_tfm+0x18/0x55
[26468.905905] PGD 0
[26468.905905] Oops: 0000 [#1] SMP
[26468.905905] last sysfs file: /sys/devices/pci0000:00/0000:00:07.1/host2/target2:0:0/2:0:0:0/type
[26468.905905] CPU 0
[26468.905905] Modules linked in: iscsi_target_mod target_core_stgt target_core_pscsi target_core_file target_core_iblock target_core_mod scsi_tgt configfs sr_mod cdrom sd_mod ata_piix mptspi mptscsih libata mptbase [last unloaded: target_core_mod]
[26468.905905]
[26468.905905] Pid: 9478, comm: iscsi_np Not tainted 2.6.37+ #1 440BX Desktop Reference Platform/VMware Virtual Platform
[26468.905905] RIP: 0010:[<ffffffff811cca7c>]  [<ffffffff811cca7c>] crypto_destroy_tfm+0x18/0x55
[26468.905905] RSP: 0018:ffff88001d903ce0  EFLAGS: 00010282
[26468.905905] RAX: ffff88001d903fd8 RBX: fffffffffffffffe RCX: ffff88001d903ce0
[26468.905905] RDX: dead000000200200 RSI: fffffffffffffffe RDI: fffffffffffffffe
[26468.905905] RBP: ffff88001d903d00 R08: ffff88001d903ce0 R09: ffff88001dd40000
[26468.905905] R10: ffff8800000bd320 R11: ffffea0000694168 R12: ffff88001e290000
[26468.905905] R13: fffffffffffffffe R14: ffff88001ddf5ad0 R15: ffff88001e288000
[26468.905905] FS:  00007fb294cd96e0(0000) GS:ffff88001fa00000(0000) knlGS:0000000000000000
[26468.905905] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[26468.905905] CR2: 000000000000004e CR3: 0000000001803000 CR4: 00000000000006f0
[26468.905905] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[26468.905905] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[26468.905905] Process iscsi_np (pid: 9478, threadinfo ffff88001d902000, task ffff88001f6f8000)
[26468.905905] Stack:
[26468.905905]  ffff88001d903d00 ffff88001dd40000 ffff88001e290000 ffff88001d903eb0
[26468.905905]  ffff88001d903f40 ffffffffa01b447f ffff88001d903e70 ffff88001d903e30
[26468.905905]  ffff88001d903ee0 ffff88001d903e00 ffff88001f6f8000 ffff88001f6f8000
[26468.905905] Call Trace:
[26468.905905]  [<ffffffffa01b447f>] iscsi_target_login_thread+0x16c5/0x1829 [iscsi_target_mod]
[26468.905905]  [<ffffffff810038a4>] kernel_thread_helper+0x4/0x10
[26468.905905]  [<ffffffffa01b2dba>] ? iscsi_target_login_thread+0x0/0x1829 [iscsi_target_mod]
[26468.905905]  [<ffffffff810038a0>] ? kernel_thread_helper+0x0/0x10
[26468.905905] Code: 85 c0 74 02 ff d0 48 89 df e8 26 dd e9 ff 41 5b 5b c9 c3 55 48 89 e5 41 55 49 89 fd 41 54 53 48 89 f3 48 83 ec 08 48 85 ff 74 35 <4c> 8b 66 50 48 83 7e 48 00 75 12 49 8b 84 24 08 01 00 00 48 85
[26468.905905] RIP  [<ffffffff811cca7c>] crypto_destroy_tfm+0x18/0x55
[26468.905905]  RSP <ffff88001d903ce0>
[26468.905905] CR2: 000000000000004e
[26501.219398] ---[ end trace 9fdad6e747ed8f46 ]---

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target_login.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target_login.c b/drivers/target/lio-target/iscsi_target_login.c
index 8367026..35d4765 100644
--- a/drivers/target/lio-target/iscsi_target_login.c
+++ b/drivers/target/lio-target/iscsi_target_login.c
@@ -1369,9 +1369,9 @@ old_sess_out:
 		iscsi_dec_session_usage_count(SESS(conn));
 	}
 
-	if (conn->conn_rx_hash.tfm)
+	if (!IS_ERR(conn->conn_rx_hash.tfm))
 		crypto_free_hash(conn->conn_rx_hash.tfm);
-	if (conn->conn_tx_hash.tfm)
+	if (!IS_ERR(conn->conn_tx_hash.tfm))
 		crypto_free_hash(conn->conn_tx_hash.tfm);
 
 	if (conn->conn_cpumask)
-- 
1.5.6.5

