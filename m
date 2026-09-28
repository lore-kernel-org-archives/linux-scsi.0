Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA3A32B118
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618094; cv=none; b=h+WL2gpUICqDrRD+pWwg8kbxLwt9snzMFey1ZDd4OJpu1jXUdejXnY6GJlhCiKnBAkX1CkqCiZZyB2iNlG53TzXqfMGma8GHtpqrrdV3780BwUL5TWKZ7ZxXWwC5kNOSvbsETyTzKDzqn7fksN1AWRWPTnmF5ncFtEV0/wxP0CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618094; c=relaxed/simple;
	bh=n2DzVKfXY6g92JDu48SIz20vD0k+CfdbmDrO5jgovd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VHQiEblgctbBbNbHt2XM5bTcBj8J4+JsYzjFFBg444OuVJQ8TFdwVdVKv/EOtroycf8Gz1XInh1nIZAEOjGxnh+pyNkRPmSQxt//VJHLgb9K3A2ixdVVMkbenNXeeq219uicYZB9NJPCnRH4LcKpnSngFEA16Ae+SQ33eETN6SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nd/h6oXc; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nd/h6oXc"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-341fe27b718so3272004eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618092; x=1791222892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SF2lyk4B9tRk05b+m0f6bFDUt7cIneDFpylgWStsJCU=;
        b=nd/h6oXcLwk+aM20kwC+x0ORo/nk6txhdiHeEpUxE2tl9v/15obAAQRk05ps9CjcP3
         YMIIKhvxl+IzyttgbTUib92/BabY7LrKhRDE+i2T1i0D/CjFJg8zes2HeHHiQ2RHBXH/
         3eFJtC1WzWRAzd7zY6MU0sOVJxAwqHH7w6oJCGdIJAQL33+qDQB7FgixwAAwXWDTeKWi
         8WshdF/GlN4gSL7jnGlvGjLXIZcyj05mZUAoPqUcSwWumb1a0IQW06mizvsadsjHrYWU
         QZmJJNwBq4UOZloAAEKbUtEx5z1McqyPmOXKZOgbT48AbXp2oFW+7WTC7EmeC7zS2Qvq
         p4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618092; x=1791222892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SF2lyk4B9tRk05b+m0f6bFDUt7cIneDFpylgWStsJCU=;
        b=zfGYKrDa45HwQH1Tq5m3mmUNkyUxhbhynPNmPHnSG0HTFy6eSHE1yL0xATuunsCvH+
         AfJTsJplnjg9zEt3Ng+IH/WRoFSAXISV8gL1Y48QP+/sil2X2F7f4s5EibBeZNi/BjPn
         K+Je1V6HRkooDeoI7KpKwu/uNJ3Pd28TVahKFJjhLjNf3OEViHnQV4lml/ThkIy0NCwW
         nec+RY36MbuVcLmcCcShhxh/tUqRyKO49IxrjtFTxZAphiY+D9Eovfp/XsqCKv7huzCp
         LbbLvA9HKdlj0ttfcUp3LluWpF3PeDzXFBMIDGcFoR8mJ+cYXC79qSJKhsdVyphu4yFA
         IgTg==
X-Gm-Message-State: AFq9FYLSguntTwxCkOWyv4crP1fJ9K/fwpDekuVyFZ2nwxkWqwOLZtpc
	pFQPovC8Nv0rxiPb2OAXmvGGJfBTF0VHqqGdeD7KltQicLJbCeBdcMWGpVPUQA35
X-Gm-Gg: AYBFou3Irykx/1pRCoR4pchAgogMMfNSO5+4IzYV4Sc7yC1zqLjw1ThONXewPOVT5Xz
	p0XZOcvmdqOLHb/Mcp9Xujm8C4X9LwGydC03qaJX0AwXs+WELSjdaOnJbKS2RdbjA/Hr4gbZwK8
	GRozPK9lzADUPAjOKaqA6krW6SRCKRFCZqQIYe2iWElw6nrP9hHE11wrkHk7qcbjlnMbTCmsu9s
	9CZVfSzsuYRQxySqEeNWNYdMahi8qqWYdSi80eIU0bbkjWxeS/GzLSFz1jWbUVkbJnsaZYkxq+i
	p9rtny7oChF3UfD7hjC5VvFPSXefHLVmOXGb/crALHKNtXsJoKb+MB4LbOoOebFX15hTNioAAdp
	cvoYd50Q8iQD4V7/JTFOllKJ6b9ky2421wBebIkzA+JivTOqC7mA5B5zfESs79HjUz5r0sW/Q5K
	J0tvTQK5qmIzpDFKMC9G6z/nZ5uXp+WSsQvCocUxeDUz/UkXEQ4RjFx5lPj2WXGfuzsE9Ja+fTs
	ws36AfpB7nEq/3QlPQPyuxVHsI8EAqrOMHmjV2a66snY7bMOZi2bJmAWSm2bV3/YvWw
X-Received: by 2002:a05:7300:d10c:b0:342:645a:5cf with SMTP id 5a478bee46e88-3426fbbe907mr10469271eec.1.1790618091839;
        Mon, 28 Sep 2026 10:54:51 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.54.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:54:51 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 03/10] lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd
Date: Mon, 28 Sep 2026 11:17:50 -0700
Message-Id: <20260928181757.21959-4-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A kernel oops at dma_unmap_sg_attrs may occur due to a race between an
aborted scsi I/O completion and a scsi error handler issued TUR using the
same repurposed scsi_cmnd structure.

The LPFC_DRIVER_ABORTED cmd_flag is set when inflight I/Os are aborted
via lpfc_sli_abort_taskmgmt, and this flag is not cleared until after
scsi_done is called.  The inflight I/O test is changed to check scsi I/O
for either LFPC_IO_ON_TXCMPLQ or LPFC_DRIVER_ABORTED.  If either cmd_flag
is set, then the I/O should still be counted.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cd285e87c278..b370a64e6b67 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12730,8 +12730,12 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 
 		if (!iocbq || iocbq->vport != vport)
 			continue;
-		if (!(iocbq->cmd_flag & LPFC_IO_FCP) ||
-		    !(iocbq->cmd_flag & LPFC_IO_ON_TXCMPLQ))
+		/* Only count FCP i/o */
+		if (!(iocbq->cmd_flag & LPFC_IO_FCP))
+			continue;
+		/* Count i/o whilst LLDD retains an interest in the scsi_cmnd */
+		if (!(iocbq->cmd_flag &
+				(LPFC_IO_ON_TXCMPLQ | LPFC_DRIVER_ABORTED)))
 			continue;
 
 		/* Include counting outstanding aborts */
-- 
2.38.0

