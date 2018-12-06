From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: message: fusion: Use kmemdup instead of duplicating its function
Date: Thu, 6 Dec 2018 20:37:33 +0800
Message-ID: <20181206123733.59427-1-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

kmemdup has implemented the function that kmalloc() + memcpy().
We prefer to kmemdup rather than code opened implementation.

This issue was detected with the help of coccinelle.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Sathya Prakash <sathya.prakash@broadcom.com>
CC: Chaitra P B <chaitra.basappa@broadcom.com>
CC: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
CC: MPT-FusionLinux.pdl@broadcom.com
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/message/fusion/mptbase.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptb=
ase.c
index ba551d8dfba4..f8ec116cb9a4 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6001,13 +6001,12 @@ mpt=5FfindImVolumes(MPT=5FADAPTER *ioc)
 	if (mpt=5Fconfig(ioc, &cfg) !=3D 0)
 		goto out;
=20
-	mem =3D kmalloc(iocpage2sz, GFP=5FKERNEL);
+	mem =3D kmemdup((u8 *)pIoc2, iocpage2sz, GFP=5FKERNEL);
 	if (!mem) {
 		rc =3D -ENOMEM;
 		goto out;
 	}
=20
-	memcpy(mem, (u8 *)pIoc2, iocpage2sz);
 	ioc->raid=5Fdata.pIocPg2 =3D (IOCPage2=5Ft *) mem;
=20
 	mpt=5Fread=5Fioc=5Fpg=5F3(ioc);
--=20
2.19.1
