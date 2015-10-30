From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 04/25] hpsa: fix null device issues
Date: Fri, 30 Oct 2015 08:49:28 +0100
Message-ID: <56332108.3020907@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220453.5323.34762.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbbJ3Hta (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 03:49:30 -0400
In-Reply-To: <20151028220453.5323.34762.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:04 PM, Don Brace wrote:
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 6b6e9bb..3fe8a18 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1136,7 +1136,7 @@ static int hpsa_find_target_lun(struct ctlr_inf=
o *h,
>  	return !found;
>  }
> =20
> -static inline void hpsa_show_dev_msg(const char *level, struct ctlr_=
info *h,
> +static void hpsa_show_dev_msg(const char *level, struct ctlr_info *h=
,
>  	struct hpsa_scsi_dev_t *dev, char *description)
>  {
>  	if (dev =3D=3D NULL)
This is not a null device check; you modified the function.
Please put it into a separate function.

Or make a patch 'cleanup' or something.

> @@ -1423,6 +1423,9 @@ static int hpsa_scsi_find_entry(struct hpsa_scs=
i_dev_t *needle,
>  #define DEVICE_CHANGED 1
>  #define DEVICE_SAME 2
>  #define DEVICE_UPDATED 3
> +	if (needle =3D=3D NULL)
> +		return DEVICE_NOT_FOUND;
> +
>  	for (i =3D 0; i < haystack_size; i++) {
>  		if (haystack[i] =3D=3D NULL) /* previously removed. */
>  			continue;
> @@ -1574,6 +1577,9 @@ static void hpsa_figure_phys_disk_ptrs(struct c=
tlr_info *h,
>  				total_disks_per_row;
>  	int qdepth;
> =20
> +	if (logical_drive =3D=3D NULL)
> +		return;
> +
>  	if (nraid_map_entries > RAID_MAP_MAX_ENTRIES)
>  		nraid_map_entries =3D RAID_MAP_MAX_ENTRIES;
> =20
> @@ -1585,6 +1591,8 @@ static void hpsa_figure_phys_disk_ptrs(struct c=
tlr_info *h,
>  		if (!logical_drive->offload_config)
>  			continue;
>  		for (j =3D 0; j < ndevices; j++) {
> +			if (dev[j] =3D=3D NULL)
> +				continue;
>  			if (dev[j]->devtype !=3D TYPE_DISK)
>  				continue;
>  			if (is_logical_dev_addr_mode(dev[j]->scsi3addr))
> @@ -1628,6 +1636,8 @@ static void hpsa_update_log_drive_phys_drive_pt=
rs(struct ctlr_info *h,
>  	int i;
> =20
>  	for (i =3D 0; i < ndevices; i++) {
> +		if (dev[i] =3D=3D NULL)
> +			continue;
>  		if (dev[i]->devtype !=3D TYPE_DISK)
>  			continue;
>  		if (!is_logical_dev_addr_mode(dev[i]->scsi3addr))
> @@ -1743,8 +1753,11 @@ static void adjust_hpsa_scsi_table(struct ctlr=
_info *h, int hostno,
>  	/* Now that h->dev[]->phys_disk[] is coherent, we can enable
>  	 * any logical drives that need it enabled.
>  	 */
> -	for (i =3D 0; i < h->ndevices; i++)
> +	for (i =3D 0; i < h->ndevices; i++) {
> +		if (h->dev[i] =3D=3D NULL)
> +			continue;
>  		h->dev[i]->offload_enabled =3D h->dev[i]->offload_to_be_enabled;
> +	}
> =20
>  	spin_unlock_irqrestore(&h->devlock, flags);
> =20
> @@ -1769,6 +1782,8 @@ static void adjust_hpsa_scsi_table(struct ctlr_=
info *h, int hostno,
>  	sh =3D h->scsi_host;
>  	/* Notify scsi mid layer of any removed devices */
>  	for (i =3D 0; i < nremoved; i++) {
> +		if (removed[i] =3D=3D NULL)
> +			continue;
>  		if (removed[i]->expose_state & HPSA_SCSI_ADD) {
>  			struct scsi_device *sdev =3D
>  				scsi_device_lookup(sh, removed[i]->bus,
> @@ -1792,18 +1807,18 @@ static void adjust_hpsa_scsi_table(struct ctl=
r_info *h, int hostno,
> =20
>  	/* Notify scsi mid layer of any added devices */
>  	for (i =3D 0; i < nadded; i++) {
> +		if (added[i] =3D=3D NULL)
> +			continue;
>  		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
>  			continue;
>  		if (scsi_add_device(sh, added[i]->bus,
>  			added[i]->target, added[i]->lun) =3D=3D 0)
>  			continue;
> -		hpsa_show_dev_msg(KERN_WARNING, h, added[i],
> -					"addition failed, device not added.");
> +		dev_warn(&h->pdev->dev, "addition failed, device not added.");
>  		/* now we have to remove it from h->dev,
>  		 * since it didn't get added to scsi mid layer
>  		 */
>  		fixup_botched_add(h, added[i]);
> -		added[i] =3D NULL;
>  	}
> =20
>  free_and_out:
>=20
Again, modifying the logging message is not a null device check.
Please move it into another patch.

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
