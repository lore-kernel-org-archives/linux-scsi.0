Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E472D4805
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929747; cv=none; b=AzuNJ+8ssnjtiy71JId0BBMASM+g3Lsr0WseyU9gxhSPmnmdWwFlSYBl2L2qMO0RAo+L1KCYLRJTchBwd7rhiOgGTYMIsK3Hmmw/xY5uQ3raC1+sJz/SXBYha3H8rB8kYxaac3dr9190QKuti3MkhybXR3Gxs7qvv+/4KAhR2Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929747; c=relaxed/simple;
	bh=B6jhxoAMWDRvf/Dx78zLFcHVZprg/YnIuwTWATOozCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iv95zIQ+atmFxg6R4zRNvb9nSpeuY9ukbM7Ah1djXzCA9CDg06rIbXdI04ttu6dgHM25LBX9HbEhupbEoTLrX574oUVibxttSS2hR7Nf3IqhzOewicK9U4dEhzmB7TqjmV1eL2Her18hOMg2YV71+3cJQzPP66J/QWcjEiRMBPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5axJjtn; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5axJjtn"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896f8feee14so4422776d6.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929745; x=1771534545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8TxAFhFqsXqi5gx5s5X1W6jdhjvwP7Xh9wd2DI5NqPQ=;
        b=Y5axJjtn24JRciBGFB2v52T56gl0XCfZMEhxnKQbp9A82l8lY5DObcU5mftZFZEasm
         76Vxp1P/l2UeVTBPF8gscPNfWassS09g0+4wSBfVvwGqyYdfyWm7lNQbN0Yn/PjUfJQg
         dIY/q/gha2h+CxQboTiKJltpR1r4b+GuUDihMMuMw/9b3XVrigjplN7UthV/4OXl02xl
         95PV5QRtHe1MWkCXEVGUFRp99enKfUnCciWHkh/MI2TyUPJA7UoPR2nq8fXmTZ/1Y45P
         xLal746CtYhIYJcrZRLnDYMVtRyz8YPklZeNG8YNHhF9IOwaFAO+4YStaX+WBqq/FbsY
         lBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929745; x=1771534545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8TxAFhFqsXqi5gx5s5X1W6jdhjvwP7Xh9wd2DI5NqPQ=;
        b=n8EacxlFQUKsh+4ZuHfaTWkXCxI4SrDR1dkEi16/JsV5CSH2ZwofwciG2SHZsr+cC8
         ATAeGg9j+J0rUXO8juEgQp56Y85+TV9gANfYj1FJHmdD/ieovgByXUWOMAGjvdjU2rks
         tWn9R8AJQ7AhkisyYzbK4cfYD78E3b6bL6EDYeaWYa4AxAwN5UNOge9DxEF+c3GJ+9CW
         S0lxewoTvw01IcoZXSVgJteUWBN35jxFYzHRq+cNSD6WZ9SkYWdVYySui++9hqyEnjU1
         U1M7E7HHiDMMF6slOkugOxOq9pXqVCEC/yrIGfI3Qzb8DeVsQZH/8O/Vd1tXKOjomJIS
         qyoA==
X-Gm-Message-State: AOJu0YxegsbuMkIDmJ9jCjpMQlNXjC11oDYZOfj0FfXWRsXzKsl2fReW
	/CCKAFXeBYYPqXRN7kFmSxu+8yMjmfXkXGy3duiKJbpuPKhV13uVMhEL
X-Gm-Gg: AZuq6aKcgL+jbodY3GaDn7EwO4WtH7GaW/o5B+OZG3+4gjRyuSZGakVb3WdhCdXLHFc
	TXIckOGAcQoy9Qr/e/dU0FP9S5HS2eqL3dm6G/mAl5Pn/y4yCPLRA7Jt2rV6u+Bu3ADmUyxUV6z
	VCU0oNYUV1tg/iU/Ewg4mosjPLVL9OtUTMplYYcxoQx+Ec8BkKVNaytdRL8uBKeOCCk/aOHzMeX
	JgEj/qYe5CsriwQh2N8VTWORKzhYbMso9UmI8KMuo8CHofUR0UQeWO6xaWpIajC38PYcpNHT8rY
	C0X0oOb+gZKwUwVpOG8/JHuKksJy9aUD9wWspThOfVkB0IMOUvz4hDSyBQGWv3L1sPVQzGrwOG4
	55oXvq8DhnArmN8vYDPr5XjOqVkI9xzLEfVbP7h4plYVfE8wM31QX9Da0JZplOqi+nVtfHpvlOn
	KVAMN155T77+ZffBFfPfh+uBTgutAtoxw5OPSDd43O
X-Received: by 2002:ad4:5ccd:0:b0:896:fc72:f92 with SMTP id 6a1803df08f44-897349b7efamr5696886d6.67.1770929743212;
        Thu, 12 Feb 2026 12:55:43 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:43 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/13] lpfc: Update class of service bit field to 3 bits for WQE submissions
Date: Thu, 12 Feb 2026 13:30:05 -0800
Message-Id: <20260212213008.149873-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

WQE submissions only require a 3 bit field when specifying the class of
service to use.  So, update WQE submission paths to use a 3 bit field
instead of 0x0f as the bit mask.  A NLP_FCP_CLASS_MASK bitmask is defined
to ensure only a 3 bit mask is used.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h |  5 +++--
 drivers/scsi/lpfc/lpfc_scsi.c | 10 +++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index de0adeecf668..a377e97cbe65 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2013 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -137,7 +137,8 @@ struct lpfc_nodelist {
 	uint16_t	nlp_maxframe;		/* Max RCV frame size */
 	uint8_t		nlp_class_sup;		/* Supported Classes */
 	uint8_t         nlp_retry;		/* used for ELS retries */
-	uint8_t         nlp_fcp_info;	        /* class info, bits 0-3 */
+	uint8_t         nlp_fcp_info;	        /* class info, bits 0-2 */
+#define NLP_FCP_CLASS_MASK 0x07			/* class info bitmask */
 #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
 	u8		nlp_nvme_info;	        /* NVME NSLER Support */
 	uint8_t		vmid_support;		/* destination VMID support */
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index df64948e55ee..bb3f5077f35e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -4665,7 +4665,7 @@ static int lpfc_scsi_prep_cmnd_buf_s3(struct lpfc_vport *vport,
 	else
 		piocbq->iocb.ulpFCP2Rcvy = 0;
 
-	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & 0x0f);
+	piocbq->iocb.ulpClass = (pnode->nlp_fcp_info & NLP_FCP_CLASS_MASK);
 	piocbq->io_buf  = lpfc_cmd;
 	if (!piocbq->cmd_cmpl)
 		piocbq->cmd_cmpl = lpfc_scsi_cmd_iocb_cmpl;
@@ -4777,7 +4777,7 @@ static int lpfc_scsi_prep_cmnd_buf_s4(struct lpfc_vport *vport,
 		bf_set(wqe_erp, &wqe->generic.wqe_com, 1);
 
 	bf_set(wqe_class, &wqe->generic.wqe_com,
-	       (pnode->nlp_fcp_info & 0x0f));
+	       (pnode->nlp_fcp_info & NLP_FCP_CLASS_MASK));
 
 	 /* Word 8 */
 	wqe->generic.wqe_com.abort_tag = pwqeq->iotag;
@@ -4877,7 +4877,7 @@ lpfc_scsi_prep_task_mgmt_cmd_s3(struct lpfc_vport *vport,
 	piocb->ulpCommand = CMD_FCP_ICMND64_CR;
 	piocb->ulpContext = ndlp->nlp_rpi;
 	piocb->ulpFCP2Rcvy = (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0;
-	piocb->ulpClass = (ndlp->nlp_fcp_info & 0x0f);
+	piocb->ulpClass = (ndlp->nlp_fcp_info & NLP_FCP_CLASS_MASK);
 	piocb->ulpPU = 0;
 	piocb->un.fcpi.fcpi_parm = 0;
 
@@ -4945,7 +4945,7 @@ lpfc_scsi_prep_task_mgmt_cmd_s4(struct lpfc_vport *vport,
 	bf_set(wqe_erp, &wqe->fcp_icmd.wqe_com,
 	       ((ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0));
 	bf_set(wqe_class, &wqe->fcp_icmd.wqe_com,
-	       (ndlp->nlp_fcp_info & 0x0f));
+	       (ndlp->nlp_fcp_info & NLP_FCP_CLASS_MASK));
 
 	/* ulpTimeout is only one byte */
 	if (lpfc_cmd->timeout > 0xff) {
-- 
2.38.0

