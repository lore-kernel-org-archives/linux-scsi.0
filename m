From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3] SG_SCSI_RESET ioctl: add no_escalate values
Date: Mon, 20 Oct 2014 13:30:37 +0200
Message-ID: <5444F25D.5010903@suse.de>
References: <5442C969.4060504@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbaJTLak (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2014 07:30:40 -0400
In-Reply-To: <5442C969.4060504@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Elliott, Robert (Server Storage)" <elliott@hp.com>, Jeremy Linton <jlinton@tributary.com>

On 10/18/2014 10:11 PM, Douglas Gilbert wrote:
> Further to a January 2013 thread titled: "[PATCH] SG_SCSI_RESET ioctl
> should only perform requested operation" by Jeremy Linton a patch (v3=
)
> is presented that expands the existing ioctl to include "no_escalate"
> versions to the existing resets. This requires no changes to SCSI low
> level drivers (LLDs); it adds several more finely tuned reset options
> to the user space. For example:
>=20
>   /* This call remains the same, with the same escalating semantics
>    * if the device (LU) reset fail. That is: on failure to try a
>    * target reset and if that fails, try a bus reset, and if that fai=
ls
>    * try a host (i.e. LLD) reset. */
>   val =3D SG_SCSI_RESET_DEVICE;
>   res =3D ioctl(<sg_or_block_fd>, SG_SCSI_RESET, &val);
>=20
>   /* What follows is a new option introduced by this patch series. On=
ly
>    * a device reset is attempted. If that fails then an appropriate
>    * error code is provided. N.B. There is no reset escalation. */
>   val =3D SG_SCSI_RESET_DEVICE | SG_SCSI_RESET_NO_ESCALATE;
>   res =3D ioctl(<sg_or_block_fd>, SG_SCSI_RESET, &val);
>=20
> This patches applies to lk 3.17.0 and Christoph's drivers-for-3.18
> tree. The sg_reset utility has been extended to use this new option
> since sg3_utils-1.36 package which was released on 20130531.
>=20
> v3 of this patch changes adding, subtracting and arithmetic
> comparisons to the corresponding bitwise logical operations.
> For example 'SG_SCSI_RESET_DEVICE + SG_SCSI_RESET_NO_ESCALATE' has
> been changed to 'SG_SCSI_RESET_DEVICE | SG_SCSI_RESET_NO_ESCALATE'.
>=20
> ChangeLog:
>   - modify SG_SCSI_RESET ioctl so the SG_SCSI_RESET_NO_ESCALATE
>     value may be OR-ed to the existing values. If so the existing
>     device->target->bus->host escalation does not occur. The
>     SG_SCSI_RESET ioctl is modified in both the sg driver and
>     scsi_ioctl.c (so block devices can use it).
>   - modify scsi_reset_provider() in the scsi_error.c file in a
>     similar way to support this additional functionality.
>=20
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
