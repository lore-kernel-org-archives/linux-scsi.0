From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] qedi: Fix a possible sleep-in-atomic bug in
 qedi_process_tmf_resp
Date: Wed, 13 Dec 2017 09:12:11 +0000
Message-ID: <D656EC82.4ACF8%manish.rangankar@cavium.com>
References: <1513156268-13328-1-git-send-email-baijiaju1990@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513156268-13328-1-git-send-email-baijiaju1990@gmail.com>
Content-Language: en-US
Content-ID: <352840AEB62B484492A03B8585BF37CC@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jia-Ju Bai <baijiaju1990@gmail.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 13/12/17 2:41 PM, "Jia-Ju Bai" <baijiaju1990@gmail.com> wrote:

>The driver may sleep under a spinlock.
>The function call path is:
>qedi_cpu_offline (acquire the spinlock)
>  qedi_fp_process_cqes
>    qedi_mtask_completion
>      qedi_process_tmf_resp
>        kzalloc(GFP_KERNEL) --> may sleep
>
>To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.
>
>This bug is found by my static analysis tool(DSAC) and checked by my code
>review.
>
>Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>---
> drivers/scsi/qedi/qedi_fw.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
>index bd302d3..20a9259 100644
>--- a/drivers/scsi/qedi/qedi_fw.c
>+++ b/drivers/scsi/qedi/qedi_fw.c
>@@ -198,7 +198,7 @@ static void qedi_process_tmf_resp(struct qedi_ctx
>*qedi,
> 	cqe_tmp_response =3D &cqe->cqe_common.iscsi_hdr.tmf_response;
>=20
> 	qedi_cmd =3D task->dd_data;
>-	qedi_cmd->tmf_resp_buf =3D kzalloc(sizeof(*resp_hdr_ptr), GFP_KERNEL);
>+	qedi_cmd->tmf_resp_buf =3D kzalloc(sizeof(*resp_hdr_ptr), GFP_ATOMIC);
> 	if (!qedi_cmd->tmf_resp_buf) {
> 		QEDI_ERR(&qedi->dbg_ctx,
> 			 "Failed to allocate resp buf, cid=3D0x%x\n",
>--=20
>1.7.9.5

Thanks,

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>

>
