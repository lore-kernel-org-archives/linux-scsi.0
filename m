From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] [SCSI] scsilun_to_int should ignore the highest 2 bits
Date: Thu, 06 Jun 2013 10:42:16 +0200
Message-ID: <51B04B68.8080001@suse.de>
References: <1370506691-22933-1-git-send-email-jvesely@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370506691-22933-1-git-send-email-jvesely@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Vesely <jvesely@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

On 06/06/2013 10:18 AM, Jan Vesely wrote:
> From: Jan Vesely <jvesely@redhat.com>
>=20
> The comment says the function does this but it does not.
> Reported luns change from weirdly high numbers (like 16640)
> to something saner (256), when using flat space addressing.
>=20
> CC: James Bottomley <JBottomley@Parallels.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Jan Vesely <jvesely@redhat.com>
> ---
>  drivers/scsi/scsi_scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 3e58b22..38dc093 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1244,7 +1244,7 @@ int scsilun_to_int(struct scsi_lun *scsilun)
> =20
>  	lun =3D 0;
>  	for (i =3D 0; i < sizeof(lun); i +=3D 2)
> -		lun =3D lun | (((scsilun->scsi_lun[i] << 8) |
> +		lun =3D lun | ((((scsilun->scsi_lun[i] & 0x3f) << 8) |
>  			      scsilun->scsi_lun[i + 1]) << (i * 8));
>  	return lun;
>  }
>=20
Bzzt. It's not that simple.

=46or SCSI-3 _all_ numbers are valid, and doesn't know of any
addressing scheme. It's only SPC-2 which introduced the addressing
scheme. So at the very least you should be checking the scsi
revision before attempting something like this.

But in general doing a sequential scan past 256 is criminally
dangerous. Any array / device attempting to is in most cases
misconfigured or does not have the correct BLIST flag set.

I know of some older Hitachi and EMC firmware which would pretend to
be SCSI-2, but supporting more than 256 LUNs per host.
Which, of course, it totally bonkers.

I'll be posting my 64-bit LUN patchset, that should fix this issue.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
