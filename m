From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 12:54:26 +0100
Message-ID: <56E7F7F2.5090502@suse.de>
References: <1458026382-43338-1-git-send-email-hare@suse.de>
 <56E7EBFF.9030305@linux.vnet.ibm.com> <56E7F1C3.7030801@suse.de>
 <56E7F6A4.7090201@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934369AbcCOLy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 07:54:28 -0400
In-Reply-To: <56E7F6A4.7090201@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/15/2016 12:48 PM, Steffen Maier wrote:
> On 03/15/2016 12:28 PM, Hannes Reinecke wrote:
>> On 03/15/2016 12:03 PM, Steffen Maier wrote:
>>> On 03/15/2016 08:19 AM, Hannes Reinecke wrote:
>>>> On larger installations it is useful to disable automatic LUN
>>>> scanning, and only add the required LUNs via udev rules.
>>>> This can speed up bootup dramatically.
>>>>
>>>> This patch introduces a new scan module parameter value 'manual',
>>>> which works like 'none', but can be overriden by setting the
>>>> 'rescan'
>>>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>>>> And it updates all relevant callers to set the 'rescan' value
>>>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>>>>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
>>> In particular, the following might be necessary in order not to
>>> break zfcp manual LUN addition (as long as zfcp still has its own
>>> unit_add sysfs interface; completely replacing it with the solution
>>> here is not easy because it breaks the zfcp sysfs user interface):
>>>
>>>> void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
>>>> {
>>>>      struct fc_rport *rport =3D unit->port->rport;
>>>>      u64 lun;
>>>>
>>>>      lun =3D scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
>>>>
>>>>      if (rport && rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
>>>> -         scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
>>>> lun, 1);
>>>> +         scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
>>>> lun,
>>>> +                  SCSI_SCAN_MANUAL);
>>>> }
>=20
>> As for zfcp: it also relies on the 'user_scan' callback from
>> scsi_transport_fc, so it will fall under the same rules as any
>> 'normal' FC HBA.
>=20
> I'm not sure, since zfcp needs to continue to support HBA hardware
> virtualization without NPIV.
>=20
> The zfcp unit_add sysfs interface is kind of a peer of your common
> code scsi scan interface interface. I think, for zfcp users, a
> unit_add needs to be sufficient. It would be strange to additionally
> have them also write the same LUN into the Scsi_Host's scan sysfs
> attribute, i.e. having to double configure things.
>=20
Hmm. Good point. So yeah, if auto LUN scan is disabled we should be
overriding any setting from the 'scan' parameter.

Let's see if I can come up with a patch here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
