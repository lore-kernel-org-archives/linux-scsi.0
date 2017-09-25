From: Vladis Dronov <vdronov@redhat.com>
Subject: Re: scsi: fix the issue that iscsi_if_rx doesn't parse nlmsg properly
Date: Mon, 25 Sep 2017 12:56:24 +0200
Message-ID: <20170925105624.14317-1-vdronov@redhat.com>
References: <0c9fd6fbc0f5fa7b72e6ae5b82d5499a38fd375e.1503836726.git.lucien.xin@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934668AbdIYK4e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Sep 2017 06:56:34 -0400
In-Reply-To: <0c9fd6fbc0f5fa7b72e6ae5b82d5499a38fd375e.1503836726.git.lucien.xin@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ChunYu Wang <chunwang@redhat.com>, Xin Long <lucien.xin@gmail.com>, Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <JBottomley@odin.com>, syzkaller@googlegroups.com, jejb@linux.vnet.ibm.com

hello,

an additional research shows that the very latest kernels are not showing
a crash with a reproducer. git bisect showed that:

commit 7f564528a480084e2318cd48caba7aef4a54a77f is the first commit (between
v4.11 and v4.12-rc1) a crash is not reproduced with:

commit 7f564528a480084e2318cd48caba7aef4a54a77f
Author: Steffen Klassert <steffen.klassert@secunet.com>
Date:   Sat Apr 8 20:36:24 2017 +0200
skbuff: Extend gso_type to unsigned int.

i.e. this is commit which fixed the crash. checking the code, it looks like
struct skb_shared_info's fields were reordered, so a field which overwrite
was causing a panic has been moved. nevertheless, the buffer overwrite is still
there, so a suggested patch 9923803 (or its later version) is still needed.

for a proof compare a flaw description:

> ev = nlmsg_data(nlh) will acutally get skb_shinfo(SKB) instead and set a
> new value to skb_shinfo(SKB)->nr_frags by ev->type.

and the commit message:

>    The remaining two byte hole is moved to the
>    beginning of the structure, this protects us
>    from immediate overwites on out of bound writes
>    to the sk_buff head.
> 
>    Structure layout on x86-64 before the change:
> 
>    struct skb_shared_info {
>            unsigned char              nr_frags;
>            __u8                       tx_flags;
> 
>    Structure layout on x86-64 after the change:
> 
>    struct skb_shared_info {
>            short unsigned int         _unused;
>            unsigned char              nr_frags;
>            __u8                       tx_flags;

Best regards,
Vladis Dronov | Red Hat, Inc. | Product Security Engineer

----- Original Message -----
From: Xin Long <lucien.xin@gmail.com>
To: linux-scsi@vger.kernel.org
Sent: Sun, 27 Aug 2017 20:25:26 +0800
Subject: scsi: fix the issue that iscsi_if_rx doesn't parse nlmsg properly

> ChunYu found a kernel crash by syzkaller:
> 
> [  651.617875] kasan: CONFIG_KASAN_INLINE enabled
> [  651.618217] kasan: GPF could be caused by NULL-ptr deref or user memory access
> [  651.618731] general protection fault: 0000 [#1] SMP KASAN
> [  651.621543] CPU: 1 PID: 9539 Comm: scsi Not tainted 4.11.0.cov #32
> [  651.621938] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  651.622309] task: ffff880117780000 task.stack: ffff8800a3188000
> [  651.622762] RIP: 0010:skb_release_data+0x26c/0x590
