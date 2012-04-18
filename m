From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [PATCH 0/2] 'default' hardware handler for multipath
Date: Wed, 18 Apr 2012 16:07:49 +0200
Message-ID: <4F8ECAB5.1020806@suse.de>
References: <1333385035-6663-1-git-send-email-hare@suse.de> <77471C95FAFD844C8CA02DD4F4C5FE2B03A484@SACEXCMBX02-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab2DROHx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Apr 2012 10:07:53 -0400
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B03A484@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>

On 04/03/2012 11:12 PM, Moger, Babu wrote:
> Thanks Hannes. We appreciate your work on this.
>=20
>> -----Original Message-----
>> From: dm-devel-bounces@redhat.com [mailto:dm-devel-
>> bounces@redhat.com] On Behalf Of Hannes Reinecke
>> Sent: Monday, April 02, 2012 11:44 AM
>> To: linux-scsi@vger.kernel.org
>> Cc: dm-devel@redhat.com; Mike Snitzer
>> Subject: [dm-devel] [PATCH 0/2] 'default' hardware handler for multi=
path
>>
>> This patchset introduces a 'default' hardware handler for dm-multipa=
th.
>> Modern storage arrays typically support two failover methods, the or=
iginal
>> proprietary and the modern ALUA-based one.
>> The device_handler implementation will currently select the ALUA han=
dler,
>> and falling back to the proprietary one if ALUA isn't supported.
>> However, in the built-in hardware table for multipath one can specif=
y only
>> one hardware handler, causing the original hardware handler to be
>> overwritten.
>> By specifying a 'default' hardware handler multipath will not try to=
 attach a
>> specific hardware handler, but rather using the currently attached o=
n.
>=20
> I think we still have some issues here. Right now we load the driver
> either by adding it in initrd or by using request_module call from de=
vice mapper.
> If the user passes, hardware_handler   "1 default"  from multipath th=
en request_module will fail.=20
> How are we going to load the driver if these handlers are not loaded.=
=20
>=20
The idea of the 'default' hardware handler is to avoid multipath
overriding the kernel matchine algorithm. To make this work we
obviously have to load the modules prior to start multipathing.

Given that we (ie RH and us) are already loading the device-handler
modules from the initrd independent from multipathing we should be fine=
=2E

But thinking a bit more about it, it might be better to handle this
via features.
Implementing a feature like 'default_hw_handler' would not override
the default hardware handler from the hardware table.
So the requested hardware handler would still be loaded, but the
actual initialisation would be controlled via the feature.

Yep, that sound better.
I'll be preparing a patch.

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
