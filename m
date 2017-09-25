From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fix the issue that iscsi_if_rx doesn't parse nlmsg properly
Date: Mon, 25 Sep 2017 15:28:19 -0400
Message-ID: <yq1a81ih92k.fsf@oracle.com>
References: <0c9fd6fbc0f5fa7b72e6ae5b82d5499a38fd375e.1503836726.git.lucien.xin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31808 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934880AbdIYT2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Sep 2017 15:28:44 -0400
In-Reply-To: <0c9fd6fbc0f5fa7b72e6ae5b82d5499a38fd375e.1503836726.git.lucien.xin@gmail.com>
        (Xin Long's message of "Sun, 27 Aug 2017 20:25:26 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, syzkaller@googlegroups.com, chunwang@redhat.com


Xin,

> ChunYu found a kernel crash by syzkaller:

[...]

> It's caused by skb_shared_info at the end of sk_buff was overwritten by
> ISCSI_KEVENT_IF_ERROR when parsing nlmsg info from skb in iscsi_if_rx.
>
> During the loop if skb->len == nlh->nlmsg_len and both are sizeof(*nlh),
> ev = nlmsg_data(nlh) will acutally get skb_shinfo(SKB) instead and set a
> new value to skb_shinfo(SKB)->nr_frags by ev->type.
>
> This patch is to fix it by checking nlh->nlmsg_len properly there to
> avoid over accessing sk_buff.

Applied to 4.14/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
