From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 17:08:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924170857.A15340@eng2.beaverton.ibm.com>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com> <20020924123250.A5890@eng2.beaverton.ibm.com> <20020924233941.A9952@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020924233941.A9952@flint.arm.linux.org.uk>; from rmk@arm.linux.org.uk on Tue, Sep 24, 2002 at 11:39:42PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue, Sep 24, 2002 at 11:39:42PM +0100, Russell King wrote:
> Ok, as promised here's the first patch.

Looks nice.  I have the same comment as before about no commands.

>    The new bit is what it does after the command has completed.  If
>    the command was successful, we update the device "locked" flag to
>    indicate the new state.

(The sd.c and sr code are a bit odd since lock failures are ignored;
sr won't unlock later in such cases, but sd unlocks even if the
lock failed on sd_open.)

> +static void scsi_eh_lock_done(struct scsi_cmnd *SCpnt)
> +{
> +	struct scsi_request *SRpnt = SCpnt->sc_request;
> +
> +	SCpnt->sc_request = NULL;
> +	SRpnt->sr_command = NULL;
> +
> +	scsi_release_command(SCpnt);
> +	scsi_release_request(SRpnt);
> +}

This is back to my orginal point (i.e. case 1 in your other response
about "restarting operations after error handling", I haven't figured
out case 2 yet) - the above will not be called if there are no commands.

Can you add some debug printks or what not above and below so we know
for certain the result?

It would be nice if we could call
scsi_set_medium_removal(SCSI_REMOVAL_PREVENT) and use a single code path
for all door lock requests, then we need a special force-to-queue-head
argument passed on down the chain. (We should really have some common
setup-a-scsi-command functions to remove all the duplicate cmd[]
setup code.)

> +STATIC void scsi_eh_lock_door(struct scsi_device *dev)
> +{
> +	struct scsi_request *SRpnt = scsi_allocate_request(dev);
> +
> +	if (SRpnt == NULL) {
> +		/* what now? */
> +		return;
> +	}
> +
> +	SRpnt->sr_cmnd[0] = ALLOW_MEDIUM_REMOVAL;
> +	SRpnt->sr_cmnd[1] = (dev->scsi_level <= SCSI_2) ? (dev->lun << 5) : 0;
> +	SRpnt->sr_cmnd[2] = 0;
> +	SRpnt->sr_cmnd[3] = 0;
> +	SRpnt->sr_cmnd[4] = SCSI_REMOVAL_PREVENT;
> +	SRpnt->sr_cmnd[5] = 0;
> +	SRpnt->sr_data_direction = SCSI_DATA_NONE;
> +	SRpnt->sr_bufflen = 0;
> +	SRpnt->sr_buffer = NULL;
> +	SRpnt->sr_allowed = 5;
> +	SRpnt->sr_done = scsi_eh_lock_done;
> +	SRpnt->sr_timeout_per_command = 10 * HZ;
> +	SRpnt->sr_cmd_len = COMMAND_SIZE(SRpnt->sr_cmnd[0]);
> +
> +	scsi_insert_special_req(SRpnt, 1);
> +}
> +
>  /*
>   * Function:  scsi_restart_operations
>   *
> @@ -1241,6 +1280,18 @@
>  	ASSERT_LOCK(&io_request_lock, 0);
>  
>  	/*
> +	 * If the door was locked, we need to insert a door lock request
> +	 * onto the head of the SCSI request queue for the device.  There
> +	 * is no point trying to lock the door of an off-line device.
> +	 */
> +	for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next) {

> +		if (!SDpnt->online || !SDpnt->locked)
> +			continue;
> +
> +		scsi_eh_lock_door(SDpnt);
> +	}

Why is the above in a separate loop from the loop with the request_fn call?
To avoid holding the lock during the call or what?

Above is where we also need a "SDpnt->has_cmdblock" check, simplify
the above to be:

	for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next)
		if (SDpnt->online && SDpnt->locked && SDpnt->has_cmdblock)
			scsi_eh_lock_door(SDpnt);
			
(And why does the SDpnt->device_blocked cause the later loop to
break rather than continue! I can understand the host->xxx checks
breaking out.)

-- Patrick Mansfield
