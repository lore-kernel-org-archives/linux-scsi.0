Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BF71632DD
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 07:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770880035; cv=none; b=X1d+fbVFoQLmvaB4ib4M3K6jjVvtBBwSBxtHl1Cbhr+9+LROYbMuUoedmICdKPLu18ud6KuFDSbTyqCtpGirvMXPpLY/ASgiZmoOqtPIYDMnngUFEBSHeRfqqPm1TBxtAGdVwG8uHXx9SAUS7CN8Fw1PdaHs89/gmIsivvXJnUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770880035; c=relaxed/simple;
	bh=mf93LmvuVleMuIursqf0aGMGODK5jvo+op2GbXlaUM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o5NiZywHj4GLQoNSriTDOFf5TFBHG0l+1UsYHbRbAc+SMZxZqMrf7Ur2jyDNTmYYem7ax7IehJBsEqfYVx/tJlW4ElusRubvNLbGwBPsy5mp0/JEIrPBcrFljFDh/RqOjd4Lyn2FWgtQsPgNy1DLZ8o459KBeNUAqSEsmQ4BEhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SVjY03Yw; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SVjY03Yw"
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-8c52f15c5b3so748630785a.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 23:07:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770880033; x=1771484833;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HUuTOXQTmROFqPiRxzQHAENtLTb5yfjULAN3N22DQFM=;
        b=LqHps3MWmmiAoSyfD/ysOXpS2VBKAxjdOCkSwUgPWnm5BAfDLZ/3MW1DAfvizQYBwJ
         uih8FES9GFtz8DGOdVX7OhEEW9oxWWL4QXxG0xpeEBGDwiv7afrHvSzU0VGOHtkOo9QJ
         Z7nNBio/rSuzbcBaMRw4H14qDGmW/ly41pidDPKi0Hz53Sp1Og7dR97lBpCafSNfpG5g
         Ssbb0++u6qAAXgxZwq2eKAoAAHwnAakYlqfOp/tVumlzoB68vxZ5a94oy6t6w4YHbWIn
         Mqbp5Glu61SRUSMEMwfPP/0dsX4hNGkdVXS34hQLgAyuwdXje2/GBDEG63rWbPF+eLcs
         au5g==
X-Gm-Message-State: AOJu0Yx/POz7x2xMZpsKSL6QAk85R24evVjxy7LwJdJyRNLe1jsTBPsG
	V/J2ApJSj3rcizFo08LtNxTCjwlsYjquZQmAUypvS8XPDGiNQ3YM/oA+Et3Y4+HgSVdwq5uz0+/
	vd0z6rJDDR65jgcII+ZPeUUD8j7Y+PgCis6UpyIs//qt/8HHmT5qFgSWCF2VuvpZT/Yu79gvp4N
	qUx9fcG8cLCmIdyOWaI2uI0f8sNyQgzkf8xAoeuX+Nlbosovvi4ugyUmGHgo8+Wc4sJ3SLnf3yM
	+aDSK9GnJ8NQG7B
X-Gm-Gg: AZuq6aIVTBMt6pa1bKsEvMm8ZTCAay3BYb3BagFHDmWoGFHbJ6wi7dukYtMkJ5OJ1e1
	lZ+hFpvS8JMhzsweIVL2PIhtUU7s74/raMglsK46v+uENUafBT87CN52pMxj45m3KCNMQsn3TYj
	7xsfCxnbsotTuvxpcyQ8KATEvd3cSpuTQMQSIeX8df/sK9vC7WS78Tg7WAVujeqnBVF+0/8EVip
	4Q+DgUvbVCXSTNnfn3t74hBtxdtnOd/bdLuU73tczi+GmrmHTYFHONCxl8yUwFSKM5Me0i+SOAa
	uGd0CPoMmEm1kvoTUzLuYVJh0HMG783fFtQLdCLLzdXWGvUi+jIA3TonBuNihZOaL0m55hYkGkZ
	7qYSZoSov9WLuyFXiQ4dqkdtIrqXQ8TAcPlqzMB8u+ZdpTjFA+yVtLpI3Ht4PsvJXRNqjHRVgEU
	o4rClJZFgdh+4h5T2UePj/OGo4PkP+J6tx8PQZ1LjQTDXPINPZLpbbsQ==
X-Received: by 2002:a05:622a:15c3:b0:4ed:bb39:9a63 with SMTP id d75a77b69052e-50691b9abe3mr27333621cf.39.1770880032659;
        Wed, 11 Feb 2026 23:07:12 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8971cc8f072sm5080076d6.11.2026.02.11.23.07.12
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Feb 2026 23:07:12 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2aae3810558so60720135ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 23:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1770880031; x=1771484831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HUuTOXQTmROFqPiRxzQHAENtLTb5yfjULAN3N22DQFM=;
        b=SVjY03Ywn2DSQRKd6Jgp59BkiF83Ak0przOZDn2Y+PeQMsSZXenvMKafwufbM78M8H
         3Ya1WoxO4AoavZ5BIiwTon+fHZ3CKfyUkAjuLkm4JS3D97FFk2GFSFgrxX1pdPP9LUy0
         ThWTrEjHuDaZ5FDqTfmyxu0TyyhfmMHDRKHFk=
X-Received: by 2002:a17:902:d4c9:b0:295:fc0:5a32 with SMTP id d9443c01a7336-2ab398a9436mr15179375ad.3.1770880031205;
        Wed, 11 Feb 2026 23:07:11 -0800 (PST)
X-Received: by 2002:a17:902:d4c9:b0:295:fc0:5a32 with SMTP id d9443c01a7336-2ab398a9436mr15179195ad.3.1770880030728;
        Wed, 11 Feb 2026 23:07:10 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab298706c5sm43418245ad.33.2026.02.11.23.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 23:07:10 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1] mpi3mr: Add NULL checks when resetting request and reply queues
Date: Thu, 12 Feb 2026 12:30:26 +0530
Message-ID: <20260212070026.30263-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The driver encountered a crash during resource cleanup
when the reply and request queues were null due to freed memory.
This issue occurred when the creation of reply or request queues failed,
and the driver freed the memory first but attempted to mem set the
content of the freed memory, leading to a system crash.

Added null pointer checks for reply and request queues before accessing
the reply/request memory during cleanup

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 34 ++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 1cfbdb773353..04d4a2aea7d7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4806,21 +4806,25 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	}
 
 	for (i = 0; i < mrioc->num_queues; i++) {
-		mrioc->op_reply_qinfo[i].qid = 0;
-		mrioc->op_reply_qinfo[i].ci = 0;
-		mrioc->op_reply_qinfo[i].num_replies = 0;
-		mrioc->op_reply_qinfo[i].ephase = 0;
-		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
-		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
-		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
-
-		mrioc->req_qinfo[i].ci = 0;
-		mrioc->req_qinfo[i].pi = 0;
-		mrioc->req_qinfo[i].num_requests = 0;
-		mrioc->req_qinfo[i].qid = 0;
-		mrioc->req_qinfo[i].reply_qid = 0;
-		spin_lock_init(&mrioc->req_qinfo[i].q_lock);
-		mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		if (mrioc->op_reply_qinfo) {
+			mrioc->op_reply_qinfo[i].qid = 0;
+			mrioc->op_reply_qinfo[i].ci = 0;
+			mrioc->op_reply_qinfo[i].num_replies = 0;
+			mrioc->op_reply_qinfo[i].ephase = 0;
+			atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
+			atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
+			mpi3mr_memset_op_reply_q_buffers(mrioc, i);
+		}
+
+		if (mrioc->req_qinfo) {
+			mrioc->req_qinfo[i].ci = 0;
+			mrioc->req_qinfo[i].pi = 0;
+			mrioc->req_qinfo[i].num_requests = 0;
+			mrioc->req_qinfo[i].qid = 0;
+			mrioc->req_qinfo[i].reply_qid = 0;
+			spin_lock_init(&mrioc->req_qinfo[i].q_lock);
+			mpi3mr_memset_op_req_q_buffers(mrioc, i);
+		}
 	}
 
 	atomic_set(&mrioc->pend_large_data_sz, 0);
-- 
2.47.3

