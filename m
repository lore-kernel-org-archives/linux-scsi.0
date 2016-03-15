From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 12:48:52 +0100
Message-ID: <56E7F6A4.7090201@linux.vnet.ibm.com>
References: <1458026382-43338-1-git-send-email-hare@suse.de>
 <56E7EBFF.9030305@linux.vnet.ibm.com> <56E7F1C3.7030801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42623 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440AbcCOLs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2016 07:48:59 -0400
Received: from localhost
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 15 Mar 2016 11:48:57 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id BD1102190046
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2016 11:48:36 +0000 (GMT)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2FBmsxh51708078
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2016 11:48:54 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2FBmqAc032663
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2016 05:48:54 -0600
In-Reply-To: <56E7F1C3.7030801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/15/2016 12:28 PM, Hannes Reinecke wrote:
> On 03/15/2016 12:03 PM, Steffen Maier wrote:
>> On 03/15/2016 08:19 AM, Hannes Reinecke wrote:
>>> On larger installations it is useful to disable automatic LUN
>>> scanning, and only add the required LUNs via udev rules.
>>> This can speed up bootup dramatically.
>>>
>>> This patch introduces a new scan module parameter value 'manual',
>>> which works like 'none', but can be overriden by setting the 'resca=
n'
>>> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
>>> And it updates all relevant callers to set the 'rescan' value
>>> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>

>> In particular, the following might be necessary in order not to
>> break zfcp manual LUN addition (as long as zfcp still has its own
>> unit_add sysfs interface; completely replacing it with the solution
>> here is not easy because it breaks the zfcp sysfs user interface):
>>
>>> void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
>>> {
>>>      struct fc_rport *rport =3D unit->port->rport;
>>>      u64 lun;
>>>
>>>      lun =3D scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
>>>
>>>      if (rport && rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
>>> -         scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
>>> lun, 1);
>>> +         scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
>>> lun,
>>> +                  SCSI_SCAN_MANUAL);
>>> }

> As for zfcp: it also relies on the 'user_scan' callback from
> scsi_transport_fc, so it will fall under the same rules as any
> 'normal' FC HBA.

I'm not sure, since zfcp needs to continue to support HBA hardware=20
virtualization without NPIV.

The zfcp unit_add sysfs interface is kind of a peer of your common code=
=20
scsi scan interface interface. I think, for zfcp users, a unit_add need=
s=20
to be sufficient. It would be strange to additionally have them also=20
write the same LUN into the Scsi_Host's scan sysfs attribute, i.e.=20
having to double configure things.

> But I do think we can tie the 'scan' module parameter with the
> 'allow_lun_scan' parameter from zfcp; both are now doing essentially
> the same. Eg the 'allow_lun_scan' parameter could take it's default
> value from the 'scan' parameter.

> In the long run we might want to check if and how the global 'scan'
> parameter can be moved down to a host parameter, which then would
> eliminate the need for a zfcp-specific parameter.

I need to think about this.

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
