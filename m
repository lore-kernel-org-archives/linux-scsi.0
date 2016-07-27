From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 27 Jul 2016 15:54:27 -0400
Message-ID: <20160727195426.GB7322@redhat.com>
References: <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com>
 <20160725212325.GA23961@redhat.com>
 <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
 <20160726011607.GA77078@redhat.com>
 <577bc6d5-9c78-b6d3-10f7-10626c0da516@sandisk.com>
 <20160727140828.GA5692@redhat.com>
 <20160727155215.GA12197@octiron.msp.redhat.com>
 <81581dc1-46d1-193b-748f-54a0524634f6@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbcG0Ty3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2016 15:54:29 -0400
Content-Disposition: inline
In-Reply-To: <81581dc1-46d1-193b-748f-54a0524634f6@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jul 27 2016 at  3:06pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 07/27/2016 08:52 AM, Benjamin Marzinski wrote:
> >if you look in drivers/md/dm-ioctl.c at do_resume(), device mapper
> >internally does a suspend when you call resume with a new table loaded.
> >That's when these suspends are happening.
> >
> >In the userspace tools, this happens in the DM_DEVICE_RESUME calls after
> >dm_addmap_reload(), which loads the new table.  These all happen in the
> >domap() function.

multipathd's only call to dm_addmap_reload() with flush = true is the
ACT_RESIZE case in do_map().

> Thanks Ben for chiming in. As far as I can see md->map is only used
> in the I/O submission path but not in the I/O completion path. So
> why to suspend and resume I/O before activating the new map? Do you
> think it would be safe to activate the new map without suspending
> and resuming I/O?

That is the DM state machine.  Before a new table can be swapped in, via
resume, the old map needs to first be suspended.

I appreciate you just hunting for _why_ on this but questioning this
aspect of userspace <-> kernel ioctl interface between multipathd and
dm-mpath isn't productive.

I'll focus on reviewing 4.7's flag management (if there is anywhere that
queue_if_no_path and the saved_ variant are managed without holding the
lock).  Basically the 4.7 changes that reduced/dropped holding the
m->lock in so many places could have allowed for some race that is
causing must_push_back() to return false (in 4.7) when it previously
return true (<= 4.6).
