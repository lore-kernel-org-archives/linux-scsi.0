From: =?utf-8?Q?Popovics_L=C3=A1szl=C3=B3?= <cuttie@me.com>
Subject: Problem with LIO
Date: Sun, 28 Aug 2016 21:51:36 +0200
Message-ID: <13D83B17-F7EF-49DF-96B3-743C4EEF66D4@me.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pv33p03im-asmtp001.me.com ([17.143.180.10]:40586 "EHLO
        pv33p03im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcH1Uvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2016 16:51:42 -0400
Received: from process-dkim-sign-daemon.pv33p03im-asmtp001.me.com by
 pv33p03im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OCM00J00XPEBM00@pv33p03im-asmtp001.me.com> for
 linux-scsi@vger.kernel.org; Sun, 28 Aug 2016 19:51:41 +0000 (GMT)
Received: from [192.168.1.105] (2E6B2CBC.catv.pool.telekom.hu [46.107.44.188])
 by pv33p03im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 with ESMTPSA id <0OCM00N3HXU1O740@pv33p03im-asmtp001.me.com> for
 linux-scsi@vger.kernel.org; Sun, 28 Aug 2016 19:51:41 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I loose ISCSI target from a client. (iscsi with iser)
On the server side I get the following message if I issue dmesg command

Any idea how can I solve this problem ?

[13433.066229] INFO: task iscsi_trx:4434 blocked for more than 120 =
seconds.
[13433.069001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" =
disables this message.
[13433.071766] iscsi_trx       D ffff88083102f400     0  4434      2 =
0x00000084
[13433.071770]  ffff881054387bf0 0000000000000046 ffff880834d02280 =
ffff881054387fd8
[13433.071776]  ffff881054387fd8 ffff881054387fd8 ffff880834d02280 =
ffff880831295a30
[13433.071781]  ffff880831295a38 7fffffffffffffff ffff880834d02280 =
ffff88083102f400
[13433.071787] Call Trace:
[13433.071793]  [<ffffffff8163a909>] schedule+0x29/0x70
[13433.071798]  [<ffffffff816385f9>] schedule_timeout+0x209/0x2d0
[13433.071803]  [<ffffffff8163a909>] ? schedule+0x29/0x70
[13433.071807]  [<ffffffff816385f9>] ? schedule_timeout+0x209/0x2d0
[13433.071816]  [<ffffffff8163acd6>] wait_for_completion+0x116/0x170
[13433.071822]  [<ffffffff810b8c10>] ? wake_up_state+0x20/0x20
[13433.071850]  [<ffffffffa0680ce0>] =
target_wait_for_sess_cmds+0x60/0x150 [target_core_mod]
[13433.071857]  [<ffffffffa0771378>] isert_wait_conn+0x88/0x180 =
[ib_isert]
[13433.071869]  [<ffffffffa072cfbd>] iscsit_close_connection+0x15d/0x820 =
[iscsi_target_mod]
[13433.071878]  [<ffffffff8163b837>] ? =
wait_for_completion_interruptible+0x167/0x1d0
[13433.071889]  [<ffffffffa072bad0>] ? =
iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[13433.071899]  [<ffffffffa071b183>] =
iscsit_take_action_for_connection_exit+0x83/0x110 [iscsi_target_mod]
[13433.071913]  [<ffffffffa072bcb7>] iscsi_target_rx_thread+0x1e7/0xf80 =
[iscsi_target_mod]
[13433.071924]  [<ffffffff81013588>] ? __switch_to+0xf8/0x4b0
[13433.071936]  [<ffffffffa072bad0>] ? =
iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[13433.071942]  [<ffffffff810a5aef>] kthread+0xcf/0xe0
[13433.071948]  [<ffffffff810a5a20>] ? =
kthread_create_on_node+0x140/0x140
[13433.071956]  [<ffffffff81645858>] ret_from_fork+0x58/0x90
[13433.071975]  [<ffffffff810a5a20>] ? =
kthread_create_on_node+0x140/0x140

I=E2=80=99m using kernel version : 3.10.0-327.el7.x86_64
Centos 7 OS
targetcli version 2.1.fb41

After yum update the same occurs.

Thanks, and Best Regards,

	Laszlo

