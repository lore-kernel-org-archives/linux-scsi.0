From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Sanitize PQ3 device handling
Date: Wed, 18 May 2005 16:33:29 +0200
Message-ID: <428B5239.5090502@suse.de>
References: <428B0E4D.50505@suse.de> <20050518140140.GA22570@infradead.org> <428B4BB0.9040306@suse.de> <20050518141459.GA22916@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:2975 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S262254AbVEROda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 10:33:30 -0400
In-Reply-To: <20050518141459.GA22916@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> On Wed, May 18, 2005 at 04:05:36PM +0200, Hannes Reinecke wrote:
>>>If scsi_probe_and_add_lun returns SCSI_SCAN_TARGET_PRESENT sdev isn'=
t valid at
>>>this point.  You should probably default to SCSI_2 for that case.
>>>
>>How so? This is exactly the behaviour I've removed. sdev is valid eve=
n
>>for SCSI_SCAN_TARGET_PRESENT.
>>If not please show me.
>=20
> Indeed, you replaced the check at the end of scsi_probe_and_add_lun. =
 I don't
> think it makes a lot of sense to leave around the stale scsi_dev for =
PQ3, though.
Why not? sg connects to it and you can ask it to provide lots of useles=
s
information. Eg doing an report_luns by hand if the configuration of th=
e
SAN has changed; PQ3 only states that _this_ device will never have a
LUN attached.
>=20
> Doing a REPORT_LUNS for SCSI_SCAN_TARGET_PRESENT does OTOH make a lot=
 of sense,
> there's nothing in the spec against it.  So what about dropping that =
device
> after we're done with REPORT_LUNS?
>=20
See above. I'd like to have them around to be able to send commands to =
it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
