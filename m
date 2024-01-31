Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6622364
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660489; cv=none; b=YC4tKfG4RJPitwTIhmPH45ziuSE4SN1Qp7reezAgWxw96Hqtx8QX0i33N3vSS7iFkI4pc73B+mHRKRxpIddYF9ex5SBUWPFDhAKOUnOWyjHhdDqIUGpHKjDEy3z3/+hR8tkGInN5H4WunD0Cr4Om4041vn6D/YpnD/hoDSODSc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660489; c=relaxed/simple;
	bh=gDm2BaCy0BUtg05iJ7ByS6gA0fToR3Bnsk3/MRUPz48=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ukew3He6drDZNU7h7tWdRIRK3KYLfVTUF/qyKGPnEIphJgR4JP1DP08zo22ERDzjikIqfQYKMrvyhjPwXouFqvOAC6QyLIrelq4ATCbqGj9lZO9pxT5Inc5kCebMHmi7JC09Zh+yiCdX5hL9x5y2/ONaiwvLdi3wlCIef7Va1VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpqhtjYz; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpqhtjYz"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-42a9c3f31e0so4802191cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660486; x=1707265286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G02PxKYH/d/xuogNFC50KNVfD5cQDSP0cX0mGmNZDcM=;
        b=VpqhtjYzgDeSqnwX86WrMoSm1Zb1gAr+n4z4k59H7EdoWh4+9ev9i68J5RynJlihCe
         yWQoMLuO0wHSP1wDCIs0RV7zw+1hXhlCqyI8+sVleJnxq8Tdo/MdD6XF3QZv2LuI/iMm
         vJVkKdRw/JVUvkqGFdugnyaI/6urSXpOL2d8FjIXSqDzus5ueuc4mNioXK7X0sDDEy3O
         FX6Zqw2jQR3E0Azcb8VviqJIBKm3z9JBbPKUFS8/9iZrsoFnhGFq4h2W9BEYcW7N25eQ
         7y92XLGUTJQIKS6XbyVAAT0c0q5Q6nEkhMp/Hatn540CMtpJZ2pRnwbYXXuuM9r+Ti5H
         j2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660486; x=1707265286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G02PxKYH/d/xuogNFC50KNVfD5cQDSP0cX0mGmNZDcM=;
        b=dQMh9YHzrFYff2+2J+Gghin73DOw46VIGDyGajHemXF62V5EXcJa3jvDVmBDJL1Oba
         oXcqj7+zEvOUy970/pOlVlFjoaC0tWHJi6cSxHD/JhI7T0CJNkpRsKfqb2cMl5CbxtSC
         0W4214H7A/5GjRyg5rFJINi86KYbNzlv1krU0+dnsFEhImgAERNWA9hlYdB6QqMjX/jz
         FKgaM1DiOBkpWvlZBonBjANIYNtRZmJ+cV6NdZGLjLNRHhjAgMuSjgBBOABlUnDE2BxU
         4Vq7ey5p/6De1+bSz7Oz1XeQPpDaFJdbMiGWsTVsrIPMizBQ6jXDOtiNqy95NzfWdpmd
         FwBQ==
X-Gm-Message-State: AOJu0Yzl5j8bOg9E5cm+nKrdJZWZyRgiq7cX1K3I5KJgRt33AYpDiinS
	UW2HUOh7jmhGzhcNIcpZ51mOPnrJe+NIidolEsgCyUUcF2vBjTHDDwlwDaeu
X-Google-Smtp-Source: AGHT+IEFarVhUwzOhfa5tHSAIO/4wEpuszk9O13BQ/DOuoRRQ2PnaKwHWrg6fbusiHAfq0pbjhGNJQ==
X-Received: by 2002:a05:6214:d0f:b0:68c:6bc0:bfb with SMTP id 15-20020a0562140d0f00b0068c6bc00bfbmr170346qvh.2.1706660486355;
        Tue, 30 Jan 2024 16:21:26 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:26 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/17] lpfc: Update lpfc to revision 14.4.0.0
Date: Tue, 30 Jan 2024 16:35:32 -0800
Message-Id: <20240131003549.147784-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.0

This patch set contains fixes identified by static code analyzers, updates
to log messaging, bug fixes related to discovery and congestion management,
and clean up patches regarding the abuse of shost lock in the driver.

The patches were cut against Martin's 6.9/scsi-queue tree.

Justin Tee (17):
  lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list
  lpfc: Fix possible memory leak in lpfc_rcv_padisc
  lpfc: Use sg_dma_len API to get struct scatterlist's length
  lpfc: Remove D_ID swap log message from trace event logger
  lpfc: Allow lpfc_plogi_confirm_nport logic to execute for Fabric nodes
  lpfc: Remove NLP_RCV_PLOGI early return during RSCN processing for
    ndlps
  lpfc: Fix failure to delete vports when discovery is in progress
  lpfc: Add condition to delete ndlp object after sending BLS_RJT to an
    ABTS
  lpfc: Save FPIN frequency statistics upon receipt of peer cgn
    notifications
  lpfc: Move handling of reset congestion statistics events
  lpfc: Remove shost_lock protection for fc_host_port shost APIs
  lpfc: Change nlp state statistic counters into atomic_t
  lpfc: Protect vport fc_nodes list with an explicit spin lock
  lpfc: Change lpfc_vport fc_flag member into a bitmask
  lpfc: Change lpfc_vport load_flag member into a bitmask
  lpfc: Update lpfc version to 14.4.0.0
  lpfc: Copyright updates for 14.4.0.0 patches

 drivers/scsi/lpfc/lpfc.h           |  94 +++---
 drivers/scsi/lpfc/lpfc_attr.c      | 107 +++----
 drivers/scsi/lpfc/lpfc_bsg.c       |   8 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 154 +++++-----
 drivers/scsi/lpfc/lpfc_debugfs.c   |  14 +-
 drivers/scsi/lpfc/lpfc_els.c       | 446 +++++++++++++----------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 350 ++++++++++------------
 drivers/scsi/lpfc/lpfc_hw4.h       |   4 +-
 drivers/scsi/lpfc/lpfc_init.c      | 137 +++++----
 drivers/scsi/lpfc/lpfc_mbox.c      |  10 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  91 +++---
 drivers/scsi/lpfc/lpfc_nvme.c      |  20 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |  14 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  10 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  56 ++--
 drivers/scsi/lpfc/lpfc_version.h   |   6 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  69 ++---
 17 files changed, 717 insertions(+), 873 deletions(-)

-- 
2.38.0

