Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525CD396B6F
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782759674; cv=none; b=Ic59C6ihDBKTePoyspDr1WX8YrLRXqhXPbUsma1dr5I7A+/o4tbHD7QSaftW7TIksBbPXatQnAewy7aGk/dF14uv1Hwj0GGw09kndH6ZJyTYPa5e55pQLn65WJ9dDCn7mtJtqWbZQZ3mzF2LEyOD3VMjBYGv7+VlmtkaW9roZHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782759674; c=relaxed/simple;
	bh=OiMr6873tVpbe4uhJZNJ0HQTqhp+3DTr3MZK/Boqnj8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fz5HJknKF/CA6Yc90lRE4o0yiAibz1icn7GMPQUfBjsyynkv+MMMYjsLUHO3AAm3q399r5o/75c5A1B5PSPPWs5ieFvRY2Nk5Y8r4Rbsj8yJwBkw1+bz+Ffmmu3XRVM2ZMjwY8eAkIKQAntrRler+S+ok7nn+kR9q8sVcgLFPoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SLqrwKTa; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SLqrwKTa"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c9bd2f8bf7so16509795ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 12:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782759672; x=1783364472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MdfvxNsaLAGa/pG9tGmiFkHkaCQnRszMYhn1DEf3toE=;
        b=SLqrwKTazGx+XgHDB8I5bLWZd4pyf8JaxuZM+cstS4TDQ4wsY40SUUcaruawS7c18W
         p64GQb8RNd9oFqGHvN9OfIKtPv9VhOXOGqgfg8W4Gqv9IxJ/dQNc9LoWdH7L1SKSrY+Y
         Pz2+ySyxl44oNNNXGMPtH3kCt8Puu/7e98WEZaK7ofazIfgIJyQgyhJwe6NoPzxy/2kB
         FEjou6LF4g2LvMdfIlSHMj25M7E9XMjF8xZYJxx/ch08JulPEUltVPf3An48jetICKwe
         SbB1/YmFpVV33+Z6H7K78OtAy0zkW7gYCPbbyP5A+BJYG+WlIWi3pElYlpxbSIbj1iOr
         YWHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782759672; x=1783364472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MdfvxNsaLAGa/pG9tGmiFkHkaCQnRszMYhn1DEf3toE=;
        b=RuS3POZIpFtlhHW1bbeikinCNy/utDK6tUp0C9iY7nrXgMGQG3CTjTuwGQbEJganLT
         31ICs6Toh6dNB7C8AqFTZFETjT9tOuKAtHsWfMJT8AR6ut0hmsWV90x1PnFrgH6Xx9E6
         Y/h8vA5AzCkJU9n55FMRK/x/OZ3PFEi+SNeoq9Cemol6YF511SumZwFuh9H41sQmITzP
         FRPg8EkhNdM6ReuuwcB7jPjMWutRuCzJ4il/EuUPiqqy9T8t0nGMJp6YVnQtofo9cGPV
         mb2CphnbQtjoYt3DA7fK8zy8Z7UeN1+fU0LPywH8LrFN25/uczrNNogEJMTI2x03OttJ
         2jAw==
X-Forwarded-Encrypted: i=1; AHgh+RoVkpUbx5BgZm1PNSLPV41AASX4CWpaUCk5oos3lGTzd6CV9iap9H3de0KU7bVOSiUKI5zBLxHE0A38@vger.kernel.org
X-Gm-Message-State: AOJu0Yyua46HFlREIt+Jpr2e+0LTB8kUtON+ThFd6PZKecKexV/IjnDB
	nUEpVt6nksWTmN60aaaMHqjzQEwhPhbUWBCBQOspfdRPJz91WkmD+vyV
X-Gm-Gg: AfdE7cmS7nix9vbuoQ44TFm1tlzOzB/CRm1Yd0rirBgyKnZ4y/M3E+uUG7tqeFCGcmJ
	k0+HRrV7XEBM7vakvYXFGqlGpgNMaOAkm/Lo1MEc4RFuaqwOLIW7Hp9XoLkVKWU3eHEsRt5/wkw
	wcmAViSQHEkLLK+6ZeKtIs0b3UtWoG6Xeni+boPjicYwOqFi0T2FehpHW7mgi7qz/kXnlvtN8lJ
	+JjbhF3j9P6DwVbgBAjgMAv2la+DkSawX53UaRlOyH9o1tsPT+PaHT3a11AMyK/0wMjQb8Z9e5z
	K2a0FK0ThjZzC9tdt+XLyYu46usNMkJsEez3gDNMpf39S2uh1Lf7tAAvOfA8fpVxHZQPGMXCroE
	NHTd8CVhJUw46KYIa3oMMpkYP5zRaiYED7WcEhwAGL44reM7r87DxXudjNJmP+3/npquOMIO7Bi
	px/e8TQ5bEwUDq3p0onc4=
X-Received: by 2002:a17:903:1ce:b0:2c9:d27b:af11 with SMTP id d9443c01a7336-2ca2ea353bcmr3474955ad.11.1782759672450;
        Mon, 29 Jun 2026 12:01:12 -0700 (PDT)
Received: from localhost ([2402:e280:3e0d:544:91b3:77c4:f31d:d706])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c9a2a2522csm55461925ad.18.2026.06.29.12.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 12:01:12 -0700 (PDT)
From: Vaibhav Nagare <nagarevaibhav@gmail.com>
X-Google-Original-From: Vaibhav Nagare <vnagare@redhat.com>
To: justin.tee@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Vaibhav Nagare <vnagare@redhat.com>
Subject: [PATCH v2]   scsi: lpfc: Add rport validation in lpfc_dev_loss_tmo_callbk
Date: Tue, 30 Jun 2026 00:31:08 +0530
Message-ID: <20260629190108.601212-1-vnagare@redhat.com>
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
  callback is still invoked.

  The driver already has lpfc_rport_invalid() which validates rport,
  rdata, ndlp, and vport. The function lpfc_terminate_rport_io() uses
  this validation, but lpfc_dev_loss_tmo_callbk() does not, leading
  to a NULL pointer dereference when accessing vport->phba.

  Crash signature observed on RHEL 8.10 (4.18.0-553.125.1.el8_10.x86_64):
    BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
    RIP: lpfc_dev_loss_tmo_callbk+0x54
    Call Trace:
     fc_rport_final_delete+0xea/0x1d0 [scsi_transport_fc]
     process_one_work+0x1d3/0x390
     worker_thread+0x30/0x390

    Preceding kernel log message:
     lpfc_rport_invalid: Null vport on ndlp xffff9c36d412bc00

  Add a call to lpfc_rport_invalid() at the start of
  lpfc_dev_loss_tmo_callbk() to validate all required pointers before
  dereferencing them, consistent with lpfc_terminate_rport_io().

Signed-off-by: Vaibhav Nagare <vnagare@redhat.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b8649c40b537..af56c32708c6 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -163,27 +163,15 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	unsigned long iflags;
 	bool drop_initial_node_ref = false;
 
+	/* Validate rport, rdata, ndlp, and vport before proceeding */
+	if (lpfc_rport_invalid(rport))
+		return;
+
 	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
 		return;
 
 	vport = ndlp->vport;
-	if (!vport) {
-		/*
-		 * Vport is NULL - this can happen during teardown when the
-		 * vport has been destroyed but the rport final delete is
-		 * still processing. Clear the association and return.
-		 */
-		pr_err("lpfc: Null vport on ndlp %p, DID x%06x rport %p\n",
-		       ndlp, ndlp->nlp_DID, rport);
-
-		spin_lock_irqsave(&ndlp->lock, iflags);
-		((struct lpfc_rport_data *)rport->dd_data)->pnode = NULL;
-		ndlp->rport = NULL;
-		spin_unlock_irqrestore(&ndlp->lock, iflags);
-		return;
-	}
-
 	phba  = vport->phba;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
-- 
2.54.0

