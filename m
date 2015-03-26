From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: Scsi Error handling query
Date: Fri, 27 Mar 2015 00:13:02 +0530
Message-ID: <bc74695bc632f3cda3ccec360eb6e0ae@mail.gmail.com>
References: <5d00e10b067fd4d0fb82ecdec18dd325@mail.gmail.com> <55142C6D.1060205@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35353 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbCZSnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2015 14:43:05 -0400
Received: by lbcgn8 with SMTP id gn8so47605908lbc.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2015 11:43:03 -0700 (PDT)
In-Reply-To: <55142C6D.1060205@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, March 26, 2015 9:28 PM
> To: Kashyap Desai; linux-scsi@vger.kernel.org
> Subject: Re: Scsi Error handling query
>
> On 03/26/2015 02:38 PM, Kashyap Desai wrote:
> > Hi Hannes,
> >
> > I was going through one of the slide posted at below link.
> >
> > http://events.linuxfoundation.org/sites/events/files/slides/SCSI-EH=
=2Epd
> > f
> >
> > Slide #59 has below data. I was trying to correlate with latest
> > upstream code, but do not understand few things. Does Linux handle
> > blocking I/O to the device and target before it actually start lega=
cy EH
> recovery ?
>
> Yes. This is handled by 'scsi_eh_scmd_add()', which adds the command =
to
> the
> internal 'eh_entry' list and starts recovery once all remaining
> outstanding
> commands are completed.

Thanks Hannes..! Scsi_eh_scmd_add() move shost state to recovery, so it
means  blocking further IO to the Host and not really a limited to
Device/Target for which command was timed out. Right ?
I understood that, new improvement of scsi error handling will allow IO=
s to
the other Devices attached to the host except the IO belongs to specifi=
c
target.

Also, one more thing to clarify... In presentation, term "task set abor=
ts"
was used. Does this mean task set abort is handled as traversing comple=
te
list of timed out command and sending individual TASK ABORT ?

>
> > Also, how does linux scsi stack achieve task set abort ?
> >
> Currently we don't :-)
> The presentation was a roadmap about future EH updates.
>
> > Proposed SCSI EH strategy
> > =E2=80=A2 Send command aborts after timeout
> > =E2=80=A2 EH Recovery starts:
> > =E2=80=92 Block I/O to the device
> >        =E2=80=92 Issue 'Task Set Abort'
> > =E2=80=92 Block I/O to the target
> >        =E2=80=92 Issue I_T Nexus Reset
> >        =E2=80=92 Complete outstanding command on success =E2=80=92 =
Engage current EH
> > strategy
> >        =E2=80=92 LUN Reset, Target Reset etc
> >
> The current plans for EH updates are:
>
> - Convert eh_host_reset_handler() to take Scsi_Host as argument
>   - Convert EH host reset to do a host rescan after try_host_reset()
>     succeeded
>   - Terminate failed scmds prior to calling try_host_reset()
>   =3D> with that we should be able to instantiate a quick failover
>      when running under multipathing, as then I/Os will be returned
>      prior to the host reset (which is know to take quite a long
>      time)
>
> - Convert the remaining eh_XXX_reset_handler() to take the
>   appropriate structure as argument.
>   This will require some work, as some EH handler implementation
>   re-use the command tag (or even the actual command) for sending
>   TMFs.
>
> - Implementing a 'transport reset' EH function; to be called
>   after the current EH LUN Reset
>
> - Investigating the possibilty for an asynchronous 'task set abort',
>   and make the 'transport reset' EH function asynchronous, too.
>
> I've got a patchset for the first step, but the others still require =
some
> work ...
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton=
 HRB 21284
> (AG
> N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
