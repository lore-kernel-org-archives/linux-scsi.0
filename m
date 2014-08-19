From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH/RFC V2 07/16] scsi: support well known logical units
Date: Tue, 19 Aug 2014 12:22:51 -0500
Message-ID: <20140819172251.GA12892@infradead.org>
References: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
 <1408023067-26103-8-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408023067-26103-8-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 14, 2014 at 04:30:58PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
>=20
> REPORT LUNS command has "SELECT REPORT" field which controls what typ=
e of
> logical units to be reported by device server. According to UFS devic=
e
> standard, if this field is set to 0, REPORT LUNS would report only re=
port
> standard logical units. If it's set to 1 then it would report only we=
ll
> known logical unit and if it's set to 2 then device would report both
> standard and well known logical units.
> Some well-known logical units might not have scsi upper-layer drivers=
=2E In
> such cases, the runtime PM reference count increased during device
> enumeration will not be decreased, causing the parent device (host) t=
o
> always be on even during idle.
>=20
> This change allows the SCSI LLD (Low Level Driver) to choose which ty=
pe
> of logical units should be detected.
>=20
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 4a6e4ba..5a0e164 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -802,6 +802,14 @@ static int scsi_add_lun(struct scsi_device *sdev=
, unsigned char *inq_result,
>  	} else {
>  		sdev->type =3D (inq_result[0] & 0x1f);
>  		sdev->removable =3D (inq_result[1] & 0x80) >> 7;
> +
> +		/*
> +		 * some devices may respond with wrong type for
> +		 * well-known logical units. Force well-known type
> +		 * to enumerate them correctly.
> +		 */
> +		if (scsi_is_wlun(sdev->lun) && (sdev->type !=3D TYPE_WLUN))
> +			sdev->type =3D TYPE_WLUN;

no need to test for TYPE_WLUN here.

>  	switch (sdev->type) {
> @@ -817,6 +825,7 @@ static int scsi_add_lun(struct scsi_device *sdev,=
 unsigned char *inq_result,
>  	case TYPE_COMM:
>  	case TYPE_RAID:
>  	case TYPE_OSD:
> +	case TYPE_WLUN:
>  		sdev->writeable =3D 1;
>  		break;
>  	case TYPE_ROM:

This switch statements has been removed in 3.17-rc1, please rebase your
series on top of it.  While you're at it please make this patch, which
introduce=D1=95 core scsi changes first in the series.

> @@ -1412,6 +1421,13 @@ static int scsi_report_lun_scan(struct scsi_ta=
rget *starget, int bflags,
>  	 */
>  	memset(&scsi_cmd[1], 0, 5);
> =20
> +	if (shost->report_wlus)
> +		/*
> +		 * Set "SELECT REPORT" field to 0x2 which will make device to
> +		 * report well known logical units along with standard LUs.
> +		 */
> +		scsi_cmd[2] =3D 0x2;

So we're finally getting well known LUN support.  I think we should key=
 this
off the SBC compliance level and not have the drivers opt in.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 5f36788..ba9d0f0 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1060,6 +1060,13 @@ int scsi_sysfs_add_sdev(struct scsi_device *sd=
ev)
>  		}
>  	}
> =20
> +	/*
> +	 * put runtime pm reference for well-known logical units,
> +	 * drivers are expected to _get_* again during probe.
> +	 */
> +	if (scsi_is_wlun(sdev->lun))
> +		scsi_autopm_put_device(sdev);

Special casing the well known LUNs here seems wrong.  Shouldn't we do t=
his
for any devices that don't get a driver attached to them?
