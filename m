From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 3/3] target: Minor sparse warning fixes and annotations
Date: Tue, 25 Jan 2011 00:56:10 +0100
Message-ID: <20110125005610.11d5d143@stein>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
	<1295901446-17089-4-git-send-email-nab@linux-iscsi.org>
	<1295902567.15425.13.camel@mulgrave.site>
	<1295904802.24778.47.camel@haakon2.linux-iscsi.org>
	<1295905896.15425.17.camel@mulgrave.site>
	<1295907147.24778.53.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45640 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1AXX4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 18:56:18 -0500
In-Reply-To: <1295907147.24778.53.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>

On Jan 24 Nicholas A. Bellinger wrote:
> On Mon, 2011-01-24 at 15:51 -0600, James Bottomley wrote:
> > On Mon, 2011-01-24 at 13:33 -0800, Nicholas A. Bellinger wrote:
> > > On Mon, 2011-01-24 at 14:56 -0600, James Bottomley wrote:
> > > > On Mon, 2011-01-24 at 12:37 -0800, Nicholas A. Bellinger wrote:
> > > > > -#define TASK_CMD(task) ((struct se_cmd *)task->task_se_cmd)
> > > > > -#define TASK_DEV(task) ((struct se_device *)task->se_dev)
> > > > > +#define TASK_CMD(task) ((task)->task_se_cmd)
> > > > > +#define TASK_DEV(task) ((task)->se_dev)
> > > > 
> > > > If sparse is objecting to things like this then sparse needs fixing:
> > > > It's decreasing typesafety.  the things being cast are void * ... they'd
> > > > be depositable into any pointer whatsoever without the cast.  With the
> > > > cast in the #define, we pick up pointer mismatches (as we should).
> > > > Without it, we don't.  As long as the define is always a specific type,
> > > > it *should* cast to it.
> > > > 
> > > 
> > > Hmmm, good point..  In that case I will go ahead and drop this part of
> > > the patch.
> > 
> > Actually, I misspoke on this.  They're not void *; they're defined as
> > struct pointers ... so the cast is actually a spurious double cast.  As
> > long as the rest are, I'm fine with this.
> > 
> 
> Committed as seperate commit b58b76c -> lio-core-2.6.git/linus-38-rc2,
> and picked into the mainline queue @ scsi-post-merge-2.6.git/for-jejb.

Why do you provide macros for a simple structure member dereference?

And if you *really* need these helpers, why not

static inline struct se_cmd *cmd_of(struct se_task *task)
{
	return task->task_se_cmd;
}

(But then, I see no reason at all not to write it as task->task_se_cmd at
the user sites.)
-- 
Stefan Richter
-=====-==-== ---= ==--=
http://arcgraph.de/sr/
