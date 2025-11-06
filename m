Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187F6222594
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467343; cv=none; b=BH/p/oUyHD7HGCG3ENhgxaLNgFw2mB/MKE+tmEVG+/V2X97jpap5UyRsXi/PCmIt+dupJoELaEEL/zonScxJfstVpI5w6cyAovo8mKcP72rOXbbORo2BNaHhDRC/0MN8T+3TMsLPtBNGq+hnYIiiScwCbL7LHsu/snIXPW5aB0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467343; c=relaxed/simple;
	bh=csIMmU13go2KpEAefdnSavPDRJ8F9j9NhBOK2lOESKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UXagaYCk3pxRqDQc4P9Y2FkdPPOWk6/M4L5Z7H7RBFyReVChx/Y2mqWU+I7Trw8avAcIwHX3tLBuTGkvrGG+K9wZg+aGN6Vq2/8HnN0bkIOWX4RvLYoZi+hPPDmRRG6eria6sfmXHfU9M4X9XolCv2sNSVg4yGH6l9ebETjwgio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TfjZZq0Z; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfjZZq0Z"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aace33b75bso156366b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467341; x=1763072141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bdM66Gc6+/k8T6MtlOOA9P/Jrc/3parojDYchCBv4zU=;
        b=TfjZZq0ZC2NYXcCTAj5E3wJEP5RYBnh1LS0158ShUkCWuIbNFEqPJcddZY1rn7Jdb4
         dFa4t+15OKs/ISQAqDkX8haYQzWKkdAlAcmasx6AlHgfcGpJSEywiKWbYwWay7BCbmQT
         lIG9kRi6Jqa9SYN/oaxeeSn8DxCfsnkVdZVGTtSQ7CKJ7P2QvzlQTUSPowFnxHnBx/he
         c7i0Z/BuU0m4TWzGUlYa4e5xadnPhyv7qddtHiZcBQGPcE5XdnP4FxI5DZ1VQTypfKrQ
         1Vlj8XO43DzrcElQQjKpsAAJFw76jMzp0wDEg5CMJvA56uZDsZer5gbxNONPnQ3j9aqO
         CB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467341; x=1763072141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bdM66Gc6+/k8T6MtlOOA9P/Jrc/3parojDYchCBv4zU=;
        b=D4xl0Fa8AdDEwHYzw/dkrNhwFGoTjqqwaLO5F7oK+Csw7lAqI1dM0sP42TQSS0ht8p
         i/gXiB81YEuFTNzlfu0kwzH0inQskSCZi8vOtQ+rCWxHJFeTLkH5LkTtr3hv76ZVQU1b
         Y7PwPWXUkZAyoQkL8K6yxd0pbgMMgW0SFQQDzCqJnqpg9D+ktjmwpfoZXyUriFJ6hRnh
         i4LuOD7tVjntJZiRJISzQR1xN2iuCnCfM4Xny9LIJ+/4MoLDq0DTYxNWWYEhJINsC9mV
         afZHb1x/mUJNlRJRFQqapkvLOxnY0/3joK2Klp4FhrHgqZ4IOw1ctoEpDa/RQ0wxmmHD
         wzJA==
X-Gm-Message-State: AOJu0Ywjut+rJWBeaNvUUuiDWmO9QXM8MaxbDLaYGqhkO9Q0gs/LfMf2
	OVWXJYC/2v3BG2VMt7hHlzRbPoTOJiQlD/tXWQXasR/wGTfdX4wxbvmWnSL7S9gW
X-Gm-Gg: ASbGncv4BXlOVN7gAoOy/SDlHMxQmti7zkAqetE8WcRdNdHi85+gRecbP4xpMY7CiBJ
	8SGrAQ/mBXv5VFdK4ztk9/1gxh1JCSzYzm0o+nEf4dDJ3ZNMP1CE9m/FigVHfknnN+1lw77tR32
	aE0mKRRjAlQki0BtPY+2tskR20V3KTWLjQ1fQn0bMTDaXnCDbReM+W++J2d3xHQzYuz/9XX0jHG
	pNTdP7qi2Db4RdJ0uPKBuNEL4JQFpn9V4IIwJqN1e9E75cq3+m61YI2+yvm/hes+OMKxLSlxjlo
	xhvrOl2MTHhgsKjVVXBxMMOn77DCZhsTsrF/AVBaxOcc6HxXz5G3Mpq7KMHMCMH3jchUrIEtUCF
	UAgjtGxbqNNNzsVfcqN9AmNCx33NJhqHkEuTwMyz7sQrY4JV/cnsy7NCZ5ND13y0hFIeZ/WXmBZ
	2HIojFeby1Z+n2InjJ5hLndu88nd6TuMFQprMlDjIO4+WHCa9bwxuau1TvS1Tr3vQWi7rPcn0=
X-Google-Smtp-Source: AGHT+IGxbSpiPsY1XcXUTh1e46yFU7FiQ/qOaVS6vnPvWMF+83MW6XKBHXowxrLEeEpNek7aZ17glw==
X-Received: by 2002:a05:6a00:2e1e:b0:7a2:7610:364d with SMTP id d2e1a72fcca58-7b0bd5a2d7cmr1359743b3a.15.1762467341256;
        Thu, 06 Nov 2025 14:15:41 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:40 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 01/10] lpfc: Update various NPIV diagnostic log messaging
Date: Thu,  6 Nov 2025 14:46:30 -0800
Message-Id: <20251106224639.139176-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update PRLI status log message to automatically warn when CQE status is
non-zero.

When issuing an RSCN, log ndlp's kref count to the debugfs trace buffer.

Add the NPIV virtual port index to the FDMI registration log message with
the fabric.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 6 +++---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b71db7d7d747..f7c6758557c8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2367,7 +2367,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			mode = KERN_INFO;
 
 		/* Warn PRLI status */
-		lpfc_printf_vlog(vport, mode, LOG_ELS,
+		lpfc_vlog_msg(vport, mode, LOG_ELS,
 				 "2754 PRLI DID:%06X Status:x%x/x%x, "
 				 "data: x%x x%x x%lx\n",
 				 ndlp->nlp_DID, ulp_status,
@@ -3597,8 +3597,8 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-			      "Issue RSCN:       did:x%x",
-			      ndlp->nlp_DID, 0, 0);
+			      "Issue RSCN:   did:x%x refcnt %d",
+			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f206267d9ecd..34386b7c0b48 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9082,9 +9082,9 @@ lpfc_setup_fdmi_mask(struct lpfc_vport *vport)
 			vport->fdmi_port_mask = LPFC_FDMI2_PORT_ATTR;
 	}
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_DISCOVERY,
-			"6077 Setup FDMI mask: hba x%x port x%x\n",
-			vport->fdmi_hba_mask, vport->fdmi_port_mask);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
+			 "6077 Setup FDMI mask: hba x%x port x%x\n",
+			 vport->fdmi_hba_mask, vport->fdmi_port_mask);
 }
 
 /**
-- 
2.38.0

