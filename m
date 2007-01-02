From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] Prevent infinite retries due to DID_RESET return status
Date: Tue, 2 Jan 2007 12:15:14 +0000
Message-ID: <20070102121514.GA31621@infradead.org>
References: <457DD0CA.9010509@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58816 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbXABMPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2007 07:15:16 -0500
Content-Disposition: inline
In-Reply-To: <457DD0CA.9010509@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeremy Higdon <jeremy@sgi.com>

On Mon, Dec 11, 2006 at 03:42:34PM -0600, Michael Reed wrote:
> Due to a firmware mismatch between a host and target (names withheld to
> protect the innocent?), the LLDD was returning DID_RESET for every
> i/o command.  This patch modifies the scsi layer to take into account
> when the command which received DID_RESET was issued and eventually
> give up on it instead of unconditionally reissuing it forever
> when it receives a DID_RESET.  With this patch, on my test system,
> the command receiving the constant DID_RESET times out after about
> 360 seconds.
> 
> The premise for this patch is that no command should have an infinite
> lifetime.  The impetus for this patch was a system which would not
> reach a command prompt without disconnecting the storage from the
> host.
> 
> The significant change in this patch is to call scsi_retry_command()
> instead of scsi_requeue_command() if the command which receives a
> DID_RESET did not complete any i/o (good_bytes==0).  scsi_retry_command()
> does not release the command and regenerate it like scsi_requeue_command()
> does, hence jiffies_at_alloc reflects when the command was first issued.

Generally this patch looks good to me.  Some comments:


> -extern int scsi_retry_command(struct scsi_cmnd *cmd);
> +extern int scsi_retry_command(struct scsi_cmnd *cmd, int reason);

	I've just sent a patch to kill scsi_retry_command.  Use
	scsi_queue_insert directly instead.

> +	scsi_release_buffers(cmd);

	Can you please separate out the moving of the scsi_release_buffer
	calls into a separate patch so it can be audited better?

> @@ -961,9 +992,20 @@ void scsi_io_completion(struct scsi_cmnd
>  		/* Third party bus reset or reset for error recovery
>  		 * reasons.  Just retry the request and see what
>  		 * happens.
> +		 * If no data was transferred, just reissue this
> +		 * command.  If data was transferred, regenerate
> +		 * the command to transfer only untransferred data.
>  		 */

The whole comment should look more like:

		/*
		 * Third party bus reset or reset for error recovery reasons.
		 * If no data was transferred, just reissue this command.
		 * If data was transferred, regenerate the command to transfer
		 * only untransferred data.
		 */

> -		scsi_requeue_command(q, cmd);
> -		return;
> +		if (!good_bytes) {
> +			if (!(scsi_command_expired(cmd))) {
> +				scsi_retry_command(cmd, SCSI_MLQUEUE_DID_RESET);
> +				return;
> +			}
> +		}
> +		else {
> +			scsi_requeue_command(q, cmd);
> +			return;
> +		}

	With this code we now fallthrough if we don't have any good bytes
	and the command has expired.  Is this the expected behaviour? If
	yes we need a good comment describing it.

