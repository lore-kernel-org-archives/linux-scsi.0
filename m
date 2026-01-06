Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6201B237713
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 18:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725831; cv=none; b=ZeGvHiuwhe6ZQMBAnOUFzsUg+3p3VT+vdHAfBAdtV7mSUyln40MQ4u6MMnJ4b2MZJakrUBDBi9VD88a7MIzc8CoHH+iUeZs3so1tpVzeP/dSfb0XlKJoiixiiqClcSqZndr3NZ4FXWhgeSGrE10sJjQZcBZB6nr+2FwpdpGPYxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725831; c=relaxed/simple;
	bh=iPKU0SHlCj6fXg7MFISWJUxTAVXSYA1H5ay7IpKSX9E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TcuTgmMhHsA5C2c0C/iMc/GHwOWM0j5VXMYRimKLlDJDX0u4Dlom2QkFAZx3IX6Rz7vrc5+yUeDWXAqnAl840PbPx5YBuL3z2YvRllphGGiqZsdCF65BHilnQA/DUpmLDBn0+HBAmUx8fJ5D936841mUf/z5NY63RKy2z4JzEo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u9lF8e7p; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u9lF8e7p"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dm0lS51gfz1XNnxZ;
	Tue,  6 Jan 2026 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1767725826; x=1770317827; bh=U28yaJ3T//qo98wwQLBcOv5gROZRNzTB8/B
	ydiUHHRk=; b=u9lF8e7pJlWsesflOC/wh0iJ6yP4UXbGxGVPTtPY6OxYnUvFUxh
	rRXA3r5JQcWRO84QYJkN8o78tVmtNipe+5mBOmRBbwORNZljqGpL0cz8HL3m9Qkt
	Voz3Psae/qWhL9ckDzvUkqkZ5bukvdbJSiX8UbotNeTYBhjAhTimjlTEuUAp60+w
	6JX3QOwynz4vHHFrAKe8Sj2BAN8qjBGDn5c5PP0CT5ulqIsYOQwnNQOV71D5Slr4
	d4soBglYIWTK1QuNK9jqgPcC6VGrZ+zjBWqXnVWdy1jkGWjNaMqd8qMv8aipdGZI
	xda9K6daO3HpCv+xmGcr8R7/sQqK9s3c3RQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m0hupYS3jCU4; Tue,  6 Jan 2026 18:57:06 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dm0lP1ZWtz1XM6J7;
	Tue,  6 Jan 2026 18:57:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: mpt3sas: Simplify the workqueue allocation code
Date: Tue,  6 Jan 2026 11:56:54 -0700
Message-ID: <20260106185655.2526800-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let alloc_ordered_workqueue() format the workqueue name instead of
calling scnprintf() explicitly. Compile-tested only.

Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 +----
 drivers/scsi/mpt3sas/mpt3sas_base.h | 6 ++----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index e4e22cb0e277..2f2183f405c9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -843,11 +843,8 @@ mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *=
ioc)
 	/* initialize fault polling */
=20
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, _base_fault_reset_work);
-	scnprintf(ioc->fault_reset_work_q_name,
-	    sizeof(ioc->fault_reset_work_q_name), "poll_%s%d_status",
-	    ioc->driver_name, ioc->id);
 	ioc->fault_reset_work_q =3D alloc_ordered_workqueue(
-		"%s", WQ_MEM_RECLAIM, ioc->fault_reset_work_q_name);
+		"poll_%s%d_status", WQ_MEM_RECLAIM, ioc->driver_name, ioc->id);
 	if (!ioc->fault_reset_work_q) {
 		ioc_err(ioc, "%s: failed (line=3D%d)\n", __func__, __LINE__);
 		return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/m=
pt3sas_base.h
index de37fa5ac073..d4597d058705 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1163,9 +1163,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct M=
PT3SAS_ADAPTER *ioc);
  * @mask_interrupts: ignore interrupt
  * @pci_access_mutex: Mutex to synchronize ioctl, sysfs show path and
  *			pci resource handling
- * @fault_reset_work_q_name: fw fault work queue
- * @fault_reset_work_q: ""
- * @fault_reset_work: ""
+ * @fault_reset_work_q: fw fault workqueue
+ * @fault_reset_work: fw fault work
  * @firmware_event_thread: fw event work queue
  * @fw_event_lock:
  * @fw_event_list: list of fw events
@@ -1349,7 +1348,6 @@ struct MPT3SAS_ADAPTER {
 	u8		mask_interrupts;
=20
 	/* fw fault handler */
-	char		fault_reset_work_q_name[20];
 	struct workqueue_struct *fault_reset_work_q;
 	struct delayed_work fault_reset_work;
=20
