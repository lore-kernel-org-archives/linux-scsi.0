From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 12:03:27 +0100
Message-ID: <56E7EBFF.9030305@linux.vnet.ibm.com>
References: <1458026382-43338-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:41844 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbcCOLDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2016 07:03:32 -0400
Received: from localhost
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 15 Mar 2016 11:03:30 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id AE2A217D8067
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2016 11:03:59 +0000 (GMT)
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2FB3S4K57868318
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2016 11:03:28 GMT
Received: from d06av10.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2FA3UM6018036
	for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2016 04:03:30 -0600
In-Reply-To: <1458026382-43338-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/15/2016 08:19 AM, Hannes Reinecke wrote:
> On larger installations it is useful to disable automatic LUN
> scanning, and only add the required LUNs via udev rules.
> This can speed up bootup dramatically.
>
> This patch introduces a new scan module parameter value 'manual',
> which works like 'none', but can be overriden by setting the 'rescan'
> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
> And it updates all relevant callers to set the 'rescan' value
> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

> +MODULE_PARM_DESC(scan, "sync, async, manual, or none. "
> +		 "Setting to 'manual' disables automatic scanning, but allows "
> +		 "for manual device scan via the 'scan' sysfs attribute.");

nice solution

> + * @rescan:	passed to LUN scanning routines; SCSI_SCAN_NONE for no r=
escan,
> + *              SCSI_SCAN_RESCAN to rescan existing LUNs, and SCSI_S=
CAN_MANUAL
> + *              to force scanning even if 'scan=3Dmanual' is set.

> @@ -1621,6 +1627,10 @@ void scsi_scan_target(struct device *parent, u=
nsigned int channel,
>   	if (strncmp(scsi_scan_type, "none", 4) =3D=3D 0)
>   		return;
>
> +	if (rescan < SCSI_SCAN_MANUAL &&
> +	    strncmp(scsi_scan_type, "manual", 6) =3D=3D 0)
> +		return;
> +

I see that the ordering of identifiers in enum scsi_scan_mode allows a=20
nice inequation here.

However, it also seems that we need to touch all callers (which intend=20
an unconditional manual scan) of scsi_scan_target() that used to call i=
t=20
with rescan=3D=3D1 which would now be rescan=3D=3DSCSI_SCAN_MANUAL=3D=3D=
2 ?

Or could we define the ordering of identifiers in enum scsi_scan_mode=20
such that SCSI_SCAN_MANUAL happens to remain 1 so we don't have to touc=
h=20
many callers (probably there would still remain some callers we would=20
have to touch because 1 does not mean MANUAL but RESCAN there)?

In particular, the following might be necessary in order not to break=20
zfcp manual LUN addition (as long as zfcp still has its own unit_add=20
sysfs interface; completely replacing it with the solution here is not=20
easy because it breaks the zfcp sysfs user interface):

> void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
> {
> 	struct fc_rport *rport =3D unit->port->rport;
> 	u64 lun;
>
> 	lun =3D scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
>
> 	if (rport && rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
>- 		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun, 1);
>+ 		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun,
>+ 				 SCSI_SCAN_MANUAL);
> }

Not sure about: mpt_work_wrapper(), snic_scsi_scan_tgt().

> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -143,7 +143,8 @@ static int scsi_scan(struct Scsi_Host *shost, con=
st char *str)

> +		res =3D scsi_scan_host_selected(shost, channel, id, lun,
> +					      SCSI_SCAN_MANUAL);

> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2110,7 +2110,8 @@ fc_user_scan_tgt(struct Scsi_Host *shost, uint =
channel, uint id, u64 lun)

> +			scsi_scan_target(&rport->dev, channel, id, lun,
> +					 SCSI_SCAN_MANUAL);

> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1819,7 +1819,7 @@ static int iscsi_user_scan_session(struct devic=
e *dev, void *data)

>   			scsi_scan_target(&session->dev, 0, id,
> +					 scan_data->lun, SCSI_SCAN_MANUAL);

> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1739,8 +1739,8 @@ static int sas_user_scan(struct Scsi_Host *shos=
t, uint channel,

> +			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
> +					 lun, SCSI_SCAN_MANUAL);

> +++ b/include/scsi/scsi_device.h

> +enum scsi_scan_mode {
> +	SCSI_SCAN_NONE =3D 0,
> +	SCSI_SCAN_RESCAN,
> +	SCSI_SCAN_MANUAL,
> +};

--=20
Mit freundlichen Gr=FC=DFen / Kind regards
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
