From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Mon, 02 Mar 2015 14:35:36 +0100
Message-ID: <54F46728.3070908@suse.de>
References: <1423586616-18177-1-git-send-email-nmusini@cisco.com> <1423586616-18177-10-git-send-email-nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbbCBNfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2015 08:35:38 -0500
In-Reply-To: <1423586616-18177-10-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

On 02/10/2015 05:43 PM, Narsimhulu Musini wrote:
> Kconfig for kbuild
> Makefile to build snic module
>=20
> Updated MAINTAINERS file
>=20
> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
> ---
>  MAINTAINERS                |  7 +++++++
>  drivers/scsi/Kconfig       | 10 ++++++++++
>  drivers/scsi/Makefile      |  1 +
>  drivers/scsi/snic/Makefile | 17 +++++++++++++++++
>  4 files changed, 35 insertions(+)
>  create mode 100644 drivers/scsi/snic/Makefile
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2a97e05..368fb76 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2536,6 +2536,13 @@ L:	linux-scsi@vger.kernel.org
>  S:	Supported
>  F:	drivers/scsi/fnic/
> =20
> +CISCO SCSI HBA DRIVER
> +M:	Narsimhulu Musini <nmusini@cisco.com>
> +M:	Sesidhar Baddela <sebaddel@cisco.com>
> +L:	linux-scsi@vger.kernel.org
> +S:	Supported
> +F:	drivers/scsi/snic/
> +
>  CMPC ACPI DRIVER
>  M:	Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>  M:	Daniel Oliveira Nascimento <don@syst.com.br>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 9c92f41..7e9d80a 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -634,6 +634,16 @@ config FCOE_FNIC
>  	  <file:Documentation/scsi/scsi.txt>.
>  	  The module will be called fnic.
> =20
> +config SCSI_SNIC
> +	tristate "Cisco SNIC Driver"
> +	depends on PCI && SCSI && X86
> +	help
> +	  This is support for the Cisco PCI-Express SCSI HBA.
> +
> +	  To compile this driver as a module, choose M here and read
> +	  <file:Documentation/scsi/scsi.txt>.
> +	  The module will be called snic.
> +
>  config SCSI_DMX3191D
>  	tristate "DMX3191D SCSI support"
>  	depends on PCI && SCSI
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 58158f1..f643942 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -39,6 +39,7 @@ obj-$(CONFIG_LIBFC)		+=3D libfc/
>  obj-$(CONFIG_LIBFCOE)		+=3D fcoe/
>  obj-$(CONFIG_FCOE)		+=3D fcoe/
>  obj-$(CONFIG_FCOE_FNIC)		+=3D fnic/
> +obj-$(CONFIG_SCSI_SNIC)		+=3D snic/
>  obj-$(CONFIG_SCSI_BNX2X_FCOE)	+=3D libfc/ fcoe/ bnx2fc/
>  obj-$(CONFIG_ISCSI_TCP) 	+=3D libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
>  obj-$(CONFIG_INFINIBAND_ISER) 	+=3D libiscsi.o
> diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile
> new file mode 100644
> index 0000000..ad856a1
> --- /dev/null
> +++ b/drivers/scsi/snic/Makefile
> @@ -0,0 +1,17 @@
> +obj-$(CONFIG_SCSI_SNIC) +=3D snic.o
> +
> +snic-y :=3D \
> +	snic_attrs.o \
> +	snic_main.o \
> +	snic_res.o \
> +	snic_isr.o \
> +	snic_ctl.o \
> +	snic_io.o \
> +	snic_scsi.o \
> +	snic_disc.o \
> +	snic_debugfs.o \
> +	snic_trc.o \
> +	vnic_cq.o \
> +	vnic_intr.o \
> +	vnic_dev.o \
> +	vnic_wq.o
>=20
As mentioned earlier, please add OONFIG_XXX items for debugfs and
tracing functionality.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
