Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8E42C21CE
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2025 06:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754979711; cv=none; b=gh+NeDnR3HWbsrYJZ6fgovfbZ/7qfkEt96+4R5EXcBdGrHxSHocA4+sVtnkrbkEynHuMlWhEDJ/rzhu7gU56/uwO4925YXhwwe2TdIjNQLe8Wwui3ESOJt1XH6Q0FKyWW3Q7EMQSOFpRrAJNiBU+QiVFYN7DxiQf2nGpA5/TmJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754979711; c=relaxed/simple;
	bh=j9SeDoRL/zhcDIxNSS4UctRBSHg1RCzqAgMYHl9qkqo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qgkKbFtxRd3b9wWFarXTZPA0OejaNSsMt+3iL/y36JGheBGUMZZ5+V/6VgYjGQ/cIZnaSSyWpBuGWbqnCfCzA9K4SL5rQXjBh1zXp4ow1EB//O9Gv34Zakop9YZJPpUBVNgJlzfRCGMlISWPpCyDikzXmt6eAcNIiIah56AqoEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=JYH5YnHQ; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="JYH5YnHQ"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-76bf3dafaa5so5587143b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 23:21:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754979710; x=1755584510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCHLE6MOqroEiy+1R8X845jTZo3rM4OTlMeoN6yXvZg=;
        b=lVlhvXUvOtIk+KUiDyL71rCSS6me0YONvs4oFeU+pa8c63rtofa/jAkWv93dOwD/jN
         JKbYSSt+rjUR6FdpkFcN3p8NkRYvpav9Io9eHwa9qNqRM86B2eeVKX22JEw++yNWcJLK
         FBWKxJWqwN+8QbHcTVF8RpvMw7WdHsbiioYxMYZg/sQMA90isIJ6vgAFZ6del9nVoLJm
         c20HC+QNSQ7B1R0z4+wqZkmCn/M0Npn0iKDQmdzY2HiXL4id8g6kM9zoU4yJGUef1SWD
         FCrzGfQS8ZgCc7yec7B0ya99/8PTi3fgkDubQI6yCg4y255Qu+HH9ZytMee/Ve+W8DOU
         8MXA==
X-Forwarded-Encrypted: i=1; AJvYcCVb6/ggxCAvCSyVbWCe5SaL1nZ2ogpNlSqzd7OFxeK4eNhAr36OFOrBBzw655/ixRzcc9HcInaoVutB@vger.kernel.org
X-Gm-Message-State: AOJu0YwL/K8KY0ipRynTvfz3H5LwM/PQWkdb8zZ1bC4F3pk2fVfcEl13
	8Ct5mF1IpA9dx9I1Fcr19Qh9ZAJIge8bdPraZwzDyDXLWXHcq+3MyIPhS79BVnxfwE4opx1H4Kp
	UCOaeX3HHJir1XMcvEtcG4iaIX8QB7UFpR9/fE3ISER2VpcQG+U7KmIO1ABJiKQQbwvUePuSMeS
	WxZ29+KerbPHgU14FjjZlmdv5rIme6fTu+r6XDSptJRTiD/OQCQOoxdLpMS0Ko895Bewxv5Ft5b
	ocOoovrnJQ9lkEiX2Nh
X-Gm-Gg: ASbGncsS0+HfxMZ2h6bwbXkmvnt7NZt29Hwgi+iXKx7v76S1kFWTO1xtHxbC2wKsvnd
	Kjf5B/wqXc/DDjpqp3+ZB2fi7LnBbobcC3T9lxOTDJ62g41ki9sryG6ulDv46MTrZl4VV8tWSXb
	56gia1MdkKYAb/0wlt8dHT6UoS0pDAHlBuvffionfOu2hoxkumWmrXF0+O0a3jcz/MR6dtvZoM/
	a6aGBkQxB8k3kKepSx46CuCs6Vo2qJLBi8X/KieF6irANpAgSvEqc7iR9Syh2QHMSoD/1LAimRE
	inV+polbL2yuiXKY3SwObTsJfEyyUzbL2xY3/mjXN2hb+3Var/pwQIJwm7Yy8YsRHLc0s/ivLcp
	HSeOzL307kjA/WPCXpdU7H+vkbuUkB+HmxSL3f+ACgArwm3bAHv7p3J9hhVLjNwAUm1K0UaVeYD
	3dcuqPeQ==
X-Google-Smtp-Source: AGHT+IHOHrxROB1uMyzNatGD8wpf2VZx1JnwzCZQ4+UhTp9sEjEi8uadND3qpL+0di/Vt/IfoKJqSRFo9pxP
X-Received: by 2002:a17:902:e1c4:b0:242:fea2:8bf2 with SMTP id d9443c01a7336-242fea29fcfmr15817305ad.5.1754979709752;
        Mon, 11 Aug 2025 23:21:49 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-122.dlp.protect.broadcom.com. [144.49.247.122])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-241e899d1e2sm18346765ad.79.2025.08.11.23.21.49
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Aug 2025 23:21:49 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c790dc38b4so1132079285a.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 23:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1754979708; x=1755584508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wCHLE6MOqroEiy+1R8X845jTZo3rM4OTlMeoN6yXvZg=;
        b=JYH5YnHQbjvf+g2d+XFQbDxl2nbUFvOxWnBsmHvnGvFI1TWIWIWCVnG2DoR1dfbL2Z
         0J+p6X/inANSbCCX8XWudKGae6KIVgy+n500419nVsgyUyptzq/we3Mqo6sJbXT7sNda
         DskgSjig9wC/ajj7H8A/IMEN0qNYeiV9+qwo0=
X-Forwarded-Encrypted: i=1; AJvYcCUbKsohPgGYmhadShImWPOBujA1r0zwr7LciUsSbYXtDMreK1bwN8Pfg9WTuQY/PiaybvTAlgS2LWcU@vger.kernel.org
X-Received: by 2002:a05:620a:bd6:b0:7e8:71b:96ac with SMTP id af79cd13be357-7e858daee46mr342622785a.11.1754979708283;
        Mon, 11 Aug 2025 23:21:48 -0700 (PDT)
X-Received: by 2002:a05:620a:bd6:b0:7e8:71b:96ac with SMTP id af79cd13be357-7e858daee46mr342619985a.11.1754979707824;
        Mon, 11 Aug 2025 23:21:47 -0700 (PDT)
Received: from shivania.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e826e22c13sm800422385a.50.2025.08.11.23.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 23:21:47 -0700 (PDT)
From: Shivani Agarwal <shivani.agarwal@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	tapas.kundu@broadcom.com,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	James Smart <jsmart2021@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH v5.10] scsi: lpfc: Fix link down processing to address NULL pointer  dereference
Date: Mon, 11 Aug 2025 23:08:22 -0700
Message-Id: <20250812060822.149216-1-shivani.agarwal@broadcom.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 1854f53ccd88ad4e7568ddfafafffe71f1ceb0a6 ]

If an FC link down transition while PLOGIs are outstanding to fabric well
known addresses, outstanding ABTS requests may result in a NULL pointer
dereference. Driver unload requests may hang with repeated "2878" log
messages.

The Link down processing results in ABTS requests for outstanding ELS
requests. The Abort WQEs are sent for the ELSs before the driver had set
the link state to down. Thus the driver is sending the Abort with the
expectation that an ABTS will be sent on the wire. The Abort request is
stalled waiting for the link to come up. In some conditions the driver may
auto-complete the ELSs thus if the link does come up, the Abort completions
may reference an invalid structure.

Fix by ensuring that Abort set the flag to avoid link traffic if issued due
to conditions where the link failed.

Link: https://lore.kernel.org/r/20211020211417.88754-7-jsmart2021@gmail.com
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ff39c596f000..49931577da38 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11432,10 +11432,12 @@ lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
 		abtsiocbp->iocb_flag |= LPFC_IO_FOF;
 
-	if (phba->link_state >= LPFC_LINK_UP)
-		iabt->ulpCommand = CMD_ABORT_XRI_CN;
-	else
+	if (phba->link_state < LPFC_LINK_UP ||
+	    (phba->sli_rev == LPFC_SLI_REV4 &&
+	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN))
 		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
+	else
+		iabt->ulpCommand = CMD_ABORT_XRI_CN;
 
 	abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
 	abtsiocbp->vport = vport;
-- 
2.40.4

