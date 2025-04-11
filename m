Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F55920B806
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 11:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744370361; cv=none; b=Gb9/0MQleGnmQ0ev/ExrHzkMLGy/SnPmJzafoB50/CaBsO6gi6fLo5Sg8AfOxxiLNtBItL9hzqawaiXTHL6MeZc+QnLcv7vxCvjxfYW/vuJm8dIN00rxVhZnQ21OkOuiXHWKthoJFpOtPMPXWsb2Pbk8XvszH05AdtqkYUT3G9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744370361; c=relaxed/simple;
	bh=0Li/qqcuMF5C+sKteXxSetwme8NCv2hfNLGDfl1J4Ps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E8/a7w7ZJq8qsc60yGLqFK02sdC/EdUpPvile/TSNeR9CMw3sY1nlOqLxKhxW0Al3rkwISF99QyQHaSkXNFvENI6DemkmLRylmK/POJhDOniNq+K+emGnuOXyi6hjKEiI5fEFgbtntXYOqsCc5fLPTZUlC+cuRcydWMJ7Otv9Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=iItvVO66; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iItvVO66"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-72d3b48d2ffso1876586b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 04:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1744370357; x=1744975157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/m/3d3TtE5r56N988VKyJ5gOZ77ZQPrrPQjrW9ZMYPo=;
        b=iItvVO66uqzMhK+/Qp4Ni8+tuqzhsxLXnB41nqDGLGTD+CxfuxO3MKF3Zz6sU5NWVV
         X4sdf3a4YamsKPirNR8O6juV20SFz/9TdFpjizZcY+K1LNiXPK/AfxeHTKqXmh2xFlBW
         zfqNOeN9EYCuPicHoOqqZvTKW33zmEjEAvZ0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744370357; x=1744975157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/m/3d3TtE5r56N988VKyJ5gOZ77ZQPrrPQjrW9ZMYPo=;
        b=bQxUeSnMe8nEff3N9rBDOT720LGmtnMRjPmwKO3rV0vKYDhRwFWsI+yM1IDiuiVYvJ
         YP0OuDdsnRVFlDTC7u6KSU4PXiRCxuzJElOcv5sAsu2mVp5xnS9yHOddUqmaeZWmKX+N
         fIC/IlVlOzlHLto6xlNn1elSz+Il0ndBFTk/yC+n+5YojKgvphs2PcdCGPMGSaq6A70U
         bY64LSRymQdGjP65Vbch55G14lX/sChEiJyX5PgW3E7kKY8GEvAJf3DB/gECE10h5hJ4
         GG4mzMXtuAVnP3cYp7RdwzSF7MW3V3Zs7dUeoRFyLPqgjiw06ssfwYJigGqbKXr0hTmP
         gEQQ==
X-Gm-Message-State: AOJu0YxM4hzKHYDpqzq+femLLM5b2VF21b6CQ2d8HCzfick1tZtmUJDe
	oavNKV+EdjZ0B9s7IhQihIvAK/iok4Y897BC4ejDM22GjxGtV63YW9IsiWFbg6s19bbB57WOVii
	Fk44yx2xk7XXo4gnQNknQq0NgWxbRAQlDx6jc68dpKZKbRRBj4atTyzlxW9gBExNqmwpR7ZnT07
	5rNtNwI5dEmMcoSwBLgYxI31o8o8L1zbWK/1dltTKlF2VjJw==
X-Gm-Gg: ASbGncuB22oJYgd3y6d2FtBlTIlzp5tjZYobjugo3dAjCS22Jo2RRfLw3HMBIXvu0Nx
	5GwFudv/4nMt0x2CT+dFWln5pYORPF9LODQWAN5AZ4y6AO4FpcXzJ/FtRDThHC+0jNOSWC/vjxS
	lZsAj7do40pokdnCiq3i6uap30Z4xDWfKcXn8hbTreA5/XrnPTDHMnPRFKYboTg7XldprlPAOwr
	MwFBq2MfQkFpALblWc5tRltVKr8L3FpFvTL8QmLP2Rq95E0jxiAhW8GOkOcqB/XoWam+DHIsa/3
	w5bJiI19YeAnWw4BDx9u1zjWCs5j/8YtpYP3tIzbNRq1Jl/ceUPqb2y6oFOEUf2i4+8WMIv3WrU
	VD09Ejpyj
X-Google-Smtp-Source: AGHT+IHdB7cuaz+h6Nd3nw3MX6wsA00yUMF4he1ZUzS+zxMceGqPQacHi3ZzkELiHzuL2/A+pkFjzQ==
X-Received: by 2002:a05:6a00:a91:b0:736:62a8:e52d with SMTP id d2e1a72fcca58-73bd11fe733mr3546676b3a.12.1744370357057;
        Fri, 11 Apr 2025 04:19:17 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd21c65c9sm1266920b3a.61.2025.04.11.04.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Apr 2025 04:19:16 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	tadamsjr@google.com,
	vishakhavc@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	stable@vger.kernel.org
Subject: [PATCH v1 1/2] Regression fix: Fix pending IOs counter per reply queue
Date: Fri, 11 Apr 2025 16:44:18 +0530
Message-Id: <20250411111419.135485-2-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250411111419.135485-1-ranjan.kumar@broadcom.com>
References: <20250411111419.135485-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 199510e33dea ("scsi: mpi3mr: Update consumer index of
reply queues after every 100 replies") introduced a regression
with Per reply queue pending IOs counter was wrongly decremented
leading to counter getting negative.

Fixed the issue by dropping the extra atomic decrement for
pending IOs counter.

Fixes: 199510e33dea ("scsi: mpi3mr: Update consumer index of reply queues after every 100 replies")
Cc: stable@vger.kernel.org
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 3fcb1ad3b070..d6e402aacb2a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -565,7 +565,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));
 		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
 		    reply_qidx);
-		atomic_dec(&op_reply_q->pend_ios);
+
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_op_reply++;
-- 
2.31.1

