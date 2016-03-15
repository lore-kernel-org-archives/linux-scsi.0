From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 07:47:34 +0100
Message-ID: <56E7B006.6020809@suse.de>
References: <1457710420-37769-1-git-send-email-hare@suse.de>
 <yq1y49kfwa9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50491 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbcCOGrg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 02:47:36 -0400
In-Reply-To: <yq1y49kfwa9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/15/2016 12:57 AM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 97074c9..929204b 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -96,10 +96,11 @@ MODULE_PARM_DESC(max_luns,
>>  #define SCSI_SCAN_TYPE_DEFAULT "sync"
>>  #endif
>> =20
>> -char scsi_scan_type[6] =3D SCSI_SCAN_TYPE_DEFAULT;
>> +char scsi_scan_type[9] =3D SCSI_SCAN_TYPE_DEFAULT;
>> =20
>> -module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type), S=
_IRUGO);
>> -MODULE_PARM_DESC(scan, "sync, async or none");
>> +module_param_string(scan, scsi_scan_type, sizeof(scsi_scan_type),
>> +		    S_IRUGO|S_IWUSR);
>> +MODULE_PARM_DESC(scan, "sync, async, disabled, or none");
>=20
> So "disabled" is "sometimes enabled" and "none" is "really disabled"?
> =20
'disabled' means:
disable automatic scanning, but allow manual scanning via the 'scan'
attribute.

>>  static unsigned int scsi_inq_timeout =3D SCSI_TIMEOUT/HZ + 18;
>> =20
>> @@ -1604,7 +1605,9 @@ static void __scsi_scan_target(struct device *=
parent, unsigned int channel,
>>   * @channel:	channel to scan
>>   * @id:		target id to scan
>>   * @lun:	Specific LUN to scan or SCAN_WILD_CARD
>> - * @rescan:	passed to LUN scanning routines
>> + * @rescan:	passed to LUN scanning routines; 0 for no rescan, 1 to =
rescan
>> + *              existing LUNs, and 2 to override any 'scan_disabled=
' setting
>> + *              from the host.
>=20
> enum SCSI_SCAN_FOO_BAR instead of magic values, please.
>=20
Okay.

> What's this "scan_disabled" setting from the host?
>=20
It's called a 'typo' and found quite frequently in the wilds :-)

I'll be sending a respin.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
