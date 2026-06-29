Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23E643CED2
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782749164; cv=none; b=iW3vpQFzfXOi2HEzrnAMK8gB0++F7v+sf7exyb3dceUSp89Ot78k+CPrDbCuxj0hBX9lEh9d8X5x4quuofs1LqO5j/cLjhnjqm5FyY8SmeCecdHmKf4Sd+7nvLCYVwjjoc1Q+cCoTXAa+43+lit2azKJt0NZqLiVpXFYGA6m4io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782749164; c=relaxed/simple;
	bh=H/8jVrSXBxhHwqpzTE0jtCxS48mDZRKDW/De/WwxWIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Npb2Qpvf1QMY56QhjuY2504JU+AqigGCsVJwqQurR67e07wLszBn1Mg42BNyfesw2bvjU6rxNAV8E302d6zNweZKPddbXBWMJzK9xexyCDyKFyz9xhA5ob07e5h+IH1l5hpPzPGywk1oMud0gJTBPPzObDKz8o+FDrE6voUpnJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J4hnnUCn; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4hnnUCn"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30e9eefa268so4531720eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 09:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782749162; x=1783353962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=07DkbqrxkEWB9InrfnVwkuUXGu+LKrL45AaBp8JNff0=;
        b=J4hnnUCnbtO5m2WsrU3mp/j3LueM7F9Z4ZEZld5jdYmx/1SgMzRxMlixyZOXXgEFz5
         x/QhWxQ3G9xjOw8wVm6sCnVpocOgQhiBZScwbn8/5iWlL7LOBw0O+OC9xkNmBuhI6uvm
         LtIOsUxo7icwU/I9uewpXNLZmSqg2AV/wOhGgj1oPqvTXSbr5gCLwLB2i7xeLYWAIJAn
         ervtbivMsciZ+QlEr6JPDQ+OXi1/+JY6ezCglgyNLDO6NjLk/yCHZ9Z4F2cEvQHB6CZ9
         PhNPzsD+CbSTe0+x9Z7AGuC1pkPJH0F3918/ebXScyZpDSEL3FSlTdcc3CHgUWnxfY51
         yUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782749162; x=1783353962;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07DkbqrxkEWB9InrfnVwkuUXGu+LKrL45AaBp8JNff0=;
        b=VV6nGfwJoGY4nINXuofTBiaUmF0IjoOzqOZNjNuEu4sQYo1DNuoRHjS0fACP4a0QTd
         diJYkMFG2pcD8tfzSX3ltESg0CYp3K0yUSDmJ7kom5yE3HiaqE5XsGLrFexrEj4izENr
         pOLVQ5jNCStKAN0aQshVSz+89nvVYwLvD4YvM6aRHD3Z+dbq7go05Vc54HLHj7bgG8X+
         MpWRpv4eLg1Jd/fGwWDqvdJ4UcIXEJ88j9rSRoil3FjulDGaKKaOFl87u60zNG5aywq5
         TgIA6zGbHCdGlyWtA11Wb3KbadEKPY03NmhqDMjQne5dyKgpIwbdq1e9WumIQHdfVTFn
         piMA==
X-Forwarded-Encrypted: i=1; AHgh+RqkOQ6aNMV1ttXMK6ceXqxlQ7pcyPva/Ow7EB/zLrmJT0CfiL6wC1Y7/ZDz7w3hyiZlbd8lpOSUjC37@vger.kernel.org
X-Gm-Message-State: AOJu0Yys3/lB+MskXH7RPvt2bB+PKto4CsfImnFJN3e54Z3Qjc5ZxaYc
	3ltPOiWNP/g9eRL5tgfWBXnNgOX1E169EjZXPK6StLK/lGTjUC0hQtAQ
X-Gm-Gg: AfdE7ckhmQM62Z4arYqceod0h29VpLgiEfw5fIRvdUOFiZrVHBpDo4PdxdV+4c/vqFr
	sWXkhObrRvq7dTff14jcDllyVdqMqwsSiegqjJJNiuEP47CXv/U1c0C6kJpuhy1E3ikPyXR/EQm
	o37q1WKQU98Sv1gaygjPRow95XCGcE7AhQJxm8Rrr6+0O8ferGSU6xAAkI3L8WhyQ9lMDzwjpMO
	xudz+GRX/JtfNLvcRpJfAWd3DI3hLzCBV9bD2fbLLk6E1fJLcHJ6vb++ZP9cBorWXS13ud7mFFZ
	CBhnn4ubWb8d1BPV2nDQ74mv6GGCk+UHrUEya9f/qu0jBEtVf9+Tg045N6ffpnHFF9m5VFSJH6Z
	nRjF+9Vv9VG9z+/+Ox3aHIYHMhribpSbE0R70aKx5b5fYFuG9OVbhFtM0yhifdjkbpxhZruliH9
	sIY2G1stDWmk7L/yzNtvk=
X-Received: by 2002:a05:7300:7c12:b0:30a:e531:3141 with SMTP id 5a478bee46e88-30ee128f22fmr67702eec.17.1782749161669;
        Mon, 29 Jun 2026 09:06:01 -0700 (PDT)
Received: from localhost ([2402:e280:3e0d:544:91b3:77c4:f31d:d706])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30d3af0d2e4sm27718674eec.22.2026.06.29.09.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:06:01 -0700 (PDT)
From: Vaibhav Nagare <nagarevaibhav@gmail.com>
X-Google-Original-From: Vaibhav Nagare <vnagare@redhat.com>
To: justin.tee@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vaibhav Nagare <vnagare@redhat.com>
Subject: [PATCH] scsi: lpfc: Add NULL check for vport in lpfc_dev_loss_tmo_callbk
Date: Mon, 29 Jun 2026 21:35:57 +0530
Message-ID: <20260629160557.586208-1-vnagare@redhat.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a kernel NULL pointer dereference in lpfc_dev_loss_tmo_callbk()
when ndlp->vport is NULL during FC remote port deletion.

The crash occurs during fc_rport_final_delete() when the vport has
already been cleared on the ndlp structure, but the dev_loss_tmo
callback is still invoked. This is a race condition during port
removal where the vport is destroyed before the rport cleanup completes.

The existing code checks if ndlp is NULL but does not verify that
ndlp->vport is valid before dereferencing it to access vport->phba.

Crash signature observed on RHEL 8.10 (4.18.0-553.125.1.el8_10.x86_64):
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
  RIP: lpfc_dev_loss_tmo_callbk+0x54
  Call Trace:
   fc_rport_final_delete+0xea/0x1d0 [scsi_transport_fc]
   process_one_work+0x1d3/0x390
   worker_thread+0x30/0x390

Add a NULL check for vport after retrieving it from ndlp. When vport
is NULL, the port is in a teardown state, so we log the condition,
clear the pnode reference to prevent stale pointers, and return early.

Note: Commit 1cced5779e7a ("scsi: lpfc: Ensure HBA_SETUP flag is used
only for SLI4 in dev_loss_tmo_callbk") addressed a different issue
further down in the function and does not prevent this crash.

Signed-off-by: Vaibhav Nagare <vnagare@redhat.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f3a85f6c796e..b8649c40b537 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -168,6 +168,22 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 		return;
 
 	vport = ndlp->vport;
+	if (!vport) {
+		/*
+		 * Vport is NULL - this can happen during teardown when the
+		 * vport has been destroyed but the rport final delete is
+		 * still processing. Clear the association and return.
+		 */
+		pr_err("lpfc: Null vport on ndlp %p, DID x%06x rport %p\n",
+		       ndlp, ndlp->nlp_DID, rport);
+
+		spin_lock_irqsave(&ndlp->lock, iflags);
+		((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
+		ndlp->rport = NULL;
+		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		return;
+	}
+
 	phba  = vport->phba;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
-- 
2.54.0

