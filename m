From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RESEND PATCH] SCSI: scsi_lib: fix scsi_io_completion's SG_IO
 error propagation
Date: Fri, 27 Jul 2012 15:29:46 +0200
Message-ID: <501297CA.2060704@suse.de>
References: <20120718230614.GC13570@redhat.com> <1343238411-18193-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab2G0N3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2012 09:29:51 -0400
In-Reply-To: <1343238411-18193-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Babu.Moger@netapp.com

On 07/25/2012 07:46 PM, Mike Snitzer wrote:
> The following v3.4-rc1 commit unmasked an existing bug in
> scsi_io_completion's SG_IO error handling:
> 47ac56d [SCSI] scsi_error: classify some ILLEGAL_REQUEST sense as a p=
ermanent TARGET_ERROR
>=20
> Given that certain ILLEGAL_REQUEST are now properly categorized as
> TARGET_ERROR the host_byte is being set (before host_byte wasn't ever
> set for these ILLEGAL_REQUEST).
>=20
> In scsi_io_completion, initialize req->errors with cmd->result _after=
_
> the SG_IO block that calls __scsi_error_from_host_byte (which may
> modify the host_byte).
>=20
> Before this fix:
>=20
>     cdb to send: 12 01 01 00 00 00
> ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=3D[12, 01, 01, 00, 00, 00=
],
>     mx_sb_len=3D32, iovec_count=3D0, dxfer_len=3D0, timeout=3D20000, =
flags=3D0,
>     status=3D02, masked_status=3D01, sb[19]=3D[70, 00, 05, 00, 00, 00=
, 00, 0b,
>     00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=3D0x10,
>     driver_status=3D0x8, resid=3D0, duration=3D0, info=3D0x1}) =3D 0
> SCSI Status: Check Condition
>=20
> Sense Information:
> sense buffer empty
>=20
> After:
>=20
>     cdb to send: 12 01 01 00 00 00
> ioctl(3, SG_IO, {'S', SG_DXFER_NONE, cmd[6]=3D[12, 01, 01, 00, 00, 00=
],
>     mx_sb_len=3D32, iovec_count=3D0, dxfer_len=3D0, timeout=3D20000, =
flags=3D0,
>     status=3D02, masked_status=3D01, sb[19]=3D[70, 00, 05, 00, 00, 00=
, 00, 0b,
>     00, 00, 00, 00, 24, 00, 00, 00, 00, 00, 00], host_status=3D0,
>     driver_status=3D0x8, resid=3D0, duration=3D0, info=3D0x1}) =3D 0
> SCSI Status: Check Condition
>=20
> Sense Information:
>  Fixed format, current;  Sense key: Illegal Request
>  Additional sense: Invalid field in cdb
>  Raw sense data (in hex):
>         70 00 05 00 00 00 00 0b  00 00 00 00 24 00 00 00
>         00 00 00
>=20
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Reported-by: Paolo Bonzini <pbonzini@redhat.com>
> Tested-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Babu Moger <babu.moger@netapp.com>
> Cc: stable@vger.kernel.org [v3.4+]

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes--
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
