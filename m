From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: add in sas transport
Date: Wed, 30 Sep 2015 09:49:47 +0200
Message-ID: <560B941B.8000802@suse.de>
References: <20150929221748.6433.53593.stgit@brunhilda> <20150929222154.6433.60590.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43037 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbbI3Htt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Sep 2015 03:49:49 -0400
In-Reply-To: <20150929222154.6433.60590.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, linux-scsi@vger.kernel.org

On 09/30/2015 12:21 AM, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@pmcs.com>
>=20
> customers want lsscsi -t to show sas addresses when
> enumerating sas devices. The sas addresses are used
> mainly to light drive LEDs for location.
>=20
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c     |  704 +++++++++++++++++++++++++++++++++++++=
+++++-----
>  drivers/scsi/hpsa.h     |   37 ++
>  drivers/scsi/hpsa_cmd.h |   14 +
>  3 files changed, 677 insertions(+), 78 deletions(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 3b35de0..ae811a7 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -41,6 +41,7 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsi_eh.h>
> +#include <scsi/scsi_transport_sas.h>
>  #include <scsi/scsi_dbg.h>
>  #include <linux/cciss_ioctl.h>
>  #include <linux/string.h>
> @@ -205,6 +206,16 @@ static struct board_type products[] =3D {
>  	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
>  };
> =20
> +static struct scsi_transport_template *hpsa_sas_transport_template;
> +static int hpsa_add_sas_host(struct ctlr_info *h);
> +static void hpsa_delete_sas_host(struct ctlr_info *h);
> +static int hpsa_add_sas_device(struct hpsa_sas_node *hpsa_sas_node,
> +			struct hpsa_scsi_dev_t *device);
> +static void hpsa_remove_sas_device(struct hpsa_scsi_dev_t *device);
> +static struct hpsa_scsi_dev_t
> +	*hpsa_find_device_by_sas_rphy(struct ctlr_info *h,
> +		struct sas_rphy *rphy);
> +
>  #define SCSI_CMD_BUSY ((struct scsi_cmnd *)&hpsa_cmd_busy)
>  static const struct scsi_cmnd hpsa_cmd_busy;
>  #define SCSI_CMD_IDLE ((struct scsi_cmnd *)&hpsa_cmd_idle)
> @@ -275,6 +286,8 @@ static void hpsa_command_resubmit_worker(struct w=
ork_struct *work);
>  static u32 lockup_detected(struct ctlr_info *h);
>  static int detect_controller_lockup(struct ctlr_info *h);
>  static int is_ext_target(struct ctlr_info *h, struct hpsa_scsi_dev_t=
 *device);
> +static inline int hpsa_scsi_do_report_phys_luns(struct ctlr_info *h,
> +	struct ReportExtendedLUNdata *buf, int bufsize);
> =20
>  static inline struct ctlr_info *sdev_to_hba(struct scsi_device *sdev=
)
>  {
> @@ -617,6 +630,11 @@ static const char * const raid_label[] =3D { "0"=
, "4", "1(+0)", "5", "5+1", "6",
>  #define HPSA_RAID_ADM	6	/* also used for RAID 1+0 ADM */
>  #define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
> =20
> +static inline bool is_logical_device(struct hpsa_scsi_dev_t *device)
> +{
> +	return !device->physical_device;
> +}
> +
>  static ssize_t raid_level_show(struct device *dev,
>  	     struct device_attribute *attr, char *buf)
>  {
> @@ -637,7 +655,7 @@ static ssize_t raid_level_show(struct device *dev=
,
>  	}
> =20
>  	/* Is this even a logical drive? */
> -	if (!is_logical_dev_addr_mode(hdev->scsi3addr)) {
> +	if (!is_logical_device(hdev)) {
>  		spin_unlock_irqrestore(&h->lock, flags);
>  		l =3D snprintf(buf, PAGE_SIZE, "N/A\n");
>  		return l;
Can you make this a separate patch? It's not related to the
transport class modifications, and it would reduce the size of the
individual patches.

> @@ -771,8 +789,8 @@ static ssize_t path_info_show(struct device *dev,
>  				scsi_device_type(hdev->devtype));
> =20
>  		if (is_ext_target(h, hdev) ||
> -			(hdev->devtype =3D=3D TYPE_RAID) ||
> -			is_logical_dev_addr_mode(hdev->scsi3addr)) {
> +			hdev->devtype =3D=3D TYPE_RAID ||
> +			is_logical_device(hdev)) {
>  			output_len +=3D snprintf(path[i] + output_len,
>  						PATH_STRING_LEN, "%s\n",
>  						active);
> @@ -791,8 +809,7 @@ static ssize_t path_info_show(struct device *dev,
>  				PATH_STRING_LEN,
>  				"PORT: %.2s ",
>  				phys_connector);
> -		if (hdev->devtype =3D=3D TYPE_DISK &&
> -			hdev->expose_state !=3D HPSA_DO_NOT_EXPOSE) {
> +		if (hdev->devtype =3D=3D TYPE_DISK && hdev->expose_device) {
>  			if (box =3D=3D 0 || box =3D=3D 0xFF) {
>  				output_len +=3D snprintf(path[i] + output_len,
>  					PATH_STRING_LEN,
> @@ -1148,7 +1165,7 @@ static inline void hpsa_show_dev_msg(const char=
 *level, struct ctlr_info *h,
>  				"RAID-?" : raid_label[dev->raid_level],
>  			dev->offload_config ? '+' : '-',
>  			dev->offload_enabled ? '+' : '-',
> -			dev->expose_state);
> +			dev->expose_device);
>  }
> =20
>  /* Add an entry into h->dev[] array. */
> @@ -1221,7 +1238,7 @@ lun_assigned:
>  	added[*nadded] =3D device;
>  	(*nadded)++;
>  	hpsa_show_dev_msg(KERN_INFO, h, device,
> -		device->expose_state & HPSA_SCSI_ADD ? "added" : "masked");
> +		device->expose_device ? "added" : "masked");
>  	device->offload_to_be_enabled =3D device->offload_enabled;
>  	device->offload_enabled =3D 0;
>  	return 0;
Same goes for the move from 'expose_state' to 'expose_device'.

> @@ -1579,7 +1596,7 @@ static void hpsa_figure_phys_disk_ptrs(struct c=
tlr_info *h,
>  		for (j =3D 0; j < ndevices; j++) {
>  			if (dev[j]->devtype !=3D TYPE_DISK)
>  				continue;
> -			if (is_logical_dev_addr_mode(dev[j]->scsi3addr))
> +			if (is_logical_device(dev[j]))
>  				continue;
>  			if (dev[j]->ioaccel_handle !=3D dd[i].ioaccel_handle)
>  				continue;
> @@ -1622,7 +1639,7 @@ static void hpsa_update_log_drive_phys_drive_pt=
rs(struct ctlr_info *h,
>  	for (i =3D 0; i < ndevices; i++) {
>  		if (dev[i]->devtype !=3D TYPE_DISK)
>  			continue;
> -		if (!is_logical_dev_addr_mode(dev[i]->scsi3addr))
> +		if (!is_logical_device(dev[i]))
>  			continue;
> =20
>  		/*
> @@ -1638,6 +1655,45 @@ static void hpsa_update_log_drive_phys_drive_p=
trs(struct ctlr_info *h,
>  	}
>  }
> =20
> +static int hpsa_add_device(struct ctlr_info *h, struct hpsa_scsi_dev=
_t *device)
> +{
> +	int rc;
> +
> +	if (is_logical_device(device))
> +		rc =3D scsi_add_device(h->scsi_host, device->bus,
> +			device->target, device->lun);
> +	else
> +		rc =3D hpsa_add_sas_device(h->sas_host, device);
> +
> +	return rc;
> +}
> +
> +static void hpsa_remove_device(struct ctlr_info *h,
> +			struct hpsa_scsi_dev_t *device)
> +{
> +	if (is_logical_device(device)) {
> +		struct scsi_device *sdev =3D
> +			scsi_device_lookup(h->scsi_host, device->bus,
> +				device->target, device->lun);
> +		if (sdev) {
> +			scsi_remove_device(sdev);
> +			scsi_device_put(sdev);
> +		} else {
> +			/*
> +			 * We don't expect to get here.  Future commands
> +			 * to this device will get a selection timeout as
> +			 * if the device were gone.
> +			 */
> +			dev_warn(&h->pdev->dev,
> +				"didn't find scsi %d:%d:%d:%d for removal.",
> +				h->scsi_host->host_no, device->bus,
> +				device->target, device->lun);
> +		}
> +	} else {
> +		hpsa_remove_sas_device(device);
> +	}
> +}
> +
>  static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>  	struct hpsa_scsi_dev_t *sd[], int nsds)
>  {
> @@ -1650,14 +1706,13 @@ static void adjust_hpsa_scsi_table(struct ctl=
r_info *h, int hostno,
>  	unsigned long flags;
>  	struct hpsa_scsi_dev_t **added, **removed;
>  	int nadded, nremoved;
> -	struct Scsi_Host *sh =3D NULL;
> =20
>  	added =3D kzalloc(sizeof(*added) * HPSA_MAX_DEVICES, GFP_KERNEL);
>  	removed =3D kzalloc(sizeof(*removed) * HPSA_MAX_DEVICES, GFP_KERNEL=
);
> =20
>  	if (!added || !removed) {
> -		dev_warn(&h->pdev->dev, "out of memory in "
> -			"adjust_hpsa_scsi_table\n");
> +		dev_warn(&h->pdev->dev, "out of memory in %s\n",
> +			__func__);
>  		goto free_and_out;
>  	}
> =20
> @@ -1758,36 +1813,19 @@ static void adjust_hpsa_scsi_table(struct ctl=
r_info *h, int hostno,
>  	if (hostno =3D=3D -1 || !changes)
>  		goto free_and_out;
> =20
> -	sh =3D h->scsi_host;
>  	/* Notify scsi mid layer of any removed devices */
>  	for (i =3D 0; i < nremoved; i++) {
> -		if (removed[i]->expose_state & HPSA_SCSI_ADD) {
> -			struct scsi_device *sdev =3D
> -				scsi_device_lookup(sh, removed[i]->bus,
> -					removed[i]->target, removed[i]->lun);
> -			if (sdev !=3D NULL) {
> -				scsi_remove_device(sdev);
> -				scsi_device_put(sdev);
> -			} else {
> -				/*
> -				 * We don't expect to get here.
> -				 * future cmds to this device will get selection
> -				 * timeout as if the device was gone.
> -				 */
> -				hpsa_show_dev_msg(KERN_WARNING, h, removed[i],
> -					"didn't find device for removal.");
> -			}
> -		}
> +		if (removed[i]->expose_device)
> +			hpsa_remove_device(h, removed[i]);
>  		kfree(removed[i]);
>  		removed[i] =3D NULL;
>  	}
> =20
>  	/* Notify scsi mid layer of any added devices */
>  	for (i =3D 0; i < nadded; i++) {
> -		if (!(added[i]->expose_state & HPSA_SCSI_ADD))
> +		if (!(added[i]->expose_device))
>  			continue;
> -		if (scsi_add_device(sh, added[i]->bus,
> -			added[i]->target, added[i]->lun) =3D=3D 0)
> +		if (hpsa_add_device(h, added[i]) =3D=3D 0)
>  			continue;
>  		hpsa_show_dev_msg(KERN_WARNING, h, added[i],
>  					"addition failed, device not added.");
Sigh. Here we go again.

I've probably asked you (or Mike Miller :-) about this several times
now, but couldn't you use the _real_ LUN addresses?

Especially as you're now exposing 'real' devices, where is the point
of creating an internal LUN mapping table?

If you were expose the devices with the actual LUN address (by eg
arranging the target/RAID controller on bus '0', the RAID devices on
bus '1', and the exposed devices on bus '2') you could remove the
internal LUN mapping table and quite some complexity would go away ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
