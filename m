Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59500C32771
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F2E022527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZJdUqG/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgA1AX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:27 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52713 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:26 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so614263wmc.2
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bxnQFje52VjjZoa9re+CFSX+DCCTJ+k25F4C3klAxDg=;
        b=KZJdUqG/xXcuqcjDfriWXduFxwa9YsCILpwi24pLIArWt4n5UQQRc5pxy+xTgq9vIu
         Qmw1G8YXBHDMKkgX4crXeZiTcKTrgvIXS1gQFWAfeg3LGpDqZvWqr4/LWDdI62duTVFJ
         17YiD2LmZ3si9FnlllnTWiOGcDWn+TJSdaus/AaiB9yRfZ6Z8Wl07Vr/JwV+cE/fCUy2
         I7DcQPjZZinHdAkDoJdAqUq5DgAMdv5ekB5K1uiMZ9XHeicxk6ctRUvH/WHgEtiBS/aK
         QXk03b3d2PoePkCMnoj5jWE+mDCxB341cP9z4YdlOQtMP5XRNCXeHxj2dJWMVl1xQijO
         UwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bxnQFje52VjjZoa9re+CFSX+DCCTJ+k25F4C3klAxDg=;
        b=GyobzZvFDh4RGveNgg6Lt9C9qf49AJFjLh+NfFJUMcIZJ4YNldLx12v1gnrxI9Triv
         NsJGKQxe0I5PrXKsPFKNvzdGP8t72akJzs0jniejqAkQOISqoyEezZEjhaa9Afo+ipCD
         e8joVMZQkWYr4VvE+t4zGUdUbXCUEX7Uk1fcVqgtESYESNMcwxWEDv1GQQ+k3M33RLXL
         u6g5fDOrQr37Opdk2EVBdPBe4O3ZikInKWIbOdky91n0gFa5lPqoRacQq6pQQk1zQYYY
         QP7n/Z5nTM8hwt1W7TAiHyrHvetr0GydUJ09Wg1EVWQbkNJ29O2aEDL+vazXO2yqFfnK
         Gksg==
X-Gm-Message-State: APjAAAX3yUE8gOkpfnKdvhGk+fUTw0lmSM5frIn5EPgwxm2QYyNatZuj
        AOrHdOViG+xCq4vJVW++LJEV0fBa
X-Google-Smtp-Source: APXvYqy57Yw/gcNZIfyU+qXGLj9BrECrcXAuFSlZBT+bcwtGhHdYkG2R01Ko/glgI7ripEnW9RG1/Q==
X-Received: by 2002:a05:600c:2509:: with SMTP id d9mr1217989wma.148.1580171003680;
        Mon, 27 Jan 2020 16:23:23 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:23 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 01/12] lpfc: Fix RQ buffer leakage when no IOCBs available
Date:   Mon, 27 Jan 2020 16:23:01 -0800
Message-Id: <20200128002312.16346-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is occasionally see the following SLI Port error, requiring
reset and reinit:
 Port Status Event: ... error 1=0x52004a01, error 2=0x218

The failure means an RQ timeout. That is, the adapter had received
asynchronous receive frames, ran out of buffer slots to place the frames,
and the driver did not replenish the buffer slots before a timeout
occurred. The driver should not be so slow in replenishing buffers that
a timeout can occur.

When the driver received all the frames of a sequence, it allocates an IOCB
to put the frames in. In a situation where there was no IOCB available
for the frame of a sequence, the RQ buffer corresponding to the first frame
of the sequence was not returned to the FW. Eventually, with enough traffic
encountering the situation, the timeout occurred.

Fix by releasing the buffer back to firmware whenever there is no IOCB
for the first frame.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 64002b0cb02d..ab6f58bc80a4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -17950,6 +17950,10 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 			list_add_tail(&iocbq->list, &first_iocbq->list);
 		}
 	}
+	/* Free the sequence's header buffer */
+	if (!first_iocbq)
+		lpfc_in_buf_free(vport->phba, &seq_dmabuf->dbuf);
+
 	return first_iocbq;
 }
 
-- 
2.13.7

