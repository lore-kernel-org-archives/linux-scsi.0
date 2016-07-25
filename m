From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Mon, 25 Jul 2016 17:23:25 -0400
Message-ID: <20160725212325.GA23961@redhat.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com>
 <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbcGYVX1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 17:23:27 -0400
Content-Disposition: inline
In-Reply-To: <20160725175344.GA23000@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Mon, Jul 25 2016 at  1:53pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Jul 21 2016 at  4:58pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
> 
> > On 07/20/2016 11:33 AM, Mike Snitzer wrote:
> > >Would be interesting to know the error returned from map_request()'s
> > >ti->type->clone_and_map_rq().  Really should just be DM_MAPIO_REQUEUE.
> > >But the stack you've provided shows map_request calling
> > >dm_complete_request(), which implies dm_kill_unmapped_request() is being
> > >called due to ti->type->clone_and_map_rq() returning < 0.
> > 
> > Hello Mike,
> > 
> > Apparently certain requests fail with -EIO because DM_DEV_SUSPEND
> > ioctls are being submitted to the same multipath target. As you know
> > DM_DEV_SUSPEND changes QUEUE_IF_NO_PATH from 1 into 0. A WARN_ON()
> > statement that I added in driver dm-mpath statement learned me that
> > multipathd is submitting these DM_DEV_SUSPEND ioctls. In the output
> > of strace -fp$(pidof multipathd) I found the following:
> > 
> > [pid 13927] ioctl(5, DM_TABLE_STATUS, 0x7fa1000483f0) = 0
> > [pid 13927] write(1, "mpathbe: failed to setup multipa"..., 35) = 35
> > [pid 13927] write(1, "dm-0: uev_add_map failed\n", 25) = 25
> > [pid 13927] write(1, "uevent trigger error\n", 21) = 21
> > [pid 13927] write(1, "sdh: remove path (uevent)\n", 26) = 26
> > [pid 13927] ioctl(5, DM_TABLE_LOAD, 0x7fa1000483f0) = 0
> > [pid 13927] ioctl(5, DM_DEV_SUSPEND, 0x7fa1000483f0) = 0
> > 
> > I'm still analyzing these and other messages.
> 
> The various ioctls you're seeing is just multipathd responding to the
> failures.  Part of reloading a table (with revised path info, etc) is to
> suspend and then resume the device that is being updated.
> 
> But I'm not actually sure on the historic reasoning of why
> queue_if_no_path is disabled (and active setting saved) on suspend.
> 
> I'll think about this further but maybe others recall why?

I think it dates back to when we queued IO within the multipath target.
Commit e809917735ebf ("dm mpath: push back requests instead of
queueing") obviously changed how we handle the retry.

But regardless __must_push_back() should catch the case where
queue_io_no_path is cleared during suspend (by checking if current !=
saved).

SO I'd be curious to know if your debugging has enabled you to identify
exactly where in the dm-mapth.c code the -EIO return is being
established.  do_end_io() is the likely candidate -- but again the
__must_push_back() check should prevent it and DM_ENDIO_REQUEUE should
be returned.

Mike
