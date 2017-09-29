From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: fix the issue that iscsi_if_rx doesn't parse
 nlmsg properly
Date: Fri, 29 Sep 2017 09:33:34 -0400
Message-ID: <1506692014.4100.543.camel@localhost.localdomain>
References: <0c9fd6fbc0f5fa7b72e6ae5b82d5499a38fd375e.1503836726.git.lucien.xin@gmail.com>
         <yq1a81ih92k.fsf@oracle.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbdI2Ndf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Sep 2017 09:33:35 -0400
In-Reply-To: <yq1a81ih92k.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Xin Long <lucien.xin@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, syzkaller@googlegroups.com, chunwang@redhat.com

On Mon, 2017-09-25 at 15:28 -0400, Martin K. Petersen wrote:
> Xin,
> 
> > ChunYu found a kernel crash by syzkaller:
> 
> [...]
> 
> > It's caused by skb_shared_info at the end of sk_buff was overwritten by
> > ISCSI_KEVENT_IF_ERROR when parsing nlmsg info from skb in iscsi_if_rx.
> >
> > During the loop if skb->len == nlh->nlmsg_len and both are sizeof(*nlh),
> > ev = nlmsg_data(nlh) will acutally get skb_shinfo(SKB) instead and set a
> > new value to skb_shinfo(SKB)->nr_frags by ev->type.
> >
> > This patch is to fix it by checking nlh->nlmsg_len properly there to
> > avoid over accessing sk_buff.
> 
> Applied to 4.14/scsi-fixes. Thank you!
> 

Should this be considered for -stable?  (Despite not being reproduced
after 7f564528a4).
