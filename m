From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [PATCH / RFC] scsi_set_host_offline
Date: Wed, 5 Mar 2003 20:49:16 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200303052049.16538.oliver@neukum.name>
References: <20030303221532.GB1587@beaverton.ibm.com> <200303050012.35309.oliver@neukum.name> <1046883135.1784.23.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1046883135.1784.23.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>

Am Mittwoch, 5. M=E4rz 2003 17:52 schrieben Sie:
> On Tue, 2003-03-04 at 17:12, Oliver Neukum wrote:
> > It seems to me that there's a race with scan_scsis() and
> > scan_scsis_single() which cannot be closed with failing queuecomman=
d, as
> > there's a window where the INQUIRY has succeeded but has not yet be=
en
> > evaluated by the SCSI layer.
>
> Consider the offline function as a work in progress.  I think the mod=
el

I do. But problems have to be pointed out and fixes proposed.

> we'll ultimately move to is to use the sysfs refcounting, so we could
> call the offline function, have the device refuse all incoming reques=
ts,
> but still process pending ones (which, if this is a forced remove sho=
uld
> fail).  Then call a remove hook when the outstanding command count dr=
ops
> to zero.

What exactly is a refcount supposed to do? It doesn't help the main pro=
blem.
You must prevent new references arising. This requires locking and flag=
s.

> > I am not quite sure how slave_alloc() is involved into this, but IM=
HO
> > it's wrong to force LLDDs to know about devices if they are hotplug=
gable.
> > Could you clarify?
>
> By design LLDs need to know about configured devices because they may
> (although not all do) need to allocate resources to process them.  Th=
e
> slave configure/alloc/destroy is the interface for communicating this
> information:

Very well, but that system should not be overloaded with hotplugging is=
sues.
IMHO we must not require drivers to support this interface just because=
 they
are hotpluggable.

	Regards
		Oliver

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
