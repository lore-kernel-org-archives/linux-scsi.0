Received: from mail-pf1-f226.google.com (mail-pf1-f226.google.com [209.85.210.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F3E494A0F
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787857064; cv=none; b=H/4k5oYxm128NBorrjgFmYq1E9VtwFsbrQqjIPxQYM2biaAGTbBDWL2uwXoVR//oBHP5x7G/mGz+7BqiMcAWO5A/p8wEredSAjDzvlggpaLi+qaF6+hq2wyhjRdK7F3yV4POzw+2Hsw7haStkkStdS9t9lVKLYMekd/IVRSaoeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787857064; c=relaxed/simple;
	bh=bId58P1f3rx83kEyCFQCmbOQueTyIg0Jg1Ag1a5jGfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBS+ruETxdRMGiiBLHRY6vXg/OgnKlsSytkGd7YWlSsqzhkUh/o8ruwFT98vx5Nvn1VjPUhWLEpBZRa/oQvFfLd/P0QJL4TRZTU/U7QzOnXVxPiMYod5NEXrK8ibLw0+OF6lNCEglG0+OxH/OqawJsGDN3mxabL3meEeomrSq/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Q9rrg5rA; arc=none smtp.client-ip=209.85.210.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Q9rrg5rA"
Received: by mail-pf1-f226.google.com with SMTP id d2e1a72fcca58-85237ffb172so17881b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 11:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1787857052; x=1788461852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ex+RB5aItdA3h/bx30wNaWsAq7n74S1CMmypqWLJ+1k=;
        b=Q9rrg5rARoepcGhMNERctdSNthFuFWKbtn0YACk+MDoFqExmU3YFRTvG4ddSXeXGLJ
         ZjOTr7Ezz8nshhwzVsbdrmg3gYansSJK9e/QTsJP2bESpb3QEJz2jtmfpTJjuRSdYNMu
         aaZCMl7Yy+5xfIj+vZI+Q+ta2uBdSzlmlpwwa8izr7BTDocl3P69ejOOb/bEMlKBoAhl
         kdD+4ZbDp3ve0Ph6K/GhwDG/SyTHQV8BU9IM2YaIsO+j4edvVUURTqXDbaHUdBm5eHHb
         oPdddvES6u1xiuAyc+VDqmxWLO0Y0d3vwmTbrqOJQSq4FcKAeKXYfQR3aRWr3NY2/pxG
         PPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787857052; x=1788461852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ex+RB5aItdA3h/bx30wNaWsAq7n74S1CMmypqWLJ+1k=;
        b=IVptVg84yOU0pzhqMMCG38qLkIRRQQmSLQlEqFUHWtGlcVYlbB0u8RAs+zJwLr/IHT
         rRaMJK4wlXKI/QRjK+DmykvvOTLuQLI1mzsl0DsJqJKu/+6da2i3Ek2LVGnT5CYcdv9p
         mdB3O7PSN6YBGyeomFsq7U4yN8mzDCglXZKHqonloUCpuJlIwlf9HkiHsxAU9QFDKRPr
         Ic9kAEJtkiql8LfYDsesnZcp9+f+DacK9wc3+0z/CQCDUTu07sKQO6tPObSoCrI8PSMW
         opDi5ppQA5K4DOWJzFm4MKzZAEfrCrNMn2YwHEsMtezXBhBMtRfVsW/VAXBYBlyTCC91
         xuUw==
X-Forwarded-Encrypted: i=1; AHgh+RpGSyp5jn87D1jnH5hpXG8GmzY7/B8wiOPyr7t3cHwHaMLo+iem8tX/49ZLJ9S3CUSNbUmANBzbGDa7@vger.kernel.org
X-Gm-Message-State: AFuF++mjwsoFdwI11E/3ZomwLClJLHM6y//SqVNN0tTpRPOqIZrAi2+j
	L8my3/YtlukOtGJPCoa5U2mRRH8v3rCuJ9SK6QmD3Er//fVRxD55kqNEOZhPIW7EP4r3XkNJl7E
	caaosKf0qHbPcJGKT9gmlRPeNFAObgyIQnLxytwUrRF2Xf7DRXmrR
X-Gm-Gg: AR+sD119BMvpPtR9eF/cJQ6txAH85yV9qR5nI7+M8lTjGCO7887H5tgSNCl8xlpWaG5
	ILSjmUDSWvOYAbpJ2AOticaTsheLmt8rni7hXUfjQeXW5Vszl+u9SWw7OM1bnZHOOtmns3dk5dK
	D8mNbQcsU6VNBj6zhAA5JFqZr7KPrFtWalkNs05Y0fPhL2dLcjCKLy1Q7cbhbh8xDy+Cdf6byJZ
	wDgKQKhK+4dGEaLttaxEn3R3oh9XSM0ENccZwmQAort5NvLx2fGBI9AN4RT7miWk3811MIPSWvk
	qtwjgmpgmWvQej15JaT9RDl7pgQTiY3BoTV7moz4tobyBXn9noXyux2s2lrIyb98VEILqS77skm
	NKlmVtfpBcTBK5wez5w==
X-Received: by 2002:a05:6a00:4449:b0:851:c2bd:43d1 with SMTP id d2e1a72fcca58-85628a85b9amr829996b3a.1.1787857051450;
        Thu, 27 Aug 2026 11:57:31 -0700 (PDT)
Received: from c7-smtp-2026.dev.purestorage.com ([2620:125:9017:12:36:3:6:0])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8538d0c4935sm2212871b3a.7.2026.08.27.11.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 11:57:31 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.12.104])
	by c7-smtp-2026.dev.purestorage.com (Postfix) with ESMTP id A24254030A;
	Thu, 27 Aug 2026 12:57:30 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 9F60AE404C2; Thu, 27 Aug 2026 12:57:30 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Ming Lei <tom.leiming@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 2/2] nvme/ioctl: call io_uring_cmd_set_res32() in ->end_io()
Date: Thu, 27 Aug 2026 12:57:21 -0600
Message-ID: <20260827185722.3234622-3-csander@purestorage.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827185722.3234622-1-csander@purestorage.com>
References: <20260827185722.3234622-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring_cmd_set_res32() only performs loads and stores to the io_uring
request state, so it's safe to call in interrupt context. Move the call
from the nvme_uring_task_cb() task work to nvme_uring_cmd_end_io(). This
unifies the 2 io_uring_cmd_set_res32() callers and removes the need to
pass result and status through struct nvme_uring_cmd_pdu, saving 16
bytes and a couple memory accesses.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 drivers/nvme/host/ioctl.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 131959c00287..b50bba207818 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -421,12 +421,10 @@ struct nvme_uring_data {
  * Expect build errors if this grows larger than that.
  */
 struct nvme_uring_cmd_pdu {
 	struct request *req;
 	struct bio *bio;
-	u64 result;
-	int status;
 };
 
 static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
 		struct io_uring_cmd *ioucmd)
 {
@@ -438,29 +436,30 @@ static void nvme_uring_task_cb(struct io_tw_req tw_req, io_tw_token_t tw)
 	struct io_uring_cmd *ioucmd = io_uring_cmd_from_tw(tw_req);
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 
 	if (pdu->bio)
 		blk_rq_unmap_user(pdu->bio);
-	io_uring_cmd_set_res32(ioucmd, pdu->status, pdu->result);
 	io_uring_cmd_done(ioucmd, IO_URING_CMD_TASK_WORK_ISSUE_FLAGS);
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 						blk_status_t err,
 						const struct io_comp_batch *iob)
 {
 	struct io_uring_cmd *ioucmd = req->end_io_data;
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
+	u64 result = le64_to_cpu(nvme_req(req)->result.u64);
+	int status;
 
 	if (nvme_req(req)->flags & NVME_REQ_CANCELLED) {
-		pdu->status = -EINTR;
+		status = -EINTR;
 	} else {
-		pdu->status = nvme_req(req)->status;
-		if (!pdu->status)
-			pdu->status = blk_status_to_errno(err);
+		status = nvme_req(req)->status;
+		if (!status)
+			status = blk_status_to_errno(err);
 	}
-	pdu->result = le64_to_cpu(nvme_req(req)->result.u64);
+	io_uring_cmd_set_res32(ioucmd, status, result);
 
 	/*
 	 * For IOPOLL, check if this completion is happening in the context
 	 * of the same io_ring that owns the request (local context). If so,
 	 * we can complete inline without task_work overhead. Otherwise, we
@@ -469,11 +468,10 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	 */
 	if (blk_rq_is_poll(req) && iob &&
 	    iob->poll_ctx == io_uring_cmd_ctx_handle(ioucmd)) {
 		if (pdu->bio)
 			blk_rq_unmap_user(pdu->bio);
-		io_uring_cmd_set_res32(ioucmd, pdu->status, pdu->result);
 		io_uring_cmd_done(ioucmd, 0);
 	} else {
 		io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_cb);
 	}
 	return RQ_END_IO_FREE;
-- 
2.55.0

