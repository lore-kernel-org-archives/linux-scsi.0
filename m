Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5468018F2E3;
	Wed, 26 Jun 2024 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719424923; cv=none; b=cdL+IvTdVF48n50AfLPisNg3e/HpE/l6gyg5URpJEWh04z7SwooLMQ6ctyGX519OpRZGM9aUPocrAWJvcbsbbzhbsIWHBALGTXPmLI5v336I/2x0unRBVo4HuXeNCTj+ESCKYkqE9ZjZLdMa3VsJMFAtKfSZ3fygu+P7lk4YPvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719424923; c=relaxed/simple;
	bh=DBAoA6YQndyFztrdyhctAMXii6o3QZHeeA6CbFnpSag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUQ8ZYQVob3F+9s2OKl1R9eiL/ch5kL6/4YvAGZJzVrnYCo5SQTPmtxPM0uG65sxv6IPQY1alGGUKs3Vv5v3jcqAZioKdzJnb1Hxs3poEm1Amaai0kX3dZCtWKzlxlLztLwxrFEM+e3xDQfVeVhmAFgMpMympOq4CUT5dyQ7oUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQgUeZEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQgUeZEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BCCC32782;
	Wed, 26 Jun 2024 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719424923;
	bh=DBAoA6YQndyFztrdyhctAMXii6o3QZHeeA6CbFnpSag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQgUeZEU/icnoqiqHWApJKo1Vos1k+DQZi9uooi6VxwSiDDwtlBGYP4ij5nms6ufY
	 Z6IYfQKMtD2YG+NhsrUPvoXOUW9Vn2N7CIXr8+i+6PltAWby/nbgx/9/mlkr120IRd
	 qjI6nnqkSyKVmFkP6jrGuWB1rWvHIOHWMLDpRgriI/tWi2EJ7lk6PNgl9VgMlNvYw/
	 mTfsQ0epEeIYOOYe23qT2heZ6L9v+PutJt37T5o8/o77RpAdwu4yA3SM5oU3NbZFaX
	 QQ1S3/2COidIivc2NTG2iGkK04mOdm/5t1+I6yyBrWtIoFb74YfzOscpU8tIkVLkg4
	 QDAvpwGQ/cD/Q==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH v2 12/13] ata,scsi: Remove useless ata_sas_port_alloc() wrapper
Date: Wed, 26 Jun 2024 20:00:42 +0200
Message-ID: <20240626180031.4050226-27-cassel@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626180031.4050226-15-cassel@kernel.org>
References: <20240626180031.4050226-15-cassel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4589; i=cassel@kernel.org; h=from:subject; bh=DBAoA6YQndyFztrdyhctAMXii6o3QZHeeA6CbFnpSag=; b=owGbwMvMwCV2MsVw8cxjvkWMp9WSGNJqwl3mCFr9vVqdsOr1OimnTz944g7kt+b8STy/0szF1 OTbzOd/OkpZGMS4GGTFFFl8f7jsL+52n3Jc8Y4NzBxWJpAhDFycAjCR1QaMDEf+zwzW9P9lE2a5 9evrj29KMz9lvWfTmBX3aanRLiHxXamMDO/NGju/u88rCL12f9a2m1+qLL++eb6pv75jqnfE2uy I/TwA
X-Developer-Key: i=cassel@kernel.org; a=openpgp; fpr=5ADE635C0E631CBBD5BE065A352FE6582ED9B5DA
Content-Transfer-Encoding: 8bit

Now when the ap->print_id assignment has moved to ata_port_alloc(),
we can remove the useless ata_sas_port_alloc() wrapper.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/ata/libata-core.c     |  1 +
 drivers/ata/libata-sata.c     | 35 -----------------------------------
 drivers/ata/libata.h          |  1 -
 drivers/scsi/libsas/sas_ata.c | 10 ++++++++--
 include/linux/libata.h        |  3 +--
 5 files changed, 10 insertions(+), 40 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 846ab99e0cd3..11ecfdea5959 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5492,6 +5492,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	return ap;
 }
+EXPORT_SYMBOL_GPL(ata_port_alloc);
 
 void ata_port_free(struct ata_port *ap)
 {
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index b602247604dc..48660d445602 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -1204,41 +1204,6 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 }
 EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
 
-/**
- *	ata_sas_port_alloc - Allocate port for a SAS attached SATA device
- *	@host: ATA host container for all SAS ports
- *	@port_info: Information from low-level host driver
- *	@shost: SCSI host that the scsi device is attached to
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- *	RETURNS:
- *	ata_port pointer on success / NULL on failure.
- */
-
-struct ata_port *ata_sas_port_alloc(struct ata_host *host,
-				    struct ata_port_info *port_info,
-				    struct Scsi_Host *shost)
-{
-	struct ata_port *ap;
-
-	ap = ata_port_alloc(host);
-	if (!ap)
-		return NULL;
-
-	ap->port_no = 0;
-	ap->pio_mask = port_info->pio_mask;
-	ap->mwdma_mask = port_info->mwdma_mask;
-	ap->udma_mask = port_info->udma_mask;
-	ap->flags |= port_info->flags;
-	ap->ops = port_info->port_ops;
-	ap->cbl = ATA_CBL_SATA;
-
-	return ap;
-}
-EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
-
 /**
  *	ata_sas_device_configure - Default device_configure routine for libata
  *				   devices
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 38ce13b55474..e930ac948eac 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -82,7 +82,6 @@ extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);
 extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
-extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern const char *sata_spd_string(unsigned int spd);
 extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 				      u8 page, void *buf, unsigned int sectors);
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index e8987dce585f..eecdd1525a18 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -597,13 +597,19 @@ int sas_ata_init(struct domain_device *found_dev)
 
 	ata_host_init(ata_host, ha->dev, &sas_sata_ops);
 
-	ap = ata_sas_port_alloc(ata_host, &sata_port_info, shost);
+	ap = ata_port_alloc(ata_host);
 	if (!ap) {
-		pr_err("ata_sas_port_alloc failed.\n");
+		pr_err("ata_port_alloc failed.\n");
 		rc = -ENODEV;
 		goto free_host;
 	}
 
+	ap->port_no = 0;
+	ap->pio_mask = sata_port_info.pio_mask;
+	ap->mwdma_mask = sata_port_info.mwdma_mask;
+	ap->udma_mask = sata_port_info.udma_mask;
+	ap->flags |= sata_port_info.flags;
+	ap->ops = sata_port_info.port_ops;
 	ap->private_data = found_dev;
 	ap->cbl = ATA_CBL_SATA;
 	ap->scsi_host = shost;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 84a7bfbac9fa..17394098bee9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1244,9 +1244,8 @@ extern int sata_link_debounce(struct ata_link *link,
 extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
 			     bool spm_wakeup);
 extern int ata_slave_link_init(struct ata_port *ap);
-extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
-					   struct ata_port_info *, struct Scsi_Host *);
 extern void ata_port_probe(struct ata_port *ap);
+extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern void ata_port_free(struct ata_port *ap);
 extern int ata_tport_add(struct device *parent, struct ata_port *ap);
 extern void ata_tport_delete(struct ata_port *ap);
-- 
2.45.2

