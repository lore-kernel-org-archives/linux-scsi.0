Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEEC2040BC;
	Mon, 16 Dec 2024 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348558; cv=none; b=oPalmBz5liwS3oIMJy2gaHK3NXhHKBRZ+eII6D6bXyQjCve1NHHQtItysKV39aZB2z3gAWIsjDSh1yxIkg4LVKU441/AjJex6XlSR/vzRVSQAwI4rEyFsVRr+9Q6mA/O0kM/muyhRzBjBW7qfcdHfQHS7aW+9H/OytEgPd0yfac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348558; c=relaxed/simple;
	bh=W+0Z4QVsEE43bUpRexFCykIgMN9iO9eLgbxKoLARbqk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hxSJhoY8Sx1wIWkE8s0ek+Q/OPe2uDbytmbYXECNZL3NoywdHMHs9nplLCFWsR0eopobDcI5dk3XC0i57P6TlixcMUJ4NHwedGzwUkGRFrbW9s7OHHWa8Sj1g7DiKnkXzdj0EbUqYLvzHSpb4kGYxz15pR06JCGBwVKKWRjRc10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=ix4b7inj; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="ix4b7inj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348553;
	bh=W+0Z4QVsEE43bUpRexFCykIgMN9iO9eLgbxKoLARbqk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ix4b7injg+/iY+ZOZh+5gU5wmZFvPs6gnTB9UQENKl3DystMTzeSMrmyVUfkqAqg/
	 gZ69Cq9X70sGKHjvMImWM+Nj/LUWX2W19kcSZedUxWupGBepLGik2YAcO8dx7QU+ly
	 zQ8gb3MLOWd5WoYQf1/B4gj94nY1po/wDLkcIqpk=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Mon, 16 Dec 2024 12:29:13 +0100
Subject: [PATCH 06/11] scsi: lpfc: Constify 'struct bin_attribute'
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-6-f0a5e54b3437@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=2659;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=W+0Z4QVsEE43bUpRexFCykIgMN9iO9eLgbxKoLARbqk=;
 b=PvxT0Qpnkj49P3LHfPfXUCSjZE54BDHEBEjiOzke6/a3CdIzFNkyHoShGplVXsJePuSfUff3F
 dfoi0gw/LXlDRb6N4AsoA6trIQtSEUSLVm2LIqvPkYloF319CSfV2Bf
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/scsi/lpfc/lpfc_attr.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 39b504164ecc187d8b0798c95c9fa3f6bc9780e3..0d0213bba35da8e10be8b874763dd5f01d6ff586 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6185,7 +6185,7 @@ const struct attribute_group *lpfc_vport_groups[] = {
  **/
 static ssize_t
 sysfs_ctlreg_write(struct file *filp, struct kobject *kobj,
-		   struct bin_attribute *bin_attr,
+		   const struct bin_attribute *bin_attr,
 		   char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
@@ -6244,7 +6244,7 @@ sysfs_ctlreg_write(struct file *filp, struct kobject *kobj,
  **/
 static ssize_t
 sysfs_ctlreg_read(struct file *filp, struct kobject *kobj,
-		  struct bin_attribute *bin_attr,
+		  const struct bin_attribute *bin_attr,
 		  char *buf, loff_t off, size_t count)
 {
 	size_t buf_off;
@@ -6280,14 +6280,14 @@ sysfs_ctlreg_read(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static struct bin_attribute sysfs_ctlreg_attr = {
+static const struct bin_attribute sysfs_ctlreg_attr = {
 	.attr = {
 		.name = "ctlreg",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = 256,
-	.read = sysfs_ctlreg_read,
-	.write = sysfs_ctlreg_write,
+	.read_new = sysfs_ctlreg_read,
+	.write_new = sysfs_ctlreg_write,
 };
 
 /**
@@ -6308,7 +6308,7 @@ static struct bin_attribute sysfs_ctlreg_attr = {
  **/
 static ssize_t
 sysfs_mbox_write(struct file *filp, struct kobject *kobj,
-		 struct bin_attribute *bin_attr,
+		 const struct bin_attribute *bin_attr,
 		 char *buf, loff_t off, size_t count)
 {
 	return -EPERM;
@@ -6332,20 +6332,20 @@ sysfs_mbox_write(struct file *filp, struct kobject *kobj,
  **/
 static ssize_t
 sysfs_mbox_read(struct file *filp, struct kobject *kobj,
-		struct bin_attribute *bin_attr,
+		const struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
 {
 	return -EPERM;
 }
 
-static struct bin_attribute sysfs_mbox_attr = {
+static const struct bin_attribute sysfs_mbox_attr = {
 	.attr = {
 		.name = "mbox",
 		.mode = S_IRUSR | S_IWUSR,
 	},
 	.size = MAILBOX_SYSFS_MAX,
-	.read = sysfs_mbox_read,
-	.write = sysfs_mbox_write,
+	.read_new = sysfs_mbox_read,
+	.write_new = sysfs_mbox_write,
 };
 
 /**

-- 
2.47.1

