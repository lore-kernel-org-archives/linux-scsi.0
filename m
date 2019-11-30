Return-Path: <SRS0=mhd7=ZW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78C5C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 07:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C2972075C
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 07:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfK3HZk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Nov 2019 02:25:40 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725298AbfK3HZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Nov 2019 02:25:40 -0500
Received: from DGGEML403-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 69B62B5CE3B3A718B691;
        Sat, 30 Nov 2019 15:25:38 +0800 (CST)
Received: from DGGEML505-MBX.china.huawei.com ([169.254.12.88]) by
 DGGEML403-HUB.china.huawei.com ([fe80::74d9:c659:fbec:21fa%31]) with mapi id
 14.03.0439.000; Sat, 30 Nov 2019 15:25:27 +0800
From:   "wubo (T)" <wubo40@huawei.com>
To:     Lee Duncan <LDuncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
CC:     Mingfangsen <mingfangsen@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: RE: [PATCH V4] scsi: avoid potential deadlock in iscsi_if_rx func
Thread-Topic: [PATCH V4] scsi: avoid potential deadlock in iscsi_if_rx func
Thread-Index: AdWnTxEsStx3PExLTm21jFNMmytp6A==
Date:   Sat, 30 Nov 2019 07:25:26 +0000
Message-ID: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6915E68ABC@dggeml505-mbx.china.huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Friendy ping...

> 
> In iscsi_if_rx func, after receiving one request through iscsi_if_recv_msg func,
> iscsi_if_send_reply will be called to try to reply the request in do-loop.
> If the return of iscsi_if_send_reply func return -EAGAIN all the time, one
> deadlock will occur.
> 
> For example, a client only send msg without calling recvmsg func, then it will
> result in the watchdog soft lockup.
> The details are given as follows,
> 
> Details of the special case which can cause deadlock:
> 
> sock_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ISCSI); retval =
> bind(sock_fd, (struct sock addr*) & src_addr, sizeof(src_addr); while (1) {
>          state_msg = sendmsg(sock_fd, &msg, 0);
>          //Note: recvmsg(sock_fd, &msg, 0) is not processed here.
> }
> close(sock_fd);
> 
> watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [netlink_test:253305]
> Sample time: 4000897528 ns(HZ: 250) Sample stat:
> curr: user: 675503481560, nice: 321724050, sys: 448689506750, idle:
> 4654054240530, iowait: 40885550700, irq: 14161174020, softirq: 8104324140,
> st: 0
> deta: user: 0, nice: 0, sys: 3998210100, idle: 0, iowait: 0, irq: 1547170, softirq:
> 242870, st: 0 Sample softirq:
>          TIMER:        992
>          SCHED:          8
> Sample irqstat:
>          irq    2: delta       1003, curr:    3103802, arch_timer
> CPU: 7 PID: 253305 Comm: netlink_test Kdump: loaded Tainted: G
> OE
> Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
> pstate: 40400005 (nZcv daif +PAN -UAO)
> pc : __alloc_skb+0x104/0x1b0
> lr : __alloc_skb+0x9c/0x1b0
> sp : ffff000033603a30
> x29: ffff000033603a30 x28: 00000000000002dd
> x27: ffff800b34ced810 x26: ffff800ba7569f00
> x25: 00000000ffffffff x24: 0000000000000000
> x23: ffff800f7c43f600 x22: 0000000000480020
> x21: ffff0000091d9000 x20: ffff800b34eff200
> x19: ffff800ba7569f00 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000
> x15: 0000000000000000 x14: 0001000101000100
> x13: 0000000101010000 x12: 0101000001010100
> x11: 0001010101010001 x10: 00000000000002dd
> x9 : ffff000033603d58 x8 : ffff800b34eff400
> x7 : ffff800ba7569200 x6 : ffff800b34eff400
> x5 : 0000000000000000 x4 : 00000000ffffffff
> x3 : 0000000000000000 x2 : 0000000000000001
> x1 : ffff800b34eff2c0 x0 : 0000000000000300 Call trace:
> __alloc_skb+0x104/0x1b0
> iscsi_if_rx+0x144/0x12bc [scsi_transport_iscsi]
> netlink_unicast+0x1e0/0x258
> netlink_sendmsg+0x310/0x378
> sock_sendmsg+0x4c/0x70
> sock_write_iter+0x90/0xf0
> __vfs_write+0x11c/0x190
> vfs_write+0xac/0x1c0
> ksys_write+0x6c/0xd8
> __arm64_sys_write+0x24/0x30
> el0_svc_common+0x78/0x130
> el0_svc_handler+0x38/0x78
> el0_svc+0x8/0xc
> 
> Here, we add one limit of retry times in do-loop to avoid the deadlock.
> 
> V4:
> 	- modify the patch subject, no code change.
> 
> V3:
> 	- replace the error with warning as suggested by Ulrich
> 
> V2:
> 	- add some debug kernel message as suggested by Lee Duncan
> 
> Signed-off-by: Bo Wu <wubo40@huawei.com>
> Reviewed-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Reviewed-by: Lee Duncan <LDuncan@suse.com>
> ---
> drivers/scsi/scsi_transport_iscsi.c | 7 +++++++
> 1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c
> b/drivers/scsi/scsi_transport_iscsi.c
> index 417b868d8735..ed8d9709b9b9 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -24,6 +24,8 @@
> 
>  #define ISCSI_TRANSPORT_VERSION "2.0-870"
> 
> +#define ISCSI_SEND_MAX_ALLOWED  10
> +
> #define CREATE_TRACE_POINTS
> #include <trace/events/iscsi.h>
> 
> @@ -3682,6 +3684,7 @@ iscsi_if_rx(struct sk_buff *skb)
>                 struct nlmsghdr       *nlh;
>                 struct iscsi_uevent *ev;
>                 uint32_t group;
> +                int retries = ISCSI_SEND_MAX_ALLOWED;
> 
>                  nlh = nlmsg_hdr(skb);
>                 if (nlh->nlmsg_len < sizeof(*nlh) + sizeof(*ev) || @@
> -3712,6 +3715,10 @@ iscsi_if_rx(struct sk_buff *skb)
>                                    break;
>                           err = iscsi_if_send_reply(portid,
> nlh->nlmsg_type,
>                                                         ev,
> sizeof(*ev));
> +                          if (err == -EAGAIN && --retries < 0) {
> +                                   printk(KERN_WARNING "Send
> reply failed, error %d\n", err);
> +                                   break;
> +                          }
>                 } while (err < 0 && err != -ECONNREFUSED && err !=
> -ESRCH);
>                 skb_pull(skb, rlen);
>        }
> --
> 1.8.3.1

