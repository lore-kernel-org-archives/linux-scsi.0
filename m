From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qedi: fix missing return error code check on call
 to qedi_setup_int
Date: Tue, 28 Feb 2017 11:29:34 +0000
Message-ID: <D4DB5CBA.37A86%manish.rangankar@cavium.com>
References: <20170228110248.19290-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0065.outbound.protection.outlook.com ([104.47.33.65]:21944
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751507AbdB1LaO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Feb 2017 06:30:14 -0500
In-Reply-To: <20170228110248.19290-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <26BD04D72FB7E548B9028670F3873272@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


On 28/02/17 4:32 PM, "Colin King" <colin.king@canonical.com> wrote:

>From: Colin Ian King <colin.king@canonical.com>
>
>The call to qedi_setup_int is not updating the return code rc yet rc
>is being checked for an error. Fix this by assigning rc to the return
>code from the call to qedi_setup_int.
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/scsi/qedi/qedi_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
>index 5eda21d..8e3d928 100644
>--- a/drivers/scsi/qedi/qedi_main.c
>+++ b/drivers/scsi/qedi/qedi_main.c
>@@ -1805,7 +1805,7 @@ static int __qedi_probe(struct pci_dev *pdev, int
>mode)
> 	 */
> 	qedi_ops->common->update_pf_params(qedi->cdev, &qedi->pf_params);
>=20
>-	qedi_setup_int(qedi);
>+	rc =3D qedi_setup_int(qedi);
> 	if (rc)
> 		goto stop_iscsi_func;
>=20
>--=20
>2.10.2
>

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
