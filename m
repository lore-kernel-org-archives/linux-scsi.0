From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/4] qla2xxx: Add DebugFS node for target sess list.
Date: Sat, 06 Feb 2016 21:00:49 -0800
Message-ID: <1454821249.10001.27.camel@haakon3.risingtidesystems.com>
References: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
	 <1454604319-27947-4-git-send-email-himanshu.madhani@qlogic.com>
	 <1454820035.10001.17.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54773 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbcBGFAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2016 00:00:50 -0500
In-Reply-To: <1454820035.10001.17.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, Quinn Tran <quinn.tran@qlogic.com>

On Sat, 2016-02-06 at 20:40 -0800, Nicholas A. Bellinger wrote:
> Hi Himanshu & Quinn,
> 
> On Thu, 2016-02-04 at 11:45 -0500, Himanshu Madhani wrote:
> > From: Quinn Tran <quinn.tran@qlogic.com>
> > 
> >  #cat  /sys/kernel/debug/qla2xxx/qla2xxx_31/tgt_sess
> >  qla2xxx_31
> >  Port ID   Port Name                Handle
> >  ff:fc:01  21:fd:00:05:33:c7:ec:16  0
> >  01:0e:00  21:00:00:24:ff:7b:8a:e4  1
> >  01:0f:00  21:00:00:24:ff:7b:8a:e5  2
> >  ....
> > 
> > Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
> > Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_def.h    |    1 +
> >  drivers/scsi/qla2xxx/qla_dfs.c    |   55 ++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/qla2xxx/qla_target.c |   56 ++++++++++++++++++++++++------------
> >  3 files changed, 93 insertions(+), 19 deletions(-)
> > 
> 
> So looking at this patch beyond the debugfs part, it does change where
> ->check_initiator_node_acl() gets call during qlt_create_sess().
> 
> I assume this is related to new debugfs attribute, and these changes
> (plus others in qlt_del_sess_work_fn) are not bug-fixes on their own,
> correct..?
> 
> Aside from that, I don't have an objection to merge as v4.6 for-next
> code if QLogic finds it useful for debugging.
> 

Btw, this patch has a conflict with target-pending/queue-next wrt to
removal of be_sid + loopid from tgt_ops->check_initiator_node_acl(),
which is part of the target_alloc_session() conversion for v4.6.

Here's the updated version that's been applied to queue-next:

https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=queue-next&id=cfd527d9db57ceac8a1e211b77c3357259df48cc

Please verify that it looks + works as expected.

