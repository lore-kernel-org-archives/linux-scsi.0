From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone
 (one line)
Date: Mon, 16 May 2011 07:56:14 +0200
Message-ID: <4DD0BC7E.3060901@suse.de>
References: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com> <201105122203.13671.rjw@sisk.pl> <1305232563.2575.85.camel@mulgrave.site> <201105142111.53266.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201105142111.53266.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Charles Hannum <root@ihack.net>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/14/2011 09:11 PM, Oliver Neukum wrote:
> Am Donnerstag, 12. Mai 2011, 22:36:03 schrieb James Bottomley:
>
>> Instinct tells me the correct set of fixes is to add a sync cache fr=
om
>> release (so we automatically sync on last close, which is usually wh=
en
>> an ordered remove happens), keep the one on shutdown, just in case t=
he
>> system goes down with stuff still mounted and print a nasty message =
on
>> suspend for a write back device that's been removed.
>>
>> I also think we shouldn't abort the suspend if the disk doesn't resp=
ond
>> correctly to start/stop ... the power is going to be disconnected
>> anyway, so it's no issue if the disk spins for a second or so longer=
=2E
>>
>> The problem this is going to cause is double sync on shutdown (once =
when
>> final unmount closes the device and once on shutdown) ... do people
>> agree that's a price worth paying?
>>
>> Something like this?
>
> Hi,
>
> it seems to me that the error codes should really be evaluated a bit =
better.
> How about this?
>
> 	Regards
> 		Oliver
>
>  From 2ab03ae46d6dc126a51ee9cd38206fbdc8bf6a34 Mon Sep 17 00:00:00 20=
01
> From: Oliver Neukum<oliver@neukum.org>
> Date: Mon, 25 Oct 2010 12:25:26 +0200
> Subject: [PATCH 2/5] SCSI:sd:error handling in sd_sync_cache()
>
> The SCSI commands sd_sync_cache() uses may fail.
> These errors needs to be evaluated to return correct
> error codes. This fixes system suspension while a device
> removal is being handled.
>
> Signed-off-by: Oliver NEukum<oneukum@suse.de>
Yep, this makes sense.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
