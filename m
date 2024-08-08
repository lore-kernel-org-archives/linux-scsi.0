Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CE81487C0
	for <linux-scsi@vger.kernel.org>; Thu,  8 Aug 2024 12:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723121882; cv=none; b=lq3YoW/kmQFMYjOqRRVIqg7rNb0JWW9uZmEtfM9qajK6BWmu8Ee0l/gf6jxxe9N4sBKwKjzdADeFwWAtU6bwCy1eoGze9fBHOpgeeEzh1knL8Vcv9l/RcdlhwNLEtSj6EajJQufJw10boXFBWOQKCx3lT8LW0Yb4AiJ8Sf0uN1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723121882; c=relaxed/simple;
	bh=aW4SDonbT1xbqqa4jbLH6dE8gmUvXVznsjKD45xV+wA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iGS3VigbfNFCxAociwbUVNTnPmoUoXY/8EdG1KaHeb6JlVnHrVcH5t/pdWfLIq7DcAzRP6bBkLCUL3UGo+40bNWMVUPIK5ecDQEC9169h0YuJxVPZwhShC18921qjdDUSYvhTl/jDN+5jNUty6FcjuY8Ha+/Z2UP/GnNtlSfIGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GI58Y0Ih; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GI58Y0Ih"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fd66cddd4dso9443775ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2024 05:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1723121879; x=1723726679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nUOAJ+nPzc510/DBQcwvUkvU0Xns2JddaOVC8E63Onc=;
        b=GI58Y0IhYnvEO4O10Gh1lix9hIBkRUr4nkNh9Nobm5wnf4XQHsGQaIJHt3RCrRVMfi
         6yA4X1HaE5UIQCl/IR9q1EqB/BdF9D0ioPnRi+WwV2u1eKVDtOyE3Ox4OJRO9XmWoLpw
         l85u0drWy/UAh7LLMlG7aPqCfZzzedwv9TI9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723121879; x=1723726679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUOAJ+nPzc510/DBQcwvUkvU0Xns2JddaOVC8E63Onc=;
        b=jhmRsuciQxelg4eX3nnW9Vd2TEFSHm85DcEEi7mOtKR/Aun9i9zuR3EX1iCCmVBqoD
         uLy/3ovLSv+/InSKhleC7viN9IDs6LiOaZfA9OHV8Dl9cHcKXlp+LSK71jLQHZ3YKgmw
         rzUj4g9ACeHOlSJWS7XYt0nG5ucqy4luGeaZNrjArs0spn4qL58YAPSKbBDZltdh8ieE
         88UTAikflIQYYr1UOc7AQ6gob4a5UiyyABqCPlea0/qSZStkg14PlrZMm3wDdCo+rp/W
         WD3/rK4z8DpK0R4jKDbyQOzJlxuFUKTFg1qun7TKkHhQKi0Jln0wIC9vBBkZ2sP6AK8q
         5OMA==
X-Gm-Message-State: AOJu0YwYwkjXSdfubIA9VxmT/rcnJGBjYSoji+oUGpn/MyUG+uZmvtQn
	zlvb0uXyZnenDjVm8j0ndI87RwnR7NZo6K4DWtLgRi2Ra3XFtiggDU/0sAvIGdE2arEKgugVTMr
	qHFql22fHPa2cKoGowlBXQBg7ooAE0oorI+NKVrQ8iTcuafLu/nfJtFKd+0H0xHn219rY+vVlMF
	z2Z4wqV6at1hXuFn+JH01oHuBFVmiAmu6BQ5bCI+g8jDLuBA==
X-Google-Smtp-Source: AGHT+IEuqngFK4H7IoCS6ywvLKgFHEyhCeobHhsl2TMdyVgem37wbkV2KyGBSowCRUlu7uCPHxFeIA==
X-Received: by 2002:a17:902:cec3:b0:1ff:4967:66a with SMTP id d9443c01a7336-20095266268mr17879975ad.14.1723121869154;
        Thu, 08 Aug 2024 05:57:49 -0700 (PDT)
Received: from localhost.localdomain ([115.110.236.218])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff590608b2sm123283325ad.152.2024.08.08.05.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 05:57:48 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/3] mpi3mr: Update consumer index of reply queues after every 100 replies
Date: Thu,  8 Aug 2024 18:24:17 +0530
Message-Id: <20240808125418.8832-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
References: <20240808125418.8832-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of updating the ConsumerIndex of the Admin
and Operational ReplyQueues after processing all
replies in the queue, it will now be periodically updated
after processing every 100 replies.

Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index dc2cdd5f0311..cbb6e4b2d447 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -213,6 +213,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_HDB_QUERY_ELEMENT_TRIGGER_FORMAT_INDEX   0
 #define MPI3MR_HDB_QUERY_ELEMENT_TRIGGER_FORMAT_DATA    1
 
+#define MPI3MR_THRESHOLD_REPLY_COUNT	100
 
 /* SGE Flag definition */
 #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 169850393580..6eb5bcd8e757 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -443,6 +443,7 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	u32 admin_reply_ci = mrioc->admin_reply_ci;
 	u32 num_admin_replies = 0;
 	u64 reply_dma = 0;
+	u16 threshold_comps = 0;
 	struct mpi3_default_reply_descriptor *reply_desc;
 
 	if (!atomic_add_unless(&mrioc->admin_reply_q_in_use, 1, 1))
@@ -466,6 +467,7 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_admin_replies++;
+		threshold_comps++;
 		if (++admin_reply_ci == mrioc->num_admin_replies) {
 			admin_reply_ci = 0;
 			exp_phase ^= 1;
@@ -476,6 +478,11 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 		if ((le16_to_cpu(reply_desc->reply_flags) &
 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
 			break;
+		if (threshold_comps == MPI3MR_THRESHOLD_REPLY_COUNT) {
+			writel(admin_reply_ci,
+			    &mrioc->sysif_regs->admin_reply_queue_ci);
+			threshold_comps = 0;
+		}
 	} while (1);
 
 	writel(admin_reply_ci, &mrioc->sysif_regs->admin_reply_queue_ci);
@@ -529,7 +536,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	u32 num_op_reply = 0;
 	u64 reply_dma = 0;
 	struct mpi3_default_reply_descriptor *reply_desc;
-	u16 req_q_idx = 0, reply_qidx;
+	u16 req_q_idx = 0, reply_qidx, threshold_comps = 0;
 
 	reply_qidx = op_reply_q->qid - 1;
 
@@ -560,6 +567,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_op_reply++;
+		threshold_comps++;
 
 		if (++reply_ci == op_reply_q->num_replies) {
 			reply_ci = 0;
@@ -581,13 +589,19 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 			break;
 		}
 #endif
+		if (threshold_comps == MPI3MR_THRESHOLD_REPLY_COUNT) {
+			writel(reply_ci,
+			    &mrioc->sysif_regs->oper_queue_indexes[reply_qidx].consumer_index);
+			atomic_sub(threshold_comps, &op_reply_q->pend_ios);
+			threshold_comps = 0;
+		}
 	} while (1);
 
 	writel(reply_ci,
 	    &mrioc->sysif_regs->oper_queue_indexes[reply_qidx].consumer_index);
 	op_reply_q->ci = reply_ci;
 	op_reply_q->ephase = exp_phase;
-
+	atomic_sub(threshold_comps, &op_reply_q->pend_ios);
 	atomic_dec(&op_reply_q->in_use);
 	return num_op_reply;
 }
-- 
2.31.1

