From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Tue, 30 Jan 2007 19:16:39 -0600
Message-ID: <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
References: <200701301947.08478.liml@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932095AbXAaBQo@vger.kernel.org>
In-Reply-To: <200701301947.08478.liml@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

First off, please send SCSI patches to the SCSI list:
<linux-scsi@vger.kernel.org>

On Tue, 2007-01-30 at 19:47 -0500, Mark Lord wrote:
> In ancient kernels, the SCSI disk code used to continue after
> encountering a MEDIUM_ERROR.  It would "complete" the good
> sectors before the error, fail the bad sector/block, and then
> continue with the rest of the request.
> 
> Kernels since about 2.6.16 or so have been broken in this regard.
> They "complete" the good sectors before the error,
> and then fail the entire remaining portions of the request.

What was the commit that introduced the change? ... I have a vague
memory of it being deliberate.

> This is very risky behaviour, as a request is often a merge
> of several bios, and just because one application hits a bad sector
> is no reason to pretend that (for example) an adjacent directly lookup also failed.
> 
> This patch fixes the behaviour to be similar to what we had originally.
> 
> When a bad sector is encounted, SCSI will now work around it again,
> failing *only* the bad sector itself.

Erm, but the corollary is that if we get a large read failure because of
a bad track, you're going to try and chunk up it a sector at a time
forcing an individual error for each sector is going to annoy some
people ... particularly removable medium ones which return this error if
the medium isn't present ... Are you sure this is really what we want to
do?

> Signed-off-by:  Mark Lord <mlord@pobox.com>
> ---
> diff -u --recursive --new-file --exclude-from=linux_17//Documentation/dontdiff old/drivers/scsi/scsi_lib.c linux/drivers/scsi/scsi_lib.c
> --- old/drivers/scsi/scsi_lib.c	2007-01-30 13:58:05.000000000 -0500
> +++ linux/drivers/scsi/scsi_lib.c	2007-01-30 18:30:01.000000000 -0500
> @@ -865,6 +865,12 @@
>  	 */
>  	if (sense_valid && !sense_deferred) {
>  		switch (sshdr.sense_key) {
> +		case MEDIUM_ERROR:
> +			// Bad sector.  Fail it, and then continue the rest of the request:
> +			if (scsi_end_request(cmd, 0, cmd->device->sector_size, 1) == NULL) {

The sense key may have come with additional information  I think we want
to parse that (if it exists) rather than just blindly failing the first
sector of the request.

> +				cmd->retries = 0;	// go around again..
> +				return;
> +			}

This would drop through to the UNIT_ATTENTION case if scsi_end_request()
fails ... I don't think that's correct.

>  		case UNIT_ATTENTION:
>  			if (cmd->device->removable) {
>  				/* Detected disc change.  Set a bit
