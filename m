From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.x alternate add back missing scsi_queue_next_request calls
Date: Fri, 21 Mar 2003 16:24:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321162421.A9398@beaverton.ibm.com>
References: <20030321141525.A8134@beaverton.ibm.com> <3E7B97A0.4010204@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7B97A0.4010204@splentec.com>; from luben@splentec.com on Fri, Mar 21, 2003 at 05:52:16PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Mar 21, 2003 at 05:52:16PM -0500, Luben Tuikov wrote:

> All those users of scsi_put_command() DO NOT need to call
> scsi_queue_next_request().
> 
> For this reason you do not need to export it.

OK ... new version in a few minutes.

> cpqfcTSinit.c -- needs a scsi command to reset the device -- called
> from the eh_handler.

Not exactly but the driver does't compile as it uses scsi_do_cmd, and is
commented as needing a switch to Scsi_Request, so:

OK.

> aha152x.c -- needs a scsi command to reset the device -- called
> from the eh_handler.

OK

> gdth.c -- flushing and releasing the device.

OK. The driver is also broken, still using scsi_do_cmd.

> gdth_proc.c -- same.

It's a proc interface to get or set info, but again it is broken using
scsi_do_cmd, so also:

OK.

> ONLY because they notify via scsi_done(command), but entered via
> scsi_request! This needs a patch. See my previous post.
> 
> I.e. we need a patch which fixes this infrastructre, rather than
> a patchwork solution. (Address at the root.)

No one disagrees with fixing up the code, but it takes time. You don't
have to repeat this point in every post.

-- Patrick Mansfield
