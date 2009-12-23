From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: does scsi_io_completion need to dump sense data for ata pass
 through (ck_cond = 1) ?
Date: Wed, 23 Dec 2009 00:45:51 -0500
Message-ID: <4B31AE8F.6070409@interlog.com>
References: <200912221917.36495.kb@sysmikro.com.pl> <4B312181.30000@interlog.com> <200912230011.44703.kb@sysmikro.com.pl>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48841 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZLWFp7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2009 00:45:59 -0500
In-Reply-To: <200912230011.44703.kb@sysmikro.com.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?S3J6eXN6dG9mIELFgmFzemtvd3NraQ==?= <kb@sysmikro.com.pl>
Cc: eric@andante.org, linux-scsi@vger.kernel.org, Krzysztof.b@id-7.com

Krzysztof B=C5=82aszkowski wrote:
> On Tuesday 22 December 2009 20:44, Douglas Gilbert wrote:
>> Krzysztof B=C5=82aszkowski wrote:
>>> Hello Eric,
>>>
>>> I think it is not necessary and current behavior of kernel like 2.6=
=2E31
>>> confuses QA people.
>>> They need explanation that message like below:
>>>
>>> sd 5:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor=
]
>>> Descriptor sense data with sense descriptors (in hex):
>>>         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
>>>         00 00 00 00 00 50
>>> sd 5:0:1:0: [sdb] Add. Sense: ATA pass through information availabl=
e
>>>
>>> stands for that sense data contains ata registers file and the comm=
and
>>> was executed properly.
>>>
>>> Here is additional condition i used in scsi_io_completion() which
>>> suppresses this message. Is it okay ?
>> Close but I would like to see a filter on the additional
>> sense code ATA PASS-THROUGH INFORMATION AVAILABLE [0x0, 0x1d].
>> There is nothing in SAT that precludes the return of a RECOVERED
>> ERROR sense code for a read on a SATA disk that was recovered
>> after some extra work (for example).
>=20
> of course but is it good idea to log sense data if:
> - it is created on demand by application. (sat-2 ch 12.2.2 and .3)
> - it doesn't contain some failure status
>=20
> ?
>=20
>> With that filter in place there is no need to filter on the command.
>=20
> right but OTOH if filter used asc/ascq then it would filter out all c=
ommands=20
> even these with some failures.=20
>=20
> i am not sure if this is really what you want to have, ie block all d=
umps of=20
> ATA PASS-THROUGH sense data.
>=20
>> IOWs just filter on sense code RECOVERED ERROR and additional
>> sense code ATA PASS-THROUGH INFORMATION AVAILABLE. SAT and SAT-2
>> compliant implementations should then dump less to the log.
>=20
> i would say that asc/ascq filter will stop logging all SAT/SAT-2 chec=
k=20
> conditions instead of "less".
>=20
> that improvement i sent has better "granularity".

I disagree.

This is the code sequence I had in mind:

         if (sense_valid && (sshdr.sense_key =3D=3D RECOVERED_ERROR)) {
                 /* if ATA PASS-THROUGH INFORMATION AVAILABLE skip
                  * print since app wants ATA registers */
                 if ((sshdr.asc =3D=3D 0x0) && (sshdr.ascq =3D=3D 0x1d)=
)
                         ;
                 else if (!(req->cmd_flags & REQ_QUIET))
                         scsi_print_sense("", cmd);
                 result =3D 0;
                 /* BLOCK_PC may have set error */
                 error =3D 0;
         }

This will suppress logging the sense data associated with the
ATA PASS-THROUGH INFORMATION AVAILABLE additional sense code.
That is only generated in the situation when a SCSI ATA PASS-THROUGH
command sets the CK_COND bit _and_ there was no other error from
the ATA disk or the transport (e.g. SAS can issue an ABORTED COMMAND
sense key). This is shown in sat2r09.pdf section 12.2.5 table 113.

Doug Gilbert

P.S. Haven't seen Eric Youngdale's email address for a while
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
