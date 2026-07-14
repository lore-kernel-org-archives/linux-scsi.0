Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774B91A8F97
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989466; cv=none; b=fyPqroJhRWmcaPe24fOegWifQcujW2uP08QET30g9Kfj64XU89+n/9lkP0N9PNohrYojBrG3p6SwUslX+6Cw8gPKlHWxDyMi7OZIgPzUBitlHFi69NzpfnSbwFsj4T4zn337YrnH1N43SwNMTrQdrfP+hNqQvu3oh1txe0bodsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989466; c=relaxed/simple;
	bh=EG+1r38sgk9cm9N4t9r5K0UD4VWneSvbq/yu3yB5N6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Of34r7kSMITOgkp3z0q60smHOETuCuu1EASrwu233f0sIYy2gPpQnXFWPGVbNOoghIGFis0xoj1qzgNx9MmJGTkTA4w9TqHOu+r95pBkfStpidupzI7ftile8LzrnnAvENd1o/20mjNhizlXDt2c1rGp40xY69ejdVU2TCKutVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jOGu11kj; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOGu11kj"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ff5d1b0f91so22583776d6.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989464; x=1784594264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M73orJO1eZv0WmwYNQMzEudqm2565fsKxJqPta5b244=;
        b=jOGu11kjPURR6frTyPmBpCeSofqnDFJYIfV+2pF2iR0pPTvExwMX5+MweTEcScfvH9
         D/KZem5K5llotj2DS06HWaJoO9JxU6qB01T2x38p/p3GXklGcL3TiYnFIIgaxsIn/5pE
         W1Kc3dDXNPHoBPr+jXHktOtk6pjyXoZAM0dQAA6sthg+522olLqrbgRuWoOVMjBVG6Uq
         S+KR+PkV+B0cIrWdWn2qq5NpPSVHVfw/0LGX1w2lfdhZXafLIAzsXlZaJpyCXcjJaAGQ
         CDMM+wLu2YRCr78t7tjWqnomMEa7vbx7eGzuk9CZHgv+Rrb2+igxcFwHeoSZ5m4zdcpC
         9dsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989464; x=1784594264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M73orJO1eZv0WmwYNQMzEudqm2565fsKxJqPta5b244=;
        b=bV5+IVpq5gq7jXHtBahOFZNHrfeFsyVvjUHHmGLiGt6H4zPBp7gfeu1hxHE1HkLKbt
         JjbvpxawULXnu/mc4SqhnFkzDHyNExPXq/xwccteGBIfDRYomF9TuGgHlZvRzDmNJpi/
         YrhS2OUrEzh3E/hFm+xHsNceSr1FvwaYMb8sIunpoFB7aPUWby6WeQ9O7/QU865wQ79P
         QZ0HfWlbhlGzSHcrYx21KlyxNvdKLoHMZn5yGYsUzmTdxMIKhvw8Vzxn/PCd5ZBa4hlk
         RzBOkHl/KweEu6vtOwID5bsFQbpwdDPKcYUSMfUG45s9/ybsWycYyJm4Myg5kkzKq6X5
         LV0Q==
X-Gm-Message-State: AOJu0YylOBH9KelS368PBvHmX+e5NzBFMkMqsrLs0LR8q7XueZ0s6lYv
	85KkwypNWdRNNv8jyfM3GNknH29KjigollMawEpxzX3FNuz2haJWP7XKghcme6tYLuk=
X-Gm-Gg: AfdE7ckhmiaaCfBnUyQho3Vqmhg3xpwPo+voATp9Wi3oe4XVPrfe16nBuGnznuR2GAK
	MZGNFcNWc5crD38woSJMWK37uraKSN10t2AEucNA38fRjewPJ+4L6C2HVY8EbzlaKZCW5XFoVe/
	Ko5z62lXi2jbTFm9ahxrjpxfFxT9Bq3Gg8zKmZ/QuF/w0WtxhLQEwhVw2Q0Re79aSNnElXbolmp
	qgFP+KS/ik3zXajR5Pn5ooPVQwoJKAx0mYkOFPTwB8oq+BdPxR+kRHGjsPMsbGMO8s3EGCeH7qZ
	+/KReK94La5wrlzfr6RsCaH6hUQkYhNUorue9rYxfMn3EEM6oXVzb3Ytrk8Gda+5ymhtaqoDqNQ
	3VmZBWSNPWdgI4x/V5J2ZS75uLmTulh9BfkHpu/ClkDSAv7gkmLdlULbPzYOhcKFVcxYcXWV5MD
	jYfvLmdlN0MVbxkdT2EW25XMwQiipj26vjMSebVoQZ1u0yaKYLjo40PGrT3jzLOMhPt2vAVgCoh
	KELPFx3DQv9gwxk6oxLFRU5XQNDaZ3oDCiILn50Hz8=
X-Received: by 2002:a05:620a:4542:b0:92a:dc07:2665 with SMTP id af79cd13be357-93086be2754mr30842985a.54.1783989464439;
        Mon, 13 Jul 2026 17:37:44 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:44 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 03/14] lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd
Date: Mon, 13 Jul 2026 18:18:01 -0700
Message-Id: <20260714011812.106753-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260714011812.106753-1-justintee8345@gmail.com>
References: <20260714011812.106753-1-justintee8345@gmail.com>
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
index 62a30a92b792..10db07771ccf 100644
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

