Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42473BADB6
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599044; cv=none; b=K/7B/xS22glrjLJBU6aWtO9aL0PThBoXvbXgDhisQMdwzK5T8SwVYxov74eof4WdSHQWJTNpbsQCCbM5dxwYb0Z29fh86+/yEMxGZDc/7fl0SqEm12VJi3gtFwGDLHZTVNmb0b01wotuLeSj7giIqwrVjoXnsE9Lclxyvpy8li8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599044; c=relaxed/simple;
	bh=gbD4FCJy0BQ4W1zXJKiTk9oj2celhkKljTujiWAVRVs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f+Tj20cI/qqdj8enFLUNl2Ke78+UXeAyhFqHN7a7Zx+qeECnPZ0TvErm42Q23jOz1hUhqBYc+cMV7yNFzezEQhhuemLwUMO8qmPWZpW17LZE0EuQR1fh0Yfdr8+R6xiKxYRK58hzBDmz++/4JzDNXTnq5araPMDWxk+swNNcJ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jugTdIH6; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jugTdIH6"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-91587626ae1so122450585a.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599042; x=1781203842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o1nKnoCKwwPu7b7Objh9jn1z5sqhtLDS46+7PHLh/Ds=;
        b=jugTdIH6DlAvJ3Q7mIyt8Iu14iW1QiLhcmeV9ZTkTE6YZo3keNTTsUCxYHMTbGFxXq
         7UlwvVUq1+jXd1B2thY2YltzAxyKDnFVBh9C0DAbuqZEZlojj8K80vb2hCEV8jH+HwvU
         mJQgUhr/MJLL7bsQumdy93NNh/uVhuWmHJgTe/XuA3isaPK5Dd7EpIo9q2U3m52i5b20
         RF1J0w1ujxgMjHPQ+UNIfXQYeR6gRQiH2eJ7qMF5w7yD5PPVC8KQHuUJo3+i2GIYs2zu
         C61q+VcyZXFsOYkLhtx3PLoD60kI00zHcLPbeEvbgCVggCPotOd2mx/cqrBIi4FyT0BK
         YAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599042; x=1781203842;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1nKnoCKwwPu7b7Objh9jn1z5sqhtLDS46+7PHLh/Ds=;
        b=HlFZcC2D5+7DZL3NNN9FKpH7bnB60Lw37OqSCc7JgdrMxjyvjar2TMRujb9u2rIbLW
         aILrxEefVqR76DYl0I6JSlNrWD5ce5e2dgFW1MICfYaNMxrckWMslJL8PXLPp44Y8RZg
         RN02oiGqBs0PuBH/cK8hdq0HheJjMKu+FQzKm2pptQDgxzduDtOIjibrHSo95cHKXwQs
         /QTlacbnYV4/+xUKU4S3zKBo9Ysj0U32++R01MlzEV5sNN7V7FemT8gwa5J0uk6LBoZe
         F+GMd4khqzBDVnALcdVG/SNdQTL+7G7jOvjeKQv3NntUaILJB9hcWgYgOx13xwb87zeR
         82AQ==
X-Gm-Message-State: AOJu0Yz/QpL5hsafqhAubcFSPY24HYRCP+8z1TU+CyQ8QgEPC8jAWsII
	K8kPKMty7165vKhgIuClQPlhh3Dey9i33SuYuSr5rV9m8Vwy0PhZyNsDAyTfn5N2
X-Gm-Gg: Acq92OHVKwkRlL27DuLm64NueWJeh8ezeFOO5WL+/wYReyKhhbqD+xIsI9/iY/eyWKq
	xiSJZ7Ossvctreswmy7QCG3x+fZay82FrC/wjT3/LjBSSEe96NjCFyWMx8NS+mcVNHl7T37gcI7
	FAl9SW+krIegCbWSE9gYW83Rv2OOO9mnQ9Uf+vpoCQIg8Iz8e/izh+U5qNw7812/UJtMh4vfvoY
	SO8Wz1Dz8Yx88NiaVf7+iZHhsKSNYN8mO2xPo9aTePKwSFmgx3rdv0YTp6qmiBqXbw7w5E7U9Um
	DC9amhYFInp1wOHqWwTvhKyRhLF2C7BOw5MdbFX795VBL9TqA7j57y4VOGlAXrhMmGod0ISZzsD
	J8fcDyQr28i63ZdCqZwRJlrQKKuNRSZpAlqAQXXhUOaraAFVcN6AZR1pNS/ulp+pJs5Szne8LpT
	NzNjUY05+ky55M2DyX5PqIxsgkLoOyRMmX/a4fVOuHV1OghfUpkiAtVKfOs3aa7pKHRHzoYxZoM
	y8CjdPV+5jHSmgX6tM9kCi6zgJHk1DHIc+bin2CdRMXwffa6+OrIw==
X-Received: by 2002:a05:620a:261e:b0:915:9531:f6d2 with SMTP id af79cd13be357-915a9c75563mr76704785a.10.1780599041854;
        Thu, 04 Jun 2026 11:50:41 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:41 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/14] Update lpfc to revision 15.0.0.1
Date: Thu,  4 Jun 2026 12:29:23 -0700
Message-Id: <20260604192937.65605-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 15.0.0.1

This patch set contains bug fixes related to cleanup handling in both
normal and error paths, discovery rework for large SAN configurations, and
refactoring of duplicate code.

The patches were cut against Martin's 7.2/scsi-queue tree.

Justin Tee (14):
  lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
  lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
    set
  lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
    cmd
  lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
  lpfc: Add handling for when PLOGI or PRLI is dropped during link
    failure
  lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery
    sequence
  lpfc: Rework I/O flush ordering when unloading driver
  lpfc: Improve PLOGI retry handling for large SAN configurations
  lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received
  lpfc: Remove slowpath cqe process limiter in slow ring event handler
  lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL
    unavailable
  lpfc: Update ELS ACC logging for diagnostic troubleshooting
  lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
  lpfc: Update lpfc version to 15.0.0.1

 drivers/scsi/lpfc/lpfc_bsg.c       |   5 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |  12 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  19 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   2 +-
 drivers/scsi/lpfc/lpfc_els.c       | 427 +++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 100 +++----
 drivers/scsi/lpfc/lpfc_init.c      |  16 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  86 +++++-
 drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 246 ++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli.h       |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 13 files changed, 707 insertions(+), 216 deletions(-)

-- 
2.38.0

