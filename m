From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [RESEND PATCH 2/2] scsi: qedi: Use zeroing allocator instead of
 allocator/memset
Date: Tue, 9 Jan 2018 09:15:52 +0000
Message-ID: <D67A854D.51B95%manish.rangankar@cavium.com>
References: <1515488812-22664-1-git-send-email-himanshujha199640@gmail.com>
 <1515488812-22664-2-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0056.outbound.protection.outlook.com ([104.47.40.56]:3136
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751390AbeAIJPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Jan 2018 04:15:55 -0500
In-Reply-To: <1515488812-22664-2-git-send-email-himanshujha199640@gmail.com>
Content-Language: en-US
Content-ID: <3CD71B66B0E593469F27D0D34659B2C6@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "Dupuis, Chad" <Chad.Dupuis@cavium.com>


On 09/01/18 2:36 PM, "Himanshu Jha" <himanshujha199640@gmail.com> wrote:

>Use dma_zalloc_coherent instead of dma_alloc_coherent followed by memset
>0.
>
>Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
>
>Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
>Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
>---
> drivers/scsi/qedi/qedi_main.c | 42
>+++++++++++++++---------------------------
> 1 file changed, 15 insertions(+), 27 deletions(-)
>
>diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
>index cccc34a..5ef0b36 100644
>--- a/drivers/scsi/qedi/qedi_main.c
>+++ b/drivers/scsi/qedi/qedi_main.c
>@@ -1268,16 +1268,14 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
> 	}
>=20
> 	/* Allocate list of PBL pages */
>-	qedi->bdq_pbl_list =3D dma_alloc_coherent(&qedi->pdev->dev,
>-						PAGE_SIZE,
>-						&qedi->bdq_pbl_list_dma,
>-						GFP_KERNEL);
>+	qedi->bdq_pbl_list =3D dma_zalloc_coherent(&qedi->pdev->dev, PAGE_SIZE,
>+						 &qedi->bdq_pbl_list_dma,
>+						 GFP_KERNEL);
> 	if (!qedi->bdq_pbl_list) {
> 		QEDI_ERR(&qedi->dbg_ctx,
> 			 "Could not allocate list of PBL pages.\n");
> 		return -ENOMEM;
> 	}
>-	memset(qedi->bdq_pbl_list, 0, PAGE_SIZE);
>=20
> 	/*
> 	 * Now populate PBL list with pages that contain pointers to the
>@@ -1367,11 +1365,10 @@ static int qedi_alloc_global_queues(struct
>qedi_ctx *qedi)
> 		    (qedi->global_queues[i]->cq_pbl_size +
> 		    (QEDI_PAGE_SIZE - 1));
>=20
>-		qedi->global_queues[i]->cq =3D
>-		    dma_alloc_coherent(&qedi->pdev->dev,
>-				       qedi->global_queues[i]->cq_mem_size,
>-				       &qedi->global_queues[i]->cq_dma,
>-				       GFP_KERNEL);
>+		qedi->global_queues[i]->cq =3D dma_zalloc_coherent(&qedi->pdev->dev,
>+								 qedi->global_queues[i]->cq_mem_size,
>+								 &qedi->global_queues[i]->cq_dma,
>+								 GFP_KERNEL);
>=20
> 		if (!qedi->global_queues[i]->cq) {
> 			QEDI_WARN(&qedi->dbg_ctx,
>@@ -1379,14 +1376,10 @@ static int qedi_alloc_global_queues(struct
>qedi_ctx *qedi)
> 			status =3D -ENOMEM;
> 			goto mem_alloc_failure;
> 		}
>-		memset(qedi->global_queues[i]->cq, 0,
>-		       qedi->global_queues[i]->cq_mem_size);
>-
>-		qedi->global_queues[i]->cq_pbl =3D
>-		    dma_alloc_coherent(&qedi->pdev->dev,
>-				       qedi->global_queues[i]->cq_pbl_size,
>-				       &qedi->global_queues[i]->cq_pbl_dma,
>-				       GFP_KERNEL);
>+		qedi->global_queues[i]->cq_pbl =3D dma_zalloc_coherent(&qedi->pdev->dev=
,
>+								     qedi->global_queues[i]->cq_pbl_size,
>+								     &qedi->global_queues[i]->cq_pbl_dma,
>+								     GFP_KERNEL);
>=20
> 		if (!qedi->global_queues[i]->cq_pbl) {
> 			QEDI_WARN(&qedi->dbg_ctx,
>@@ -1394,8 +1387,6 @@ static int qedi_alloc_global_queues(struct qedi_ctx
>*qedi)
> 			status =3D -ENOMEM;
> 			goto mem_alloc_failure;
> 		}
>-		memset(qedi->global_queues[i]->cq_pbl, 0,
>-		       qedi->global_queues[i]->cq_pbl_size);
>=20
> 		/* Create PBL */
> 		num_pages =3D qedi->global_queues[i]->cq_mem_size /
>@@ -1456,25 +1447,22 @@ int qedi_alloc_sq(struct qedi_ctx *qedi, struct
>qedi_endpoint *ep)
> 	ep->sq_pbl_size =3D (ep->sq_mem_size / QEDI_PAGE_SIZE) * sizeof(void *);
> 	ep->sq_pbl_size =3D ep->sq_pbl_size + QEDI_PAGE_SIZE;
>=20
>-	ep->sq =3D dma_alloc_coherent(&qedi->pdev->dev, ep->sq_mem_size,
>-				    &ep->sq_dma, GFP_KERNEL);
>+	ep->sq =3D dma_zalloc_coherent(&qedi->pdev->dev, ep->sq_mem_size,
>+				     &ep->sq_dma, GFP_KERNEL);
> 	if (!ep->sq) {
> 		QEDI_WARN(&qedi->dbg_ctx,
> 			  "Could not allocate send queue.\n");
> 		rval =3D -ENOMEM;
> 		goto out;
> 	}
>-	memset(ep->sq, 0, ep->sq_mem_size);
>-
>-	ep->sq_pbl =3D dma_alloc_coherent(&qedi->pdev->dev, ep->sq_pbl_size,
>-					&ep->sq_pbl_dma, GFP_KERNEL);
>+	ep->sq_pbl =3D dma_zalloc_coherent(&qedi->pdev->dev, ep->sq_pbl_size,
>+					 &ep->sq_pbl_dma, GFP_KERNEL);
> 	if (!ep->sq_pbl) {
> 		QEDI_WARN(&qedi->dbg_ctx,
> 			  "Could not allocate send queue PBL.\n");
> 		rval =3D -ENOMEM;
> 		goto out_free_sq;
> 	}
>-	memset(ep->sq_pbl, 0, ep->sq_pbl_size);
>=20
> 	/* Create PBL */
> 	num_pages =3D ep->sq_mem_size / QEDI_PAGE_SIZE;
>--=20
>2.7.4

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>


>
