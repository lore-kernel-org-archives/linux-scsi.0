From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [dm-devel] [PATCH 0/4] scsi_dh: Fix for handler attach and code clean up
Date: Wed, 2 Nov 2011 11:13:16 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DB8D0@RTPMVEXC1-PRD.hq.netapp.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DB4D4@RTPMVEXC1-PRD.hq.netapp.com> <4EB0EE06.8020200@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:6633 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab1KBPNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2011 11:13:37 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4EB0EE06.8020200@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

Hannes,
Thanks for the comments. Please see my response..=20

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, November 02, 2011 2:15 AM
> To: device-mapper development
> Cc: Moger, Babu; Linux SCSI Mailing list
> Subject: Re: [dm-devel] [PATCH 0/4] scsi_dh: Fix for handler attach a=
nd
> code clean up
>=20
> On 11/01/2011 06:19 PM, Moger, Babu wrote:
> > These series of patches handles following things.
> > 1. Fixes handler attach issue.
> > 2. Introduces match function for all the handlers
> > 3. cleans up the scsi_dh code
> >
> > I have noticed the attach issue during our multipath testing. We
> found that during
> > the lun discovery there were lots of error messages like below..
> >
> > Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav]  Result:
> hostbyte=3DDID_OK
> > driverbyte=3DDRIVER_SENSE
> > Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav]  Sense Key :
> Illegal
> > Request [current]
> > Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav]<<vendor>>
> ASC=3D0x94
> > ASCQ=3D0x1ASC=3D0x94 ASCQ=3D0x1
> > Oct 25 08:24:43 kswm-mihosi kernel: sd 0:0:0:7: [sdav] CDB: Read(10=
):
> 28 00 00
> > 00 00 00 00 00 80 00
> > Oct 25 08:24:43 kswm-mihosi kernel: end_request: I/O error, dev sda=
v,
> sector 0
> >
> > These messages were coming in spite of having scsi_dh_rdac in initr=
d.
> Reason
> > for these errors are due to device handler not being attached
> properly. If the
> > device handler was attached then the I/O's should not go to passive
> paths.
> >
> > Investigating further we found that there errors started with the
> introduction
> > of these patches below.
> >
> > http://www.spinics.net/lists/linux-scsi/msg54284.html
> > or
> > http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-
> 2.6.git;a=3Dcommit;h=3D6c3633d08acf514e2e89aa95d2346ce9d64d719a
> >
> > This patch introduces the match function for device handlers. But t=
he
> match function
> > was added only to scsi_dh_alua handler.
> >
> > Reason for the failure is, if the match function is not available
> then scsi_dh calls
> > scsi_get_device_flags_keyed(sdev, sdev->vendor, sdev->model,
> SCSI_DEVINFO_DH)
> > which compares the exact vendor and product strings from sdev(which
> comes from inquiry).
> >
> > While setting up the scsi_dev_info, handlers use the short
> strings(example below).
> > Look at scsi_register_device_handler code. If  you look closely the
> handlers have
> > only first few characters of the model string. So,
> scsi_get_device_flags_keyed
> > fails and handler will not be attached. This applies to all the
> handlers.
> >
> > Example :
> >
> >          Strings in scsi_dh_rdac handler..
> >                      {"IBM", "1746"},
> >
> >          Actual string..
> >                       "IBM", "1746      FAStT"
> >
> > Couple of ways we can fix this problem.
> > 1. List the complete model strings in handlers for all the products=
=2E
> > 2. Introduce match function for all the handler and remove the call
> to scsi_get_device_flags_keyed.
> >
> > I think the option 2 is the best way to fix this problem. This
> removes lot of code in scsi_dh and
> > simplifies the things..
> >
> > TESTED the patches on NetApp E series storage.
> >
> And this was the main intention of the original patch, introducing
> the ->match() function.
>=20
> However, one thing to keep in mind here:
> What do we do if two ->match() function trigger?
> IE a NetApp E series in ALUA mode would have both match functions
> from scsi_dh_alua and scsi_dh_rdac matching.
> As there is no sane way of keeping the module order (having alua
> always first in the list of modules is very error-prone), I would
> think we'd need to introduce some checks in the vendor-specific
> device-handler to have the match() function returning 'false' if the
> respective device is in ALUA mode.

  Agree. We cannot assume module loading order. I will add a new check =
in rdac for
 TPGS bit. If TPGS  is enabled then scsi_dh_rdac will return false. Wil=
l send the
 Patches tomorrow.=20

>=20
> This doesn't affect multipathing at all, it's just for having a sane
> default when the system boots up.
>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
