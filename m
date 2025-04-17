Received: from mx2.usergate.com (unknown [46.229.79.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4421DE4FC;
	Thu, 17 Apr 2025 05:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744869297; cv=none; b=fxc7sPdUJrD3dqZSCB3TAqecPt+BfhqXEtiNw/FdbOjxfuBVrOKnri/7dOaYZpct8QZzJwnWTBnrJ0pO7F7J1amGzV5eGfWLNGSTp7XTBNEsf5URB76/idcko9ehr4izidUzTpXhl06zDl/ygfMWTqZXIfb+G18vr25GnIW5SD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744869297; c=relaxed/simple;
	bh=Od0yWLlZbKBUa36Zzz8mWeVChx1sO/abmn2CfT7dci0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2lCNyleSlEduZCGlRuz25utRghwGbMn57S0uBF6TQh1EfsUjE7FJl0epmpgTq+QmAIVnI9w4YWXJsB5wln8i8Q5AtyurIp+MWRQy1+Zx07R8yMBqqHfC7KeBqX2nrRwjKrz2TrlZ3yRJOX20Bwl8Kcx66LgMxe+yDJT0r8Jp8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 B4D8733438D542E28A1FEB29109F5909; Thu, 17 Apr 2025 11:20:39 +0700
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
To: <hare@suse.org>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,"Boris
 Belyavtsev" <bbelyavtsev@usergate.com>
Subject: [PATCH 3/3] scsi: aic79xx: check for non-NULL scb in
	 ahd_linux_queue_abort_cmd
Date: Thu, 17 Apr 2025 11:20:15 +0700
Message-ID: <20250417042015.780823-4-bbelyavtsev@usergate.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250417042015.780823-1-bbelyavtsev@usergate.com>
References: <20250417042015.780823-1-bbelyavtsev@usergate.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset="utf-8"
X-ClientProxiedBy: ESLSRV-EXCH-01.esafeline.com (192.168.90.36) To
 nsk02-mbx01.esafeline.com (10.10.1.35)
X-Message-Id: CD07E1B6428D475B95C80F94AC46F7AF
X-MailFileId: 3A8A392F50A64BE0AC8477CCC4284E4D

possible NULL pointer dereference in case hardware returns invalid scb
index

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Boris Belyavtsev <bbelyavtsev@usergate.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic7=
9xx_osm.c
index 17dfc3c72110..7d40c7d80411 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2265,7 +2265,8 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
                 * and hope that the target responds.
                 */
                pending_scb =3D ahd_lookup_scb(ahd, active_scbptr);
-               pending_scb->flags |=3D SCB_RECOVERY_SCB|SCB_ABORT;
+               if (pending_scb =3D=3D NULL)
+                       pending_scb->flags |=3D SCB_RECOVERY_SCB|SCB_ABORT;
                ahd_outb(ahd, MSG_OUT, HOST_MSG);
                ahd_outb(ahd, SCSISIGO, last_phase|ATNO);
                scmd_printk(KERN_INFO, cmd, "Device is active, asserting AT=
N\n");
--
2.43.0

=D0=9D=D0=B0=D1=81=D1=82=D0=BE=D1=8F=D1=89=D0=B5=D0=B5 =D1=8D=D0=BB=D0=B5=
=D0=BA=D1=82=D1=80=D0=BE=D0=BD=D0=BD=D0=BE=D0=B5 =D1=81=D0=BE=D0=BE=D0=B1=
=D1=89=D0=B5=D0=BD=D0=B8=D0=B5 =D1=81=D0=BE=D0=B4=D0=B5=D1=80=D0=B6=D0=B8=
=D1=82 =D0=B8=D0=BD=D1=84=D0=BE=D1=80=D0=BC=D0=B0=D1=86=D0=B8=D1=8E =D0=BA=
=D0=BE=D0=BD=D1=84=D0=B8=D0=B4=D0=B5=D0=BD=D1=86=D0=B8=D0=B0=D0=BB=D1=8C=D0=
=BD=D0=BE=D0=B3=D0=BE =D1=85=D0=B0=D1=80=D0=B0=D0=BA=D1=82=D0=B5=D1=80=D0=
=B0, =D0=B0 =D1=82=D0=B0=D0=BA=D0=B6=D0=B5 =D0=BC=D0=BE=D0=B6=D0=B5=D1=82 =
=D1=81=D0=BE=D0=B4=D0=B5=D1=80=D0=B6=D0=B0=D1=82=D1=8C =D0=BA=D0=BE=D0=BC=
=D0=BC=D0=B5=D1=80=D1=87=D0=B5=D1=81=D0=BA=D1=83=D1=8E =D1=82=D0=B0=D0=B9=
=D0=BD=D1=83 =D0=9E=D0=9E=D0=9E =C2=AB=D0=AE=D0=B7=D0=B5=D1=80=D0=B3=D0=B5=
=D0=B9=D1=82=C2=BB =D0=98=D0=9D=D0=9D 5408308256 (UserGate). =D0=9D=D0=B5=
=D0=BF=D1=80=D0=B0=D0=B2=D0=BE=D0=BC=D0=B5=D1=80=D0=BD=D0=BE=D0=B5 =D0=B8=
=D1=81=D0=BF=D0=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D0=BD=D0=B8=D0=B5 / =
=D1=80=D0=B0=D1=81=D0=BA=D1=80=D1=8B=D1=82=D0=B8=D0=B5 =D1=82=D0=B0=D0=BA=
=D0=BE=D0=B2=D0=BE=D0=B9 =D0=B8=D0=BD=D1=84=D0=BE=D1=80=D0=BC=D0=B0=D1=86=
=D0=B8=D0=B8 =D0=B7=D0=B0=D0=BF=D1=80=D0=B5=D1=89=D0=B5=D0=BD=D0=BE. =D0=95=
=D1=81=D0=BB=D0=B8 =D0=B2=D1=8B =D0=BF=D0=BE=D0=BB=D1=83=D1=87=D0=B8=D0=BB=
=D0=B8 =D0=BD=D0=B0=D1=81=D1=82=D0=BE=D1=8F=D1=89=D0=B5=D0=B5 =D1=81=D0=BE=
=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B5 =D0=BF=D0=BE =D0=BE=D1=88=D0=B8=
=D0=B1=D0=BA=D0=B5, =D0=BF=D0=BE=D0=B6=D0=B0=D0=BB=D1=83=D0=B9=D1=81=D1=82=
=D0=B0, =D1=81=D0=B2=D1=8F=D0=B6=D0=B8=D1=82=D0=B5=D1=81=D1=8C =D1=81 =D0=
=BE=D1=82=D0=BF=D1=80=D0=B0=D0=B2=D0=B8=D1=82=D0=B5=D0=BB=D0=B5=D0=BC =D0=
=B8 =D1=83=D0=B4=D0=B0=D0=BB=D0=B8=D1=82=D0=B5 =D0=B2=D1=81=D0=B5 =D0=BA=D0=
=BE=D0=BF=D0=B8=D0=B8 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D1=
=8F. =D0=9D=D0=B0=D1=81=D1=82=D0=BE=D1=8F=D1=89=D0=B5=D0=B5 =D1=81=D0=BE=D0=
=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B5 =D0=BD=D0=B5 =D1=8F=D0=B2=D0=BB=D1=
=8F=D0=B5=D1=82=D1=81=D1=8F =D0=BE=D1=84=D0=B5=D1=80=D1=82=D0=BE=D0=B9. =D0=
=A1=D0=B2=D0=B5=D0=B4=D0=B5=D0=BD=D0=B8=D1=8F =D0=BE =D0=BF=D0=BB=D0=B0=D0=
=BD=D0=B8=D1=80=D1=83=D0=B5=D0=BC=D1=8B=D1=85 =D0=BA =D1=80=D0=B0=D0=B7=D1=
=80=D0=B0=D0=B1=D0=BE=D1=82=D0=BA=D0=B5 =D1=82=D0=B5=D1=85=D0=BD=D0=BE=D0=
=BB=D0=BE=D0=B3=D0=B8=D1=87=D0=B5=D1=81=D0=BA=D0=B8=D1=85 =D1=80=D0=B5=D1=
=88=D0=B5=D0=BD=D0=B8=D1=8F=D1=85, =D1=86=D0=B5=D0=BD=D0=BE=D0=B2=D0=BE=D0=
=B9 =D0=BF=D0=BE=D0=BB=D0=B8=D1=82=D0=B8=D0=BA=D0=B5, =D0=B8=D0=BD=D1=8B=D0=
=B5 =D1=81=D0=BE=D0=B4=D0=B5=D1=80=D0=B6=D0=B0=D1=89=D0=B8=D0=B5=D1=81=D1=
=8F =D0=B2 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D1=81=D0=
=B2=D0=B5=D0=B4=D0=B5=D0=BD=D0=B8=D1=8F =D0=B8=D0=BC=D0=B5=D1=8E=D1=82 =D0=
=B8=D1=81=D0=BA=D0=BB=D1=8E=D1=87=D0=B8=D1=82=D0=B5=D0=BB=D1=8C=D0=BD=D0=BE=
 =D0=B8=D0=BD=D1=84=D0=BE=D1=80=D0=BC=D0=B0=D1=86=D0=B8=D0=BE=D0=BD=D0=BD=
=D1=8B=D1=85 =D1=85=D0=B0=D1=80=D0=B0=D0=BA=D1=82=D0=B5=D1=80 =D0=B8 =D0=BD=
=D0=B5 =D0=B4=D0=BE=D0=BB=D0=B6=D0=BD=D1=8B =D0=B1=D1=8B=D1=82=D1=8C =D1=80=
=D0=B0=D1=81=D1=86=D0=B5=D0=BD=D0=B5=D0=BD=D1=8B =D0=B2 =D0=BA=D0=B0=D1=87=
=D0=B5=D1=81=D1=82=D0=B2=D0=B5 =D0=BE=D1=81=D0=BD=D0=BE=D0=B2=D0=B0=D0=BD=
=D0=B8=D1=8F =D0=B4=D0=BB=D1=8F =D0=B2=D0=BE=D0=B7=D0=BD=D0=B8=D0=BA=D0=BD=
=D0=BE=D0=B2=D0=B5=D0=BD=D0=B8=D1=8F =D0=BE=D0=B1=D1=8F=D0=B7=D0=B0=D1=82=
=D0=B5=D0=BB=D1=8C=D1=81=D1=82=D0=B2 =D0=BB=D1=8E=D0=B1=D0=BE=D0=B3=D0=BE =
=D1=81=D0=B2=D0=BE=D0=B9=D1=81=D1=82=D0=B2=D0=B0.
