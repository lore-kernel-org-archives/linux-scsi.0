From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Wed, 30 Mar 2016 21:41:53 +0200
Message-ID: <20160330194153.GB13317@bblock-ThinkPad-W530>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:58589 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbcC3Tl6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2016 15:41:58 -0400
Received: from localhost
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
	Wed, 30 Mar 2016 20:41:57 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id CAFDC2190056
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2016 20:41:34 +0100 (BST)
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u2UJfs6K8716720
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2016 19:41:54 GMT
Received: from d06av01.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u2UJfsJs025302
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2016 13:41:54 -0600
Received: from bblock-ThinkPad-W530 (dyn-9-152-222-126.boeblingen.de.ibm.com [9.152.222.126])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u2UJfsQR025293
	for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2016 13:41:54 -0600
Content-Disposition: inline
In-Reply-To: <1458200385-32088-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Hello Hannes,

I am a bit late here, but as this got pulled and Steffen didn't have
time to give it a review, I did today.

On 08:39 Thu 17 Mar     , Hannes Reinecke wrote:
> On larger installations it is useful to disable automatic LUN
> scanning, and only add the required LUNs via udev rules.
> This can speed up bootup dramatically.
>=20
> This patch introduces a new scan module parameter value 'manual',
> which works like 'none', but can be overriden by setting the 'rescan'
> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
> And it updates all relevant callers to set the 'rescan' value
> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

[:snip:]

>=20
> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_u=
nit.c
> index 157d3d2..08bba7c 100644
> --- a/drivers/s390/scsi/zfcp_unit.c
> +++ b/drivers/s390/scsi/zfcp_unit.c
> @@ -26,7 +26,8 @@ void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
>  	lun =3D scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
>=20
>  	if (rport && rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
> -		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun, 1);
> +		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun,
> +				 SCSI_SCAN_RESCAN);

I'd rather use the new SCSI_SCAN_MANUAL here. We don't want this to be
"blocked" by an attribute set in a different (new) code-path and
config-location.

This path is used by both, zfcp-recovery and -userinterfaces (sysfs) an=
d
in both cases we call it with the intend that the scan is really done -
hence the SCSI_SCAN_MANUAL to force a scan. I'd find it very weird if
suddenly our users would have to additionally use yet an other config t=
o
get the old interfaces working properly.



                                                    Beste Gr=FC=DFe / B=
est regards,
                                                      - Benjamin Block
--=20
Linux on z Systems Development         /         IBM Systems & Technolo=
gy Group
		  IBM Deutschland Research & Development GmbH=20
Vorsitz. AufsR.: Martina Koederitz     /        Gesch=E4ftsf=FChrung: D=
irk Wittkopp
Sitz der Gesellschaft: B=F6blingen / Registergericht: AmtsG Stuttgart, =
HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
