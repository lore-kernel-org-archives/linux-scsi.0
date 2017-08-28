From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qedi: off by one in qedi_get_cmd_from_tid()
Date: Mon, 28 Aug 2017 05:34:24 +0000
Message-ID: <D5C9A8DE.3C608%manish.rangankar@cavium.com>
References: <20170825103657.6kwprvwfks7szn3b@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0048.outbound.protection.outlook.com ([104.47.33.48]:51374
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750708AbdH1Fe1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 01:34:27 -0400
In-Reply-To: <20170825103657.6kwprvwfks7szn3b@mwanda>
Content-Language: en-US
Content-ID: <7F0931AD45D92541849601EBF17B1E56@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>



On 25/08/17 4:06 PM, "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

>The > here should be >=3D or we end up reading one element beyond the end
>of the qedi->itt_map[] array.  The qedi->itt_map[] array is allocated in
>qedi_alloc_itt().
>
>Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI
>driver framework.")
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
>diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
>index c4a470bab4dd..cccc34adc0e0 100644
>--- a/drivers/scsi/qedi/qedi_main.c
>+++ b/drivers/scsi/qedi/qedi_main.c
>@@ -1576,7 +1576,7 @@ struct qedi_cmd *qedi_get_cmd_from_tid(struct
>qedi_ctx *qedi, u32 tid)
> {
> 	struct qedi_cmd *cmd =3D NULL;
>=20
>-	if (tid > MAX_ISCSI_TASK_ENTRIES)
>+	if (tid >=3D MAX_ISCSI_TASK_ENTRIES)
> 		return NULL;
>=20
> 	cmd =3D qedi->itt_map[tid].p_cmd;

Thanks for the patch.

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>


>
