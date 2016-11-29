From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 3/3] hpsa: add 'ctlr_num' sysfs attribute
Date: Tue, 29 Nov 2016 02:03:36 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D193B0CCD11@avsrvexchmbx1.microsemi.net>
References: <1479454369-100281-1-git-send-email-hare@suse.de>
 <1479454369-100281-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0070.outbound.protection.outlook.com ([104.47.40.70]:56736
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753935AbcK2CEK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Nov 2016 21:04:10 -0500
In-Reply-To: <1479454369-100281-4-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Martin Wilck <martin.wilck@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, November 18, 2016 1:33 AM
> To: Martin K. Petersen
> Cc: Christoph Hellwig; James Bottomley; Don Brace; Martin Wilck; linux-
> scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
> Subject: [PATCH 3/3] hpsa: add 'ctlr_num' sysfs attribute
>=20
> EXTERNAL EMAIL
>=20
>=20
> Add a sysfs attribute 'ctlr_num' holding the current HPSA controller
> number. This is required to construct compability 'cciss' links.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hpsa.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 3d89f74..5834117 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -867,6 +867,16 @@ static ssize_t path_info_show(struct device *dev,
>         return output_len;
>  }
>=20
> +static ssize_t host_show_ctlr_num(struct device *dev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct ctlr_info *h;
> +       struct Scsi_Host *shost =3D class_to_shost(dev);
> +
> +       h =3D shost_to_hba(shost);
> +       return snprintf(buf, 20, "%d\n", h->ctlr);
> +}
> +
>  static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
>  static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
>  static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
> @@ -890,6 +900,8 @@ static DEVICE_ATTR(resettable, S_IRUGO,
>         host_show_resettable, NULL);
>  static DEVICE_ATTR(lockup_detected, S_IRUGO,
>         host_show_lockup_detected, NULL);
> +static DEVICE_ATTR(ctlr_num, S_IRUGO,
> +       host_show_ctlr_num, NULL);
>=20
>  static struct device_attribute *hpsa_sdev_attrs[] =3D {
>         &dev_attr_raid_level,
> @@ -910,6 +922,7 @@ static DEVICE_ATTR(lockup_detected, S_IRUGO,
>         &dev_attr_hp_ssd_smart_path_status,
>         &dev_attr_raid_offload_debug,
>         &dev_attr_lockup_detected,
> +       &dev_attr_ctlr_num,
>         NULL,
>  };
>=20
> --
> 1.8.5.6

Acked-by: Don Brace <don.brace@microsemi.com>

