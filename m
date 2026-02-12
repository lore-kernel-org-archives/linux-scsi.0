Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07302F90C4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929744; cv=none; b=dTyPIgihRJfMPX8UXHvJ5y9f2HfvVlfdaAYrXOOz++M1W6qC3A5ZNceHSwlO26MvoHfxwe5SM++hngxswNWo5IOSyDDT8UmE0Zszk3oHUVmng9n3FFrHPCMGDirURqH1H6fQK6Hygzaipg6AAKpkPKfSza06r0DXPusZ7DPFeHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929744; c=relaxed/simple;
	bh=cH2Z2/8k65JanH4ji9+Sf2xrutYHJXbQ2UIZcyMx8vY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L6K+6ShltWL7VgSQOIYWYcb3nxWaBL9v99BhRs43SSrqHtcjo3BNZjmyyxmakw90LYQZnscdr+WFVMe6nYXt2lmgoVPHN4hbXjJKLSv3+qC3nYIxK5RweILiWh/fAzfE0IigI1gTL4gEiQ+mBxmHZXFR0KZZOqSi4d+rcZZ53B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMGPH+Tu; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMGPH+Tu"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8951c720496so2300246d6.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929742; x=1771534542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q65li+f19GiMmdqt01ybvWxqzWyrocRgVPVJZ3dSz3A=;
        b=BMGPH+TuffXaBqTL4q5QsmtHnCwMUiG79SnfBS0DXV3oapbQXWLTqhv/3kRoc5UNhk
         I+tPam2CVUbdrggJzBjSj4XlRqWQR72PZYM5/VhDGBO2JeCGIkrJi/FRs0JQv6ulxbtd
         UGm2lbMZyFDYfVkGNkvXtTzPSFcHXvo20GM0jRFrr4j+72MXm7bGgtfnd7NqD9VKpMaE
         rBDnNqVfm8W37H7IfcvSLyxbw4KlKIIWC/zTVnnLU34wYlH0LsgsUs51Sp9AMIkVoJN0
         OJ04kaW0c3vQJRs0+qRiJvDs4HMB/y7IcUqk3fOIKOqrnZ6sMS6pirvLNcttI6CQ56Ku
         uA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929742; x=1771534542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q65li+f19GiMmdqt01ybvWxqzWyrocRgVPVJZ3dSz3A=;
        b=rZa0z1QYev1zqcvasvMR72pTNi6DsFJutWhCwMyaW7jhX7HgJeurq/gLH7Y6um7/4/
         m+GU8qsNA8/xnDjNyOow6V6w0OReBgGGbVs7ESVD5ytiPfcqoo+66HnRO1u0S+UXpdru
         jh2Q+nNH0CKxjDdlQLsD0qZ5Xk3YuEJ/v0Dv9EpJQ7JpNhzaXK5MkYYZFjF95elm7MUt
         B8jy9B51tBrTTZCoD/PZs7EIHyjL/bj/feMyqoURUMpO6uEhJ3yZ+FU5h/cg2I9Wp6fZ
         4gvfj/p7oFW2yrps8Vgn7ioSLZNXQN0HXlnG2Q19Py3VJ2u1XcfTzghCIej45hLEkXpm
         7XKg==
X-Gm-Message-State: AOJu0YwkYBwlOrgs1G7/EkLhEVYKKQ36AcpGEylRDlnYBl2ou6RwSQi5
	YDXH5h3zLDUSEfc8jAKPTNRm3l6Ya+KBBDAKC159h1sSdkXl2TDeEqi/2Vm6jH5W
X-Gm-Gg: AZuq6aKNKK0SUfoF6Rw7bdrE/IlSbSnD4wWRnhDTLc63uI9hxZJ3ZnkRAz/LdTv+r43
	49gnkmioTJYVd8W667OWVaQ9/q+1fTqNww2YFxU+t5cbDlOkK4luUW0mEQLoQLWV5GEblM3sRJn
	99bmiPBtvlN3icu0EPfJOPHLTcsH7j4F/PXErde3vxp3ozgMZIiyqLNKrDB99PVSazdAZ2tWg9R
	JqDQtzqB6mmuYvpI+tQr5QPsayOVce8FoK+CgcaSqdVcT7nDOUxtcTTvc05xRn9LgKn6nLClnQ+
	KVLIeqjZGwjq0v3PTUeab3vt/msLz0+ni8knbW49Z4YYnfijHKGt2RwOTFXA+tVi8rqfhB59krD
	p/y+XGt252c5ZTDET5w82H+cnGAUrGRinqM4tAAeJfb0IzAn/Q7EdjnyZYZCPDk51FUQ5/kEMdk
	2aPFUcJXq6Yy4e3G9BXnmCmVKmN7r8m+aYHVpjvZPjSZFKBlZ2jIvZkEXj1V3t0TqMOmQzZpWyw
	38zW6U8HTc=
X-Received: by 2002:a05:6214:4109:b0:896:fbdd:ef02 with SMTP id 6a1803df08f44-8973470738dmr7263446d6.3.1770929741773;
        Thu, 12 Feb 2026 12:55:41 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:41 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/13] lpfc: Add clean up of aborted NVMe commands during PCI fcn reset
Date: Thu, 12 Feb 2026 13:30:04 -0800
Message-Id: <20260212213008.149873-10-justintee8345@gmail.com>
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

When handling a PCI function reset, notification to the NVME transport
layer is skipped for outstanding aborted NVME I/O.  Introduce a new routine
called lpfc_nvme_flush_abts_list, which notifies upper NVME transport layer
of outstanding aborted NVME I/O that are not planned to be completed
normally due to a PCI function reset request.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  3 ++-
 drivers/scsi/lpfc/lpfc_init.c |  2 +-
 drivers/scsi/lpfc/lpfc_nvme.c | 50 ++++++++++++++++++++++++++++++++++-
 3 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index efeb61b15a5b..ddd6485f31be 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2024 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -660,6 +660,7 @@ void lpfc_wqe_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
 void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			   uint32_t stat, uint32_t param);
+void lpfc_nvme_flush_abts_list(struct lpfc_hba *phba);
 void lpfc_nvmels_flush_cmd(struct lpfc_hba *phba);
 extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index c3023474427a..62289e6620ad 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1087,7 +1087,6 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	struct lpfc_async_xchg_ctx *ctxp, *ctxp_next;
 	struct lpfc_sli4_hdw_queue *qp;
 	LIST_HEAD(aborts);
-	LIST_HEAD(nvme_aborts);
 	LIST_HEAD(nvmet_aborts);
 	struct lpfc_sglq *sglq_entry = NULL;
 	int cnt, idx;
@@ -1946,6 +1945,7 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 
 	lpfc_offline_prep(phba, mbx_action);
 	lpfc_sli_flush_io_rings(phba);
+	lpfc_nvme_flush_abts_list(phba);
 	lpfc_nvmels_flush_cmd(phba);
 	lpfc_offline(phba);
 	/* release interrupt for possible resource change */
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e6f632521cff..2e3fc2ddcf12 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -2846,6 +2846,54 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 #endif
 }
 
+/**
+ * lpfc_nvme_flush_abts_list - Clean up nvme commands from the abts list
+ * @phba: Pointer to HBA context object.
+ *
+ **/
+void
+lpfc_nvme_flush_abts_list(struct lpfc_hba *phba)
+{
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	struct lpfc_io_buf *psb, *psb_next;
+	struct lpfc_sli4_hdw_queue *qp;
+	LIST_HEAD(aborts);
+	int i;
+
+	/* abts_xxxx_buf_list_lock required because worker thread uses this
+	 * list.
+	 */
+	spin_lock_irq(&phba->hbalock);
+	for (i = 0; i < phba->cfg_hdw_queue; i++) {
+		qp = &phba->sli4_hba.hdwq[i];
+
+		spin_lock(&qp->abts_io_buf_list_lock);
+		list_for_each_entry_safe(psb, psb_next,
+					 &qp->lpfc_abts_io_buf_list, list) {
+			if (!(psb->cur_iocbq.cmd_flag & LPFC_IO_NVME))
+				continue;
+			list_move(&psb->list, &aborts);
+			qp->abts_nvme_io_bufs--;
+		}
+		spin_unlock(&qp->abts_io_buf_list_lock);
+	}
+	spin_unlock_irq(&phba->hbalock);
+
+	list_for_each_entry_safe(psb, psb_next, &aborts, list) {
+		list_del_init(&psb->list);
+		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+				"6195 %s: lpfc_ncmd x%px flags x%x "
+				"cmd_flag x%x xri x%x\n", __func__,
+				psb, psb->flags,
+				psb->cur_iocbq.cmd_flag,
+				psb->cur_iocbq.sli4_xritag);
+		psb->flags &= ~LPFC_SBUF_XBUSY;
+		psb->status = IOSTAT_SUCCESS;
+		lpfc_sli4_nvme_pci_offline_aborted(phba, psb);
+	}
+#endif
+}
+
 /**
  * lpfc_nvmels_flush_cmd - Clean up outstanding nvmels commands for a port
  * @phba: Pointer to HBA context object.
-- 
2.38.0

