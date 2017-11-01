From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qla4xxx: Convert timers to use timer_setup()
Date: Wed, 1 Nov 2017 07:06:14 +0000
Message-ID: <D61F6B9C.42267%manish.rangankar@cavium.com>
References: <20171025100743.GA145111@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025100743.GA145111@beast>
Content-Language: en-US
Content-ID: <F7882078B427234090AD28DD86DD3E0F@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 25/10/17 3:37 PM, "Kees Cook" <keescook@chromium.org> wrote:

>In preparation for unconditionally passing the struct timer_list pointer
>to
>all timer callbacks, switch to using the new timer_setup() and
>from_timer()
>to pass the timer pointer explicitly.
>
>Cc: QLogic-Storage-Upstream@qlogic.com
>Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
>Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>Cc: linux-scsi@vger.kernel.org
>Signed-off-by: Kees Cook <keescook@chromium.org>
>---
> drivers/scsi/qla4xxx/ql4_os.c | 12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index 64c6fa563fdb..2b8a8ce2a431 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -3955,16 +3955,15 @@ void qla4xxx_update_session_conn_param(struct
>scsi_qla_host *ha,
> /*
>  * Timer routines
>  */
>+static void qla4xxx_timer(struct timer_list *t);
>=20
>-static void qla4xxx_start_timer(struct scsi_qla_host *ha, void *func,
>+static void qla4xxx_start_timer(struct scsi_qla_host *ha,
> 				unsigned long interval)
> {
> 	DEBUG(printk("scsi: %s: Starting timer thread for adapter %d\n",
> 		     __func__, ha->host->host_no));
>-	init_timer(&ha->timer);
>+	timer_setup(&ha->timer, qla4xxx_timer, 0);
> 	ha->timer.expires =3D jiffies + interval * HZ;
>-	ha->timer.data =3D (unsigned long)ha;
>-	ha->timer.function =3D (void (*)(unsigned long))func;
> 	add_timer(&ha->timer);
> 	ha->timer_active =3D 1;
> }
>@@ -4508,8 +4507,9 @@ static void qla4xxx_check_relogin_flash_ddb(struct
>iscsi_cls_session *cls_sess)
>  * qla4xxx_timer - checks every second for work to do.
>  * @ha: Pointer to host adapter structure.
>  **/
>-static void qla4xxx_timer(struct scsi_qla_host *ha)
>+static void qla4xxx_timer(struct timer_list *t)
> {
>+	struct scsi_qla_host *ha =3D from_timer(ha, t, timer);
> 	int start_dpc =3D 0;
> 	uint16_t w;
>=20
>@@ -8805,7 +8805,7 @@ static int qla4xxx_probe_adapter(struct pci_dev
>*pdev,
> 	ha->isp_ops->enable_intrs(ha);
>=20
> 	/* Start timer thread. */
>-	qla4xxx_start_timer(ha, qla4xxx_timer, 1);
>+	qla4xxx_start_timer(ha, 1);
>=20
> 	set_bit(AF_INIT_DONE, &ha->flags);
>=20
>--=20
>2.7.4


Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
