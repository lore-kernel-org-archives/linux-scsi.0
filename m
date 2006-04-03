From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Retry INQUIRY on power-on
Date: Mon, 03 Apr 2006 08:47:06 +0200
Message-ID: <4430C4EA.8070609@suse.de>
References: <442D2AA1.3070909@suse.de> <1143818178.3375.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:21156 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1751599AbWDCGrN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2006 02:47:13 -0400
In-Reply-To: <1143818178.3375.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2006-03-31 at 15:12 +0200, Hannes Reinecke wrote:
>> So we really should loosen that statement to do retry for all ASC 0x=
29
>> values as a power-on might well have occured without a reset.
>=20
> Actually, there's probably no reason to qualify the UNIT_ATTENTION at
> all.  Any device that replies UNIT_ATTENTION to INQUIRY is out of spe=
c,
> so it's reasonable to assume that the ASC/ASCQ responses aren't in sp=
ec
> either.  There doesn't seem to be a disadvantage to just retrying thr=
ee
> times in all unit attention cases.
>=20
Well, after looking through the trace I discovered it's not actually a
broken device, but rather more a driver issue:

- SCSI ML sends inquiry
- HBA cannot send message as transport parameters are invalid
- HBA requests sense
- HBA sets the sense code and returns command with code 'ADD_TO_MLQUEUE=
'
  to inform ML to retry the command

Only the ML fails to honour the ADD_TO_MLQUEUE code as this is
scsi_scan(), which doesn't check for it.
So if anything then rather the code in scsi_scan should been fixed to
retry the command if so advised from the LLD.

> Did you have time to look at the reset locking issue that turned up i=
n
> the aic7xxx backport?
>=20
Already sent.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
---
Excerpt of the trace:

 4:0:10:0: scsi scan: INQUIRY pass 1 length 36
scsi_add_timer: scmd: d6d57e00, time: 1375, (e083d29e)
 4:0:10:0: send 0xd6d57e00                   4:0:10:0:
        command: Inquiry: 12 00 00 00 24 00
buffer =3D 0xd8baf880, bufflen =3D 36, done =3D 0xe083ec8a, queuecomman=
d
0xe0ceeb1c
leaving scsi_dispatch_cmnd()
scsi4:A:10:0: INITIATOR_MSG_OUT byte 0x1
WDTR negotiation rejected busfree.
scsi4: ILLEGAL_PHASE 0x80
 target4:0:10: asynchronous
(scsi4:A:10:0): Unexpected command phase from packetized target
scsi4:A:10:0: Attempt to issue message failed
(scsi4:A:10:0): SCB 1: requests Check Status
(scsi4:A:10:0): Sending Sense
Copied 18 bytes of sense data at 0:
0x70 0x0 0x6 0x0 0x0 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x29 0x1 0x1 0x0
0x0 0x0
scsi_delete_timer: scmd: d6d57e00, rtn: 1
 4:0:10:0: done 0xd6d57e00 SUCCESS  8000002  4:0:10:0:
        command: Inquiry: 12 00 00 00 24 00
: Current: sense key: Unit Attention
    Additional sense: Power on occurred
scsi scan: INQUIRY failed with code 0x8000002
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
