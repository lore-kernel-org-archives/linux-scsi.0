From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Sanitize PQ3 device handling
Date: Wed, 18 May 2005 16:05:36 +0200
Message-ID: <428B4BB0.9040306@suse.de>
References: <428B0E4D.50505@suse.de> <20050518140140.GA22570@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:22748 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262218AbVEROFp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 10:05:45 -0400
In-Reply-To: <20050518140140.GA22570@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
>> 	res =3D scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan, =
NULL);
>>-	if (res =3D=3D SCSI_SCAN_LUN_PRESENT) {
>>-		if (scsi_report_lun_scan(sdev, bflags, rescan) !=3D 0)
>>+	if (res !=3D SCSI_SCAN_NO_RESPONSE) {
>>+		if (scsi_report_lun_scan(sdev, bflags, rescan) !=3D 0) {
>> 			/*
>> 			 * The REPORT LUN did not scan the target,
>> 			 * do a sequential scan.
>> 			 */
>>+			if (res =3D=3D SCSI_SCAN_TARGET_PRESENT)
>>+				/*
>>+				 * There's a target here, but lun 0 is=20
>>+				 * offline so we can't use the report_lun
>>+				 * scan.  Fall back to a sequential lun scan
>>+				 * with a bflags of SPARSELUN.
>>+				 *
>>+				 * The old code also used a default scsi level
>>+				 * of SCSI_2 which seems a bit spurious. Any
>>+				 * misbehaving device should rather be added
>>+				 * to the blacklist.
>>+				 */
>>+				bflags |=3D BLIST_SPARSELUN;
>>+
>> 			scsi_sequential_lun_scan(starget, bflags,
>> 				       	res, sdev->scsi_level, rescan);
>=20
> If scsi_probe_and_add_lun returns SCSI_SCAN_TARGET_PRESENT sdev isn't=
 valid at
> this point.  You should probably default to SCSI_2 for that case.
>=20
How so? This is exactly the behaviour I've removed. sdev is valid even
for SCSI_SCAN_TARGET_PRESENT.
If not please show me.

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
