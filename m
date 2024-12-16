Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38745204F65;
	Mon, 16 Dec 2024 11:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348561; cv=none; b=NG9wTukMZIdSV1gLMfP4HSBgvyerXANGgSgnhhQHx9s7wrErTZzKkw0qX8xFoEHkIqO1aNZHJDDxzbfVwxawUMaN2+iyyO2dSbmtKyX/79bvRRLeWK1pKWAKjBq/ax3Cz1FJJgWiNWSuV6t1cSCfGa68HusGA2moiXl/qC8OmYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348561; c=relaxed/simple;
	bh=3uZW7n2Dks+H/Doo9q/ymOJETj3rjFvKcshiuUcefLM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Xclmz0hhedQj0TSPRXvHSIWJWXGYMmw5UUmjuriEFeNv3BuUGeA4CwD0OrCw6AKsES4uLS0kMrnJVqHgNHz2ZtQ22akGD3Cwkv894XBrUD5P9scZoUoISWOP0ANzU94f9WrvjjvOz2R/LoHO9db6wDF5QWH20aB6/+f5ggcGpY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=JZnvdDvI; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="JZnvdDvI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348553;
	bh=3uZW7n2Dks+H/Doo9q/ymOJETj3rjFvKcshiuUcefLM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JZnvdDvIVLp1ZOxxcHNlXN8wdnL+pIUmr0q7kiYSIb59hF+wPedan38OdkIU3mFxI
	 GCnSq0idhsTC5EYfkYXdnHztJe4bXI9oXfLHux5+MNwo1WYKNujzy1r+0jT6DM7Gyp
	 VQzSYcM/qQ/Z4JjpIikvUVUs9SejC6uHDS2gdaF0=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:18 +0100
Subject: [PATCH 11/11] scsi: qla4xxx: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-11-f0a5e54b3437@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=2063;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=3uZW7n2Dks+H/Doo9q/ymOJETj3rjFvKcshiuUcefLM=;
 b=FudiGZdk+7eiqucd0Mb3IdXBG2lRQt7iNuv+QY5rtiehQ0sCbeMq8dx/vlYt5/Q9/IIhVyJBr
 R65fOzklM+wC2PS3I1zQMq5XL6HeZTFUPE1v5sntq59RyzxSNb7mE4t
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/qla4xxx/ql4_attr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index abfa6ef604800aefef3dbc757d656b7dc20ede8c..e3f85d6ea0db25d5674ca69475af31a4267e2fdb 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -10,7 +10,7 @@
 
 static ssize_t
 qla4_8xxx_sysfs_read_fw_dump(struct file *filep, struct kobject *kobj,
-			     struct bin_attribute *ba, char *buf, loff_t off,
+			     const struct bin_attribute *ba, char *buf, loff_t off,
 			     size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
@@ -28,7 +28,7 @@ qla4_8xxx_sysfs_read_fw_dump(struct file *filep, struct kobject *kobj,
 
 static ssize_t
 qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject *kobj,
-			      struct bin_attribute *ba, char *buf, loff_t off,
+			      const struct bin_attribute *ba, char *buf, loff_t off,
 			      size_t count)
 {
 	struct scsi_qla_host *ha = to_qla_host(dev_to_shost(container_of(kobj,
@@ -104,19 +104,19 @@ qla4_8xxx_sysfs_write_fw_dump(struct file *filep, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_fw_dump_attr = {
+static const struct bin_attribute sysfs_fw_dump_attr = {
 	.attr = {
 		.name = "fw_dump",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 0,
-	.read = qla4_8xxx_sysfs_read_fw_dump,
-	.write = qla4_8xxx_sysfs_write_fw_dump,
+	.read_new = qla4_8xxx_sysfs_read_fw_dump,
+	.write_new = qla4_8xxx_sysfs_write_fw_dump,
 };
 
 static struct sysfs_entry {
 	char *name;
-	struct bin_attribute *attr;
+	const struct bin_attribute *attr;
 } bin_file_entries[] = {
 	{ "fw_dump", &sysfs_fw_dump_attr },
 	{ NULL },

-- 
2.47.1

