Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738511917D6
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 20:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036745; cv=none; b=RTFgkzOMfo/ogGKIx3ScsgmRpuqxTxGctvOosgnGiroDfE8Kk4V23mJoRWgcZK5z6sQa3Bbwqv/eawxrWlJXJLdP+/kHVKQEg1lOeYJUvoSIIqrH1ZMeNu1flaoLTDnvZu5h+BxlyQjGej3sEd+CiRCCfukRPELRxgFdzNJI5Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036745; c=relaxed/simple;
	bh=rbW1MWjtSR5nGGTwTbZhYFX/todq16UnxeMXHgwMn7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKA9RM6nVQK/ktXg/1v69JrFrbHMSzjin0yawTlIUacrxOS2zkLQ+buVgayKcpCqjSBv/rhAgx/jFeXn3lJFboD5SaHv7JjMwtEqiNMhkcfISSkIwgqSxY5Mc+KeEOY0K5BPhIe7GeFKxzBs58OGCMUb+UTXngBcalEbOarFR9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=d4Jtg193; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="d4Jtg193"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6EG/TMrAs+0NuIAxtUlxCtd0MXNMBUvcVZY0rG9bFgw=; b=d4Jtg193SrHVZ1Sm5kL/tZTmdP
	o4nh/8qPwBP+K01OtQiSWQFSlKGlk8xxRQYmZ57OWnoq8WzQq48wIqXvaDAh1Ke6Xv65qBz/EStxk
	9I1Zw958Bay9A3QLrlQoeTZFL6Oc4B2DiVYySA5fw3hS9rMpn7J39MNZA4csePsP1WN3ZqTiVX53+
	vaeCkXw32DQXiuZ4e3bJlSo9kjy+RVg3/k8WKNJevKgAIBJP7ULuUnloSa3z0Bv+utasCVbd1Ry/j
	ic0jwhamlkrDdudnFniOGcVPgskYn6CsR0mftUgPZCtFMsSUbKxorKhc2Ntzmfwj46oxVo3BN07eZ
	t+HNKDvQ==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLqAY-00000001rO5-0CJr;
	Thu, 12 Dec 2024 20:52:22 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/5] scsi: scsi_lib: add kernel-doc for exported functions
Date: Thu, 12 Dec 2024 12:52:15 -0800
Message-ID: <20241212205217.597844-4-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212205217.597844-1-rdunlap@infradead.org>
References: <20241212205217.597844-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add kernel-doc for scsi_failures_reset_retries() and
scsi_alloc_request() since these are exported.
This allows them to be part of the SCSI driver-api docbook.

Fix kernel-doc comments for scsi_vpd_tpg_id() [add kernel-doc for
one parameter and fix a typo].

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/scsi_lib.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- linux-next-20241212.orig/drivers/scsi/scsi_lib.c
+++ linux-next-20241212/drivers/scsi/scsi_lib.c
@@ -184,6 +184,10 @@ void scsi_queue_insert(struct scsi_cmnd
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+/**
+ * scsi_failures_reset_retries - reset all failures to zero
+ * @failures: &struct scsi_failures with specific failure modes set
+ */
 void scsi_failures_reset_retries(struct scsi_failures *failures)
 {
 	struct scsi_failure *failure;
@@ -1214,6 +1218,15 @@ static void scsi_initialize_rq(struct re
 	cmd->retries = 0;
 }
 
+/**
+ * scsi_alloc_request - allocate a block request and partially
+ *                      initialize its &scsi_cmnd
+ * @q: the device's request queue
+ * @opf: the request operation code
+ * @flags: block layer allocation flags
+ *
+ * Return: &struct request pointer on success or %NULL on failure
+ */
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
 				   blk_mq_req_flags_t flags)
 {
@@ -3365,14 +3378,16 @@ int scsi_vpd_lun_id(struct scsi_device *
 }
 EXPORT_SYMBOL(scsi_vpd_lun_id);
 
-/*
+/**
  * scsi_vpd_tpg_id - return a target port group identifier
  * @sdev: SCSI device
+ * @rel_id: pointer to return relative target port in if not %NULL
  *
  * Returns the Target Port Group identifier from the information
- * froom VPD page 0x83 of the device.
+ * from VPD page 0x83 of the device.
+ * Optionally sets @rel_id to the relative target port on success.
  *
- * Returns the identifier or error on failure.
+ * Return: the identifier or error on failure.
  */
 int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 {
