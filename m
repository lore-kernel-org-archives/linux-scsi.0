Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1E4C7C;
	Mon, 16 Dec 2024 11:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348558; cv=none; b=BXrk6iODnZYc6ulWxvMeZ7tw27ooJumoXJ7nXESs5UJvroWO17hS3nRbeuMoNulEfLgCzshe49ex/CvJJK68go3/jobW+aE5b2+Q7LCGsn8rKAkK88j+Rk/QnvhxYAKmmUuDfXC4hiHPKz2IuynqVf/30XXApXgfzKzWdhhaLVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348558; c=relaxed/simple;
	bh=TjVja/zk+UJSLd4Q97XnJXAzbXafaV96VJJ2y2xcgm4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ilZL0IrMyIU1yJ0bUUz7cjDTa000/Ekru/hZV8yaBK2N+YXIscmX/CspApyYOS/GIYZaqIhuIgzMrVWUw2bngGD/CzWWvnaAR48KF3Q8rPigM1OYLEXaZ4FkQ4VbtMCXnMKjO0Slt0QbzXSkU+mpKSxBi7OjlGn3QVXwjFP9qy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=smBWsnEG; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="smBWsnEG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348552;
	bh=TjVja/zk+UJSLd4Q97XnJXAzbXafaV96VJJ2y2xcgm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=smBWsnEGDX0bZ10U/9wLxtIv2PGJ5U4XBMe94YkqdZF6ukWU83aG4wJzucfAP2k8P
	 YBRJMCxE9jiZ/Rrj9akKDg1C4jyus9A4sJaJL8S8em1xWjoKlmkWTA+NOeQ4fli+s+
	 NzNipJv6XG8USBabiBG904lzidmMQVDwCXIO2c/c=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:11 +0100
Subject: [PATCH 04/11] scsi: esas2r: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-4-f0a5e54b3437@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=6468;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=TjVja/zk+UJSLd4Q97XnJXAzbXafaV96VJJ2y2xcgm4=;
 b=cHpzmCZLeQqd1OQ9m+VjdHMlnbORVFZql4Wpf6q2sfJdTUE0nTJzea+z2TUT+o90QQnQ3pVcM
 1Qkron+E+zwDaDCjDL5AgAFL69ATj+ts8h3Zvs/T8Ma3pN/j1evnvnD
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/esas2r/esas2r.h      | 12 ++++++------
 drivers/scsi/esas2r/esas2r_main.c | 32 ++++++++++++++++----------------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 1e2d7c63a8e36a22bed3b365cd2e6eb81a3a4a1d..c48275d53aef3d45c0b8a1c38f5a21020ab33102 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -1411,11 +1411,11 @@ static inline void esas2r_comp_list_drain(struct esas2r_adapter *a,
 }
 
 /* sysfs handlers */
-extern struct bin_attribute bin_attr_fw;
-extern struct bin_attribute bin_attr_fs;
-extern struct bin_attribute bin_attr_vda;
-extern struct bin_attribute bin_attr_hw;
-extern struct bin_attribute bin_attr_live_nvram;
-extern struct bin_attribute bin_attr_default_nvram;
+extern const struct bin_attribute bin_attr_fw;
+extern const struct bin_attribute bin_attr_fs;
+extern const struct bin_attribute bin_attr_vda;
+extern const struct bin_attribute bin_attr_hw;
+extern const struct bin_attribute bin_attr_live_nvram;
+extern const struct bin_attribute bin_attr_default_nvram;
 
 #endif /* ESAS2R_H */
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index f700a16cd88534c1edc9fb0ed8ed8b8d1db4fe51..44871746944ad0c0f30f28975ed40e0fde4e8d03 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -66,7 +66,7 @@ static struct esas2r_adapter *esas2r_adapter_from_kobj(struct kobject *kobj)
 }
 
 static ssize_t read_fw(struct file *file, struct kobject *kobj,
-		       struct bin_attribute *attr,
+		       const struct bin_attribute *attr,
 		       char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -75,7 +75,7 @@ static ssize_t read_fw(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t write_fw(struct file *file, struct kobject *kobj,
-			struct bin_attribute *attr,
+			const struct bin_attribute *attr,
 			char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -84,7 +84,7 @@ static ssize_t write_fw(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t read_fs(struct file *file, struct kobject *kobj,
-		       struct bin_attribute *attr,
+		       const struct bin_attribute *attr,
 		       char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -93,7 +93,7 @@ static ssize_t read_fs(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t write_fs(struct file *file, struct kobject *kobj,
-			struct bin_attribute *attr,
+			const struct bin_attribute *attr,
 			char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -109,7 +109,7 @@ static ssize_t write_fs(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t read_vda(struct file *file, struct kobject *kobj,
-			struct bin_attribute *attr,
+			const struct bin_attribute *attr,
 			char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -118,7 +118,7 @@ static ssize_t read_vda(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t write_vda(struct file *file, struct kobject *kobj,
-			 struct bin_attribute *attr,
+			 const struct bin_attribute *attr,
 			 char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -127,7 +127,7 @@ static ssize_t write_vda(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t read_live_nvram(struct file *file, struct kobject *kobj,
-			       struct bin_attribute *attr,
+			       const struct bin_attribute *attr,
 			       char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -138,7 +138,7 @@ static ssize_t read_live_nvram(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t write_live_nvram(struct file *file, struct kobject *kobj,
-				struct bin_attribute *attr,
+				const struct bin_attribute *attr,
 				char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -158,7 +158,7 @@ static ssize_t write_live_nvram(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t read_default_nvram(struct file *file, struct kobject *kobj,
-				  struct bin_attribute *attr,
+				  const struct bin_attribute *attr,
 				  char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -169,7 +169,7 @@ static ssize_t read_default_nvram(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t read_hw(struct file *file, struct kobject *kobj,
-		       struct bin_attribute *attr,
+		       const struct bin_attribute *attr,
 		       char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -187,7 +187,7 @@ static ssize_t read_hw(struct file *file, struct kobject *kobj,
 }
 
 static ssize_t write_hw(struct file *file, struct kobject *kobj,
-			struct bin_attribute *attr,
+			const struct bin_attribute *attr,
 			char *buf, loff_t off, size_t count)
 {
 	struct esas2r_adapter *a = esas2r_adapter_from_kobj(kobj);
@@ -211,12 +211,12 @@ static ssize_t write_hw(struct file *file, struct kobject *kobj,
 }
 
 #define ESAS2R_RW_BIN_ATTR(_name) \
-	struct bin_attribute bin_attr_ ## _name = { \
+	const struct bin_attribute bin_attr_ ## _name = { \
 		.attr	= \
 		{ .name = __stringify(_name), .mode  = S_IRUSR | S_IWUSR }, \
 		.size	= 0, \
-		.read	= read_ ## _name, \
-		.write	= write_ ## _name }
+		.read_new	= read_ ## _name, \
+		.write_new	= write_ ## _name }
 
 ESAS2R_RW_BIN_ATTR(fw);
 ESAS2R_RW_BIN_ATTR(fs);
@@ -224,10 +224,10 @@ ESAS2R_RW_BIN_ATTR(vda);
 ESAS2R_RW_BIN_ATTR(hw);
 ESAS2R_RW_BIN_ATTR(live_nvram);
 
-struct bin_attribute bin_attr_default_nvram = {
+const struct bin_attribute bin_attr_default_nvram = {
 	.attr	= { .name = "default_nvram", .mode = S_IRUGO },
 	.size	= 0,
-	.read	= read_default_nvram,
+	.read_new	= read_default_nvram,
 	.write	= NULL
 };
 

-- 
2.47.1

