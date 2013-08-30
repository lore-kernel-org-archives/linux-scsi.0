From: Hannes Reinecke <hare@suse.de>
Subject: Re: PATCH: scsi: make scsi reset permissions more relaxed (RFC)
Date: Fri, 30 Aug 2013 14:18:04 +0200
Message-ID: <52208D7C.8000009@suse.de>
References: <20130830120450.GB31120@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130830120450.GB31120@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcus Meissner <meissner@suse.de>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/30/2013 02:04 PM, Marcus Meissner wrote:
> Hi folks,
>=20
> cdrecord wants to whack the CD drive with a SCSI RESET ...
>=20
> So far SCSI RESET can be done at 4 levels (target, device, bus, host)
> and all 4 are checked for CAP_SYS_ADMIN / CAP_SYS_RAWIO.
>=20
>=20
> As the cdrecord author wants special permissions for cdrecord, readcd=
 ,
> cdda2wav to allow it to send SCSI RESET commands I was wondering if
> relaxing the permission is a potential idea?
>=20
> This would allow SCSI reset on target/device if a local user
> gets regular access to a SCSI device (via udev acls etc.)
>=20
Hmm. Device and target reset are typically implemented at the
transport level (SCSI itself doesn't have any commands for this).
So it should be possible to inject them via bsg, and as such should
have the same restrictions as bsg has.
Assuming that sg and bsg follow the same rules the patch should be okay=
=2E

>=20
> (I know that the actual reset code will fall back into the chain
>  target -> device -> bus -> host resetting if one fails.)
>=20
Actually, it doesn't. sg_reset_provider() will just call the
individual function.

If the function fails _and_ there are commands send to the device
then the error handling will kick in, but it won't be triggered
directly.
Not sure if that makes a difference, though.

> Signed-off-by: Marcus Meissner <meissner@suse.de>
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
