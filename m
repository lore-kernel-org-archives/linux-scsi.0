From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib_dma.c : fix bug w/ dma maps on virtual fc
	ports
Date: Tue, 07 Oct 2008 08:53:49 -0500
Message-ID: <1223387629.3254.6.camel@localhost.localdomain>
References: <1223386518.3082.9.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55451 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbYJGNyW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 09:54:22 -0400
In-Reply-To: <1223386518.3082.9.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-10-07 at 09:35 -0400, James Smart wrote:
> =EF=BB=BFWhen the updated scsi dma code was introduced recently, it a=
ssumed the
> physical host/adapter was the parent of the scsi host. Unfortunately,
> on FC virtual ports, the parent of the scsi host is the virtual port,
> which does not have dma information.

Hmm, so now we have nested hosts; I'd missed that piece; we might be in
trouble in other places than just here.

> I have updated the dma map routines to use a function that finds the
> top-most scsi host, then use the parent of that host.  This is a bit
> ugly as every dma request does this walking, to the top of the object
> tree.
>=20
> A different option that was considered was taking the parent dev, the=
n
> walking the dev list backward to find the first device with a dma mas=
k,
> then using that device.
>   Eg:   while (!dev->dma_mask)  dev=3Ddev->parent;
>=20
> If there is a better solution, please let me know.

I think there is: just do what you want.  i.e. an accessor that finds
the parent bus device.  So you walk up the tree and continue walking if
either the type is NULL or the type is SCSI ... that way the first thin=
g
you come across should be the physical bus attached device.  Call it
something like to_non_scsi_dev().

> -- james s
>=20
>=20
>  Signed-off-by: James Smart <james.smart@emulex.com>
>=20
>  ---
>=20
>  drivers/scsi/scsi_lib_dma.c |   13 +++++++++----
>  include/scsi/scsi_host.h    |   21 +++++++++++++++++++++
>  2 files changed, 30 insertions(+), 4 deletions(-)
>=20
>=20
> diff -upNr a/drivers/scsi/scsi_lib_dma.c b2/drivers/scsi/scsi_lib_dma=
=2Ec
> --- a/drivers/scsi/scsi_lib_dma.c	2008-09-23 15:12:13.000000000 -0400
> +++ b2/drivers/scsi/scsi_lib_dma.c	2008-10-03 12:19:39.000000000 -040=
0
> @@ -23,9 +23,11 @@ int scsi_dma_map(struct scsi_cmnd *cmd)
>  	int nseg =3D 0;
> =20
>  	if (scsi_sg_count(cmd)) {
> -		struct device *dev =3D cmd->device->host->shost_gendev.parent;
> +		struct Scsi_Host *shost;

You have a bit of a penchant for code churn here.  What's wrong with

struct device *dev =3D dev_to_phys_shost(&cmd->device->sdev_gendev)->sh=
ost_gendev.parent;

?

Then none of the code below needs changing.

or if you use to_non_scsi_dev() it's even simpler:

struct device *dev =3D to_non_scsi_dev(&cmd->device->sdev_gendev);

> -		nseg =3D dma_map_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
> +		shost =3D dev_to_phys_shost(&cmd->device->sdev_gendev);
> +		nseg =3D dma_map_sg(shost->shost_gendev.parent,
> +				  scsi_sglist(cmd), scsi_sg_count(cmd),
>  				  cmd->sc_data_direction);
>  		if (unlikely(!nseg))
>  			return -ENOMEM;
> @@ -41,10 +43,13 @@ EXPORT_SYMBOL(scsi_dma_map);
>  void scsi_dma_unmap(struct scsi_cmnd *cmd)
>  {
>  	if (scsi_sg_count(cmd)) {
> -		struct device *dev =3D cmd->device->host->shost_gendev.parent;
> +		struct Scsi_Host *shost;
> =20
> -		dma_unmap_sg(dev, scsi_sglist(cmd), scsi_sg_count(cmd),
> +		shost =3D dev_to_phys_shost(&cmd->device->sdev_gendev);
> +		dma_unmap_sg(shost->shost_gendev.parent,
> +			     scsi_sglist(cmd), scsi_sg_count(cmd),
>  			     cmd->sc_data_direction);
>  	}
>  }
>  EXPORT_SYMBOL(scsi_dma_unmap);
> +
> diff -upNr a/include/scsi/scsi_host.h b2/include/scsi/scsi_host.h
> --- a/include/scsi/scsi_host.h	2008-09-23 15:12:20.000000000 -0400
> +++ b2/include/scsi/scsi_host.h	2008-10-03 12:16:46.000000000 -0400
> @@ -696,6 +696,10 @@ static inline void *shost_priv(struct Sc
> =20
>  int scsi_is_host_device(const struct device *);
> =20
> +/*
> + * walks object list backward, to find the first shost object.
> + * Skips over transport objects that may not be stargets, etc
> + */
>  static inline struct Scsi_Host *dev_to_shost(struct device *dev)
>  {
>  	while (!scsi_is_host_device(dev)) {
> @@ -706,6 +710,23 @@ static inline struct Scsi_Host *dev_to_s
>  	return container_of(dev, struct Scsi_Host, shost_gendev);
>  }
> =20
> +/*
> + * walks object list backward, to find the top-most shost object.
> + * Skips over transport objects that may be vports, shosts under
> vports, etc=20
> + */
> +static inline struct Scsi_Host *dev_to_phys_shost(struct device *dev=
)
> +{
> +	struct Scsi_Host *shost_new =3D dev_to_shost(dev);
> +	struct Scsi_Host *shost =3D shost_new;
> +
> +	while (shost_new) {
> +		shost_new =3D dev_to_shost(shost->shost_gendev.parent);
> +		if (shost_new)
> +			shost =3D shost_new;
> +	}
> +	return shost;
> +}
> +
>  static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
>  {
>  	return shost->shost_state =3D=3D SHOST_RECOVERY ||

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
