From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [2.6.25] scsi mid layer: add a time threshold to force device
	to completed command queued for a long time.
Date: Tue, 11 Mar 2008 21:44:11 -0400
Message-ID: <1205286251.2941.84.camel@localhost.localdomain>
References: <e7510f760803111741h71de33b0i3764b7759a340803@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <e7510f760803111741h71de33b0i3764b7759a340803@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-03-11 at 17:41 -0700, Gwendal Grignou wrote:
> Please ignore the patch I sent earlier, it was out of context.
> [scsi_sysfs: Fix cut and paste errors]
> This patch allows to throttle command queuing to a device, if
> older commands are outstanding for too long already.
> I added a new sysfs parameter [per scsi device] req_pending_time_thres.
> If a command is still outstanding after req_pending_time_thres ms, no
> new command will be sent to the device.
> This mechanism is enabled only when req_pending_time_thres!=0 and
> the device queue uses tagging defined in blk_tag.c
> The rational for this patch is I noticed that some SATA hard drives with NCQ
> enabled have tendency to leave some commands in the back of their queue
> when they received a lot of outstanding commands. This is not a problem
> for synthetic read random test, like iometer, but it hurts performance of
> real-life applications: the deviation of the latency increase significantly
> when NCQ is enabled.
> 
> This patch slightly decrease performance during synthetic test when
> req_pending_time_thres != 0 [it is still better than when NCQ is not enabled]
> but it improves the deviation.

Firstly there's a structural problem with this:  you don't take into
account the fact that the tag map may be shared, so the first entry in
the tag list may belong to a completely different device.

Secondly, this req->timeout_time_thres is really at the wrong layer:
it's only ever set and read from SCSI, so there's not really a good
reason to place it in the request ... it should probably be in the
command.  Additionally, cmnd->jiffies_at_alloc already exists, so you
can probably get it do do everything you need without adding even a
parameter to the command.

Finally, it doesn't look like it will work well with error handling: we
use the ->queuecommand path for certain error handling commands; if the
device is stopped and we've passed the threshold, this will reject the
error handling commands as well.  The basic problem here is that the tag
is held in the block layer and isn't released until the command is
completed (after error handling is done).

James


