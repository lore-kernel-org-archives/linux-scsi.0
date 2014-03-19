From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Deadlock in usb-storage error handling
Date: Wed, 19 Mar 2014 13:54:18 -0700
Message-ID: <CAA9_cmfe5XLZ5yPjmhe+dw7YUQA4URCEpUHbpmf++4TpTjnaWA@mail.gmail.com>
References: <53298181.9020206@gmail.com>
	<Pine.LNX.4.44L0.1403191449290.887-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1403191449290.887-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Andreas Reis <andreas.reis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 19, 2014 at 1:31 PM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> wrote:
> On Wed, 19 Mar 2014, Andreas Reis wrote:
>
>> I've uploaded a dmesg with the new debugging patch to bugzilla:
>> https://bugzilla.kernel.org/attachment.cgi?id=130041
>
> Thanks.  I have now managed to reproduce many of the features of this
> problem on my own computer.
>
> James, I will need your help (or help from somebody who understands the
> SCSI error handler) to figure out how this problem should be fixed.
>
> Basically, usb-storage deadlocks when the SCSI error handler invokes
> the eh_device_reset_handler callback while a command is running.  The
> command has timed out and will never complete normally, because the
> device's firmware has crashed.  But usb-storage's device-reset routine
> waits for the current command to finish, which brings everything to a
> standstill.
>
> Is this design wrong?  That is, should the device-reset routine wait
> for currently executing commands to finish, or should it abort them, or
> what?
>
> Or should the SCSI error handler abort the running command before
> invoking the eh_device_reset_handler callback?
>
> For the record, and in case anyone is curious, here's the detailed
> sequence of events during my test:
>
>         sd issues a READ(10) command.  For whatever reason, the device
>         goes nuts and the command times out.
>
>         scsi_times_out() calls scsi_abort_command(), which queues an
>         abort request.
>
>         scmd_eh_abort_handler() calls scsi_try_to_abort_cmd(), which
>         succeeds in aborting the READ.
>
>         The READ command is retried (I didn't trace through the details
>         of this).  The retry fails with a Unit Attention (SK=6,
>         ASC=0x29, Reset or Bus Device Reset Occurred).
>
>         The READ command is retried a second time, and it times out
>         again.
>
>         This time around, scsi_times_out() calls scsi_abort_command()
>         unsuccessfully (because the SCSI_EH_ABORT_SCHEDULED flag is
>         still set).
>
>         As a result, scsi_error_handler() calls scsi_unjam_host(),
>         which calls scsi_eh_get_sense().
>
>         That routine calls scsi_request_sense(), which goes into
>         scsi_send_eh_cmnd().
>
>         The calls to shost->hostt->queuecommand() all fail, because the
>         READ command is still running and usb-storage has a queue
>         depth of 1.  The error messages produced by these failures are
>         disconcerting but not dangerous.
>
>         Since the REQUEST SENSE command was never issued,
>         scsi_eh_get_sense() returns 0.
>
>         scsi_unjam_host() goes on to call scsi_eh_abort_cmds(), which
>         does essentially nothing because the SCSI_EH_CANCEL_CMD flag
>         for the only command on work_q is clear.
>         scsi_eh_test_devices() returns 0 because check_list is empty
>         and work_q isn't.
>
>         scsi_unjam_host() then calls scsi_eh_ready_devs().  This
>         routine ends up calling scsi_eh_bus_device_reset(), at which
>         point usb-storage deadlocks as described above.
>
> (On Andreas's system, the first READ retry times out as opposed to the
> second retry as on my computer.  I doubt this makes any difference.)
>
> I can't tell if this is all working as intended or if it went off the
> tracks somewhere.
>
> Thanks for any guidance.
>

It seems to me we need an ->eh_strategy_handler() that understands the
usb transport and will escalate to device reset around the time
scsi_abort_command() fails.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
