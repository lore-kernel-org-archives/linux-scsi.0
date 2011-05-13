From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 13/14] iscsi-target: Add misc utility and debug logic
Date: Fri, 13 May 2011 16:32:25 -0700
Message-ID: <1305329545.7102.53.camel@haakon2.linux-iscsi.org>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
	 <1305184041-32189-14-git-send-email-nab@linux-iscsi.org>
	 <BANLkTikMdAUjT=G+DHaJwDOXuh532uN8nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45036 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472Ab1EMXkd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 19:40:33 -0400
In-Reply-To: <BANLkTikMdAUjT=G+DHaJwDOXuh532uN8nw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Redlich <arne.redlich@googlemail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>

On Fri, 2011-05-13 at 21:30 +0200, Arne Redlich wrote:
> 2011/5/12 Nicholas A. Bellinger <nab@linux-iscsi.org>:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This file adds iscsi_target_util.[c,h] code containing a number
> > of miscellaneous utility functions for iscsi_target_mod.
> >
> > It also contains iscsi_debug.h macros for CONFIG_ISCSI_TARGET_DEBUG
> >
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> <snip>
> 
> > diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> > new file mode 100644
> > index 0000000..af1c5c44
> > --- /dev/null
> > +++ b/drivers/target/iscsi/iscsi_target_util.c
> 
> <snip>
> 
> > +
> > +struct iscsi_r2t *iscsit_get_r2t_for_eos(
> > +       struct iscsi_cmd *cmd,
> > +       u32 offset,
> > +       u32 length)
> > +{
> > +       struct iscsi_r2t *r2t;
> > +
> > +       spin_lock_bh(&cmd->r2t_lock);
> > +       list_for_each_entry(r2t, &cmd->cmd_r2t_list, r2t_list) {
> > +               if ((r2t->offset <= offset) &&
> > +                   (r2t->offset + r2t->xfer_len) >= (offset + length))
> > +                       break;
> > +       }
> > +       spin_unlock_bh(&cmd->r2t_lock);
> > +
> > +       if (!r2t) {
> > +               printk(KERN_ERR "Unable to locate R2T for Offset: %u, Length:"
> > +                               " %u\n", offset, length);
> > +               return NULL;
> > +       }
> > +
> > +       return r2t;
> > +}
> > +
> 
> Nicholas,
> 
> This lookup pattern (repeated several times throughout the patch)
> looks seriously flawed to me as r2t will never be NULL.
> 

Ugh..

Unfortuately this breakage was introduced during the v4 conversion of
iscsi-target to use struct list_head instead of the legacy raw ->next
pointers for list walking in about 10 different locations..

I have pushed the following commit into lio-core-2.6.git to address the
cases where a bogus NULL check of *pos after list_for_each_entry()
exists:

iscsi-target: Fix incorrect list_for_each_entry() NULL checks
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=af66a1368ec3256ba44656490688364084fa893d

Please review the changes in lio-core-2.6.git/lio-4.1 and let me know if
you see any more of these cases that need to be fixed, or have any
additional review comments.

So with that, I will go ahead and re-spin a proper PATCH-v4 series over
the weekend for James to merge with this patch, and hopefully one
additional v4.1 specific bugfix that is currently be investigated by
Martin.

Seriously, thanks for catching this one Arne..

Best Regards,

--nab

