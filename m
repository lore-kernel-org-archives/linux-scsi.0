Received: from mx2.usergate.com (unknown [46.229.79.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A051DE889;
	Thu, 17 Apr 2025 04:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.229.79.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744865883; cv=none; b=RlCH+wr68eCYrfbQrw3DRpbjlYa7gTHl/MMZ1I54uOkcZRzf6LDmQYm4DhJXXb6oWAO2g4u1Nems91wOOI18waVAnjtVn4w61QLz1E0zwmKHxiSWfRBgSVkWQCgaT8aKCMyY/K0VP58yC2cEoLWfJ4sbB37ZZbpVUxNjbIeJc+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744865883; c=relaxed/simple;
	bh=QUCSGN8Amri6gWsa/LlkBd+tPzIdUsEmXusdXXyHkxM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CgE+KJQ6DWT+bDtxrRNCqS/TGCsP2qYE+SxX7bhFpMFnTTWiFDAPLcDiFFLgrJB/O0DyhjT2JChR+V27tWzXEZyhZ1F1B6uldsp/GSXvTPP5q1oT3iVjpVtVWKwnvQoRjHxZu7EitrwKHg1qSGmLBExDhnkgVCylohcQHu2CuAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com; spf=pass smtp.mailfrom=usergate.com; arc=none smtp.client-ip=46.229.79.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usergate.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usergate.com
Received: from mail.usergate.com[192.168.90.36] by mx2.usergate.com with ESMTP id
	 A3B53BB2C54F469F8E995EE847D2F249; Thu, 17 Apr 2025 11:22:27 +0700
From: Boris Belyavtsev <bbelyavtsev@usergate.com>
To: <hare@suse.com>
CC: <linux-scsi@vger.kernel.org>,<linux-kernel@vger.kernel.org>,"Boris
 Belyavtsev" <bbelyavtsev@usergate.com>
Subject: [PATCH 0/3] aic79xx: Add some non-NULL checks
Date: Thu, 17 Apr 2025 11:22:17 +0700
Message-ID: <20250417042220.782230-1-bbelyavtsev@usergate.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: ESLSRV-EXCH-01.esafeline.com (192.168.90.36) To
 nsk02-mbx01.esafeline.com (10.10.1.35)
X-Message-Id: 3D6BE4F57BEA488C8529B28B12F87014
X-MailFileId: A2EA105D036349AB9667BB5F567F5B1C

Add non-NULL checks for ahd_lookup_scb return value.
scb could be NULL if an attacker has special equipment to return
certain values to the driver.

Belyavtsev Boris (1):
  scsi: aic79xx: check for non-NULL scb in ahd_handle_seqint

Boris Belyavtsev (2):
  scsi: aic79xx: check for non-NULL scb in ahd_handle_pkt_busfree
  scsi: aic79xx: check for non-NULL scb in ahd_linux_queue_abort_cmd

 drivers/scsi/aic7xxx/aic79xx_core.c | 15 +++++++++------
 drivers/scsi/aic7xxx/aic79xx_osm.c  |  3 ++-
 2 files changed, 11 insertions(+), 7 deletions(-)

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
