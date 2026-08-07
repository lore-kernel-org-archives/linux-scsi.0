Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A4B3C73D9
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786143045; cv=none; b=TzMlbOyDjkuHLCf0Dy2KqNv7uCZ34QhbKsYHvv9IlBEF7newZttGRnKYoIOMkOT3MD+B+UXAI/q52cZUmACP7y93g3wn/e5SxZOHj2gnd313gJvP/vie01fNoOVDTSwIh6f+GUJzpzt9ZNzwpyvfB12ICXy+JlwpsGkjX0p2gQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786143045; c=relaxed/simple;
	bh=/uOP2fMHHc9SYQi8aoT1/1xMVlEws3YKvN6mr1vdbSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQMttxcwAdRu20uAEubZTzKmHCKxuniO2ly2QuvbXcWN/vb+H4kLGQv7zDWDLUcRM/23TYo/i92ouuAsOUVfDmJhTL0LEZxU3cXfjFqX6NuwZJeCYaQB5CkAIBfZn+wBXjBNeIZzwkPOC/lTcNaLHAXlte7jXGHjPqT788Fzuvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eArHoqcS; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eArHoqcS"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGzrg3NQjzlfvq8;
	Fri,  7 Aug 2026 22:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786143039; x=1788735040; bh=8bQ78
	nqQ90mJwPgbbj3ug9u570P6AH+Y+2BBDmrDnV4=; b=eArHoqcScgWkyFvZ4hNRl
	FkCTakLi+fGGdr2fFjRyV2uiAddKVbdDru+9SXLmMSXTnUH1gWjl1QISB1T+8Zrc
	FygW0uX4UO/BSi9h4WEE/MdaONMtEx/iZ1vzeR0q5J7o9WNqj7Xh4nrLzHiwLyjx
	MYsqkXVINFsF5INLwbab14RTqFTKUqSPcASf9vCyTsvpO2Ni5ekP3wg0iMR1cSJB
	i4GfdBJubSKn87AO1icTIu31IjydCrAvkHkAXVu/meV2/pWHx2Df5x0PfbwqQnM4
	J29RbdmEdfVCDpV2SaFf/QtrkNnF4lnMqhRt6fH+5yno6m+IBGPfpNKZJfljm+OX
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xliabmCzNajN; Fri,  7 Aug 2026 22:50:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzrT2rKmzlfvq0;
	Fri,  7 Aug 2026 22:50:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v7 4/6] scsi: core: Add lock context annotations
Date: Fri,  7 Aug 2026 15:49:49 -0700
Message-ID: <ad5ca37acf8c933a12830c0811c293af54c87573.1786142946.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <cover.1786142946.git.bvanassche@acm.org>
References: <cover.1786142946.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document which functions expect that shost->scan_mutex is held.

Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d7e0e9393194..3b82e80e807a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1195,6 +1195,7 @@ static int scsi_probe_and_add_lun(struct Scsi_Host =
*shost,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
 				  void *hostdata)
+	__must_hold(&shost->scan_mutex)
 {
 	struct scsi_device *sdev;
 	unsigned char *result;
@@ -1352,6 +1353,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
 				     struct scsi_target *starget,
 				     blist_flags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	uint max_dev_lun;
 	u64 sparse_lun, lun;
@@ -1444,6 +1446,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
 static int scsi_report_lun_scan(struct Scsi_Host *shost,
 			struct scsi_target *starget, blist_flags_t bflags,
 			enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
@@ -1769,6 +1772,7 @@ EXPORT_SYMBOL(scsi_rescan_device);
 static void __scsi_scan_target(struct Scsi_Host *shost, struct device *p=
arent,
 			       unsigned int channel, unsigned int id, u64 lun,
 			       enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	blist_flags_t bflags =3D 0;
 	int res;
@@ -1866,6 +1870,7 @@ EXPORT_SYMBOL(scsi_scan_target);
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int chan=
nel,
 			      unsigned int id, u64 lun,
 			      enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	uint order_id;
=20
