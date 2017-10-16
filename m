From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qedi: Delete redundant variables
Date: Mon, 16 Oct 2017 05:37:51 +0000
Message-ID: <D60A434B.3F295%manish.rangankar@cavium.com>
References: <1507983478-23083-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0062.outbound.protection.outlook.com ([104.47.33.62]:23104
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750731AbdJPFhx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 01:37:53 -0400
In-Reply-To: <1507983478-23083-1-git-send-email-chris.gekas@gmail.com>
Content-Language: en-US
Content-ID: <A4145B2DD895D4458359CB0B944C1BAD@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christos Gkekas <chris.gekas@gmail.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 14/10/17 5:47 PM, "Christos Gkekas" <chris.gekas@gmail.com> wrote:

>Remove redundant variables in quedi_fw.c that are set but not used.
>
>Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
>---
> drivers/scsi/qedi/qedi_fw.c | 17 +----------------
> 1 file changed, 1 insertion(+), 16 deletions(-)
>
>diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
>index 93d54ac..bd302d3 100644
>--- a/drivers/scsi/qedi/qedi_fw.c
>+++ b/drivers/scsi/qedi/qedi_fw.c
>@@ -92,7 +92,6 @@ static void qedi_process_text_resp(struct qedi_ctx
>*qedi,
> 	struct iscsi_text_response_hdr *cqe_text_response;
> 	struct qedi_cmd *cmd;
> 	int pld_len;
>-	u32 *tmp;
>=20
> 	cmd =3D (struct qedi_cmd *)task->dd_data;
> 	task_ctx =3D qedi_get_task_mem(&qedi->tasks, cmd->task_id);
>@@ -108,7 +107,6 @@ static void qedi_process_text_resp(struct qedi_ctx
>*qedi,
> 	hton24(resp_hdr_ptr->dlength,
> 	       (cqe_text_response->hdr_second_dword &
> 		ISCSI_TEXT_RESPONSE_HDR_DATA_SEG_LEN_MASK));
>-	tmp =3D (u32 *)resp_hdr_ptr->dlength;
>=20
> 	resp_hdr_ptr->itt =3D build_itt(cqe->cqe_solicited.itid,
> 				      conn->session->age);
>@@ -196,7 +194,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx
>*qedi,
> 	struct iscsi_tm_rsp *resp_hdr_ptr;
> 	struct iscsi_tm *tmf_hdr;
> 	struct qedi_cmd *qedi_cmd =3D NULL;
>-	u32 *tmp;
>=20
> 	cqe_tmp_response =3D &cqe->cqe_common.iscsi_hdr.tmf_response;
>=20
>@@ -222,7 +219,6 @@ static void qedi_process_tmf_resp(struct qedi_ctx
>*qedi,
> 	hton24(resp_hdr_ptr->dlength,
> 	       (cqe_tmp_response->hdr_second_dword &
> 		ISCSI_TMF_RESPONSE_HDR_DATA_SEG_LEN_MASK));
>-	tmp =3D (u32 *)resp_hdr_ptr->dlength;
> 	resp_hdr_ptr->itt =3D build_itt(cqe->cqe_solicited.itid,
> 				      conn->session->age);
> 	resp_hdr_ptr->statsn =3D cpu_to_be32(cqe_tmp_response->stat_sn);
>@@ -269,7 +265,6 @@ static void qedi_process_login_resp(struct qedi_ctx
>*qedi,
> 	struct iscsi_login_response_hdr *cqe_login_response;
> 	struct qedi_cmd *cmd;
> 	int pld_len;
>-	u32 *tmp;
>=20
> 	cmd =3D (struct qedi_cmd *)task->dd_data;
>=20
>@@ -286,7 +281,6 @@ static void qedi_process_login_resp(struct qedi_ctx
>*qedi,
> 	hton24(resp_hdr_ptr->dlength,
> 	       (cqe_login_response->hdr_second_dword &
> 		ISCSI_LOGIN_RESPONSE_HDR_DATA_SEG_LEN_MASK));
>-	tmp =3D (u32 *)resp_hdr_ptr->dlength;
> 	resp_hdr_ptr->itt =3D build_itt(cqe->cqe_solicited.itid,
> 				      conn->session->age);
> 	resp_hdr_ptr->tsih =3D cqe_login_response->tsih;
>@@ -590,7 +584,6 @@ static void qedi_scsi_completion(struct qedi_ctx
>*qedi,
> 	int datalen =3D 0;
> 	struct qedi_conn *qedi_conn;
> 	u32 iscsi_cid;
>-	bool mark_cmd_node_deleted =3D false;
> 	u8 cqe_err_bits =3D 0;
>=20
> 	iscsi_cid  =3D cqe->cqe_common.conn_id;
>@@ -674,7 +667,6 @@ static void qedi_scsi_completion(struct qedi_ctx
>*qedi,
> 		cmd->io_cmd_in_list =3D false;
> 		list_del_init(&cmd->io_cmd);
> 		qedi_conn->active_cmd_count--;
>-		mark_cmd_node_deleted =3D true;
> 	}
> 	spin_unlock(&qedi_conn->list_lock);
>=20
>@@ -763,7 +755,7 @@ static void qedi_process_cmd_cleanup_resp(struct
>qedi_ctx *qedi,
> 	u32 rtid =3D 0;
> 	u32 iscsi_cid;
> 	struct qedi_conn *qedi_conn;
>-	struct qedi_cmd *cmd_new, *dbg_cmd;
>+	struct qedi_cmd *dbg_cmd;
> 	struct iscsi_task *mtask;
> 	struct iscsi_tm *tmf_hdr =3D NULL;
>=20
>@@ -856,7 +848,6 @@ static void qedi_process_cmd_cleanup_resp(struct
>qedi_ctx *qedi,
> 		}
> 		qedi_conn->cmd_cleanup_cmpl++;
> 		wake_up(&qedi_conn->wait_queue);
>-		cmd_new =3D task->dd_data;
>=20
> 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
> 			  "Freeing tid=3D0x%x for cid=3D0x%x\n",
>@@ -1029,7 +1020,6 @@ int qedi_send_iscsi_login(struct qedi_conn
>*qedi_conn,
> 	struct iscsi_task_context *fw_task_ctx;
> 	struct qedi_ctx *qedi =3D qedi_conn->qedi;
> 	struct iscsi_login_req *login_hdr;
>-	struct scsi_sge *req_sge =3D NULL;
> 	struct scsi_sge *resp_sge =3D NULL;
> 	struct qedi_cmd *qedi_cmd;
> 	struct qedi_endpoint *ep;
>@@ -1037,7 +1027,6 @@ int qedi_send_iscsi_login(struct qedi_conn
>*qedi_conn,
> 	u16 sq_idx =3D 0;
> 	int rval =3D 0;
>=20
>-	req_sge =3D (struct scsi_sge *)qedi_conn->gen_pdu.req_bd_tbl;
> 	resp_sge =3D (struct scsi_sge *)qedi_conn->gen_pdu.resp_bd_tbl;
> 	qedi_cmd =3D (struct qedi_cmd *)task->dd_data;
> 	ep =3D qedi_conn->ep;
>@@ -1718,7 +1707,6 @@ int qedi_send_iscsi_nopout(struct qedi_conn
>*qedi_conn,
> 	struct qedi_ctx *qedi =3D qedi_conn->qedi;
> 	struct iscsi_task_context *fw_task_ctx;
> 	struct iscsi_nopout *nopout_hdr;
>-	struct scsi_sge *req_sge =3D NULL;
> 	struct scsi_sge *resp_sge =3D NULL;
> 	struct qedi_cmd *qedi_cmd;
> 	struct qedi_endpoint *ep;
>@@ -1727,7 +1715,6 @@ int qedi_send_iscsi_nopout(struct qedi_conn
>*qedi_conn,
> 	u16 sq_idx =3D 0;
> 	int rval =3D 0;
>=20
>-	req_sge =3D (struct scsi_sge *)qedi_conn->gen_pdu.req_bd_tbl;
> 	resp_sge =3D (struct scsi_sge *)qedi_conn->gen_pdu.resp_bd_tbl;
> 	qedi_cmd =3D (struct qedi_cmd *)task->dd_data;
> 	nopout_hdr =3D (struct iscsi_nopout *)task->hdr;
>@@ -1995,7 +1982,6 @@ void qedi_trace_io(struct qedi_ctx *qedi, struct
>iscsi_task *task,
> 	struct qedi_conn *qedi_conn =3D conn->dd_data;
> 	struct scsi_cmnd *sc_cmd =3D task->sc;
> 	unsigned long flags;
>-	u8 op;
>=20
> 	spin_lock_irqsave(&qedi->io_trace_lock, flags);
>=20
>@@ -2005,7 +1991,6 @@ void qedi_trace_io(struct qedi_ctx *qedi, struct
>iscsi_task *task,
> 	io_log->cid =3D qedi_conn->iscsi_conn_id;
> 	io_log->lun =3D sc_cmd->device->lun;
> 	io_log->op =3D sc_cmd->cmnd[0];
>-	op =3D sc_cmd->cmnd[0];
> 	io_log->lba[0] =3D sc_cmd->cmnd[2];
> 	io_log->lba[1] =3D sc_cmd->cmnd[3];
> 	io_log->lba[2] =3D sc_cmd->cmnd[4];
>--=20
>2.7.4

Thanks for the patch.

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
