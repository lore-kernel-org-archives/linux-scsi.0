Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FDE3B7B7B
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682265; cv=none; b=ITuZuwbZt/4yFZ62xYAM4HnqV/4y45EOEn7qTlRgRt4Y0/N3uR4zbnt8KNTC+v/33NpMBQ9UfFa+Nij3v3wVnsBkjLvBRzrQ+JCeWB9pHOpYS2bilByyWCrcyFCJRJejAZQ0mugCCHuz4bbw6JdTBgJQSxLfU2CEMRh/erhl2lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682265; c=relaxed/simple;
	bh=JQi0jA1FDBMB/C03H+fp20C1aZnIiIb7z24UB/Y+1ZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jf8Rl4FpZ6mXoDDB1e6PutXMfBMb6Cm3qucsweZnD+4nyEJFSL2C/6fW0+G+oeD3Ue1nJK5qYdBl8DD5d9LJ3c/z0WYvT5vL1fu8NMb3/W1HUGdw9IvK/DhwhA4htxfBbYjsWeEO0DaH7hSPaZ7oV+ENwulQ+LSfGbgTZdP+7tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IvaSqrfr; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IvaSqrfr"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccda24afso87756a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682262; x=1790287062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xIyI70HUMF83aI0xLGzs1iManq7KuvCFL6+pZs1N3wI=;
        b=IvaSqrfryCnMfoeSuHfTeWgLBnYDCMSEbBi1Bx8AGu8WGqlaiZSOrCpbrzy66Fk4Bq
         tyWaD03DdX6C74A8VI962slQW8vkg5D2iVBJjNmjYXnnWW8oQaUReUNcQB1e/o8B0B38
         XtOPMVX/X3+jfBX+mu43VTnREUTEaSbSdkogYQPhve2lBUYzz+QGsPauNg7Z0F2Njeoj
         AXBJjSGYNAuI/FzmNTyxb9a5KwZfFcuXsFDmfT5brEnUWArNKlOX3LQs60Kfp36MjDtn
         ghJXiVfU7nzOCGcjdVYhUPrYktokHo0gi6hYybXMz+mGUTrZ2iL6iHs21WohJBYAN7zC
         eh9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682262; x=1790287062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xIyI70HUMF83aI0xLGzs1iManq7KuvCFL6+pZs1N3wI=;
        b=u7hf3NWBQfc7e32Qrz3Xyb2T5f33b8pO5sbY0wkdHPAToxhxdzEf0EyHFZe9rIzAbG
         4vaKuik5CNx90FJycBSd+mmegkp02yqazex6A7pHMNOM42UmOVke6QbWny0zezBSQMoU
         oH9u8aHBNQB7Za8iK5xNrf6kDDGZyXZbq16I4K7I/bgjNCJmMT4lgcZGkJMkvTuHmT6M
         GdJevWwzr3pms1HNXZYGsh4mBSDl4cy+49jAn1D7MpgW15ICK8OWUAhVeWxU68Pk8/Sa
         dmtDL4dbtyqSst5UYpFU1vaHp18XN0+Ne6zIaAxdz+VXNX1sqYhkoh4Kt+qXy7pEcqXZ
         /2Tg==
X-Gm-Message-State: AFuF++m6HoX2Tu8GwVTdpZzFWTN5IZW/GvAZYmuQby5/jL0vAwY35uHH
	JhN0YqSpJH9Zfwf15CJJgRXSQZcr8jMgHs8VOw2pG8EF7NI32H3Lv4xABDlEEQ==
X-Gm-Gg: AYBFou3Mxl+FACXHIHioU3Jf90Ext0ZCL4j3NDCBci5zUvr92G/qDyCybfeOuQK2kwY
	IPpYuoDoXEWKxaL13BX8nmiEbzY24oTyev2SoFj2tx8DvsUt7s3sHOnfMMYB3MyU4mnXU0iqq+/
	aF/f2sqS7IFGG0q7jRTqCQBTed5g+I8IrdLBvLJX04BRkvs6B9ex73Ec7hLBTaxRRo/tig47bb+
	LKZSR8I23ROT1H4++YcezZixW0jkW6Q9ItHWQhHxNl1TKMDnb/eT22IWytb+c5YD3dnYNgmm9nG
	SSf7pZWQKKJTBKRmLCJpVS0mGPwK2dDI53bucO9jm37f34hn407moDTrjmVFbefeV2uEDIa5/JB
	pVgnFIWaOauDYLy5Ozumev4S7wTu+gie4/p3fg9jj4aursKIQf6j5YTcGTxa9Y6C0+/1vOVwcyd
	kPkvVUYhlTG3BHg8WHZdp2zgMD7f7nPDAiR/SBJR8HjnQ+R0aDf4sqaJkgE00sgY9Y1LAT4saej
	1WpWdfozVjjLqn2c1482EEO5xNJHJzvRgIscKdSjhSzZAshpiz3iw+ihSo=
X-Received: by 2002:a17:90b:57c5:b0:39e:3554:4d0e with SMTP id 98e67ed59e1d1-39e54c584c7mr1729102a91.1.1789682262456;
        Thu, 17 Sep 2026 14:57:42 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:41 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 10/14] lpfc: Remove slowpath cqe process limiter in slow ring event handler
Date: Thu, 17 Sep 2026 15:20:11 -0700
Message-Id: <20260917222015.61053-11-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a cqe process limit of 64 cqes in
lpfc_sli_handle_slow_ring_event_s4.  The HBA_SP_QUEUE_EVT flag is not set
nor the worker thread rescheduled when reaching this 64 limit.  This means
a burst of over 64 cqes can incur a delayed processing penalty, which can
be problematic in large SAN configurations waiting for rediscovery after a
link perturbation.

Remove the slowpath cqe process limiter in
lpfc_sli_handle_slow_ring_event_s4 to ensure the slow path CQ is drained.
Add log messages to notify when LPFC_WQE_DEF_COUNT cqe count is reached.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 10d9030a1e88..06dc01c9539e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4542,7 +4542,7 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 	struct hbq_dmabuf *dmabuf;
 	struct lpfc_cq_event *cq_event;
 	unsigned long iflag;
-	int count = 0;
+	u32 count = 0;
 
 	clear_bit(HBA_SP_QUEUE_EVT, &phba->hba_flag);
 	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {
@@ -4562,22 +4562,39 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 			if (irspiocbq)
 				lpfc_sli_sp_handle_rspiocb(phba, pring,
 							   irspiocbq);
-			count++;
 			break;
 		case CQE_CODE_RECEIVE:
 		case CQE_CODE_RECEIVE_V1:
 			dmabuf = container_of(cq_event, struct hbq_dmabuf,
 					      cq_event);
 			lpfc_sli4_handle_received_buffer(phba, dmabuf);
-			count++;
 			break;
 		default:
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+					"7771 Unknown WCQE completion code "
+					"x%x, ignoring.\n",
+					bf_get(lpfc_wcqe_c_code,
+					       &cq_event->cqe.wcqe_cmpl));
 			break;
 		}
 
-		/* Limit the number of events to 64 to avoid soft lockups */
-		if (count == 64)
-			break;
+		/* This loop runs until the ELS/CT CQ is empty.  Post a one
+		 * time message for debug support when ELS WQ ecount
+		 * completions are processed - this represent 1 full ELS WQ
+		 * wrap.
+		 */
+		if (++count == LPFC_WQE_DEF_COUNT) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+					"7772 %s SP CQE count %d\n",
+					__func__, count);
+		}
+	}
+
+	/* Log a final message to note how many CQEs were processed. */
+	if (count > LPFC_WQE_DEF_COUNT) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+				"7773 %s SP CQEs complete, count %d\n",
+				__func__, count);
 	}
 }
 
-- 
2.38.0

