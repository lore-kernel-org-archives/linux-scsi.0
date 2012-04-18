From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [dm-devel] [PATCH 0/2] 'default' hardware handler for multipath
Date: Wed, 18 Apr 2012 16:25:24 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B059160@SACEXCMBX02-PRD.hq.netapp.com>
References: <1333385035-6663-1-git-send-email-hare@suse.de>
 <77471C95FAFD844C8CA02DD4F4C5FE2B03A484@SACEXCMBX02-PRD.hq.netapp.com>
 <4F8ECAB5.1020806@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:56501 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab2DRQZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2012 12:25:48 -0400
In-Reply-To: <4F8ECAB5.1020806@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>

Hannes,

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, April 18, 2012 9:08 AM
> To: Moger, Babu
> Cc: device-mapper development; linux-scsi@vger.kernel.org; Mike Snitz=
er
> Subject: Re: [dm-devel] [PATCH 0/2] 'default' hardware handler for mu=
ltipath
>=20
> On 04/03/2012 11:12 PM, Moger, Babu wrote:
> > Thanks Hannes. We appreciate your work on this.
> >
> >> -----Original Message-----
> >> From: dm-devel-bounces@redhat.com [mailto:dm-devel-
> >> bounces@redhat.com] On Behalf Of Hannes Reinecke
> >> Sent: Monday, April 02, 2012 11:44 AM
> >> To: linux-scsi@vger.kernel.org
> >> Cc: dm-devel@redhat.com; Mike Snitzer
> >> Subject: [dm-devel] [PATCH 0/2] 'default' hardware handler for mul=
tipath
> >>
> >> This patchset introduces a 'default' hardware handler for dm-multi=
path.
> >> Modern storage arrays typically support two failover methods, the =
original
> >> proprietary and the modern ALUA-based one.
> >> The device_handler implementation will currently select the ALUA
> handler,
> >> and falling back to the proprietary one if ALUA isn't supported.
> >> However, in the built-in hardware table for multipath one can spec=
ify only
> >> one hardware handler, causing the original hardware handler to be
> >> overwritten.
> >> By specifying a 'default' hardware handler multipath will not try =
to attach a
> >> specific hardware handler, but rather using the currently attached=
 on.
> >
> > I think we still have some issues here. Right now we load the drive=
r
> > either by adding it in initrd or by using request_module call from =
device
> mapper.
> > If the user passes, hardware_handler   "1 default"  from multipath =
then
> request_module will fail.
> > How are we going to load the driver if these handlers are not loade=
d.
> >
> The idea of the 'default' hardware handler is to avoid multipath
> overriding the kernel matchine algorithm. To make this work we
> obviously have to load the modules prior to start multipathing.
>=20
> Given that we (ie RH and us) are already loading the device-handler
> modules from the initrd independent from multipathing we should be fi=
ne.
>=20
> But thinking a bit more about it, it might be better to handle this
> via features.
> Implementing a feature like 'default_hw_handler' would not override
> the default hardware handler from the hardware table.
> So the requested hardware handler would still be loaded, but the
> actual initialisation would be controlled via the feature.

hardware_handler is also used to pass on the arguments to handler. Like=
=2E
	hardware_handler        "2 emc 1"
We have to make sure that this feature does not break here. Considering=
 all this=20
don't you think it may be better if we make this decision in multipath =
tools itself.
Common factor here is alua. It is always between alua or some other han=
dler.
Does it make sense to check TPGS in tools?=20

> Yep, that sound better.
> I'll be preparing a patch.
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
