From: "wangqiang (AY)" <wangqiang62@huawei.com>
Subject: iscsi deadlock while login and logout 2 iscsi nodes in tight loop
 at unstable network environment
Date: Mon, 19 Jun 2017 13:35:52 +0000
Message-ID: <508A4C72ED914648BB0F1814399310DBB9FEC3@DGGEMM506-MBX.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
To: "lduncan@suse.com" <lduncan@suse.com>, "cleech@redhat.com" <cleech@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi all,

In the upstream 4.12.0-rc5 kernel, I encounter a deadlock problem while login and logout 2 iscsi nodes in tight loop at unstable network environment, the iscsid will be D state.

SysRq-w reported the following call stacks:
[10660.667133] sysrq: SysRq : Show Blocked State
[10660.671536]   task                        PC stack   pid father
[10660.672137] iscsid          D    0 11415      1 0x00000000
[10660.672139] Call Trace:
[10660.672141]  __schedule+0x1d9/0x780
[10660.672144]  schedule+0x36/0x80
[10660.672146]  async_synchronize_cookie_domain+0xaa/0x150
[10660.672149]  ? remove_wait_queue+0x60/0x60
[10660.672151]  async_synchronize_full_domain+0x18/0x20
[10660.672153]  sd_remove+0x4d/0xc0 [sd_mod]
[10660.672156]  device_release_driver_internal+0x141/0x200
[10660.672158]  device_release_driver+0x12/0x20
[10660.672159]  bus_remove_device+0xfd/0x170
[10660.672161]  device_del+0x1e8/0x330
[10660.672164]  __scsi_remove_device+0xc6/0xd0
[10660.672166]  scsi_remove_device+0x26/0x40
[10660.672168]  scsi_remove_target+0x165/0x1b0
[10660.672174]  __iscsi_unbind_session+0xbe/0x170 [scsi_transport_iscsi]
[10660.672180]  iscsi_remove_session+0xd6/0x190 [scsi_transport_iscsi]
[10660.672186]  iscsi_destroy_session+0x12/0x50 [scsi_transport_iscsi]
[10660.672192]  iscsi_session_teardown+0xd5/0xf0 [libiscsi]
[10660.672195]  iscsi_sw_tcp_session_destroy+0x48/0x70 [iscsi_tcp]
[10660.672202]  iscsi_if_recv_msg+0xbb1/0x1390 [scsi_transport_iscsi]
[10660.672205]  ? __kmalloc_node_track_caller+0x199/0x280
[10660.672211]  iscsi_if_rx+0x8e/0x1f0 [scsi_transport_iscsi]
[10660.672214]  netlink_unicast+0x181/0x240
[10660.672216]  netlink_sendmsg+0x2c2/0x3b0
[10660.672220]  sock_sendmsg+0x38/0x50
[10660.672222]  ___sys_sendmsg+0x27a/0x290
[10660.672224]  ? kernfs_refresh_inode+0xc8/0xe0
[10660.672227]  ? _copy_to_user+0x26/0x40
[10660.672230]  __sys_sendmsg+0x54/0x90
[10660.672232]  SyS_sendmsg+0x12/0x20
[10660.672234]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[10660.672325] kworker/u48:2   D    0 22364      2 0x00000000
[10660.672332] Workqueue: scsi_wq_7 __iscsi_unbind_session [scsi_transport_iscsi]
[10660.672333] Call Trace:
[10660.672336]  __schedule+0x1d9/0x780
[10660.672350]  ? set_next_entity+0x7c/0x7a0
[10660.672353]  schedule+0x36/0x80
[10660.672354]  schedule_timeout+0x249/0x300
[10660.672356]  ? finish_task_switch+0xec/0x240
[10660.672359]  wait_for_completion+0x121/0x180
[10660.672361]  ? wake_up_q+0x80/0x80
[10660.672364]  flush_workqueue+0x16d/0x490
[10660.672366]  ? probe_sched_wakeup+0x1c/0x20
[10660.672369]  drain_workqueue+0x5b/0x130
[10660.672371]  destroy_workqueue+0x1a/0x200
[10660.672373]  scsi_host_dev_release+0x6f/0x130
[10660.672375]  device_release+0x32/0x90
[10660.672377]  kobject_cleanup+0x63/0x170
[10660.672379]  kobject_put+0x28/0x50
[10660.672381]  put_device+0x17/0x20
[10660.672383]  scsi_host_put+0x15/0x20
[10660.672389]  iscsi_session_release+0x3d/0x80 [scsi_transport_iscsi]
[10660.672390]  device_release+0x32/0x90
[10660.672393]  kobject_cleanup+0x63/0x170
[10660.672395]  kobject_put+0x28/0x50
[10660.672396]  put_device+0x17/0x20
[10660.672398]  scsi_target_dev_release+0x1f/0x30
[10660.672400]  device_release+0x32/0x90
[10660.672402]  kobject_cleanup+0x63/0x170
[10660.672404]  kobject_put+0x28/0x50
[10660.672406]  put_device+0x17/0x20
[10660.672407]  scsi_target_destroy+0xc5/0xe0
[10660.672409]  scsi_target_reap_ref_release+0x35/0x40
[10660.672411]  scsi_target_reap+0x2e/0x40
[10660.672413]  scsi_remove_target+0x197/0x1b0
[10660.672419]  __iscsi_unbind_session+0xbe/0x170 [scsi_transport_iscsi]
[10660.672421]  process_one_work+0x149/0x360
[10660.672423]  worker_thread+0x4d/0x3c0
[10660.672425]  kthread+0x109/0x140
[10660.672427]  ? rescuer_thread+0x380/0x380
[10660.672428]  ? kthread_park+0x60/0x60
[10660.672430]  ret_from_fork+0x25/0x30

sd_remove() waits for async_synchronize_cookie_domain which is defined in sd_probe() and relate to sd_probe_async(), but due to unstable network environment, the session which process sd_probe_async() became ISCSI_STATE_FAILED state, and IO corresponding to sd_probe_async() doesnt complete, iscsi_conn_failure() send event to iscsid and wait for respond to stop connection, iscsid cannot respond as the sd_remove() is waiting for completion of sd_probe_async(). Hence the deadlock.

So, is any method to fix this deadlock?
Any reply would be thankful.

Execute the shell scripts below at the initiator side and wait for 5 ~ 20 minutes, the deadlock can be reproduced.(nodes need at least 10 luns respectively.)
#!/bin/bash
# discovery 2 nodes
iscsiadm -m discovery -p IP_A -t st
iscsiadm -m discovery -p IP_B -t st
# set network loss rate (eth1 connected to the ipsan)
tc qdisc add dev eth1 root netem loss 60%
# loop test
n=1
while [ 1 ]
do
     echo "$(date) ==== test loop $n ===="
     iscsiadm -m node -T iqn.xxxx::yyyy:IP_A --login
     sleep 5
     iscsiadm -m node -T iqn.xxxx::yyyy:IP_A --logout&
     iscsiadm -m node -T iqn.xxxx::yyyz:IP_B --login&
     sleep 10
     iscsiadm -m node -u
     n=$(($n + 1))
     echo "$(date) ==== continue to test loop ===="
done
