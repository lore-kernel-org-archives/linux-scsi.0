From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh: Use the correct module name when loading device
 handler
Date: Sat, 26 Sep 2015 03:21:36 +0200
Message-ID: <5605F320.1060905@suse.de>
References: <20150926001915.GD12540@fergus.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbbIZBWB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 21:22:01 -0400
In-Reply-To: <20150926001915.GD12540@fergus.ozlabs.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>

On 09/26/2015 02:19 AM, Paul Mackerras wrote:
> This fixes a bug in recent kernels which results in failure to boot
> on systems that have multipath SCSI disks.  I observed this failure
> on a POWER8 server where all the disks are multipath SCSI disks.
> The symptoms are several messages like this on the console:
>=20
> [    3.018700] device-mapper: table: 253:0: multipath: error attachin=
g hardware handler
> [    3.018828] device-mapper: ioctl: error adding target to table
>=20
> and the system does not find its disks, and therefore fails to boot.
>=20
> Bisection revealed that the bug was introduced in commit 566079c849cf=
,
> "dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath"=
=2E
> The specific reason for the failure is that where we previously loade=
d
> the "scsi_dh_alua" module, we are now trying to load the "alua" modul=
e,
> which doesn't exist.
>=20
> To fix this, we change the request_module call in scsi_dh_lookup()
> to prepend "scsi_dh_" to the name, just like the old code in
> drivers/md/dm-mpath.c:parse_hw_handler() used to do.
>=20
> Fixes: 566079c849cf
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
> ---
>  drivers/scsi/scsi_dh.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index edb044a..0a2168e 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -111,7 +111,7 @@ static struct scsi_device_handler *scsi_dh_lookup=
(const char *name)
> =20
>  	dh =3D __scsi_dh_lookup(name);
>  	if (!dh) {
> -		request_module(name);
> +		request_module("scsi_dh_%s", name);
>  		dh =3D __scsi_dh_lookup(name);
>  	}
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
