From: Saurav Kashyap <skashyap@marvell.com>
Subject: Re: [PATCH -next] scsi: qedf: remove set but not used variables
Date: Wed, 24 Apr 2019 15:56:22 +0000
Message-ID: <D8E684C7.18978%skashyap@marvell.com>
References: <20190423144138.20428-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190423144138.20428-1-yuehaibing@huawei.com>
Content-Language: en-US
Content-ID: <688F04A98CCD0149A78E5273B6B00368@namprd18.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

-----Original Message-----
From: <linux-scsi-owner@vger.kernel.org> on behalf of Yue Haibing
<yuehaibing@huawei.com>
Date: Tuesday, 23 April 2019 at 8:11 PM
To: "QLogic-Storage-Upstream@cavium.com"
<QLogic-Storage-Upstream@cavium.com>, "jejb@linux.ibm.com"
<jejb@linux.ibm.com>, "martin.petersen@oracle.com"
<martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, YueHaibing
<yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: qedf: remove set but not used variables
Resent-From: <Saurav.Kashyap@cavium.com>
Resent-Date: Tuesday, 23 April 2019 at 8:12 PM

>From: YueHaibing <yuehaibing@huawei.com>
>
>Fixes gcc '-Wunused-but-set-variable' warnings:
>
>drivers/scsi/qedf/qedf_els.c: In function 'qedf_process_els_compl':
>drivers/scsi/qedf/qedf_els.c:149:20: warning: variable 'sc_cmd' set but
>not used [-Wunused-but-set-variable]
>drivers/scsi/qedf/qedf_els.c:148:28: warning: variable 'task_ctx' set but
>not used [-Wunused-but-set-variable]
>drivers/scsi/qedf/qedf_els.c: In function 'qedf_send_srr':
>drivers/scsi/qedf/qedf_els.c:612:6: warning: variable 'sid' set but not
>used [-Wunused-but-set-variable]
>
>They are never used since introduction.
>
>Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>---
> drivers/scsi/qedf/qedf_els.c | 10 +---------
> 1 file changed, 1 insertion(+), 9 deletions(-)
>
>diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
>index 1781e73..d900c89e 100644
>--- a/drivers/scsi/qedf/qedf_els.c
>+++ b/drivers/scsi/qedf/qedf_els.c
>@@ -145,9 +145,6 @@ static int qedf_initiate_els(struct qedf_rport
>*fcport, unsigned int op,
> void qedf_process_els_compl(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
> 	struct qedf_ioreq *els_req)
> {
>-	struct fcoe_task_context *task_ctx;
>-	struct scsi_cmnd *sc_cmd;
>-	uint16_t xid;
> 	struct fcoe_cqe_midpath_info *mp_info;
>=20
> 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Entered with xid =3D 0x%x"
>@@ -158,10 +155,6 @@ void qedf_process_els_compl(struct qedf_ctx *qedf,
>struct fcoe_cqe *cqe,
> 	/* Kill the ELS timer */
> 	cancel_delayed_work(&els_req->timeout_work);
>=20
>-	xid =3D els_req->xid;
>-	task_ctx =3D qedf_get_task_mem(&qedf->tasks, xid);
>-	sc_cmd =3D els_req->sc_cmd;
>-
> 	/* Get ELS response length from CQE */
> 	mp_info =3D &cqe->cqe_info.midpath_info;
> 	els_req->mp_req.resp_len =3D mp_info->data_placement_size;
>@@ -609,7 +602,7 @@ static int qedf_send_srr(struct qedf_ioreq
>*orig_io_req, u32 offset, u8 r_ctl)
> 	struct qedf_rport *fcport;
> 	struct fc_lport *lport;
> 	struct qedf_els_cb_arg *cb_arg =3D NULL;
>-	u32 sid, r_a_tov;
>+	u32 r_a_tov;
> 	int rc;
>=20
> 	if (!orig_io_req) {
>@@ -635,7 +628,6 @@ static int qedf_send_srr(struct qedf_ioreq
>*orig_io_req, u32 offset, u8 r_ctl)
>=20
> 	qedf =3D fcport->qedf;
> 	lport =3D qedf->lport;
>-	sid =3D fcport->sid;
> 	r_a_tov =3D lport->r_a_tov;
>=20
> 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_ELS, "Sending SRR orig_io=3D%p, "
>--=20
>2.7.0

Thanks,
Acked-by: Saurav Kashyap <skashyap@marvell.com>
>
>
