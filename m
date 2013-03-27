From: Hannes Reinecke <hare@suse.de>
Subject: Re: error handler scheduling
Date: Wed, 27 Mar 2013 15:35:26 +0100
Message-ID: <515303AE.3060605@suse.de>
References: <51525560.3000008@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3C0Of1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Mar 2013 10:35:27 -0400
In-Reply-To: <51525560.3000008@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/27/2013 03:11 AM, James Smart wrote:
> In looking through the error handler, if a command times out and is
> added to the eh_cmd_q for the shost, the error handler is only
> awakened once shost->host_busy (total number of i/os posted to the
> shost) is equal to shost->host_failed (number of i/o that have been
> failed and put on the eh_cmd_q).  Which means, any other i/o that
> was outstanding must either complete or have their timeout fire.
> Additionally, as all further i/o is held off at the block layer as
> the shost is in recovery, new i/o cannot be submitted until the
> error handler runs and resolves the errored i/os.
>
> Is this true ?
>
Yes.

> I take it is also true that the midlayer thus expects every i/o to
> have an i/o timeout.  True ?
>
Yes. But this is guaranteed by the block-layer:

void blk_add_timer(struct request *req)
{
	struct request_queue *q =3D req->q;
	unsigned long expiry;

	if (!q->rq_timed_out_fn)
		return;

	BUG_ON(!list_empty(&req->timeout_list));
	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));

	/*
	 * Some LLDs, like scsi, peek at the timeout to prevent a
	 * command from being retried forever.
	 */
	if (!req->timeout)
		req->timeout =3D q->rq_timeout;


So every request will have a timeout, either the default=20
request_queue timeout or an individual one.

> The crux of this point is that when the recovery thread runs to
> aborts the timed out i/os, is at the mercy of the last command to
> complete or timeout. Additionally, as all further i/o is held off at
> the block layer as the shost is in recovery, new i/o cannot be
> submitted until the error handler runs and resolves the errored
> i/os. So all I/O on the host is stopped until that last i/o
> completes/times out.   The timeouts may be eons later.  Consider
> SCSI format commands or verify commands that can take hours to
> complete.
>
Yes, that's true. Unfortunately.

> Specifically, I'm in a situation currently, where an application is
> using sg to send a command to a target. The app selected no-timeout
> - by setting timeout to MAX_INT. Effectively it's so large its
> infinite. This I/O was one of those "lost" on the storage fabric.
> There was another command that long ago timed out and is sitting on
> the error handlers queue. But nothing is happening - new i/o, or
> error handler to resolve the failed i/o, until that inifinite i/o
> completes.
>
Hehe. no timeout !=3D MAX_INT.

It's easy to apply a timeout if none is set. But how do we determine=20
what constitutes a valid timeout?

As mentioned, some command can literally take forever, _and_ being=20
fully legit. So who are we to decide?

> I'm hoping I hear that I just misunderstand things.  If not,  is
> there a suggestion for how to resolve this predicament ?    IMHO,
> I'm surprised we stop all i/o for error handling, and that it can be
> so long later... I would assume there's a minimum bound we would
> wait in the error handler (30s?) before we unconditionally run it
> and abort anything that was outstanding.
>
Ah, the joys of error recovery.

Incidentally, that'll be one of the topics I'll be discussing at=20
LSF; I've been bitten by this on various other occasions.

AFAIK the reasoning behind the current error recovery strategy is=20
that it's modelled after SCSI parallel behaviour, where you=20
basically have to stop the entire bus, figure out which state it's=20
in, and then take corrective action.
And you typically don't have any LUNs to deal with.
_And_ SPI is essentially single-threaded when it comes to target=20
access, so in effect you cannot send commands over the bus when=20
resetting a target.
So there it makes sense.

Less so for modern fabrics, where target access is governed by an=20
I_T nexus, any of which is largely independent on others.

Actually there is another issue with the error handler:
The commands will only be release after eh is done.

If you look at the eh sequence
-> eh_abort
   -> eh_lun_reset
     -> eh_target_reset
       -> eh_bus_reset
         -> eh_host_reset
the command itself is only meaningful until lun_reset() has=20
completed; after lun_reset() the command is invalided.
Every other stage still uses the scsi command as an argument,
but only as a place holder to figure out which device it should act=20
upon.

So we _could_ speed up things by quite a lot when we were able to=20
call ->done() on the command after lun reset; then the command would=20
be returned to the upper layers.
And things like multipath could kick in an move I/O to other
devices.

However, this is a daunting task.
I've tried, and it's far from easy.
_Especially_ do to some FC HBAs insisting on using scmds for sending=20
TARGET RESET TMFs.
If we just could do a LOGO for target reset things would become so=20
much easier ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
