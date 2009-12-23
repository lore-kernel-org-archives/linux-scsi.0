From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: does scsi_io_completion need to dump sense data for ata pass through (ck_cond = 1) ?
Date: Wed, 23 Dec 2009 12:16:58 +0100
Message-ID: <200912231216.59143.kb@sysmikro.com.pl>
References: <200912221917.36495.kb@sysmikro.com.pl> <200912230011.44703.kb@sysmikro.com.pl> <4B31AE8F.6070409@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v007470.home.net.pl ([212.85.125.104]:61199 "HELO
	v007470.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751139AbZLWLRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2009 06:17:15 -0500
In-Reply-To: <4B31AE8F.6070409@interlog.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: eric@andante.org, linux-scsi@vger.kernel.org, Krzysztof.b@id-7.com

On Wednesday 23 December 2009 06:45, Douglas Gilbert wrote:
> Krzysztof B=C5=82aszkowski wrote:
> > On Tuesday 22 December 2009 20:44, Douglas Gilbert wrote:
> >> Krzysztof B=C5=82aszkowski wrote:
> >>> Hello Eric,
> >>>
> >>> I think it is not necessary and current behavior of kernel like 2=
=2E6.31
> >>> confuses QA people.
> >>> They need explanation that message like below:
> >>>
> >>> sd 5:0:1:0: [sdb] Sense Key : Recovered Error [current] [descript=
or]
> >>> Descriptor sense data with sense descriptors (in hex):
> >>>         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> >>>         00 00 00 00 00 50
> >>> sd 5:0:1:0: [sdb] Add. Sense: ATA pass through information availa=
ble
> >>>
> >>> stands for that sense data contains ata registers file and the co=
mmand
> >>> was executed properly.
> >>>
> >>> Here is additional condition i used in scsi_io_completion() which
> >>> suppresses this message. Is it okay ?
> >>
> >> Close but I would like to see a filter on the additional
> >> sense code ATA PASS-THROUGH INFORMATION AVAILABLE [0x0, 0x1d].
> >> There is nothing in SAT that precludes the return of a RECOVERED
> >> ERROR sense code for a read on a SATA disk that was recovered
> >> after some extra work (for example).
> >
> > of course but is it good idea to log sense data if:
> > - it is created on demand by application. (sat-2 ch 12.2.2 and .3)
> > - it doesn't contain some failure status
> >
> > ?
> >
> >> With that filter in place there is no need to filter on the comman=
d.
> >
> > right but OTOH if filter used asc/ascq then it would filter out all
> > commands even these with some failures.
> >
> > i am not sure if this is really what you want to have, ie block all=
 dumps
> > of ATA PASS-THROUGH sense data.
> >
> >> IOWs just filter on sense code RECOVERED ERROR and additional
> >> sense code ATA PASS-THROUGH INFORMATION AVAILABLE. SAT and SAT-2
> >> compliant implementations should then dump less to the log.
> >
> > i would say that asc/ascq filter will stop logging all SAT/SAT-2 ch=
eck
> > conditions instead of "less".
> >
> > that improvement i sent has better "granularity".
>
> I disagree.
>
> This is the code sequence I had in mind:
>
>          if (sense_valid && (sshdr.sense_key =3D=3D RECOVERED_ERROR))=
 {
>                  /* if ATA PASS-THROUGH INFORMATION AVAILABLE skip
>                   * print since app wants ATA registers */
>                  if ((sshdr.asc =3D=3D 0x0) && (sshdr.ascq =3D=3D 0x1=
d))
>                          ;
>                  else if (!(req->cmd_flags & REQ_QUIET))
>                          scsi_print_sense("", cmd);
>                  result =3D 0;
>                  /* BLOCK_PC may have set error */
>                  error =3D 0;
>          }
>
> This will suppress logging the sense data associated with the
> ATA PASS-THROUGH INFORMATION AVAILABLE additional sense code.
> That is only generated in the situation when a SCSI ATA PASS-THROUGH
> command sets the CK_COND bit _and_ there was no other error from
> the ATA disk or the transport (e.g. SAS can issue an ABORTED COMMAND
> sense key). This is shown in sat2r09.pdf section 12.2.5 table 113.

I think you are right that checking CK_COND bit here is not necessary b=
ecause=20
if command was failed due to drive error then sense key wouldn't be=20
RECOVERED_ERROR according to section 11 (sat2).

Krzysztof Blaszkowski
>
> Doug Gilbert
>
> P.S. Haven't seen Eric Youngdale's email address for a while


P.S. I took his address from scsi_lib header (2.6.31.5) and i don't thi=
nk i=20
should bother if this address is valid or invalid or if he wishes to re=
ply or=20
he doesn't. This is why i posted my conclusions to linux-scsi too.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
