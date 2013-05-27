From: Hannes Reinecke <hare@suse.de>
Subject: Re: SCSI error handling -- one error blocks the whole SCSI host
Date: Mon, 27 May 2013 16:39:21 +0200
Message-ID: <51A37019.3050604@suse.de>
References: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com> <1369608242.1904.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33476 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758Ab3E0OjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 May 2013 10:39:23 -0400
In-Reply-To: <1369608242.1904.7.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Roland Dreier <roland@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/27/2013 12:44 AM, James Bottomley wrote:
>=20
> On Thu, 2013-05-23 at 11:14 -0700, Roland Dreier wrote:
>> At LSF this year, we had a discussion about error handling and in
>> particular the problem that SCSI midlayer error handling waits for t=
he
>> entire SCSI host (HBA) to quiesce before it starts to abort commands
>> etc.
>>
>> James made the suggestion that FC should handle things the way SAS
>> does, because SAS has a strategy handler that does things the right
>> way.  However, now that I finally sit down and look at the code, I
>> don't see how this is the case.  It seems inherent in the way that
>> scsi_eh_scmd_add() and the thread in scsi_error_handler() work (in
>> particular the strategy handler can't even be called until host_fail=
ed
>> =3D=3D host_busy; we don't bump host_failed without SHOST_RECOVERY s=
et,
>> which stops queueing commands to any devices attached to the whole
>> HBA).
>>
>> James, am I understanding your suggestion properly?  If so can you
>> explain what you meant about the libsas code -- I see that it has it=
s
>> own strategy handler but as I said before we've already stopped ever=
y
>> device attached to the HBA before we ever get there.
>=20
> It is, but I checked: Apparently it's not implemented in the sas
> transport class.  The original discussion when libsas was constructed=
,
> as I remember it, was about using the scsi timeout handler to impleme=
nt
> a running abort.  The idea is fairly simple: you use the first fire o=
f
> eh_timed_out to trigger the abort (or LUN reset) while simultaneously
> returning BLK_EH_RESET_TIMER.  If the timer fires again and the abort
> hasn't returned, you escalate, otherwise you resend the command when =
the
> abort returns.  This allows you to handle single command failures (up=
 to
> LUN reset) without stopping the host.  Obviously, if you have to
> escalate to device reset, then you need to start the eh thread.
>=20
There are some problems with that:

- Returning BLK_EH_RESET_TIMER will restart the timer with the
  _default_ blk timeout. Whereas the _abort_ timeout might
  (and, for some LLDDs, it definitely is) different from
  that.
- Leaving the command running while abort is active will
  inevitably risk a double completion on the original command;
  the command abort might terminate the command at the
  same time as the (real) completion comes in.
  'Normal' command timeouts are protected against this via
  REQ_ATOM_COMPLETE; commands aborted via scsi_finish_cmnd()
  are not.
- LLDDs typically won't return a command status even for a
  command which has been aborted via ABORT TASK TMF.
  So the midlayer probably will never get notified if
  the command got aborted via ABORT TASK.

Especially the last point made me abandon this idea for my EH
rewrite. We would be having a real benefit if we somehow could get
the command status _from the target_ for an aborted command.
But as it appears we won't.
So as any status is made up anyway I'd very much prefer to have it
set by the midlayer. Which renders the whole operation quite
pointless and we're better off using the existing syntax for command
aborts.
Plus it makes life _so much_ easier for the implementation ...

But to answer Roland: Have you checked my patchset?
It should help for command timeouts ...

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
