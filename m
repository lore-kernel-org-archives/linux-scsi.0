From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2] scsi: ses: don't get power status of SES device slot
 on probe
Date: Wed, 5 Apr 2017 16:23:46 +0000
Message-ID: <D1CDB51B-F034-4476-A709-E13B4C9682F7@fb.com>
References: <1491405499-5429-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47831 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755449AbdDEQYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2017 12:24:08 -0400
In-Reply-To: <1491405499-5429-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Content-Language: en-US
Content-ID: <6AFBED30E2C4B2479E7D9BD46AB486A1@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@fb.com>, "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, "gpiccoli@linux.vnet.ibm.com" <gpiccoli@linux.vnet.ibm.com>


> On Apr 5, 2017, at 8:18 AM, Mauricio Faria de Oliveira <mauricfo@linux.vn=
et.ibm.com> wrote:
>=20
> The commit 08024885a2a3 ("ses: Add power_status to SES device slot")
> introduced the 'power_status' attribute to enclosure components and
> the associated callbacks.
>=20
> There are 2 callbacks available to get the power status of a device:
> 1) ses_get_power_status() for 'struct enclosure_component_callbacks'
> 2) get_component_power_status() for the sysfs device attribute
> (these are available for kernel-space and user-space, respectively.)
>=20
> However, despite both methods being available to get power status
> on demand, that commit also introduced a call to get power status
> in ses_enclosure_data_process().
>=20
> This dramatically increased the total probe time for SCSI devices
> on larger configurations, because ses_enclosure_data_process() is
> called several times during the SCSI devices probe and loops over
> the component devices (but that is another problem, another patch).
>=20
> That results in a tremendous continuous hammering of SCSI Receive
> Diagnostics commands to the enclosure-services device, which does
> delay the total probe time for the SCSI devices __significantly__:
>=20
>  Originally, ~34 minutes on a system attached to ~170 disks:
>=20
>    [ 9214.490703] mpt3sas version 13.100.00.00 loaded
>    ...
>    [11256.580231] scsi 17:0:177:0: qdepth(16), tagged(1), simple(0),
>                   ordered(0), scsi_level(6), cmd_que(1)
>=20
>  With this patch, it decreased to ~2.5 minutes -- a 13.6x faster
>=20
>    [ 1002.992533] mpt3sas version 13.100.00.00 loaded
>    ...
>    [ 1151.978831] scsi 11:0:177:0: qdepth(16), tagged(1), simple(0),
>                   ordered(0), scsi_level(6), cmd_que(1)
>=20
> Back to the commit discussion.. on the ses_get_power_status() call
> introduced in ses_enclosure_data_process(): impact of removing it.
>=20
> That may possibly be in place to initialize the power status value
> on device probe.  However, those 2 functions available to retrieve
> that value _do_ automatically refresh/update it.  So the potential
> benefit would be a direct access of the 'power_status' field which
> does not use the callbacks...
>=20
> But the only reader of 'struct enclosure_component::power_status'
> is the get_component_power_status() callback for sysfs attribute,
> and it _does_ check for and call the .get_power_status callback,
> (which indeed is defined and implemented by that commit), so the
> power status value is, again, automatically updated.
>=20
> So, the remaining potential for a direct/non-callback access to
> the power_status attribute would be out-of-tree modules -- well,
> for those, if they are for whatever reason interested in values
> that are set during device probe and not up-to-date by the time
> they need it.. well, that would be curious.
>=20
> Well, to handle that more properly, set the initial power state
> value to '-1' (i.e., uninitialized) instead of '1' (power 'on'),
> and check for it in that callback which may do an direct access
> to the field value _if_ a callback function is not defined.
>=20
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> Fixes: 08024885a2a3 ("ses: Add power_status to SES device slot")
> ---
>=20
> v2:
> - remove module parameter.
> - better return values for -1/uninitalized power_status.
>   (thanks: Dan Williams <dan.j.williams@intel.com>)
>=20
> drivers/misc/enclosure.c | 7 ++++++-
> drivers/scsi/ses.c       | 1 -
> 2 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 65fed7146e9b..d3fe3ea902d4 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -148,7 +148,7 @@ struct enclosure_device *
> 	for (i =3D 0; i < components; i++) {
> 		edev->component[i].number =3D -1;
> 		edev->component[i].slot =3D -1;
> -		edev->component[i].power_status =3D 1;
> +		edev->component[i].power_status =3D -1;
> 	}
>=20
> 	mutex_lock(&container_list_lock);
> @@ -594,6 +594,11 @@ static ssize_t get_component_power_status(struct dev=
ice *cdev,
>=20
> 	if (edev->cb->get_power_status)
> 		edev->cb->get_power_status(edev, ecomp);
> +
> +	/* If still uninitialized, the callback failed or does not exist. */
> +	if (ecomp->power_status =3D=3D -1)
> +		return (edev->cb->get_power_status) ? -EIO : -ENOTTY;
> +
> 	return snprintf(buf, 40, "%s\n", ecomp->power_status ? "on" : "off");
> }
>=20
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 50adabbb5808..f1cdf32d7514 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -548,7 +548,6 @@ static void ses_enclosure_data_process(struct enclosu=
re_device *edev,
> 					ecomp =3D &edev->component[components++];
>=20
> 				if (!IS_ERR(ecomp)) {
> -					ses_get_power_status(edev, ecomp);
> 					if (addl_desc_ptr)
> 						ses_process_descriptor(
> 							ecomp,
> --=20
> 1.8.3.1
>=20

Reviewed-by: Song Liu <songliubraving@fb.com>
