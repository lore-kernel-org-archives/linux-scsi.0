From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Open-FCoE] [PATCH] scsi_transport_fc: Add sysfs entry for HBA
 API management library
Date: Thu, 04 Oct 2012 09:08:46 +0200
Message-ID: <506D35FE.10202@suse.de>
References: <20121003201237.28626.15887.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab2JDHIt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Oct 2012 03:08:49 -0400
In-Reply-To: <20121003201237.28626.15887.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, devel@open-fcoe.org

On 10/03/2012 10:12 PM, Robert Love wrote:
> The user space HBA API vendor libraries need to know which HBA/CNAs
> hosts to manage. Currently, libhbalinux is used to manage a few drive=
rs
> that use libfcoe and libfc. Right now libhbalinux keys off of the
> string " over " in the FC Host's symbolic_name attribute to determine
> if it should manage a given host. fnic, bnx2fc and fcoe/netdev based
> hosts all use " over " in their symboic_names and that is currently
> what libhbalinux looks for to determine if it should manage hosts
> created by those drivers.
>
> Clearly using " over " in the symbolic_name isn't descriptive
> and it is an awkward way to determine whether libhbalinux should
> manage a host. Also, drivers may wish to use more descriptive
> and accurate symbolic_names because these strings are displayed
> in fabric management applications; forcing them to use " over "
> in their symbolic_name is unnecessarily restrictive.
>
> This patch adds a read-only attribute to the FC Host that will expose
> which management library should be used to manage it.
>
> This attribute will not be present in sysfs for drivers that
> do no implement the .show_hbaapi_lib routine.
>
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> Tested-by: Ross Brattain <ross.b.brattain@intel.com>
> ---
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++++
>   drivers/scsi/fcoe/fcoe.c          |    4 ++++
>   drivers/scsi/fnic/fnic_main.c     |    4 ++++
>   drivers/scsi/scsi_transport_fc.c  |    5 ++++-
>   include/scsi/libfc.h              |    2 ++
>   include/scsi/scsi_transport_fc.h  |    4 ++++
>   6 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/=
bnx2fc_fcoe.c
> index ae1cb76..97f60d8 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -731,6 +731,9 @@ static int bnx2fc_shost_config(struct fc_lport *l=
port, struct device *dev)
>   		BNX2FC_NAME, BNX2FC_VERSION,
>   		interface->netdev->name);
>
> +	strncpy(fc_host_hbaapi_library(lport->host), FC_LIBHBALINUX_NAME,
> +		FC_SYMBOLIC_NAME_SIZE);
> +
>   	return 0;
>   }
>
> @@ -2583,6 +2586,7 @@ static struct fc_function_template bnx2fc_trans=
port_function =3D {
>   	.get_host_port_state =3D fc_get_host_port_state,
>   	.show_host_port_state =3D 1,
>   	.show_host_symbolic_name =3D 1,
> +	.show_host_hbaapi_library =3D 1,
>
>   	.dd_fcrport_size =3D (sizeof(struct fc_rport_libfc_priv) +
>   				sizeof(struct bnx2fc_rport)),
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 078d262..812876f 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -201,6 +201,7 @@ static struct fc_function_template fcoe_nport_fc_=
functions =3D {
>   	.get_host_port_state =3D fc_get_host_port_state,
>   	.show_host_port_state =3D 1,
>   	.show_host_symbolic_name =3D 1,
> +	.show_host_hbaapi_library =3D 1,
>
>   	.dd_fcrport_size =3D sizeof(struct fc_rport_libfc_priv),
>   	.show_rport_maxframe_size =3D 1,
> @@ -755,6 +756,9 @@ static int fcoe_shost_config(struct fc_lport *lpo=
rt, struct device *dev)
>   		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
>   		 fcoe_netdev(lport)->name);
>
> +	strncpy(fc_host_hbaapi_library(lport->host), FC_LIBHBALINUX_NAME,
> +		FC_SYMBOLIC_NAME_SIZE);
> +
>   	return 0;
>   }
>
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_m=
ain.c
> index fc98eb6..783bd3d 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -138,6 +138,7 @@ static struct fc_function_template fnic_fc_functi=
ons =3D {
>   	.get_host_port_state =3D fc_get_host_port_state,
>   	.show_host_port_state =3D 1,
>   	.show_host_symbolic_name =3D 1,
> +	.show_host_hbaapi_library =3D 1,
>   	.show_rport_maxframe_size =3D 1,
>   	.show_rport_supported_classes =3D 1,
>   	.show_host_fabric_name =3D 1,
> @@ -704,6 +705,9 @@ static int __devinit fnic_probe(struct pci_dev *p=
dev,
>   	sprintf(fc_host_symbolic_name(lp->host),
>   		DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
>
> +	strncpy(fc_host_hbaapi_library(lp->host), FC_LIBHBALINUX_NAME,
> +		FC_SYMBOLIC_NAME_SIZE);
> +
>   	spin_lock_irqsave(&fnic_list_lock, flags);
>   	list_add_tail(&fnic->list, &fnic_list);
>   	spin_unlock_irqrestore(&fnic_list_lock, flags);
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_tra=
nsport_fc.c
> index e894ca7..ed19b42 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -313,7 +313,7 @@ static void fc_scsi_scan_rport(struct work_struct=
 *work);
>   #define FC_STARGET_NUM_ATTRS 	3
>   #define FC_RPORT_NUM_ATTRS	10
>   #define FC_VPORT_NUM_ATTRS	9
> -#define FC_HOST_NUM_ATTRS	29
> +#define FC_HOST_NUM_ATTRS	30
>
>   struct fc_internal {
>   	struct scsi_transport_template t;
> @@ -422,6 +422,7 @@ static int fc_host_setup(struct transport_contain=
er *tc, struct device *dev,
>   	fc_host->speed =3D FC_PORTSPEED_UNKNOWN;
>   	fc_host->fabric_name =3D -1;
>   	memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
> +	memset(fc_host->hbaapi_library, 0, sizeof(fc_host->hbaapi_library))=
;
>   	memset(fc_host->system_hostname, 0, sizeof(fc_host->system_hostnam=
e));
>
>   	fc_host->tgtid_bind_type =3D FC_TGTID_BIND_BY_WWPN;
> @@ -1529,6 +1530,7 @@ fc_private_host_rd_attr(max_npiv_vports, "%u\n"=
, 20);
>   fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SI=
ZE +1));
>   fc_private_host_rd_attr(manufacturer, "%s\n", FC_SERIAL_NUMBER_SIZE=
 + 1);
>   fc_private_host_rd_attr(model, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
> +fc_private_host_rd_attr(hbaapi_library, "%s\n", FC_SYMBOLIC_NAME_SIZ=
E + 1);
>   fc_private_host_rd_attr(model_description, "%s\n", FC_SYMBOLIC_NAME=
_SIZE + 1);
>   fc_private_host_rd_attr(hardware_version, "%s\n", FC_VERSION_STRING=
_SIZE + 1);
>   fc_private_host_rd_attr(driver_version, "%s\n", FC_VERSION_STRING_S=
IZE + 1);
> @@ -2262,6 +2264,7 @@ fc_attach_transport(struct fc_function_template=
 *ft)
>   	SETUP_HOST_ATTRIBUTE_RD(speed);
>   	SETUP_HOST_ATTRIBUTE_RD(fabric_name);
>   	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
> +	SETUP_HOST_ATTRIBUTE_RD(hbaapi_library);
>   	SETUP_HOST_ATTRIBUTE_RW(system_hostname);
>
>   	/* Transport-managed attributes */
> diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
> index 399162b..89630cf 100644
> --- a/include/scsi/libfc.h
> +++ b/include/scsi/libfc.h
> @@ -36,6 +36,8 @@
>
>   #include <scsi/fc_frame.h>
>
> +#define FC_LIBHBALINUX_NAME "libhbalinux"
> +
>   #define	FC_FC4_PROV_SIZE	(FC_TYPE_FCP + 1)	/* size of tables */
>
>   /*
Bah.

You can't be serious.
I totally agree that matching on 'over' is ridiculous.
But hard-coding 'libhbalinux' is also a bad move, simply for the=20
fact that libhbalinux is a user-space library and no-one knows how=20
long it'll stay around. Or if some vendor would like it to be=20
renamed for whatever reason.

No, please. I would rather define a libfc version, and having this=20
one displayed fc host attributes.
This way userspace could identify
a) if libfc is used
b) which libfc _version_ is used
and libbhalinux could match onto those.

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
