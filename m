From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] aic79xx: Fixup external device reset
Date: Wed, 25 Oct 2006 09:01:10 +0200
Message-ID: <453F0BB6.2020508@suse.de>
References: <453CC21D.5030201@suse.de> <1161733051.7104.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:26806 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1423078AbWJYHBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Oct 2006 03:01:25 -0400
In-Reply-To: <1161733051.7104.37.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

James Bottomley wrote:
> On Mon, 2006-10-23 at 15:22 +0200, Hannes Reinecke wrote:
>> +                       /* Hand-craft TUR command */
>> +                       ahd_outb(ahd, SCB_CDB_STORE, 0);
>> +                       ahd_outb(ahd, SCB_CDB_STORE+1, 0);
>> +                       ahd_outb(ahd, SCB_CDB_STORE+2, 0);
>> +                       ahd_outb(ahd, SCB_CDB_STORE+3, 0);
>> +                       ahd_outb(ahd, SCB_CDB_STORE+4, 0);
>> +                       ahd_outb(ahd, SCB_CDB_STORE+5, 0);
>> +                       ahd_outb(ahd, SCB_CDB_LEN, 6);
>> +                       scb->hscb->control &=3D ~(TAG_ENB|SCB_TAG_TY=
PE);
>> +                       scb->hscb->control |=3D MK_MESSAGE;
>> +                       ahd_outb(ahd, SCB_CONTROL, scb->hscb->contro=
l);
>> +                       ahd_outb(ahd, MSG_OUT, HOST_MSG);
>> +                       ahd_outb(ahd, SAVED_SCSIID, scb->hscb->scsii=
d);
>=20
> What's the reason for having to have this hand crafted test unit read=
y?
>=20
I asked myself the same question. It's actually from the original=20
adaptec sources, and i couldn't figure out why it was need, either.
That's why I removed it initially when doing the first round of externa=
l=20
device reset patches.

Thing is whenever we send a SCB with the MK_MESSAGE flag set the=20
sequencer will interrupt normal SCB delivery and ensure that the=20
MK_MESSAGE SCB is sent immediately. Plus we can force the connection to=
=20
non-packetized transfer as the resetted target will start out with=20
normal transfers, too. And as we already have invalidated the=20
negotiation settings for all targets a renegotiation will happen when=20
this TUR is completed.
So the normal flow of operation can continue and only one command will=20
have to be requeued from the midlayer.

I think. Or that's what I've glanced from the sequencer code. Maybe Rob=
=20
can give some more insight here.

Admittedly, this is really a nasty tweaking. In theory we should have a=
=20
proper error handler which handles this sort of thing. But the entire=20
code is littered with such tweakings so that's quite a vain hope.
Unless someone passes me a theory of operation document for it.
Having a register description is quite pointless.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
