From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_scan: Send TEST UNIT READY to LUN0 before LUN scanning
Date: Fri, 05 Dec 2014 08:02:53 +0100
Message-ID: <5481589D.80004@suse.de>
References: <1417711162-102950-1-git-send-email-hare@suse.de> <94D0CD8314A33A4D9D801C0FE68B4029593F57E4@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaLEHC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 02:02:56 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593F57E4@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Martthias Roessler <Matthias.Roessler@ts.fujitsu.com>

On 12/04/2014 09:00 PM, Elliott, Robert (Server Storage) wrote:
>=20
>=20
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>> Sent: Thursday, 04 December, 2014 10:39 AM
> ...
>>  /**
>> + * scsi_test_lun - waiting for a LUN to become ready
>> + * @sdev:	scsi_device to test
>> + *
>> + * Description:
>> + *     Wait for the lun associated with @sdev to become ready
>> + *
>> + *     Send a TEST UNIT READY to detect any unit attention conditio=
ns.
>> + *     Retry TEST UNIT READY for up to @scsi_scan_timeout if the
>> + *     returned sense key is 02/04/01 (Not ready, Logical Unit is
>> + *     in process of becoming ready)
>> + **/
>> +static int
>> +scsi_test_lun(struct scsi_device *sdev)
>> +{
>> +	struct scsi_sense_hdr sshdr;
>> +	int res =3D SCSI_SCAN_TARGET_PRESENT;
>> +	int tur_result;
>> +	unsigned long tur_timeout =3D jiffies + scsi_scan_timeout * HZ;
>> +
>> +	/* Skip for older devices */
>> +	if (sdev->scsi_level <=3D SCSI_3)
>> +		return SCSI_SCAN_LUN_PRESENT;
>> +
>> +	/*
>> +	 * Wait for the device to become ready.
>> +	 *
>> +	 * Some targets take some time before the firmware is
>> +	 * fully initialized, during which time they might not
>> +	 * be able to fill out any REPORT_LUN command correctly.
>> +	 * And as we're not capable of handling the
>> +	 * INQUIRY DATA CHANGED unit attention correctly we'd
>> +	 * rather wait here.
>> +	 */
>> +	do {
>> +		tur_result =3D scsi_test_unit_ready(sdev, SCSI_TIMEOUT,
>> +							  3, &sshdr);
>> +		if (!tur_result) {
>> +			res =3D SCSI_SCAN_LUN_PRESENT;
>> +			break;
>> +		}
>> +		if ((driver_byte(tur_result) & DRIVER_SENSE) &&
>> +		    scsi_sense_valid(&sshdr)) {
>> +			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
>> +				"scsi_scan: tur returned %02x/%02x/%02x\n",
>> +				sshdr.sense_key, sshdr.asc, sshdr.ascq));
>> +			if (sshdr.sense_key =3D=3D NOT_READY &&
>> +			    sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x01) {
>> +				/* Logical Unit is in process
>> +				 * of becoming ready */
>> +				msleep(100);
>> +				continue;
>> +			}
>> +		}
>=20
> In SAS, you may see these after power on or after sending a
> START STOP UNIT command with START=3D1, as the controller or=20
> expander is performing staggered spinup:
> 04h/11h LOGICAL UNIT NOT READY, NOTIFY (ENABLE SPINUP) REQUIRED
>=20
> Once the drive receives NOTIFY (ENABLE SPINUP), then it starts
> reporting this until spinup is done:
> 04h/01h LOGICAL UNIT IS IN PROCESS OF BECOMING READY
>=20
> If this function is intended for general "wait for ready" use,=20
> then it should sit through both codes.
>=20
> If this function is only intended for drives that violate the
> rule to always be capable of returning REPORT LUNS data=20
> indicating LUN 0, it's hard to guess if 04h/11h could also
> appear. =20
>=20
Oh, but the point is they do _NOT_ violate the rule.
They follow SAM to the letter, and return a dummy LUN inventory with
just LUN0. Once the firmware is ready it sets an 'REPORT LUN DATA
CHANGED' UA. But the SCSI stack never acts on that UA,
and the subsequent LUNs will never scanned.

Cheers,

Hannes

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
