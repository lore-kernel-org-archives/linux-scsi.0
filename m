Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B63338902
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768586899; cv=none; b=O0FFlCR1UMxjKmD22A5l8w6/amN1OUOO83oz18lKanHBdLF/wCo5jfHr7fBPtP268thrwN4xZsscbeUJCEagH8XV8C5nIEf6QVhJPm4B5MmVMx/MIio8SfXxJfAnaSwicfdb///S0rQhonkN2aTKTR06jThCIozaAqHKWcg1ebA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768586899; c=relaxed/simple;
	bh=tSTy87m2ijQckQ5sshwmv6WZoprPtgrY5AqbhiMnlfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkII3fTZEdUDHn+O/ja6AxVFylCYmBzfEpvAMNzeMsPQznDQAzer1HBmhzMhItPZ6vwvH0/QNYSbWFN2FpYDHa0q7T9A0OBse0sSjiVIyP0Ov94GOdSicMAAdfiQnTX5JnbUMlyofRHV0zt+DMaIc+ElRplfU0jEdcdEdaEILHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ENrUXui3; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ENrUXui3"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7BT4y4mzlfftm;
	Fri, 16 Jan 2026 18:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1768586894; x=1771178895; bh=mxLzyMjKEoA5xOgwIRZmw9wXz1E3dRZHSlP
	GnzfebyY=; b=ENrUXui3kAHFtTW3ftV/6W+Xbrwo0jsVP7+IM5FkciVh/aKeE3U
	247/TQbo50COePaQlvoTWDiO9o1SEsahTLkYQ3bhHvVJZJPGmwhEIZ+Ly5NiJTYd
	ot0ypCQhvoqZWMD/A0yesyCx0hA1FZbBHPkGIa+FssMb4WPkGZYO27BHacdq/vFr
	RcEwx2GUvN/JUlDDRaNh84yu4LfPxzOPXyoK4btORtfrruvBIqsMgsWWnxClUYTJ
	bJD9SiiIygLULVyKEJJIXLgeWZ3dMcE7I0SuZCbLtWq7AZL/ins6C+YJAp5TRl7R
	9P7gk3P1KIO9xbjyfYdbOFaP4VSR5GFJrPQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Fxt6MEXkbuSm; Fri, 16 Jan 2026 18:08:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7BM52NtzlfpMC;
	Fri, 16 Jan 2026 18:08:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	vamshi gajjela <vamshigajjela@google.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <quic_cang@quicinc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: core: Use a host-wide tagset in SDB mode
Date: Fri, 16 Jan 2026 10:07:51 -0800
Message-ID: <20260116180800.3085233-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In single-doorbell (SDB) mode there is only a single request queue. Hence=
,
it doesn't matter whether or not the SCSI host tagset is configured as
host-wide. Configure the host tagset as host-wide in SDB mode because
this enables a simplification of the hot path.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 2 --
 drivers/ufs/core/ufshcd-priv.h | 7 +------
 drivers/ufs/core/ufshcd.c      | 1 +
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 64c234096e23..18a95b728633 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -444,7 +444,6 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_config_esi);
=20
 int ufshcd_mcq_init(struct ufs_hba *hba)
 {
-	struct Scsi_Host *host =3D hba->host;
 	struct ufs_hw_queue *hwq;
 	int ret, i;
=20
@@ -478,7 +477,6 @@ int ufshcd_mcq_init(struct ufs_hba *hba)
 		mutex_init(&hwq->sq_mutex);
 	}
=20
-	host->host_tagset =3D 1;
 	return 0;
 }
=20
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 4259f499382f..7d6d19361af9 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -374,12 +374,7 @@ static inline bool ufs_is_valid_unit_desc_lun(struct=
 ufs_dev_info *dev_info, u8
  */
 static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba, u=
32 tag)
 {
-	/*
-	 * Host-wide tags are enabled in MCQ mode only. See also the
-	 * host->host_tagset assignment in ufs-mcq.c.
-	 */
-	struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags ?:
-					   hba->host->tag_set.tags[0];
+	struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags;
 	struct request *rq =3D blk_mq_tag_to_rq(tags, tag);
=20
 	if (WARN_ON_ONCE(!rq))
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 057678f4c50a..889da15a61f0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9320,6 +9320,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.max_segment_size	=3D PRDT_DATA_BYTE_COUNT_MAX,
 	.max_sectors		=3D SZ_1M / SECTOR_SIZE,
 	.max_host_blocked	=3D 1,
+	.host_tagset		=3D true,
 	.track_queue_depth	=3D 1,
 	.skip_settle_delay	=3D 1,
 	.sdev_groups		=3D ufshcd_driver_groups,
