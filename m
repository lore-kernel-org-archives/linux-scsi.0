From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding ordered-tag support.
Date: Thu, 09 Feb 2006 12:20:35 -0500
Message-ID: <1139505635.3275.43.camel@mulgrave.il.steeleye.com>
References: <43E99248.7090505@gmail.com>
	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
	 <43EA17E6.4000800@gmail.com> <43EA1B75.40008@emulex.com>
	 <43EA2313.9030506@gmail.com>
	 <1139418451.3003.37.camel@mulgrave.il.steeleye.com>
	 <43EA27E4.9080105@gmail.com>
	 <1139419637.3003.43.camel@mulgrave.il.steeleye.com>
	 <43EA329F.2000906@pobox.com>  <43EAC110.5030700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5271 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965241AbWBIRVH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 12:21:07 -0500
In-Reply-To: <43EAC110.5030700@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2006-02-09 at 13:12 +0900, Tejun Heo wrote:
> Maybe I have misunderstood, but, AFAICS, linked task doesn't assure any 
> ordering relation with respect to other tasks unlike ordered tag.  So, 
> it doesn't make much difference compared to simple & stupid ordering by 
> draining.  For a barrier to work, the following order should be kept.

It's a different paradigm from barriers.  With a barrier, it's an
impassable object in the I/O stream (nothing overtakes it or falls
behind it).  With a link, there's a set of commands (the linked set, and
there may be more than one linked set of commands) that have to be
ordered within the link.  The point is that most of our problems with
barriers are figuring out how to prevent leaks.  The linked command
paradigm is much more forgiving in this regard.

> pre-barrier writes -> cache flush -> barrier write (FUA) -> other writes
> 
> Issuing cache flush and barrier write with ordered tags accomplishes all 
> the ordering requirements (if it works, that is.).  I can see linked 
> task can be used for 'cache flush -> barrier write (FUA)' segment but 
> that leaves us with two unhandled ordering requirements.

Right, that's why I said we'd have to change the block layer API to use
linked commands.

> Another thing I'm curious about linked task is what advantages linked 
> task has over simply issuing and completing the commands sequentially. 
> Commands in a linked task has to be issued and completed sequentially 
> anyway, so I don't really see the difference.

The fact that tasks can proceed in parallel, only the command components
individual linked tasks must be serialised. so it supports the TCQ
paradigm.

Really, also, linked tasks is exactly what a JFS wants because most of
the updates that would be linked are something like update log entry;
modify metadata (or data); remove log entry.

James


