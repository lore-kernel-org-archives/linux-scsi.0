From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2] scsi: storvsc: Add support for FC rport.
Date: Tue, 21 Mar 2017 18:10:21 +0000
Message-ID: <DM5PR03MB249001B5147401DE4829EC21A03D0@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <1489763861-18384-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489763861-18384-1-git-send-email-cavery@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Cathy Avery <cavery@redhat.com>, "hch@infradead.org" <hch@infradead.org>, Haiyang Zhang <haiyangz@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "stephen@networkplumber.org" <stephen@networkplumber.org>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Cathy Avery [mailto:cavery@redhat.com]
> Sent: Friday, March 17, 2017 8:18 AM
> To: KY Srinivasan <kys@microsoft.com>; hch@infradead.org; Haiyang Zhang
> <haiyangz@microsoft.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com
> Cc: stephen@networkplumber.org; dan.carpenter@oracle.com;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: [PATCH v2] scsi: storvsc: Add support for FC rport.
>=20
> Included in the current storvsc driver for Hyper-V is the ability
> to access luns on an FC fabric via a virtualized fiber channel
> adapter exposed by the Hyper-V host. The driver also attaches to
> the FC transport to allow host and port names to be published under
> /sys/class/fc_host/hostX. Current customer tools running on the VM
> require that these names be available in the well known standard
> location under fc_host/hostX.
>=20
> A problem arose when attaching to the FC transport. The scsi_scan
> code attempts to call fc_user_scan which has basically become a no-op
> due to the fact that the virtualized FC device does not expose rports.
> At this point you cannot refresh the scsi bus after mapping or unmapping
> luns on the SAN without a reboot of the VM.
>=20
> This patch stubs in an rport per fc_host in storvsc so that the
> requirement of a defined rport is now met within the fc_transport and
> echo "- - -" > /sys/class/scsi_host/hostX/scan now works.
>=20
> Signed-off-by: Cathy Avery <cavery@redhat.com>

Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
> Changes since v1:
> - Fix fc_rport_identifiers init [Stephen Hemminger]
> - Better error checking
> ---
>  drivers/scsi/storvsc_drv.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 638e5f4..37646d1 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -478,6 +478,9 @@ struct storvsc_device {
>  	 */
>  	u64 node_name;
>  	u64 port_name;
> +#if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> +	struct fc_rport *rport;
> +#endif
>  };
>=20
>  struct hv_host_device {
> @@ -1816,19 +1819,27 @@ static int storvsc_probe(struct hv_device
> *device,
>  		target =3D (device->dev_instance.b[5] << 8 |
>  			 device->dev_instance.b[4]);
>  		ret =3D scsi_add_device(host, 0, target, 0);
> -		if (ret) {
> -			scsi_remove_host(host);
> -			goto err_out2;
> -		}
> +		if (ret)
> +			goto err_out3;
>  	}
>  #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
>  	if (host->transportt =3D=3D fc_transport_template) {
> +		struct fc_rport_identifiers ids =3D {
> +			.roles =3D FC_PORT_ROLE_FCP_TARGET,
> +		};
> +
>  		fc_host_node_name(host) =3D stor_device->node_name;
>  		fc_host_port_name(host) =3D stor_device->port_name;
> +		stor_device->rport =3D fc_remote_port_add(host, 0, &ids);
> +		if (!stor_device->rport)
> +			goto err_out3;
>  	}
>  #endif
>  	return 0;
>=20
> +err_out3:
> +	scsi_remove_host(host);
> +
>  err_out2:
>  	/*
>  	 * Once we have connected with the host, we would need to
> @@ -1854,8 +1865,10 @@ static int storvsc_remove(struct hv_device *dev)
>  	struct Scsi_Host *host =3D stor_device->host;
>=20
>  #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
> -	if (host->transportt =3D=3D fc_transport_template)
> +	if (host->transportt =3D=3D fc_transport_template) {
> +		fc_remote_port_delete(stor_device->rport);
>  		fc_remove_host(host);
> +	}
>  #endif
>  	scsi_remove_host(host);
>  	storvsc_dev_remove(dev);
> --
> 2.5.0
