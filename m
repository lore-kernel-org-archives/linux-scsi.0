From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: make use of the residue value
Date: Fri, 23 May 2008 17:00:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805231658110.3106-100000@iolanthe.rowland.org>
References: <1205022257.2893.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47855 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755651AbYEWVAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2008 17:00:13 -0400
In-Reply-To: <1205022257.2893.29.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Was there every any definite reason for not accepting this, or 
something like it?  Did it turn out not to be needed?

Alan Stern


On Sat, 8 Mar 2008, James Bottomley wrote:

> What I was actually looking for was something simpler.  How about this?
> I'll still have to run it through the test wringer since it might still
> end up causing problems if drivers are careless about their residue
> calculations.
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index e5c6f6a..96dbc63 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -759,9 +759,16 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  
>  	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
>          if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
> +		int old_good_bytes = good_bytes;
>  		drv = scsi_cmd_to_driver(cmd);
>  		if (drv->done)
>  			good_bytes = drv->done(cmd);
> +		/*
> +		 * USB may not give sense identifying bad sector and
> +		 * simply return a residue instead.
> +		 */
> +		if (good_bytes == old_good_bytes)
> +			good_bytes -= scsi_get_resid(cmd);
>  	}
>  	scsi_io_completion(cmd, good_bytes);
>  }

