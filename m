From: berthiaume_wayne@emc.com
Subject: RE: Re: [PATCH] Fixes to EMC scsi device handler
Date: Thu, 8 May 2008 18:43:44 -0400
Message-ID: <218DC19ED27F8842B837598EC6D59D0E0145150E@CORPUSMX40A.corp.emc.com>
References: <481EF5AA.7090304@suse.de>
	<1210037658.21974.125.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1210037658.21974.125.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, dm-devel@redhat.com, hare@suse.de
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

FYI: The VRAID type is for the CLARiiON implementation of RAID6.=20

Regards,
Wayne.

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Chandra Seetharaman
Sent: Monday, May 05, 2008 9:34 PM
To: Hannes Reinecke
Cc: James Bottomley; dm-devel; SCSI Mailing List
Subject: [dm-devel] Re: [PATCH] Fixes to EMC scsi device handler


On Mon, 2008-05-05 at 13:55 +0200, Hannes Reinecke wrote:
> Hi Chandra,
>=20
> based on your latest patchset there are some issues which
> should be fixed:
>=20
> - When SYSFS_DEPRECATED is not set also scsi_target and
>   scsi_host devices will be attached to the scsi bus.
>   So we have to check with 'scsi_is_sdev_device' before
>   processing the notifier call

This need to be done for all the handlers, right ?
> =20
> - Newer EMC flarecode also provide for a 'VRAID' device
>   model; this should be added to the device map
> - The name should be 'emc', not 'emc_clariion', for
>   integration with existing multipath-tools
> - It's spelled 'detached' :-)
>=20
> Patch attached.

Looks good to me.
>=20
> Some issues which I'd like to see eventually:
>=20
> - We should have a way of adding/modifying the internal
>   device map. Currently we have to recompile the module
>   every time a new device definition is found.

Yeah, very true. it will become an annoyance. Is this the reason why
you were asking for the sysfs interface (below) ?

> - The ->activate function should be able to be triggered
>   manually via sysfs.

Why would you need this ?=20
>=20
> James, seeing that the scsi_dh pointer is already present
> in the sdev structure, would you accept a patch which adds
> scsi_dh attributes to drivers/scsi/scsi_sysfs.c?
> Having them encapsulated into drivers/scsi/device_handler
> somewhere is really painful due to the asynchronous nature
> of this whole thing ...
>=20
> Apart from this: Great work!
> I'll check the other device handlers, too; already noticed
> that the device map for HP is wrong :-)

Can you please help fix it.=20
>=20
> Cheers,
>=20
> hannes
> plain text document attachment (scsi-dh-emc-fixes)
> Fixes to EMC scsi device handler
>=20
> Several fixes to the EMC scsi device handler:
> - The name should be 'emc' for seamless integration with multipathing
> - Newer EMC flarecode also has a 'VRAID' type
> - Check if this is really a sdev before processing the notifier call
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c
b/drivers/scsi/device_handler/scsi_dh_emc.c
> index 1b18989..0aded96 100644
> --- a/drivers/scsi/device_handler/scsi_dh_emc.c
> +++ b/drivers/scsi/device_handler/scsi_dh_emc.c
> @@ -25,7 +25,7 @@
>  #include <scsi/scsi_dh.h>
>  #include <scsi/scsi_device.h>
>=20
> -#define CLARIION_NAME			"emc_clariion"
> +#define CLARIION_NAME			"emc"
>=20
>  #define CLARIION_TRESPASS_PAGE		0x22
>  #define CLARIION_BUFFER_SIZE		0x80
> @@ -390,12 +390,13 @@ static int clariion_check_sense(struct
scsi_device *sdev,
>  	return SUCCESS;
>  }
>=20
> -static const struct {
> +static const struct clariion_dev_list_t {
>  	char *vendor;
>  	char *model;
>  } clariion_dev_list[] =3D {
>  	{"DGC", "RAID"},
>  	{"DGC", "DISK"},
> +	{"DGC", "VRAID"},
>  	{NULL, NULL},
>  };
>=20
> @@ -422,6 +423,9 @@ static int clariion_bus_notify(struct
notifier_block *nb,
>  	int i, found =3D 0;
>  	unsigned long flags;
>=20
> +	if (!scsi_is_sdev_device(dev))
> +		return 0;
> +
>  	if (action =3D=3D BUS_NOTIFY_ADD_DEVICE) {
>  		for (i =3D 0; clariion_dev_list[i].vendor; i++) {
>  			if (!strncmp(sdev->vendor,
clariion_dev_list[i].vendor,
> @@ -465,7 +469,7 @@ static int clariion_bus_notify(struct
notifier_block *nb,
>  		sdev->scsi_dh_data =3D NULL;
>  		spin_unlock_irqrestore(sdev->request_queue->queue_lock,
flags);
>=20
> -		sdev_printk(KERN_NOTICE, sdev, "Dettached %s.\n",
> +		sdev_printk(KERN_NOTICE, sdev, "Detached %s.\n",
>  			    CLARIION_NAME);
>=20
>  		kfree(scsi_dh_data);

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
