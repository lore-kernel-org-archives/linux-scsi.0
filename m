From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: avoid unused-function warning
Date: Fri, 30 Jun 2017 23:54:48 +0000
Message-ID: <F445CD44-3240-4E58-BDC2-DF3A8389D636@cavium.com>
References: <20170630161056.30630-1-arnd@arndb.de>
 <20170630161056.30630-2-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170630161056.30630-2-arnd@arndb.de>
Content-Language: en-US
Content-ID: <4CEC7B51BFE4E14F896644E835D72C0D@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Tran, Quinn" <Quinn.Tran@cavium.com>, Nicholas Bellinger <nab@linux-iscsi.org>, "Trapp, Darren" <Darren.Trapp@cavium.com>, Anil Gurumurthy <anil.gurumurhty@cavium.com>, "Grigsby, Duane" <Duane.Grigsby@cavium.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> On Jun 30, 2017, at 9:10 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> When NVMe support is disabled, we get a couple of harmless warnings:
>=20
> drivers/scsi/qla2xxx/qla_nvme.c:667:13: error: 'qla_nvme_unregister_remot=
e_port' defined but not used [-Werror=3Dunused-function]
> drivers/scsi/qla2xxx/qla_nvme.c:634:13: error: 'qla_nvme_abort_all' defin=
ed but not used [-Werror=3Dunused-function]
> drivers/scsi/qla2xxx/qla_nvme.c:604:12: error: 'qla_nvme_wait_on_rport_de=
l' defined but not used [-Werror=3Dunused-function]
>=20
> This replaces the preprocessor checks in the code with equivalent
> compiler conditionals, which lets gcc drop the unused functions
> without warning, and is nicer to read.
>=20
> Fixes: e84067d74301 ("scsi: qla2xxx: Add FC-NVMe F/W initialization and t=
ransport registration")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> drivers/scsi/qla2xxx/Kconfig    |  1 +
> drivers/scsi/qla2xxx/qla_nvme.c | 20 ++++++++++++--------
> 2 files changed, 13 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
> index de952935b5d2..036cc3f217b1 100644
> --- a/drivers/scsi/qla2xxx/Kconfig
> +++ b/drivers/scsi/qla2xxx/Kconfig
> @@ -2,6 +2,7 @@ config SCSI_QLA_FC
> 	tristate "QLogic QLA2XXX Fibre Channel Support"
> 	depends on PCI && SCSI
> 	depends on SCSI_FC_ATTRS
> +	depends on NVME_FC || !NVME_FC
> 	select FW_LOADER
> 	select BTREE
> 	---help---
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_n=
vme.c
> index 14e25e32e622..9c18d754ac33 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -17,10 +17,12 @@ static void qla_nvme_unregister_remote_port(struct wo=
rk_struct *);
>=20
> int qla_nvme_register_remote(scsi_qla_host_t *vha, fc_port_t *fcport)
> {
> -#if (IS_ENABLED(CONFIG_NVME_FC))
> 	struct nvme_rport *rport;
> 	int ret;
>=20
> +	if (!IS_ENABLED(CONFIG_NVME_FC))
> +		return 0;
> +
> 	if (fcport->nvme_flag & NVME_FLAG_REGISTERED)
> 		return 0;
>=20
> @@ -78,7 +80,6 @@ int qla_nvme_register_remote(scsi_qla_host_t *vha, fc_p=
ort_t *fcport)
> 	init_waitqueue_head(&fcport->nvme_waitQ);
> 	rport->fcport =3D fcport;
> 	list_add_tail(&rport->list, &vha->nvme_rport_list);
> -#endif
> 	return 0;
> }
>=20
> @@ -666,11 +667,13 @@ static void qla_nvme_abort_all(fc_port_t *fcport)
>=20
> static void qla_nvme_unregister_remote_port(struct work_struct *work)
> {
> -#if (IS_ENABLED(CONFIG_NVME_FC))
> 	struct fc_port *fcport =3D container_of(work, struct fc_port,
> 	    nvme_del_work);
> 	struct nvme_rport *rport, *trport;
>=20
> +	if (!IS_ENABLED(CONFIG_NVME_FC))
> +		return;
> +
> 	list_for_each_entry_safe(rport, trport,
> 	    &fcport->vha->nvme_rport_list, list) {
> 		if (rport->fcport =3D=3D fcport) {
> @@ -680,16 +683,17 @@ static void qla_nvme_unregister_remote_port(struct =
work_struct *work)
> 			    fcport->nvme_remote_port);
> 		}
> 	}
> -#endif
> }
>=20
> void qla_nvme_delete(scsi_qla_host_t *vha)
> {
> -#if (IS_ENABLED(CONFIG_NVME_FC))
> 	struct nvme_rport *rport, *trport;
> 	fc_port_t *fcport;
> 	int nv_ret;
>=20
> +	if (!IS_ENABLED(CONFIG_NVME_FC))
> +		return;
> +
> 	list_for_each_entry_safe(rport, trport, &vha->nvme_rport_list, list) {
> 		fcport =3D rport->fcport;
>=20
> @@ -711,17 +715,18 @@ void qla_nvme_delete(scsi_qla_host_t *vha)
> 			ql_log(ql_log_info, vha, 0x2115,
> 			    "Unregister of localport failed\n");
> 	}
> -#endif
> }
>=20
> void qla_nvme_register_hba(scsi_qla_host_t *vha)
> {
> -#if (IS_ENABLED(CONFIG_NVME_FC))
> 	struct nvme_fc_port_template *tmpl;
> 	struct qla_hw_data *ha;
> 	struct nvme_fc_port_info pinfo;
> 	int ret;
>=20
> +	if (!IS_ENABLED(CONFIG_NVME_FC))
> +		return;
> +
> 	ha =3D vha->hw;
> 	tmpl =3D &qla_nvme_fc_transport;
>=20
> @@ -752,5 +757,4 @@ void qla_nvme_register_hba(scsi_qla_host_t *vha)
> 	atomic_set(&vha->nvme_ref_count, 1);
> 	vha->nvme_local_port->private =3D vha;
> 	init_waitqueue_head(&vha->nvme_waitQ);
> -#endif
> }
> --=20
> 2.9.0
>=20

Looks Good.=20

Acked-By: Himanshu Madhani <himanshu.madhani@cavium.com>

Thanks,
- Himanshu
