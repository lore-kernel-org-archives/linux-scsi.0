Received: from MSK-MAILEDGE.securitycode.ru (msk-mailedge.securitycode.ru [195.133.217.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DC119597F;
	Thu, 19 Sep 2024 07:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.133.217.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726732121; cv=none; b=dCplOxAjJjmJAu3xHuWWmwRwZX8ef5BU/qy9yekuTUX0ZXBff5usPhJ6iqGOrxra9vd/DOCzd1dBL2olbpf3hyZ+5u/UQsgyixLfD+A1Z0hgecT9vPJyWU6MBtQH3hQjtY+JjwmHJXSv18F1o0mupPCeadvVbgkqWWCk7YfNXdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726732121; c=relaxed/simple;
	bh=ZUIY1bTq7tcStG9n2brMp/RAUcRJFzU/Eqq1FFpE2NQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oaV3/M8NiUhQUkTFRYCzaLlTGL6eIX/tyYdAHIt6/q15s3nL9EHWxedNj16M4KiLKya7I5LkpAN9fQuqktzWFeOooaqSvVyrejzq+WiMcErbk+NzWdlelAN/AZBfM1it59ZYOVvdD7v143FjLmx1My8LF8nvhewX26JyGicQx54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=securitycode.ru; spf=pass smtp.mailfrom=securitycode.ru; arc=none smtp.client-ip=195.133.217.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=securitycode.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=securitycode.ru
From: George Rurikov <g.ryurikov@securitycode.ru>
To: Kashyap Desai <kashyap.desai@broadcom.com>
CC: George Rurikov <g.ryurikov@securitycode.ru>, Sumit Saxena
	<sumit.saxena@broadcom.com>, Shivasharan S
	<shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil
	<chandrakanth.patil@broadcom.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, <megaraidlinux.pdl@broadcom.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH] scsi: megaraid: Remove redundant check in megasas_init_fw()
Date: Thu, 19 Sep 2024 10:48:07 +0300
Message-ID: <20240919074807.930749-1-g.ryurikov@securitycode.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: SPB-EX2.Securitycode.ru (172.16.24.92) To
 MSK-EX2.Securitycode.ru (172.17.8.92)

This is cosmetic fix.

The memory for 'fusion' (instance->ctrl_context) is allocated in
megasas_alloc_ctrl_mem() in a call to megasas_alloc_fusion_context().
A possible allocation error is handled after megasas_alloc_ctrl_mem()
with a fail_alloc_dma_buf label transition.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Cc: stable@vger.kernel.org
Signed-off-by: George Rurikov <g.ryurikov@securitycode.ru>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 111 +++++++++++-----------
 1 file changed, 54 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megar=
aid/megaraid_sas_base.c
index 6c79c350a4d5..e4823680e009 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6149,68 +6149,65 @@ static int megasas_init_fw(struct megasas_instance =
*instance)

                scratch_pad_1 =3D megasas_readl
                        (instance, &instance->reg_set->outbound_scratch_pad=
_1);
-               /* Check max MSI-X vectors */
-               if (fusion) {
-                       if (instance->adapter_type =3D=3D THUNDERBOLT_SERIE=
S) {
-                               /* Thunderbolt Series*/
-                               instance->msix_vectors =3D (scratch_pad_1
-                                       & MR_MAX_REPLY_QUEUES_OFFSET) + 1;
-                       } else {
-                               instance->msix_vectors =3D ((scratch_pad_1
-                                       & MR_MAX_REPLY_QUEUES_EXT_OFFSET)
-                                       >> MR_MAX_REPLY_QUEUES_EXT_OFFSET_S=
HIFT) + 1;
-
-                               /*
-                                * For Invader series, > 8 MSI-x vectors
-                                * supported by FW/HW implies combined
-                                * reply queue mode is enabled.
-                                * For Ventura series, > 16 MSI-x vectors
-                                * supported by FW/HW implies combined
-                                * reply queue mode is enabled.
-                                */
-                               switch (instance->adapter_type) {
-                               case INVADER_SERIES:
-                                       if (instance->msix_vectors > 8)
-                                               instance->msix_combined =3D=
 true;
-                                       break;
-                               case AERO_SERIES:
-                               case VENTURA_SERIES:
-                                       if (instance->msix_vectors > 16)
-                                               instance->msix_combined =3D=
 true;
-                                       break;
-                               }

-                               if (rdpq_enable)
-                                       instance->is_rdpq =3D (scratch_pad_=
1 & MR_RDPQ_MODE_OFFSET) ?
-                                                               1 : 0;
+               if (instance->adapter_type =3D=3D THUNDERBOLT_SERIES) {
+                       /* Thunderbolt Series*/
+                       instance->msix_vectors =3D (scratch_pad_1
+                               & MR_MAX_REPLY_QUEUES_OFFSET) + 1;
+               } else {
+                       instance->msix_vectors =3D ((scratch_pad_1
+                               & MR_MAX_REPLY_QUEUES_EXT_OFFSET)
+                               >> MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + =
1;

-                               if (instance->adapter_type >=3D INVADER_SER=
IES &&
-                                   !instance->msix_combined) {
-                                       instance->msix_load_balance =3D tru=
e;
-                                       instance->smp_affinity_enable =3D f=
alse;
-                               }
+                       /*
+                               * For Invader series, > 8 MSI-x vectors
+                               * supported by FW/HW implies combined
+                               * reply queue mode is enabled.
+                               * For Ventura series, > 16 MSI-x vectors
+                               * supported by FW/HW implies combined
+                               * reply queue mode is enabled.
+                               */
+                       switch (instance->adapter_type) {
+                       case INVADER_SERIES:
+                               if (instance->msix_vectors > 8)
+                                       instance->msix_combined =3D true;
+                               break;
+                       case AERO_SERIES:
+                       case VENTURA_SERIES:
+                               if (instance->msix_vectors > 16)
+                                       instance->msix_combined =3D true;
+                               break;
+                       }

-                               /* Save 1-15 reply post index address to lo=
cal memory
-                                * Index 0 is already saved from reg offset
-                                * MPI2_REPLY_POST_HOST_INDEX_OFFSET
-                                */
-                               for (loop =3D 1; loop < MR_MAX_MSIX_REG_ARR=
AY; loop++) {
-                                       instance->reply_post_host_index_add=
r[loop] =3D
-                                               (u32 __iomem *)
-                                               ((u8 __iomem *)instance->re=
g_set +
-                                               MPI2_SUP_REPLY_POST_HOST_IN=
DEX_OFFSET
-                                               + (loop * 0x10));
-                               }
+                       if (rdpq_enable)
+                               instance->is_rdpq =3D (scratch_pad_1 & MR_R=
DPQ_MODE_OFFSET) ?
+                                                       1 : 0;
+
+                       if (instance->adapter_type >=3D INVADER_SERIES &&
+                               !instance->msix_combined) {
+                               instance->msix_load_balance =3D true;
+                               instance->smp_affinity_enable =3D false;
                        }

-                       dev_info(&instance->pdev->dev,
-                                "firmware supports msix\t: (%d)",
-                                instance->msix_vectors);
-                       if (msix_vectors)
-                               instance->msix_vectors =3D min(msix_vectors=
,
-                                       instance->msix_vectors);
-               } else /* MFI adapters */
-                       instance->msix_vectors =3D 1;
+                       /* Save 1-15 reply post index address to local memo=
ry
+                               * Index 0 is already saved from reg offset
+                               * MPI2_REPLY_POST_HOST_INDEX_OFFSET
+                               */
+                       for (loop =3D 1; loop < MR_MAX_MSIX_REG_ARRAY; loop=
++) {
+                               instance->reply_post_host_index_addr[loop] =
=3D
+                                       (u32 __iomem *)
+                                       ((u8 __iomem *)instance->reg_set +
+                                       MPI2_SUP_REPLY_POST_HOST_INDEX_OFFS=
ET
+                                       + (loop * 0x10));
+                       }
+               }
+
+               dev_info(&instance->pdev->dev,
+                               "firmware supports msix\t: (%d)",
+                               instance->msix_vectors);
+               if (msix_vectors)
+                       instance->msix_vectors =3D min(msix_vectors,
+                               instance->msix_vectors);


                /*
--
2.34.1

=D0=97=D0=B0=D1=8F=D0=B2=D0=BB=D0=B5=D0=BD=D0=B8=D0=B5 =D0=BE =D0=BA=D0=BE=
=D0=BD=D1=84=D0=B8=D0=B4=D0=B5=D0=BD=D1=86=D0=B8=D0=B0=D0=BB=D1=8C=D0=BD=D0=
=BE=D1=81=D1=82=D0=B8

=D0=94=D0=B0=D0=BD=D0=BD=D0=BE=D0=B5 =D1=8D=D0=BB=D0=B5=D0=BA=D1=82=D1=80=
=D0=BE=D0=BD=D0=BD=D0=BE=D0=B5 =D0=BF=D0=B8=D1=81=D1=8C=D0=BC=D0=BE =D0=B8 =
=D0=BB=D1=8E=D0=B1=D1=8B=D0=B5 =D0=BF=D1=80=D0=B8=D0=BB=D0=BE=D0=B6=D0=B5=
=D0=BD=D0=B8=D1=8F =D0=BA =D0=BD=D0=B5=D0=BC=D1=83 =D1=8F=D0=B2=D0=BB=D1=8F=
=D1=8E=D1=82=D1=81=D1=8F =D0=BA=D0=BE=D0=BD=D1=84=D0=B8=D0=B4=D0=B5=D0=BD=
=D1=86=D0=B8=D0=B0=D0=BB=D1=8C=D0=BD=D1=8B=D0=BC=D0=B8 =D0=B8 =D0=BF=D1=80=
=D0=B5=D0=B4=D0=BD=D0=B0=D0=B7=D0=BD=D0=B0=D1=87=D0=B5=D0=BD=D1=8B =D0=B8=
=D1=81=D0=BA=D0=BB=D1=8E=D1=87=D0=B8=D1=82=D0=B5=D0=BB=D1=8C=D0=BD=D0=BE =
=D0=B4=D0=BB=D1=8F =D0=B0=D0=B4=D1=80=D0=B5=D1=81=D0=B0=D1=82=D0=B0. =D0=95=
=D1=81=D0=BB=D0=B8 =D0=92=D1=8B =D0=BD=D0=B5 =D1=8F=D0=B2=D0=BB=D1=8F=D0=B5=
=D1=82=D0=B5=D1=81=D1=8C =D0=B0=D0=B4=D1=80=D0=B5=D1=81=D0=B0=D1=82=D0=BE=
=D0=BC =D0=B4=D0=B0=D0=BD=D0=BD=D0=BE=D0=B3=D0=BE =D0=BF=D0=B8=D1=81=D1=8C=
=D0=BC=D0=B0, =D0=BF=D0=BE=D0=B6=D0=B0=D0=BB=D1=83=D0=B9=D1=81=D1=82=D0=B0,=
 =D1=83=D0=B2=D0=B5=D0=B4=D0=BE=D0=BC=D0=B8=D1=82=D0=B5 =D0=BD=D0=B5=D0=BC=
=D0=B5=D0=B4=D0=BB=D0=B5=D0=BD=D0=BD=D0=BE =D0=BE=D1=82=D0=BF=D1=80=D0=B0=
=D0=B2=D0=B8=D1=82=D0=B5=D0=BB=D1=8F, =D0=BD=D0=B5 =D1=80=D0=B0=D1=81=D0=BA=
=D1=80=D1=8B=D0=B2=D0=B0=D0=B9=D1=82=D0=B5 =D1=81=D0=BE=D0=B4=D0=B5=D1=80=
=D0=B6=D0=B0=D0=BD=D0=B8=D0=B5 =D0=B4=D1=80=D1=83=D0=B3=D0=B8=D0=BC =D0=BB=
=D0=B8=D1=86=D0=B0=D0=BC, =D0=BD=D0=B5 =D0=B8=D1=81=D0=BF=D0=BE=D0=BB=D1=8C=
=D0=B7=D1=83=D0=B9=D1=82=D0=B5 =D0=B5=D0=B3=D0=BE =D0=B2 =D0=BA=D0=B0=D0=BA=
=D0=B8=D1=85-=D0=BB=D0=B8=D0=B1=D0=BE =D1=86=D0=B5=D0=BB=D1=8F=D1=85, =D0=
=BD=D0=B5 =D1=85=D1=80=D0=B0=D0=BD=D0=B8=D1=82=D0=B5 =D0=B8 =D0=BD=D0=B5 =
=D0=BA=D0=BE=D0=BF=D0=B8=D1=80=D1=83=D0=B9=D1=82=D0=B5 =D0=B8=D0=BD=D1=84=
=D0=BE=D1=80=D0=BC=D0=B0=D1=86=D0=B8=D1=8E =D0=BB=D1=8E=D0=B1=D1=8B=D0=BC =
=D1=81=D0=BF=D0=BE=D1=81=D0=BE=D0=B1=D0=BE=D0=BC.
