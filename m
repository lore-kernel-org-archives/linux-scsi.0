Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2F368D5E
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786142734; cv=none; b=Sgp5UEHJj8AJLvNQCNFqhlCYnM3b0HY/Ybwq4SoBXHdwmPxPmypfjdNCaRyuulQPXQol36OKxfhT6FRAjMItAzn/zBWRsGBviEJG2vCq20XOz38rzcEVqjgy1Ou4mqUJATU1BlbAzWzVuJ7HHqEHGTf5MfT7Qqhrpz1ppVJrHkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786142734; c=relaxed/simple;
	bh=/uOP2fMHHc9SYQi8aoT1/1xMVlEws3YKvN6mr1vdbSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSeH1kcNR6uKE1/lt7DBUzeglZeMXhMeLL2IpZLOyF1ktZWnEbo981eXdrM6nkjlgxMH/BvbaGLxdFCnGt2uatjTEOaO+75CXdoV+IQ7MS4k20dQazYYsZw/2zqQa7dNpSrq3uFxW+FhQuEIJbhnshTHCxbkoDPuRBuuwGUjXb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gIBfN4Bl; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gIBfN4Bl"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hGzkh120Qz1XM6JZ;
	Fri,  7 Aug 2026 22:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786142728; x=1788734729; bh=8bQ78
	nqQ90mJwPgbbj3ug9u570P6AH+Y+2BBDmrDnV4=; b=gIBfN4Blq7Dp58n5cmFCq
	CvV677DYEgnPgYitTn848N+O8a/zw0n6/T6knK+sJ8hM8tMnOV/mpwW/XOaNPQSx
	2Q5WVRnNhf2hGDgBzeSnyqCfuqBqoU7vsUqBuXie/M9bIYZ+uLQHV5sFM2jmL3RG
	yloqv8yQ10NlBGcvCoS8FBdDggdQYs6K4muxlp3XD4cWVHN7hD9x3HcmYDI5mMOx
	Eucibc/AdtrFi+k7u82JekE6btD+UKicDSmmQSavlDYmfKUasyf8OS61MRs1IIoK
	/So4J8qz58BvbM67wEU2LrB8lyq7LpQNSyxwM/8DMU1sVVcwODlhHxIm935+5fIw
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iYVIPPiRuF-w; Fri,  7 Aug 2026 22:45:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzkZ69jmz1XM6JY;
	Fri,  7 Aug 2026 22:45:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 4/6] scsi: core: Add lock context annotations
Date: Fri,  7 Aug 2026 15:44:22 -0700
Message-ID: <ad5ca37acf8c933a12830c0811c293af54c87573.1786142607.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <8fe4526ce272811b28e99048b42358dd8f7c48af.1786142607.git.bvanassche@acm.org>
References: <8fe4526ce272811b28e99048b42358dd8f7c48af.1786142607.git.bvanassche@acm.org>
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
