From: Hannes Reinecke <hare@suse.de>
Subject: Re: scanning for LUNs
Date: Mon, 08 Apr 2013 16:42:06 +0200
Message-ID: <5162D73E.4000906@suse.de>
References: <1365088357-22624-1-git-send-email-kys@microsoft.com> <1365088500.2764.8.camel@dabdike> <5c58dfba0d564ed4b6959a0d478268b9@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759462Ab3DHOmI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Apr 2013 10:42:08 -0400
In-Reply-To: <5c58dfba0d564ed4b6959a0d478268b9@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: James Bottomley <jbottomley@parallels.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/04/2013 07:12 PM, KY Srinivasan wrote:
>=20
>=20
>> -----Original Message-----
>> From: James Bottomley [mailto:jbottomley@parallels.com]
>> Sent: Thursday, April 04, 2013 11:15 AM
>> To: KY Srinivasan
>> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; l=
inux-
>> scsi@vger.kernel.org
>> Subject: Re: scanning for LUNs
>>
>> On Thu, 2013-04-04 at 08:12 -0700, K. Y. Srinivasan wrote:
>>> Here is the code snippet for scanning LUNS (drivers/scsi/scsi_scan.=
c in function
>>> __scsi_scan_target()):
>>>
>>>         /*
>>>          * Scan LUN 0, if there is some response, scan further. Ide=
ally, we
>>>          * would not configure LUN 0 until all LUNs are scanned.
>>>          */
>>>         res =3D scsi_probe_and_add_lun(starget, 0, &bflags, NULL, r=
escan, NULL);
>>>         if (res =3D=3D SCSI_SCAN_LUN_PRESENT || res =3D=3D
>> SCSI_SCAN_TARGET_PRESENT) {
>>>                 if (scsi_report_lun_scan(starget, bflags, rescan) !=
=3D 0)
>>>
>>>
>>> So, if we don't get a response while scanning LUN0, we will not use
>>> scsi_report_lun_scan().
>>> On Hyper-V, the scsi emulation on the host does not treat LUN0 as
>>> anything special and we
>>> could have situations where the only device under a scsi controller=
 is
>>> at a location other than 0
>>> or 1. In this case the standard LUN scanning code in Linux fails to
>>> detect this device. Is this
>>> behaviour expected? Why is LUN0 treated differently here. Looking a=
t
>>> the scsi spec, I am not sure
>>> if this is what is specified. Any help/guidance will be greatly
>>> appreciated.
>>
>> Why don't you describe the problem.  We can't scan randomly a bunch =
of
>> LUNs hoping for a response (the space is 10^19).  SAM thinks you use
>> LUNW for this, but that's not well supported.  We can't annoy USB
>> devices by probing with REPORT LUNS, so conventionally most arrays
>> return something for LUN0 even if they don't actually have one (That=
's
>> what the peripheral qualifier codes are supposed to be about).  We
>> translate PQ1 and PQ2 to SCSI_SCAN_TARGET_PRESENT, which means no LU=
N,
>> but there is a target to scan here.
>>
>> If you're sending back an error to an INQUIRY to LUN0, then you're o=
ut
>> of spec.  The SCSI standards say:
>>
>>         SPC3 6.4.1: In response to an INQUIRY command received by an
>>         incorrect logical unit, the SCSI target device shall return =
the
>>         INQUIRY data with the peripheral qualifier set to the value
>>         defined in 6.4.2. The INQUIRY command shall return CHECK
>>         CONDITION status only when the device server is unable to re=
turn
>>         the requested INQUIRY data
>=20
> Thanks James. I will further investigate the issue on our platform.
>=20
Or check if you can use W_LUN for scanning.
I've done a patchset for this (check the mailing list).

Using W_LUN is precisely for this type of setup.

(And would provide me with another scenario for using W_LUNs :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
