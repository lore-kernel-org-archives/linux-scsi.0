From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.5.65, cciss_scsi, scsi error handling
Date: 18 Mar 2003 17:13:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048025604.1780.76.camel@mulgrave>
References: <20030318100658.GA997@zuul.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030318100658.GA997@zuul.cca.cpqcorp.net>
List-Id: linux-scsi@vger.kernel.org
To: steve.cameron@hp.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-03-18 at 05:06, Stephen Cameron wrote:
> At least the tape drive still works.  The only scsi devices the
> cciss driver will present to linux are tape drives and medium changers.
> (especially not disks.)
> 
> Is it really accurate in this case to say
> 
>   "ERROR: This is not a safe way to run your SCSI host
>    ERROR: The error handling must be added to this driver"
>
> when the only things the error handlers can do 
> is try to abort commands or try to reset devices or buses...

Yes, since if a command times out or fails for some reason, the driver
will return I/O errors immediately (it could also lead to panics if you
retain a reference to the now completed command inside the driver).

A fix like the one you propose:


> +/* Need at least one of these 2 to keep ../scsi/hosts.c from complaining.
> + * It might be possible to implement the device reset and command aborting
> + * ones in a real way, but host/bus reset can't do anything meaningful. */
> +static int cciss_eh_bus_reset_handler(Scsi_Cmnd *notused)
> +{
> +	/* The bus in question is fabricated by this driver.
> +	 * The real busses are behind the array controller, and the
> +	 * firmware is taking care of it, be it SCSI, or something else.  
> +	 * Resetting THAT from here is DEFINITELY not desirable. */
> +	return FAILED;
> +}
> +static int cciss_eh_host_reset_handler(Scsi_Cmnd *notused)
> +{
> +	/* This is an array controller, not just a dumb scsi controller,
> +	 * resetting the HBA would be extremely bad. */
> +	return FAILED;
> +}
> +

Will simply cause the device to be offlined on the first error.

Are the devices the cciss presents really genuine SCSI devices (which
will have timeouts and report errors)?  In which case, you need proper
error handling.

If they're just figments of the cciss controller imagination and
commands will never error or timeout then perhaps you can get away with
just filling in FAILED returns for a single error handler function.

James


