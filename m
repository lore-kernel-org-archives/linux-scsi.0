From: Hannes Reinecke <hare@suse.de>
Subject: Re: Debugging scsi abort handling ?
Date: Fri, 29 Aug 2014 08:08:32 +0200
Message-ID: <540018E0.9050907@suse.de>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com> <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org> <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de> <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com> <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com> <53FF39F7.3070004@suse.de> <53FF430F.5060103@redhat.com> <53FF4709.9040801@suse.de> <alpine.LNX.2.00.1408291419070.29948@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38236 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaH2GIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2014 02:08:35 -0400
In-Reply-To: <alpine.LNX.2.00.1408291419070.29948@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>, Robert Elliot <elliot@hp.com>

On 08/29/2014 06:39 AM, Finn Thain wrote:
>
> On Thu, 28 Aug 2014, Hannes Reinecke wrote:
>
>> What might happen, though, that the command is already dead and gone=
 by
>> the time you're calling ->scsi_done() (if you call it after eh_abort=
).
>> So there might not _be_ a command upon which you can call ->scsi_don=
e()
>> to start with.
>>
>> Hence any LLDD need to clear up any internal references after a call=
 to
>> eh_XXX to ensure it doesn't call ->scsi_done() an in invalid command=
=2E
>>
>> So even if the LLDD returns 'FAILED' upon a call to eh_XXX it _still=
_
>> needs to clear up the internal reference.
>
> This is a question that has been bothering me too. If the host's
> eh_abort_cmd() method returns FAILED, it seems the mid-layer is liabl=
e to
> re-issue the same command to the LLD (?)
>
No.
=46AILED for any eh_abort_cmd() means that the TMF hasn't been sent.
So the midlayer escalates to the next EH step.
The command will only ever be re-issued once EH completes.

>> Either that or return 'FAILED' for any later eh_XXX function until t=
he
>> internal references can be cleared up.
>
> So if a command may or may not "exist" after eh_abort_handler() retur=
ns
> control to the mid-layer (regardless of SUCCESS or FAILURE), then the=
 LLD
> has to be careful about keeping track of which commands were aborted,=
 if
> those commands are still in the process of cleanup when eh_abort_hand=
ler()
> returns.
>
Yes.

> It's hard to see how that can work when command pointers are only uni=
que
> while a command "exists".
>
Which is why we have the EH callbacks, to give the LLDD a chance to=20
clean up internal references.

> In effect, this would mean that EH functions cannot return at all, un=
til
> the relevant command(s) are completely forgotten by the LLD; and that
> means the LLD itself may have to escalate abort -> device reset -> bu=
s
> reset -> etc instead of simply returning FAILED.
>
More often than not the LLDD has its own internal command structure,=20
which reference the midlayer SCSI command structure via a pointer.
Just clearing that pointer will do the trick.

Take eg. lpfc:
It'll construct its internal command here:

	lpfc_cmd =3D lpfc_get_scsi_buf(phba, ndlp);
	if (lpfc_cmd =3D=3D NULL) {
		lpfc_rampdown_queue_depth(phba);

		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
				 "0707 driver's buffer pool is empty, "
				 "IO busied\n");
		goto out_host_busy;
	}

	/*
	 * Store the midlayer's command structure for the
	 * completion phase
	 * and complete the command initialization.
	 */
	lpfc_cmd->pCmd  =3D cmnd;
	lpfc_cmd->rdata =3D rdata;
	lpfc_cmd->timeout =3D 0;
	lpfc_cmd->start_time =3D jiffies;
	cmnd->host_scribble =3D (unsigned char *)lpfc_cmd;

and then checks for the pointer upon command completion:

static void
lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq=20
*pIocbIn,
			struct lpfc_iocbq *pIocbOut)
{
	struct lpfc_scsi_buf *lpfc_cmd =3D
		(struct lpfc_scsi_buf *) pIocbIn->context1;

[ .. ]
	/* Sanity check on return of outstanding command */
	if (!(lpfc_cmd->pCmd))
		return;

But indeed, 'FAILED' is not very meaningful here, leaving the=20
midlayer with no information about what happened to the command.

Personally I would like to enforce this meaning on the eh_XXX callbacks=
:
- upon each eh_XXX callback the LLDD clears any internal references
   to the command / command scope (ie eh_abort_cmd clears the
   references to the command, eh_lun_reset clears all internal
   references to commands to this ITL nexus etc.)
   This happens irrespective of the return code.
- The eh_XXX callback shall return 'FAILED' if the respective
   TMF (or equivalent) could not be initiated.
- The eh_XXX callback shall return 'SUCCESS' if the respective
   TMF (or equvalent) could be initiated.
- After each eh_XXX callback control for this command / command
   scope is transferred back to the midlayer; the LLDD shall not
   assume the associated command structures to remain valid after
   that point.

I'm tempted to enshrine this in the documentation;
that surely will help me during the EH cleanup.
And Hans will have some guidelines on how to design uas EH :-)

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
