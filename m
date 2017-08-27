From: Xin Long <lucien.xin@gmail.com>
Subject: [PATCH] scsi: fix the issue that iscsi_if_rx doesn't parse nlmsg properly
Date: Sun, 27 Aug 2017 20:25:26 +0800
Message-ID: <0c9fd6fbc0f5fa7b72e6ae5b82d5499a38fd375e.1503836726.git.lucien.xin@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36354 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdH0MZg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Aug 2017 08:25:36 -0400
Received: by mail-pf0-f193.google.com with SMTP id a2so2322594pfj.3
        for <linux-scsi@vger.kernel.org>; Sun, 27 Aug 2017 05:25:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, syzkaller@googlegroups.com, chunwang@redhat.com

ChunYu found a kernel crash by syzkaller:

[  651.617875] kasan: CONFIG_KASAN_INLINE enabled
[  651.618217] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  651.618731] general protection fault: 0000 [#1] SMP KASAN
[  651.621543] CPU: 1 PID: 9539 Comm: scsi Not tainted 4.11.0.cov #32
[  651.621938] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  651.622309] task: ffff880117780000 task.stack: ffff8800a3188000
[  651.622762] RIP: 0010:skb_release_data+0x26c/0x590
[...]
[  651.627260] Call Trace:
[  651.629156]  skb_release_all+0x4f/0x60
[  651.629450]  consume_skb+0x1a5/0x600
[  651.630705]  netlink_unicast+0x505/0x720
[  651.632345]  netlink_sendmsg+0xab2/0xe70
[  651.633704]  sock_sendmsg+0xcf/0x110
[  651.633942]  ___sys_sendmsg+0x833/0x980
[  651.637117]  __sys_sendmsg+0xf3/0x240
[  651.638820]  SyS_sendmsg+0x32/0x50
[  651.639048]  entry_SYSCALL_64_fastpath+0x1f/0xc2

It's caused by skb_shared_info at the end of sk_buff was overwritten by
ISCSI_KEVENT_IF_ERROR when parsing nlmsg info from skb in iscsi_if_rx.

During the loop if skb->len == nlh->nlmsg_len and both are sizeof(*nlh),
ev = nlmsg_data(nlh) will acutally get skb_shinfo(SKB) instead and set a
new value to skb_shinfo(SKB)->nr_frags by ev->type.

This patch is to fix it by checking nlh->nlmsg_len properly there to
avoid over accessing sk_buff.

Reported-by: ChunYu Wang <chunwang@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e4b3d8f..bb4ed7b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3697,7 +3697,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		uint32_t group;
 
 		nlh = nlmsg_hdr(skb);
-		if (nlh->nlmsg_len < sizeof(*nlh) ||
+		if (nlh->nlmsg_len < sizeof(*nlh) + sizeof(*ev) ||
 		    skb->len < nlh->nlmsg_len) {
 			break;
 		}
-- 
2.1.0
