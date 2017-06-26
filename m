From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qedi: Remove comparison of u16 idx with zero.
Date: Mon, 26 Jun 2017 07:17:19 +0000
Message-ID: <D576B27D.3B0C5%manish.rangankar@cavium.com>
References: <1498321485-21677-1-git-send-email-chris.gekas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0069.outbound.protection.outlook.com ([104.47.37.69]:28896
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751354AbdFZHRX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 03:17:23 -0400
In-Reply-To: <1498321485-21677-1-git-send-email-chris.gekas@gmail.com>
Content-Language: en-US
Content-ID: <D096191747850E428AB7537344E1EA7C@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christos Gkekas <chris.gekas@gmail.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 24/06/17 9:54 PM, "Christos Gkekas" <chris.gekas@gmail.com> wrote:

>Variable idx is defined as u16 thus statement (idx < 0) is
>always false and should be removed.
>
>Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
>---
> drivers/scsi/qedi/qedi_fw.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
>index e937490..19254bd 100644
>--- a/drivers/scsi/qedi/qedi_fw.c
>+++ b/drivers/scsi/qedi/qedi_fw.c
>@@ -333,7 +333,7 @@ static void qedi_get_rq_bdq_buf(struct qedi_ctx *qedi,
>=20
> 	/* Obtain buffer address from rqe_opaque */
> 	idx =3D cqe->rqe_opaque.lo;
>-	if ((idx < 0) || (idx > (QEDI_BDQ_NUM - 1))) {
>+	if (idx > (QEDI_BDQ_NUM - 1)) {
> 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
> 			  "wrong idx %d returned by FW, dropping the unsolicited pkt\n",
> 			  idx);
>@@ -370,7 +370,7 @@ static void qedi_put_rq_bdq_buf(struct qedi_ctx *qedi,
>=20
> 	/* Obtain buffer address from rqe_opaque */
> 	idx =3D cqe->rqe_opaque.lo;
>-	if ((idx < 0) || (idx > (QEDI_BDQ_NUM - 1))) {
>+	if (idx > (QEDI_BDQ_NUM - 1)) {
> 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_CONN,
> 			  "wrong idx %d returned by FW, dropping the unsolicited pkt\n",
> 			  idx);
>--=20
>2.7.4

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
