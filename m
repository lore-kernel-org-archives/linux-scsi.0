From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH 9/9] scsi: bnx2i: Use zeroing allocator rather than
 allocator/memset
Date: Tue, 2 Jan 2018 04:42:51 +0000
Message-ID: <D6710B54.4F541%manish.rangankar@cavium.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
 <1514647712-6332-10-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0075.outbound.protection.outlook.com ([104.47.32.75]:34958
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751251AbeABEmx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Jan 2018 23:42:53 -0500
In-Reply-To: <1514647712-6332-10-git-send-email-himanshujha199640@gmail.com>
Content-Language: en-US
Content-ID: <029635F90AF1A945B541A75BA5BE2903@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "aacraid@adaptec.com" <aacraid@adaptec.com>
Cc: "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>, "Kalluru, Sudarsana" <Sudarsana.Kalluru@cavium.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "satishkh@cisco.com" <satishkh@cisco.com>, "sebaddel@cisco.com" <sebaddel@cisco.com>, "kartilak@cisco.com" <kartilak@cisco.com>Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 30/12/17 8:58 PM, "Himanshu Jha" <himanshujha199640@gmail.com> wrote:

>Use dma_zalloc_coherent instead of dma_alloc_coherent followed by
>memset 0.
>
>Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
>
>Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
>Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
>---
> drivers/scsi/bnx2i/bnx2i_hwi.c | 14 ++++++--------
> 1 file changed, 6 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c
>b/drivers/scsi/bnx2i/bnx2i_hwi.c
>index 9e3bf53..c6a0bd6 100644
>--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
>+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
>@@ -1069,16 +1069,15 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba,
>struct bnx2i_endpoint *ep)
> 	}
>=20
> 	/* Allocate memory area for actual SQ element */
>-	ep->qp.sq_virt =3D
>-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.sq_mem_size,
>-				   &ep->qp.sq_phys, GFP_KERNEL);
>+	ep->qp.sq_virt =3D
>+		dma_zalloc_coherent(&hba->pcidev->dev, ep->qp.sq_mem_size,
>+					&ep->qp.sq_phys, GFP_KERNEL);
> 	if (!ep->qp.sq_virt) {
> 		printk(KERN_ALERT "bnx2i: unable to alloc SQ BD memory %d\n",
> 				  ep->qp.sq_mem_size);
> 		goto mem_alloc_err;
> 	}
>=20
>-	memset(ep->qp.sq_virt, 0x00, ep->qp.sq_mem_size);
> 	ep->qp.sq_first_qe =3D ep->qp.sq_virt;
> 	ep->qp.sq_prod_qe =3D ep->qp.sq_first_qe;
> 	ep->qp.sq_cons_qe =3D ep->qp.sq_first_qe;
>@@ -1106,15 +1105,14 @@ int bnx2i_alloc_qp_resc(struct bnx2i_hba *hba,
>struct bnx2i_endpoint *ep)
> 	}
>=20
> 	/* Allocate memory area for actual CQ element */
>-	ep->qp.cq_virt =3D
>-		dma_alloc_coherent(&hba->pcidev->dev, ep->qp.cq_mem_size,
>-				   &ep->qp.cq_phys, GFP_KERNEL);
>+	ep->qp.cq_virt =3D
>+		dma_zalloc_coherent(&hba->pcidev->dev, ep->qp.cq_mem_size,
>+					&ep->qp.cq_phys, GFP_KERNEL);
> 	if (!ep->qp.cq_virt) {
> 		printk(KERN_ALERT "bnx2i: unable to alloc CQ BD memory %d\n",
> 				  ep->qp.cq_mem_size);
> 		goto mem_alloc_err;
> 	}
>-	memset(ep->qp.cq_virt, 0x00, ep->qp.cq_mem_size);
>=20
> 	ep->qp.cq_first_qe =3D ep->qp.cq_virt;
> 	ep->qp.cq_prod_qe =3D ep->qp.cq_first_qe;
>--=20
>2.7.4

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>


>
