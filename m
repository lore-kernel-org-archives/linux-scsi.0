From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 12:28:03 +0100
Message-ID: <56E7F1C3.7030801@suse.de>
References: <1458026382-43338-1-git-send-email-hare@suse.de>
 <56E7EBFF.9030305@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbcCOL2H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 07:28:07 -0400
In-Reply-To: <56E7EBFF.9030305@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/15/2016 12:03 PM, Steffen Maier wrote:
> On 03/15/2016 08:19 AM, Hannes Reinecke wrote:
>> On larger installations it is useful to disable automatic LUN
>> scanning, and only add the required LUNs via udev rules.
>> This can speed up bootup dramatically.
>>
>> This patch introduces a new scan module parameter value 'manual',
>> which works like 'none', but can be overriden by setting the 'rescan=
'
>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>> And it updates all relevant callers to set the 'rescan' value
>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>=20
>> +MODULE_PARM_DESC(scan, "sync, async, manual, or none. "
>> +         "Setting to 'manual' disables automatic scanning, but
>> allows "
>> +         "for manual device scan via the 'scan' sysfs attribute.");
>=20
> nice solution
>=20
>> + * @rescan:    passed to LUN scanning routines; SCSI_SCAN_NONE
>> for no rescan,
>> + *              SCSI_SCAN_RESCAN to rescan existing LUNs, and
>> SCSI_SCAN_MANUAL
>> + *              to force scanning even if 'scan=3Dmanual' is set.
>=20
>> @@ -1621,6 +1627,10 @@ void scsi_scan_target(struct device
>> *parent, unsigned int channel,
>>       if (strncmp(scsi_scan_type, "none", 4) =3D=3D 0)
>>           return;
>>
>> +    if (rescan < SCSI_SCAN_MANUAL &&
>> +        strncmp(scsi_scan_type, "manual", 6) =3D=3D 0)
>> +        return;
>> +
>=20
> I see that the ordering of identifiers in enum scsi_scan_mode allows
> a nice inequation here.
>=20
> However, it also seems that we need to touch all callers (which
> intend an unconditional manual scan) of scsi_scan_target() that used
> to call it with rescan=3D=3D1 which would now be
> rescan=3D=3DSCSI_SCAN_MANUAL=3D=3D2 ?
>=20
Yes, sort of.

However, not _all_ callers need to be touched (as this would defeat
the purpose). We just need to touch those callers which will be
invoked by a _manual_ scan via

echo "X X X" > /sys/class/scsi_host/hostX/scan

Other callers should _not_ be modified, as the automatic scan should
be disabled.

> Or could we define the ordering of identifiers in enum
> scsi_scan_mode such that SCSI_SCAN_MANUAL happens to remain 1 so we
> don't have to touch many callers (probably there would still remain
> some callers we would have to touch because 1 does not mean MANUAL
> but RESCAN there)?
>=20
> In particular, the following might be necessary in order not to
> break zfcp manual LUN addition (as long as zfcp still has its own
> unit_add sysfs interface; completely replacing it with the solution
> here is not easy because it breaks the zfcp sysfs user interface):
>=20
>> void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
>> {
>>     struct fc_rport *rport =3D unit->port->rport;
>>     u64 lun;
>>
>>     lun =3D scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
>>
>>     if (rport && rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
>> -         scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
>> lun, 1);
>> +         scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
>> lun,
>> +                  SCSI_SCAN_MANUAL);
>> }
>=20
> Not sure about: mpt_work_wrapper(), snic_scsi_scan_tgt().
>=20
See above. We only need to modify the call sites triggered from
drivers/scsi/scsi_sysfs.c:scsi_scan(); all other functions need to
remain as-is to allow the mechanism to work correctly.

As for zfcp: it also relies on the 'user_scan' callback from
scsi_transport_fc, so it will fall under the same rules as any
'normal' FC HBA.
But I do think we can tie the 'scan' module parameter with the
'allow_lun_scan' parameter from zfcp; both are now doing essentially
the same. Eg the 'allow_lun_scan' parameter could take it's default
value from the 'scan' parameter.

In the long run we might want to check if and how the global 'scan'
parameter can be moved down to a host parameter, which then would
eliminate the need for a zfcp-specific parameter.

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
