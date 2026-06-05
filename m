Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA31536EA8C
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681505; cv=none; b=HpJeqOMnA4HiWoh+On+lBTcvJnwe+KVv/ycOWeebl2HaMND8JF7azUgkcrI7xHSmeuCyZDHVpeMrTXvY1qV1A6vkSHe+msLVE6FUm44hoHLkTbwdCbYqrJ6WeaorS8B/ZMXvcktfgexiMOL8PGZ/cF5xYGjk94t7TzqIBPTsNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681505; c=relaxed/simple;
	bh=uzRsLBkRjDumYAVG90ujWoyRwH5o0caFsignH/DRc6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JP+axN7bDVgm0GraDOcwFWDWMS/Y1JdnGZqc17OC6VuVbmDfX7a8YNYziyx4RxRqEM2yxN3sBqw0zQO7/ZmlMEOLwyJDXwQPI+F/hVfTiVtvQmB5pApje+acWxWgqHrHzPdGAVfx0WpnWqjAWrHS4PCZlb5DK8iF1EUtPDB/lUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JM+AfhiA; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JM+AfhiA"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5177b1a7441so31571601cf.3
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681499; x=1781286299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqYVp931at5BTO3V7xOddO7UQBUdeCKu9JpHGI5LQBY=;
        b=JM+AfhiA1zi6R+/vtrRABos6l9VKgNU5tn0HLVQqfeTnTKEQv4Gdm+FhPG8/jel22s
         znwfjbZUC+wFOv5Gansk9SHHSK7ERy2MGnkT9uG2Y3wFYaTsZY/7RoRE797wfRrK4a25
         i0ZDMpNArW15ujlrOdXS3o0CsMIX+6y/CAVql8DXf1Kw8oVkH74vWxU76gAc9wWD0rN0
         0Jfzg1mXkxKwvGt6E6x7m9gFHf9QJNlyUhWII3n/Im1T3ywkuHGHetTUcAmfaayTqe32
         WPFrmLePYAjulcsLAkAN7feIq8nQX0sswO7oGfvUaOK1CpL0y+wTB30+waFu7ic1JpU8
         9tbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681499; x=1781286299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AqYVp931at5BTO3V7xOddO7UQBUdeCKu9JpHGI5LQBY=;
        b=qiIfm/Z0EUTIlBSjTnSiCE1KIJiM9RuEt9kTT5r62ozChfhh6qGW+1ecXOLNInK9r/
         u9SxjPDDcRrsephAO/Mdk+WslVA6TCL8rTNPLhV0EtiAi2up4f6D0TQXt1FDs0US/i6p
         6wcH3IrY58/BvtT1VAbMLhxDjbFkveY32tkM5vWtfb/Q+dfIMZ0AAXohkxKC43qyAWVL
         IbTXnCHbucvPGiSLLuYSZidKsRMFlQfbB/eQizS3zg3636JxxwgasLbF677mUzvDKf/r
         rieZoBIbElJdJednTgE+wUBGDHjezs/fHIiDjFR3ZvmvgxaSdWDg+fBlmt5GkrwPzzvO
         9zNQ==
X-Gm-Message-State: AOJu0YyULFakMFRDa528P2tgGKlRkpXqL+pWViQQ9Q9uYt8+LB0pFlCx
	juqcEnsVkFTskjCN/iA4y1LatJTTfbkRxG8y+YrhwmfJIOk9iIbSyJCYZU2Ja5pF
X-Gm-Gg: Acq92OFLHSP25c4r9RHnNcVbOnR34mb9nVR6eS7uJfg2vVkdgeO8kbN4rCIqcel/gLy
	xsqXWS3tsDrGfvYIP3NhV7ECHCwRrKDYbtkVyLimIj+s+6bx6Cxjg1rsd+4FLPIluGL8A95jU0q
	U1lqNO7WI45c0h34m+C0pcV4XJO3irNbNuaCkWuY0uKyJjKvMC1ZW8zXH5ufL4eK5gHQBds+G8V
	X9CPLOXQQcqGuFK9WJOpE29IwV2Uar3rlfOBNmuXsDhu1N426LnSS3zZcVXFFIk4BfyyvlvGECw
	GU0goBDjmHzfGeK7QW13ndXmhc+rW9QAx5hIsZjIBGt+x+Ps4ljn0kFquNHsxiVwC4etQHaGJ+j
	Ms6sGo3pyFvhByRvxRgr//qY8QkYkKgG6McbjOiQnYyp3eszITmE9apyetmv8p53mjOCw/eJ90+
	wc5eF3l5SKVZyUNhpTNV6G33g/jd0kpaIwL7WXwo3dA0VUn+hJhusuOUStCgCXzOn2QS/YDjUH1
	8OnG7dYk8FEpP+h2qEsgdh0t9AoB45IIIfr0HwCvxgDMIpYx0m/YA==
X-Received: by 2002:a05:622a:2516:b0:516:ddfa:23a4 with SMTP id d75a77b69052e-51795c8e01emr79741881cf.41.1780681498710;
        Fri, 05 Jun 2026 10:44:58 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.44.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:44:58 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 03/14] lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd
Date: Fri,  5 Jun 2026 11:23:25 -0700
Message-Id: <20260605182336.134919-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260605182336.134919-1-justintee8345@gmail.com>
References: <20260605182336.134919-1-justintee8345@gmail.com>
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

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d38fb374b379..20ee8171e31f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12725,8 +12725,12 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vport, uint16_t tgt_id, uint64_t lun_id,
 
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

