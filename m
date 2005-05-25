From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Fix reference counting for failed SCSI devices
Date: Wed, 25 May 2005 17:16:18 +0200
Message-ID: <429496C2.3020706@suse.de>
References: <4292F631.9090300@suse.de> <1116975478.7710.28.camel@mulgrave>	 <4294201D.4070304@suse.de> <1117024043.5071.6.camel@mulgrave>	 <429473A1.6010402@suse.de> <1117033088.4956.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:31903 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S262370AbVEYPQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 11:16:21 -0400
In-Reply-To: <1117033088.4956.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

James Bottomley wrote:
> On Wed, 2005-05-25 at 14:46 +0200, Hannes Reinecke wrote:
>>>so it's contained within the scsi_device.  Freeing the scsi_device f=
rees
>>>the classdev (and the gendev).
>>>
>>But does not call the ->release function.
>=20
> Please just read the code like I asked.  If you do, you'll find that =
the
> sdev_classdev release method is NULL until scsi_sysfs_add_sdev()
> precisely for the reason that the class references don't matter until
> that point.  We're free to kill the whole thing without bothering abo=
ut
> the class devices until scsi_add_lun detects something and calls
> scsi_sysfs_add_sdev() to make the whole thing visible.  Then all
> classdevs get a ref on the parent gendev which their release method
> relinquishes.
>=20
Oh, right. Indeed, you are totally correct. Sorry for the noise.

>>Put it the other way round: does 'rmmod aic7xxx' work for you?
>>It certainly did _not_ work for aic79xx, hence the fix.
>=20
> Well, I know aic7xxx works perfectly on a dual channel card, because =
I
> actually test the failure paths and insmod/rmmod is one of my tests. =
 I
> can't comment on aic79xx because I don't have the hardware.
>=20
I guess it's time to convert aic79xx to the spi_transport class.
Unfortunately my attempt segfaults when removing a device in
attribute_container_device_trigger(); someone is overwriting the ->matc=
h
function. Oh well, further debugging needed.

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
