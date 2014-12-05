From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_scan: Send TEST UNIT READY to LUN0 before LUN scanning
Date: Fri, 05 Dec 2014 19:40:48 +0100
Message-ID: <5481FC30.1090801@suse.de>
References: <1417711162-102950-1-git-send-email-hare@suse.de> <1417738774.8998.21.camel@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaLESkx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 13:40:53 -0500
In-Reply-To: <1417738774.8998.21.camel@parallels.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Matthias.Roessler@ts.fujitsu.com" <Matthias.Roessler@ts.fujitsu.com>

On 12/05/2014 01:19 AM, James Bottomley wrote:
> On Thu, 2014-12-04 at 17:39 +0100, Hannes Reinecke wrote:
> [...]
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 0af7133..ca39e32 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -119,6 +119,13 @@ MODULE_PARM_DESC(inq_timeout,
>>  		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
>>  		 " Default is 20. Some devices may need more; most need less.");
>> =20
>> +static unsigned int scsi_scan_timeout =3D SCSI_TIMEOUT/HZ + 58;
>> +
>> +module_param_named(scan_timeout, scsi_scan_timeout, uint, S_IRUGO|S=
_IWUSR);
>> +MODULE_PARM_DESC(scan_timeout,
>> +		 "Timeout (in seconds) waiting for devices to become ready"
>> +		 " after INQUIRY. Default is 60.");
>> +
>>  /* This lock protects only this list */
>>  static DEFINE_SPINLOCK(async_scan_lock);
>>  static LIST_HEAD(scanning_hosts);
>> @@ -719,19 +726,6 @@ static int scsi_probe_lun(struct scsi_device *s=
dev, unsigned char *inq_result,
>>  	}
>> =20
>>  	/*
>> -	 * Related to the above issue:
>> -	 *
>> -	 * XXX Devices (disk or all?) should be sent a TEST UNIT READY,
>> -	 * and if not ready, sent a START_STOP to start (maybe spin up) an=
d
>> -	 * then send the INQUIRY again, since the INQUIRY can change after
>> -	 * a device is initialized.
>=20
> You're not sending a start_stop unit, so why is this being deleted?  =
Any
> unstarted unit will still return initialization command required and =
may
> or may not return lun data.
>=20
Hmm. Okay.

>> -	 *
>> -	 * Ideally, start a device if explicitly asked to do so.  This
>> -	 * assumes that a device is spun up on power on, spun down on
>> -	 * request, and then spun up on request.
>> -	 */
>> -
>> -	/*
>>  	 * The scanning code needs to know the scsi_level, even if no
>>  	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
>>  	 * non-zero LUNs can be scanned.
>> @@ -756,6 +750,65 @@ static int scsi_probe_lun(struct scsi_device *s=
dev, unsigned char *inq_result,
>>  }
>> =20
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
>=20
> Can't we just fix that?  All you need is rescan to re-read the inquir=
y
> data.
>=20
In theory, yes.
However, there is this nasty issue with UA preference, so a
Power-On/Reset UA might have obscured this one.
Plus we would need to enable it in general, in which case it would
also be run if someone unmapped LUNs on the array.
At which point we would have to _delete_ scsi devices on the fly,
something I'm not really comfortable with.
At least _not_ without quite some testing.

Besides, correct UA handling would be a good topic for LSF.
There _are_ areas where we could improve.

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
>=20
> If we're waiting 60s and coming in here every 100ms we'll get 600 of
> these in the log ... that's going to drown out anything that came bef=
ore
> it.
>=20
Ok, I'll be switching to _ratelimit here.

>> +			if (sshdr.sense_key =3D=3D NOT_READY &&
>> +			    sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x01) {
>> +				/* Logical Unit is in process
>> +				 * of becoming ready */
>> +				msleep(100);
>> +				continue;
>> +			}
>> +		}
>> +		res =3D SCSI_SCAN_LUN_PRESENT;
>=20
> Aren't you missing a break here?  Otherwise how does an unexpected
> return code from the test unit ready do anything other than loop arou=
nd
> dumping log messages until 60s have expired.
>=20
Hmm. Indeed. I'll be fixing it up.

>> +	} while (time_before_eq(jiffies, tur_timeout));
>> +	return res;
>> +}
>> +
>> +/**
>>   * scsi_add_lun - allocate and fully initialze a scsi_device
>>   * @sdev:	holds information to be stored in the new scsi_device
>>   * @inq_result:	holds the result of a previous INQUIRY to the LUN
>> @@ -1159,6 +1212,15 @@ static int scsi_probe_and_add_lun(struct scsi=
_target *starget,
>>  		goto out_free_result;
>>  	}
>> =20
>> +	if (bflags & BLIST_TEST_LUN0) {
>> +		res =3D scsi_test_lun(sdev);
>> +		if (res =3D=3D SCSI_SCAN_TARGET_PRESENT) {
>> +			SCSI_LOG_SCAN_BUS(1, sdev_printk(KERN_INFO, sdev,
>> +				"scsi scan: device not ready\n"));
>> +			goto out_free_result;
>> +		}
>> +	}
>> +
>>  	res =3D scsi_add_lun(sdev, result, &bflags, shost->async_scan);
>=20
> So any return other than SCSI_SCAN_TARGET_PRESENT gets thrown away.  =
Why
> not just return true/false from the scsi_test_lun(sdev) and set res t=
o
> SCSI_SCAN_TARGET_PRESENT in the if clause if it fails?  That should
> greatly simplify the logic inside scsi_test_lun().
>=20
Ok. Will be updating the patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
