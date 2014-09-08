From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Mon, 08 Sep 2014 16:31:01 -0400
Message-ID: <540E1205.9060201@interlog.com>
References: <5403AB47.3040706@interlog.com> <20140905052402.GA27094@infradead.org> <5409C116.5060702@interlog.com> <5409D5D0.8060801@acm.org> <540B1CC6.8010800@interlog.com> <540D72BB.2020100@acm.org> <20140908150703.GA30298@infradead.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:52867 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160AbaIHUbN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 16:31:13 -0400
In-Reply-To: <20140908150703.GA30298@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>

On 14-09-08 11:07 AM, Christoph Hellwig wrote:
> On Mon, Sep 08, 2014 at 11:11:23AM +0200, Bart Van Assche wrote:
>> Hello Doug,
>>
>> In the scsi_debug driver scsi_remove_host() is called from inside the
>> sdebug_driver_remove() callback function. Unless I have missed something it
>> is not guaranteed that that callback function is invoked before unloading of
>> the scsi_debug driver has finished. I think most of the code in
>> sdebug_driver_remove() should be moved to sdebug_remove_adapter().
>
> I'm not sure that's right.  scsi_debug uses the driver mode in a
> slightly unusual way, and includes both the bus driver, device and
> device driver.
>
> sdebug_driver_remove is a bus method, but as we don't have driver methods
> should act very much like all other _remove callbacks.
>
> sdebug_remove_adapter is more a "bus-level" function that calls into
> the driver model to unbind devices from the driver.
>
> But we defintively shouldn't stop and free queued command before we
> fully remove the hosts.  As far as I can tell the stop_all_queued
> call can be entirely removed from the remove path, as the midlayer
> will take care of waiting for all commands to return, and the
> free_all_queued should be after all hosts are unregistered.

stop_all_queued() is doing hrtimer_cancel(), del_timer_sync()
or tasklet_kill() on all the scsi_cmnd objects that are
"in play". Unless another mechanism calls the .eh_abort_handler
entry point reliably on each "in play" command then the module
cannot be removed. That is because some timer expiry callbacks
are pending.

> Something like the (untested) patch below would do the trick.
> We'd still need Dougs patch for the EH case, though.
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d19c0e3..d022c2f 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3983,14 +3983,13 @@ static void __exit scsi_debug_exit(void)
>   {
>   	int k = scsi_debug_add_host;
>
> -	stop_all_queued();
> -	free_all_queued();
>   	for (; k; k--)
>   		sdebug_remove_adapter();
>   	driver_unregister(&sdebug_driverfs_driver);
>   	bus_unregister(&pseudo_lld_bus);
>   	root_device_unregister(pseudo_primary);
>
> +	free_all_queued();
>   	if (dif_storep)
>   		vfree(dif_storep);
>
> --

The only other call to stop_all_queued() is from the
.eh_host_reset_handler entry point.

Doug Gilbert


