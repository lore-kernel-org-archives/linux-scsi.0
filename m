Received: from mx2.usergate.com (unknown [46.229.79.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012381DE3AC;
	Thu, 17 Apr 2025 04:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744865878; cv=none; b=XZ7KRCbEQ4RCc5defrI4AZVFpUmxXNDvwAK4uVjt20djJg4iU0VJM1Bm05gBTFbUEG4Vx2BK3smSl4uqGSH+SpKLlpWHo0aGQchEOgY4gEdhWuUBpkdN2tn7y22wKrDHKVYN3YEQPonNaapO7WSng4WzwUuReyz7EtDvWjB2Wd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744865878; c=relaxed/simple;
	bh=QolKNjhVzMoUZI6l4ywmFBMt62EtnAuW+iC8PalOFIk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJNrlaSXgwZeBlGlFFb0Uk9EZ9FdwQxmKHmc+pM51Au5Hgv7R1JpuO5323FzfNPHq+q8H0clz1MQoP7KZPLjFzIfOqRGm1Desl0fXkdb/SgBF64U6xjZoocWAW2AJAWoG81qRkZESmZ5oMEw0MHSHyENvnFGqiu1kTILVzYTIhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 0DCB4AD3AEB144148BACF59E4357CE38; Thu, 17 Apr 2025 11:22:27 +0700
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
To: <hare@suse.com>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,"Boris
 Belyavtsev" <bbelyavtsev@usergate.com>
Subject: [PATCH 2/3] scsi: aic79xx: check for non-NULL scb in ahd_handle_pkt_busfree
Date: Thu, 17 Apr 2025 11:22:19 +0700
Message-ID: <20250417042220.782230-3-bbelyavtsev@usergate.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250417042220.782230-1-bbelyavtsev@usergate.com>
References: <20250417042220.782230-1-bbelyavtsev@usergate.com>
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
X-Message-Id: B375174590E74FA598FBA39598C8A588
X-MailFileId: 756730C677CF4547BE74AE673ACE2D86

If hardware returns invalid scbid scb could be NULL

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Boris Belyavtsev <bbelyavtsev@usergate.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic=
79xx_core.c
index ff9ae0f8e153..27ec31457e7d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2997,9 +2997,10 @@ ahd_handle_pkt_busfree(struct ahd_softc *ahd, u_int =
busfreetime)
                ahd_print_path(ahd, scb);
                printk("Unexpected PKT busfree condition\n");
                ahd_dump_card_state(ahd);
-               ahd_abort_scbs(ahd, SCB_GET_TARGET(ahd, scb), 'A',
-                              SCB_GET_LUN(scb), SCB_GET_TAG(scb),
-                              ROLE_INITIATOR, CAM_UNEXP_BUSFREE);
+               if (scb !=3D NULL)
+                       ahd_abort_scbs(ahd, SCB_GET_TARGET(ahd, scb), 'A',
+                                      SCB_GET_LUN(scb), SCB_GET_TAG(scb),
+                                      ROLE_INITIATOR, CAM_UNEXP_BUSFREE);

                /* Return restarting the sequencer. */
                return (1);
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
