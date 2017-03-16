From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 01/10] be2iscsi: Check tag in beiscsi_mccq_compl_wait
Date: Thu, 16 Mar 2017 08:54:36 +0530
Message-ID: <1489634685-4975-2-git-send-email-jitendra.bhivare@broadcom.com>
References: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38664 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdCPD0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2017 23:26:01 -0400
Received: by mail-wm0-f46.google.com with SMTP id t189so37332775wmt.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Mar 2017 20:25:13 -0700 (PDT)
In-Reply-To: <1489634685-4975-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

scsi host12: BS_1377 : mgmt_invalidate_connection Failed for cid=256
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
IP: [<ffffffff81332ebf>] __list_add+0xf/0xc0
PGD 0
Oops: 0000 [#1] SMP
Modules linked in:
...
CPU: 9 PID: 1542 Comm: iscsid Tainted: G               ------------ T 3.10.0-514.el7.x86_64 #1
Hardware name: HP ProLiant DL360 Gen9/ProLiant DL360 Gen9, BIOS P89 09/12/2016
task: ffff88076f310fb0 ti: ffff88076bba8000 task.ti: ffff88076bba8000
RIP: 0010:[<ffffffff81332ebf>]  [<ffffffff81332ebf>] __list_add+0xf/0xc0
RSP: 0018:ffff88076bbab8e8  EFLAGS: 00010046
RAX: 0000000000000246 RBX: ffff88076bbab990 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff880468badf58 RDI: ffff88076bbab990
RBP: ffff88076bbab900 R08: 0000000000000246 R09: 00000000000020de
R10: 0000000000000000 R11: ffff88076bbab5be R12: 0000000000000000
R13: ffff880468badf58 R14: 000000000001adb0 R15: ffff88076f310fb0
FS:  00007f377124a880(0000) GS:ffff88046fa40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 0000000771318000 CR4: 00000000001407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Stack:
ffff88076bbab990 ffff880468badf50 0000000000000001 ffff88076bbab938
ffffffff810b128b 0000000000000246 00000000cf9b7040 ffff880468bac7a0
0000000000000000 ffff880468bac7a0 ffff88076bbab9d0 ffffffffa05a6ea3

Call Trace:
[<ffffffff810b128b>] prepare_to_wait+0x7b/0x90
[<ffffffffa05a6ea3>] beiscsi_mccq_compl_wait+0x153/0x330 [be2iscsi]
[<ffffffff810b1600>] ? wake_up_atomic_t+0x30/0x30
[<ffffffffa05981b1>] beiscsi_ep_disconnect+0x91/0x2d0 [be2iscsi]
[<ffffffffa0202ffa>] iscsi_if_ep_disconnect.isra.14+0x5a/0x70 [scsi_transport_iscsi]
[<ffffffffa02042fb>] iscsi_if_recv_msg+0x113b/0x14a0 [scsi_transport_iscsi]
[<ffffffff811dffd8>] ? __kmalloc_node_track_caller+0x58/0x290
[<ffffffffa02046ee>] iscsi_if_rx+0x8e/0x1f0 [scsi_transport_iscsi]
[<ffffffff815a351d>] netlink_unicast+0xed/0x1b0
[<ffffffff815a38fe>] netlink_sendmsg+0x31e/0x690
[<ffffffff815a03e4>] ? netlink_rcv_wake+0x44/0x60
[<ffffffff815a19e3>] ? netlink_recvmsg+0x1e3/0x450

beiscsi_mccq_compl_wait gets called even when MCC tag allocation failed
for mgmt_invalidate_connection.
mcc_wait is not initialized for tag 0 so causes crash in prepare_to_wait.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 5d59e263..d14ddb2 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -246,6 +246,12 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *phba,
 {
 	int rc = 0;
 
+	if (!tag || tag > MAX_MCC_CMD) {
+		__beiscsi_log(phba, KERN_ERR,
+			      "BC_%d : invalid tag %u\n", tag);
+		return -EINVAL;
+	}
+
 	if (beiscsi_hba_in_error(phba)) {
 		clear_bit(MCC_TAG_STATE_RUNNING,
 			  &phba->ctrl.ptag_state[tag].tag_state);
-- 
2.7.4
