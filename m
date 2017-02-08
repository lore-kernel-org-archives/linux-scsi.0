From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH -next] scsi: qedi: Fix possible memory leak in
 qedi_iscsi_update_conn()
Date: Wed, 8 Feb 2017 05:51:06 +0000
Message-ID: <D4C0AF2B.36B98%manish.rangankar@cavium.com>
References: <20170207145258.31429-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0070.outbound.protection.outlook.com ([104.47.38.70]:57756
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751748AbdBHFvJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Feb 2017 00:51:09 -0500
In-Reply-To: <20170207145258.31429-1-weiyj.lk@gmail.com>
Content-Language: en-US
Content-ID: <274E7222CA0F7C43BA23126ACFF02DCA@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On 07/02/17 8:22 PM, "Wei Yongjun" <weiyj.lk@gmail.com> wrote:

>From: Wei Yongjun <weiyongjun1@huawei.com>
>
>'conn_info' is malloced in qedi_iscsi_update_conn() and should be
>freed before leaving from the error handling cases, otherwise it
>will cause memory leak.
>
>Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI
>driver framework.")
>Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>---
> drivers/scsi/qedi/qedi_iscsi.c | 4 ----
> 1 file changed, 4 deletions(-)
>
>diff --git a/drivers/scsi/qedi/qedi_iscsi.c
>b/drivers/scsi/qedi/qedi_iscsi.c
>index d6a2054..eb64469 100644
>--- a/drivers/scsi/qedi/qedi_iscsi.c
>+++ b/drivers/scsi/qedi/qedi_iscsi.c
>@@ -453,13 +453,9 @@ static int qedi_iscsi_update_conn(struct qedi_ctx
>*qedi,
> 	if (rval) {
> 		rval =3D -ENXIO;
> 		QEDI_ERR(&qedi->dbg_ctx, "Could not update connection\n");
>-		goto update_conn_err;
> 	}
>=20
> 	kfree(conn_info);
>-	rval =3D 0;
>-
>-update_conn_err:
> 	return rval;
> }
>

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
