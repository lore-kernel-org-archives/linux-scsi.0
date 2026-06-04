Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324FC3BC68E
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599052; cv=none; b=KkacvOunawGIRo9KD1HaA6mHO1jAESn70An/tm4FZud1fo9uj1/8G2t2TYADQJpRVUOYTHznroGjFGkA86MfO9i3iT2ziHj917I8PTOG1DDzySrM9p4vC7bnwuLLb7TnzPVWksTu7jppnBvhJofza9WJ0R0NjJYAlT56qdhndoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599052; c=relaxed/simple;
	bh=uzRsLBkRjDumYAVG90ujWoyRwH5o0caFsignH/DRc6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SrQTQtwfYo8KNa6XCLxE8/OcsZ9/ABz+mFv5/w0+mMwikSmKGygcz/1ySStmItuQHyTZW+LIdY3U/WRF+eDe7OWgdIkxtrTissBOquWLvTvVi5be0Df6gikg/K4FAu13jiZvF0wuNOT0Tx2Z4aD7lvJADT8bjoYnQY9mbDibnRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCZuHNe1; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCZuHNe1"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-91562bf6c12so144524785a.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599050; x=1781203850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AqYVp931at5BTO3V7xOddO7UQBUdeCKu9JpHGI5LQBY=;
        b=CCZuHNe1cwAukM6n08ScdmF7MtQ2EkNmq/RYkvpvy4g15dGWfuUM+wxgcsqydtd2P/
         6vuK2AGxcdwIbEVIosS1UPhiNv2ZSSg92YlaGrZ4oyC8MNZOoEZ00dos3l5bxAmSSNga
         UI+M0xDUP7G5ikrdOh9zfN0uuB4RbHsYvHcXKlo/uMR/PreNefJLEclSmTP3h5xNPmEq
         z2RpsQq5GJvloNGXGQ3aoLy3JJ2ejp78WHQ9dScbjuY0fQ/C7dBBhHeXylyud7ohDRdF
         Fi2WfIc9LbBN9zdOs4z6QF/hcDnRrcsAspEjagkHw09UWaoS4nbu5ca2U6QdpPJPk/qh
         krZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599050; x=1781203850;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AqYVp931at5BTO3V7xOddO7UQBUdeCKu9JpHGI5LQBY=;
        b=Y10EWwdarJ3rt019v1GSJJypl2Et7swVTH6M+PyqxtJGWGDKUpgOw34EJqgOb8Si86
         HSgPd593ktRtUHO3MQsQc7MHteWsWLo+XBjZ+D1PcjNazdd7l+jTEpfSbx7WHK4EmqZB
         epNNZhEcIRHrvjpf5FDpktR0emV58K8RZno7oDbWnxHNDbBppEH3pdhpGoZ8/A6Qcuat
         hWHAt8jISFjDP6ptLVggQ9ne/h4komhYWlYB9CeuWMLfxhE0jfnKUd7SN7IUmeIgcAlE
         mbWFo+wcpKkJeo6M9TOEQh8QJU3XBmKyxMv95ZR9d3MTd2fM8CxD9tROdgZgBobZR24O
         4XWg==
X-Gm-Message-State: AOJu0Ywyx6qaONkUuoo+udNiWarKCDpwjJjLKzg5uTeqDD/rfPNT70hJ
	e85B2JvmJH0TWzNUO/yOKD2VUijZtny1eIbJ47eAh54KBY59GOIp7jjVABzZsIKI
X-Gm-Gg: Acq92OF27Ll4wuZsa1znXur2rq6bSon4ZZAKjUniVMm/0hN9zw+Lfhvms68EBOpVkUn
	dnU7xQLR5zAP4s1NRlCZVg5Gb6wJi8QA2RN+g5iBX41guTCssoldJpFGylYQ378fOIDIXKF16AB
	zHnExMZNVOOSn01/gpgcyweIVFeHvc583Y3RYwDWzZxjnHextxQNdKjYzJcqJ9I5zXHU52WDuN/
	I8E8Gswt4CI0G0qojVH+ACDcmBeVl8caCJzP8jPUkbypI+nqWa4bzm44Sp3VCZa/ud0Fp05cxV3
	QmbQy/0NHz0XMsPJ+fPdUQhja9P7ejEn5GeOHliz9O0+GhyvN1Ruv4yqyKr9kFuZ0pztp3xJ7c6
	nFgspP7d01CyCZlWxJcVLjkFI7fHa373UaG3I8tnX96eThkpkAbjG0GkIIFKuEzCRnEDtAPKdpb
	NceLE0xOF4AHXC+Y42SMD8I96KnTVvYDG/LWrxOQss1RP86j7x0vwp/Mf2KMVMvqN1vzq7B51Yy
	ijQtc1Aa5kx7i4Q+vzhZhMLT/D39MR9F5MNEGHLddiBuMivkj6/7A==
X-Received: by 2002:a05:620a:17a6:b0:915:6758:222c with SMTP id af79cd13be357-915a9db8ab5mr59799085a.46.1780599050137;
        Thu, 04 Jun 2026 11:50:50 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.50.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:50:49 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/14] lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted cmd
Date: Thu,  4 Jun 2026 12:29:26 -0700
Message-Id: <20260604192937.65605-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
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

