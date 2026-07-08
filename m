Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7192B4C9567
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 18:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783536046; cv=none; b=Xa1Y316echiN3Y7vAFfLqZLkakqOaUkGqD274MHyrsf7gG3BdexLTyCCaeYieD+IDk5FXdtilTbtGGAro9c0bb0nS0arw5NaX6EX4lx2kwoxV4YnYBcnFKlKjBL5oDNnqT0+qZ+TGnJvrm8BF+wEX9XZDE6J/REhfCfGeooW6z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783536046; c=relaxed/simple;
	bh=Z9tnK3/W+U3pWyMAGWGFUbtfZEw/GCjuuR9uQ7O3lqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQVSG2S6bzeIhF8iYanuDJOBZo4qu2mDTQn6iuTwGSK0znxyDnp+mVKTokHw8Z/xPsUNFLzQbou/EkV0kqeXlFrc9d8EsXe3+U3cWP/j1pVJE4x/k7DTNdHa+E0wJ89+fl5t3yRzwOxfcmGnjRaSVHb97E37fZUUNORyjLx1BxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CNugpzMj; arc=none smtp.client-ip=209.85.214.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CNugpzMj"
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2ca64c3ce5fso1320865ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783536045; x=1784140845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T1KL9TuON6d8cnqPs/2lVRQx0fDxtDRFYCzB5QxCka8=;
        b=DNXZYVaALRlWjiTtePVaFuSjVb7kop1YogdGMaSpnMobqp4IuKI7jxEr0RwKYSYFzA
         zoBXvOwDUz+ah+JSkGIPNatjyYYaWMvIPh8lmcFKfCxnOcMWsAX0Tox6gGsihj0hRC9c
         OQKpCrokidW7rfHesctXLxATekhfoRd7MAjsWwsc79ccezBDk3AWV4btT3S7N882gkdJ
         BYqWyHsH+GCagFyWCdFNjpnMr3K2jRCLOlQIMLr1uCyNvRsvLkYTrvEVGnGKSYzV4IuN
         DHQalk5uFNhTIKkpLidJ8b0DMtp3xuU5uWSDvoh5HTxR9H79MhzF09zEypZIRlYjIyEK
         bzUQ==
X-Gm-Message-State: AOJu0YynqDvRFOcgfKwMv+dxYJ7V7vNNruBpDYbl9IgqAiaEGVzadI+u
	cKBUL0o9tEBgr8cyBhYBX7hFhzw5Y/WwT7oGJHAZdw4ehYk7s9qwFNtPYZffox2GQr9bxJaDqic
	YjM0/Vgy5wRSYpzAtDN2wCWfO4gpDDHMRbO3C7+hsGh9AerooDun8yYAj7/QaZwZoBpr/0ZhlAX
	o3Lo4Uj4gZE06rsKGBRh+NgZCFnXnuO6jDGMQe7x/d71JtqiCcy27ND7nmL19X21IDsmv9W+0oj
	nzkdww+DJTR3P0+
X-Gm-Gg: AfdE7cmQxkIzO7yMp1lSad+tRfplEQtlt2dbEPvAxHQRS2S+BL2rU+DAQxK/8SRzwcY
	A6vpFsfGWVWxFTYccyhMqJMO2WjDplhxSLOvSN/HzKUbZZfqugF0K0i9oWE0br8HHCAqqsIWPjD
	5mJVO1XGrsHs2h0GR2Z9J7/6HKDBss3IyClCOE9QK6DpAN30+GtNhc02gKL6+AsiKjc2T/km3KL
	HrTHMBBMA77bm3HNlAAkv4rb9jA2uvSqtZrQ53xNZtwIxtBEa/HM6RI0EzhfEdJR1RlhLy9NMK8
	SxAKQcArsOqWxxUNjY53TJzUQF/g+kfZpCevotvPH24VJOc2DhY9iwmP9vIQ/kcv/sC7mFI687q
	FqB2G9hKzMO7TwkzRw965DKf6UgoFFSBvt0N1LE1tzWOSlo9U4uePHkJKbCncMyyw8TTnveg9Bf
	NLT3UXi5D1+aklvnQdQ00lkGOjYv0CkyhZsgFloa9/W5F/9g==
X-Received: by 2002:a17:903:234f:b0:2c9:97a8:8c17 with SMTP id d9443c01a7336-2ccea5962bemr36795655ad.42.1783536044555;
        Wed, 08 Jul 2026 11:40:44 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-11.dlp.protect.broadcom.com. [144.49.247.11])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2ccc9bdd019sm5515605ad.13.2026.07.08.11.40.44
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jul 2026 11:40:44 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c89704da8c7so173065a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 11:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1783536042; x=1784140842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T1KL9TuON6d8cnqPs/2lVRQx0fDxtDRFYCzB5QxCka8=;
        b=CNugpzMj53eIBMRjGmIlNmaj3dQZlWe/W4MqftVGmxdvPviZpQD81Ui9n0U+N/mcNx
         Cg3iK8T0McbvrJYfJp7PogfcvaUNH0pqkDkKb2UwF2XmalfdDn34ShyL6Xcfn0ceVnDw
         vMcC72IpOM6P5LlTXSa0VG2hmIr8Krn3SVwFU=
X-Received: by 2002:a05:6a20:d28b:b0:3bf:6c08:fb9c with SMTP id adf61e73a8af0-3c0bcead1d7mr4427193637.48.1783536042586;
        Wed, 08 Jul 2026 11:40:42 -0700 (PDT)
X-Received: by 2002:a05:6a20:d28b:b0:3bf:6c08:fb9c with SMTP id adf61e73a8af0-3c0bcead1d7mr4427158637.48.1783536042063;
        Wed, 08 Jul 2026 11:40:42 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm19820599eec.18.2026.07.08.11.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 11:40:41 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 06/10] mpi3mr: Fix memory leak on operational queue creation failure
Date: Thu,  9 Jul 2026 00:03:01 +0530
Message-ID: <20260708183305.244485-7-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

When operational queue creation fails after one or more queues have
been created, the error path frees the queue information arrays but
does not release the DMA memory segments associated with the created
queues, resulting in a memory leak.

Fix the memory leak by ensuring that partially allocated segments are
freed immediately if a queue fails to create.

Additionally, harden the error handling path to fix two potential
kernel panics:
1. Prevent a NULL pointer dereference by ensuring the queue information
   arrays are successfully allocated before attempting to free their
   associated segments.
2. Ensure the operational queue counts are reset to zero on failure,
   preventing a deferred kernel panic during driver cleanup if queue
   creation fails during a controller reset.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=6
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 2f787fa36ffd..4b9fff176040 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2481,7 +2481,7 @@ static int mpi3mr_create_op_req_q(struct mpi3mr_ioc *mrioc, u16 idx,
 static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 {
 	int retval = 0;
-	u16 num_queues = 0, i = 0, msix_count_op_q = 1;
+	u16 num_queues = 0, i = 0, j  = 0, msix_count_op_q = 1;
 	u32 ioc_status;
 	enum mpi3mr_iocstate ioc_state;
 
@@ -2533,6 +2533,13 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 		}
 	}
 
+	if (i < num_queues) {
+		for (j = i; j < num_queues; j++) {
+			mpi3mr_free_op_req_q_segments(mrioc, j);
+			mpi3mr_free_op_reply_q_segments(mrioc, j);
+		}
+	}
+
 	if (i == 0) {
 		/* Not even one queue is created successfully*/
 		retval = -1;
@@ -2554,11 +2561,18 @@ static int mpi3mr_create_op_queues(struct mpi3mr_ioc *mrioc)
 
 	return retval;
 out_failed:
-	kfree(mrioc->req_qinfo);
-	mrioc->req_qinfo = NULL;
-
+	if (mrioc->req_qinfo) {
+		for (j = 0; j < i; j++) {
+			mpi3mr_free_op_req_q_segments(mrioc, j);
+			mpi3mr_free_op_reply_q_segments(mrioc, j);
+		}
+		kfree(mrioc->req_qinfo);
+		mrioc->req_qinfo = NULL;
+	}
+	mrioc->num_op_req_q = 0;
 	kfree(mrioc->op_reply_qinfo);
 	mrioc->op_reply_qinfo = NULL;
+	mrioc->num_op_reply_q = 0;
 
 	return retval;
 }
-- 
2.47.3

