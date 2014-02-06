From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Thu, 06 Feb 2014 16:13:10 +0100
Message-ID: <52F3A686.3040107@suse.de>
References: <1391157974-17512-1-git-send-email-hare@suse.de>	 <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>	 <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>	 <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com>	 <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com>	 <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com>	 <52F010F9.5090305@tributary.com> <52F389A9.808@suse.de>	 <yq1eh3gv0l9.fsf@sermon.lab.mkp.net> <52F38D78.2070002@suse.de>	 <yq161osuz90.fsf@sermon.lab.mkp.net> <1391697515.2213.74.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbaBFPNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 10:13:12 -0500
In-Reply-To: <1391697515.2213.74.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jlinton@tributary.com" <jlinton@tributary.com>, "kay@vrfy.org" <kay@vrfy.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>

On 02/06/2014 03:38 PM, James Bottomley wrote:
> On Thu, 2014-02-06 at 08:50 -0500, Martin K. Petersen wrote:
>>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>>
>>>> My patch provides both the original VPD 0x83 and 0x80 bits as well=
 as
>>>> a handle identical to /sbin/scsi_id.
>>>>
>> Hannes> Bah, don't do that.  That should better be handled by udev
>> Hannes> rules.  I've got a set of patches moving from scsi_id to sg_=
inq,
>> Hannes> which can be easily adapted to using sysfs directly.
>>
>> I just want to get out of the "userland sending random SCSI commands=
"
>> business. That is a world of pain right now.
>=20
> Well, in the words of Bill Clinton "I feel your pain".  However, I ne=
ed
> to know we won't pick up that same whole world of pain in the kernel.
> Remember it's not just SCSI devices, it's also ATA devices and
> potentially other block devices ... then there's blkid and all the we=
ird
> things it does. Then there's transport identifiers for multi-path
> reservations and so on.
>=20
blkid is actually not so bad, _if_ it would distinguish between
'metadata not found' and 'I/O error during metadata read'.
I made a patch which hopefully should find it's way upstream.

And blkid just issues plain READ commands, so _this_ behaviour won't
change ...

> Convince me this path won't have us shifting a whole bunch of weird f=
rom
> user space to the kernel without any reduction in the weird factor.
> Remember the point is not what can we do for all the nicely behaved
> SCSI-3 devices, it's what do we do for everything.
>=20
Well, first and foremost the patch should be limited to SCSI-3 (and
later devices). So we'd be insulated from the most obvious crap.

So that leaves only devices which claim to be SCSI-3 or something,
but still keel over when asked for VPD pages.
However, this type of devices will fail already, as 'sd.c' is
already asking for all sorts of VPD pages.
Which leaves only non-Disk devices, but those tend to have a better
SCSI implementation as you can't make quick bucks with, say, as SCSI
Enclosure device.

But the prime motivator behind this patch is that we can be
reasonably sure the device will answer at all.
When retrieving the EVPD pages from userspace you always have the
problem that the device might have gone away or being unresponsive
by the time you get around sending the SG_IO call.
So you always have these stuck user-space processes asking for
information which _had_ been present at one point. In particular
udev is prone for this; anyone who ever came across the message

udevd[]: worker unexpectedly returned with status 0x0100

knows what I'm talking about ...

And the more udev events for a device you get, the higher the
likelyhood for this to happen is.

Plus I could re-use this information for my scsi_dh_alua patchset,
and for xcopy and friends we'll be needing it, too.

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
