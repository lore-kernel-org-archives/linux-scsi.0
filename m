Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45A3093B8
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 18:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780599067; cv=none; b=YqCegn5Lc80sdrnMDIxeHidjFaUfYoiOZ/YH4aRU99c3QiWxkh5orvv+C9+mYPgpt4VfN6ntAqtuA7jPkFPYtbvmYX14BsPsb49JAHNUx6FsOhYFumNHdo8Tuj2FbXVJg8sc+/4eXfFK2quiEgAZDwWFqRSwhhGMRbWcqOEkwS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780599067; c=relaxed/simple;
	bh=kMpwQhPqju4oCrvzV8XzrSkHCfWHp71p9nPZ/6qzfqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BzpUUcD+7eiMSA3isyQ8QM+fzWsv3AY0C6dvIllhli5fCPdE86Pfgo2IBFEpiRT6fAjcMBzGmbx/1Tp6AI2cxm5OFuID7lAB5/nMkrRhv0XIOkqhMf7tgU7R1Z+luFPKpolPpPnHGScW7UMvQ5l6hDojZepQ03YmNevzsd8lukg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XrpzZLuV; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrpzZLuV"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-91562bf6c12so144550685a.2
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 11:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780599065; x=1781203865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Meq+S3sUis9q5hh4b+PS0TDRjT62KvcCqdUR4XGhqzQ=;
        b=XrpzZLuVcdiAjnC66zoCX8oFU9+c7u9N64Vy/1V/JoSrPzjooYd2pJhYGAvY+gGsIf
         JFPmF5sH1LznDwan941L71rwsSdyqfVTbl1MwI4EkI8LBEx+5vsVf86VIKfzRFKnfAHw
         ynXFwHFIgNFGsA2tq62xS3/7nkMFcJ3GKQ0Ksr3aie9cmSqJHTVjo1fw3LbH2+GCRXM3
         FWa/+ie5KMPeur9k9nVaXlMZSxNONSuU0RLXcegrL4pvETr8xriMX3G9Kj9QA4JBmsNV
         6f/qN1+Uvf9/zAOE0LbujSgiNADQ0xC7rz/d4+EZoT1daLHVl879VcNNekbSVcPQv4o5
         X6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780599065; x=1781203865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Meq+S3sUis9q5hh4b+PS0TDRjT62KvcCqdUR4XGhqzQ=;
        b=MI0Li9r0DYY64muaNINiIpe/6AyMOGqIAZM/kdPM0i/WlkzZmyRaIX61K6J2ZXs/lo
         GNZCUqSaAfwQgLlk9XYwahHqAUa215E7OBXoFM5ZW8G202dO5hg8HUtkgEw7bMyk4CWV
         kjsAIvlVS8koKms09vPjVXA8PmiOy0K5urbbauY8OkfDhUrrQzZxdMAOhDyDDxvVU90E
         tHSGEZZvMpff0Zz7b+KfWijSa44H5N2gCee5aez3W/qCKhbTKLqD6hX6ttvI+e1eMYHL
         FUOxKTaK3C1RNoMRj8pNpZbi7lCgpBtFzx9UCV9Hkq1t+90YeF2u8XG5p1uKuQ6xqYgn
         dGGg==
X-Gm-Message-State: AOJu0Yw+7xmdaD0JP5jwDG7jcFL6sgGW38qSP2ukzOhXlonRUbOteFd8
	iz+gAWPcwSW394JkOq1W1ZcHyOPhIjI5lJ4t5yY+pB7D8vkTPBBXD57gNbyJgKvV
X-Gm-Gg: Acq92OEpjlBt5vF7pzNy4g0ljXPBBU6rKBjiDo7aOHabv9q+LG8xFlK6srCsKKajxsg
	S/ZX9h1Zo/OFwMMhoOeB4rso5cWKmULdAF3eo1u1N9RPeyqL0GWRxdVc3gTK12R0jIjDYnR9qw5
	DEAY9uXnx7GF4jiqJbulzNpBQ/X5yK1b9wjhSQQMQPh4eYwd+0vG+XW6f/aFUib77hjhdYRtkDJ
	vEDymixbYEl9SWUZQCGzEozjfFQnMC/ot3WD9iQ9p+VGuJZIR2ilRGjfebCfOmFCFGXBSbdAzmd
	H4A1jNwqMvC0Na88zjMEIsCAJJtYZQMgs1CxUYh7yAH9N4k4GJDxZ+m3o5dD2ey6OXMhv3wjXb9
	HB5t2BPotGrbN69P9HlzimTFLTKJS1NRxBhZpNVLAmzV+enuoif60pXdxeieCovumUNVTmC0R5t
	tL+hzKY6JjrtNCncdY0bNeqMP3DksSrUqLyIvZh0HLqtdyedWErUgUgozslQxEVhfrx52c+Ihyj
	ILMHJmUkD//2XKN0LcI0BW0S+Z/tJF6tcNSIcg+BoHmLTDGF+vs9g==
X-Received: by 2002:a05:620a:3190:b0:911:1a2c:f953 with SMTP id af79cd13be357-915a9c8e141mr74555585a.20.1780599064688;
        Thu, 04 Jun 2026 11:51:04 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm651208685a.22.2026.06.04.11.51.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jun 2026 11:51:04 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 13/14] lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
Date: Thu,  4 Jun 2026 12:29:36 -0700
Message-Id: <20260604192937.65605-14-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260604192937.65605-1-justintee8345@gmail.com>
References: <20260604192937.65605-1-justintee8345@gmail.com>
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
index 27ccd3ad4b7a..c5f3fae0ccb4 100644
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

