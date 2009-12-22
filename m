From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: does scsi_io_completion need to dump sense data for ata pass through (ck_cond = 1) ?
Date: Wed, 23 Dec 2009 00:11:44 +0100
Message-ID: <200912230011.44703.kb@sysmikro.com.pl>
References: <200912221917.36495.kb@sysmikro.com.pl> <4B312181.30000@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v007470.home.net.pl ([212.85.125.104]:63445 "HELO
	v007470.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752752AbZLVXMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2009 18:12:01 -0500
In-Reply-To: <4B312181.30000@interlog.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: eric@andante.org, linux-scsi@vger.kernel.org, Krzysztof.b@id-7.com

On Tuesday 22 December 2009 20:44, Douglas Gilbert wrote:
> Krzysztof B=C5=82aszkowski wrote:
> > Hello Eric,
> >
> > I think it is not necessary and current behavior of kernel like 2.6=
=2E31
> > confuses QA people.
> > They need explanation that message like below:
> >
> > sd 5:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor=
]
> > Descriptor sense data with sense descriptors (in hex):
> >         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> >         00 00 00 00 00 50
> > sd 5:0:1:0: [sdb] Add. Sense: ATA pass through information availabl=
e
> >
> > stands for that sense data contains ata registers file and the comm=
and
> > was executed properly.
> >
> > Here is additional condition i used in scsi_io_completion() which
> > suppresses this message. Is it okay ?
>
> Close but I would like to see a filter on the additional
> sense code ATA PASS-THROUGH INFORMATION AVAILABLE [0x0, 0x1d].
> There is nothing in SAT that precludes the return of a RECOVERED
> ERROR sense code for a read on a SATA disk that was recovered
> after some extra work (for example).

of course but is it good idea to log sense data if:
- it is created on demand by application. (sat-2 ch 12.2.2 and .3)
- it doesn't contain some failure status

?

> With that filter in place there is no need to filter on the command.

right but OTOH if filter used asc/ascq then it would filter out all com=
mands=20
even these with some failures.=20

i am not sure if this is really what you want to have, ie block all dum=
ps of=20
ATA PASS-THROUGH sense data.

>
> IOWs just filter on sense code RECOVERED ERROR and additional
> sense code ATA PASS-THROUGH INFORMATION AVAILABLE. SAT and SAT-2
> compliant implementations should then dump less to the log.

i would say that asc/ascq filter will stop logging all SAT/SAT-2 check=20
conditions instead of "less".

that improvement i sent has better "granularity".

>
> Doug Gilbert

Krzysztof Blaszkowski
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
