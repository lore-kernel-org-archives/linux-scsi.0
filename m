Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BDD1F8747
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 19:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751053862; cv=none; b=qJdIiX3yxXYevRqw+2kDNVayORPIZNa9PCIjhdWayrxTI6VSBh+LB7DesYNj6nHav8QKnjjSRGcNvToD2LwLfFMDrI9VQ0j/mhGzeyb75GaEyNcXQaGqLFC7DBJyJPXqWL9XcQUa8dQKII05t8+1NlX4Nab8UGt0Jvrx/S+i7LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751053862; c=relaxed/simple;
	bh=oiMTHog+F+uKeDeh51k1LJ/7nnVyG0WgFibrhOLthzw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VGyPDIortspi/T8kVFsIq+i45fz3RiTYZDpD80CrBPKfn606TjwDJmCxVO51qvZTf9BJax5D0RWFfs6a7db5vLZ4V1H7U8yFWVXxuRlGtlYJG4lBazZtgon3Nl6/llKyVhSFoxlP5CWK04klzggdk3+YVk83MEB1ED61eK6dheY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BvKjuv5e; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BvKjuv5e"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-747e41d5469so462223b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 12:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1751053860; x=1751658660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APgr3LNBVWwNPVuC7C3rvR7APHRHSRBdXswhxSMJ494=;
        b=BvKjuv5ePdlawsjD8BzxcMnit39rWUYUMDpbjYNQ5v1fkvxP622XUtIRsTL+eCbWR/
         3exzbIuC2f8aeovJ27IbdxbrUnRCbkoIBh4W7CfJOevSXZhfrdYvnErcHuGmGiQEUK4J
         DSi1xuyycKBfM5J97e15hRJ0wviEZrQbct12g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751053860; x=1751658660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=APgr3LNBVWwNPVuC7C3rvR7APHRHSRBdXswhxSMJ494=;
        b=fapgk/zWLKvDocwi/sdfLY+S458J1BOoSx6PN6ar0ij+yu5UzzzZW+YMNhSUul5SK4
         o41i6p0Qa/R6qjGdub3i0QAK5s1Mn3Za2KDmxh7weEnBNGxEtK87E7D1oWb+wOYMmU7y
         X5tp6T3BZzVXMS7kUQla+tI8v5qQdljodb1KRbrgunSAfTu6Ae+VrcqggJyplqU+nQ2b
         cC5ZNQCC4Ah0XMoRAC1QBIaY7D8uJZCEVXrzgwTqDV9vj2KK5vFUOPHzchYeM1RY1oQm
         rnPqZ49+fYYr/Et1zJt8FgwTWhf/o5A+aamT3n7v0lwAVoR4MRSoOk/jacJo5LwAYiqY
         Kzmg==
X-Gm-Message-State: AOJu0Yygi73R9d0W7pFUusz3cvluk3R8/Jo/oFEHzt2KZrQpKDpNlqrL
	uIrcEMyrBhV9+Kx7zyMDJJR1FlNAWNu4jNYryUy58KFnXBtLyOpiSICo5dCJoxyZtm6IdEWFD9D
	qGgapyREZiERgSkEIaFQvThCPUitTzeP8Obt79sIhhhQFUsGSpF7og82iIurCYEU53oUbqkJmf8
	Y9d6sRhTx8hwWAcPnYiRv4IDVzPclqXGD2rUuWyGRXdXwhc5q1Lg==
X-Gm-Gg: ASbGncsG2VK5WPSn7mFfoGkVkelrrCjCUKeMStxSKeOLWlNDQyQjhzTSNAjIsff9z9y
	d+9VFL1JWcsTOWV88P7cJp1WqxSNOp8is6o/wq8cZIzrV8y1J+YLWz7OthOx5LQChPbL/KD6G+K
	yBjqMq4JuRaK7qOmI2G1xqu6SaMrshg+3N13YlvnjHit+O7PC7L2BJ+oKwFJq8gXaJWLFSQ8Pwz
	A+Ado77EwbEz//tHH6l4Q2G+mDMaQQKi2JimqD+VVC2iiEOKyKIv/WDyRE1eCNZMGTaYkwZ/7Ib
	rpUvI0SOnbpYFtt4hjcrPzjXJaplhbFkLQxI5WNSxHTz3CmOPudYzTWioGe7qGDYQiEfXv4988P
	PX6WgOv97/mZxfW0Kl8QuEt4kuSTF7wY=
X-Google-Smtp-Source: AGHT+IG6YnkWKwXhqtxK3gha9FYeKMi9bmuYoN+JoFm0KgWQO9WyuAZ491zOD5U9GEUiNWYqIRHnvA==
X-Received: by 2002:a17:902:db10:b0:235:1706:1fe7 with SMTP id d9443c01a7336-23ac3bffb5fmr67376525ad.4.1751053859637;
        Fri, 27 Jun 2025 12:50:59 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb2f247csm23485175ad.79.2025.06.27.12.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 12:50:59 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	stable@vger.kernel.org
Subject: [PATCH v1 3/4] mpi3mr: Serialize admin queue BAR writes on 32-bit systems
Date: Sat, 28 Jun 2025 01:15:38 +0530
Message-Id: <20250627194539.48851-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
References: <20250627194539.48851-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 32-bit systems, 64-bit BAR writes to admin queue registers are
performed as two 32-bit writes. Without locking, this can cause
partial writes when accessed concurrently.

Updated per-queue spinlocks is used to serialize these writes and prevent
race conditions.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Cc: stable@vger.kernel.org
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  4 ++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 15 +++++++++++----
 drivers/scsi/mpi3mr/mpi3mr_os.c |  2 ++
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index bf272dd69d23..f2201108ea91 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1137,6 +1137,8 @@ struct scmd_priv {
  * @logdata_buf: Circular buffer to store log data entries
  * @logdata_buf_idx: Index of entry in buffer to store
  * @logdata_entry_sz: log data entry size
+ * @adm_req_q_bar_writeq_lock: Admin request queue lock
+ * @adm_reply_q_bar_writeq_lock: Admin reply queue lock
  * @pend_large_data_sz: Counter to track pending large data
  * @io_throttle_data_length: I/O size to track in 512b blocks
  * @io_throttle_high: I/O size to start throttle in 512b blocks
@@ -1339,6 +1341,8 @@ struct mpi3mr_ioc {
 	u8 *logdata_buf;
 	u16 logdata_buf_idx;
 	u16 logdata_entry_sz;
+	spinlock_t adm_req_q_bar_writeq_lock;
+	spinlock_t adm_reply_q_bar_writeq_lock;
 
 	atomic_t pend_large_data_sz;
 	u32 io_throttle_data_length;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8976582946a2..0152d31d430a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -23,17 +23,22 @@ module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
 
 #if defined(writeq) && defined(CONFIG_64BIT)
-static inline void mpi3mr_writeq(__u64 b, void __iomem *addr)
+static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
+	spinlock_t *write_queue_lock)
 {
 	writeq(b, addr);
 }
 #else
-static inline void mpi3mr_writeq(__u64 b, void __iomem *addr)
+static inline void mpi3mr_writeq(__u64 b, void __iomem *addr,
+	spinlock_t *write_queue_lock)
 {
 	__u64 data_out = b;
+	unsigned long flags;
 
+	spin_lock_irqsave(write_queue_lock, flags);
 	writel((u32)(data_out), addr);
 	writel((u32)(data_out >> 32), (addr + 4));
+	spin_unlock_irqrestore(write_queue_lock, flags);
 }
 #endif
 
@@ -2954,9 +2959,11 @@ static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc)
 	    (mrioc->num_admin_req);
 	writel(num_admin_entries, &mrioc->sysif_regs->admin_queue_num_entries);
 	mpi3mr_writeq(mrioc->admin_req_dma,
-	    &mrioc->sysif_regs->admin_request_queue_address);
+		&mrioc->sysif_regs->admin_request_queue_address,
+		&mrioc->adm_req_q_bar_writeq_lock);
 	mpi3mr_writeq(mrioc->admin_reply_dma,
-	    &mrioc->sysif_regs->admin_reply_queue_address);
+		&mrioc->sysif_regs->admin_reply_queue_address,
+		&mrioc->adm_reply_q_bar_writeq_lock);
 	writel(mrioc->admin_req_pi, &mrioc->sysif_regs->admin_request_queue_pi);
 	writel(mrioc->admin_reply_ci, &mrioc->sysif_regs->admin_reply_queue_ci);
 	return retval;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index ce444efd859e..0d1c9bbb13b5 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5365,6 +5365,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&mrioc->tgtdev_lock);
 	spin_lock_init(&mrioc->watchdog_lock);
 	spin_lock_init(&mrioc->chain_buf_lock);
+	spin_lock_init(&mrioc->adm_req_q_bar_writeq_lock);
+	spin_lock_init(&mrioc->adm_reply_q_bar_writeq_lock);
 	spin_lock_init(&mrioc->sas_node_lock);
 	spin_lock_init(&mrioc->trigger_lock);
 
-- 
2.31.1

