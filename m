From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 3/3] target: Minor sparse warning fixes and annotations
Date: Mon, 24 Jan 2011 15:51:36 -0600
Message-ID: <1295905896.15425.17.camel@mulgrave.site>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
	 <1295901446-17089-4-git-send-email-nab@linux-iscsi.org>
	 <1295902567.15425.13.camel@mulgrave.site>
	 <1295904802.24778.47.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1AXVvl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 16:51:41 -0500
In-Reply-To: <1295904802.24778.47.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>

On Mon, 2011-01-24 at 13:33 -0800, Nicholas A. Bellinger wrote:
> On Mon, 2011-01-24 at 14:56 -0600, James Bottomley wrote:
> > On Mon, 2011-01-24 at 12:37 -0800, Nicholas A. Bellinger wrote:
> > > -#define TASK_CMD(task) ((struct se_cmd *)task->task_se_cmd)
> > > -#define TASK_DEV(task) ((struct se_device *)task->se_dev)
> > > +#define TASK_CMD(task) ((task)->task_se_cmd)
> > > +#define TASK_DEV(task) ((task)->se_dev)
> > 
> > If sparse is objecting to things like this then sparse needs fixing:
> > It's decreasing typesafety.  the things being cast are void * ... they'd
> > be depositable into any pointer whatsoever without the cast.  With the
> > cast in the #define, we pick up pointer mismatches (as we should).
> > Without it, we don't.  As long as the define is always a specific type,
> > it *should* cast to it.
> > 
> 
> Hmmm, good point..  In that case I will go ahead and drop this part of
> the patch.

Actually, I misspoke on this.  They're not void *; they're defined as
struct pointers ... so the cast is actually a spurious double cast.  As
long as the rest are, I'm fine with this.

James


