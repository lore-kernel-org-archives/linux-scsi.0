From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] scsi: qedi: return via va_end to match corresponding
 va_start
Date: Thu, 22 Dec 2016 08:51:13 +0000
Message-ID: <D4818FAC.360C4%manish.rangankar@cavium.com>
References: <20161216141043.22324-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0061.outbound.protection.outlook.com ([104.47.33.61]:51856
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755221AbcLVJXL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 04:23:11 -0500
In-Reply-To: <20161216141043.22324-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <1ABE2215FA17804E8A1E34DD65BB1F5C@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dept-Eng QLogic Storage Upstream <QLogic-Storage-Upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



On 16/12/16 7:40 PM, "Colin King" <colin.king@canonical.com> wrote:

>From: Colin Ian King <colin.king@canonical.com>
>
>Although on most systems va_end is a no-op, it is good practice
>to use va_end on the function return path, especially since the
>va_start documenation states:
>
>  "Each invocation of va_start() must be matched by a corresponding
>   invocation of va_end() in the same function."
>
>Found with static analysis by CoverityScan, CIDs 1389477-1389479
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/scsi/qedi/qedi_dbg.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/qedi/qedi_dbg.c b/drivers/scsi/qedi/qedi_dbg.c
>index 2bdedb9..8fd28b0 100644
>--- a/drivers/scsi/qedi/qedi_dbg.c
>+++ b/drivers/scsi/qedi/qedi_dbg.c
>@@ -52,7 +52,7 @@ qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char
>*func, u32 line,
> 	vaf.va =3D &va;
>=20
> 	if (!(qedi_dbg_log & QEDI_LOG_WARN))
>-		return;
>+		goto ret;
>=20
> 	if (likely(qedi) && likely(qedi->pdev))
> 		pr_warn("[%s]:[%s:%d]:%d: %pV", dev_name(&qedi->pdev->dev),
>@@ -60,6 +60,7 @@ qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char
>*func, u32 line,
> 	else
> 		pr_warn("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
>=20
>+ret:
> 	va_end(va);
> }
>=20
>@@ -80,7 +81,7 @@ qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char
>*func, u32 line,
> 	vaf.va =3D &va;
>=20
> 	if (!(qedi_dbg_log & QEDI_LOG_NOTICE))
>-		return;
>+		goto ret;
>=20
> 	if (likely(qedi) && likely(qedi->pdev))
> 		pr_notice("[%s]:[%s:%d]:%d: %pV",
>@@ -89,6 +90,7 @@ qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char
>*func, u32 line,
> 	else
> 		pr_notice("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
>=20
>+ret:
> 	va_end(va);
> }
>=20
>@@ -109,7 +111,7 @@ qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char
>*func, u32 line,
> 	vaf.va =3D &va;
>=20
> 	if (!(qedi_dbg_log & level))
>-		return;
>+		goto ret;
>=20
> 	if (likely(qedi) && likely(qedi->pdev))
> 		pr_info("[%s]:[%s:%d]:%d: %pV", dev_name(&qedi->pdev->dev),
>@@ -117,6 +119,7 @@ qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char
>*func, u32 line,
> 	else
> 		pr_info("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
>=20
>+ret:
> 	va_end(va);
> }
>=20
>--=20
>2.10.2


Acked-by: Manish Rangankar <manish.rangankar@cavium.com>

