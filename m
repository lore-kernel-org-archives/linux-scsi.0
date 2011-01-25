From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH 2/4] scsi: pm8001: simplify workqueue usage
Date: Tue, 25 Jan 2011 15:12:54 +0800
Message-ID: <9F94217BD54C49A9B04998760F52CA7E@usish.com.cn>
References: <1295877451-16602-1-git-send-email-tj@kernel.org> <1295877451-16602-3-git-send-email-tj@kernel.org> <1295930543.15425.136.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:52407 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1AYHM7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2011 02:12:59 -0500
In-Reply-To: <1295930543.15425.136.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'Tejun Heo' <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, lindar_liu@usish.com

 > 
> On Mon, 2011-01-24 at 14:57 +0100, Tejun Heo wrote:
> > pm8001 manages its own list of pending works and cancel them on device
> > free.  It is unnecessarily complex and has a race condition - the
> > works are canceled but not synced, so the work could still be running
> > during and after the data structures are freed.
> >
> > This patch simplifies workqueue usage.
> >
> > * A driver specific workqueue pm8001_wq is created to serve these
> >   work items.
> >
> > * To avoid confusion, the "queue" suffixes are dropped from work items
> >   and functions.
> >
> > * Delayed queueing was never used.  pm8001_work now uses work_struct
> >   instead.
> >
> > * The driver no longer keeps track of pending works.  All pm8001_works
> >   are queued to pm8001_wq and the workqueue is flushed as necessary.
> >
> > flush_scheduled_work() usage is removed during conversion.
> 
> cc'ing pm8001 maintainers for an opinion.  Jack could you look at this
> and ack, please.
> 
> Thanks,
> 
> James
> 
[Jack Wang] Looks Okay to me. Ack-by: Jack Wang <jack_wang@usish.com>
	 Thanks

