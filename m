From: Ming Lin <minggr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 0/1] fix bug of iscsid hung
Date: Thu,  4 Apr 2019 16:04:04 -0700
Message-ID: <1554419045-20873-1-git-send-email-minggr@gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBDUKPZWVXUMBB542TLSQKGQEIO3NJCY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: wangqiang62-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, caijin.laurence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi list,

I encountered a bug of iscsid hung when testing iscsi login/logout in unstable network.

Same as this one reported by Wangqiang@Huawei
https://lore.kernel.org/lkml/508A4C72ED914648BB0F1814399310DBBB2997-0LhPdUyVHB9548jd+VSckwK1hpo4iccwjNknBlVQO8k@public.gmane.org/

Use tc tool to simulate network packet loss.

---------- test script start -------------
tc qdisc add dev eth0 root netem loss 60
 
 # 2 target, each with 10 LUNs 

n=1
while [ 1 ]
do
     echo "$(date) ==== test loop $n ===="
     iscsiadm -m node -T iqn.2016-06.io.spdk:disk1 --login
     sleep 5
     iscsiadm -m node -T iqn.2016-06.io.spdk:disk1 --logout&
     iscsiadm -m node -T iqn.2016-06.io.spdk:disk2 --login&
     sleep 10
     iscsiadm -m node -u
     n=$(($n + 1))
     echo "$(date) ==== continue to test loop ===="
done
---------- test script end -------------

iscsid hung as below,

[  369.909988] INFO: task iscsid:1254 blocked for more than 122 seconds.
[  369.912532]       Tainted: G            E     5.1.0-rc3+ #12
[  369.914750] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  369.917396] iscsid          D    0  1254      1 0x00000080
[  369.917399] Call Trace:
[  369.920958]  schedule+0x32/0x70
[  369.922716]  schedule_timeout+0x1d8/0x300
[  369.926129]  wait_for_completion+0x123/0x190
[  369.929365]  __flush_work.isra.34+0x124/0x1b0  ===> flush_work(&session->unbind_work);
[  369.932746]  iscsi_remove_session+0xf0/0x1d0 [scsi_transport_iscsi]
[  369.934718]  iscsi_session_teardown+0x37/0xf0 [libiscsi]
[  369.936417]  iscsi_sw_tcp_session_destroy+0x42/0x60 [iscsi_tcp]
[  369.938312]  iscsi_if_recv_msg+0x69b/0x1510 [scsi_transport_iscsi]
[  369.946502]  iscsi_if_rx+0xa5/0x1e0 [scsi_transport_iscsi]
[  369.948193]  netlink_unicast+0x17f/0x230
[  369.949734]  netlink_sendmsg+0x2d2/0x3d0
[  369.951277]  sock_sendmsg+0x36/0x50
[  369.952691]  ___sys_sendmsg+0x280/0x2a0
[  369.981533]  __sys_sendmsg+0x58/0xa0
[  369.982444]  do_syscall_64+0x5b/0x180
[  369.983369]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

__flush_work() tried to flush session->unbind_work.
kworker thread that handles unbind_work blocked as below,

[  615.742259] INFO: task kworker/u4:11:1321 blocked for more than 368 seconds.
[  615.743615]       Tainted: G            E     5.1.0-rc3+ #12
[  615.744780] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  615.746274] kworker/u4:11   D    0  1321      2 0x80000080
[  615.746281] Workqueue: scsi_wq_2 __iscsi_unbind_session [scsi_transport_iscsi]
[  615.746282] Call Trace:
[  615.749131]  schedule+0x32/0x70
[  615.750065]  async_synchronize_cookie_domain+0x8b/0x140
[  615.752349]  sd_remove+0x8f/0x140 [sd_mod]
[  615.753411]  device_release_driver_internal+0xeb/0x1c0
[  615.754605]  bus_remove_device+0xe5/0x160
[  615.755702]  device_del+0x15a/0x340
[  615.759495]  __scsi_remove_device+0x9c/0x160
[  615.760673]  scsi_remove_device+0x21/0x30
[  615.761824]  scsi_remove_target+0x172/0x1c0
[  615.763001]  __iscsi_unbind_session+0xd0/0x1a0 [scsi_transport_iscsi]
[  615.764477]  process_one_work+0x171/0x380
[  615.765646]  worker_thread+0x49/0x3f0
[  615.766774]  kthread+0xf8/0x130
[  615.769974]  ret_from_fork+0x35/0x40

async_synchronize_cookie_domain() blocked until all entries in "scsi_sd_probe_domain" finished.
But some entries never finished because kworker thread that executes sd_probe_async() blocked as below,

[  492.909482] INFO: task kworker/u4:0:7 blocked for more than 122 seconds.
[  492.912321]       Tainted: G            E     5.1.0-rc3+ #6
[  492.913519] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  492.915037] kworker/u4:0    D    0     7      2 0x80000000
[  492.915046] Workqueue: events_unbound async_run_entry_fn
[  492.915047] Call Trace:
[  492.916813]  schedule+0x32/0x70
[  492.917740]  io_schedule+0x12/0x40
[  492.918659]  do_read_cache_page+0x43b/0x740
[  492.921877]  read_dev_sector+0x28/0xa0
[  492.922859]  read_lba+0xfe/0x1b0
[  492.924904]  find_valid_gpt+0xfa/0x720
[  492.927048]  efi_partition+0x89/0x430
[  492.931934]  check_partition+0x110/0x200
[  492.932960]  rescan_partitions+0xbb/0x360
[  492.934000]  __blkdev_get+0x372/0x4b0
[  492.934987]  blkdev_get+0x1a7/0x300
[  492.937892]  __device_add_disk+0x45f/0x4c0
[  492.938942]  sd_probe_async+0x13f/0x240 [sd_mod]
[  492.940065]  async_run_entry_fn+0x39/0x160
[  492.941126]  process_one_work+0x171/0x380
[  492.942181]  worker_thread+0x49/0x3f0
[  492.943169]  kthread+0xf8/0x130
[  492.946140]  ret_from_fork+0x35/0x40

The iscsi command sent by do_read_cache_page() timedout in my test, but it's never completed/aborted
because session->state is ISCSI_STATE_FAILED and iscsi_eh_cmd_timed_out() keep returning BLK_EH_RESET_TIMER.

1947 enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
1948 {
......
......
1972         if (session->state != ISCSI_STATE_LOGGED_IN) {
1973                 /*
1974                  * During shutdown, if session is prematurely disconnected,
1975                  * recovery won't happen and there will be hung cmds. Not
1976                  * handling cmds would trigger EH, also bad in this case.
1977                  * Instead, handle cmd, allow completion to happen and let
1978                  * upper layer to deal with the result.
1979                  */
1980                 if (unlikely(system_state != SYSTEM_RUNNING)) {
1981                         sc->result = DID_NO_CONNECT << 16;
1982                         ISCSI_DBG_EH(session, "sc on shutdown, handled\n");
1983                         rc = BLK_EH_DONE;
1984                         goto done;
1985                 }
1986                 /*
1987                  * We are probably in the middle of iscsi recovery so let
1988                  * that complete and handle the error.
1989                  */
1990                 rc = BLK_EH_RESET_TIMER;
1991                 goto done;
1992         }

I ported Wangqiang's patch to latest 5.1-rc kernel and it fixed this bug.
Please help review it.

Thanks,
Ming

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
