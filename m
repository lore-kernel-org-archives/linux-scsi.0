Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2971836E9
	for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 21:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714427874; cv=none; b=FLbX3+4lVwmIVH03K+ZkLN4boaIJTfvKS4Cl9nhORPEeqgiXDSRO3v4+jdv3kaAozEI77WFx/wOXuuhX97fFEV8xjbqmr107BFxbvavXJgOcRvFmSvJyAr1YKw2W5RlJwNq4jPsUkXnyQZ2IpcWLTJoagLj0xrbECkN1E7yZieg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714427874; c=relaxed/simple;
	bh=M5aORdSw1Tqr74QY9p5Xf25U1JP+6sEmuqDyOKMuRD0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Il8miw2QN6lNVU2jppUZww/WCY3oG8fgsAUcBKI92O4m8btjLy70CPrKGUaqDa/AuP9ZTTgqikERuJu9NmDF0zNXiOGw+JVLPzRrXSBQKgxiPcQklo2IZCzYdBRjmy4Ey8NIN1CDrKs+l4o5f3Frm//Lsn84JUGaGmySq9o/i3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EIe2T2Bl; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EIe2T2Bl"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6a08073fe48so3703986d6.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Apr 2024 14:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714427872; x=1715032672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2ugQk73brDtDUV2N3t4JwztVHa8p7JnsvdpuuapZzu8=;
        b=EIe2T2Bl6+ctXjgTcwVJ0F84YbaQmHQxL7MddPonfSvV1VZoTb6MdaA0sQwZ4b7MpG
         raW/DTmmcvls2q/4Vp9kJ0YzFo7HBQ5+7oP7df2OBjnEARpSGran0yukATuh8byCi6nH
         Z+eCHqiWdl+bcWxAxfHwlI7x1GmG1juhUAAN8Tp1fvHSVaNL6NdJe4KqIJfOSgbPXhe1
         VcSGksvAx7cG5FP6Q7xL5tOcBbp0qq9YknulED+c00ij4OZQA7Tyy9ic+5H3Lud4idB6
         ctfajUszvsf36jN8IqiGC5Hn3Le9d+u9s2MuQaCvURkb8WW0PEEOPWFV/igcFgrXpQMX
         7HAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714427872; x=1715032672;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ugQk73brDtDUV2N3t4JwztVHa8p7JnsvdpuuapZzu8=;
        b=pIgAjDDqtKcVj2tyLrXvnarIX16h0/x5OlVVsRC7ak9eBwCGg4FTuOrMTF8kxUd6Gp
         txqjMq+bmRgeFCA29QzuTlk7ffaf9+EqM/fDfajeRCFUfU6pfma1Q0QaB+TiNGQxdIlf
         Lzfof47+YAMy6Rx4qWwDK4iuckeQRRBumKyBw9hCltRYI66fvFb3pirdy/0Rdzs8J3Tj
         byOP7Vk/Kqs7+KbAH/RAt3PvgFXrUJ4NuZf152DAd++jJ20lRIdPembmXq5Nj16y9V6c
         +pynfq2Fr+aqlOvuF5k2fCJbMhYYG418223sbohKO4bU4sj/+ENoO31QclxDTQ2Uia8U
         5BZw==
X-Gm-Message-State: AOJu0YxehOZ31PpxrQlk/o7hrAK39jMg0xJ8L7SWlnSTeXX6mhXrp3u0
	+t2l7OYA9NGyaN6gOt7VPnatMZkN8Ys0775PW5X1oXedPphzvNdDMiN/NA==
X-Google-Smtp-Source: AGHT+IGJO2QTmNJRvmS1pH1VzbQD5rcdj+mVO93AjTpsvyln/K3AMDu24sduYl6z4zAXwIETbNk5Jw==
X-Received: by 2002:a05:6214:4008:b0:6a0:b2e4:583c with SMTP id kd8-20020a056214400800b006a0b2e4583cmr11492976qvb.3.1714427871852;
        Mon, 29 Apr 2024 14:57:51 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mh12-20020a056214564c00b006a0cc9ef675sm1528280qvb.16.2024.04.29.14.57.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2024 14:57:51 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/8] Update lpfc to revision 14.4.0.2
Date: Mon, 29 Apr 2024 15:15:39 -0700
Message-Id: <20240429221547.6842-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.2

This patch set contains updates to log messaging, a bug fix related to
unloading of the driver, clean up patches regarding the abuse of a global
spinlock, and support for 32 byte CDBs.

The patches were cut against Martin's 6.10/scsi-queue tree.

Justin Tee (8):
  lpfc: Change default logging level for unsolicited CT MIB commands
  lpfc: Update logging of protection type for T10 DIF I/O
  lpfc: Clear deferred RSCN processing flag when driver is unloading
  lpfc: Introduce rrq_list_lock to protect active_rrq_list
  lpfc: Change lpfc_hba hba_flag member into a bitmask
  lpfc: Add support for 32 byte CDBs
  lpfc: Update lpfc version to 14.4.0.2
  lpfc: Copyright updates for 14.4.0.2 patches

 drivers/scsi/lpfc/lpfc.h           |  62 ++++----
 drivers/scsi/lpfc/lpfc_attr.c      |  31 ++--
 drivers/scsi/lpfc/lpfc_bsg.c       |   3 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  24 ++--
 drivers/scsi/lpfc/lpfc_els.c       |  43 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 133 ++++++++----------
 drivers/scsi/lpfc/lpfc_hw4.h       |   8 ++
 drivers/scsi/lpfc/lpfc_init.c      | 119 +++++++---------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  63 +++++----
 drivers/scsi/lpfc/lpfc_nvme.c      |  27 ++--
 drivers/scsi/lpfc/lpfc_nvmet.c     |   9 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  71 ++++++----
 drivers/scsi/lpfc/lpfc_scsi.h      |  32 +++--
 drivers/scsi/lpfc/lpfc_sli.c       | 218 +++++++++++++----------------
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 15 files changed, 432 insertions(+), 413 deletions(-)

-- 
2.38.0

