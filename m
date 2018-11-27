From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: ufs: Use PTR_ERR_OR_ZERO to replace the open coded version
Date: Tue, 27 Nov 2018 15:50:25 +0800
Message-ID: <20181127075025.16018-1-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>, Wen Yang <yellowriver2010@hotmail.com>
List-Id: linux-scsi@vger.kernel.org

PTR=5FERR=5FOR=5FZERO has implemented the same function, so use inlined fun=
ction
instead of open coded equivalent.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Vinayak Holikatti <vinholikatti@gmail.com>
CC: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-scsi@vger.kernel.org
CC: Wen Yang <yellowriver2010@hotmail.com>
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/ufs/ufs-hisi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 452e19f..6fdf059 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -514,10 +514,7 @@ static int ufs=5Fhisi=5Fget=5Fresource(struct ufs=5Fhi=
si=5Fhost *host)
 	/* get resource of ufs sys ctrl */
 	mem=5Fres =3D platform=5Fget=5Fresource(pdev, IORESOURCE=5FMEM, 1);
 	host->ufs=5Fsys=5Fctrl =3D devm=5Fioremap=5Fresource(dev, mem=5Fres);
-	if (IS=5FERR(host->ufs=5Fsys=5Fctrl))
-		return PTR=5FERR(host->ufs=5Fsys=5Fctrl);
-
-	return 0;
+	return PTR=5FERR=5FOR=5FZERO(host->ufs=5Fsys=5Fctrl);
 }
=20
 static void ufs=5Fhisi=5Fset=5Fpm=5Flvl(struct ufs=5Fhba *hba)
--=20
2.9.5
