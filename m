From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x alternate add back missing scsi_queue_next_request
 calls
Date: Fri, 21 Mar 2003 17:52:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7B97A0.4010204@splentec.com>
References: <20030321141525.A8134@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Alternate version of the patch. I prefer the previous version. Posting to
> clarify the coding issues.

1. Thanks for posing this patch.

2. I know that you prefer the previous version of the patch.

Please DO NOT export scsi_queue_next_request()!  It is not needed
in LLDD and ULDD (unless they feed DIRECTLY from the request queue,
which is currently NOT the case).

cpqfcTSinit.c -- needs a scsi command to reset the device -- called
from the eh_handler.

aha152x.c -- needs a scsi command to reset the device -- called
from the eh_handler.

gdth.c -- flushing and releasing the device.
gdth_proc.c -- same.

All those users of scsi_put_command() DO NOT need to call
scsi_queue_next_request().

For this reason you do not need to export it.

Logically its part of SCSI Core's queueing mechanism and
the more reason not to export it.

3. The way this is scattered all over the place will NOT
last long.  It WILL be centralized in the near future,
for this reason I'd rather keep the slab allocation for
command struct intact.

See my previous email on scsi request and scsi command
entry points and completion notifiers -- having a centralized
place you'll be able to do all kinds of magic there.

> The change to use a pool for scsi_cmnd allocations removed some
> scsi_queue_next_request calls, this patch restores the calls, and
> exports scsi_put_command and scsi_get_command.

As I said before: look at scsi_get_command() and try to MIRROR
the same for scsi_put_command() -- one centralized place where
you can call whatever function you want and do whatever
checks and magic there.

Modularizing the command allocation is THE FIRST STEP, if we
contaminate it, all this work goes down the drain.

More and more parts of SCSI Core will be modularized similarly
and then SCSI Core will be defined in terms of their interaction.

> The extra scsi_queue_next_request calls are needed to handle non-block
> device IO completion (char devices and scsi scanning).

ONLY because they notify via scsi_done(command), but entered via
scsi_request! This needs a patch. See my previous post.

I.e. we need a patch which fixes this infrastructre, rather than
a patchwork solution. (Address at the root.)

-- 
Luben


