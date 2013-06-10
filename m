From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 11:19:16 -0400
Message-ID: <20130610151916.GA18076@logfs.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-4-git-send-email-hare@suse.de>
 <20130610082001.GB7816@infradead.org>
 <51B595C1.8040106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59496 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FJQsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jun 2013 12:48:51 -0400
Content-Disposition: inline
In-Reply-To: <51B595C1.8040106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On Mon, 10 June 2013 11:00:49 +0200, Hannes Reinecke wrote:
> On 06/10/2013 10:20 AM, Christoph Hellwig wrote:
> >=20
> > Why can't we use a work item per command?  Linking things into a li=
st
> > just to queue it up to workqueues missed half of the point of the
> > workqueue infrastructure.
> >=20
> Hmm. I felt that using a per command workqueue might be a bit excessi=
ve.
> Also the current semantics call for a synchronous command abort.
> So even using a per command workqueue won't buy us anything as the
> workqueue item would have to wait for the command abort to complete,
> which again is quite a waste.

Not sure if you confuse workqueue with workitem.  Either way, using a
single work item to handle a queue of commands does not fly and we
either have to use per-command work items or abandon work queues and
use a kernel thread.  The middle ground is either racy or useless.

I don't care too much whether we use per-command work items or a
single system-global thread.  This shouldn't ever become a hot path or
the system is screwed anyway.  The only problem with our current error
handling is that even rare errors can effectively break the system.

J=C3=B6rn

--
Victory in war is not repetitious.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
