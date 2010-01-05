From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3 version 4] scsi_lib: Collapse scsi_end_request into
 only user
Date: Tue, 5 Jan 2010 10:20:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1001051014200.3002-100000@iolanthe.rowland.org>
References: <4B43013E.9010502@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56268 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754744Ab0AEPUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2010 10:20:22 -0500
In-Reply-To: <4B43013E.9010502@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 5 Jan 2010, Boaz Harrosh wrote:

> Embedding scsi_end_request() into scsi_io_completion actually simplifies
> the code and makes it clearer what's going on.
> 
> There is absolutely no functional and/or side effects changes after this
> patch.

Here are some suggestions for changes to the comments.  These are quite
minor and you might not want to bother updating the patch yet again...

> +	if (likely(0 == blk_end_request(req, error, good_bytes))) {
> +		/* All is done and good move to next command */

		/* The command completed successfully; move on to the next. */

> +		cmd->request = NULL;
> +		action = ACTION_NEXT_CMND;
> +	} else if (result == 0) {
> +		/* Wrote some bytes but request was split */

		/* The command was successful but not all the data was
		 * transferred; re-prep the command to handle the rest.
		 */

> +		action = ACTION_REPREP;
> +	} else if (error && scsi_noretry_cmd(cmd)) {
> +		/* kill remainder if no retries */

		/* Error.  Kill the request since retries are disallowed. */

> +		blk_end_request_all(req, error);
> +		cmd->request = NULL;
> +		action = ACTION_NEXT_CMND;
> +	} else if (host_byte(result) == DID_RESET) {

Alan Stern

