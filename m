From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3 version 2] scsi_lib: Collapse scsi_end_request into
 only user
Date: Mon, 4 Jan 2010 13:23:16 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1001041315230.3180-100000@iolanthe.rowland.org>
References: <4B41F637.8070809@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56600 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753068Ab0ADSXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 13:23:19 -0500
In-Reply-To: <4B41F637.8070809@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>

On Mon, 4 Jan 2010, Boaz Harrosh wrote:

> Embedding scsi_end_request() into scsi_io_completion actually simplifies the
> code and makes it clearer what's going on.
> 
> There is absolutely no functional and/or side effects changes after this patch.
> 
> Patch was inspired by Alan Stern. (version 2 comments by Matthew Wilcox)

> -	/*
> -	 * A number of bytes were successfully read.  If there
> -	 * are leftovers and there is some kind of error
> -	 * (result != 0), retry the rest.
> -	 */
> -	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
> -		return;
> -
> -	error = -EIO;
> -
> -	if (host_byte(result) == DID_RESET) {
> +	if (likely(!blk_end_request(req, error, good_bytes))) {
> +		cmd->request = NULL;
> +		action = ACTION_NEXT_CMND;
> +	} else if (error && scsi_noretry_cmd(cmd)) {
> +		/* kill remainder if no retrys */
> +		blk_end_request_all(req, error);
> +		cmd->request = NULL;
> +		action = ACTION_NEXT_CMND;
> +	} else if (result == 0) {
> +		action = ACTION_REPREP;
> +	} else if (host_byte(result) == DID_RESET) {

A few comments in these new "if" cases would help readers to understand
the logic here.

My personal preference is to reverse the order of the "if (error && 
scsi_noretry_cmd(cmd))" and the "if (result == 0)" sections.  It would 
make more sense; that way we'd have:

	If the request is finished [blk_end_request() == 0]
		...
	else if the request was successful but has more work to do
			(result == 0)
		...
	else if there was an error and retries are disallowed
		...
	else ... [other error handling]

Interchanging the order wouldn't make any functional difference, 
because the code above this point guarantees that we can never have 
result == 0 and error != 0.

Apart from these small issues, it looks perfect.

Alan Stern

