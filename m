Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDE7204F78;
	Mon, 16 Dec 2024 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348562; cv=none; b=r6iJd/SrF5a/wbzLoN9/BU0lKnl7d38n7zsQUWUn9PtftHnXIx9sfoYipQw7NNEYxIUlYlEYWnJaDyJ76D0q1HRj6wfL6LA8bzNCoElZyJ99gyGzr5tfRFsxJsnlLZGTdjv3D1S7vYfA5xgI3wSsfkk+pHjlLnsB3uOaJn+bE2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348562; c=relaxed/simple;
	bh=TnuBvtbm/eKcN8yGKFA+/hPyKlT4aEyQjANk9DeyXiI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DH0P6sECcGk/JHNob3ETnw3UFNRh09I0CVlDcwBKQIYnjjylSuw9WPcP/j6oWW1XyZSJ8pZ+C/exDJk3+1qQHOs613O7Qt4ex1ZyGW8gr4L0cfRnJAA2qrmbsTgxWt18oybhwrIQ80QH70Gpv9jWwJW/IcOHICyEL6npwlsRHgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=A1FxjZYR; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="A1FxjZYR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348553;
	bh=TnuBvtbm/eKcN8yGKFA+/hPyKlT4aEyQjANk9DeyXiI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=A1FxjZYRPPJQX0xbzKEXvO1Q9aAIWd0ldmiTpipg/B45okU5dWp/imiObvOguW73E
	 7QCyrC4X6ldX7RnzZxlphHwAJAd9i5FiTbQCkzIQLz/fg3n6BljzV47kOSkuVmSji+
	 8I85ovRjBYMgJPYP5Hh+kkF5H2aLupGkGSvqBHpE=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:17 +0100
Subject: [PATCH 10/11] scsi: qla2xxx: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-10-f0a5e54b3437@weissschuh.net>
References: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
In-Reply-To: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Adam Radford <aradford@gmail.com>, 
 Bradley Grove <linuxdrivers@attotech.com>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, Brian King <brking@us.ibm.com>, 
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
 Manish Rangankar <mrangankar@marvell.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=9804;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=TnuBvtbm/eKcN8yGKFA+/hPyKlT4aEyQjANk9DeyXiI=;
 b=hMP1olY6EzhDv4p3LOXBwNL02D9JjGyYAaTYTMdtgmGsKSZbwRDLoJlLp8E+KZMqxkaOwp8pV
 sFlVux4YBYGClYqis4bxn540b7WW9JUJueJYIG3tACx4vyI0MUTLc4u
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/qla2xxx/qla_attr.c | 80 ++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e6ece30c43486ce8f268e369f317e850994ed008..dcb0c2af1fa7cf9b63a5613c01b792143142a412 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -17,7 +17,7 @@ static int qla24xx_vport_disable(struct fc_vport *, bool);
 
 static ssize_t
 qla2x00_sysfs_read_fw_dump(struct file *filp, struct kobject *kobj,
-			   struct bin_attribute *bin_attr,
+			   const struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -58,7 +58,7 @@ qla2x00_sysfs_read_fw_dump(struct file *filp, struct kobject *kobj,
 
 static ssize_t
 qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
-			    struct bin_attribute *bin_attr,
+			    const struct bin_attribute *bin_attr,
 			    char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -168,19 +168,19 @@ qla2x00_sysfs_write_fw_dump(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_fw_dump_attr = {
+static const struct bin_attribute sysfs_fw_dump_attr = {
 	.attr = {
 		.name = "fw_dump",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 0,
-	.read = qla2x00_sysfs_read_fw_dump,
-	.write = qla2x00_sysfs_write_fw_dump,
+	.read_new = qla2x00_sysfs_read_fw_dump,
+	.write_new = qla2x00_sysfs_write_fw_dump,
 };
 
 static ssize_t
 qla2x00_sysfs_read_nvram(struct file *filp, struct kobject *kobj,
-			 struct bin_attribute *bin_attr,
+			 const struct bin_attribute *bin_attr,
 			 char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -220,7 +220,7 @@ qla2x00_sysfs_read_nvram(struct file *filp, struct kobject *kobj,
 
 static ssize_t
 qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
-			  struct bin_attribute *bin_attr,
+			  const struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -282,19 +282,19 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_nvram_attr = {
+static const struct bin_attribute sysfs_nvram_attr = {
 	.attr = {
 		.name = "nvram",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 512,
-	.read = qla2x00_sysfs_read_nvram,
-	.write = qla2x00_sysfs_write_nvram,
+	.read_new = qla2x00_sysfs_read_nvram,
+	.write_new = qla2x00_sysfs_write_nvram,
 };
 
 static ssize_t
 qla2x00_sysfs_read_optrom(struct file *filp, struct kobject *kobj,
-			  struct bin_attribute *bin_attr,
+			  const struct bin_attribute *bin_attr,
 			  char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -318,7 +318,7 @@ qla2x00_sysfs_read_optrom(struct file *filp, struct kobject *kobj,
 
 static ssize_t
 qla2x00_sysfs_write_optrom(struct file *filp, struct kobject *kobj,
-			   struct bin_attribute *bin_attr,
+			   const struct bin_attribute *bin_attr,
 			   char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -344,19 +344,19 @@ qla2x00_sysfs_write_optrom(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_optrom_attr = {
+static const struct bin_attribute sysfs_optrom_attr = {
 	.attr = {
 		.name = "optrom",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 0,
-	.read = qla2x00_sysfs_read_optrom,
-	.write = qla2x00_sysfs_write_optrom,
+	.read_new = qla2x00_sysfs_read_optrom,
+	.write_new = qla2x00_sysfs_write_optrom,
 };
 
 static ssize_t
 qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
+			       const struct bin_attribute *bin_attr,
 			       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -529,18 +529,18 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 	return rval;
 }
 
-static struct bin_attribute sysfs_optrom_ctl_attr = {
+static const struct bin_attribute sysfs_optrom_ctl_attr = {
 	.attr = {
 		.name = "optrom_ctl",
 		.mode = S_IWUSR,
 	},
 	.size = 0,
-	.write = qla2x00_sysfs_write_optrom_ctl,
+	.write_new = qla2x00_sysfs_write_optrom_ctl,
 };
 
 static ssize_t
 qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
-		       struct bin_attribute *bin_attr,
+		       const struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -587,7 +587,7 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobject *kobj,
 
 static ssize_t
 qla2x00_sysfs_write_vpd(struct file *filp, struct kobject *kobj,
-			struct bin_attribute *bin_attr,
+			const struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -642,19 +642,19 @@ qla2x00_sysfs_write_vpd(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_vpd_attr = {
+static const struct bin_attribute sysfs_vpd_attr = {
 	.attr = {
 		.name = "vpd",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 0,
-	.read = qla2x00_sysfs_read_vpd,
-	.write = qla2x00_sysfs_write_vpd,
+	.read_new = qla2x00_sysfs_read_vpd,
+	.write_new = qla2x00_sysfs_write_vpd,
 };
 
 static ssize_t
 qla2x00_sysfs_read_sfp(struct file *filp, struct kobject *kobj,
-		       struct bin_attribute *bin_attr,
+		       const struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -679,18 +679,18 @@ qla2x00_sysfs_read_sfp(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_sfp_attr = {
+static const struct bin_attribute sysfs_sfp_attr = {
 	.attr = {
 		.name = "sfp",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = SFP_DEV_SIZE,
-	.read = qla2x00_sysfs_read_sfp,
+	.read_new = qla2x00_sysfs_read_sfp,
 };
 
 static ssize_t
 qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
-			struct bin_attribute *bin_attr,
+			const struct bin_attribute *bin_attr,
 			char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -823,19 +823,19 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_reset_attr = {
+static const struct bin_attribute sysfs_reset_attr = {
 	.attr = {
 		.name = "reset",
 		.mode = S_IWUSR,
 	},
 	.size = 0,
-	.write = qla2x00_sysfs_write_reset,
+	.write_new = qla2x00_sysfs_write_reset,
 };
 
 static ssize_t
 qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
-			struct bin_attribute *bin_attr,
-			char *buf, loff_t off, size_t count)
+		   const struct bin_attribute *bin_attr,
+		   char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
@@ -866,18 +866,18 @@ qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_issue_logo_attr = {
+static const struct bin_attribute sysfs_issue_logo_attr = {
 	.attr = {
 		.name = "issue_logo",
 		.mode = S_IWUSR,
 	},
 	.size = 0,
-	.write = qla2x00_issue_logo,
+	.write_new = qla2x00_issue_logo,
 };
 
 static ssize_t
 qla2x00_sysfs_read_xgmac_stats(struct file *filp, struct kobject *kobj,
-		       struct bin_attribute *bin_attr,
+		       const struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -929,18 +929,18 @@ qla2x00_sysfs_read_xgmac_stats(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_xgmac_stats_attr = {
+static const struct bin_attribute sysfs_xgmac_stats_attr = {
 	.attr = {
 		.name = "xgmac_stats",
 		.mode = S_IRUSR,
 	},
 	.size = 0,
-	.read = qla2x00_sysfs_read_xgmac_stats,
+	.read_new = qla2x00_sysfs_read_xgmac_stats,
 };
 
 static ssize_t
 qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
-		       struct bin_attribute *bin_attr,
+		       const struct bin_attribute *bin_attr,
 		       char *buf, loff_t off, size_t count)
 {
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
@@ -987,18 +987,18 @@ qla2x00_sysfs_read_dcbx_tlv(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_dcbx_tlv_attr = {
+static const struct bin_attribute sysfs_dcbx_tlv_attr = {
 	.attr = {
 		.name = "dcbx_tlv",
 		.mode = S_IRUSR,
 	},
 	.size = 0,
-	.read = qla2x00_sysfs_read_dcbx_tlv,
+	.read_new = qla2x00_sysfs_read_dcbx_tlv,
 };
 
 static struct sysfs_entry {
 	char *name;
-	struct bin_attribute *attr;
+	const struct bin_attribute *attr;
 	int type;
 } bin_file_entries[] = {
 	{ "fw_dump", &sysfs_fw_dump_attr, },

-- 
2.47.1

