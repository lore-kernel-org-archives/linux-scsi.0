Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1071C8FAC
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594384; cv=none; b=CUWb3YTIS+gK/6jAtdKwtc2fV1SPH1gfm+aSDjjudXgxk4U7xegy15jHEjrL6uG5D6xynawBHpckw2pGMTud9pQitt2hXmuTYRa2lYN2Z9dp5x0s6Qw5e84KbNEiwXH63EkGzxLdyaTpdYcXjsjUh86O/YBVmbbgQW3Qe8PJtww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594384; c=relaxed/simple;
	bh=3DxkUpuv/j+Sfk3qXa7C9XWSyljvkIE1MhjgYWto29A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tcSXOskJ5CO2b6MqbGq3MEyc+jLWs+hQZB5Xla2VnbF62DwrdrMBDiWu1MotXmvB/NYBU5vUytQt/8WhZ211xcGAtVaOykPjTPNFIGqfpQb1hJaJ7dRwzpQrodu0Us6SQDcvhoD8lmZQHmFgK9ZVmLtGuDW3v/ZSox8KsBcWt04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ib0a8Rnr; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ib0a8Rnr"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3762c172d94so488025ab.0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594382; x=1720199182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sKRsAY0jHyrEEfswJbETTj8mOq9QvVjI6YaRHp8y3XU=;
        b=Ib0a8Rnrw7DG/j+jtVc2f/5iFLXmzzObqlThUYnH3UugwnBa6OdpyCAkfFJb6UFnb/
         mW5TYOD8uOx+d8n8sQJ7d2kVZ6CqkboVa98JIraK3dHl28VvEAkFyTn0LXrFlvOpyMb3
         cqgT3KFsWsfZeizMmBD7l3Uftz10BhnakFnDQTSq+ooL498Rvd7pxoLAt4Xqor/TTByA
         C9buwZd0xp0WEiTUgYQGgcMlu4wIF/Zd/Hd8KWI4mCQ0wGU/Nut7uMHKe8mAJkkHaeni
         BzKIiziA4kTQ9ykDKGgSLR14Kk60odggULFWu2iH3Hvq944Ptwl4liJvMSZQG1UHD5ko
         hj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594382; x=1720199182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sKRsAY0jHyrEEfswJbETTj8mOq9QvVjI6YaRHp8y3XU=;
        b=svms1fJwJN5PTosLe5ZIRKV7DFWlIJWClVomKNV55BX0GIrbUN1LWQ75fQkhU7ujtM
         FxXPm3esfP9YQqw8tpfSeqVOJdiOFKfPBB4r8aKEv+gf2sIV+OF5k5DGFbqo2EhSxxi9
         Qcw0/m3J1z5mhEMQb1K4farPnjaXy8LIWBbXwqTYFkhRgiQiC2aGU024etM02c5+hZwO
         ef44HmCHqL+5TPRqy0XyANmZrv+wN1Q+JWVIYZuI4lAQLgPRtmZpwuheNzJjGH1bvmWQ
         QeFvWW+yKS8Dmr9x9jZ5I2MBjPWWF8TFy+Z3wncl+wZT0I03KfaTbFRMxJTAmh3VEvdZ
         wh4A==
X-Gm-Message-State: AOJu0YzXS62RW1/stb/0lBTlZyphXT2z9ovuyiSWii1cCHa4FLMgbBZ2
	co/Ga1/NEkR4wDIiwBL0fxaZRIX4XhY+0zrwbc5gcHTXH87VcOWafxD6Mw==
X-Google-Smtp-Source: AGHT+IHBErmEPl6Yx0Zwkg7OSU0SK3Yl0j8Oylau1Zprj7GBu3I7z47htPch3xmt2/NSgG4/kSikGA==
X-Received: by 2002:a92:d28c:0:b0:376:2361:d2ac with SMTP id e9e14a558f8ab-37638b5136dmr149638975ab.2.1719594381782;
        Fri, 28 Jun 2024 10:06:21 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.06.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:06:21 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/8] lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
Date: Fri, 28 Jun 2024 10:20:08 -0700
Message-Id: <20240628172011.25921-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240628172011.25921-1-justintee8345@gmail.com>
References: <20240628172011.25921-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The MBX_TIMEOUT return code is not handled in lpfc_get_sfp_info and
the routine unconditionally frees submitted mailbox commands regardless of
return status.  The issue is that for MBX_TIMEOUT cases, when firmware
returns SFP information at a later time, that same mailbox memory region
references previously freed memory in its cmpl routine.

Fix by adding checks for the MBX_TIMEOUT return code.  During mailbox
resource cleanup, check the mbox flag to make sure that the wait did not
timeout.  If the MBOX_WAKE flag is not set, then do not free the resources
because it will be freed when firmware completes the mailbox at a later
time in its cmpl routine.

Also, increase the timeout from 30 to 60 seconds to accommodate boot
scripts requiring longer timeouts.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b27ebb574bfb..929cbfc95163 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7302,13 +7302,13 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 	}
 	mbox->vport = phba->pport;
-
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
 	if (rc == MBX_NOT_FINISHED) {
 		rc = 1;
 		goto error;
 	}
-
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		mp = mbox->ctx_buf;
 	else
@@ -7361,7 +7361,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 		mbox->u.mqe.un.mem_dump_type3.addr_hi = putPaddrHigh(mp->phys);
 	}
 
-	rc = lpfc_sli_issue_mbox_wait(phba, mbox, 30);
+	rc = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_SLI4_CONFIG_TMO);
+
+	if (rc == MBX_TIMEOUT)
+		goto error;
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe)) {
 		rc = 1;
 		goto error;
@@ -7372,8 +7375,10 @@ int lpfc_get_sfp_info_wait(struct lpfc_hba *phba,
 			     DMP_SFF_PAGE_A2_SIZE);
 
 error:
-	mbox->ctx_buf = mpsave;
-	lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	if (mbox->mbox_flag & LPFC_MBX_WAKE) {
+		mbox->ctx_buf = mpsave;
+		lpfc_mbox_rsrc_cleanup(phba, mbox, MBOX_THD_UNLOCKED);
+	}
 
 	return rc;
 
-- 
2.38.0

