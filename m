From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: does scsi_io_completion need to dump sense data for ata pass
 through (ck_cond = 1) ?
Date: Tue, 22 Dec 2009 14:44:01 -0500
Message-ID: <4B312181.30000@interlog.com>
References: <200912221917.36495.kb@sysmikro.com.pl>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48008 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZLVTok (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2009 14:44:40 -0500
In-Reply-To: <200912221917.36495.kb@sysmikro.com.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?S3J6eXN6dG9mIELFgmFzemtvd3NraQ==?= <kb@sysmikro.com.pl>
Cc: eric@andante.org, linux-scsi@vger.kernel.org, Krzysztof.b@id-7.com

Krzysztof B=C5=82aszkowski wrote:
> Hello Eric,
>=20
> I think it is not necessary and current behavior of kernel like 2.6.3=
1=20
> confuses QA people.=20
> They need explanation that message like below:
>=20
> sd 5:0:1:0: [sdb] Sense Key : Recovered Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
>         00 00 00 00 00 50
> sd 5:0:1:0: [sdb] Add. Sense: ATA pass through information available
>=20
> stands for that sense data contains ata registers file and the comman=
d was=20
> executed properly.
>=20
> Here is additional condition i used in scsi_io_completion() which sup=
presses=20
> this message. Is it okay ?

Close but I would like to see a filter on the additional
sense code ATA PASS-THROUGH INFORMATION AVAILABLE [0x0, 0x1d].
There is nothing in SAT that precludes the return of a RECOVERED
ERROR sense code for a read on a SATA disk that was recovered
after some extra work (for example).
With that filter in place there is no need to filter on the command.

IOWs just filter on sense code RECOVERED ERROR and additional
sense code ATA PASS-THROUGH INFORMATION AVAILABLE. SAT and SAT-2
compliant implementations should then dump less to the log.

Doug Gilbert
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
