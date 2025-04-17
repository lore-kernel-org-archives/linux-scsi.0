Received: from mx2.usergate.com (unknown [46.229.79.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A816F1E1DEB;
	Thu, 17 Apr 2025 05:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744869304; cv=none; b=meL2RgrN3fEtni2Rom5refpOWTRn9Az/5Djs+inh5ZEDR8gKcUhOh9hsIfIQxQTbAydT6E9fGHPziUDHW4F+VK2TC0FHf09N80m6Jl7INhb+Uw4k4f3P5wuHFVH03J1xcwstPWcOFoKjZFffKIRDhCeZwU7e1ICXSdfDoXmoyy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744869304; c=relaxed/simple;
	bh=QolKNjhVzMoUZI6l4ywmFBMt62EtnAuW+iC8PalOFIk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HRcW2G8L6cmwV8k5NdVohCh0I+VqyE9Yz6XnTZZkSwafR+7jVnStJ3r0txCTxJ6l8EOq0tQCZbF2j4qmLyzBtuEU622CaH6MTy6FZSWnk1znlpLEROwUYMKu3Qt5+2P4PLSvqbg6YoLwvfz3cFRO4tS1JzEV159gHM5YEpZHOpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 1EA52C4FE87A475F88E770CC6BBE1020; Thu, 17 Apr 2025 11:20:39 +0700
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
To: <hare@suse.org>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,"Boris
 Belyavtsev" <bbelyavtsev@usergate.com>
Subject: [PATCH 2/3] scsi: aic79xx: check for non-NULL scb in ahd_handle_pkt_busfree
Date: Thu, 17 Apr 2025 11:20:14 +0700
Message-ID: <20250417042015.780823-3-bbelyavtsev@usergate.com>
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
X-Message-Id: 9D225A5F3469407A9B34E96E4624CC77
X-MailFileId: D35C4025561B44B7AB63E0C5CC12AA03

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
