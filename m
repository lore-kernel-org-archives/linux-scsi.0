From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: Scsi Error handling query
Date: Tue, 31 Mar 2015 19:03:21 +0530
Message-ID: <cafaad3bf9eb170d6a12182e4727a318@mail.gmail.com>
References: <5d00e10b067fd4d0fb82ecdec18dd325@mail.gmail.com>
 <55142C6D.1060205@suse.de> <bc74695bc632f3cda3ccec360eb6e0ae@mail.gmail.com>
 <55157F08.3070707@suse.de> <d88ae93f14d83d38941f67a956f1567c@mail.gmail.com> <551967F9.9020500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:35474 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbbCaNef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2015 09:34:35 -0400
Received: by lahf3 with SMTP id f3so12278307lah.2
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2015 06:34:34 -0700 (PDT)
In-Reply-To: <551967F9.9020500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, March 30, 2015 8:43 PM
> To: Kashyap Desai; linux-scsi@vger.kernel.org
> Subject: Re: Scsi Error handling query
>
> On 03/30/2015 01:45 PM, Kashyap Desai wrote:
> >> -----Original Message-----
> >> From: Hannes Reinecke [mailto:hare@suse.de]
> >> Sent: Friday, March 27, 2015 9:32 PM
> >> To: Kashyap Desai; linux-scsi@vger.kernel.org
> >> Subject: Re: Scsi Error handling query
> >>
> >> On 03/26/2015 07:43 PM, Kashyap Desai wrote:
> >>>> -----Original Message-----
> >>>> From: Hannes Reinecke [mailto:hare@suse.de]
> >>>> Sent: Thursday, March 26, 2015 9:28 PM
> >>>> To: Kashyap Desai; linux-scsi@vger.kernel.org
> >>>> Subject: Re: Scsi Error handling query
> >>>>
> >>>> On 03/26/2015 02:38 PM, Kashyap Desai wrote:
> >>>>> Hi Hannes,
> >>>>>
> >>>>> I was going through one of the slide posted at below link.
> >>>>>
> >>>>> http://events.linuxfoundation.org/sites/events/files/slides/SCS=
I-EH.
> >>>>> pd
> >>>>> f
> >>>>>
> >>>>> Slide #59 has below data. I was trying to correlate with latest
> >>>>> upstream code, but do not understand few things. Does Linux han=
dle
> >>>>> blocking I/O to the device and target before it actually start
> >>>>> legacy EH
> >>>> recovery ?
> >>>>
> >>>> Yes. This is handled by 'scsi_eh_scmd_add()', which adds the
> >>>> command to the internal 'eh_entry' list and starts recovery once
> >>>> all remaining outstanding commands are completed.
> >>>
> >>> Thanks Hannes..! Scsi_eh_scmd_add() move shost state to recovery,=
 so
> >>> it means  blocking further IO to the Host and not really a limite=
d
> >>> to Device/Target for which command was timed out. Right ?
> >>> I understood that, new improvement of scsi error handling will al=
low
> >>> IOs to the other Devices attached to the host except the IO belon=
gs
> >>> to specific target.
> >>>
> >>> Also, one more thing to clarify... In presentation, term "task se=
t
> >>> aborts"
> >>> was used. Does this mean task set abort is handled as traversing
> >>> complete list of timed out command and sending individual TASK AB=
ORT ?
> >>>
> >> No. The idea was to send 'task set aborts' as a single TMF.
> >
> > Thanks Hannes.!  OK so idea was to have single TMF for "Task set ab=
ort."
> > I
> > am not sure how to frame my  next question.. But what if Linux SCSI
> > layer traverse each IO of one particular target and issue individua=
l
> > Task abort?
> > Don=E2=80=99t we call that as "task set aborts" ?  How LLD Driver s=
hould
> > interface for "task set aborts" as single TMF ? My understanding is
> > "Task set
> abort"
> > will be internally converted to single Task abort either by SCSI la=
yer
> > or HBA FW.
> >
> Why? There _is_ a 'task set abort' TMF defined in SAM.
> If the firmware doesn't implement it I'd thought the respective comma=
nd to
> be
> failed?
Understood this part.  It is single TMF of "task set abort" is what
addressed here.

Is there any harm to do in Low level driver as below for Lun/Target res=
et ?

Once LLD enter into eh_abort_handler callback, try to do "Task Set Abor=
t"
from LLD as single TMF (most likely convert single "task set abort" in =
=46W
specific format)
Wait for completion and see if things are really resolve. If not, issue
Target Reset (from the FW) which will be SAS Link Hard Reset.

This way driver can  abort command related to associated I_T nexus.
I initially thought Linux scsi error handling actually does this becaus=
e it
completely traverse all timed out command from error handling thread (w=
hich
will be almost equivalent to single TMF "Task set abort")

>
> However, at this point I'm not sure if 'task set abort' is actually
> required; it
> _should_ be superseded by the new 'transport reset' EH handler.
> On the FC side this will translate into a relogin, which will
> automatically abort all
> outstanding tasks.
> SAS even has a dedicated TMF IT NEXUS LOSS, which looks like it could=
 be
> used
> here.

Not sure if my above comment/query is on same line.

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
