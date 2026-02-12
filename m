Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD3225B2F4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929732; cv=none; b=SgTiko+hAbWBm4jOdfLmfZe33zgbocIEMzCixI8gO94ibOWANBfPJ3eHgzqqhNUtRKCnr6To8M1ctsVgYj73/xytus5SBp7eBXE4oK9+/Rbmwa2FkNOGnmDWQMUtrVg/iXoNFvEvwYaeEPj5IA6jYRuo0I3n5L5hGbCH/kbpNvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929732; c=relaxed/simple;
	bh=0GnKM6rRPW/8f+H74Yw93HO5OrgLC7KzXJnQbMSoTTY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fB+ayT97mTYMIPkKfgcNbcmJB7kjfWjP0e+XSsLc+uE293OEbO0JckquJnJ8+6Dt4uiYf+JLqL65nZQQ4mnnJ+uqwpw5AcuST4KQ+HdfhJbuHlVQ3pJsCkgnQDZ/EVGHyTQN1GPdQzornGL0q71Lm+G8jCOGJXvd3p2znOsLD30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJmTyyrO; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJmTyyrO"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-896fa834290so3077486d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929730; x=1771534530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muZraXPtF6vRT3DTJIMx/7a5+ux6ww6xhh4KD4SbbTI=;
        b=hJmTyyrOUTqIWmBBmoTs/Qrapu/m9BEl0kwI3d41kwyG8aD9VKqCcIXFCQly3iK8LX
         P/oU0X344PXRazzM85Kqld1O4KxYGFv1XNmb4HZhJNoxpczxdIn+inNCTP95iDmfwGdF
         elwZts5tzMgmnDTuQQ7z6Fq8Y81KhSg7lcTq+dxzpeqQ6fiWQz80/4G5AojjM7wtonwj
         cKYH8MRk+covSC3zyNvk65CNsBT62mm+CYE5p7iOsO9MhSW70cWWCTybtV6iyn3ZMtIM
         I4yWMfbVOLd0kgqX3fkfq46/FkgPBnHRblxp4My3ZLWx/cY6m05NGvNb4ygQMizPrCYG
         YpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929730; x=1771534530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=muZraXPtF6vRT3DTJIMx/7a5+ux6ww6xhh4KD4SbbTI=;
        b=LMddVLGOMcvrqr13TgGacKB4IdwKR+BAsfra6hsJURZ4kfxTnWD1OLCF28IAXfVDrD
         0wvJayDXBnUYLj8lTiyHdF+Qnja4qT5QK4IJWhzBjwCbuNZbEYAbFQ9J+fjVzJu7Z7dq
         cP6K59ss1MJ0KjGOSYECsWMx8x1xmU1USRk2IX0O77ZHBQ6qM5K4NtV1fJyU6WSYrrZn
         Q3wyjZSy4ZewZVm27b7GuGKpsYqQjkWGye19dMwsfJg2S//GFC4mHIbIbBOw0VWheUcb
         Uv94bT2j8/uibBI/3GXSlMHYZ6HCOiAHj8SLVdbJ3xelalM8H5vGysi/Q29ATNKdW+6g
         WM8A==
X-Gm-Message-State: AOJu0Yy/zWcpJJApU+4ZZp/keGzOSA8PE+vLtAOtwFwxtWIYiCh+USIj
	qQNXZbHR/PHEZ5+HU2u/Nm69i1v1ooONCnrpdMNOzbiOzXB6EWO4vjMeU2FxCtAF
X-Gm-Gg: AZuq6aJ3urrTD/DU+dJcjrzlvauJzx5NytpTd5PZDiOzsdbQqoyh3ZPOhMkX1x/YCR6
	sVM2VyoE3bOvgr9AVaqbmMo/vQu+W9+GdwRxV6C9MDYlwDwfdsSne0ZtCnO4DL8lL3lFmoewx6k
	biiLfy9k8KqWDhiqQyxKIfNoPzwccKDHu29Itov1MFcaI/rpzm3ld5wIEqxNFxMi7+Mm93rJIiG
	3LvNY/YSO2J04gcmdIu+IappITXax7DSjmv8piJ/vdW2iApJIkq7KPiQLp3YosXiNH+bz/lehGE
	A/IIKehJOF6802XGgc1pHYoGbJ3nZXuXZXhv6d8iKv6Wti6b1b0cUT4FBT84NZ2qtpV+cgWNEq8
	zbQU2DC4CmqBrums0SBEqDE+aguwOj6e1UuLhzd+BMNVj9kaQLl57EfqfJiykiZMjiH0B+39q16
	yQHrDbKxwaKp2u+imXaK6s+JEU5GkGGFU0gn4Tkc5Qkq2fgEU3I99Tk2Ol53R9NJjxY4ljqaa11
	7v2DX59jOw=
X-Received: by 2002:ad4:5962:0:b0:895:4bf8:3cf3 with SMTP id 6a1803df08f44-89728d99211mr52600336d6.15.1770929730442;
        Thu, 12 Feb 2026 12:55:30 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:29 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/13] lpfc: Log discarded and insufficient RQE buffer events
Date: Thu, 12 Feb 2026 13:29:57 -0800
Message-Id: <20260212213008.149873-3-justintee8345@gmail.com>
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

An RCQE with statuses indicating that an RQE is dropped or when there are
insufficient buffers to receive new RQEs are currently occuring silently.
Add a new log message to warn when such events occur.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c  | 17 ++++++++++++++---
 drivers/scsi/lpfc/lpfc_sli4.h |  5 ++++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 734af3d039f8..3d88888d8ee8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -14740,11 +14740,22 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 					atomic_read(&tgtp->rcv_fcp_cmd_out),
 					atomic_read(&tgtp->xmt_fcp_release));
 		}
+		hrq->RQ_discard_frm++;
 		fallthrough;
-
 	case FC_STATUS_INSUFF_BUF_NEED_BUF:
+		/* Unexpected event - bump the counter for support. */
 		hrq->RQ_no_posted_buf++;
-		/* Post more buffers if possible */
+
+		lpfc_log_msg(phba, KERN_WARNING,
+			     LOG_ELS | LOG_DISCOVERY | LOG_SLI,
+			     "6423 RQE completion Status x%x, needed x%x "
+			     "discarded x%x\n", status,
+			     hrq->RQ_no_posted_buf - hrq->RQ_discard_frm,
+			     hrq->RQ_discard_frm);
+
+		/* For SLI3, post more buffers if possible. No action for SLI4.
+		 * SLI4 is reposting immediately after processing the RQE.
+		 */
 		set_bit(HBA_POST_RECEIVE_BUFFER, &phba->hba_flag);
 		workposted = true;
 		break;
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index ee58383492b2..0aa105cab125 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2026 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -246,6 +246,8 @@ struct lpfc_queue {
 	uint32_t q_cnt_2;
 	uint32_t q_cnt_3;
 	uint64_t q_cnt_4;
+	uint32_t q_cnt_5;
+
 /* defines for EQ stats */
 #define	EQ_max_eqe		q_cnt_1
 #define	EQ_no_entry		q_cnt_2
@@ -268,6 +270,7 @@ struct lpfc_queue {
 #define	RQ_no_buf_found		q_cnt_2
 #define	RQ_buf_posted		q_cnt_3
 #define	RQ_rcv_buf		q_cnt_4
+#define RQ_discard_frm		q_cnt_5
 
 	struct work_struct	irqwork;
 	struct work_struct	spwork;
-- 
2.38.0

