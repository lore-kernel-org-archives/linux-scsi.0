From: Saurav Kashyap <skashyap@marvell.com>
Subject: Re: [PATCH][V2] scsi: qedf: remove memset/memcpy to nfunc and use
 func instead
Date: Thu, 18 Apr 2019 08:13:34 +0000
Message-ID: <D8DE2F28.187A3%skashyap@marvell.com>
References: <20190412094829.15868-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190412094829.15868-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <6FE65425F8EB6A4183AA304D1208C5C7@namprd18.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



-----Original Message-----
From: Colin King <colin.king@canonical.com>
Date: Friday, 12 April 2019 at 3:18 PM
To: <QLogic-Storage-Upstream@cavium.com>, "James E . J . Bottomley"
<jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>,
<linux-scsi@vger.kernel.org>
Cc: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH][V2] scsi: qedf: remove memset/memcpy to nfunc and use
func instead
Resent-From: <Saurav.Kashyap@cavium.com>
Resent-Date: Fri, 12 Apr 2019 02:48:45 -0700

>From: Colin Ian King <colin.king@canonical.com>
>
>Currently the qedf_dbg_* family of functions can overrun the end
>of the source string if it is less than the destination buffer
>length because of the use of a fixed sized memcpy. Remove the
>memset/memcpy calls to nfunc and just use func instead as it
>is always a null terminated string.
>
>Addresses-Coverity: ("Out-of-bounds access")
>Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver
>framework.")
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
>
>V2: replace the V1 strscpy with just using func since this is always
>    going to be a NUL terminated string. Thanks to Rasmus Villemoes for
>    noticing that.
>
>---
> drivers/scsi/qedf/qedf_dbg.c | 32 ++++++++------------------------
> 1 file changed, 8 insertions(+), 24 deletions(-)
>
>diff --git a/drivers/scsi/qedf/qedf_dbg.c b/drivers/scsi/qedf/qedf_dbg.c
>index f2397ee9ba69..f7d170bffc82 100644
>--- a/drivers/scsi/qedf/qedf_dbg.c
>+++ b/drivers/scsi/qedf/qedf_dbg.c
>@@ -15,10 +15,6 @@ qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
> {
> 	va_list va;
> 	struct va_format vaf;
>-	char nfunc[32];
>-
>-	memset(nfunc, 0, sizeof(nfunc));
>-	memcpy(nfunc, func, sizeof(nfunc) - 1);
>=20
> 	va_start(va, fmt);
>=20
>@@ -27,9 +23,9 @@ qedf_dbg_err(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
>=20
> 	if (likely(qedf) && likely(qedf->pdev))
> 		pr_err("[%s]:[%s:%d]:%d: %pV", dev_name(&(qedf->pdev->dev)),
>-			nfunc, line, qedf->host_no, &vaf);
>+			func, line, qedf->host_no, &vaf);
> 	else
>-		pr_err("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
>+		pr_err("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
>=20
> 	va_end(va);
> }
>@@ -40,10 +36,6 @@ qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
> {
> 	va_list va;
> 	struct va_format vaf;
>-	char nfunc[32];
>-
>-	memset(nfunc, 0, sizeof(nfunc));
>-	memcpy(nfunc, func, sizeof(nfunc) - 1);
>=20
> 	va_start(va, fmt);
>=20
>@@ -55,9 +47,9 @@ qedf_dbg_warn(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
>=20
> 	if (likely(qedf) && likely(qedf->pdev))
> 		pr_warn("[%s]:[%s:%d]:%d: %pV", dev_name(&(qedf->pdev->dev)),
>-			nfunc, line, qedf->host_no, &vaf);
>+			func, line, qedf->host_no, &vaf);
> 	else
>-		pr_warn("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
>+		pr_warn("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
>=20
> ret:
> 	va_end(va);
>@@ -69,10 +61,6 @@ qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
> {
> 	va_list va;
> 	struct va_format vaf;
>-	char nfunc[32];
>-
>-	memset(nfunc, 0, sizeof(nfunc));
>-	memcpy(nfunc, func, sizeof(nfunc) - 1);
>=20
> 	va_start(va, fmt);
>=20
>@@ -84,10 +72,10 @@ qedf_dbg_notice(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
>=20
> 	if (likely(qedf) && likely(qedf->pdev))
> 		pr_notice("[%s]:[%s:%d]:%d: %pV",
>-			  dev_name(&(qedf->pdev->dev)), nfunc, line,
>+			  dev_name(&(qedf->pdev->dev)), func, line,
> 			  qedf->host_no, &vaf);
> 	else
>-		pr_notice("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
>+		pr_notice("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
>=20
> ret:
> 	va_end(va);
>@@ -99,10 +87,6 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
> {
> 	va_list va;
> 	struct va_format vaf;
>-	char nfunc[32];
>-
>-	memset(nfunc, 0, sizeof(nfunc));
>-	memcpy(nfunc, func, sizeof(nfunc) - 1);
>=20
> 	va_start(va, fmt);
>=20
>@@ -114,9 +98,9 @@ qedf_dbg_info(struct qedf_dbg_ctx *qedf, const char
>*func, u32 line,
>=20
> 	if (likely(qedf) && likely(qedf->pdev))
> 		pr_info("[%s]:[%s:%d]:%d: %pV", dev_name(&(qedf->pdev->dev)),
>-			nfunc, line, qedf->host_no, &vaf);
>+			func, line, qedf->host_no, &vaf);
> 	else
>-		pr_info("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
>+		pr_info("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
>=20
> ret:
> 	va_end(va);
>--=20
>2.20.1

Thanks,
Acked-by: Saurav Kashyap <skashyap@marvell.com>


>
