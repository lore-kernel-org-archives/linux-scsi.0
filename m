Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076881A8F97
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783989481; cv=none; b=rFU+9ZCeM0MKP8OZX+PyUU7Hjs3OCt5+6uUywUhwLAFpMTJyrRPBL2Vh8H8tZN//SC9zR792P6LnosWQiKTPut5ExKdzUHQg5O7nSA8ly0twYZn9o4trPcAx6AKqyAeHqSvmOTFjzFTy7twM9HD3NOdq61cJ6arhWHSsk7+vIWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783989481; c=relaxed/simple;
	bh=2BvYiWuMvX1hZeoIZD56kiWWI37BXX2UPCsphGzSeUo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q7s87XP9a9l6VDf4fHRY6lhVBhvDOKJcb2tUFpd5ITTJMd4FRB98sj0CkhVWZgGgUutwwue+HOUUyJh9zBg5Ytk9MrzJkLsDcuX7SCmXK9FlNVwbmESlJrNBo6Ym9hypzcegFsoBdYP+t7Und1vtQVQutoPX0yIGmljH2AdH9m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jp+plSIJ; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jp+plSIJ"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e4fd65b2bso35077585a.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 17:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783989479; x=1784594279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iJLEqNR6u9b1mJhxtJWEAfN7AcqGBcJ0eys2WErMxWs=;
        b=Jp+plSIJKJx4bfTc8jGg/mPZBJi/XApquQ9znqmVCgVS8N85JBx/u3h/p2yNNGLrt5
         udfA0vdbDC88KYcbG2yvRW1/Yr2cKiIHtXjqAK+Q6XeOR/Zgu2Gfy6zewzGgYejUxB9B
         J0W5Hev6xkdhROH04s1ASvhcINT2WlK+pm1d65aSMqq4tXubdOfdNcCB3u3wBXrpwekB
         bIPdixhWQxyhFu/Ut9TWkUQpgCjbYnaXR7/apqEtkymCWY0FMsx0/4+HAx9tD9U6JAvQ
         w7jrO+nCH1PGvnYvDPOFH88cJR5yQsBN841T1STwhuORj6Y58ub/U0vp7AKwmYxa3AZP
         e5Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783989479; x=1784594279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iJLEqNR6u9b1mJhxtJWEAfN7AcqGBcJ0eys2WErMxWs=;
        b=YRQXLkGL8IRG8YWUYD3NzCr5f5YK+tIx6Gfnq0+dBb6P0AmvK4W45mj5PygJEVlZeE
         TNyozFCBppJkFxWKTtx8UoQw7YFWI9K1tkrrsDiy4uVPpzxaseyFyI1q85fqzS0V8qyf
         kXEuwar1G7tq2Hh59fx6xFN9pEZIwsBYPYJs3JDRlDuKRScgtIgmheAPF9KGZPCr9RDQ
         sGTiCtWZemJh93g33CW17r6cBdfdoXkyAnICIbu+D63ILuRd7BTOk8013O8RSaCOo8/Y
         LRI7HInHi/FOeJfomWf5iTghzUFJU7Up08lMjSSuVgmxbPPo8EzwQBxudl32DtWgjBOB
         +bkg==
X-Gm-Message-State: AOJu0YwC3PqLpm8nxjkYymBgwH1yXoqAMQ3XkF7SUOxr6/i1ivOmcvjm
	7+SYj7uWbhKQlrlPsM9xS3I92iveFGkKzc3QSQYUbvnOGf+B2crMsmnb3AD8tZAz2lQ=
X-Gm-Gg: AfdE7ckM73zg//LRlCRc2AuiMABMDmIKnYuF8dfqJ3oLjm87RTr82vV3Xsa2UF4EkTE
	rrMPcraX71rNoMZaa5SyYXdtZ5FWC+ns4xWpUmhOkFQ8r4lAFVHvwQ5/5P1weoyTHt54y8qkhSp
	p/9V5N2YuTotZyONRPm/0S+cLF69jPjvsG5dmtSps/OCv3W7gdljft2eac+MBTqR45kIaZcBkRw
	C3VQPCIHxBWnUkyspWlQjY+/mwFq1RbpdmHFl9er4oFTUJaLSQ3zZS5Nn2piYwi5WIfLk8PMr/E
	fCWf3yXWSr5uOZWcKaXnj/DnJ7RXv+ZBWYCSVhsMHQgZZaqvyxTH4YVWd62JDjUBolXKZ8pmfOj
	KR3bl9upYcqemzZPyPwiD7E8M4uojAMgapKlmuZIdPYuiM7mLwtbCpqSOuYFUx5TpWRV3fJzlrM
	Bg0vD6geozngGKdRul53Y0lzUH8EEVa0m3wAuwt5E3fkuhJfMes2Ju/xgt/2DFgYzMm1l95JUrJ
	oK98bGHHp/V65/jGJD0lyRtjA8tKu0b
X-Received: by 2002:a05:620a:1787:b0:92e:c118:18c2 with SMTP id af79cd13be357-92ef2cb6546mr1051473385a.77.1783989479095;
        Mon, 13 Jul 2026 17:37:59 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d6c28bsm1289899185a.46.2026.07.13.17.37.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2026 17:37:58 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v3 13/14] lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
Date: Mon, 13 Jul 2026 18:18:11 -0700
Message-Id: <20260714011812.106753-14-justintee8345@gmail.com>
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

The lpfc_set_disctmo routine is not used for all cases when the driver
needs to restart discovery on the fc_disctmo timer.  Not doing so, makes
discovery timer actions invisible in some cases as they do not get logged.
This patch substitutes calls on fc_disctmo to use lpfc_set_disctmo in
lpfc_els_rcv_rscn.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0a7e69dcb2db..0c5524c613e5 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -8383,7 +8383,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t payload_len, length, nportid, *cmd;
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
-	int i, tmo;
+	int i;
 
 	pcmd = cmdiocb->cmd_dmabuf;
 	lp = (uint32_t *) pcmd->virt;
@@ -8462,11 +8462,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb,
 				ndlp, NULL);
 			/* Restart disctmo if its already running */
-			if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-				tmo = ((phba->fc_ratov * 3) + 3);
-				mod_timer(&vport->fc_disctmo,
-					  jiffies + secs_to_jiffies(tmo));
-			}
+			if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+				lpfc_set_disctmo(vport);
 			return 0;
 		}
 	}
@@ -8497,11 +8494,9 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		set_bit(FC_RSCN_DEFERRED, &vport->fc_flag);
 
 		/* Restart disctmo if its already running */
-		if (test_bit(FC_DISC_TMO, &vport->fc_flag)) {
-			tmo = ((phba->fc_ratov * 3) + 3);
-			mod_timer(&vport->fc_disctmo,
-				  jiffies + secs_to_jiffies(tmo));
-		}
+		if (test_bit(FC_DISC_TMO, &vport->fc_flag))
+			lpfc_set_disctmo(vport);
+
 		if ((rscn_cnt < FC_MAX_HOLD_RSCN) &&
 		    !test_bit(FC_RSCN_DISCOVERY, &vport->fc_flag)) {
 			set_bit(FC_RSCN_MODE, &vport->fc_flag);
-- 
2.38.0

