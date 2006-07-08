From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi_lib.c: do not requeue on success
Date: Sat, 08 Jul 2006 00:15:08 -0500
Message-ID: <1152335708.3866.97.camel@mulgrave.il.steeleye.com>
References: <20060708040909.60001.qmail@web31815.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61582 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751193AbWGHFPL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 01:15:11 -0400
In-Reply-To: <20060708040909.60001.qmail@web31815.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2006-07-07 at 21:09 -0700, Luben Tuikov wrote:
> -       if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
> +       if (scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)


Um, why?

I merely reverted this hunk back to the original code to fix the SATA
flushing problem.  The requeue code in scsi_end_request() is

	if (end_that_request_chunk(req, uptodate, bytes)) {
[...]
		/* kill remainder if no retrys */
		if (!uptodate && blk_noretry_request(req))
			end_that_request_chunk(req, 0, leftover);
		else {
			if (requeue) {
				/*
				 * Bleah.  Leftovers again.  Stick the
				 * leftovers in the front of the
				 * queue, and goose the queue again.
				 */
				scsi_requeue_command(q, cmd);
				cmd = NULL;
			}
			return cmd;
		}

however, since we go into scsi_end_request() with uptodate == 1, we
always hit the else code if good_bytes is less than the actual request
size.  Now, if we have an actual error, i.e. result != 0 it looks to me
like we want to continue on in scsi_io_completion and process it (i.e.
return and don't requeue).  I think if good_bytes is less than the
request size and result == 0 we want to requeue (this is for the case
where we had to process the request with a SCSI command that couldn't
contain the entire request length, so we have to keep going around until
we complete it---realistically only READ/WRITE(6), I think).

James


