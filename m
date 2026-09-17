Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE653749E8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682253; cv=none; b=YPtMe+nqOA1jWm+tfgyCxZrvXEIjWB/BNdqyKgZl5+QxFltv2Z77kKC89qdrT6DmUg+WvkQ2Yhahs7FjD1mJI1d1NMA5CfPmAPf23eLrbXprAh0wwBBcatCBfYeFMbAJC9XhrVp3sL1czDyofvNEiKTs3nxY0E6m13iZhTX/zMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682253; c=relaxed/simple;
	bh=B6RMpMRgQrXzlvPmC9oVse2YGa2A6Gz8AEtiJuTMOSc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ESBaxgukNrO05XhDRGQeNHmRdPFFx7V/U7LjGB9pr2vTvfZ5tVSoYs6OmL/N5qviGDcYowXn1Ku4cc64/gI6jm3OB+7jX8iFswodDUkHPnC6Sy3wl6NPXwbY1W41pA/50GOyH7ykHVc1b1KUeAQB4JCkOlHiv9zWukp5jRnNlgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKURWRM2; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKURWRM2"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-86b90133ae8so90517b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682250; x=1790287050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HcRO7BO+mpnvWNJPeojCKfbdZgXKT3fUqHIfyN44DpI=;
        b=IKURWRM2KdFBiHgFf+pcevDQf9FO5yPiLIFRILi5FnxRQ2dm7X0/XMH9TVGw/dwLx0
         qA5Th+2b6bUTV9FR6y0cp/p/4kO9trNAgH262oPy9gMy9szgK4rAEvivnLEtx+KFbI1i
         S+T/at/wWJcy5SbZXpRIh4v3mLlivYMMHH+nYldzjaEqTUbFInoSAWu4AydT2DhpG/MT
         xA7337qYxsHZ0kYrtSM03+7xsJ9sJFudTlXc+dR39XAg+L9+9gWK44rbcN2HaFtEauRY
         wbRNTliM7Bhc0rqBf8jSmB4h7J7zZ64TRoBL8Mtfk3FftiOGuT7j/1rYWWTSo8Ng1gR5
         Gp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682250; x=1790287050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HcRO7BO+mpnvWNJPeojCKfbdZgXKT3fUqHIfyN44DpI=;
        b=0R0bK0lz/gkm6ujRbtZzw6ax0MWbvgTP10JK/YwCSyGLTQljeXdxJ9Mg7n3ienzq5O
         zQon/5g/FtSPCYTU7VKlI843gCKMEfYD6gqF1O74/NSl+thXcDAX9WFxmvZXbeNbAH5R
         Q83fn3IcyyMvTgUTxFFILafOwZHNPDi4/SDBbQ446fyB9a52jCMnThZCg2p6vRLCIAsU
         raIScEOeHDnMVvwc07/5fjgbBxYhU1kia/SnYIuAvclrlBXteY3GQhL0Tx2Kggkb5fJm
         GTrNThTpfzr1ZHSKKaDr1R1EC3+Mkes65Le4Vy66k6ctn+1XIq9utgq8NJTDdntPpB+i
         pBKQ==
X-Gm-Message-State: AFuF++lpPLWHLyPCJpWno/UZ8KcHrvHCndJe4D7zn0jpcJAIrhwNwyQY
	LcR/obW3ZfusG2K4wUB5n7tZ3aZeEkOCBpJpZOkSvLp7CpphSij/K9dfUcm8XJNV
X-Gm-Gg: AYBFou1fBwfySbd8fiIF0yNVr5o3CPkr7+EqtP8daI2WtEscsE3QU+8dg02VaMJTjVM
	gpZy4efZgYsMYalt7kVfVe33F0Evh0v4cQ00lCsuQKhJrusy1dJneP/A5NQ8+uF6CTPxzj7t1SN
	IsKhl3cPI1/xmyyndVFeTzolQkHKgqcvMDxZz1fLr0K0G44kfsyCdyNWweiWo5B/CAgrIugXwEv
	I+u9KEx2NlpYZEj1MZn1pgpTzWLeUxkhHOmwB9SHyJDXCNohb7wN2hhrmJUHWp+9161tCeydqaA
	7spPQo5POANwa3hh4QgdHki7EkOijbC3GF7kGAlrbUvUFC+ot7B4+PDY7aT+5CpGFpVemdn8SIm
	juE6Jf/jmdouts/5M5swwQYN147ydbN9QaqKxZRI32TgoUbEupkjiCliTcceF0IsI4yZd0f1GJX
	EXqFCskDVuQmZl+hOadg5Q44Z7SbnblAL2bU5SMoMjlT4+cdff3J7vl45V8KCeFtAh4PQnHXeae
	ZGzk7ykOT0nGLCNdMyszYP2YFmYcEVG0E+QpcR48hS4zvmF6FDnHVCyXuNvJvCQoLBEXg==
X-Received: by 2002:a05:6a21:2c11:b0:3d0:868d:8ccb with SMTP id adf61e73a8af0-3dd8c2eaf15mr521751637.13.1789682250029;
        Thu, 17 Sep 2026 14:57:30 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:29 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 00/14] Update lpfc to revision 15.0.0.1
Date: Thu, 17 Sep 2026 15:20:01 -0700
Message-Id: <20260917222015.61053-1-nkirkland2304@gmail.com>
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

The patches were cut against Martin's 7.4/scsi-queue tree.

Nigel Kirkland (14):
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

 drivers/scsi/lpfc/lpfc_bsg.c       |   7 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |  12 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  23 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   5 +-
 drivers/scsi/lpfc/lpfc_els.c       | 503 ++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 130 ++++----
 drivers/scsi/lpfc/lpfc_init.c      |  21 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 100 +++++-
 drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 227 ++++++++++---
 drivers/scsi/lpfc/lpfc_sli.h       |  18 ++
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 13 files changed, 812 insertions(+), 240 deletions(-)

-- 
2.38.0

