From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Tue, 5 Apr 2016 14:20:46 +0200
Message-ID: <20160405122046.GC13317@bblock-ThinkPad-W530>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
 <20160330194153.GB13317@bblock-ThinkPad-W530>
 <56FE234B.8090904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:39853 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847AbcDEMUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2016 08:20:53 -0400
Received: from localhost
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
	Tue, 5 Apr 2016 13:20:51 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2448817D8059
	for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2016 13:21:29 +0100 (BST)
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u35CKmGE7995880
	for <linux-scsi@vger.kernel.org>; Tue, 5 Apr 2016 12:20:48 GMT
Received: from d06av06.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u35CKmcG018209
	for <linux-scsi@vger.kernel.org>; Tue, 5 Apr 2016 08:20:48 -0400
Received: from bblock-ThinkPad-W530 (dyn-9-152-222-126.boeblingen.de.ibm.com [9.152.222.126])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id u35CKk7H018061
	for <linux-scsi@vger.kernel.org>; Tue, 5 Apr 2016 08:20:46 -0400
Content-Disposition: inline
In-Reply-To: <56FE234B.8090904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 09:29 Fri 01 Apr     , Hannes Reinecke wrote:
> On 03/30/2016 09:41 PM, Benjamin Block wrote:
> > Hello Hannes,
> >=20
> > I am a bit late here, but as this got pulled and Steffen didn't hav=
e
> > time to give it a review, I did today.
> >=20
> > On 08:39 Thu 17 Mar     , Hannes Reinecke wrote:
> >> On larger installations it is useful to disable automatic LUN
> >> scanning, and only add the required LUNs via udev rules.
> >> This can speed up bootup dramatically.
> >>
> >> This patch introduces a new scan module parameter value 'manual',
> >> which works like 'none', but can be overriden by setting the 'resc=
an'
> >> value from scsi_scan_target to 'SCSI_SCAN_MANUAL'.
> >> And it updates all relevant callers to set the 'rescan' value
> >> to 'SCSI_SCAN_MANUAL' if invoked via the 'scan' option in sysfs.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >=20
> > [:snip:]
> >=20
> >>
> >> diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfc=
p_unit.c
> >> index 157d3d2..08bba7c 100644
> >> --- a/drivers/s390/scsi/zfcp_unit.c
> >> +++ b/drivers/s390/scsi/zfcp_unit.c
> >> @@ -26,7 +26,8 @@ void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
> >>  	lun =3D scsilun_to_int((struct scsi_lun *) &unit->fcp_lun);
> >>
> >>  	if (rport && rport->port_state =3D=3D FC_PORTSTATE_ONLINE)
> >> -		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun, 1)=
;
> >> +		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun,
> >> +				 SCSI_SCAN_RESCAN);
> >=20
> > I'd rather use the new SCSI_SCAN_MANUAL here. We don't want this to=
 be
> > "blocked" by an attribute set in a different (new) code-path and
> > config-location.
> >=20
> > This path is used by both, zfcp-recovery and -userinterfaces (sysfs=
) and
> > in both cases we call it with the intend that the scan is really do=
ne -
> > hence the SCSI_SCAN_MANUAL to force a scan. I'd find it very weird =
if
> > suddenly our users would have to additionally use yet an other conf=
ig to
> > get the old interfaces working properly.
> >=20
> Okay, no problem with that.
> zfcp has its own scanning rules (cf allow_lun_scan module parameter),=
 so
> setting it to 'MANUAL' will just restore the original behaviour.
>=20
> Will you be sending a patch for it?
>=20

Yeah, sry, once I am through our backlog and I find time to test that
properly.



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
