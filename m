From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Fix reference counting for failed SCSI devices
Date: Wed, 25 May 2005 14:46:25 +0200
Message-ID: <429473A1.6010402@suse.de>
References: <4292F631.9090300@suse.de> <1116975478.7710.28.camel@mulgrave>	 <4294201D.4070304@suse.de> <1117024043.5071.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:63419 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261443AbVEYMq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 08:46:26 -0400
In-Reply-To: <1117024043.5071.6.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2005-05-25 at 08:50 +0200, Hannes Reinecke wrote:
>>>>+	class_device_put(&sdev->sdev_classdev);
>>>This is unnecessary since the class device is simply occupying a pri=
vate
>>>area in the scsi_device.  As long as its never made visible to the
>>>system, its refcount is irrelevant
>>>
>>It's not. Whenever you try to rmmod the adapter it becomes highly
>>relevant. If it doesn't crash you've at least generated a memleak as =
the
>>class device is never freed.
>>(And these are quite a few for Wide-SCSI Double-channel adapters ...)
>=20
> ?  Look at the code; you're not doing a put on a pointer to the
> sdev_classdev, you're doing a put on a reference to it.
>=20
> It's defined in scsi_device.h:
>=20
> struct scsi_device {
> 	...
> 	struct class_device sdev_classdev;
> 	...
> };
>=20
> so it's contained within the scsi_device.  Freeing the scsi_device fr=
ees
> the classdev (and the gendev).
>=20
But does not call the ->release function.

Put it the other way round: does 'rmmod aic7xxx' work for you?
It certainly did _not_ work for aic79xx, hence the fix.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=C3=9Fe 5				+49 911 74053 688
90409 N=C3=BCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
